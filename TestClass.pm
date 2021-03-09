package Fieldhouse::TestClass;
use Fieldhouse::Base;
our $CLASS = "Fieldhouse::TestClass";
our @ISA = ("Fieldhouse::Base");

sub initialize {
  my $self = shift;
  $self->SUPER::initialize(@_);
  $self->declare_scalar('intScalar', 4);
  $self->declare_scalar('strScalar', "asdf");
  $self->declare_scalar('undefScalar');
  $self->declare_list('listAcc');
  $self->declare_indexed_list('idxList',
                                          indexer => sub {
                                            my $val = shift;
                                            return 1000+$val;
                                          });
  $self->declare_hash('hashAcc');
  $self->declare_dblhash('dblhash');
  $self->declare_hash_of_lists('listHash');
  $self->declare_dblhash_of_lists('listDblHash');
  $self->declare_triplehash('trihash');
}

1;
