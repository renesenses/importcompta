use utf8;
package Releve::Schema::Result::Reglementp;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Reglementp

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<reglementp>

=cut

__PACKAGE__->table("reglementp");

=head1 ACCESSORS

=head2 regp_id

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 regp_type

  data_type: 'char'
  default_value: 'p'
  is_foreign_key: 1
  is_nullable: 0
  size: 1

=head2 regp_modreglib

  data_type: 'text'
  is_foreign_key: 1
  is_nullable: 0

=head2 regp_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "regp_id",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
  },
  "regp_type",
  {
    data_type => "char",
    default_value => "p",
    is_foreign_key => 1,
    is_nullable => 0,
    size => 1,
  },
  "regp_modreglib",
  { data_type => "text", is_foreign_key => 1, is_nullable => 0 },
  "regp_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</regp_id>

=back

=cut

__PACKAGE__->set_primary_key("regp_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<regp_id_regp_type_unique>

=over 4

=item * L</regp_id>

=item * L</regp_type>

=back

=cut

__PACKAGE__->add_unique_constraint("regp_id_regp_type_unique", ["regp_id", "regp_type"]);

=head1 RELATIONS

=head2 reglement

Type: belongs_to

Related object: L<Releve::Schema::Result::Reglement>

=cut

__PACKAGE__->belongs_to(
  "reglement",
  "Releve::Schema::Result::Reglement",
  { reg_id => "regp_id", reg_type => "regp_type" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 regp_modreglib

Type: belongs_to

Related object: L<Releve::Schema::Result::Modereglement>

=cut

__PACKAGE__->belongs_to(
  "regp_modreglib",
  "Releve::Schema::Result::Modereglement",
  { modreg_lib => "regp_modreglib" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:9MhrMGASFRX2OheLqDe0ZQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
