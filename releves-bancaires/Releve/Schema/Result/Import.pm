use utf8;
package Releve::Schema::Result::Import;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Import

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<import>

=cut

__PACKAGE__->table("import");

=head1 ACCESSORS

=head2 import_id

  data_type: 'import_name
	import_file
	import_ts'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "import_id",
  {
    data_type   => "import_name\n\timport_file\n\timport_ts",
    is_nullable => 1,
  },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:FPVpIocf1bl7juv/xe6Iig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
