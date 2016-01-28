use utf8;
package Releve::Schema::Result::Typeofmodereglement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Typeofmodereglement

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<typeofmodereglement>

=cut

__PACKAGE__->table("typeofmodereglement");

=head1 ACCESSORS

=head2 typeofmr_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 typeofmr_type

  data_type: 'text'
  is_nullable: 0

=head2 typeofmr_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "typeofmr_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "typeofmr_type",
  { data_type => "text", is_nullable => 0 },
  "typeofmr_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</typeofmr_id>

=back

=cut

__PACKAGE__->set_primary_key("typeofmr_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<typeofmr_type_unique>

=over 4

=item * L</typeofmr_type>

=back

=cut

__PACKAGE__->add_unique_constraint("typeofmr_type_unique", ["typeofmr_type"]);

=head1 RELATIONS

=head2 modereglements

Type: has_many

Related object: L<Releve::Schema::Result::Modereglement>

=cut

__PACKAGE__->has_many(
  "modereglements",
  "Releve::Schema::Result::Modereglement",
  { "foreign.modreg_type" => "self.typeofmr_type" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QEGRbVppW8KFcIe6UBwrbQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
