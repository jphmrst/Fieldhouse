# Fieldhouse::Dispatchers::XHashOfLists
#
# Common helper methods for hashtables referring to lists.
##

package Fieldhouse::Dispatchers::XHashOfLists;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::XHashOfLists";

sub isHash4EmptyLists {
  my $self = shift;
  my $hash = shift;
  return $self->hash4ListsSize($hash) == 0;
}

sub isHash3EmptyLists {
  my $self = shift;
  my $hash = shift;
  return $self->hash3ListsSize($hash) == 0;
}

sub isHash2EmptyLists {
  my $self = shift;
  my $hash = shift;
  return $self->hash2ListsSize($hash) == 0;
}

sub isHash1EmptyLists {
  my $self = shift;
  my $hash = shift;
  return $self->hash1ListsSize($hash) == 0;
}

sub hash4ListsSize {
  my $self = shift;
  my $hash = shift;
  my $total = 0;
  if (defined $hash) {
    foreach my $key (keys %$hash) {
      $total += $self->hash3ListsSize($hash->{$key});
    }
  }
  return $total;
}

sub hash3ListsSize {
  my $self = shift;
  my $hash = shift;
  my $total = 0;
  if (defined $hash) {
    foreach my $key (keys %$hash) {
      $total += $self->hash2ListsSize($hash->{$key});
    }
  }
  return $total;
}

sub hash2ListsSize {
  my $self = shift;
  my $hash = shift;
  my $total = 0;
  if (defined $hash) {
    foreach my $key (keys %$hash) {
      $total += $self->hash1ListsSize($hash->{$key});
    }
  }
  return $total;
}

sub hash1ListsSize {
  my $self = shift;
  my $hash = shift;
  my $total = 0;
  if (defined $hash) {
    foreach my $key (keys %$hash) {
      $total += 1 + $#{$hash->{$key}}  if defined $hash->{$key};
    }
  }
  return $total;
}

sub listSizeSafe {
  my $self = shift;
  my $list = shift;
  return 0 unless defined $list;
  return 1+$#{$list};
}
