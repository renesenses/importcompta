use utf8;
package Releve::Schema::Result::Tier;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Tier

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<tiers>

=cut

__PACKAGE__->table("tiers");

=head1 ACCESSORS

=head2 tiers_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 tiers_type

  data_type: 'char'
  default_value: 'e'
  is_nullable: 0
  size: 1

=head2 tiers_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "tiers_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "tiers_type",
  { data_type => "char", default_value => "e", is_nullable => 0, size => 1 },
  "tiers_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</tiers_id>

=back

=cut

__PACKAGE__->set_primary_key("tiers_id");

=head1 RELATIONS

=head2 entreprises

Type: has_many

Related object: L<Releve::Schema::Result::Entreprise>

=cut

__PACKAGE__->has_many(
  "entreprises",
  "Releve::Schema::Result::Entreprise",
  {
    "foreign.entreprise_id"        => "self.tiers_id",
    "foreign.entreprise_tierstype" => "self.tiers_type",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 particuliers

Type: has_many

Related object: L<Releve::Schema::Result::Particulier>

=cut

__PACKAGE__->has_many(
  "particuliers",
  "Releve::Schema::Result::Particulier",
  {
    "foreign.particulier_id"        => "self.tiers_id",
    "foreign.particulier_tierstype" => "self.tiers_type",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 reglements

Type: has_many

Related object: L<Releve::Schema::Result::Reglement>

=cut

__PACKAGE__->has_many(
  "reglements",
  "Releve::Schema::Result::Reglement",
  { "foreign.reg_tiersid" => "self.tiers_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-16 00:38:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:w7XzK2tT7LlQTTgXc6d8+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
