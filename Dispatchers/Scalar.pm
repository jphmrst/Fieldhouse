# Fieldhouse::Dispatchers::Scalar
#
# Dispatcher objects for base class core functionality.
##

package Fieldhouse::Dispatchers::Scalar;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::Scalar";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::Scalar->new();

sub name { return "scalar"; }

sub bare {
  my $self = shift;
  my $obj = shift;
  my $name = shift;

  if ($#_ == 0) {
    my $value = shift;
    $obj->{__vars}{$name} = $value;
    return $obj;
  } else {
    return $obj->{__vars}{$name};
  }
}

sub reference {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  return \$obj->{__vars}{$name};
}

sub incr {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  my $amount = shift;
  $amount = 1 unless defined $amount;

  $obj->{__vars}{$name} += $amount;
  return $obj->{__vars}{$name};
}

1;
