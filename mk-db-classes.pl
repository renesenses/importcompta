#!/usr/bin/env perl
	# NOT USED
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
make_schema_at(
	'TEST::Schema',
	{ 	debug => 1,
		dump_directory => '.',
	},
	[ 'dbi:SQLite:TEST.db', '', '',
	],
);