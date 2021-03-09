# Fieldhouse::Base
# Base class providing core class functionality.
# (Usually) the common superclass
##

package Fieldhouse::Base;
our $AUTOLOAD;  # it's a package global
our $CLASS = "Fieldhouse::Base";
use strict;
use Carp qw(cluck confess);
use Fieldhouse::Dispatchers::Scalar;
use Fieldhouse::Dispatchers::ListAccSingular;
use Fieldhouse::Dispatchers::ListAccPlural;
use Fieldhouse::Dispatchers::IndexedListSingular;
use Fieldhouse::Dispatchers::IndexedListPlural;
use Fieldhouse::Dispatchers::SingleHash;
use Fieldhouse::Dispatchers::DoubleHash;
use Fieldhouse::Dispatchers::TripleHash;
use Fieldhouse::Dispatchers::SingleHashOfListsSingular;
use Fieldhouse::Dispatchers::SingleHashOfListsPlural;
use Fieldhouse::Dispatchers::DoubleHashOfListsSingular;
use Fieldhouse::Dispatchers::DoubleHashOfListsPlural;
use Fieldhouse::Dispatchers::TripleHashOfListsSingular;
use Fieldhouse::Dispatchers::TripleHashOfListsPlural;
use Fieldhouse::Dispatchers::HashSet;

# Generic constructor
sub new {
  my $class = shift;
  # print "***** ", join(", ", @_), " *****\n";
  my $self = { __vars => {}, __listacc => {} };
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

sub initialize {
  my $self = shift;
  # $self->SUPER::initialize(@_);
}

sub declare_scalar {
  my $self = shift;
  my $field = shift;
  my $init = shift;
  $self->{__vars}{$field} = $init;

  my $prev = $self->{__dispatcher}{$field};
  confess ("Field name $field already in use (as " . ref($prev) . ")")
      if defined $prev;
  $self->{__dispatcher}{$field} = $Fieldhouse::Dispatchers::Scalar::INSTANCE;
}

sub declare_hash_set {
  my $self = shift;
  my $field = shift;
  my $plural = shift;
  $plural = $field . "s" unless defined $plural;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} = $Fieldhouse::Dispatchers::HashSet::INSTANCE;

  confess "Field name $plural already in use"
      if defined $self->{__dispatcher}{$plural};
  $self->{__dispatcher}{$plural} = $Fieldhouse::Dispatchers::HashSet::INSTANCE;

  $self->{__hashset}{$field} = {};
}

sub declare_list {
  my $self = shift;
  my $field = shift;
  my $init = shift;
  $init = [] unless defined $init;
  my $plural = shift;
  $plural = $field . "s" unless defined $plural;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} = $Fieldhouse::Dispatchers::ListAccSingular::INSTANCE;

  confess "Field name $plural already in use"
      if defined $self->{__dispatcher}{$plural};
  $self->{__dispatcher}{$plural} = $Fieldhouse::Dispatchers::ListAccPlural::INSTANCE;

  confess "Non-list $init used to initialize $plural\n"
      unless ref($init) eq 'ARRAY';

  $self->{__listaccs}{$field} = $init;
  $self->{__listaccslot}{$plural} = $field;
}

sub declare_indexed_list {
  my $self = shift;
  my $field = shift;

  my %namedArgs = (@_);
  my $indexer = $namedArgs{indexer};
  my $init = $namedArgs{init};
  $init = [] unless defined $init;
  my $plural = $namedArgs{plural};
  $plural = $field . "s" unless defined $plural;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} =
      $Fieldhouse::Dispatchers::IndexedListSingular::INSTANCE;

  confess "Field name $plural already in use"
      if defined $self->{__dispatcher}{$plural};
  $self->{__dispatcher}{$plural} =
      $Fieldhouse::Dispatchers::IndexedListPlural::INSTANCE;

  $self->{__idxlist}{$field} = $init;
  $self->{__idxlistindexer}{$field} = $indexer;
  $self->{__idxlistpl}{$plural} = $field;

  my $index = {};
  foreach my $item (@$init) {
    $index->{&$indexer($item)} = $item;
  }
  $self->{__idxlistindex}{$field} = $index;
}

sub declare_hash {
  my $self = shift;
  my $field = shift;
  my $init = shift;
  $init = {} unless defined $init;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} =
      $Fieldhouse::Dispatchers::SingleHash::INSTANCE;

  $self->{__snghash}{$field} = $init;
}

sub declare_dblhash {
  my $self = shift;
  my $field = shift;
  my $init = shift;
  $init = {} unless defined $init;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} =
      $Fieldhouse::Dispatchers::DoubleHash::INSTANCE;

  $self->{__dblhash}{$field} = $init;
}

