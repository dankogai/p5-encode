#!/usr/bin/perl -T
use strict;
use Encode qw(encode decode);
use Scalar::Util qw(tainted);
use Test::More;
my $bin = "abc" . substr($ENV{PATH},0,0); # tainted binary to decode
my $str = decode('UTF-8', $bin);          # tainted string to encode
my @names = Encode->encodings(':all');
plan tests => 2 * @names;
for my $name (@names) {
    my ($d, $e, $s);
    eval {
        $d = decode($name, $bin);
    };
  SKIP: {
      skip $@, 1 if $@;
      ok tainted($d), "decode $name";
    }
    eval {
        $e = encode($name, $str);
    };
  SKIP: {
      skip $@, 1 if $@;
      ok tainted($e), "encode $name";
    }
}
