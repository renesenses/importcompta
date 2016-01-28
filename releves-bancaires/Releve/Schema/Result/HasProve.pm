use utf8;
package Releve::Schema::Result::HasProve;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::HasProve

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<has_prove>

=cut

__PACKAGE__->table("has_prove");

=head1 ACCESSORS

=head2 prov_expmvtid

  data_type: 'binary'
  is_foreign_key: 1
  is_nullable: 0
  size: 48

=head2 prov_pieceid

  data_type: 'integer'
  is_nullable: 0

=head2 prov_status

  data_type: 'char'
  is_foreign_key: 1
  is_nullable: 0
  size: 1

=head2 prov_comment

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "prov_expmvtid",
  { data_type => "binary", is_foreign_key => 1, is_nullable => 0, size => 48 },
  "prov_pieceid",
  { data_type => "integer", is_nullable => 0 },
  "prov_status",
  { data_type => "char", is_foreign_key => 1, is_nullable => 0, size => 1 },
  "prov_comment",
  { data_type => "text", default_value => "", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</prov_pieceid>

=item * L</prov_expmvtid>

=back

=cut

__PACKAGE__->set_primary_key("prov_pieceid", "prov_expmvtid");

=head1 RELATIONS

=head2 prov_expmvtid

Type: belongs_to

Related object: L<Releve::Schema::Result::Explication>

=cut

__PACKAGE__->belongs_to(
  "prov_expmvtid",
  "Releve::Schema::Result::Explication",
  { exp_mvtid => "prov_expmvtid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Pbvl4+oOuLQ4t8wgSZH/Ag


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
