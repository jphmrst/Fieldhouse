#!/usr/bin/env perl

use diagnostics; # this gives you more debugging information
use warnings;    # this warns you of bad practices
use strict;      # this prevents silly errors
use Carp;
use FindBin;
use Test::More qw( no_plan ); # for the is() and isnt() functions
use lib ("$FindBin::Bin/..");
use JM_Utils::TestClass;

#########################
## Scalars
##
my $tester = new JM_Utils::TestClass;
is($tester->intScalar, 4, 'Original stored int value');
is($tester->strScalar, "asdf", 'Original stored string value');
is($tester->undefScalar, undef, 'No original stored scalar value');

$tester->intScalar(5);
is($tester->intScalar, 5, 'Updated int value');

$tester->intScalar(10);
is($tester->intScalar, 10, 'Reset an int value');
$tester->incr_intScalar;
is($tester->intScalar, 11, 'Incremented int value');

$tester->strScalar("fdsa");
is($tester->strScalar, "fdsa", 'Updated string value');

$tester->undefScalar(-1);
is($tester->undefScalar, -1, 'Set a scalar value');

#########################
## List-valued
##
is($tester->listAcc_size, 0, 'Size of initialized-empty list');
ok(eq_array($tester->listAccs_ref, []), 'Underlying empty array');

$tester->push_listAcc(10);
is($tester->listAcc(0), 10, 'First pushed value');
is($tester->listAcc_size, 1,
   'Size of initialized-empty list plus one pushed on');

$tester->push_listAcc(20);
is($tester->listAcc_size, 2,
   'Size of initialized-empty list plus two pushed on');
is($tester->listAcc(0), 10, 'First pushed value after second pushed');
is($tester->listAcc(1), 20, 'Second pushed value');
$tester->incr_listAcc(1); ## In new part only
is($tester->listAcc(0), 10,
   'First pushed value not changed by incr of second');
is($tester->listAcc(1), 21, 'Second pushed value incr\'ed');

$tester->unshift_listAcc(30);
is($tester->listAcc(1), 10, 'First pushed value, now after unshift');
is($tester->listAcc(2), 21, 'Second pushed value, now after unshift');
is($tester->listAcc(0), 30, 'Unshifted 30 after two pushes');
ok(eq_array($tester->listAccs_ref, [30, 10, 21]),
   'Underlying array is now [30,10,21]');

# TODO Implement this
# $tester->maxIndex_listAcc;

#########################
## Indexed list
##
is($tester->idxList_size, 0, 'Size of initialized-empty indexed list');
# TODO unimplemented
# ok(eq_array($tester->idxList_ref, []),
#    'Underlying empty indexed list');

$tester->push_idxList(10);
is($tester->idxList_size, 1,
   'Size of initialized-empty list plus one pushed on');

$tester->push_idxList(20);
is($tester->idxList_size, 2,
   'Size of initialized-empty list plus two pushed on');

#########################
## Single hash table
##
is($tester->hashAcc_size, 0, 'Initially empty hashtable has size 0');
my @keySet = $tester->hashAcc_keys;
ok(eq_array(\@keySet, []), 'Initially empty hashtable has no keys');

$tester->hashAcc('aa', 12);
is($tester->hashAcc('aa'), 12, 'Have set aa -> 12');
@keySet = $tester->hashAcc_keys;
ok(eq_set(\@keySet, ['aa']), 'Hashtable has one key aa');

$tester->hashAcc('aa', 20);
is($tester->hashAcc('aa'), 20, 'Have reset aa -> 20');

$tester->hashAcc('bb', 30);
is($tester->hashAcc('bb'), 30, 'Have set bb -> 30');
is($tester->hashAcc('aa'), 20, 'Still have aa -> 20');
@keySet = $tester->hashAcc_keys;
ok(eq_set(\@keySet, ['aa', 'bb']), 'Hashtable has two keys aa, bb');

$tester->delete_hashAcc_key('aa');
is($tester->hashAcc('aa'), undef, 'No longer have binding for aa');
is($tester->hashAcc('bb'), 30, 'Still have bb -> 30');
@keySet = $tester->hashAcc_keys;
ok(eq_set(\@keySet, ['bb']), 'Hashtable now has one key bb');

#########################
## Double hash table
##
is($tester->dblhash_size, 0, 'Initially empty hashtable has size 0');
@keySet = $tester->dblhash_keys;
ok(eq_array(\@keySet, []), 'Initially empty hashtable has no keys');

$tester->dblhash('aa', 'mm', 12);
is($tester->dblhash('aa', 'mm'), 12, 'Have set aa,mm -> 12');
is($tester->dblhash_size, 1, 'Have 1 key now');
@keySet = $tester->dblhash_keys;
ok(eq_set(\@keySet, ['aa']), 'Hashtable has one key aa');
@keySet = $tester->dblhash_keys('aa');
ok(eq_set(\@keySet, ['mm']), 'Hashtable has one key within aa, mm');

