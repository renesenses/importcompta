use utf8;
package Releve::Schema::Result::Particulier;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Particulier

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<particulier>

=cut

__PACKAGE__->table("particulier");

=head1 ACCESSORS

=head2 particulier_id

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 particulier_tierstype

  data_type: 'char'
  default_value: 'p'
  is_foreign_key: 1
  is_nullable: 0
  size: 1

=head2 particulier_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "particulier_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
  },
  "particulier_tierstype",
  {
    data_type => "char",
    default_value => "p",
    is_foreign_key => 1,
    is_nullable => 0,
    size => 1,
  },
  "particulier_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</particulier_id>

=back

=cut

__PACKAGE__->set_primary_key("particulier_id");

=head1 RELATIONS

=head2 tier

Type: belongs_to

Related object: L<Releve::Schema::Result::Tier>

=cut

__PACKAGE__->belongs_to(
  "tier",
  "Releve::Schema::Result::Tier",
  { tiers_id => "particulier_id", tiers_type => "particulier_tierstype" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:p+zK+0/3PM+7bdX5kHlPEw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
