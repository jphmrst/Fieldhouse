# Introduction

The Fieldhouse is a small framework for managing accessor/mutator
methods in object-oriented Perl.  The base class provided by
Fieldhouse allows its subclasses to declare instance-based storage of
various shapes (scalars, lists, hashtables, hashtables mapping to
lists, and so on), with a variety accessor and mutator methods
automatically defined through Perl's `AUTOLOAD` method.

There are probably better and more sensible approaches to this
problem, but I did not know about them when I started cobbling this
project together.  Now it has grown a bit, I use it in most of the
Perl utilities I write for myself, and finding and converting to some
allegedly better and more sensible approach just does not seem worth
the effort: so here we are.

Unless you want to extend the beast, the only class you'll need is
`Fieldhouse::Base`.  Its POD follows.

# NAME

Fieldhouse::Base - A base class with dynamic declaration and management
of accessor and mutator methods for internal fields.

# SYNOPSIS

```perl
package My::Class;
use Fieldhouse::Base;
our @ISA = ("Fieldhouse::Base");

sub initialize {
  my $self = shift;

  ## Don't omit superclass initialization.
  $self->SUPER::initialize(@_);

  ## Declare local methods
  $self->declare_scalar_variable('simplevalue');
  $self->declare_list_accumulator('listval');
  $self->declare_hash_accumulator('hashval');
  $self->declare_hash_of_lists_accumulator('listhash', undef,
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
```

# DESCRIPTION

## Initializing instances

The `Fieldhouse::Base` class defines a `new` method which should
not be overridden.  Instead, use the `initialize` method (see
example above).  Always include the superclass method call, usually
first.

## Types of local storage

- Scalar variables

    These have no particular structure, just storing some value under a
    method name.  Declare via:

    - `$self-`declare\_scalar\_variable(NAME, INITIAL\_VALUE)>

    The second argument is optional. This declaration provides the
    following methods:

    - `NAME()`

        Returns the value stored in the scalar.

    - `NAME(VALUE)`

        Updates the value stored in the scalar.

- Lists

    These have multiple values associated with them.  Declare via:

    - `$self-`declare\_list\_accumulator(NAME, INITIAL\_VALUE, PLURALNAME)>

    Only the first argument is required. The second argument should be a
    list. The third argument should be a string reflecting the plural of
    the name; by default an "s" is appended to the name. This declaration
    provides the following methods:

    - `push_NAME(VALUE, ..., VALUE)`, `unshift_NAME(VALUE, ..., VALUE)`

        Adds the VALUEs to the end (resp. beginnig) of the list.

    - `PLURALNAME()`

        Returns the list of values.

- Indexed lists

    A variation of lists which can also be accessed by a key extracted
    from the list elements.

    - `$self-`declare\_indexed\_list\_accumulator(NAME, indexer => INDEXER, init => INITIAL\_VALUES, plural => PLURALNAME)>

        The `INDEXER` is a function which takes a list element and returns
        the key by which it should be accessed.  This function is optional,
        but if it is omitted then the `PUSH_` and `UNSHIFT_` list functions
        are not available.

    In addition to the list methods, the following methods are available:

    - `NAME(KEY)`

        Returns the value currently associated with KEY.

    - `push_NAME_keyed(KEY, VALUE)`, `unshift_NAME_keyed(KEY, VALUE)`

        Adds `VALUE` to the end (resp. beginning) of the list, where `VALUE`
        is indexed by `KEY`.

- Hashtable

    These provide a simple association with scalars.  Declare via:

    - `$self-`declare\_hash\_accumulator(NAME, INITAL\_HASH)>

    Only the first argument is required. This declaration provides the
    following methods:

    - `NAME(KEY)`

        Returns the value currently associated with KEY.

    - `NAME(KEY, VALUE)`

        Sets KEY to be associated with VALUE.

    - `NAME_keys()`

        Returns the currently defined keys.

    - `__NAME()`

        Returns the hashtable implementing these methods. Be careful.

- Double hashtable

    These provide a simple association with pairs of scalars.  Declare
    via:

    - `$self-`declare\_dblhash\_accumulator(NAME, INITAL\_DBL\_HASH)>

    Only the first argument is required. This declaration provides the
    following methods:

    - `NAME(KEY1,KEY2)`

        Returns the value currently associated with KEY1,KEY2.

    - `NAME(KEY1, KEY2, VALUE)`

        Sets KEY1,KEY2 to be associated with VALUE.

    - `NAME_keys()`

        Returns the currently defined KEY1 values for the first key.

    - `NAME_keys(KEY1)`

        Returns the currently defined KEY2 values for the second key given the
        first key value.

    - `__NAME()`

        Returns the hashtable implementing these methods. Be careful.

- Triple hashtable

    Continuing the pattern of n-argument hashtables, now with three.

- Hashtable of lists

    These associate each key with multiple values.  Declare via:

    - `$self-`declare\_hash\_of\_lists\_accumulator(NAME, INITIAL\_VALUE, PLURALNAME)>

    Only the first argument is required. The second argument should be a
    hashtable. The third argument should be a string reflecting the plural
    of the name; by default an "s" is appended to the name. This
    declaration provides the following methods:

    This declaration provides the following methods:

    - `NAME_keys()`

        Returns the keys in the top hashtable.

    - `push_NAME(KEY, VALUE, ..., VALUE)`, `unshift_NAME(KEY, VALUE, ..., VALUE)`

        Adds the VALUEs to the end (resp. beginning) of the list indexed by KEY.

    - `PLURALNAME(KEY)`

        Returns the list of values associated with the key

    - `__NAME()`

        Returns the hashtable implementing these methods. Be careful.
