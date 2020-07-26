#
# $Id: GSM0338.pm,v 2.8 2020/07/25 12:59:29 dankogai Exp dankogai $
#
package Encode::GSM0338;

use strict;
use warnings;
use Carp;

use vars qw($VERSION);
$VERSION = do { my @r = ( q$Revision: 2.8 $ =~ /\d+/g ); sprintf "%d." . "%02d" x $#r, @r };

use Encode qw(:fallbacks);

use parent qw(Encode::Encoding);
__PACKAGE__->Define('gsm0338');

sub needs_lines { 1 }
sub perlio_ok   { 0 }

use utf8;

# Mapping table according to 3GPP TS 23.038 version 16.0.0 Release 16 and ETSI TS 123 038 V16.0.0 (2020-07)
# https://www.etsi.org/deliver/etsi_ts/123000_123099/123038/16.00.00_60/ts_123038v160000p.pdf (page 20 and 22)
our %GSM2UNI_BASIC_SET_PLAIN = (
    "\x00" => "\x{0040}",        # COMMERCIAL AT
    "\x01" => "\x{00A3}",        # POUND SIGN
    "\x02" => "\x{0024}",        # DOLLAR SIGN
    "\x03" => "\x{00A5}",        # YEN SIGN
    "\x04" => "\x{00E8}",        # LATIN SMALL LETTER E WITH GRAVE
    "\x05" => "\x{00E9}",        # LATIN SMALL LETTER E WITH ACUTE
    "\x06" => "\x{00F9}",        # LATIN SMALL LETTER U WITH GRAVE
    "\x07" => "\x{00EC}",        # LATIN SMALL LETTER I WITH GRAVE
    "\x08" => "\x{00F2}",        # LATIN SMALL LETTER O WITH GRAVE
    "\x09" => "\x{00C7}",        # LATIN CAPITAL LETTER C WITH CEDILLA
    "\x0A" => "\x{000A}",        # LINE FEED
    "\x0B" => "\x{00D8}",        # LATIN CAPITAL LETTER O WITH STROKE
    "\x0C" => "\x{00F8}",        # LATIN SMALL LETTER O WITH STROKE
    "\x0D" => "\x{000D}",        # CARRIAGE RETURN
    "\x0E" => "\x{00C5}",        # LATIN CAPITAL LETTER A WITH RING ABOVE
    "\x0F" => "\x{00E5}",        # LATIN SMALL LETTER A WITH RING ABOVE
    "\x10" => "\x{0394}",        # GREEK CAPITAL LETTER DELTA
    "\x11" => "\x{005F}",        # LOW LINE
    "\x12" => "\x{03A6}",        # GREEK CAPITAL LETTER PHI
    "\x13" => "\x{0393}",        # GREEK CAPITAL LETTER GAMMA
    "\x14" => "\x{039B}",        # GREEK CAPITAL LETTER LAMDA
    "\x15" => "\x{03A9}",        # GREEK CAPITAL LETTER OMEGA
    "\x16" => "\x{03A0}",        # GREEK CAPITAL LETTER PI
    "\x17" => "\x{03A8}",        # GREEK CAPITAL LETTER PSI
    "\x18" => "\x{03A3}",        # GREEK CAPITAL LETTER SIGMA
    "\x19" => "\x{0398}",        # GREEK CAPITAL LETTER THETA
    "\x1A" => "\x{039E}",        # GREEK CAPITAL LETTER XI
    "\x1C" => "\x{00C6}",        # LATIN CAPITAL LETTER AE
    "\x1D" => "\x{00E6}",        # LATIN SMALL LETTER AE
    "\x1E" => "\x{00DF}",        # LATIN SMALL LETTER SHARP S
    "\x1F" => "\x{00C9}",        # LATIN CAPITAL LETTER E WITH ACUTE
    "\x20" => "\x{0020}",        # SPACE
    "\x21" => "\x{0021}",        # EXCLAMATION MARK
    "\x22" => "\x{0022}",        # QUOTATION MARK
    "\x23" => "\x{0023}",        # NUMBER SIGN
    "\x24" => "\x{00A4}",        # CURRENCY SIGN
    "\x25" => "\x{0025}",        # PERCENT SIGN
    "\x26" => "\x{0026}",        # AMPERSAND
    "\x27" => "\x{0027}",        # APOSTROPHE
    "\x28" => "\x{0028}",        # LEFT PARENTHESIS
    "\x29" => "\x{0029}",        # RIGHT PARENTHESIS
    "\x2A" => "\x{002A}",        # ASTERISK
    "\x2B" => "\x{002B}",        # PLUS SIGN
    "\x2C" => "\x{002C}",        # COMMA
    "\x2D" => "\x{002D}",        # HYPHEN-MINUS
    "\x2E" => "\x{002E}",        # FULL STOP
    "\x2F" => "\x{002F}",        # SOLIDUS
    "\x30" => "\x{0030}",        # DIGIT ZERO
    "\x31" => "\x{0031}",        # DIGIT ONE
    "\x32" => "\x{0032}",        # DIGIT TWO
    "\x33" => "\x{0033}",        # DIGIT THREE
    "\x34" => "\x{0034}",        # DIGIT FOUR
    "\x35" => "\x{0035}",        # DIGIT FIVE
    "\x36" => "\x{0036}",        # DIGIT SIX
    "\x37" => "\x{0037}",        # DIGIT SEVEN
    "\x38" => "\x{0038}",        # DIGIT EIGHT
    "\x39" => "\x{0039}",        # DIGIT NINE
    "\x3A" => "\x{003A}",        # COLON
    "\x3B" => "\x{003B}",        # SEMICOLON
    "\x3C" => "\x{003C}",        # LESS-THAN SIGN
    "\x3D" => "\x{003D}",        # EQUALS SIGN
    "\x3E" => "\x{003E}",        # GREATER-THAN SIGN
    "\x3F" => "\x{003F}",        # QUESTION MARK
    "\x40" => "\x{00A1}",        # INVERTED EXCLAMATION MARK
    "\x41" => "\x{0041}",        # LATIN CAPITAL LETTER A
    "\x42" => "\x{0042}",        # LATIN CAPITAL LETTER B
    "\x43" => "\x{0043}",        # LATIN CAPITAL LETTER C
    "\x44" => "\x{0044}",        # LATIN CAPITAL LETTER D
    "\x45" => "\x{0045}",        # LATIN CAPITAL LETTER E
    "\x46" => "\x{0046}",        # LATIN CAPITAL LETTER F
    "\x47" => "\x{0047}",        # LATIN CAPITAL LETTER G
    "\x48" => "\x{0048}",        # LATIN CAPITAL LETTER H
    "\x49" => "\x{0049}",        # LATIN CAPITAL LETTER I
    "\x4A" => "\x{004A}",        # LATIN CAPITAL LETTER J
    "\x4B" => "\x{004B}",        # LATIN CAPITAL LETTER K
    "\x4C" => "\x{004C}",        # LATIN CAPITAL LETTER L
    "\x4D" => "\x{004D}",        # LATIN CAPITAL LETTER M
    "\x4E" => "\x{004E}",        # LATIN CAPITAL LETTER N
    "\x4F" => "\x{004F}",        # LATIN CAPITAL LETTER O
    "\x50" => "\x{0050}",        # LATIN CAPITAL LETTER P
    "\x51" => "\x{0051}",        # LATIN CAPITAL LETTER Q
    "\x52" => "\x{0052}",        # LATIN CAPITAL LETTER R
    "\x53" => "\x{0053}",        # LATIN CAPITAL LETTER S
    "\x54" => "\x{0054}",        # LATIN CAPITAL LETTER T
    "\x55" => "\x{0055}",        # LATIN CAPITAL LETTER U
    "\x56" => "\x{0056}",        # LATIN CAPITAL LETTER V
    "\x57" => "\x{0057}",        # LATIN CAPITAL LETTER W
    "\x58" => "\x{0058}",        # LATIN CAPITAL LETTER X
    "\x59" => "\x{0059}",        # LATIN CAPITAL LETTER Y
    "\x5A" => "\x{005A}",        # LATIN CAPITAL LETTER Z
    "\x5B" => "\x{00C4}",        # LATIN CAPITAL LETTER A WITH DIAERESIS
    "\x5C" => "\x{00D6}",        # LATIN CAPITAL LETTER O WITH DIAERESIS
    "\x5D" => "\x{00D1}",        # LATIN CAPITAL LETTER N WITH TILDE
    "\x5E" => "\x{00DC}",        # LATIN CAPITAL LETTER U WITH DIAERESIS
    "\x5F" => "\x{00A7}",        # SECTION SIGN
    "\x60" => "\x{00BF}",        # INVERTED QUESTION MARK
    "\x61" => "\x{0061}",        # LATIN SMALL LETTER A
    "\x62" => "\x{0062}",        # LATIN SMALL LETTER B
    "\x63" => "\x{0063}",        # LATIN SMALL LETTER C
    "\x64" => "\x{0064}",        # LATIN SMALL LETTER D
    "\x65" => "\x{0065}",        # LATIN SMALL LETTER E
    "\x66" => "\x{0066}",        # LATIN SMALL LETTER F
    "\x67" => "\x{0067}",        # LATIN SMALL LETTER G
    "\x68" => "\x{0068}",        # LATIN SMALL LETTER H
    "\x69" => "\x{0069}",        # LATIN SMALL LETTER I
    "\x6A" => "\x{006A}",        # LATIN SMALL LETTER J
    "\x6B" => "\x{006B}",        # LATIN SMALL LETTER K
    "\x6C" => "\x{006C}",        # LATIN SMALL LETTER L
    "\x6D" => "\x{006D}",        # LATIN SMALL LETTER M
    "\x6E" => "\x{006E}",        # LATIN SMALL LETTER N
    "\x6F" => "\x{006F}",        # LATIN SMALL LETTER O
    "\x70" => "\x{0070}",        # LATIN SMALL LETTER P
    "\x71" => "\x{0071}",        # LATIN SMALL LETTER Q
    "\x72" => "\x{0072}",        # LATIN SMALL LETTER R
    "\x73" => "\x{0073}",        # LATIN SMALL LETTER S
    "\x74" => "\x{0074}",        # LATIN SMALL LETTER T
    "\x75" => "\x{0075}",        # LATIN SMALL LETTER U
    "\x76" => "\x{0076}",        # LATIN SMALL LETTER V
    "\x77" => "\x{0077}",        # LATIN SMALL LETTER W
    "\x78" => "\x{0078}",        # LATIN SMALL LETTER X
    "\x79" => "\x{0079}",        # LATIN SMALL LETTER Y
    "\x7A" => "\x{007A}",        # LATIN SMALL LETTER Z
    "\x7B" => "\x{00E4}",        # LATIN SMALL LETTER A WITH DIAERESIS
    "\x7C" => "\x{00F6}",        # LATIN SMALL LETTER O WITH DIAERESIS
    "\x7D" => "\x{00F1}",        # LATIN SMALL LETTER N WITH TILDE
    "\x7E" => "\x{00FC}",        # LATIN SMALL LETTER U WITH DIAERESIS
    "\x7F" => "\x{00E0}",        # LATIN SMALL LETTER A WITH GRAVE
);

our %GSM2UNI_BASIC_SET = (
	plain => \%GSM2UNI_BASIC_SET_PLAIN,
);

our %GSM2UNI_SHIFT_SET = (
	plain => {
		"\x1B\x0A" => "\x{000C}",    # FORM FEED
		"\x1B\x14" => "\x{005E}",    # CIRCUMFLEX ACCENT
		"\x1B\x28" => "\x{007B}",    # LEFT CURLY BRACKET
		"\x1B\x29" => "\x{007D}",    # RIGHT CURLY BRACKET
		"\x1B\x2F" => "\x{005C}",    # REVERSE SOLIDUS
		"\x1B\x3C" => "\x{005B}",    # LEFT SQUARE BRACKET
		"\x1B\x3D" => "\x{007E}",    # TILDE
		"\x1B\x3E" => "\x{005D}",    # RIGHT SQUARE BRACKET
		"\x1B\x40" => "\x{007C}",    # VERTICAL LINE
		"\x1B\x65" => "\x{20AC}",    # EURO SIGN
	},
);

our %UNI2GSM_BASIC_SET = (
	plain => { reverse %{ $GSM2UNI_BASIC_SET{plain} } },
);

our %UNI2GSM_SHIFT_SET = (
	plain => { reverse %{ $GSM2UNI_SHIFT_SET{plain} } },
);

our $ESC    = "\x1b";

sub basic_set {
	$_[0]->{basic_set} ||= 'plain';
}

sub shift_set {
	$_[0]->{shift_set} ||= 'plain';
}

sub gsm2uni {
	my ($self) = @_;

	$self->{gsm2uni} ||= do {
		my $basic_set = $GSM2UNI_BASIC_SET{ $self->basic_set };
		my $shift_set = $GSM2UNI_SHIFT_SET{ $self->shift_set };

		+{ %$basic_set, %$shift_set };
	};
}

sub uni2gsm {
	my ($self) = @_;

	$self->{uni2gsm} ||= do {
		my $basic_set = $UNI2GSM_BASIC_SET{ $self->basic_set };
		my $shift_set = $UNI2GSM_SHIFT_SET{ $self->shift_set };

		+{ %$basic_set, %$shift_set };
	};
}

sub decode ($$;$) {
    my ( $obj, $bytes, $chk ) = @_;
    return undef unless defined $bytes;

	my $gsm2uni = $obj->gsm2uni;

    my $str = substr($bytes, 0, 0); # to propagate taintedness;
    while ( length $bytes ) {
        my $seq = '';
        my $c;
        do {
            $c = substr( $bytes, 0, 1, '' );
            $seq .= $c;
        } while ( length $bytes and $c eq $ESC );
        my $u =
            exists $gsm2uni->{$seq}
            ? $gsm2uni->{$seq}
            : ($chk && ref $chk eq 'CODE')
            ? $chk->( unpack 'C*', $seq )
            : "\x{FFFD}";
        if ( not exists $gsm2uni->{$seq} and $chk and not ref $chk ) {
            croak join( '', map { sprintf "\\x%02X", $_ } unpack 'C*', $seq ) . ' does not map to Unicode' if $chk & Encode::DIE_ON_ERR;
            carp join( '', map { sprintf "\\x%02X", $_ } unpack 'C*', $seq ) . ' does not map to Unicode' if $chk & Encode::WARN_ON_ERR;
            if ($chk & Encode::RETURN_ON_ERR) {
                $bytes .= $seq;
                last;
            }
        }
        $str .= $u;
    }
    $_[1] = $bytes if not ref $chk and $chk and !($chk & Encode::LEAVE_SRC);
    return $str;
}

sub encode($$;$) {
    my ( $obj, $str, $chk ) = @_;
    return undef unless defined $str;

	my $uni2gsm = $obj->uni2gsm;

    my $bytes = substr($str, 0, 0); # to propagate taintedness
    while ( length $str ) {
        my $u = substr( $str, 0, 1, '' );
        my $c;
        my $seq =
            exists $uni2gsm->{$u}
            ? $uni2gsm->{$u}
            : ($chk && ref $chk eq 'CODE')
            ? $chk->( ord($u) )
            : $uni2gsm->{'?'};
        if ( not exists $uni2gsm->{$u} and $chk and not ref $chk ) {
            croak sprintf( "\\x{%04x} does not map to %s", ord($u), $obj->name ) if $chk & Encode::DIE_ON_ERR;
            carp sprintf( "\\x{%04x} does not map to %s", ord($u), $obj->name ) if $chk & Encode::WARN_ON_ERR;
            if ($chk & Encode::RETURN_ON_ERR) {
                $str .= $u;
                last;
            }
        }
        $bytes .= $seq;
    }
    $_[1] = $str if not ref $chk and $chk and !($chk & Encode::LEAVE_SRC);
    return $bytes;
}

1;
__END__

=head1 NAME

Encode::GSM0338 -- ETSI GSM 03.38 Encoding

=head1 SYNOPSIS

  use Encode qw/encode decode/;
  $gsm0338 = encode("gsm0338", $unicode); # loads Encode::GSM0338 implicitly
  $unicode = decode("gsm0338", $gsm0338); # ditto

=head1 DESCRIPTION

GSM0338 is for GSM handsets. Though it shares alphanumerals with ASCII,
control character ranges and other parts are mapped very differently,
mainly to store Greek characters.  There are also escape sequences
(starting with 0x1B) to cover e.g. the Euro sign.

This was once handled by L<Encode::Bytes> but because of all those
unusual specifications, Encode 2.20 has relocated the support to
this module.

This module implements only I<GSM 7 bit Default Alphabet> and
I<GSM 7 bit default alphabet extension table> according to standard
3GPP TS 23.038 version 16. Therefore I<National Language Single Shift>
and I<National Language Locking Shift> are not implemented nor supported.

=head2 Septets

This modules operates with octets (like any other Encode module) and not
with packed septets (unlike other GSM standards). Therefore for processing
binary SMS or parts of GSM TPDU payload (3GPP TS 23.040) it is needed to do
conversion between octets and packed septets. For this purpose perl's C<pack>
and C<unpack> functions may be useful:

  $bytes = substr(pack('(b*)*', unpack '(A7)*', unpack 'b*', $septets), 0, $num_of_septets);
  $unicode = decode('GSM0338', $bytes);

  $bytes = encode('GSM0338', $unicode);
  $septets = pack 'b*', join '', map { substr $_, 0, 7 } unpack '(A8)*', unpack 'b*', $bytes;
  $num_of_septets = length $bytes;

Please note that for correct decoding of packed septets it is required to
know number of septets packed in binary buffer as binary buffer is always
padded with zero bits and 7 zero bits represents character C<@>. Number
of septets is also stored in TPDU payload when dealing with 3GPP TS 23.040.

=head1 BUGS

Encode::GSM0338 2.7 and older versions (part of Encode 3.06) incorrectly
handled zero bytes (character C<@>). This was fixed in Encode::GSM0338
version 2.8 (part of Encode 3.07).

=head1 SEE ALSO

L<3GPP TS 23.038|https://www.3gpp.org/dynareport/23038.htm>

L<ETSI TS 123 038 V16.0.0 (2020-07)|https://www.etsi.org/deliver/etsi_ts/123000_123099/123038/16.00.00_60/ts_123038v160000p.pdf>

L<Encode>

=cut
