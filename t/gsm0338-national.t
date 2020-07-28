BEGIN {
    if ($ENV{'PERL_CORE'}){
        chdir 't';
        unshift @INC, '../lib';
    }
    require Config; import Config;
    if ($Config{'extensions'} !~ /\bEncode\b/) {
      print "1..0 # Skip: Encode was not built\n";
      exit 0;
    }
    $| = 1;
}

use strict;
use utf8;
use Test::More;
use Encode;
use Encode::GSM0338 qw[ gsm0338 ];

plan tests =>
	6 # gsm0338()
	+ 4 # 4 alphabets (gsm, tr, es, pt)
	* 4 # encode/decode basic/shift set
	;

sub it;
sub BASIC_SET_GSM;
sub BASIC_SET_UNICODE;
sub SHIFT_SET_GSM;
sub SHIFT_SET_UNICODE;

it ("should return canonical encoding name when called without parameters" => (
	expect => 'gsm0338',
	got    => gsm0338(),
));

it ("should return canonical encoding name when gsm sets are specified" => (
	expect => 'gsm0338',
	got    => gsm0338 (basic => 'gsm', shift => 'gsm'),
));

it ("should compose national language encoding" => (
	expect => 'gsm0338:tr:tr',
	got    => gsm0338 (basic => 'tr', shift => 'tr'),
));

it ("should allow combination of different basic and shift sets" => (
	expect => 'gsm0338:tr:es',
	got    => gsm0338 (basic => 'tr', shift => 'es'),
));

it ("should use default language when shift set not specified" => (
	expect => 'gsm0338:tr:gsm',
	got    => gsm0338 (basic => 'tr'),
));

it ("should use default language when basic set not specified" => (
	expect => 'gsm0338:gsm:tr',
	got    => gsm0338 (shift => 'tr'),
));

it ("should decode GSM string using default alphabet (basic set)" => (
	expect => BASIC_SET_UNICODE,
	got => decode (gsm0338, BASIC_SET_GSM),
));

it ("should decode GSM string using default alphabet (shift set)" => (
	expect => SHIFT_SET_UNICODE,
	got => decode (gsm0338, SHIFT_SET_GSM),
));

it ("should encode GSM string using default alphabet (basic set)" => (
	expect => BASIC_SET_GSM,
	got => encode (gsm0338, BASIC_SET_UNICODE),
));

it ("should encode GSM string using default alphabet (shift set)" => (
	expect => SHIFT_SET_GSM,
	got => encode (gsm0338, SHIFT_SET_UNICODE),
));

sub TURKISH_BASIC_SET_UNICODE;
sub TURKISH_SHIFT_SET_GSM;
sub TURKISH_SHIFT_SET_UNICODE;

note (<<'EONOTE');
	Turkish basic set contains EURO SIGN
	When combined with default shift set basic set should take precedence
EONOTE
it ("should decode GSM string using Turkish alphabet (basic set, UDH 250101)" => (
	expect => TURKISH_BASIC_SET_UNICODE,
	got => decode (gsm0338 (basic => 'tr'), BASIC_SET_GSM),
));

it ("should decode GSM string using Turkish alphabet (shift set, UDH 240101)" => (
	expect => TURKISH_SHIFT_SET_UNICODE,
	got => decode (gsm0338 (shift => 'tr'), TURKISH_SHIFT_SET_GSM),
));

it ("should encode GSM string using Turkish alphabet (basic set, UDH 250101)" => (
	expect => BASIC_SET_GSM,
	got => encode (gsm0338 (basic => 'tr'), TURKISH_BASIC_SET_UNICODE),
));

it ("should encode GSM string using Turkish alphabet (shift set, UDH 240101)" => (
	expect => TURKISH_SHIFT_SET_GSM,
	got => encode (gsm0338 (shift => 'tr'), TURKISH_SHIFT_SET_UNICODE),
));

sub SPANISH_BASIC_SET_UNICODE;
sub SPANISH_SHIFT_SET_GSM;
sub SPANISH_SHIFT_SET_UNICODE;

it ("should decode GSM string using Spanish alphabet (basic set, UDH 250102)" => (
	expect => SPANISH_BASIC_SET_UNICODE,
	got => decode (gsm0338 (basic => 'es'), BASIC_SET_GSM),
));

it ("should decode GSM string using Spanish alphabet (shift set, UDH 240102)" => (
	expect => SPANISH_SHIFT_SET_UNICODE,
	got => decode (gsm0338 (shift => 'es'), SPANISH_SHIFT_SET_GSM),
));

