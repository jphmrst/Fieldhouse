# Fieldhouse::Dispatchers::TripleHashOfListsPlural
#
# TripleHashOfListsPlural objects for base class core functionality.
##

package Fieldhouse::Dispatchers::TripleHashOfListsPlural;
use Fieldhouse::Base;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::TripleHashOfListsPlural";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
our $INSTANCE = new Fieldhouse::Dispatchers::TripleHashOfListsPlural;

#################################################################

sub name { return "double hash of lists"; }

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  die "$name requires three key arguments"
      unless defined $key1 && defined $key2 && defined $key3;

  my $sng = $obj->{__dblhashoflistsslot}{$name};
  my $ptr = $obj->{__dblhashoflists}{$sng}{$key1}{$key2}{$key3};
  return defined $ptr ? @$ptr : ();
}

1;
