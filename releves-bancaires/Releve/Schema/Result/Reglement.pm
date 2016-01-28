use utf8;
package Releve::Schema::Result::Reglement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Reglement

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<reglement>

=cut

__PACKAGE__->table("reglement");

=head1 ACCESSORS

=head2 reg_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 reg_type

  data_type: 'char'
  default_value: 'p'
  is_nullable: 0
  size: 1

=head2 reg_date

  data_type: 'date'
  is_nullable: 0

=head2 reg_amount

  data_type: 'numeric'
  is_nullable: 0
  size: [9,2]

=head2 reg_comment

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 reg_tiersid

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "reg_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "reg_type",
  { data_type => "char", default_value => "p", is_nullable => 0, size => 1 },
  "reg_date",
  { data_type => "date", is_nullable => 0 },
  "reg_amount",
  { data_type => "numeric", is_nullable => 0, size => [9, 2] },
  "reg_comment",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "reg_tiersid",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</reg_id>

=back

=cut

__PACKAGE__->set_primary_key("reg_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<reg_id_reg_type_reg_tiersid_unique>

=over 4

=item * L</reg_id>

=item * L</reg_type>

=item * L</reg_tiersid>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "reg_id_reg_type_reg_tiersid_unique",
  ["reg_id", "reg_type", "reg_tiersid"],
);

=head1 RELATIONS

=head2 reg_tiersid

Type: belongs_to

Related object: L<Releve::Schema::Result::Tier>

=cut

__PACKAGE__->belongs_to(
  "reg_tiersid",
  "Releve::Schema::Result::Tier",
  { tiers_id => "reg_tiersid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 reglementp

Type: might_have

Related object: L<Releve::Schema::Result::Reglementp>

=cut

__PACKAGE__->might_have(
  "reglementp",
  "Releve::Schema::Result::Reglementp",
  {
    "foreign.regp_id"   => "self.reg_id",
    "foreign.regp_type" => "self.reg_type",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 statusreglements

Type: has_many

Related object: L<Releve::Schema::Result::Statusreglement>

=cut

__PACKAGE__->has_many(
  "statusreglements",
  "Releve::Schema::Result::Statusreglement",
  { "foreign.statreg_regid" => "self.reg_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EZdDJXBKf6Q0iVgRogKRlg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
