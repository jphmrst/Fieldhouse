# Fieldhouse::Dispatchers::DoubleHashOfListsSingular
#
# DoubleHashOfListsSingular objects for base class core functionality.
##

package Fieldhouse::Dispatchers::DoubleHashOfListsSingular;
use Fieldhouse::Base;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::DoubleHashOfListsSingular";
our @ISA = ("Fieldhouse::Dispatchers::DoubleHash",
            "Fieldhouse::Dispatchers::XHashOfLists");
our $INSTANCE = new Fieldhouse::Dispatchers::DoubleHashOfListsSingular;

#################################################################

sub name { return "double hash of lists"; }

sub baseHashtable {
  shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__dblhashoflists}{$name};
}

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;

  die "$name requires at least three arguments"  if $#_ < 2;
  my $key1 = shift;
  my $key2 = shift;
  my $idx = shift;
  my $val = shift;

  ## print "** dblhash lookup hash $name keys $key1,$key2 idx $idx val $val\n";
  if (defined $val) {
    $obj->{__dblhash}{$name}{$key1}{$key2}[$idx] = $val;
    return $val;
  } else {
    return undef
        unless (exists $obj->{__dblhashoflists}{$name}{$key1}
                && exists $obj->{__dblhashoflists}{$name}{$key1}{$key2}
                && exists $obj->{__dblhashoflists}{$name}{$key1}{$key2}[$idx]);
    return $obj->{__dblhashoflists}{$name}{$key1}{$key2}[$idx];
  }
}

sub empty {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;

  ## First check the odd case that the top-level hash is empty.
  ## Weird, but not a problem we solve here.
  my $theHash = $obj->{__dblhashoflists}{$name};
  return 1  unless defined $theHash;

  ## Otherwise see how many keys are defined, and check that level of
  ## hashtable tree.
  my $key1 = shift;
  my $key2 = shift;
  if (!defined $key1) {
    return $dispatcher->isHash2EmptyLists($theHash);
  } elsif (!defined $key2) {
    return $dispatcher->isHash1EmptyLists($theHash->{$key1});
  } else {
    my $arr = $theHash->{$key1}{$key2};
    return !(defined $arr) || ($#{$arr} < 0);
  }
}

sub incr {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key1 = shift;
  my $key2 = shift;
  my $index = shift;
  die "${name}_incr requires two key and one index arguments, plus optional delta"
      unless defined $key1 && defined $key2 && defined $index;
  my $delta = shift;
  $delta = 1  unless defined $delta;

  $obj->{__dblhashoflists}{$name}{$key1}{$key2}[$index] += $delta;
  return $obj->{__dblhashoflists}{$name}{$key1}{$key2}[$index];
}

sub push {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "push_$name requires two keys plus at least one argument"  if $#_ < 2;
  my $key1 = shift;
  my $key2 = shift;
  push @{$obj->{__dblhashoflists}{$name}{$key1}{$key2}}, @_;
  return $obj;
}

sub unshift {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "unshift_$name requires two keys plus at least one argument"  if $#_ < 2;
  my $key1 = shift;
  my $key2 = shift;
  unshift @{$obj->{__dblhashoflists}{$name}{$key1}{$key2}}, @_;
  return $obj;
}

sub sizeOf {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $key1 = shift;
  my $key2 = shift;

  my $theHash = $obj->{__dblhashoflists}{$name};
  return $dispatcher->listSizeSafe($theHash->{$key1}{$key2}) if defined $key2;
  return $dispatcher->hash1ListsSize($theHash->{$key1})  if defined $key1;
  return $dispatcher->hash2ListsSize($theHash);
}

1;
