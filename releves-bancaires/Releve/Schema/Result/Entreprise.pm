use utf8;
package Releve::Schema::Result::Entreprise;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Entreprise

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<entreprise>

=cut

__PACKAGE__->table("entreprise");

=head1 ACCESSORS

=head2 entreprise_id

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 entreprise_tierstype

  data_type: 'char'
  default_value: 'e'
  is_foreign_key: 1
  is_nullable: 0
  size: 1

=head2 entreprise_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "entreprise_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
  },
  "entreprise_tierstype",
  {
    data_type => "char",
    default_value => "e",
    is_foreign_key => 1,
    is_nullable => 0,
    size => 1,
  },
  "entreprise_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</entreprise_id>

=back

=cut

__PACKAGE__->set_primary_key("entreprise_id");

=head1 RELATIONS

=head2 tier

Type: belongs_to

Related object: L<Releve::Schema::Result::Tier>

=cut

__PACKAGE__->belongs_to(
  "tier",
  "Releve::Schema::Result::Tier",
  { tiers_id => "entreprise_id", tiers_type => "entreprise_tierstype" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-16 00:38:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1qAkfUJyIozsiCASMLfAWg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
