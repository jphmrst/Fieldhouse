# Fieldhouse::Dispatchers::QuadHashOfListsPlural
#
# QuadHashOfListsPlural objects for base class core functionality.
##

package Fieldhouse::Dispatchers::QuadHashOfListsPlural;
use Fieldhouse::Base;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::QuadHashOfListsPlural";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
our $INSTANCE = new Fieldhouse::Dispatchers::QuadHashOfListsPlural;

#################################################################

sub name { return "double hash of lists"; }

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $key4 = shift;
  die "$name requires four key arguments"
      unless defined $key1 && defined $key2 && defined $key3 && defined $key4;

  my $sng = $obj->{__quadhashoflistsslot}{$name};
  my $ptr = $obj->{__quadhashoflists}{$sng}{$key1}{$key2}{$key3}{$key4};
  return defined $ptr ? @$ptr : ();
}

1;
