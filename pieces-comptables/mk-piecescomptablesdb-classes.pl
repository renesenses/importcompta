#!/usr/bin/env perl
	# NOT USED
use DBIx::Class::Schema::Loader qw/ make_schema_at /;
make_schema_at(
	'Piecescomptables::Schema',
	{ 	debug => 1,
		dump_directory => '.',
	},
	[ 'dbi:SQLite:pieces-comptables.db', '', '',
	],
);