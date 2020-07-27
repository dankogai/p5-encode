#
# $Id: GSM0338.pm,v 2.8 2020/07/25 12:59:29 dankogai Exp dankogai $
#
package Encode::GSM0338::Charset::Spanish;

use strict;
use warnings;
use Carp;

use vars qw($VERSION);
$VERSION = do { my @r = ( q$Revision: 2.8 $ =~ /\d+/g ); sprintf "%d." . "%02d" x $#r, @r };

use parent 'Encode::GSM0338::Charset::Default';

use constant LATIN_CAPITAL_LETTER_A_WITH_ACUTE           => "\x{00C1}";
use constant LATIN_CAPITAL_LETTER_I_WITH_ACUTE           => "\x{00CD}";
use constant LATIN_CAPITAL_LETTER_O_WITH_ACUTE           => "\x{00D3}";
use constant LATIN_CAPITAL_LETTER_U_WITH_ACUTE           => "\x{00DA}";
use constant LATIN_SMALL_LETTER_A_WITH_ACUTE             => "\x{00E1}";
use constant LATIN_SMALL_LETTER_I_WITH_ACUTE             => "\x{00ED}";
use constant LATIN_SMALL_LETTER_O_WITH_ACUTE             => "\x{00F3}";
use constant LATIN_SMALL_LETTER_U_WITH_ACUTE             => "\x{00FA}";

sub GSM2UNI_BASIC_SET {
	Encode::GSM0338::Charset::Default->GSM2UNI_BASIC_SET;
}

sub GSM2UNI_SHIFT_SET {
	+{
		"\x1B\x09" => __PACKAGE__->LATIN_SMALL_LETTER_C_WITH_CEDILLA,
		"\x1B\x0A" => __PACKAGE__->FORM_FEED,
		"\x1B\x14" => __PACKAGE__->CIRCUMFLEX_ACCENT,
		"\x1B\x28" => __PACKAGE__->LEFT_CURLY_BRACKET,
		"\x1B\x29" => __PACKAGE__->RIGHT_CURLY_BRACKET,
		"\x1B\x2F" => __PACKAGE__->REVERSE_SOLIDUS,
		"\x1B\x3C" => __PACKAGE__->LEFT_SQUARE_BRACKET,
		"\x1B\x3D" => __PACKAGE__->TILDE,
		"\x1B\x3E" => __PACKAGE__->RIGHT_SQUARE_BRACKET,
		"\x1B\x40" => __PACKAGE__->VERTICAL_LINE,
		"\x1B\x41" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_ACUTE,
		"\x1B\x49" => __PACKAGE__->LATIN_CAPITAL_LETTER_I_WITH_ACUTE,
		"\x1B\x4F" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_ACUTE,
		"\x1B\x55" => __PACKAGE__->LATIN_CAPITAL_LETTER_U_WITH_ACUTE,
		"\x1B\x61" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_ACUTE,
		"\x1B\x69" => __PACKAGE__->LATIN_SMALL_LETTER_I_WITH_ACUTE,
		"\x1B\x65" => __PACKAGE__->EURO_SIGN,
		"\x1B\x6F" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_ACUTE,
		"\x1B\x75" => __PACKAGE__->LATIN_SMALL_LETTER_U_WITH_ACUTE,
	};
}

1;
