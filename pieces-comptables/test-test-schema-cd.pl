#!/usr/bin/perl
# vim: ts=8 sts=4 et sw=4 sr sta
# GW
use strict;
use warnings;
 
# load the module that provides all of the common test functionality
use Test::DBIx::Class::Schema;
 
# create a new test object
my $schematest = Test::DBIx::Class::Schema->new(
    {
        # required
        dsn       => 'dbi:SQLite:pieces-comptables.db', # or use schema option
        namespace => 'Piecescomptables::Schema',
        moniker   => 'Piececomptable',
        # optional
        username  => '',
        password  => '',
        glue      => 'Result',             # fix class name if needed
        # rather than calling diag will test that all columns/relationships
        # are accounted for in your test and fail the test if not
        test_missing => 1,
    }
);
 
# tell it what to test
$schematest->methods(
    {
        columns => [
            qw[
                piececomptable_id
                piececomptable_md5
            ]
        ],
 
        relations => [
            qw[
                files
            ]
        ],
 
        custom => [
            qw[
            ]
        ],
 
        resultsets => [
            qw[
            ]
        ],
    }
);
 
# run the tests
$schematest->run_tests();