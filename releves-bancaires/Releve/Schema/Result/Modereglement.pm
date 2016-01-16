use utf8;
package Releve::Schema::Result::Modereglement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Modereglement

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<modereglement>

=cut

__PACKAGE__->table("modereglement");

=head1 ACCESSORS

=head2 modreg_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 modreg_type

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 modreg_lib

  data_type: 'text'
  is_nullable: 0

=head2 modreg_compteid

  data_type: 'b	inary'
  is_foreign_key: 1
  is_nullable: 0
  size: 24

=cut

__PACKAGE__->add_columns(
  "modreg_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "modreg_type",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "modreg_lib",
  { data_type => "text", is_nullable => 0 },
  "modreg_compteid",
  { data_type => "b\tinary", is_foreign_key => 1, is_nullable => 0, size => 24 },
);

=head1 PRIMARY KEY

=over 4

=item * L</modreg_id>

=back

=cut

__PACKAGE__->set_primary_key("modreg_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<modreg_id_modreg_compteid_unique>

=over 4

=item * L</modreg_id>

=item * L</modreg_compteid>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "modreg_id_modreg_compteid_unique",
  ["modreg_id", "modreg_compteid"],
);

=head1 RELATIONS

=head2 modreg_compteid

Type: belongs_to

Related object: L<Releve::Schema::Result::Compte>

=cut

__PACKAGE__->belongs_to(
  "modreg_compteid",
  "Releve::Schema::Result::Compte",
  { compte_id => "modreg_compteid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 modreg_type

Type: belongs_to

Related object: L<Releve::Schema::Result::Typeofmodereglement>

=cut

__PACKAGE__->belongs_to(
  "modreg_type",
  "Releve::Schema::Result::Typeofmodereglement",
  { typeofmr_type => "modreg_type" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 reglementps

Type: has_many

Related object: L<Releve::Schema::Result::Reglementp>

=cut

__PACKAGE__->has_many(
  "reglementps",
  "Releve::Schema::Result::Reglementp",
  { "foreign.regp_modreglib" => "self.modreg_lib" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-16 00:38:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zhEDjAU5jzVhju7Ao7WgVQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
