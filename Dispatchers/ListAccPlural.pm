package Fieldhouse::Dispatchers::ListAccPlural;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::ListAccPlural";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::ListAccPlural->new();

sub name { return "plural name uses for a list accumulator"; }

sub bare {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  return @{$obj->{__listaccs}{$obj->{__listaccslot}{$name}}};
}

sub reference {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  warn "${name}_ref arguments ignored"  if $#_ >= 0;
  return $obj->{__listaccs}{$obj->{__listaccslot}{$name}};
}

sub empty {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  return $#{$obj->{__listaccs}{$obj->{__listaccslot}{$name}}}<0;
}

sub sizeOf {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on ".$self->name();
  return 1+$#{$obj->{__listaccs}{$obj->{__listaccslot}{$name}}};
}

1;
