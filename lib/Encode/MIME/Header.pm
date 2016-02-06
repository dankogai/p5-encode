package Encode::MIME::Header;
use strict;
use warnings;
no warnings 'redefine';

our $VERSION = do { my @r = ( q$Revision: 2.20 $ =~ /\d+/g ); sprintf "%d." . "%02d" x $#r, @r };
use Encode qw(find_encoding encode_utf8 decode_utf8);
use MIME::Base64;
use Carp;

my %seed = (
    decode_b => '1',    # decodes 'B' encoding ?
    decode_q => '1',    # decodes 'Q' encoding ?
    encode   => 'B',    # encode with 'B' or 'Q' ?
    bpl      => 75,     # bytes per line
);

$Encode::Encoding{'MIME-Header'} =
  bless { %seed, Name => 'MIME-Header', } => __PACKAGE__;

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
my $re_encoded_text = qr/[^\?\s]*/;
my $re_encoded_word = qr/=\?$re_charset(?:\*$re_language)?\?$re_encoding\?$re_encoded_text\?=/;
my $re_capture_encoded_word = qr/=\?($re_charset)((?:\*$re_language)?)\?($re_encoding)\?($re_encoded_text)\?=/;

sub decode($$;$) {
    use utf8;
    my ( $obj, $str, $chk ) = @_;

    # zap spaces between encoded words
    1 while $str =~ s/($re_encoded_word)\s+($re_encoded_word)/$1$2/gos;

    # multi-line header to single line
    $str =~ s/(?:\r\n|[\r\n])([ \t])/$1/gos;

    # concat consecutive encoded mime words with same charset, language and encoding
    # fixes breaking inside multi-byte characters
    1 while $str =~ s/$re_capture_encoded_word=\?\1\2\?\3\?($re_encoded_text)\?=/=\?$1$2\?$3\?$4$5\?=/o;

    $str =~ s{$re_capture_encoded_word}{
        if      (uc($3) eq 'B'){
            $obj->{decode_b} or croak qq(MIME "B" unsupported);
            decode_b($1, $4, $chk);
        } elsif (uc($3) eq 'Q'){
            $obj->{decode_q} or croak qq(MIME "Q" unsupported);
            decode_q($1, $4, $chk);
        } else {
            croak qq(MIME "$3" encoding is nonexistent!);
        }
    }egox;
    $_[1] = $str if $chk;
    return $str;
}

sub decode_b {
    my $enc  = shift;
    my $d    = find_encoding($enc) or croak qq(Unknown encoding "$enc");
    my $db64 = decode_base64(shift);
    my $chk  = shift;
    return $d->name eq 'utf8'
      ? Encode::decode_utf8($db64)
      : $d->decode( $db64, $chk || Encode::FB_PERLQQ );
}

sub decode_q {
    my ( $enc, $q, $chk ) = @_;
    my $d = find_encoding($enc) or croak qq(Unknown encoding "$enc");
    $q =~ s/_/ /go;
    $q =~ s/=([0-9A-Fa-f]{2})/pack("C", hex($1))/ego;
    return $d->name eq 'utf8'
      ? Encode::decode_utf8($q)
      : $d->decode( $q, $chk || Encode::FB_PERLQQ );
}

sub encode($$;$) {
    my ( $obj, $str, $chk ) = @_;

    my @input = split /(\r\n|\r|\n)/o, $str;
    my $output = substr($str, 0, 0); # to propagate taintedness

    while ( @input ) {
        my $line = shift @input;
        my $sep = shift @input;
        my $encoded = _encode_line($line, $obj);
        $output .= _fold_line($encoded, $obj);
        $output .= $sep if defined $sep;
    }

    return $output;
}

sub _fold_line {
    my ($line, $obj) = @_;
    my $bpl = $obj->{bpl};
    my $output = '';

    while ( length $line ) {
        if ( $line =~ s/^(.{0,$bpl})(\s|\z)// ) {
            $output .= $1;
            $output .= "\r\n" . $2 if length $line;
        } elsif ( $line =~ s/(\s)(.*)$// ) {
            $output .= $line;
            $line = $2;
            $output .= "\r\n" . $1 if length $line;
        } else {
            $output .= $line;
            last;
        }
    }

    return $output;
}

sub _encode_line {
    my ($line, $obj) = @_;
    my $bpl = $obj->{bpl};
    my $output = '';

    # try to detect header name and do not encode it
    # needed for backward compatibility...
    my $header_length = 0;
    if ( $line =~ s/^([A-Za-z-]+:[ \t]+)//o ) {
        $output .= $1;
        $header_length = length($1);
    }

    my $safe_chars = q=!#$%&'*+,-./0-9:;A-Z[\\]^_`a-z{|}~=;
    my $re_comment = qr/\([$safe_chars <>@]{1,$bpl}\)/;
    my $re_addr = qr/[$safe_chars]{1,$bpl}\@[$safe_chars]{1,$bpl}/;
    my $re_angle_addr = qr/<$re_addr>/;
    my $re_not_encode = qr/(?:[ \t]+|\A)(?:$re_comment|$re_addr|$re_angle_addr)(?:[ \t]+|\z)/;

    # try to detect substrings which looks like comment or email address and do not encode them if it is possible
    # needed for backward compatibility but still should generate valid and correct mixed MIME encoded string
    while ( $line =~ s/($re_not_encode)(.*)//o ) {
        $output .= $obj->_encode($line, $header_length) if length $line;
        $output .= $1;
        $line = $2;
        $header_length = 0 if $header_length;
    }

    $output .= $obj->_encode($line, $header_length) if length $line;

    return $output;
}

use constant HEAD   => '=?UTF-8?';
use constant TAIL   => '?=';
use constant SINGLE => { B => \&_encode_b, Q => \&_encode_q, };

sub _encode {
    my ( $o, $str, $skip ) = @_;
    my $enc  = $o->{encode};
    my $llen = ( $o->{bpl} - length(HEAD) - 2 - length(TAIL) );

    # to coerce a floating-point arithmetics, the following contains
    # .0 in numbers -- dankogai
    my $skip_llen = ( $llen - $skip ) * ( $enc eq 'B' ? 3.0 / 4.0 : 1.0 / 3.0 );
    $llen *= $enc eq 'B' ? 3.0 / 4.0 : 1.0 / 3.0;
    my @result = ();
    my $chunk  = '';
    while ( length( my $chr = substr( $str, 0, 1, '' ) ) ) {
        use bytes ();
        if ( bytes::length($chunk) + bytes::length($chr) > ( @result ? $llen : $skip_llen ) ) {
            push @result, SINGLE->{$enc}($chunk);
            $chunk = '';
        }
        $chunk .= $chr;
    }
    length($chunk) and push @result, SINGLE->{$enc}($chunk);
    return join(' ', @result);
}

sub _encode_b {
    HEAD . 'B?' . encode_base64( encode_utf8(shift), '' ) . TAIL;
}

sub _encode_q {
    my $chunk = shift;
    $chunk = encode_utf8($chunk);
    $chunk =~ s{
	   ([^0-9A-Za-z])
       }{
            join("" => map {sprintf "=%02X", $_} unpack("C*", $1))
       }egox;
    return HEAD . 'Q?' . $chunk . TAIL;
}

1;
__END__

=head1 NAME

Encode::MIME::Header -- MIME 'B' and 'Q' header encoding

=head1 SYNOPSIS

    use Encode qw/encode decode/;
    $utf8   = decode('MIME-Header', $header);
    $header = encode('MIME-Header', $utf8);

=head1 ABSTRACT

This module implements RFC 2047 Mime Header Encoding.  There are 3
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

Before version 2.81 this module had broken both decoder and encoder.
It caused that module inserted additional spaces and produced invalid
MIME encoded strings. Decoder lot of times discarded white space
characters, incorrectly interpreted data or decoded Base64 string as
Quoted-Printable.

As of version 2.81 encoder should be fully compliant of RFC 2047.
Due to bugs in previous versions decoder is less strict and allows
to decode also incorrectly encoded strings by previous versions of
this module. But decoded strings will be slightly different.

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
