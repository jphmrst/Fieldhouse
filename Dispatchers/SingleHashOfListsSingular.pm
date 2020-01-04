# Fieldhouse::Dispatchers::SingleHashOfListsSingular
#
# SingleHashOfListsSingular objects for base class core functionality.
##

package Fieldhouse::Dispatchers::SingleHashOfListsSingular;
use Fieldhouse::Base;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::SingleHashOfListsSingular";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
our $INSTANCE = new Fieldhouse::Dispatchers::SingleHashOfListsSingular;

#################################################################

sub name { return "single hash of lists"; }

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;
  my $index = shift;
  my $val = shift;
  die "$name requires key and index arguments"
      unless defined $key && defined $index;

  if (defined $val) {
    $obj->{__hashoflists}{$name}{$key}[$index] = $val;
    return $val;
  } else {
    return $obj->{__hashoflists}{$name}{$key}[$index];
  }
}

sub incr {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;
  my $index = shift;
  die "${name}_incr requires key and index arguments, plus optional delta"
      unless defined $key && defined $index;
  my $delta = shift;
  $delta = 1  unless defined $delta;

  $obj->{__hashoflists}{$name}{$key}[$index] += $delta;
  return $obj->{__hashoflists}{$name}{$key}[$index];
}

sub empty {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;

  ## Check if the list associated with a key is empty
  if (defined $key) {
    return !(defined $obj->{__hashoflists}{$name}{$key})
        || $#{$obj->{__hashoflists}{$name}{$key}} < 0;
  }

  ## Otherwise check if there are any defined keys
  else {
    my @ks = keys %{$obj->{__hashoflists}{$name}};
    return $#ks < 0;
  }
}

sub keyList {
  shift;
  my $obj = shift;
  my $name = shift;
  return keys %{$obj->{__hashoflists}{$name}};
}

sub deleteKey {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;
  die "delete_${name}_key required key value"  unless defined $key;

  delete $obj->{__hashoflists}{$name}{$key};
  return $obj;
}

sub sizeOf {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;

  if (defined $key) {
    return 1+$#{$obj->{__hashoflists}{$name}{$key}};
  } else {
    my @ks = keys %{$obj->{__hashoflists}{$name}};
    return 1+$#ks;
  }
}

sub push {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;

  die "push_$name requires key"                        unless defined $key;
  die "push_$name requires at least one pushed value"  unless $#_ > -1;
  push @{$obj->{__hashoflists}{$name}{$key}}, @_;
  return $obj;
}

sub unshift {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;

  die "unshift_$name requires key"  unless defined $key;
  die "unshift_$name requires at least one unshifted value"  unless $#_ > -1;
  unshift @{$obj->{__hashoflists}{$name}{$key}}, @_;
  return $obj;
}

sub doubleUnderscore {
  shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__hashoflists}{$name};
}

1;