sub declare_triplehash {
  my $self = shift;
  my $field = shift;
  my $init = shift;
  $init = {} unless defined $init;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} =
      $Fieldhouse::Dispatchers::TripleHash::INSTANCE;

  $self->{__triplehash}{$field} = $init;
}

sub declare_hash_of_lists {
  my $self = shift;
  my $field = shift;
  my $plural = shift;
  $plural = $field . "s" unless defined $plural;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} =
      $Fieldhouse::Dispatchers::SingleHashOfListsSingular::INSTANCE;

  confess "Field name $plural already in use"
      if defined $self->{__dispatcher}{$plural};
  $self->{__dispatcher}{$plural} =
      $Fieldhouse::Dispatchers::SingleHashOfListsPlural::INSTANCE;

  # printf("++ $field -- %s\n",  dbgStr($self->{__dispatcher}{$field}));
  # printf("++ $plural -- %s\n", dbgStr($self->{__dispatcher}{$plural}));

  $self->{__hashoflists}{$field} = {};
  $self->{__hashoflistsslot}{$plural} = $field;
}

sub declare_hash_of_hashsets {
  my $self = shift;
  my $field = shift;
  my $plural = shift;
  $plural = $field . "s" unless defined $plural;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} =
      $Fieldhouse::Dispatchers::SingleHashOfListsSingular::INSTANCE;

  confess "Field name $plural already in use"
      if defined $self->{__dispatcher}{$plural};
  $self->{__dispatcher}{$plural} =
      $Fieldhouse::Dispatchers::SingleHashOfListsPlural::INSTANCE;

  # printf("++ $field -- %s\n",  dbgStr($self->{__dispatcher}{$field}));
  # printf("++ $plural -- %s\n", dbgStr($self->{__dispatcher}{$plural}));

  $self->{__hashoflists}{$field} = {};
  $self->{__hashoflistsslot}{$plural} = $field;
}

sub declare_dblhash_of_lists {
  my $self = shift;
  my $field = shift;
  my $plural = shift;
  $plural = $field . "s" unless defined $plural;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} =
      $Fieldhouse::Dispatchers::DoubleHashOfListsSingular::INSTANCE;

  confess "Field name $plural already in use"
      if defined $self->{__dispatcher}{$plural};
  $self->{__dispatcher}{$plural} =
      $Fieldhouse::Dispatchers::DoubleHashOfListsPlural::INSTANCE;

  $self->{__dblhashoflists}{$field} = {};
  $self->{__dblhashoflistsslot}{$plural} = $field;
}

sub declare_triplehash_of_lists {
  my $self = shift;
  my $field = shift;
  my $plural = shift;
  $plural = $field . "s" unless defined $plural;

  confess "Field name $field already in use"
      if defined $self->{__dispatcher}{$field};
  $self->{__dispatcher}{$field} =
      $Fieldhouse::Dispatchers::TripleHashOfListsSingular::INSTANCE;

  confess "Field name $plural already in use"
      if defined $self->{__dispatcher}{$plural};
  $self->{__dispatcher}{$plural} =
      $Fieldhouse::Dispatchers::TripleHashOfListsPlural::INSTANCE;

  $self->{__triplehashoflists}{$field} = {};
  $self->{__triplehashoflistsslot}{$plural} = $field;
}

#################################################################

sub enter_scope_for {
  my $self = shift;
  my $field = shift;
  my $hasInit = $#_ >= 0;
  my $init = shift;

  if (exists $self->{__vars}{$field}) {
    push @{$self->{__scopestack}{$field}}, $self->{__vars}{$field};
    $self->{__vars}{$field}=$init if $hasInit;
  } else {
    confess "No scoping for $field";
  }
}