it ("should encode GSM string using Spanish alphabet (basic set, UDH 250102)" => (
	expect => BASIC_SET_GSM,
	got => encode (gsm0338 (basic => 'es'), SPANISH_BASIC_SET_UNICODE),
));

it ("should encode GSM string using Spanish alphabet (shift set, UDH 240102)" => (
	expect => SPANISH_SHIFT_SET_GSM,
	got => encode (gsm0338 (shift => 'es'), SPANISH_SHIFT_SET_UNICODE),
));

sub PORTUGUESE_BASIC_SET_UNICODE;
sub PORTUGUESE_SHIFT_SET_GSM;
sub PORTUGUESE_SHIFT_SET_UNICODE;

it ("should decode GSM string using Portuguese alphabet (basic set, UDH 250103)" => (
	expect => PORTUGUESE_BASIC_SET_UNICODE,
	got => decode (gsm0338 (basic => 'pt'), BASIC_SET_GSM),
));

it ("should decode GSM string using Portuguese alphabet (shift set, UDH 240103)" => (
	expect => PORTUGUESE_SHIFT_SET_UNICODE,
	got => decode (gsm0338 (shift => 'pt'), PORTUGUESE_SHIFT_SET_GSM),
));

it ("should encode GSM string using Portuguese alphabet (basic set, UDH 250103)" => (
	expect => BASIC_SET_GSM,
	got => encode (gsm0338 (basic => 'pt'), PORTUGUESE_BASIC_SET_UNICODE),
));

it ("should encode GSM string using Portuguese alphabet (shift set, UDH 240103)" => (
	expect => PORTUGUESE_SHIFT_SET_GSM,
	got => encode (gsm0338 (shift => 'pt'), PORTUGUESE_SHIFT_SET_UNICODE),
));

done_testing;

sub it {
	my ($title, %params) = @_;

    exists $params{expect}
        ? is ($params{got}, $params{expect}, $title)
        : ok ($params{got}, $title)
		;
}

sub build_shift_set_gsm {
	my ($map) = @_;

	join '', map { "\x1B" . chr } sort keys %$map;
}

sub build_shift_set_unicode {
	my ($map) = @_;

	join '', @$map{ sort keys %$map };
}

sub BASIC_SET_GSM {
	join '', (
		"\x00\x01\x02\x03\x04\x05\x06\x07",
		"\x08\x09\x0A\x0B\x0C\x0D\x0E\x0F",
		"\x10\x11\x12\x13\x14\x15\x16\x17",
		"\x18\x19\x1A\x20\x1C\x1D\x1E\x1F", # ESC replaced with SPACE
		"\x20\x21\x22\x23\x24\x25\x26\x27",
		"\x28\x29\x2A\x2B\x2C\x2D\x2E\x2F",
		"\x30\x31\x32\x33\x34\x35\x36\x37",
		"\x38\x39\x3A\x3B\x3C\x3D\x3E\x3F",
		"\x40\x41\x42\x43\x44\x45\x46\x47",
		"\x48\x49\x4A\x4B\x4C\x4D\x4E\x4F",
		"\x50\x51\x52\x53\x54\x55\x56\x57",
		"\x58\x59\x5A\x5B\x5C\x5D\x5E\x5F",
		"\x60\x61\x62\x63\x64\x65\x66\x67",
		"\x68\x69\x6A\x6B\x6C\x6D\x6E\x6F",
		"\x70\x71\x72\x73\x74\x75\x76\x77",
		"\x78\x79\x7A\x7B\x7C\x7D\x7E\x7F",
	);
}

sub BASIC_SET_UNICODE {
	join '', (
		"\@£\$¥èéùì",
		"òÇ\x{0A}Øø\x{0D}Åå",
		"Δ_ΦΓΛΩΠΨ",
		"ΣΘΞ ÆæßÉ",
		" !\"#¤\%&'",
		"()*+,-./",
		"01234567",
		"89:;<=>?",
		"¡ABCDEFG",
		"HIJKLMNO",
		"PQRSTUVW",
		"XYZÄÖÑÜ§",
		"¿abcdefg",
		"hijklmno",
		"pqrstuvw",
		"xyzäöñüà",
	);
}

my $gsm_shift_set_map = {
	0x10 => '^',
	0x28 => '{',
	0x29 => '}',
	0x2f => '\\',
	0x3c => '[',
	0x3d => '~',
	0x3f => ']',
	0x40 => '|',
	0x65 => '€',
};

sub SHIFT_SET_GSM {
	build_shift_set_gsm ($gsm_shift_set_map);
}

