# Fieldhouse::Dispatchers::DoubleHash
#
# Dispatcher objects for base class core functionality.
##

package Fieldhouse::Dispatchers::DoubleHash;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::DoubleHash";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::DoubleHash->new();

sub name { return "Double-key hashtable"; }

#################################################################

sub baseHashtable {
  shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__dblhash}{$name};
}

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;

  die "$name requires at least two arguments"  if $#_ < 1;
  my $key1 = shift;
  my $key2 = shift;
  my $val = shift;

  ## print "** dblhash lookup hash $name keys $key1,$key2 val $val\n";
  if (defined $val) {
    $obj->{__dblhash}{$name}{$key1}{$key2} = $val;
    return $val;
  } else {
    return undef unless exists $obj->{__dblhash}{$name}{$key1};
    return $obj->{__dblhash}{$name}{$key1}{$key2};
  }
}

sub empty {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;

  ## If there are no keys in the top-level hashtable, then the answer
  ## is that it's empty no matter what the question was.
  ##
  my $theHash = $dispatcher->baseHashtable($obj, $name);
  my @ks = keys %$theHash;
  return 1  if $#ks < 0;

  ## OK, we need to know the question.  If there is no key given, then
  ## we want to know if it's absolutely empty.
  ##
  if ($#_ < 0) {
    my $total=0;
    foreach my $k (@ks) {
      my $subhash = $theHash->{$k};
      my @subkeys = keys %$subhash;
      return 0 if $#subkeys > -1;
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

sub keyList {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $basehash = $dispatcher->baseHashtable($obj, $name);

  if ($#_ > -1) {
    my $key1 = shift;
    if (exists $basehash->{$key1}
        && ref($basehash->{$key1}) eq 'HASH') {
      return keys %{$basehash->{$key1}};
    } else {
      return ();
    }
  } else {
    return keys %$basehash;
  }
}

sub deleteKey {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $basehash = $dispatcher->baseHashtable($obj, $name);

  ## There are two keys; delete the second one
  if ($#_ > 0) {
    my $key1 = shift;
    my $key2 = shift;
    delete $basehash->{$key1}{$key2};
  }

  ## There is one key; delete it at the top level
  elsif ($#_ == 0) {
    my $key1 = shift;
    delete $basehash->{$key1};
  }

  ## No keys, but we need at least one
  else {
    die "delete-${name}-key requires at least one key";
  }

  return $obj;
}

sub sizeOf {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $theHash = $dispatcher->baseHashtable($obj, $name);
  my @ks = keys %$theHash;

  my $total=0;
  foreach my $k (@ks) {
    my $subhash = $theHash->{$k};
    my @subkeys = keys %$subhash;
    $total += (1 + $#subkeys);
  }
  return $total;
}

sub doubleUnderscore {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  return $dispatcher->baseHashtable($obj, $name);
}

1;
