# Fieldhouse::Dispatchers::DoubleHashOfListsSingular
#
# DoubleHashOfListsSingular objects for base class core functionality.
##

package Fieldhouse::Dispatchers::DoubleHashOfListsSingular;
use Fieldhouse::Base;
use strict;
use Carp;

our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::DoubleHashOfListsSingular";
our @ISA = ("Fieldhouse::Dispatchers::DoubleHash");
our $INSTANCE = new Fieldhouse::Dispatchers::DoubleHashOfListsSingular;

#################################################################

sub name { return "double hash of lists"; }

sub baseHashtable {
  shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__dblhashoflists}{$name};
}

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;

  die "$name requires at least three arguments"  if $#_ < 2;
  my $key1 = shift;
  my $key2 = shift;
  my $idx = shift;
  my $val = shift;

  ## print "** dblhash lookup hash $name keys $key1,$key2 val $val\n";
  if (defined $val) {
    $obj->{__dblhash}{$name}{$key1}{$key2} = $val;
    return $val;
  } else {
    return undef
        unless (exists $obj->{__dblhashoflists}{$name}{$key1}
                && exists $obj->{__dblhashoflists}{$name}{$key1}{$key2}
                && exists $obj->{__dblhashoflists}{$name}{$key1}{$key2}[$idx]);
    return $obj->{__dblhashoflists}{$name}{$key1}{$key2}[$idx];
  }
}

sub empty {
  shift;
  my $obj = shift;
  my $name = shift;

  ## If there are no keys in the top-level hashtable, then the answer
  ## is that it's empty no matter what the question was.
  ##
  my $theHash = $obj->{__dblhashoflists}{$name};
  my @ks = keys %$theHash;
  return 1  if $#ks < 0;

  ## OK, we need to know the question.  If there is no key given, then
  ## we want to know if it's absolutely empty.
  ##
  if ($#_ < 0) {
    my $total=0;
    foreach my $k (@ks) {
      my $subhash = $theHash->{$k};
      foreach my $subkey (keys %$subhash) {
        my $arr = $subhash->{$subkey};
        return 0  if defined $arr && $#{$arr} > -1;
      }
    }

    return 1;
  }

  ## Else if we have a key, then we check just whether that key has
  ## any subkeys.
  ##
  else {
    my $key = shift;
    my @subks = keys %{$theHash->{$key}};
    return $#subks < 0;
  }
}

sub incr {
  shift;
  my $obj = shift;
  my $name = shift;
  my $key1 = shift;
  my $key2 = shift;
  my $index = shift;
  die "${name}_incr requires two key and one index arguments, plus optional delta"
      unless defined $key1 && defined $key2 && defined $index;
  my $delta = shift;
  $delta = 1  unless defined $delta;

  $obj->{__dblhashoflists}{$name}{$key1}{$key2}[$index] += $delta;
  return $obj->{__dblhashoflists}{$name}{$key1}{$key2}[$index];
}

sub push {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "push_$name requires two keys plus at least one argument"  if $#_ < 2;
  my $key1 = shift;
  my $key2 = shift;
  push @{$obj->{__dblhashoflists}{$name}{$key1}{$key2}}, @_;
  return $obj;
}

sub unshift {
  my $self = shift;
  my $obj = shift;
  my $name = shift;
  die "unshift_$name requires two keys plus at least one argument"  if $#_ < 2;
  my $key1 = shift;
  my $key2 = shift;
  unshift @{$obj->{__dblhashoflists}{$name}{$key1}{$key2}}, @_;
  return $obj;
}

sub sizeOf {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $theHash = $obj->{__dblhashoflists}{$name};
  my @ks = keys %$theHash;

  my $key1 = shift;
  my $key2 = shift;

  if (defined $key2) {
    return 1+$#{$theHash->{$key1}{$key2}};
  }

  elsif (defined $key1) {
    my $total=0;
    my $subhash = $theHash->{$key1};
    foreach my $subkey (keys %$subhash) {
      $total += ($#{$subhash->{$subkey}} + 1);
    }
    return $total;
  }

  else {
    my $total=0;
    foreach my $k (@ks) {
      my $subhash = $theHash->{$k};
      foreach my $subkey (keys %$subhash) {
        $total += ($#{$subhash->{$subkey}} + 1);
      }
    }
    return $total;
  }
}

1;
