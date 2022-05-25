[![CI on Perl 5.34 on {Linux,macOS,Windows}](https://github.com/dankogai/p5-encode/actions/workflows/platforms.yml/badge.svg)](https://github.com/dankogai/p5-encode/actions/workflows/platforms.yml)

## NAME

Encode - character encodings

## SYNOPSIS

       use Encode;

## COMMAND LINE

       $ encguess README.md
       README.md	US-ASCII

See `encguess -h` for more options.

## DESCRIPTION

The "Encode" module provides the interfaces between Perl's
strings and the rest of the system.  Perl strings are
sequences of characters.

       See `perldoc Encode` for the rest of the story

## INSTALLATION

To install this module, type the following:

       perl Makefile.PL
       make
       make test
       make install

To install scripts under bin/ directories also,

       perl Makefile.PL MORE_SCRIPTS
       make && make test && make install

By default, only enc2xs and piconv are installed.

To install *.ucm files also, say

       perl Makefile.PL INSTALL_UCM
       make && make test && make install

By default, *.ucm are not installed.

## DEPENDENCIES

This module requires perl 5.7.3 or later.

## MAINTAINER

This project was originated by Nick Ing-Simmons and later maintained by
Dan Kogai `<dankogai at dan.co.jp>`.  See AUTHORS for the full list of people
involved.

## QUESTIONS?

If you have any questions which `perldoc Encode` does not answer, please
feel free to ask at `perl-unicode@perl.org`.
