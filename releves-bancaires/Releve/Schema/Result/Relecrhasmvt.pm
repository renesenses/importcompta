use utf8;
package Releve::Schema::Result::Relecrhasmvt;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Relecrhasmvt

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<relecrhasmvt>

=cut

__PACKAGE__->table("relecrhasmvt");

=head1 ACCESSORS

=head2 relecrhmvt_ecrno

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 relecrhmvt_mvtid

  data_type: 'binary'
  is_foreign_key: 1
  is_nullable: 0
  size: 44

=head2 relecrhmvt_mvtno

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "relecrhmvt_ecrno",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "relecrhmvt_mvtid",
  { data_type => "binary", is_foreign_key => 1, is_nullable => 0, size => 44 },
  "relecrhmvt_mvtno",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</relecrhmvt_ecrno>

=item * L</relecrhmvt_mvtid>

=back

=cut

__PACKAGE__->set_primary_key("relecrhmvt_ecrno", "relecrhmvt_mvtid");

=head1 UNIQUE CONSTRAINTS

=head2 C<relecrhmvt_ecrno_relecrhmvt_mvtid_relecrhmvt_mvtno_unique>

=over 4

=item * L</relecrhmvt_ecrno>

=item * L</relecrhmvt_mvtid>

=item * L</relecrhmvt_mvtno>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "relecrhmvt_ecrno_relecrhmvt_mvtid_relecrhmvt_mvtno_unique",
  ["relecrhmvt_ecrno", "relecrhmvt_mvtid", "relecrhmvt_mvtno"],
);

=head1 RELATIONS

=head2 relecrhmvt_ecrno

Type: belongs_to

Related object: L<Releve::Schema::Result::Relecr>

=cut

__PACKAGE__->belongs_to(
  "relecrhmvt_ecrno",
  "Releve::Schema::Result::Relecr",
  { ecr_no => "relecrhmvt_ecrno" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 relecrhmvt_mvtid

Type: belongs_to

Related object: L<Releve::Schema::Result::Mouvement>

=cut

__PACKAGE__->belongs_to(
  "relecrhmvt_mvtid",
  "Releve::Schema::Result::Mouvement",
  { mvt_id => "relecrhmvt_mvtid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 relecrhmvt_mvtno

Type: belongs_to

Related object: L<Releve::Schema::Result::Mouvement>

=cut

__PACKAGE__->belongs_to(
  "relecrhmvt_mvtno",
  "Releve::Schema::Result::Mouvement",
  { mvt_no => "relecrhmvt_mvtno" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:aodbvSlZTa1ck2GkNamYZg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
