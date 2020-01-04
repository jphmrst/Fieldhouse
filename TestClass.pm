package JM_Utils::TestClass;
use Fieldhouse::Base;
our $CLASS = "JM_Utils::TestClass";
our @ISA = ("Fieldhouse::Base");

sub initialize {
  my $self = shift;
  $self->SUPER::initialize(@_);
  $self->declare_scalar_variable('intScalar', 4);
  $self->declare_scalar_variable('strScalar', "asdf");
  $self->declare_scalar_variable('undefScalar');
  $self->declare_list_accumulator('listAcc');
  $self->declare_indexed_list_accumulator('idxList',
                                          indexer => sub {
                                            my $val = shift;
                                            return 1000+$val;
                                          });
  $self->declare_hash_accumulator('hashAcc');
  $self->declare_dblhash_accumulator('dblhash');
  $self->declare_hash_of_lists_accumulator('listHash');
  $self->declare_dblhash_of_lists_accumulator('listDblHash');
  $self->declare_triplehash_accumulator('trihash');
}

1;