sub SHIFT_SET_UNICODE {
	build_shift_set_unicode ($gsm_shift_set_map);
}

sub TURKISH_BASIC_SET_UNICODE {
	join '', (
		"\@£\$¥€éùı",
		"òÇ\x{0A}Ğğ\x{0D}Åå",
		"Δ_ΦΓΛΩΠΨ",
		"ΣΘΞ ŞşßÉ",
		" !\"#¤\%&'",
		"()*+,-./",
		"01234567",
		"89:;<=>?",
		"İABCDEFG",
		"HIJKLMNO",
		"PQRSTUVW",
		"XYZÄÖÑÜ§",
		"çabcdefg",
		"hijklmno",
		"pqrstuvw",
		"xyzäöñüà",
	);
}

my $turkish_shift_set_map = {
	0x14 => '^',
	0x28 => '{',
	0x29 => '}',
	0x2F => '\\',
	0x3C => '[',
	0x3D => '~',
	0x3E => ']',
	0x40 => '|',
	0x47 => 'Ğ',
	0x49 => 'İ',
	0x53 => 'Ş',
	0x63 => 'ç',
	0x65 => '€',
	0x67 => 'ğ',
	0x69 => 'ı',
	0x73 => 'ş',
};

sub TURKISH_SHIFT_SET_GSM {
	build_shift_set_gsm ($turkish_shift_set_map);
}

sub TURKISH_SHIFT_SET_UNICODE {
	build_shift_set_unicode ($turkish_shift_set_map);
}

sub SPANISH_BASIC_SET_UNICODE {
	# Spanish basic set is identical with GSM default basic set
	BASIC_SET_UNICODE;
}

my $spanish_shift_set_map = {
	0x09 => 'ç',
	0x14 => '^',
	0x28 => '{',
	0x29 => '}',
	0x2F => '\\',
	0x3C => '[',
	0x3D => '~',
	0x3E => ']',
	0x40 => '|',
	0x41 => 'Á',
	0x49 => 'Í',
	0x4F => 'Ó',
	0x55 => 'Ú',
	0x61 => 'á',
	0x65 => '€',
	0x69 => 'í',
	0x6F => 'ó',
	0x75 => 'ú',
};

sub SPANISH_SHIFT_SET_GSM {
	build_shift_set_gsm ($spanish_shift_set_map);
}

sub SPANISH_SHIFT_SET_UNICODE {
	build_shift_set_unicode ($spanish_shift_set_map);
}

sub PORTUGUESE_BASIC_SET_UNICODE {
	join '', (
		"\@£\$¥êéúí",
		"óç\x{0A}Ôô\x{0D}Áá",
		"Δ_ªÇÀ∞^\\",
		"€Ó| ÂâÊÉ",
		" !\"#º\%&'",
		"()*+,-./",
		"01234567",
		"89:;<=>?",
		"ÍABCDEFG",
		"HIJKLMNO",
		"PQRSTUVW",
		"XYZÃÕÚÜ§",
		"~abcdefg",
		"hijklmno",
		"pqrstuvw",
		"xyzãõ`üà",
	);
}

my $portuguese_shift_set_map = {
	0x05 => 'ê',
	0x09 => 'ç',
	0x0B => 'Ô',
	0x0C => 'ô',
	0x0E => 'Á',
	0x0F => 'á',
	0x12 => 'Φ',
	0x13 => 'Γ',
	0x14 => '^',
	0x15 => 'Ω',
	0x16 => 'Π',
	0x17 => 'Ψ',
	0x18 => 'Σ',
	0x19 => 'Θ',
	0x1F => 'Ê',
	0x28 => '{',
	0x29 => '}',
	0x2F => '\\',
	0x3C => '[',
	0x3D => '~',
	0x3E => ']',
	0x40 => '|',
	0x41 => 'À',
	0x49 => 'Í',
	0x4F => 'Ó',
	0x55 => 'Ú',
	0x5B => 'Ã',
	0x5C => 'Õ',
	0x61 => 'Â',
	0x65 => '€',
	0x69 => 'í',
	0x6F => 'ó',
	0x75 => 'ú',
	0x7B => 'ã',
	0x7C => 'õ',
	0x7F => 'â',
};

sub PORTUGUESE_SHIFT_SET_GSM {
	build_shift_set_gsm ($portuguese_shift_set_map);
}

sub PORTUGUESE_SHIFT_SET_UNICODE {
	build_shift_set_unicode ($portuguese_shift_set_map);
}

