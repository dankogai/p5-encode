package Encode::MIME::Header;
use strict;
use warnings;

our $VERSION = do { my @r = ( q$Revision: 2.23 $ =~ /\d+/g ); sprintf "%d." . "%02d" x $#r, @r };

use Carp ();
use Encode ();
use MIME::Base64 ();

my %seed = (
    decode_b => 1,       # decodes 'B' encoding ?
    decode_q => 1,       # decodes 'Q' encoding ?
    encode   => 'B',     # encode with 'B' or 'Q' ?
    charset  => 'UTF-8', # encode charset
    bpl      => 75,      # bytes per line
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
my $re_charset = qr/[!"#\$%&'+\-0-9A-Z\\\^_`a-z\{\|\}~]+/;
my $re_language = qr/[A-Za-z]{1,8}(?:-[0-9A-Za-z]{1,8})*/;
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

my $re_newline = qr/(?:\r\n|[\r\n])/;

# in strict mode encoded words must be always separated by spaces or tabs (or folded newline)
# except in comments when separator between words and comment round brackets can be omitted
my $re_word_begin_strict = qr/(?:(?:[ \t]|\A)\(?|(?:[^\\]|\A)\)\()/;
my $re_word_sep_strict = qr/(?:$re_newline?[ \t])+/;
my $re_word_end_strict = qr/(?:\)\(|\)?(?:$re_newline?[ \t]|\z))/;

my $re_match = qr/()((?:$re_encoded_word\s*)*$re_encoded_word)()/;
my $re_match_strict = qr/($re_word_begin_strict)((?:$re_encoded_word_strict$re_word_sep_strict)*$re_encoded_word_strict)(?=$re_word_end_strict)/;

my $re_capture = qr/$re_capture_encoded_word(?:\s*)?/;
my $re_capture_strict = qr/$re_capture_encoded_word_strict$re_word_sep_strict?/;

our $STRICT_DECODE = 0;

sub decode($$;$) {
    my ($obj, $str, $chk) = @_;

    my $re_match_decode = $STRICT_DECODE ? $re_match_strict : $re_match;
    my $re_capture_decode = $STRICT_DECODE ? $re_capture_strict : $re_capture;

    my $stop = 0;
    my $output = substr($str, 0, 0); # to propagate taintedness

    # decode each line separately, match whole continuous folded line at one call
    1 while not $stop and $str =~ s{^((?:[^\r\n]*(?:$re_newline[ \t])?)*)($re_newline)?}{

        my $line = $1;
        my $sep = defined $2 ? $2 : '';

        $stop = 1 unless length($line) or length($sep);

        # NOTE: this code partially could break $chk support
        # in non strict mode concat consecutive encoded mime words with same charset, language and encoding
        # fixes breaking inside multi-byte characters
        1 while not $STRICT_DECODE and $line =~ s/$re_capture_encoded_word_split\s*=\?\1\2\?\3\?($re_encoded_text)\?=/=\?$1$2\?$3\?$4$5\?=/so;

        # process sequence of encoded MIME words at once
        1 while not $stop and $line =~ s{^(.*?)$re_match_decode}{

            my $begin = $1 . $2;
            my $words = $3;

            $begin =~ tr/\r\n//d;
            $output .= $begin;

            # decode one MIME word
            1 while not $stop and $words =~ s{^(.*?)($re_capture_decode)}{

                $output .= $1;
                my $orig = $2;
                my $charset = $3;
                my ($mime_enc, $text) = split /\?/, $5;

                $text =~ tr/\r\n//d;

                my $enc = Encode::find_mime_encoding($charset);

                # in non strict mode allow also perl encoding aliases
                if ( not defined $enc and not $STRICT_DECODE ) {
                    # make sure that decoded string will be always strict UTF-8
                    $charset = 'UTF-8' if lc($charset) eq 'utf8';
                    $enc = Encode::find_encoding($charset);
                }

                if ( not defined $enc ) {
                    Carp::croak qq(Unknown charset "$charset") if not ref $chk and $chk & Encode::DIE_ON_ERR;
                    Carp::carp qq(Unknown charset "$charset") if not ref $chk and $chk & Encode::WARN_ON_ERR;
                    $stop = 1 if not ref $chk and $chk & Encode::RETURN_ON_ERR;
                    $output .= ($output =~ /(?:\A|[ \t])$/ ? '' : ' ') . $orig unless $stop; # $orig mime word is separated by whitespace
                    $stop ? $orig : '';
                } else {
                    if ( uc($mime_enc) eq 'B' and $obj->{decode_b} ) {
                        my $decoded = _decode_b($enc, $text, $chk);
                        $stop = 1 if not defined $decoded and not ref $chk and $chk & Encode::RETURN_ON_ERR;
                        $output .= (defined $decoded ? $decoded : $text) unless $stop;
                        $stop ? $orig : '';
                    } elsif ( uc($mime_enc) eq 'Q' and $obj->{decode_q} ) {
                        my $decoded = _decode_q($enc, $text, $chk);
                        $stop = 1 if not defined $decoded and not ref $chk and $chk & Encode::RETURN_ON_ERR;
                        $output .= (defined $decoded ? $decoded : $text) unless $stop;
                        $stop ? $orig : '';
                    } else {
                        Carp::croak qq(MIME "$mime_enc" unsupported) if not ref $chk and $chk & Encode::DIE_ON_ERR;
                        Carp::carp qq(MIME "$mime_enc" unsupported) if not ref $chk and $chk & Encode::WARN_ON_ERR;
                        $stop = 1 if not ref $chk and $chk & Encode::RETURN_ON_ERR;
                        $output .= ($output =~ /(?:\A|[ \t])$/ ? '' : ' ') . $orig unless $stop; # $orig mime word is separated by whitespace
                        $stop ? $orig : '';
                    }
                }

            }se;

            if ( not $stop ) {
                $output .= $words;
                $words = '';
            }

            $words;

        }se;

        if ( not $stop ) {
            $line =~ tr/\r\n//d;
            $output .= $line . $sep;
            $line = '';
            $sep = '';
        }

        $line . $sep;

    }se;

    $_[1] = $str if not ref $chk and $chk and !($chk & Encode::LEAVE_SRC);
    return $output;
}

sub _decode_b {
    my ($enc, $b, $chk) = @_;
    # MIME::Base64::decode ignores everything after a '=' padding character
    # in non strict mode split string after each sequence of padding characters and decode each substring
    my $db64 = $STRICT_DECODE ?
        MIME::Base64::decode($b) :
        join('', map { MIME::Base64::decode($_) } split /(?<==)(?=[^=])/, $b);
    return _decode_enc($enc, $db64, $chk);
}

sub _decode_q {
    my ($enc, $q, $chk) = @_;
    $q =~ s/_/ /go;
    $q =~ s/=([0-9A-Fa-f]{2})/pack('C', hex($1))/ego;
    return _decode_enc($enc, $q, $chk);
}

sub _decode_enc {
    my ($enc, $str, $chk) = @_;
    $chk &= ~Encode::LEAVE_SRC if not ref $chk and $chk;
    local $Carp::CarpLevel = $Carp::CarpLevel + 1; # propagate Carp messages back to caller
    my $output = $enc->decode($str, $chk);
    return undef if not ref $chk and $chk and $str ne '';
    return $output;
}

sub encode($$;$) {
    my ($obj, $str, $chk) = @_;
    my $output = $obj->_fold_line($obj->_encode_line($str, $chk));
    $_[1] = $str if not ref $chk and $chk and !($chk & Encode::LEAVE_SRC);
    return $output . substr($str, 0, 0); # to propagate taintedness
}

sub _fold_line {
    my ($obj, $line) = @_;
    my $bpl = $obj->{bpl};
    my $output = '';

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

sub _encode_line {
    my ($obj, $str, $chk) = @_;
    my $llen = $obj->{bpl};
    my $enc = Encode::find_mime_encoding($obj->{charset});
    my $enc_chk = (not ref $chk and $chk) ? ($chk | Encode::LEAVE_SRC) : $chk;
    my @result = ();
    my $chunk = '';
    while ( length( my $chr = substr($str, 0, 1, '') ) ) {
        my $seq;
        {
            local $Carp::CarpLevel = $Carp::CarpLevel + 1; # propagate Carp messages back to caller
            $seq = $enc->encode($chr, $enc_chk);
        }
        if ( not length($seq) ) {
            substr($str, 0, 0, $chr);
            last;
        }
        if ( $obj->_encode_str_len($chunk . $seq) > $llen ) {
            push @result, $obj->_encode_str($chunk);
            $chunk = '';
        }
        $chunk .= $seq;
    }
    length($chunk) and push @result, $obj->_encode_str($chunk);
    $_[1] = $str if not ref $chk and $chk and !($chk & Encode::LEAVE_SRC);
    return join(' ', @result);
}

sub _encode_str {
    my ($obj, $chunk) = @_;
    my $charset = $obj->{charset};
    my $encode = $obj->{encode};
    my $text = $encode eq 'B' ? _encode_b($chunk) : _encode_q($chunk);
    return "=?$charset?$encode?$text?=";
}

sub _encode_str_len {
    my ($obj, $chunk) = @_;
    my $charset = $obj->{charset};
    my $encode = $obj->{encode};
    my $text_len = $encode eq 'B' ? _encode_b_len($chunk) : _encode_q_len($chunk);
    return length("=?$charset?$encode??=") + $text_len;
}

sub _encode_b {
    my ($chunk) = @_;
    return MIME::Base64::encode($chunk, '');
}

sub _encode_b_len {
    my ($chunk) = @_;
    return ( length($chunk) + 2 ) / 3 * 4;
}

my $re_invalid_q_char = qr/[^0-9A-Za-z !*+\-\/]/;

sub _encode_q {
    my ($chunk) = @_;
    $chunk =~ s{($re_invalid_q_char)}{
        join('', map { sprintf('=%02X', $_) } unpack('C*', $1))
    }egox;
    $chunk =~ s/ /_/go;
    return $chunk;
}

sub _encode_q_len {
    my ($chunk) = @_;
    my $invalid_count = () = $chunk =~ /$re_invalid_q_char/sgo;
    return ( $invalid_count * 3 ) + ( length($chunk) - $invalid_count );
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

=head1 AUTHORS

Pali E<lt>pali@cpan.orgE<gt>

=head1 SEE ALSO

L<Encode>

RFC 2047, L<http://www.faqs.org/rfcs/rfc2047.html> and many other
locations.

=cut
