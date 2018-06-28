#!../perl
BEGIN {
  if ($ENV{'PERL_CORE'}) {
    chdir 't';
    unshift @INC, '../lib';
  }
  require Config; import Config;
  if ($Config{'extensions'} !~ /\bEncode\b/) {
    print "1..0 # Skip: Encode was not built\n";
    exit 0;
  }
  if (ord("A") == 193) {
    print "1..0 # Skip: EBCDIC\n";
    exit 0;
  }
  $| = 1;
}

use strict;
use Encode;
use Test::More tests => 84;

my $encoding = find_encoding("utf-8-strict");

{
  my @Max = (1 << 7, 1 << 11, 1 << 16, 1 << 21);
  sub encode_ord {
    @_ == 2 or die q/Usage: encode_ord(ord, length)/;
    my ($ord, $len) = @_;

    ($len >= 1 && $len <= 4)
      or die q/Length must be within [1, 4]/;

    ($ord >= 0)
      or die qq/Can't encode ordinal '$ord'/;

    ($ord < $Max[$len - 1])
      or die qq/Can't encode ordinal '$ord' to length '$len'/;

    my @c = (0) x $len;
    for (reverse @c[1..$#c]) {
        $_ = ($ord & 0x3F) | 0x80;
        $ord >>= 6;
    }
    $c[0] = $ord | (0x00, 0xC0, 0xE0, 0xF0)[$#c];
    return pack('C*', @c);
  }
}

sub escape_octets {
  @_ == 1 or die q/Usage: escape_octets(octets)/;
  my ($octets) = @_;
  return join '', map { sprintf '\\x%.2X', ord } split //, $octets;
}

sub escape_string {
  @_ == 1 or die q/Usage: escape_string(string)/;
  my ($string) = @_;
  return join ' ', map { sprintf 'U+%.4X', ord } split //, $string;
}

# Unicode Scalar Value, 2-byte sequence
# The maximal subpart is the length of the truncated sequence
for my $ord (0x0080, 0x043F, 0x07FF) {
  my $encoded = encode_ord($ord, 2);

  {
    my $name    = sprintf 'decode("%s") 2-byte USV',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U', $ord);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated 2-byte USV (1 of 2 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U', 0xFFFD);
    is($got, $exp, $name);
  }
}

# Unicode Scalar Value, 3-byte sequence
# The maximal subpart is the length of the truncated sequence
for my $ord (0x0800, 0x83FF, 0xFFFD) {
  my $encoded = encode_ord($ord, 3);

  {
    my $name    = sprintf 'decode("%s") 3-byte USV',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U', $ord);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 2);
    my $name    = sprintf 'decode("%s") truncated 3-byte USV (2 of 3 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U', 0xFFFD);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated 3-byte USV (1 of 3 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U', 0xFFFD);
    is($got, $exp, $name);
  }
}

# Unicode Scalar Value, 4-byte sequence
# The maximal subpart is the length of the truncated sequence
for my $ord (0x10000, 0x8FFFD, 0x10FFFD) {
  my $encoded = encode_ord($ord, 4);
  {
    my $name    = sprintf 'decode("%s") 4-byte USV sequence',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U', $ord);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 3);
    my $name    = sprintf 'decode("%s") truncated 4-byte USV (3 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U', 0xFFFD);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 2);
    my $name    = sprintf 'decode("%s") truncated 4-byte USV (2 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U', 0xFFFD);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated 4-byte USV (1 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U', 0xFFFD);
    is($got, $exp, $name);
  }
}

# Non-shortest form, 4-byte sequence
# The maximal subpart of the ill-formed sequence is 1-byte
for my $ord (0x0000, 0x7FFF, 0xFFFF) {
  my $encoded = encode_ord($ord, 4);
  {
    my $name    = sprintf 'decode("%s") 4-byte non-shortest form',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 4);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 3);
    my $name    = sprintf 'decode("%s") truncated 4-byte non-shortest form (3 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 3);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 2);
    my $name    = sprintf 'decode("%s") truncated 4-byte non-shortest form (2 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 2);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated 4-byte non-shortest form (1 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 1);
    is($got, $exp, $name);
  }
}

# Non-shortest form, 3-byte sequence
# The maximal subpart of the ill-formed sequence is 1-byte
for my $ord (0x0000, 0x03FF, 0x07FF) {
  my $encoded = encode_ord($ord, 3);
  {
    my $name    = sprintf 'decode("%s") 3-byte non-shortest form',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 3);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 2);
    my $name    = sprintf 'decode("%s") truncated 3-byte non-shortest form (2 of 3 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 2);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated 3-byte non-shortest form (1 of 3 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 1);
    is($got, $exp, $name);
  }
}

# Non-shortest form, 2-byte sequence
# The maximal subpart of the ill-formed sequence is 1-byte
for my $ord (0x0000, 0x003F, 0x007F) {
  my $encoded = encode_ord($ord, 2);
  {
    my $name    = sprintf 'decode("%s") 2-byte non-shortest form',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 2);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated 2-byte non-shortest form (1 of 2 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 1);
    is($got, $exp, $name);
  }
}

# Surrogate, 3-byte sequence
# The maximal subpart of the ill-formed sequence is 1-byte
for my $ord (0xD800, 0xDBFF, 0xDFFF) {
  my $encoded = encode_ord($ord, 3);
  {
    my $name    = sprintf 'decode("%s") surrogate, 3-byte sequence',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 3);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 2);
    my $name    = sprintf 'decode("%s") truncated surrogate, 3-byte sequence (2 of 3 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 2);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated surrogate, 3-byte sequence (1 of 3 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', (0xFFFD) x 1);
    is($got, $exp, $name);
  }
}

# Non-character, 3-byte sequence
# The maximal subpart is the length of the truncated sequence
for my $ord (0xFDD0, 0xFDEF, 0xFFFF) {
  my $encoded = encode_ord($ord, 3);
  {
    my $name    = sprintf 'decode("%s") 3-byte non-character',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U*', 0xFFFD);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 2);
    my $name    = sprintf 'decode("%s") truncated 3-byte non-character (2 of 3 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', 0xFFFD);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated 3-byte non-character (1 of 3 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', 0xFFFD);
    is($got, $exp, $name);
  }
}

# Non-character, 4-byte sequence
# The maximal subpart is the length of the truncated sequence
for my $ord (0x1FFFF, 0x7FFFF, 0x10FFFF) {
  my $encoded = encode_ord($ord, 4);
  {
    my $name    = sprintf 'decode("%s") 4-byte non-character',
      escape_octets($encoded);
    my $got     = escape_string($encoding->decode($encoded));
    my $exp     = escape_string(pack 'U*', 0xFFFD);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 3);
    my $name    = sprintf 'decode("%s") truncated 4-byte non-character (3 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', 0xFFFD);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 2);
    my $name    = sprintf 'decode("%s") truncated 4-byte non-character (2 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', 0xFFFD);
    is($got, $exp, $name);
  }
  {
    my $partial = substr($encoded, 0, 1);
    my $name    = sprintf 'decode("%s") truncated 4-byte non-character (1 of 4 bytes)',
      escape_octets($partial);
    my $got     = escape_string($encoding->decode($partial));
    my $exp     = escape_string(pack 'U*', 0xFFFD);
    is($got, $exp, $name);
  }
}