sub exit_scope_for {
  my $self = shift;
  my $field = shift;
  my $init = shift;

  if (exists $self->{__vars}{$field}) {
    confess "No scope to exit for $field"
        unless (exists $self->{__scopestack}{$field}
                && $#{$self->{__scopestack}{$field}} > -1);
    $self->{__vars}{$field} = pop @{$self->{__scopestack}{$field}};
    delete $self->{__scopestack}{$field} if $#{$self->{__scopestack}{$field}}<0;
  } else {
    confess "No scoping for $field";
  }
}

sub enter_scope {
  my $self = shift;
  foreach my $field (keys %{$self->{__vars}}) {
    $self->enter_scope_for($field);
  }
}

sub exit_scope {
  my $self = shift;
  foreach my $field (keys %{$self->{__vars}}) {
    $self->exit_scope_for($field);
  }
}

#################################################################

sub DESTROY {
  # Nothing really to do here
}

# Provide all accessors and mutators transparently based on the
# declared fields
sub AUTOLOAD {
  my $self = shift;
  return if $AUTOLOAD =~ /::DESTROY$/;
  my $type = ref($self);

  $AUTOLOAD =~ /.*::(\w+)$/;
  my $methodName = $1;
  if (defined $methodName) {
    if ($methodName =~ /^(.+)_ref$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (${methodName}_ref) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->reference($self, $1, @_);
    } elsif ($methodName =~ /^clear_(.+)$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (clear_${methodName}) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->clear($self, $1, @_);
    } elsif ($methodName =~ /^(.+)_empty$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (${methodName}_empty) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->empty($self, $1, @_);
    } elsif ($methodName =~ /^incr_(.+)$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (incr_${methodName}) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->incr($self, $1, @_);
    } elsif ($methodName =~ /^(.+)_keys$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (${methodName}_keys) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->keyList($self, $1, @_);
    } elsif ($methodName =~ /^(.+)_size$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (${methodName}_size) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->sizeOf($self, $1, @_);
    } elsif ($methodName =~ /^delete_(.+)_key$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (delete_${methodName}_key) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->deleteKey($self, $1, @_);
    } elsif ($methodName =~ /^push_(.+)_keyed$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (push_${methodName}_keyed) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->pushKeyed($self, $1, @_);
    } elsif ($methodName =~ /^unshift_(.+)_keyed$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (unshift_${methodName}_keyed) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->unshiftKeyed($self, $1, @_);
    } elsif ($methodName =~ /^push_(.+)$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (push_$1) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->push($self, $1, @_);
    } elsif ($methodName =~ /^unshift_(.+)$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (unshift_$1) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->unshift($self, $1, @_);
    } elsif ($methodName =~ /^__(.+)$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName (__${methodName}) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->doubleUnderscore($self, $1, @_);
    } elsif ($methodName =~ /^(.+)_maxIndex$/) {
      my $dispatcher = $self->{__dispatcher}{$1};
      confess ("No dispatcher for $methodName ($1_maxIndex) on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->maxIndex($self, $1, @_);
    } else {
      my $dispatcher = $self->{__dispatcher}{$methodName};
      confess ("No dispatcher for $methodName on ".ref($self))
          unless defined $dispatcher;
      return $dispatcher->bare($self, $methodName, @_);
    }
  } else {
    cluck("No such method $methodName");
    confess (ref($self) . qq(: no such method $methodName));
  }
}

#################################################################

sub dbgStr {
  my $arg = shift;
  return defined $arg ? $arg : 'undef';
}


1;

__END__

=head1 Introduction

The Fieldhouse is a small framework for managing accessor/mutator
methods in object-oriented Perl.  The base class provided by
Fieldhouse allows its subclasses to declare instance-based storage of
various shapes (scalars, lists, hashtables, hashtables mapping to
lists, and so on), with a variety accessor and mutator methods
automatically defined through Perl's C<AUTOLOAD> method.

There are probably better and more sensible approaches to this
problem, but I did not know about them when I started cobbling this
project together.  Now it has grown a bit, I use it in most of the
Perl utilities I write for myself, and finding and converting to some
allegedly better and more sensible approach just does not seem worth
the effort: so here we are.

Unless you want to extend the beast, the only class you'll need is
C<Fieldhouse::Base>.  Its POD follows.

=head1 NAME

Fieldhouse::Base - A base class with dynamic declaration and management
of accessor and mutator methods for internal fields.

=head1 SYNOPSIS

  package My::Class;
  use Fieldhouse::Base;
  our @ISA = ("Fieldhouse::Base");

  sub initialize {
    my $self = shift;

    ## Don't omit superclass initialization.
    $self->SUPER::initialize(@_);

    ## Declare local methods
    $self->declare_scalar('simplevalue');
    $self->declare_list('listval');
    $self->declare_hash('hashval');
    $self->declare_hash_of_lists('listhash', undef,
                                             'listhashes');
  }

  sub method {
    my $self = shift;

    ## Using the scalar variable.
    $self->simplevalue(5);
    print $self->simplevalue, "\n\n";

    ## Using the list-based variable.
    $self->push_listval(5);
    $self->push_listval(6, 7);
    foreach my $val ($self->listvals) {
      print $val, " ";
    }
    print "\n\n";

    ## Using the hash-based variable.
    $self->hashval('a', 5);
    $self->hashval('b', 7);
    foreach my $k ($self->hashval_keys) {
      print $k, " -> ", $self->hashval($k), "\n";
    }
    print "\n\n";

    ## Using the hash-of-lists-based variable.
    $self->push_listhash('a', 5);
    $self->push_listhash('b', 7, 17, 717);
    foreach my $k ($self->hashval_keys) {
      print $k, " ->";
      foreach my $v (@{$self->hashvals($k)}) {
        print " ", $v;
      }
    }
    print "\n\n";
  }

=head1 DESCRIPTION

=head2 Initializing instances

The C<Fieldhouse::Base> class defines a C<new> method which should
not be overridden.  Instead, use the C<initialize> method (see
example above).  Always include the superclass method call, usually
first.

=head2 Types of local storage

=over

=item Scalar variables

These have no particular structure, just storing some value under a
method name.  Declare via:

    $self->declare_scalar(NAME, INITIAL_VALUE)

The second argument is optional. This declaration provides the
following methods:

=over

=item C<NAME()>

Returns the value stored in the scalar.

=item C<NAME(VALUE)>

Updates the value stored in the scalar.

=back

=item Hashtable-backed sets

Declare via:

    $self->declare_hash_set(NAME, PLURALNAME)

Only the first argument is required. The second argument should be a
string reflecting the plural of the name; by default an "s" is
appended to the name. This declaration provides the following methods:

=over

=item C<push_NAME(VALUE, ..., VALUE)>, C<unshift_NAME(VALUE, ..., VALUE)>

Adds the VALUEs to the set.

=item C<PLURALNAME()>

Returns the set of values as a list.

=item C<clear()>

Empties the set.

=item C<sizeOf()>, C<empty()>

Returns the number of elements in the set, or C<true> if the set is
empty.

=back

=item Lists

These have multiple values associated with them.  Declare via:

    $self->declare_list(NAME, INITIAL_VALUE, PLURALNAME)

Only the first argument is required. The second argument should be a
list. The third argument should be a string reflecting the plural of
the name; by default an "s" is appended to the name. This declaration
provides the following methods:

=over

=item C<push_NAME(VALUE, ..., VALUE)>, C<unshift_NAME(VALUE, ..., VALUE)>

Adds the VALUEs to the end (resp. beginning) of the list.

=item C<PLURALNAME()>

Returns the list of values.

=back

=item Indexed lists

A variation of lists which can also be accessed by a key extracted
from the list elements.

    $self->declare_indexed_list(NAME,
                                            indexer => INDEXER,
                                            init => INITIAL_VALUES,
                                            plural => PLURALNAME)

The C<INDEXER> is a function which takes a list element and returns
the key by which it should be accessed.  This function is optional,
but if it is omitted then the C<PUSH_> and C<UNSHIFT_> list functions
are not available.

In addition to the list methods, the following methods are available:

=over

=item C<NAME(KEY)>

Returns the value currently associated with KEY.

=item C<push_NAME_keyed(KEY, VALUE)>, C<unshift_NAME_keyed(KEY, VALUE)>

Adds C<VALUE> to the end (resp. beginning) of the list, where C<VALUE>
is indexed by C<KEY>.

=back

=item Hashtable

These provide a simple association with scalars.  Declare via:

    $self->declare_hash(NAME, INITAL_HASH)

Only the first argument is required. This declaration provides the
following methods:

=over

=item C<NAME(KEY)>

Returns the value currently associated with KEY.

=item C<NAME(KEY, VALUE)>

Sets KEY to be associated with VALUE.

=item C<NAME_keys()>

Returns the currently defined keys.

=item C<__NAME()>

Returns the hashtable implementing these methods. Be careful.

=back

=item Double hashtable

These provide a simple association with pairs of scalars.  Declare
via:

    $self->declare_dblhash(NAME, INITAL_DBL_HASH)

Only the first argument is required. This declaration provides the
following methods:

=over

=item C<NAME(KEY1,KEY2)>

Returns the value currently associated with KEY1,KEY2.

=item C<NAME(KEY1, KEY2, VALUE)>

Sets KEY1,KEY2 to be associated with VALUE.

=item C<NAME_keys()>

Returns the currently defined KEY1 values for the first key.

=item C<NAME_keys(KEY1)>

Returns the currently defined KEY2 values for the second key given the
first key value.

=item C<__NAME()>

Returns the hashtable implementing these methods. Be careful.

=back

=item Triple hashtable

Continuing the pattern of n-argument hashtables, now with three.

=item Hashtable of lists

These associate each key with multiple values.  Declare via:

    $self->declare_hash_of_lists(NAME, INITIAL_VALUE, PLURALNAME)

Only the first argument is required. The second argument should be a
hashtable.  The third argument should be a string reflecting the
plural of the name; by default an "s" is appended to the name. This
declaration provides the following methods:

This declaration provides the following methods:

=over

=item C<NAME_keys()>

Returns the keys in the top hashtable.

=item C<push_NAME(KEY, VALUE, ..., VALUE)>, C<unshift_NAME(KEY, VALUE, ..., VALUE)>

Adds the VALUEs to the end (resp. beginning) of the list indexed by KEY.

=item C<PLURALNAME(KEY)>

Returns the list of values associated with the key

=item C<__NAME()>

Returns the hashtable implementing these methods. Be careful.

=back

=back
