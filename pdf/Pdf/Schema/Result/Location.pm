use utf8;
package Pdf::Schema::Result::Location;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Pdf::Schema::Result::Location

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<location>

=cut

__PACKAGE__->table("location");

=head1 ACCESSORS

=head2 loc_id

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 loc_fullname

  data_type: 'text'
  is_nullable: 0

=head2 loc_filename

  data_type: 'text'
  is_nullable: 0

=head2 loc_dir

  data_type: 'text'
  is_nullable: 0

=head2 loc_ext

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "loc_id",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "loc_fullname",
  { data_type => "text", is_nullable => 0 },
  "loc_filename",
  { data_type => "text", is_nullable => 0 },
  "loc_dir",
  { data_type => "text", is_nullable => 0 },
  "loc_ext",
  { data_type => "text", is_nullable => 0 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<loc_id_loc_fullname_unique>

=over 4

=item * L</loc_id>

=item * L</loc_fullname>

=back

=cut

__PACKAGE__->add_unique_constraint("loc_id_loc_fullname_unique", ["loc_id", "loc_fullname"]);

=head1 RELATIONS

=head2 loc

Type: belongs_to

Related object: L<Pdf::Schema::Result::Pdf>

=cut

__PACKAGE__->belongs_to(
  "loc",
  "Pdf::Schema::Result::Pdf",
  { pdf_id => "loc_id" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-09 00:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DwuLcLdhKvoVWavjHrhkqg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
