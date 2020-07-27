#
# $Id: GSM0338.pm,v 2.8 2020/07/25 12:59:29 dankogai Exp dankogai $
#
package Encode::GSM0338::Charset::Default;

use strict;
use warnings;
use Carp;

use vars qw($VERSION);
$VERSION = do { my @r = ( q$Revision: 2.8 $ =~ /\d+/g ); sprintf "%d." . "%02d" x $#r, @r };

use constant AMPERSAND                                   => "\x{0026}";
use constant APOSTROPHE                                  => "\x{0027}";
use constant ASTERISK                                    => "\x{002A}";
use constant CARRIAGE_RETURN                             => "\x{000D}";
use constant COLON                                       => "\x{003A}";
use constant COMMA                                       => "\x{002C}";
use constant COMMERCIAL_AT                               => "\x{0040}";
use constant CURRENCY_SIGN                               => "\x{00A4}";
use constant DIGIT_EIGHT                                 => "\x{0038}";
use constant DIGIT_FIVE                                  => "\x{0035}";
use constant DIGIT_FOUR                                  => "\x{0034}";
use constant DIGIT_NINE                                  => "\x{0039}";
use constant DIGIT_ONE                                   => "\x{0031}";
use constant DIGIT_SEVEN                                 => "\x{0037}";
use constant DIGIT_SIX                                   => "\x{0036}";
use constant DIGIT_THREE                                 => "\x{0033}";
use constant DIGIT_TWO                                   => "\x{0032}";
use constant DIGIT_ZERO                                  => "\x{0030}";
use constant DOLLAR_SIGN                                 => "\x{0024}";
use constant EQUALS_SIGN                                 => "\x{003D}";
use constant EXCLAMATION_MARK                            => "\x{0021}";
use constant FULL_STOP                                   => "\x{002E}";
use constant GREATER_THAN_SIGN                           => "\x{003E}";
use constant GREEK_CAPITAL_LETTER_DELTA                  => "\x{0394}";
use constant GREEK_CAPITAL_LETTER_GAMMA                  => "\x{0393}";
use constant GREEK_CAPITAL_LETTER_LAMDA                  => "\x{039B}";
use constant GREEK_CAPITAL_LETTER_OMEGA                  => "\x{03A9}";
use constant GREEK_CAPITAL_LETTER_PHI                    => "\x{03A6}";
use constant GREEK_CAPITAL_LETTER_PI                     => "\x{03A0}";
use constant GREEK_CAPITAL_LETTER_PSI                    => "\x{03A8}";
use constant GREEK_CAPITAL_LETTER_SIGMA                  => "\x{03A3}";
use constant GREEK_CAPITAL_LETTER_THETA                  => "\x{0398}";
use constant GREEK_CAPITAL_LETTER_XI                     => "\x{039E}";
use constant HYPHEN_MINUS                                => "\x{002D}";
use constant INVERTED_EXCLAMATION_MARK                   => "\x{00A1}";
use constant INVERTED_QUESTION_MARK                      => "\x{00BF}";
use constant CIRCUMFLEX_ACCENT                           => "\x{005E}";
use constant EURO_SIGN                                   => "\x{20AC}";
use constant FORM_FEED                                   => "\x{000C}";
use constant LATIN_CAPITAL_LETTER_A                      => "\x{0041}";
use constant LATIN_CAPITAL_LETTER_AE                     => "\x{00C6}";
use constant LATIN_CAPITAL_LETTER_A_WITH_DIAERESIS       => "\x{00C4}";
use constant LATIN_CAPITAL_LETTER_A_WITH_RING_ABOVE      => "\x{00C5}";
use constant LATIN_CAPITAL_LETTER_B                      => "\x{0042}";
use constant LATIN_CAPITAL_LETTER_C                      => "\x{0043}";
use constant LATIN_CAPITAL_LETTER_C_WITH_CEDILLA         => "\x{00C7}";
use constant LATIN_CAPITAL_LETTER_D                      => "\x{0044}";
use constant LATIN_CAPITAL_LETTER_E                      => "\x{0045}";
use constant LATIN_CAPITAL_LETTER_E_WITH_ACUTE           => "\x{00C9}";
use constant LATIN_CAPITAL_LETTER_F                      => "\x{0046}";
use constant LATIN_CAPITAL_LETTER_G                      => "\x{0047}";
use constant LATIN_CAPITAL_LETTER_H                      => "\x{0048}";
use constant LATIN_CAPITAL_LETTER_I                      => "\x{0049}";
use constant LATIN_CAPITAL_LETTER_J                      => "\x{004A}";
use constant LATIN_CAPITAL_LETTER_K                      => "\x{004B}";
use constant LATIN_CAPITAL_LETTER_L                      => "\x{004C}";
use constant LATIN_CAPITAL_LETTER_M                      => "\x{004D}";
use constant LATIN_CAPITAL_LETTER_N                      => "\x{004E}";
use constant LATIN_CAPITAL_LETTER_N_WITH_TILDE           => "\x{00D1}";
use constant LATIN_CAPITAL_LETTER_O                      => "\x{004F}";
use constant LATIN_CAPITAL_LETTER_O_WITH_DIAERESIS       => "\x{00D6}";
use constant LATIN_CAPITAL_LETTER_O_WITH_STROKE          => "\x{00D8}";
use constant LATIN_CAPITAL_LETTER_P                      => "\x{0050}";
use constant LATIN_CAPITAL_LETTER_Q                      => "\x{0051}";
use constant LATIN_CAPITAL_LETTER_R                      => "\x{0052}";
use constant LATIN_CAPITAL_LETTER_S                      => "\x{0053}";
use constant LATIN_CAPITAL_LETTER_T                      => "\x{0054}";
use constant LATIN_CAPITAL_LETTER_U                      => "\x{0055}";
use constant LATIN_CAPITAL_LETTER_U_WITH_DIAERESIS       => "\x{00DC}";
use constant LATIN_CAPITAL_LETTER_V                      => "\x{0056}";
use constant LATIN_CAPITAL_LETTER_W                      => "\x{0057}";
use constant LATIN_CAPITAL_LETTER_X                      => "\x{0058}";
use constant LATIN_CAPITAL_LETTER_Y                      => "\x{0059}";
use constant LATIN_CAPITAL_LETTER_Z                      => "\x{005A}";
use constant LATIN_SMALL_LETTER_A                        => "\x{0061}";
use constant LATIN_SMALL_LETTER_AE                       => "\x{00E6}";
use constant LATIN_SMALL_LETTER_A_WITH_DIAERESIS         => "\x{00E4}";
use constant LATIN_SMALL_LETTER_A_WITH_GRAVE             => "\x{00E0}";
use constant LATIN_SMALL_LETTER_A_WITH_RING_ABOVE        => "\x{00E5}";
use constant LATIN_SMALL_LETTER_B                        => "\x{0062}";
use constant LATIN_SMALL_LETTER_C                        => "\x{0063}";
use constant LATIN_SMALL_LETTER_C_WITH_CEDILLA           => "\x{00E7}";
use constant LATIN_SMALL_LETTER_D                        => "\x{0064}";
use constant LATIN_SMALL_LETTER_E                        => "\x{0065}";
use constant LATIN_SMALL_LETTER_E_WITH_ACUTE             => "\x{00E9}";
use constant LATIN_SMALL_LETTER_E_WITH_GRAVE             => "\x{00E8}";
use constant LATIN_SMALL_LETTER_F                        => "\x{0066}";
use constant LATIN_SMALL_LETTER_G                        => "\x{0067}";
use constant LATIN_SMALL_LETTER_H                        => "\x{0068}";
use constant LATIN_SMALL_LETTER_I                        => "\x{0069}";
use constant LATIN_SMALL_LETTER_I_WITH_GRAVE             => "\x{00EC}";
use constant LATIN_SMALL_LETTER_J                        => "\x{006A}";
use constant LATIN_SMALL_LETTER_K                        => "\x{006B}";
use constant LATIN_SMALL_LETTER_L                        => "\x{006C}";
use constant LATIN_SMALL_LETTER_M                        => "\x{006D}";
use constant LATIN_SMALL_LETTER_N                        => "\x{006E}";
use constant LATIN_SMALL_LETTER_N_WITH_TILDE             => "\x{00F1}";
use constant LATIN_SMALL_LETTER_O                        => "\x{006F}";
use constant LATIN_SMALL_LETTER_O_WITH_DIAERESIS         => "\x{00F6}";
use constant LATIN_SMALL_LETTER_O_WITH_GRAVE             => "\x{00F2}";
use constant LATIN_SMALL_LETTER_O_WITH_STROKE            => "\x{00F8}";
use constant LATIN_SMALL_LETTER_P                        => "\x{0070}";
use constant LATIN_SMALL_LETTER_Q                        => "\x{0071}";
use constant LATIN_SMALL_LETTER_R                        => "\x{0072}";
use constant LATIN_SMALL_LETTER_S                        => "\x{0073}";
use constant LATIN_SMALL_LETTER_SHARP_S                  => "\x{00DF}";
use constant LATIN_SMALL_LETTER_T                        => "\x{0074}";
use constant LATIN_SMALL_LETTER_U                        => "\x{0075}";
use constant LATIN_SMALL_LETTER_U_WITH_DIAERESIS         => "\x{00FC}";
use constant LATIN_SMALL_LETTER_U_WITH_GRAVE             => "\x{00F9}";
use constant LATIN_SMALL_LETTER_V                        => "\x{0076}";
use constant LATIN_SMALL_LETTER_W                        => "\x{0077}";
use constant LATIN_SMALL_LETTER_X                        => "\x{0078}";
use constant LATIN_SMALL_LETTER_Y                        => "\x{0079}";
use constant LATIN_SMALL_LETTER_Z                        => "\x{007A}";
use constant LEFT_CURLY_BRACKET                          => "\x{007B}";
use constant LEFT_PARENTHESIS                            => "\x{0028}";
use constant LEFT_SQUARE_BRACKET                         => "\x{005B}";
use constant LESS_THAN_SIGN                              => "\x{003C}";
use constant LINE_FEED                                   => "\x{000A}";
use constant LOW_LINE                                    => "\x{005F}";
use constant NUMBER_SIGN                                 => "\x{0023}";
use constant PERCENT_SIGN                                => "\x{0025}";
use constant PLUS_SIGN                                   => "\x{002B}";
use constant POUND_SIGN                                  => "\x{00A3}";
use constant QUESTION_MARK                               => "\x{003F}";
use constant QUOTATION_MARK                              => "\x{0022}";
use constant REVERSE_SOLIDUS                             => "\x{005C}";
use constant RIGHT_CURLY_BRACKET                         => "\x{007D}";
use constant RIGHT_PARENTHESIS                           => "\x{0029}";
use constant RIGHT_SQUARE_BRACKET                        => "\x{005D}";
use constant SECTION_SIGN                                => "\x{00A7}";
use constant SEMICOLON                                   => "\x{003B}";
use constant SOLIDUS                                     => "\x{002F}";
use constant SPACE                                       => "\x{0020}";
use constant TILDE                                       => "\x{007E}";
use constant VERTICAL_LINE                               => "\x{007C}";
use constant YEN_SIGN                                    => "\x{00A5}";

sub GSM2UNI_BASIC_SET {
	+{
		"\x00" => __PACKAGE__->COMMERCIAL_AT,
		"\x01" => __PACKAGE__->POUND_SIGN,
		"\x02" => __PACKAGE__->DOLLAR_SIGN,
		"\x03" => __PACKAGE__->YEN_SIGN,
		"\x04" => __PACKAGE__->LATIN_SMALL_LETTER_E_WITH_GRAVE,
		"\x05" => __PACKAGE__->LATIN_SMALL_LETTER_E_WITH_ACUTE,
		"\x06" => __PACKAGE__->LATIN_SMALL_LETTER_U_WITH_GRAVE,
		"\x07" => __PACKAGE__->LATIN_SMALL_LETTER_I_WITH_GRAVE,
		"\x08" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_GRAVE,
		"\x09" => __PACKAGE__->LATIN_CAPITAL_LETTER_C_WITH_CEDILLA,
		"\x0A" => __PACKAGE__->LINE_FEED,
		"\x0B" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_STROKE,
		"\x0C" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_STROKE,
		"\x0D" => __PACKAGE__->CARRIAGE_RETURN,
		"\x0E" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_RING_ABOVE,
		"\x0F" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_RING_ABOVE,

		"\x10" => __PACKAGE__->GREEK_CAPITAL_LETTER_DELTA,
		"\x11" => __PACKAGE__->LOW_LINE,
		"\x12" => __PACKAGE__->GREEK_CAPITAL_LETTER_PHI,
		"\x13" => __PACKAGE__->GREEK_CAPITAL_LETTER_GAMMA,
		"\x14" => __PACKAGE__->GREEK_CAPITAL_LETTER_LAMDA,
		"\x15" => __PACKAGE__->GREEK_CAPITAL_LETTER_OMEGA,
		"\x16" => __PACKAGE__->GREEK_CAPITAL_LETTER_PI,
		"\x17" => __PACKAGE__->GREEK_CAPITAL_LETTER_PSI,
		"\x18" => __PACKAGE__->GREEK_CAPITAL_LETTER_SIGMA,
		"\x19" => __PACKAGE__->GREEK_CAPITAL_LETTER_THETA,
		"\x1A" => __PACKAGE__->GREEK_CAPITAL_LETTER_XI,
		"\x1C" => __PACKAGE__->LATIN_CAPITAL_LETTER_AE,
		"\x1D" => __PACKAGE__->LATIN_SMALL_LETTER_AE,
		"\x1E" => __PACKAGE__->LATIN_SMALL_LETTER_SHARP_S,
		"\x1F" => __PACKAGE__->LATIN_CAPITAL_LETTER_E_WITH_ACUTE,

		"\x20" => __PACKAGE__->SPACE,
		"\x21" => __PACKAGE__->EXCLAMATION_MARK,
		"\x22" => __PACKAGE__->QUOTATION_MARK,
		"\x23" => __PACKAGE__->NUMBER_SIGN,
		"\x24" => __PACKAGE__->CURRENCY_SIGN,
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

		"\x40" => __PACKAGE__->INVERTED_EXCLAMATION_MARK,
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
		"\x5B" => __PACKAGE__->LATIN_CAPITAL_LETTER_A_WITH_DIAERESIS,
		"\x5C" => __PACKAGE__->LATIN_CAPITAL_LETTER_O_WITH_DIAERESIS,
		"\x5D" => __PACKAGE__->LATIN_CAPITAL_LETTER_N_WITH_TILDE,
		"\x5E" => __PACKAGE__->LATIN_CAPITAL_LETTER_U_WITH_DIAERESIS,
		"\x5F" => __PACKAGE__->SECTION_SIGN,

		"\x60" => __PACKAGE__->INVERTED_QUESTION_MARK,
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
		"\x7B" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_DIAERESIS,
		"\x7C" => __PACKAGE__->LATIN_SMALL_LETTER_O_WITH_DIAERESIS,
		"\x7D" => __PACKAGE__->LATIN_SMALL_LETTER_N_WITH_TILDE,
		"\x7E" => __PACKAGE__->LATIN_SMALL_LETTER_U_WITH_DIAERESIS,
		"\x7F" => __PACKAGE__->LATIN_SMALL_LETTER_A_WITH_GRAVE,
	};
}

sub GSM2UNI_SHIFT_SET {
	+{
		"\x1B\x0A" => __PACKAGE__->FORM_FEED,
		"\x1B\x14" => __PACKAGE__->CIRCUMFLEX_ACCENT,
		"\x1B\x28" => __PACKAGE__->LEFT_CURLY_BRACKET,
		"\x1B\x29" => __PACKAGE__->RIGHT_CURLY_BRACKET,
		"\x1B\x2F" => __PACKAGE__->REVERSE_SOLIDUS,
		"\x1B\x3C" => __PACKAGE__->LEFT_SQUARE_BRACKET,
		"\x1B\x3D" => __PACKAGE__->TILDE,
		"\x1B\x3E" => __PACKAGE__->RIGHT_SQUARE_BRACKET,
		"\x1B\x40" => __PACKAGE__->VERTICAL_LINE,
		"\x1B\x65" => __PACKAGE__->EURO_SIGN,
	};
}

sub UNI2GSM_BASIC_SET {
	+{
		reverse %{ $_[0]->GSM2UNI_BASIC_SET },
	};
}

sub UNI2GSM_SHIFT_SET {
	+{
		reverse %{ $_[0]->GSM2UNI_SHIFT_SET },
	};
}

1;

