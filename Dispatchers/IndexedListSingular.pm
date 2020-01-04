package Fieldhouse::Dispatchers::IndexedListSingular;
use Fieldhouse::Dispatchers::Dispatcher;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Dispatchers::IndexedListSingular";
our @ISA = ("Fieldhouse::Dispatchers::Dispatcher");
use strict;
our $INSTANCE = Fieldhouse::Dispatchers::IndexedListSingular->new();

sub name { return "singular name uses for a list accumulator"; }

sub keyList {
  shift;
  my $obj = shift;
  my $name = shift;

  ## If we have an indexer, then we return the keys in the right
  ## order instead of using keys.
  if (defined $obj->{__idxlistindexer}{$name}) {
    my $indexer = $obj->{__idxlistindexer}{$name};
    my @result = ();
    foreach my $item (@{$obj->{__idxlist}{$name}}) {
      push @result, &$indexer($item);
    }
    return @result;
  } else {
    return keys %{$obj->{__idxlistindex}{$name}};
  }
}

sub bare {
  shift;
  my $obj = shift;
  my $name = shift;

  die "$AUTOLOAD requires one argument"  if $#_ != 0;
  my $key = shift;
  my $val = $obj->{__idxlistindex}{$name}{$key};
  # print "** idxlist lookup hash $name key $key val $val\n";
  return $val;
}

sub sizeOf {
  shift;
  my $obj = shift;
  my $name = shift;
  return 1+$#{$obj->{__idxlist}{$name}};
}

sub push {
  shift;
  my $obj = shift;
  my $field = shift;

  die "push_$field requires at least one argument"  if $#_ < 0;
  my $indexer = $obj->{__idxlistindexer}{$field};
  die "push_$field requires an indexer"  unless defined $indexer;
  push @{$obj->{__idxlist}{$field}}, @_;
  foreach my $item (@_) {
    my $key = &$indexer($item);
    ## print "++ $key -> $item\n";
    $obj->{__idxlistindex}{$field}{$key} = $item;
  }
  return $obj;
}

sub pushKeyed {
  shift;
  my $obj = shift;
  my $field = shift;

  die "push_${field}_keyed requires two arguments"  if $#_ != 1;
  my $key = shift;
  my $value = shift;
  CORE::push @{$obj->{__idxlist}{$field}}, $value;
  $obj->{__idxlistindex}{$field}{$key} = $value;
  return $obj;
}

sub unshift {
  shift;
  my $obj = shift;
  my $field = shift;

  die "unshift_$field requires at least one argument"  if $#_ < 0;
  my $indexer = $obj->{__idxlistindexer}{$field};
  die "unshift_$field requires an indexer"  unless defined $indexer;
  CORE::unshift @{$obj->{__idxlist}{$field}}, @_;
  foreach my $item (@_) {
    my $key = &$indexer($item);
    $obj->{__idxlistindex}{$field}{$key} = $item;
  }
  return $obj;
}

1;
