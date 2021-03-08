package Fieldhouse::Dispatchers::HashSet;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::HashSet";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::HashSet->new();

sub name { return "HashSet"; }

sub bare {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  return keys %{$obj->{__hashset}{$name}};
}

sub clear {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  $obj->{__hashset}{$name} = {};
}

sub reference {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__hashset}{$name};
}

sub empty {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  my $sz = keys %{$obj->{__hashset}{$name}};
  return $sz > 0;
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
  my $sz = keys %{$obj->{__hashset}{$name}};
  return $sz;
}

sub push {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  foreach my $item (@_) {
    $obj->{__hashset}{$name}{$item} = 1;
  }
}

sub unshift {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  foreach my $item (@_) {
    $obj->{__hashset}{$name}{$item} = 1;
  }
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
