use utf8;
package Piecescomptables::Schema::Result::File;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Piecescomptables::Schema::Result::File

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<file>

=cut

__PACKAGE__->table("file");

=head1 ACCESSORS

=head2 file_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 file_filename

  data_type: 'text'
  is_nullable: 0

=head2 file_ext

  data_type: 'text'
  is_nullable: 0

=head2 file_dir

  data_type: 'text'
  is_nullable: 0

=head2 file_volume

  data_type: 'text'
  is_nullable: 0

=head2 file_pieceid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "file_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "file_filename",
  { data_type => "text", is_nullable => 0 },
  "file_ext",
  { data_type => "text", is_nullable => 0 },
  "file_dir",
  { data_type => "text", is_nullable => 0 },
  "file_volume",
  { data_type => "text", is_nullable => 0 },
  "file_pieceid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</file_id>

=back

=cut

__PACKAGE__->set_primary_key("file_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<file_filename_file_ext_file_dir_file_volume_unique>

=over 4

=item * L</file_filename>

=item * L</file_ext>

=item * L</file_dir>

=item * L</file_volume>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "file_filename_file_ext_file_dir_file_volume_unique",
  ["file_filename", "file_ext", "file_dir", "file_volume"],
);

=head1 RELATIONS

=head2 file_pieceid

Type: belongs_to

Related object: L<Piecescomptables::Schema::Result::Piececomptable>

=cut

__PACKAGE__->belongs_to(
  "file_pieceid",
  "Piecescomptables::Schema::Result::Piececomptable",
  { piececomptable_id => "file_pieceid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-04 22:09:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0E4Eoa1iX79kTbY1BxOiOQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
