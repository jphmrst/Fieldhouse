# Fieldhouse::Dispatchers::DoubleHashOfListsPlural
#
# DoubleHashOfListsPlural objects for base class core functionality.
##

package Fieldhouse::Dispatchers::DoubleHashOfListsPlural;
use Fieldhouse::Base;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::DoubleHashOfListsPlural";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
our $INSTANCE = new Fieldhouse::Dispatchers::DoubleHashOfListsPlural;

#################################################################

sub name { return "double hash of lists"; }

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key1 = shift;
  my $key2 = shift;
  die "$name requires two key arguments"
      unless defined $key1 && defined $key2;

  my $sng = $obj->{__dblhashoflistsslot}{$name};
  my $ptr = $obj->{__dblhashoflists}{$sng}{$key1}{$key2};
  return defined $ptr ? @$ptr : ();
}

1;
