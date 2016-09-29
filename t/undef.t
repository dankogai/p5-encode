use Encode::Encoder qw(encoder);

use Test::More;
plan tests => 1;

my $emptyutf8;
eval { my $c = encoder($emptyutf8)->utf8; };
ok(!$@,"crashed encoding undef variable ($@)");
