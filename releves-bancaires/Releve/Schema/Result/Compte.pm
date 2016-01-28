use utf8;
package Releve::Schema::Result::Compte;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Compte

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<compte>

=cut

__PACKAGE__->table("compte");

=head1 ACCESSORS

=head2 compte_id

  data_type: 'binary'
  is_nullable: 0
  size: 24

=head2 compte_banquelib

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 compte_no

  data_type: 'text'
  is_nullable: 0

=head2 compte_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "compte_id",
  { data_type => "binary", is_nullable => 0, size => 24 },
  "compte_banquelib",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "compte_no",
  { data_type => "text", is_nullable => 0 },
  "compte_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</compte_id>

=back

=cut

__PACKAGE__->set_primary_key("compte_id");

=head1 RELATIONS

=head2 compte_banquelib

Type: belongs_to

Related object: L<Releve::Schema::Result::Banque>

=cut

__PACKAGE__->belongs_to(
  "compte_banquelib",
  "Releve::Schema::Result::Banque",
  { banque_lib => "compte_banquelib" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 modereglements

Type: has_many

Related object: L<Releve::Schema::Result::Modereglement>

=cut

__PACKAGE__->has_many(
  "modereglements",
  "Releve::Schema::Result::Modereglement",
  { "foreign.modreg_compteid" => "self.compte_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 mouvements

Type: has_many

Related object: L<Releve::Schema::Result::Mouvement>

=cut

__PACKAGE__->has_many(
  "mouvements",
  "Releve::Schema::Result::Mouvement",
  { "foreign.mvt_comptelib" => "self.compte_lib" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 releves

Type: has_many

Related object: L<Releve::Schema::Result::Releve>

=cut

__PACKAGE__->has_many(
  "releves",
  "Releve::Schema::Result::Releve",
  { "foreign.releve_comptelib" => "self.compte_lib" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:sFs52XwvJOU5icECiRT24g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
