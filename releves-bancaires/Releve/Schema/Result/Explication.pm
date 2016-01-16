use utf8;
package Releve::Schema::Result::Explication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Explication

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<explication>

=cut

__PACKAGE__->table("explication");

=head1 ACCESSORS

=head2 exp_mvtid

  data_type: 'binary'
  is_nullable: 0
  size: 48

=head2 exp_lib

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 exp_comptatypecode

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 exp_status

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0
  size: 1

=cut

__PACKAGE__->add_columns(
  "exp_mvtid",
  { data_type => "binary", is_nullable => 0, size => 48 },
  "exp_lib",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "exp_comptatypecode",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "exp_status",
  { data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</exp_mvtid>

=back

=cut

__PACKAGE__->set_primary_key("exp_mvtid");

=head1 UNIQUE CONSTRAINTS

=head2 C<exp_mvtid_exp_lib_unique>

=over 4

=item * L</exp_mvtid>

=item * L</exp_lib>

=back

=cut

__PACKAGE__->add_unique_constraint("exp_mvtid_exp_lib_unique", ["exp_mvtid", "exp_lib"]);

=head1 RELATIONS

=head2 exp_comptatypecode

Type: belongs_to

Related object: L<Releve::Schema::Result::Typecompta>

=cut

__PACKAGE__->belongs_to(
  "exp_comptatypecode",
  "Releve::Schema::Result::Typecompta",
  { typecompta_code => "exp_comptatypecode" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 exp_status

Type: belongs_to

Related object: L<Releve::Schema::Result::Status>

=cut

__PACKAGE__->belongs_to(
  "exp_status",
  "Releve::Schema::Result::Status",
  { status_lib => "exp_status" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 has_proves

Type: has_many

Related object: L<Releve::Schema::Result::HasProve>

=cut

__PACKAGE__->has_many(
  "has_proves",
  "Releve::Schema::Result::HasProve",
  { "foreign.prov_expmvtid" => "self.exp_mvtid" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-16 00:38:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:WHte8Re/R3hk6zByO2fGDQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
