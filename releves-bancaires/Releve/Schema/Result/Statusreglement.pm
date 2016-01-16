use utf8;
package Releve::Schema::Result::Statusreglement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Statusreglement

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<statusreglement>

=cut

__PACKAGE__->table("statusreglement");

=head1 ACCESSORS

=head2 statreg_regid

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 statreg_seq

  data_type: 'integer'
  is_nullable: 0

=head2 statreg_code

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0
  size: 1

=head2 statreg_date

  data_type: 'date'
  is_nullable: 0

=head2 statreg_comment

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "statreg_regid",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "statreg_seq",
  { data_type => "integer", is_nullable => 0 },
  "statreg_code",
  { data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 1 },
  "statreg_date",
  { data_type => "date", is_nullable => 0 },
  "statreg_comment",
  { data_type => "text", default_value => "", is_nullable => 0 },
);

=head1 UNIQUE CONSTRAINTS

=head2 C<statreg_regid_statreg_seq_statreg_code_statreg_date_unique>

=over 4

=item * L</statreg_regid>

=item * L</statreg_seq>

=item * L</statreg_code>

=item * L</statreg_date>

=back

=cut

__PACKAGE__->add_unique_constraint(
  "statreg_regid_statreg_seq_statreg_code_statreg_date_unique",
  ["statreg_regid", "statreg_seq", "statreg_code", "statreg_date"],
);

=head1 RELATIONS

=head2 statreg_regid

Type: belongs_to

Related object: L<Releve::Schema::Result::Reglement>

=cut

__PACKAGE__->belongs_to(
  "statreg_regid",
  "Releve::Schema::Result::Reglement",
  { reg_id => "statreg_regid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-16 00:38:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bTTmAvx5wLL44y34eBsKjg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
