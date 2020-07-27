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

use Exporter 5.57 'import';

our @EXPORT_OK = ('gsm0338');

sub needs_lines { 1 }
sub perlio_ok   { 0 }

use utf8;

use Encode::GSM0338::Charset::Default;
use Encode::GSM0338::Charset::Turkish;
use Encode::GSM0338::Charset::Spanish;
use Encode::GSM0338::Charset::Portuguese;

# Mapping table according to 3GPP TS 23.038 version 16.0.0 Release 16 and ETSI TS 123 038 V16.0.0 (2020-07)
# https://www.etsi.org/deliver/etsi_ts/123000_123099/123038/16.00.00_60/ts_123038v160000p.pdf (page 20 and 22)
our %LANGUAGE_MAP = (
	gsm => 'Encode::GSM0338::Charset::Default',
	tr  => 'Encode::GSM0338::Charset::Turkish',
	es  => 'Encode::GSM0338::Charset::Spanish',
	pt  => 'Encode::GSM0338::Charset::Portuguese',
);

our $ESC    = "\x1b";

sub gsm0338 {
	my (%params) = @_;

	for my $set (qw[ basic shift ]) {
		$params{$set} = delete $params{"${set}_set"} if defined $params{"${set}_set"};
		$params{$set} = 'gsm' unless defined $params{$set};
		$params{$set} = 'gsm' if $params{$set} eq 'default';
	}

	my $basic_set = $params{basic};
	my $shift_set = $params{shift};

	my $encoding = "gsm0338:${basic_set}:${shift_set}";

	return 'gsm0338' if $encoding eq 'gsm0338:gsm:gsm';

	die "Unknown basic set $basic_set" unless exists $LANGUAGE_MAP{$basic_set};
	die "Unknown shift set $shift_set" unless exists $LANGUAGE_MAP{$shift_set};

	unless (Encode->getEncoding ($encoding)) {
		my $instance = bless {
			Name => $encoding,
			basic_set => $basic_set,
			shift_set => $shift_set,
		}, __PACKAGE__;

		$instance->Define ($encoding);
	}

	return $encoding;
}

sub basic_set {
	$_[0]->{basic_set} ||= 'gsm';
}

sub shift_set {
	$_[0]->{shift_set} ||= 'gsm';
}

sub gsm2uni {
	my ($self) = @_;

	$self->{gsm2uni} ||= do {
		my $basic_set = $LANGUAGE_MAP{ $self->basic_set }->GSM2UNI_BASIC_SET;
		my $shift_set = $LANGUAGE_MAP{ $self->shift_set }->GSM2UNI_SHIFT_SET;

		+{ %$shift_set, %$basic_set };
	};
}

sub uni2gsm {
	my ($self) = @_;

	$self->{uni2gsm} ||= do {
		my $basic_set = $LANGUAGE_MAP{ $self->basic_set }->UNI2GSM_BASIC_SET;
		my $shift_set = $LANGUAGE_MAP{ $self->shift_set }->UNI2GSM_SHIFT_SET;

		# if same char is included in both sets, prefer basic
		+{ %$shift_set, %$basic_set };
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
