# Fieldhouse::Dispatchers::QuadHashOfListsSingular
#
# QuadHashOfListsSingular objects for base class core functionality.
##

package Fieldhouse::Dispatchers::QuadHashOfListsSingular;
use Fieldhouse::Dispatchers::XHashOfLists;
use Fieldhouse::Dispatchers::QuadHash;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::QuadHashOfListsSingular";
our @ISA = ("Fieldhouse::Dispatchers::QuadHash",
            "Fieldhouse::Dispatchers::XHashOfLists");
our $INSTANCE = new Fieldhouse::Dispatchers::QuadHashOfListsSingular;

#################################################################

sub name { return "double hash of lists"; }

sub baseHashtable {
  shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__quadhashoflists}{$name};
}

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;

  die "$name requires at least five arguments"  if $#_ < 4;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $key4 = shift;
  my $idx = shift;
  my $val = shift;

  ## print "** quadhash-of-lists lookup hash $name keys $key1,$key2,$key3,$key4 idx $idx val $val\n";
  if (defined $val) {
    $obj->{__quadhash}{$name}{$key1}{$key2}{$key3}{$key4}[$idx] = $val;
    return $val;
  } else {
    return undef
        unless (exists $obj->{__quadhashoflists}{$name}{$key1}
                && exists $obj->{__quadhashoflists}{$name}{$key1}{$key2}
                && exists $obj->{__quadhashoflists}{$name}{$key1}{$key2}{$key3}
                && exists $obj->{__quadhashoflists}{$name}{$key1}{$key2}{$key3}{$key4}
                && exists $obj->{__quadhashoflists}{$name}{$key1}{$key2}{$key3}{$key4}[$idx]);
    return $obj->{__quadhashoflists}{$name}{$key1}{$key2}{$key3}{$key4}[$idx];
  }
}

sub empty {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;

  ## First check the odd case that the top-level hash is empty.
  ## Weird, but not a problem we solve here.
  my $theHash = $obj->{__quadhashoflists}{$name};
  return 1  unless defined $theHash;

  ## Otherwise see how many keys are defined, and check that level of
  ## hashtable tree.
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $key4 = shift;
  if (!defined $key1) {
    return $dispatcher->isHash4EmptyLists($theHash);
  } elsif (!defined $key2) {
    return $dispatcher->isHash3EmptyLists($theHash->{$key1});
  } elsif (!defined $key3) {
    return $dispatcher->isHash2EmptyLists($theHash->{$key1}{$key2});
  } elsif (!defined $key4) {
    return $dispatcher->isHash1EmptyLists($theHash->{$key1}{$key2}{$key3});
  } else {
    my $arr = $theHash->{$key1}{$key2}{$key3}{$key4};
    return !(defined $arr) || ($#{$arr} < 0);
  }
}

sub incr {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $key4 = shift;
  my $index = shift;
  die "${name}_incr requires four key and one index arguments, plus optional delta"
      unless defined $key1 && defined $key2 && defined $key3
      && defined $key4 && defined $index;
  my $delta = shift;
  $delta = 1  unless defined $delta;

  $obj->{__quadhashoflists}{$name}{$key1}{$key2}{$key3}{$key4}[$index] += $delta;
  return $obj->{__quadhashoflists}{$name}{$key1}{$key2}{$key3}{$key4}[$index];
}

sub push {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "push_$name requires three keys plus at least one argument"  if $#_ < 4;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $key4 = shift;
  push @{$obj->{__quadhashoflists}{$name}{$key1}{$key2}{$key3}{$key4}}, @_;
  return $obj;
}

sub unshift {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "unshift_$name requires three keys plus at least one argument"
      if $#_ < 4;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $key4 = shift;
  unshift @{$obj->{__quadhashoflists}{$name}{$key1}{$key2}{$key3}{$key4}}, @_;
  return $obj;
}

sub sizeOf {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $theHash = $obj->{__quadhashoflists}{$name};

  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $key4 = shift;

  return $dispatcher->listSizeSafe($theHash->{$key1}{$key2}{$key3}{$key4})
      if defined $key4;
  return $dispatcher->hash1ListsSize($theHash->{$key1}{$key2}{$key3})
      if defined $key3;
  return $dispatcher->hash2ListsSize($theHash->{$key1}{$key2})
      if defined $key2;
  return $dispatcher->hash3ListsSize($theHash->{$key1})
      if defined $key1;
  return $dispatcher->hash4ListsSize($theHash);
}

1;
