package Fieldhouse::Dispatchers::ListAccSingular;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::ListAccSingular";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::ListAccSingular->new();

sub name { return "singular name uses for a list accumulator"; }

sub bare {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  my $index = shift;
  die "First argument $index must be a number"  unless $index =~ /^[0-9]+$/;

  my $value = shift;
  if (defined $value) {
    $obj->{__listaccs}{$name}[$index] = $value;
    return $obj;
  } else {
    return $obj->{__listaccs}{$name}[$index];
  }
}

sub incr {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  my $index = shift;
  die "First argument $index must be a number"  unless $index =~ /^[0-9]+$/;

  my $amount = shift;
  $amount=1  unless defined $amount;
  $obj->{__listaccs}{$name}[$index] += $amount;

  return $obj->{__listaccs}{$name}[$index];
}

sub sizeOf {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  return 1+$#{$obj->{__listaccs}{$name}};
}

sub push {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "push_$name requires at least one argument"  if $#_ < 0;
  push @{$obj->{__listaccs}{$name}}, @_;
  return $obj;
}

sub unshift {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "unshift_$name requires at least one argument"  if $#_ < 0;
  unshift @{$obj->{__listaccs}{$name}}, @_;
  return $obj;
}

# sub doubleUnderscore {
#   my $self = shift;
#   my $obj = shift;
#   my $name = shift;
#   die "No implementation for $name on ".$self->name();
# }

sub maxIndex {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  return $#{$obj->{__listaccs}{$name}};
}

1;
