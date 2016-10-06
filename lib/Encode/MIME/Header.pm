package Encode::MIME::Header;
use strict;
use warnings;

our $VERSION = do { my @r = ( q$Revision: 2.23 $ =~ /\d+/g ); sprintf "%d." . "%02d" x $#r, @r };

use Carp ();
use Encode ();
use MIME::Base64 ();

my %seed = (
    decode_b => 1,      # decodes 'B' encoding ?
    decode_q => 1,      # decodes 'Q' encoding ?
    encode   => 'B',    # encode with 'B' or 'Q' ?
    bpl      => 75,     # bytes per line
);

$Encode::Encoding{'MIME-Header'} = bless {
    %seed,
    Name     => 'MIME-Header',
} => __PACKAGE__;

$Encode::Encoding{'MIME-B'} = bless {
    %seed,
    decode_q => 0,
    Name     => 'MIME-B',
} => __PACKAGE__;

$Encode::Encoding{'MIME-Q'} = bless {
    %seed,
    decode_b => 0,
    encode   => 'Q',
    Name     => 'MIME-Q',
} => __PACKAGE__;

use parent qw(Encode::Encoding);

sub needs_lines { 1 }
sub perlio_ok   { 0 }

# RFC 2047 and RFC 2231 grammar
my $re_charset = qr/[-0-9A-Za-z_]+/;
my $re_language = qr/[A-Za-z]{1,8}(?:-[A-Za-z]{1,8})*/;
my $re_encoding = qr/[QqBb]/;
my $re_encoded_text = qr/[^\?]*/;
my $re_encoded_word = qr/=\?$re_charset(?:\*$re_language)?\?$re_encoding\?$re_encoded_text\?=/;
my $re_capture_encoded_word = qr/=\?($re_charset)((?:\*$re_language)?)\?($re_encoding\?$re_encoded_text)\?=/;
my $re_capture_encoded_word_split = qr/=\?($re_charset)((?:\*$re_language)?)\?($re_encoding)\?($re_encoded_text)\?=/;

# in strict mode check also for valid base64 characters and also for valid quoted printable codes
my $re_encoding_strict_b = qr/[Bb]/;
my $re_encoding_strict_q = qr/[Qq]/;
my $re_encoded_text_strict_b = qr/[0-9A-Za-z\+\/]*={0,2}/;
my $re_encoded_text_strict_q = qr/(?:[^\?\s=]|=[0-9A-Fa-f]{2})*/;
my $re_encoded_word_strict = qr/=\?$re_charset(?:\*$re_language)?\?(?:$re_encoding_strict_b\?$re_encoded_text_strict_b|$re_encoding_strict_q\?$re_encoded_text_strict_q)\?=/;
my $re_capture_encoded_word_strict = qr/=\?($re_charset)((?:\*$re_language)?)\?($re_encoding_strict_b\?$re_encoded_text_strict_b|$re_encoding_strict_q\?$re_encoded_text_strict_q)\?=/;

# in strict mode encoded words must be always separated by spaces or tabs
# except in comments when separator between words and comment round brackets can be omitted
my $re_word_begin_strict = qr/(?:[ \t\n]|\A)\(?/;
my $re_word_sep_strict = qr/[ \t]+/;
my $re_word_end_strict = qr/\)?(?:[ \t\n]|\z)/;

my $re_match = qr/()((?:$re_encoded_word\s*)*$re_encoded_word)()/;
my $re_match_strict = qr/($re_word_begin_strict)((?:$re_encoded_word_strict$re_word_sep_strict)*$re_encoded_word_strict)(?=$re_word_end_strict)/;

my $re_capture = qr/$re_capture_encoded_word(?:\s*)?/;
my $re_capture_strict = qr/$re_capture_encoded_word_strict$re_word_sep_strict?/;

our $STRICT_DECODE = 0;

sub decode($$;$) {
    my ($obj, $str, $chk) = @_;

    my $re_match_decode = $STRICT_DECODE ? $re_match_strict : $re_match;
    my $re_capture_decode = $STRICT_DECODE ? $re_capture_strict : $re_capture;

    # multi-line header to single line
    $str =~ s/(?:\r\n|[\r\n])([ \t])/$1/gos;

    # decode each line separately
    my @input = split /(\r\n|\r|\n)/o, $str, -1;
    my $output = substr($str, 0, 0); # to propagate taintedness

    while ( @input ) {

        my $line = shift @input;
        my $sep = shift @input;

        # in non strict mode concat consecutive encoded mime words with same charset, language and encoding
        # fixes breaking inside multi-byte characters
        1 while not $STRICT_DECODE and $line =~ s/$re_capture_encoded_word_split\s*=\?\1\2\?\3\?($re_encoded_text)\?=/=\?$1$2\?$3\?$4$5\?=/o;

        $line =~ s{$re_match_decode}{
            my $begin = $1;
            my $words = $2;
            $words =~ s{$re_capture_decode}{
                my $charset = $1;
                my ($mime_enc, $text) = split /\?/, $3;
                my $enc = Encode::find_mime_encoding($charset);
                # in non strict mode allow also perl encoding aliases
                if ( not defined $enc and not $STRICT_DECODE ) {
                    # make sure that decoded string will be always strict UTF-8
                    $charset = 'UTF-8' if lc($charset) eq 'utf8';
                    $enc = Encode::find_encoding($charset);
                }
                Carp::croak qq(Unknown charset "$charset") unless defined $enc;
                if ( uc($mime_enc) eq 'B' ) {
                    $obj->{decode_b} or Carp::croak qq(MIME "B" unsupported);
                    decode_b($enc, $text, $chk);
                } else {
                    $obj->{decode_q} or Carp::croak qq(MIME "Q" unsupported);
                    decode_q($enc, $text, $chk);
                }
            }eg;
            $begin . $words;
        }eg;

        $output .= $line;
        $output .= $sep if defined $sep;

    }

    $_[1] = '' if $chk; # empty the input string in the stack so perlio is ok
    return $output;
}

sub decode_b {
    my ($enc, $b, $chk) = @_;
    # MIME::Base64::decode ignores everything after a '=' padding character
    # in non strict mode split string after each sequence of padding characters and decode each substring
    my $db64 = $STRICT_DECODE ?
        MIME::Base64::decode($b) :
        join('', map { MIME::Base64::decode($_) } split /(?<==)(?=[^=])/, $b);
    return $enc->decode($db64, $chk);
}

sub decode_q {
    my ($enc, $q, $chk) = @_;
    $q =~ s/_/ /go;
    $q =~ s/=([0-9A-Fa-f]{2})/pack('C', hex($1))/ego;
    return $enc->decode($q, $chk);
}

sub encode($$;$) {
    my ($obj, $str, $chk) = @_;
    my $output = $obj->_fold_line($obj->_encode_line($str, $chk));
    $_[1] = $str if not ref $chk and $chk and !($chk & Encode::LEAVE_SRC);
    return $output;
}

sub _fold_line {
    my ($obj, $line) = @_;
    my $bpl = $obj->{bpl};
    my $output = substr($line, 0, 0); # to propagate taintedness

    while ( length($line) ) {
        if ( $line =~ s/^(.{0,$bpl})(\s|\z)// ) {
            $output .= $1;
            $output .= "\r\n" . $2 if length($line);
        } elsif ( $line =~ s/(\s)(.*)$// ) {
            $output .= $line;
            $line = $2;
            $output .= "\r\n" . $1 if length($line);
        } else {
            $output .= $line;
            last;
        }
    }

    return $output;
}

use constant HEAD   => '=?UTF-8?';
use constant TAIL   => '?=';
use constant SINGLE => { B => \&_encode_b, Q => \&_encode_q, B_len => \&_encode_b_len, Q_len => \&_encode_q_len };

sub _encode_line {
    my ($obj, $str, $chk) = @_;
    my $enc = $obj->{encode};
    my $enc_len = $enc . '_len';
    my $llen = $obj->{bpl};
    my $enc_utf8 = Encode::find_mime_encoding('UTF-8');
    my $enc_chk = (not ref $chk and $chk) ? ($chk | Encode::LEAVE_SRC) : $chk;
    my @result = ();
    my $chunk = '';
    while ( length( my $chr = substr($str, 0, 1, '') ) ) {
        my $seq;
        {
            local $Carp::CarpLevel = $Carp::CarpLevel + 1; # propagate Carp messages back to caller
            $seq = $enc_utf8->encode($chr, $chk);
        }
        if ( not length($seq) ) {
            substr($str, 0, 0, $chr);
            last;
        }
        if ( SINGLE->{$enc_len}($chunk . $seq) > $llen ) {
            push @result, SINGLE->{$enc}($chunk);
            $chunk = '';
        }
        $chunk .= $seq;
    }
    length($chunk) and push @result, SINGLE->{$enc}($chunk);
    $_[1] = $str if not ref $chk and $chk and !($chk & Encode::LEAVE_SRC);
    return join(' ', @result);
}

sub _encode_b {
    my ($chunk) = @_;
    return HEAD . 'B?' . MIME::Base64::encode($chunk, '') . TAIL;
}

sub _encode_b_len {
    my ($chunk) = @_;
    return length(HEAD . 'B?' . TAIL) + ( length($chunk) + 2 ) / 3 * 4;
}

my $re_invalid_q_char = qr/[^0-9A-Za-z !*+\-\/]/;

sub _encode_q {
    my ($chunk) = @_;
    $chunk =~ s{($re_invalid_q_char)}{
        join('', map { sprintf('=%02X', $_) } unpack('C*', $1))
    }egox;
    $chunk =~ s/ /_/go;
    return HEAD . 'Q?' . $chunk . TAIL;
}

sub _encode_q_len {
    my ($chunk) = @_;
    my $invalid_count = () = $chunk =~ /$re_invalid_q_char/sgo;
    return length(HEAD . 'Q?' . TAIL) + ( $invalid_count * 3 ) + ( length($chunk) - $invalid_count );
}

1;
__END__

=head1 NAME

Encode::MIME::Header -- MIME 'B' and 'Q' encoding for unstructured header

=head1 SYNOPSIS

    use Encode qw/encode decode/;
    $utf8   = decode('MIME-Header', $header);
    $header = encode('MIME-Header', $utf8);

=head1 ABSTRACT

This module implements RFC 2047 MIME encoding for unstructured header.
It cannot be used for structured headers like From or To.  There are 3
variant encoding names; C<MIME-Header>, C<MIME-B> and C<MIME-Q>.  The
difference is described below

              decode()          encode()
  ----------------------------------------------
  MIME-Header Both B and Q      =?UTF-8?B?....?=
  MIME-B      B only; Q croaks  =?UTF-8?B?....?=
  MIME-Q      Q only; B croaks  =?UTF-8?Q?....?=

=head1 DESCRIPTION

When you decode(=?I<encoding>?I<X>?I<ENCODED WORD>?=), I<ENCODED WORD>
is extracted and decoded for I<X> encoding (B for Base64, Q for
Quoted-Printable). Then the decoded chunk is fed to
decode(I<encoding>).  So long as I<encoding> is supported by Encode,
any source encoding is fine.

When you encode, it just encodes UTF-8 string with I<X> encoding then
quoted with =?UTF-8?I<X>?....?= .  The parts that RFC 2047 forbids to
encode are left as is and long lines are folded within 76 bytes per
line.

=head1 BUGS

Before version 2.83 this module had broken both decoder and encoder.
Encoder inserted additional spaces, incorrectly encoded input data
and produced invalid MIME strings. Decoder lot of times discarded
white space characters, incorrectly interpreted data or decoded
Base64 string as Quoted-Printable.

As of version 2.83 encoder should be fully compliant of RFC 2047.
Due to bugs in previous versions of encoder, decoder is by default in
less strict compatible mode. It should be able to decode strings
encoded by pre 2.83 version of this module. But this default mode is
not correct according to RFC 2047.

In default mode decoder try to decode every substring which looks like
MIME encoded data. So it means that MIME data does not need to be
separated by white space. To enforce correct strict mode, set package
variable $Encode::MIME::Header::STRICT_DECODE to 1, e.g. by localizing:

C<require Encode::MIME::Header; local $Encode::MIME::Header::STRICT_DECODE = 1;>

It would be nice to support encoding to non-UTF8, such as =?ISO-2022-JP?
and =?ISO-8859-1?= but that makes the implementation too complicated.
These days major mail agents all support =?UTF-8? so I think it is
just good enough.

Due to popular demand, 'MIME-Header-ISO_2022_JP' was introduced by
Makamaka.  Thre are still too many MUAs especially cellular phone
handsets which does not grok UTF-8.

=head1 SEE ALSO

L<Encode>

RFC 2047, L<http://www.faqs.org/rfcs/rfc2047.html> and many other
locations.

=cut
