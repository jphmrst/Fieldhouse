package Fieldhouse::Dispatchers::IndexedListPlural;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::IndexedListPlural";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::IndexedListPlural->new();

sub name { return "plural name uses for a list accumulator"; }

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;
  return @{$obj->{__idxlist}{$obj->{__idxlistpl}{$name}}};
}

sub reference {
  shift;
  my $obj = shift;
  my $name = shift;
  warn "${name}_ref arguments ignored"  if $#_ >= 0;
  return $obj->{__idxlist}{$obj->{__idxlistpl}{$name}};
}

sub empty {
  shift;
  my $obj = shift;
  my $name = shift;
  return $#{$obj->{__idxlist}{$obj->{__idxlistpl}{$name}}}<0;
}

sub sizeOf {
  shift;
  my $obj = shift;
  my $name = shift;
  die "No implementation for $name on indexed lists";
  return 1+$#{$obj->{__idxlist}{$obj->{__idxlistpl}{$name}}};
}

1;
