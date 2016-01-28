use utf8;
package Releve::Schema::Result::Banque;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Banque

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<banque>

=cut

__PACKAGE__->table("banque");

=head1 ACCESSORS

=head2 banque_id

  data_type: 'binary'
  is_nullable: 0
  size: 5

=head2 banque_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "banque_id",
  { data_type => "binary", is_nullable => 0, size => 5 },
  "banque_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</banque_id>

=back

=cut

__PACKAGE__->set_primary_key("banque_id");

=head1 RELATIONS

=head2 comptes

Type: has_many

Related object: L<Releve::Schema::Result::Compte>

=cut

__PACKAGE__->has_many(
  "comptes",
  "Releve::Schema::Result::Compte",
  { "foreign.compte_banquelib" => "self.banque_lib" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 mouvements

Type: has_many

Related object: L<Releve::Schema::Result::Mouvement>

=cut

__PACKAGE__->has_many(
  "mouvements",
  "Releve::Schema::Result::Mouvement",
  { "foreign.mvt_banquelib" => "self.banque_lib" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 releves

Type: has_many

Related object: L<Releve::Schema::Result::Releve>

=cut

__PACKAGE__->has_many(
  "releves",
  "Releve::Schema::Result::Releve",
  { "foreign.releve_banquelib" => "self.banque_lib" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:tt8jbpV29ledMQTPOtGirg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
