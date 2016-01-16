use utf8;
package Releve::Schema::Result::Mouvement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Mouvement

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<mouvement>

=cut

__PACKAGE__->table("mouvement");

=head1 ACCESSORS

=head2 mvt_id

  data_type: 'binary'
  is_nullable: 0
  size: 44

=head2 mvt_no

  data_type: 'integer'
  is_nullable: 0

=head2 mvt_releveno

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 mvt_comptelib

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 mvt_banquelib

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 mvt_date

  data_type: 'date'
  is_nullable: 0

=head2 mvt_datevaleur

  data_type: 'date'
  is_nullable: 0

=head2 mvt_lib

  data_type: 'text'
  is_nullable: 0

=head2 mvt_exo

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 mvt_deborcred

  data_type: 'char'
  default_value: 'd'
  is_nullable: 0
  size: 1

=head2 mvt_amount

  data_type: 'numeric'
  is_nullable: 0
  size: [9,2]

=cut

__PACKAGE__->add_columns(
  "mvt_id",
  { data_type => "binary", is_nullable => 0, size => 44 },
  "mvt_no",
  { data_type => "integer", is_nullable => 0 },
  "mvt_releveno",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "mvt_comptelib",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "mvt_banquelib",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "mvt_date",
  { data_type => "date", is_nullable => 0 },
  "mvt_datevaleur",
  { data_type => "date", is_nullable => 0 },
  "mvt_lib",
  { data_type => "text", is_nullable => 0 },
  "mvt_exo",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "mvt_deborcred",
  { data_type => "char", default_value => "d", is_nullable => 0, size => 1 },
  "mvt_amount",
  { data_type => "numeric", is_nullable => 0, size => [9, 2] },
);

=head1 PRIMARY KEY

=over 4

=item * L</mvt_id>

=back

=cut

__PACKAGE__->set_primary_key("mvt_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<mvt_id_mvt_lib_mvt_comptelib_mvt_banquelib_unique>

=over 4

=item * L</mvt_id>

=item * L</mvt_lib>

=item * L</mvt_comptelib>

=item * L</mvt_banquelib>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "mvt_id_mvt_lib_mvt_comptelib_mvt_banquelib_unique",
  ["mvt_id", "mvt_lib", "mvt_comptelib", "mvt_banquelib"],
);

=head2 C<mvt_id_mvt_no_unique>

=over 4

=item * L</mvt_id>

=item * L</mvt_no>

=back

=cut

__PACKAGE__->add_unique_constraint("mvt_id_mvt_no_unique", ["mvt_id", "mvt_no"]);

=head1 RELATIONS

=head2 mvt_banquelib

Type: belongs_to

Related object: L<Releve::Schema::Result::Banque>

=cut

__PACKAGE__->belongs_to(
  "mvt_banquelib",
  "Releve::Schema::Result::Banque",
  { banque_lib => "mvt_banquelib" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 mvt_comptelib

Type: belongs_to

Related object: L<Releve::Schema::Result::Compte>

=cut

__PACKAGE__->belongs_to(
  "mvt_comptelib",
  "Releve::Schema::Result::Compte",
  { compte_lib => "mvt_comptelib" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 mvt_releveno

Type: belongs_to

Related object: L<Releve::Schema::Result::Releve>

=cut

__PACKAGE__->belongs_to(
  "mvt_releveno",
  "Releve::Schema::Result::Releve",
  { releve_no => "mvt_releveno" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 relecrhasmvt_relecrhmvt_mvtids

Type: has_many

Related object: L<Releve::Schema::Result::Relecrhasmvt>

=cut

__PACKAGE__->has_many(
  "relecrhasmvt_relecrhmvt_mvtids",
  "Releve::Schema::Result::Relecrhasmvt",
  { "foreign.relecrhmvt_mvtid" => "self.mvt_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 relecrhasmvt_relecrhmvt_mvtnoes

Type: has_many

Related object: L<Releve::Schema::Result::Relecrhasmvt>

=cut

__PACKAGE__->has_many(
  "relecrhasmvt_relecrhmvt_mvtnoes",
  "Releve::Schema::Result::Relecrhasmvt",
  { "foreign.relecrhmvt_mvtno" => "self.mvt_no" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-16 00:38:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:l7NCQOrH97Ued7OsT3IpTg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