$tester->dblhash('aa', 'pp', 42);
is($tester->dblhash('aa', 'pp'), 42, 'Have set aa,pp -> 42');
is($tester->dblhash_size, 2, 'Have 2 keys now');
@keySet = $tester->dblhash_keys;
ok(eq_set(\@keySet, ['aa']), 'Hashtable has one key aa');
@keySet = $tester->dblhash_keys('aa');
ok(eq_set(\@keySet, ['mm', 'pp']),
   'Hashtable has one key within aa, mm and pp');

$tester->dblhash('aa', 'mm', 20);
is($tester->dblhash('aa', 'mm'), 20, 'Have reset aa,mm -> 20');
is($tester->dblhash('aa', 'pp'), 42, 'Still have aa,pp -> 42');

$tester->dblhash('bb', 'nn', 30);
is($tester->dblhash('bb', 'nn'), 30, 'Have set bb,nn -> 30');
is($tester->dblhash('aa', 'mm'), 20, 'Still have aa,mm -> 20');
is($tester->dblhash_size, 3, 'Have 3 keys now');
@keySet = $tester->dblhash_keys;
ok(eq_set(\@keySet, ['aa', 'bb']), 'Hashtable has two keys aa, bb');
@keySet = $tester->dblhash_keys('aa');
ok(eq_set(\@keySet, ['mm', 'pp']),
   'Hashtable has two subkeys under aa, mm and pp');
@keySet = $tester->dblhash_keys('bb');
ok(eq_set(\@keySet, ['nn']), 'Hashtable has one subkey under bb, nn');

$tester->delete_dblhash_key('aa');
is($tester->dblhash('aa', 'mm'), undef, 'No longer have binding for aa,mm');
is($tester->dblhash('bb', 'nn'), 30, 'Still have bb,nn -> 30');
is($tester->dblhash_size, 1, 'Have 1 key now');
@keySet = $tester->dblhash_keys;
ok(eq_set(\@keySet, ['bb']), 'Hashtable now has one key bb');
@keySet = $tester->dblhash_keys('bb');
ok(eq_set(\@keySet, ['nn']), 'Hashtable still has one subkey under bb, nn');

#########################
## Triple hash table --- this one just lightly tested, should have
## more
##
is($tester->trihash_size, 0, 'Initially empty triple hashtable has size 0');
@keySet = $tester->trihash_keys;
ok(eq_array(\@keySet, []), 'Initially empty triple hashtable has no keys');

$tester->trihash('aa', 'mm', 'xx', 12);
is($tester->trihash('aa', 'mm', 'xx'), 12, 'Have set aa,mm,xx -> 12');
is($tester->trihash_size, 1, 'Have 1 entry total now');
@keySet = $tester->trihash_keys;
ok(eq_set(\@keySet, ['aa']), 'Hashtable has one key aa');
is($tester->trihash_size('aa'), 1, 'Have 1 key under aa now');
@keySet = $tester->trihash_keys('aa');
ok(eq_set(\@keySet, ['mm']), 'Hashtable has one key within aa: mm');
is($tester->trihash_size('aa', 'mm'), 1, 'Have 1 key under aa,mm now');
@keySet = $tester->trihash_keys('aa', 'mm');
ok(eq_set(\@keySet, ['xx']), 'Hashtable has one key within aa,mm: xx');

$tester->trihash('aa', 'pp', 'yy', 42);
is($tester->trihash('aa', 'pp', 'yy'), 42, 'Have set aa,pp,yy -> 42');
is($tester->trihash_size, 2, 'Have 2 keys now');
@keySet = $tester->trihash_keys;
ok(eq_set(\@keySet, ['aa']), 'Hashtable has one key aa');
@keySet = $tester->trihash_keys('aa');
ok(eq_set(\@keySet, ['mm', 'pp']),
   'Hashtable has two keys within aa, mm and pp');

$tester->trihash('aa', 'mm', 'xx', 20);
is($tester->trihash('aa', 'mm', 'xx'), 20, 'Have reset aa,mm,xx -> 20');
is($tester->trihash('aa', 'pp', 'yy'), 42, 'Still have aa,pp,yy -> 42');

$tester->trihash('bb', 'nn', 'zz', 30);
is($tester->trihash('bb', 'nn', 'zz'), 30, 'Have set bb,nn -> 30');
is($tester->trihash('aa', 'mm', 'xx'), 20, 'Still have aa,mm -> 20');
is($tester->trihash_size, 3, 'Have 3 keys now');
@keySet = $tester->trihash_keys;
ok(eq_set(\@keySet, ['aa', 'bb']), 'Hashtable has two keys aa, bb');
@keySet = $tester->trihash_keys('aa');
ok(eq_set(\@keySet, ['mm', 'pp']),
   'Hashtable has two subkeys under aa, mm and pp');
