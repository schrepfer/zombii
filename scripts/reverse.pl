#!/usr/bin/env perl
#
# This script basically just reverses a dir.
#
# Written by Alexander C. Schrepfer (conglomo@zombiemud)
#

use Getopt::Std;
use strict;

my %options = ();
getopts("vh", \%options);

if (defined($options{v})) {
  print 'Reverse It v1.0.' . substr('$LastChangedRevision: 988 $', 22, -2) . "\n";
  exit(1);
}

if (defined($options{h}) or $#ARGV lt 1) {
  print("usage: reverse.pl <separator> <path>\n");
  exit(1);
}

my $separator = $ARGV[0];
my $path = join(' ', @ARGV[1..$#ARGV]);

my @path = split(/$separator/, $path);

my @result = ();

my %reverse = (
  "north" => "south",
  "east" => "west",
  "northeast" => "southwest",
  "northwest" => "southeast",
  "up" => "down",
  "n" => "s",
  "e" => "w",
  "ne" => "sw",
  "nw" => "se",
  "u" => "d",
);

my %alias = (
  "n" => "north",
  "e" => "east",
  "s" => "south",
  "w" => "west",
  "nw" => "northwest",
  "ne" => "northeast",
  "sw" => "southwest",
  "se" => "southeast",
  "u" => "up",
  "d" => "down",
);

while (my $command = pop(@path)) {

  my $command =~ s/^!//g;
  my $multiplier = 1;

  if ($command =~ /^([0-9]+) (.+)$/) {
    $multiplier = $1;
    $command = $2;
  }

# if (exists($alias{$command})) {
#   $command = $alias{$command};
# }

  my $opposite_dir = 0;
  while ((my $dir1, my $dir2) = each(%reverse)) {
    if ($opposite_dir) {
      next;
    }
    if ($command eq $dir1) {
      $opposite_dir = $dir2;
    }
    if ($command eq $dir2) {
      $opposite_dir = $dir1;
    }
  }

  if (!$opposite_dir) {
    $opposite_dir = "(opposite of $command)";
  }

  if ($multiplier gt 1) {
    push(@result, "$multiplier $opposite_dir");
  } else {
    push(@result, "$opposite_dir");
  }

}

my $bang = '';
if ($separator =~ /!$/) { $bang = '!'; }
print($bang . join($separator, @result) . "\n");
