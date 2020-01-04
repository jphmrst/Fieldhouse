# Fieldhouse::Dispatchers::SingleHash
#
# Dispatcher objects for base class core functionality.
##

package Fieldhouse::Dispatchers::SingleHash;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::SingleHash";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::SingleHash->new();

sub name { return "Single-key hashtable"; }

#################################################################

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;

  die "$name requires at least one argument"  if $#_ < 0;
  my $key = shift;
  my $val = shift;

  if (defined $val) {
    $obj->{__snghash}{$name}{$key} = $val;
    return $val;
  } else {
    return $obj->{__snghash}{$name}{$key};
  }
}

sub empty {
  shift;
  my $obj = shift;
  my $name = shift;
  my @keys = keys %{$obj->{__snghash}{$name}};
  return $#keys<0;
}

sub keyList {
  shift;
  my $obj = shift;
  my $name = shift;
  return keys %{$obj->{__snghash}{$name}};
}

sub deleteKey {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;
  delete $obj->{__snghash}{$name}{$key};
  return $obj;
}

sub sizeOf {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my @keys = keys %{$obj->{__snghash}{$name}};
  return 1+$#keys;
}

sub doubleUnderscore {
  shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__snghash}{$name};
}

1;
