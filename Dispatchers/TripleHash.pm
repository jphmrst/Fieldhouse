# Fieldhouse::Dispatchers::TripleHash
#
# Dispatcher objects for base class core functionality.
##

package Fieldhouse::Dispatchers::TripleHash;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::TripleHash";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::TripleHash->new();

sub name { return "Three-key hashtable"; }

#################################################################

sub baseHashtable {
  shift;
  my $obj = shift;
  my $name = shift;
  return $obj->{__triplehash}{$name};
}

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;

  die "$name requires at least three key arguments"  if $#_ < 2;
  my $key1 = shift;
  my $key2 = shift;
  my $key3 = shift;
  my $val = shift;

  ## print "** triplehash lookup hash $name keys $key1,$key2,$key3 val $val\n";
  if (defined $val) {
    $obj->{__triplehash}{$name}{$key1}{$key2}{$key3} = $val;
    return $val;
  } else {
    return undef unless exists $obj->{__triplehash}{$name}{$key1};
    return $obj->{__triplehash}{$name}{$key1}{$key2}{$key3};
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

  ## Now we need to know how many keys we are given (1 or 2).
  my $key1 = shift;
  my $key2 = shift;

  ## If we are given no keys, we check the whole thing.
  ##
  if (!(defined $key1)) {
    foreach my $k1 (@ks) {
      my $subhash = $theHash->{$k1};
      foreach my $k2 (keys %$subhash) {
        my @subkeys = keys %{$subhash->{$k2}};
        return 0 if $#subkeys > -1;
      }
    }
    return 1;
  }

  ## If we are given one key but not the other, then we check that
  ## key's subhash only.
  ##
  elsif (!(defined $key2)) {
    my $subhash = $theHash->{$key1};
    foreach my $k2 (keys %$subhash) {
      my @subkeys = keys %{$subhash->{$k2}};
      return 0 if $#subkeys > -1;
    }
    return 1;
  }

  ## Else if we have two keys, then we check just whether those keys
  ## have any subkeys.
  ##
  else {
    my @subks = keys %{$theHash->{$key1}{$key2}};
    return $#subks < 0;
  }
}

sub keyList {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $basehash = $dispatcher->baseHashtable($obj, $name);

  if ($#_ > 0) {
    my $key1 = shift;
    my $key2 = shift;
    if (exists $basehash->{$key1}
        && ref($basehash->{$key1}) eq 'HASH'
        && exists $basehash->{$key1}{$key2}
        && ref($basehash->{$key1}{$key2}) eq 'HASH') {
      return keys %{$basehash->{$key1}{$key2}};
    } else {
      return ();
    }
  }

  elsif ($#_ == 0) {
    my $key1 = shift;
    if (exists $basehash->{$key1}
        && ref($basehash->{$key1}) eq 'HASH') {
      return keys %{$basehash->{$key1}};
    } else {
      return ();
    }
  }

  else {
    return keys %$basehash;
  }
}

sub deleteKey {
  my $dispatcher = shift;
  my $obj = shift;
  my $name = shift;
  my $basehash = $dispatcher->baseHashtable($obj, $name);

  ## There are three keys; delete the third one
  if ($#_ > 1) {
    my $key1 = shift;
    my $key2 = shift;
    my $key3 = shift;
    delete $basehash->{$key1}{$key2}{$key3};
  }

  ## There are two keys; delete the second one
  elsif ($#_ == 1) {
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

  ## There are two keys; count the inner-inner hash only
  if ($#_ == 1) {
    my $key1 = shift;
    my $key2 = shift;
    my @countKeys = keys %{$theHash->{$key1}{$key2}};
    $total += (1 + $#countKeys);
  }

  ## There is one key; count from the inner hash
  elsif ($#_ == 0) {
    my $key1 = shift;
    my $subhash = $theHash->{$key1};
    foreach my $k2 (keys %$subhash) {
      my @countKeys = keys %{$subhash->{$k2}};
      $total += (1 + $#countKeys);
    }
  }

  ## No keys; count from the top
  else {
    foreach my $k1 (@ks) {
      my $subhash = $theHash->{$k1};
      foreach my $k2 (keys %$subhash) {
        my @countKeys = keys %{$subhash->{$k2}};
        $total += (1 + $#countKeys);
      }
    }
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
