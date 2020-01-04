# Fieldhouse::Dispatchers::SingleHashOfListsPlural
#
# SingleHashOfListsPlural objects for base class core functionality.
##

package Fieldhouse::Dispatchers::SingleHashOfListsPlural;
use Fieldhouse::Base;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::SingleHashOfListsPlural";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
our $INSTANCE = new Fieldhouse::Dispatchers::SingleHashOfListsPlural;

#################################################################

sub name { return "single hash of lists"; }

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key = shift;
  die "$name requires key argument"  unless defined $key;

  my $ptr = $obj->{__hashoflists}{$obj->{__hashoflistsslot}{$name}}{$key};
  return defined $ptr ? @$ptr : ();
}

1;
