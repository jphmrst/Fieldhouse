# Fieldhouse::Dispatchers::Dispatcher
#
# Dispatcher objects for base class core functionality.
##

package Fieldhouse::Dispatchers::Dispatcher;
use Fieldhouse::Base;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::Dispatcher";
our @ISA = qw(Exporter);

#################################################################

sub new {
  my $class = shift;
  my $self = { };
  bless $self, $class;
  return $self;
}

sub name { return "dispatcher superclass"; }

sub bare {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$dispatcher->name();
}

sub reference {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for ${name}_ref on ".$dispatcher->name();
}

sub empty {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for ${name}_empty on ".$dispatcher->name();
}

sub incr {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $amount = shift;
  die "No implementation for incr_${name} on ".$dispatcher->name();
}

sub keyList {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for ${name}_keys on ".$dispatcher->name();
}

sub deleteKey {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for delete_${name}_key on ".$dispatcher->name();
}

sub pushKeyed {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for push_${name}_keyed on ".$dispatcher->name();
}

sub unshiftKeyed {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for unshift_${name}_keyed on ".$dispatcher->name();
}

sub sizeOf {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for ${name}_size on ".$dispatcher->name();
}

sub push {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for push_${name} on ".$dispatcher->name();
}

sub unshift {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for unshift_${name} on ".$dispatcher->name();
}

sub doubleUnderscore {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for __${name} on ".$dispatcher->name();
}

sub maxIndex {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for ${name}_maxIndex on ".$dispatcher->name();
}

1;
