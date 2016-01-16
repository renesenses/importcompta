use utf8;
package Piecescomptables::Schema::Result::Piececomptable;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Piecescomptables::Schema::Result::Piececomptable

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<piececomptable>

=cut

__PACKAGE__->table("piececomptable");

=head1 ACCESSORS

=head2 piececomptable_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 piececomptable_md5

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "piececomptable_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "piececomptable_md5",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</piececomptable_id>

=back

=cut

__PACKAGE__->set_primary_key("piececomptable_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<piececomptable_id_piececomptable_md5_unique>

=over 4

=item * L</piececomptable_id>

=item * L</piececomptable_md5>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "piececomptable_id_piececomptable_md5_unique",
  ["piececomptable_id", "piececomptable_md5"],
);

=head1 RELATIONS

=head2 files

Type: has_many

Related object: L<Piecescomptables::Schema::Result::File>

=cut

__PACKAGE__->has_many(
  "files",
  "Piecescomptables::Schema::Result::File",
  { "foreign.file_pieceid" => "self.piececomptable_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-04 22:09:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+1qZ+Q7hv6SwmFbvQq9Chg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
