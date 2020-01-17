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

sub no_impl_msg {
  my $name = shift;
  my $dispatcher = shift;
  return ("No implementation for $name on " . ref($dispatcher)
          . " (" . $dispatcher->name() . ")");
}

sub bare {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg($name, $dispatcher);
}

sub clear {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("clear_$name", $dispatcher);
}

sub reference {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("${name}_ref", $dispatcher);
}

sub empty {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("${name}_empty", $dispatcher);
}

sub incr {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $amount = shift;
  die no_impl_msg("incr_${name}", $dispatcher);
}

sub keyList {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("${name}_keys", $dispatcher);
}

sub deleteKey {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("delete_${name}_key", $dispatcher);
}

sub pushKeyed {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("push_${name}_keyed", $dispatcher);
}

sub unshiftKeyed {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("unshift_${name}_keyed", $dispatcher);
}

sub sizeOf {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("${name}_size", $dispatcher);
}

sub push {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("push_${name}", $dispatcher);
}

sub unshift {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("unshift_${name}", $dispatcher);
}

sub doubleUnderscore {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("__${name}", $dispatcher);
}

sub maxIndex {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die no_impl_msg("${name}_maxIndex", $dispatcher);
}

1;
