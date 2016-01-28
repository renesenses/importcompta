use utf8;
package Releve::Schema::Result::Releve;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Releve

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<releve>

=cut

__PACKAGE__->table("releve");

=head1 ACCESSORS

=head2 releve_id

  data_type: 'binary'
  is_nullable: 0
  size: 34

=head2 releve_comptelib

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 releve_banquelib

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 releve_debut

  data_type: 'date'
  is_nullable: 0

=head2 releve_fin

  data_type: 'date'
  is_nullable: 0

=head2 releve_no

  data_type: 'text'
  is_nullable: 0

=head2 releve_soldedeb

  data_type: 'numeric'
  is_nullable: 0
  size: [9,2]

=head2 releve_soldefin

  data_type: 'numeric'
  is_nullable: 0
  size: [9,2]

=cut

__PACKAGE__->add_columns(
  "releve_id",
  { data_type => "binary", is_nullable => 0, size => 34 },
  "releve_comptelib",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "releve_banquelib",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "releve_debut",
  { data_type => "date", is_nullable => 0 },
  "releve_fin",
  { data_type => "date", is_nullable => 0 },
  "releve_no",
  { data_type => "text", is_nullable => 0 },
  "releve_soldedeb",
  { data_type => "numeric", is_nullable => 0, size => [9, 2] },
  "releve_soldefin",
  { data_type => "numeric", is_nullable => 0, size => [9, 2] },
);

=head1 PRIMARY KEY

=over 4

=item * L</releve_id>

=back

=cut

__PACKAGE__->set_primary_key("releve_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<releve_id_releve_comptelib_releve_banquelib_unique>

=over 4

=item * L</releve_id>

=item * L</releve_comptelib>

=item * L</releve_banquelib>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "releve_id_releve_comptelib_releve_banquelib_unique",
  ["releve_id", "releve_comptelib", "releve_banquelib"],
);

=head2 C<releve_id_releve_no_unique>

=over 4

=item * L</releve_id>

=item * L</releve_no>

=back

=cut

__PACKAGE__->add_unique_constraint("releve_id_releve_no_unique", ["releve_id", "releve_no"]);

=head1 RELATIONS

=head2 mouvements

Type: has_many

Related object: L<Releve::Schema::Result::Mouvement>

=cut

__PACKAGE__->has_many(
  "mouvements",
  "Releve::Schema::Result::Mouvement",
  { "foreign.mvt_releveno" => "self.releve_no" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 releve_banquelib

Type: belongs_to

Related object: L<Releve::Schema::Result::Banque>

=cut

__PACKAGE__->belongs_to(
  "releve_banquelib",
  "Releve::Schema::Result::Banque",
  { banque_lib => "releve_banquelib" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 releve_comptelib

Type: belongs_to

Related object: L<Releve::Schema::Result::Compte>

=cut

__PACKAGE__->belongs_to(
  "releve_comptelib",
  "Releve::Schema::Result::Compte",
  { compte_lib => "releve_comptelib" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:AeejxpKKiS8SyVQ1OEbCjg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
