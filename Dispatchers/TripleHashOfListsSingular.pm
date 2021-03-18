# Fieldhouse::Dispatchers::TripleHashOfListsSingular
#
# TripleHashOfListsSingular objects for base class core functionality.
##

package Fieldhouse::Dispatchers::TripleHashOfListsSingular;
use Fieldhouse::Dispatchers::XHashOfLists;
use Fieldhouse::Dispatchers::TripleHash;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::TripleHashOfListsSingular";
our @ISA = ("Fieldhouse::Dispatchers::TripleHash",
            "Fieldhouse::Dispatchers::XHashOfLists");
our $INSTANCE = new Fieldhouse::Dispatchers::TripleHashOfListsSingular;

#################################################################

sub name { return "double hash of lists"; }

sub baseHashtable {
  shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__triplehashoflists}{$name};
}

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;

  die "$name requires at least four arguments"  if $#_ < 3;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $idx = shift;
  my $val = shift;

  ## print "** triplehash-of-lists lookup hash $name keys $key1,$key2,$key3 idx $idx val $val\n";
  if (defined $val) {
    $obj->{__triplehash}{$name}{$key1}{$key2}{$key3}[$idx] = $val;
    return $val;
  } else {
    return undef
        unless (exists $obj->{__triplehashoflists}{$name}{$key1}
                && exists $obj->{__triplehashoflists}{$name}{$key1}{$key2}
                && exists $obj->{__triplehashoflists}{$name}{$key1}{$key2}{$key3}
                && exists $obj->{__triplehashoflists}{$name}{$key1}{$key2}{$key3}[$idx]);
    return $obj->{__triplehashoflists}{$name}{$key1}{$key2}{$key3}[$idx];
  }
}

sub empty {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;

  ## First check the odd case that the top-level hash is empty.
  ## Weird, but not a problem we solve here.
  my $theHash = $obj->{__triplehashoflists}{$name};
  return 1  unless defined $theHash;

  ## Otherwise see how many keys are defined, and check that level of
  ## hashtable tree.
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  if (!defined $key1) {
    return $dispatcher->isHash3EmptyLists($theHash);
  } elsif (!defined $key2) {
    return $dispatcher->isHash2EmptyLists($theHash->{$key1});
  } elsif (!defined $key3) {
    return $dispatcher->isHash1EmptyLists($theHash->{$key1}{$key2});
  } else {
    my $arr = $theHash->{$key1}{$key2}{$key3};
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
  my $index = shift;
  die "${name}_incr requires three key and one index arguments, plus optional delta"
      unless defined $key1 && defined $key2 && defined $key3 && defined $index;
  my $delta = shift;
  $delta = 1  unless defined $delta;

  $obj->{__triplehashoflists}{$name}{$key1}{$key2}{$key3}[$index] += $delta;
  return $obj->{__triplehashoflists}{$name}{$key1}{$key2}{$key3}[$index];
}

sub push {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "push_$name requires three keys plus at least one argument"  if $#_ < 3;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  push @{$obj->{__triplehashoflists}{$name}{$key1}{$key2}{$key3}}, @_;
  return $obj;
}

sub unshift {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "unshift_$name requires three keys plus at least one argument"
      if $#_ < 3;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  unshift @{$obj->{__triplehashoflists}{$name}{$key1}{$key2}{$key3}}, @_;
  return $obj;
}

sub sizeOf {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $theHash = $obj->{__triplehashoflists}{$name};

  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;

  return $dispatcher->listSizeSafe($theHash->{$key1}{$key2}{$key3})
      if defined $key3;
  return $dispatcher->hash1ListsSize($theHash->{$key1}{$key2})
      if defined $key2;
  return $dispatcher->hash2ListsSize($theHash->{$key1})
      if defined $key1;
  return $dispatcher->hash3ListsSize($theHash);
}

1;