@keySet = $tester->trihash_keys('bb');
ok(eq_set(\@keySet, ['nn']), 'Hashtable has one subkey under bb, nn');

$tester->delete_trihash_key('aa');
is($tester->trihash('aa', 'mm', 'xx'), undef, 'No longer have binding for aa,mm');
is($tester->trihash('bb', 'nn', 'zz'), 30, 'Still have bb,nn -> 30');
is($tester->trihash_size, 1, 'Have 1 key now');
@keySet = $tester->trihash_keys;
ok(eq_set(\@keySet, ['bb']), 'Hashtable now has one key bb');
@keySet = $tester->trihash_keys('bb');
ok(eq_set(\@keySet, ['nn']), 'Hashtable still has one subkey under bb, nn');

#########################
## Single hash of lists
##
is($tester->listHash_size, 0, 'Initially empty hash-of-lists has size 0');
@keySet = $tester->listHash_keys;
ok(eq_array(\@keySet, []), 'Initially empty hash-of-lists has no keys');

$tester->push_listHash('aa', 10);
is($tester->listHash('aa', 0), 10, 'First pushed value');
is($tester->listHash_size, 1,
   'Size of initialized-empty hash-of-lists plus one pushed on');
is($tester->listHash_size('aa'), 1,
   'Size of entry in initialized-empty hash-of-lists plus one pushed on');

$tester->push_listHash('aa', 20);
is($tester->listHash_size, 1,
   'Size of hash-of-lists with two pushed under same key');
is($tester->listHash_size('aa'), 2,
   'Size of hash-of-lists key with two pushed under same that key');
is($tester->listHash('aa', 0), 10, 'First pushed value, after second pushed');
is($tester->listHash('aa', 1), 20, 'Second pushed value');

$tester->incr_listHash('aa', 1);
is($tester->listHash('aa', 0), 10,
   'First pushed value not changed by incr of second');
is($tester->listHash('aa', 1), 21, 'Second pushed value incr\'ed');

$tester->unshift_listHash('bb', 30);
is($tester->listHash('bb', 0), 30, 'Single value under second key');
is($tester->listHash('aa', 0), 10, 'First value under first key');
is($tester->listHash('aa', 1), 21, 'Second value under first key');

$tester->unshift_listHash('aa', 40);
is($tester->listHash('bb', 0), 30, 'Single value under second key');
is($tester->listHash('aa', 0), 40, 'Unshifted value under first key');
is($tester->listHash('aa', 1), 10, 'First old pushed value under first key');
is($tester->listHash('aa', 2), 21, 'Second old pushed value under first key');


#########################
## Double hash of lists
##
is($tester->listDblHash_size, 0, 'Initial double-hash-of-lists has size 0');
@keySet = $tester->listDblHash_keys;
ok(eq_array(\@keySet, []), 'Initial double-hash-of-lists has no keys');

$tester->push_listDblHash('aa', 'mm', 10);
is($tester->listDblHash('aa', 'mm', 0), 10, 'First pushed value');
is($tester->listDblHash_size, 1,
   'Size of new double-hash-of-lists plus one pushed on');
is($tester->listDblHash_size('aa'), 1,
   'Size of entry in new double-hash-of-lists plus one pushed on');

$tester->push_listDblHash('aa', 'mm', 20);
is($tester->listDblHash_size, 2,
   'Size of double-hash-of-lists with two pushed under same key');
is($tester->listDblHash_size('aa'), 2,
   'Size of double-hash-of-lists key with two pushed under same that key');
is($tester->listDblHash('aa', 'mm', 0), 10,
   'First pushed value, after second pushed');
is($tester->listDblHash('aa', 'mm', 1), 20, 'Second pushed value');

$tester->incr_listDblHash('aa', 'mm', 1);
is($tester->listDblHash('aa', 'mm', 0), 10,
   'First pushed value not changed by incr of second');
is($tester->listDblHash('aa', 'mm', 1), 21, 'Second pushed value incr\'ed');

$tester->unshift_listDblHash('bb', 'ss', 30);
is($tester->listDblHash('bb', 'ss', 0), 30, 'Single value under second key');
is($tester->listDblHash('aa', 'mm', 0), 10, 'First value under first key');
is($tester->listDblHash('aa', 'mm', 1), 21, 'Second value under first key');

$tester->unshift_listDblHash('aa', 'mm', 40);
is($tester->listDblHash('bb', 'ss', 0), 30, 'Single value under second key');
is($tester->listDblHash('aa', 'mm', 0), 40, 'Unshifted value under first key');
is($tester->listDblHash('aa', 'mm', 1), 10,
   'First old pushed value under first key');
is($tester->listDblHash('aa', 'mm', 2), 21,
   'Second old pushed value under first key');

# TODO Implement this
# $tester->maxIndex_listDblHash

## TODO Tests on a single hash of lists

## TODO Tests on a double hash of lists

exit 0;

