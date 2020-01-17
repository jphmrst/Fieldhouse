package Fieldhouse::Dispatchers::TEMPLATE;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::TEMPLATE";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;

sub name { return "TEMPLATE"; }

sub bare {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub clear {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for clear_$name on ".$dispatcher->name();
}

sub reference {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub empty {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub incr {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  my $amount = shift;
  die "No implementation for $name on ".$self->name();
}

sub keyList {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub deleteKey {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub pushKeyed {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub unshiftKeyed {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub sizeOf {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for ${name}_size on ".$self->name();
}

sub push {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub unshift {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub doubleUnderscore {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

sub maxIndex {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
}

1;
