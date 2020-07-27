#
# $Id: GSM0338.pm,v 2.8 2020/07/25 12:59:29 dankogai Exp dankogai $
#
package Encode::GSM0338::Charset::Portuguese;

use strict;
use warnings;
use Carp;

use vars qw($VERSION);
$VERSION = do { my @r = ( q$Revision: 2.8 $ =~ /\d+/g ); sprintf "%d." . "%02d" x $#r, @r };

use parent 'Encode::GSM0338::Charset::Spanish';

use constant FEMININE_ORDINAL_INDICATOR                  => "\x{00AA}";
use constant GRAVE_ACCENT                                => "\x{0060}";
use constant INFINITY                                    => "\x{221E}";
use constant LATIN_CAPITAL_LETTER_A_WITH_CIRCUMFLEX      => "\x{00C2}";
use constant LATIN_CAPITAL_LETTER_A_WITH_GRAVE           => "\x{00C0}";
use constant LATIN_CAPITAL_LETTER_A_WITH_TILDE           => "\x{00C3}";
use constant LATIN_CAPITAL_LETTER_E_WITH_CIRCUMFLEX      => "\x{00CA}";
use constant LATIN_CAPITAL_LETTER_O_WITH_CIRCUMFLEX      => "\x{00D4}";
use constant LATIN_CAPITAL_LETTER_O_WITH_TILDE           => "\x{00D5}";
use constant LATIN_SMALL_LETTER_A_WITH_CIRCUMFLEX        => "\x{00E2}";
use constant LATIN_SMALL_LETTER_A_WITH_TILDE             => "\x{00E3}";
use constant LATIN_SMALL_LETTER_E_WITH_CIRCUMFLEX        => "\x{00EA}";
use constant LATIN_SMALL_LETTER_O_WITH_CIRCUMFLEX        => "\x{00F4}";
use constant LATIN_SMALL_LETTER_O_WITH_TILDE             => "\x{00F5}";
use constant MASCULINE_ORDINAL_INDICATOR                 => "\x{00BA}";

sub GSM2UNI_BASIC_SET {
	+{
		"\x00" => __PACKAGE__->COMMERCIAL_AT,
		"\x01" => __PACKAGE__->POUND_SIGN,
		"\x02" => __PACKAGE__->DOLLAR_SIGN,
		"\x03" => __PACKAGE__->YEN_SIGN,
		"\x04" => __PACKAGE__->LATIN_SMALL_LETTER_E_WITH_CIRCUMFLEX,
		"\x05" => __PACKAGE__->LATIN_SMALL_LETTER_E_WITH_ACUTE,
		"\x06" => __PACKAGE__->LATIN_SMALL_LETTER_U_WITH_ACUTE,
		"\x07" => __PACKAGE__->LATIN_SMALL_LETTER_I_WITH_ACUTE,
		"\x08" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_ACUTE,
		"\x09" => __PACKAGE__->LATIN_SMALL_LETTER_C_WITH_CEDILLA,
		"\x0A" => __PACKAGE__->LINE_FEED,
		"\x0B" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_CIRCUMFLEX,
		"\x0C" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_CIRCUMFLEX,
		"\x0D" => __PACKAGE__->CARRIAGE_RETURN,
		"\x0E" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_ACUTE,
		"\x0F" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_ACUTE,

		"\x10" => __PACKAGE__->GREEK_CAPITAL_LETTER_DELTA,
		"\x11" => __PACKAGE__->LOW_LINE,
		"\x12" => __PACKAGE__->FEMININE_ORDINAL_INDICATOR,
		"\x13" => __PACKAGE__->LATIN_CAPITAL_LETTER_C_WITH_CEDILLA,
		"\x14" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_GRAVE,
		"\x15" => __PACKAGE__->INFINITY,
		"\x16" => __PACKAGE__->CIRCUMFLEX_ACCENT,
		"\x17" => __PACKAGE__->REVERSE_SOLIDUS,
		"\x18" => __PACKAGE__->EURO_SIGN,
		"\x19" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_ACUTE,
		"\x1A" => __PACKAGE__->VERTICAL_LINE,
		"\x1C" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_CIRCUMFLEX,
		"\x1D" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_CIRCUMFLEX,
		"\x1E" => __PACKAGE__->LATIN_CAPITAL_LETTER_E_WITH_CIRCUMFLEX,
		"\x1F" => __PACKAGE__->LATIN_CAPITAL_LETTER_E_WITH_ACUTE,

		"\x20" => __PACKAGE__->SPACE,
		"\x21" => __PACKAGE__->EXCLAMATION_MARK,
		"\x22" => __PACKAGE__->QUOTATION_MARK,
		"\x23" => __PACKAGE__->NUMBER_SIGN,
		"\x24" => __PACKAGE__->MASCULINE_ORDINAL_INDICATOR,
		"\x25" => __PACKAGE__->PERCENT_SIGN,
		"\x26" => __PACKAGE__->AMPERSAND,
		"\x27" => __PACKAGE__->APOSTROPHE,
		"\x28" => __PACKAGE__->LEFT_PARENTHESIS,
		"\x29" => __PACKAGE__->RIGHT_PARENTHESIS,
		"\x2A" => __PACKAGE__->ASTERISK,
		"\x2B" => __PACKAGE__->PLUS_SIGN,
		"\x2C" => __PACKAGE__->COMMA,
		"\x2D" => __PACKAGE__->HYPHEN_MINUS,
		"\x2E" => __PACKAGE__->FULL_STOP,
		"\x2F" => __PACKAGE__->SOLIDUS,

		"\x30" => __PACKAGE__->DIGIT_ZERO,
		"\x31" => __PACKAGE__->DIGIT_ONE,
		"\x32" => __PACKAGE__->DIGIT_TWO,
		"\x33" => __PACKAGE__->DIGIT_THREE,
		"\x34" => __PACKAGE__->DIGIT_FOUR,
		"\x35" => __PACKAGE__->DIGIT_FIVE,
		"\x36" => __PACKAGE__->DIGIT_SIX,
		"\x37" => __PACKAGE__->DIGIT_SEVEN,
		"\x38" => __PACKAGE__->DIGIT_EIGHT,
		"\x39" => __PACKAGE__->DIGIT_NINE,
		"\x3A" => __PACKAGE__->COLON,
		"\x3B" => __PACKAGE__->SEMICOLON,
		"\x3C" => __PACKAGE__->LESS_THAN_SIGN,
		"\x3D" => __PACKAGE__->EQUALS_SIGN,
		"\x3E" => __PACKAGE__->GREATER_THAN_SIGN,
		"\x3F" => __PACKAGE__->QUESTION_MARK,

		"\x40" => __PACKAGE__->LATIN_CAPITAL_LETTER_I_WITH_ACUTE,
		"\x41" => __PACKAGE__->LATIN_CAPITAL_LETTER_A,
		"\x42" => __PACKAGE__->LATIN_CAPITAL_LETTER_B,
		"\x43" => __PACKAGE__->LATIN_CAPITAL_LETTER_C,
		"\x44" => __PACKAGE__->LATIN_CAPITAL_LETTER_D,
		"\x45" => __PACKAGE__->LATIN_CAPITAL_LETTER_E,
		"\x46" => __PACKAGE__->LATIN_CAPITAL_LETTER_F,
		"\x47" => __PACKAGE__->LATIN_CAPITAL_LETTER_G,
		"\x48" => __PACKAGE__->LATIN_CAPITAL_LETTER_H,
		"\x49" => __PACKAGE__->LATIN_CAPITAL_LETTER_I,
		"\x4A" => __PACKAGE__->LATIN_CAPITAL_LETTER_J,
		"\x4B" => __PACKAGE__->LATIN_CAPITAL_LETTER_K,
		"\x4C" => __PACKAGE__->LATIN_CAPITAL_LETTER_L,
		"\x4D" => __PACKAGE__->LATIN_CAPITAL_LETTER_M,
		"\x4E" => __PACKAGE__->LATIN_CAPITAL_LETTER_N,
		"\x4F" => __PACKAGE__->LATIN_CAPITAL_LETTER_O,

		"\x50" => __PACKAGE__->LATIN_CAPITAL_LETTER_P,
		"\x51" => __PACKAGE__->LATIN_CAPITAL_LETTER_Q,
		"\x52" => __PACKAGE__->LATIN_CAPITAL_LETTER_R,
		"\x53" => __PACKAGE__->LATIN_CAPITAL_LETTER_S,
		"\x54" => __PACKAGE__->LATIN_CAPITAL_LETTER_T,
		"\x55" => __PACKAGE__->LATIN_CAPITAL_LETTER_U,
		"\x56" => __PACKAGE__->LATIN_CAPITAL_LETTER_V,
		"\x57" => __PACKAGE__->LATIN_CAPITAL_LETTER_W,
		"\x58" => __PACKAGE__->LATIN_CAPITAL_LETTER_X,
		"\x59" => __PACKAGE__->LATIN_CAPITAL_LETTER_Y,
		"\x5A" => __PACKAGE__->LATIN_CAPITAL_LETTER_Z,
		"\x5B" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_TILDE,
		"\x5C" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_TILDE,
		"\x5D" => __PACKAGE__->LATIN_CAPITAL_LETTER_U_WITH_ACUTE,
		"\x5E" => __PACKAGE__->LATIN_CAPITAL_LETTER_U_WITH_DIAERESIS,
		"\x5F" => __PACKAGE__->SECTION_SIGN,

		"\x60" => __PACKAGE__->TILDE,
		"\x61" => __PACKAGE__->LATIN_SMALL_LETTER_A,
		"\x62" => __PACKAGE__->LATIN_SMALL_LETTER_B,
		"\x63" => __PACKAGE__->LATIN_SMALL_LETTER_C,
		"\x64" => __PACKAGE__->LATIN_SMALL_LETTER_D,
		"\x65" => __PACKAGE__->LATIN_SMALL_LETTER_E,
		"\x66" => __PACKAGE__->LATIN_SMALL_LETTER_F,
		"\x67" => __PACKAGE__->LATIN_SMALL_LETTER_G,
		"\x68" => __PACKAGE__->LATIN_SMALL_LETTER_H,
		"\x69" => __PACKAGE__->LATIN_SMALL_LETTER_I,
		"\x6A" => __PACKAGE__->LATIN_SMALL_LETTER_J,
		"\x6B" => __PACKAGE__->LATIN_SMALL_LETTER_K,
		"\x6C" => __PACKAGE__->LATIN_SMALL_LETTER_L,
		"\x6D" => __PACKAGE__->LATIN_SMALL_LETTER_M,
		"\x6E" => __PACKAGE__->LATIN_SMALL_LETTER_N,
		"\x6F" => __PACKAGE__->LATIN_SMALL_LETTER_O,

		"\x70" => __PACKAGE__->LATIN_SMALL_LETTER_P,
		"\x71" => __PACKAGE__->LATIN_SMALL_LETTER_Q,
		"\x72" => __PACKAGE__->LATIN_SMALL_LETTER_R,
		"\x73" => __PACKAGE__->LATIN_SMALL_LETTER_S,
		"\x74" => __PACKAGE__->LATIN_SMALL_LETTER_T,
		"\x75" => __PACKAGE__->LATIN_SMALL_LETTER_U,
		"\x76" => __PACKAGE__->LATIN_SMALL_LETTER_V,
		"\x77" => __PACKAGE__->LATIN_SMALL_LETTER_W,
		"\x78" => __PACKAGE__->LATIN_SMALL_LETTER_X,
		"\x79" => __PACKAGE__->LATIN_SMALL_LETTER_Y,
		"\x7A" => __PACKAGE__->LATIN_SMALL_LETTER_Z,
		"\x7B" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_TILDE,
		"\x7C" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_TILDE,
		"\x7D" => __PACKAGE__->GRAVE_ACCENT,
		"\x7E" => __PACKAGE__->LATIN_SMALL_LETTER_U_WITH_DIAERESIS,
		"\x7F" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_GRAVE,
	};
}

sub GSM2UNI_SHIFT_SET {
	+{
		"\x1B\x05" => __PACKAGE__->LATIN_SMALL_LETTER_E_WITH_CIRCUMFLEX,
		"\x1B\x09" => __PACKAGE__->LATIN_SMALL_LETTER_C_WITH_CEDILLA,
		"\x1B\x0A" => __PACKAGE__->FORM_FEED,
		"\x1B\x0B" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_CIRCUMFLEX,
		"\x1B\x0C" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_CIRCUMFLEX,
		"\x1B\x0E" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_ACUTE,
		"\x1B\x0F" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_ACUTE,

		"\x1B\x12" => __PACKAGE__->GREEK_CAPITAL_LETTER_PHI,
		"\x1B\x13" => __PACKAGE__->GREEK_CAPITAL_LETTER_GAMMA,
		"\x1B\x14" => __PACKAGE__->CIRCUMFLEX_ACCENT,
		"\x1B\x15" => __PACKAGE__->GREEK_CAPITAL_LETTER_OMEGA,
		"\x1B\x16" => __PACKAGE__->GREEK_CAPITAL_LETTER_PI,
		"\x1B\x17" => __PACKAGE__->GREEK_CAPITAL_LETTER_PSI,
		"\x1B\x18" => __PACKAGE__->GREEK_CAPITAL_LETTER_SIGMA,
		"\x1B\x19" => __PACKAGE__->GREEK_CAPITAL_LETTER_THETA,
		"\x1B\x1F" => __PACKAGE__->LATIN_CAPITAL_LETTER_E_WITH_CIRCUMFLEX,

		"\x1B\x28" => __PACKAGE__->LEFT_CURLY_BRACKET,
		"\x1B\x29" => __PACKAGE__->RIGHT_CURLY_BRACKET,
		"\x1B\x2F" => __PACKAGE__->REVERSE_SOLIDUS,

		"\x1B\x3C" => __PACKAGE__->LEFT_SQUARE_BRACKET,
		"\x1B\x3D" => __PACKAGE__->TILDE,
		"\x1B\x3E" => __PACKAGE__->RIGHT_SQUARE_BRACKET,

		"\x1B\x40" => __PACKAGE__->VERTICAL_LINE,
		"\x1B\x41" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_GRAVE,
		"\x1B\x49" => __PACKAGE__->LATIN_CAPITAL_LETTER_I_WITH_ACUTE,
		"\x1B\x4F" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_ACUTE,

		"\x1B\x55" => __PACKAGE__->LATIN_CAPITAL_LETTER_U_WITH_ACUTE,
		"\x1B\x5B" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_TILDE,
		"\x1B\x5C" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_TILDE,

		"\x1B\x61" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_CIRCUMFLEX,
		"\x1B\x65" => __PACKAGE__->EURO_SIGN,
		"\x1B\x69" => __PACKAGE__->LATIN_SMALL_LETTER_I_WITH_ACUTE,
		"\x1B\x6F" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_ACUTE,

		"\x1B\x75" => __PACKAGE__->LATIN_SMALL_LETTER_U_WITH_ACUTE,
		"\x1B\x7B" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_TILDE,
		"\x1B\x7C" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_TILDE,
		"\x1B\x7D" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_CIRCUMFLEX,
	};
}

1;
