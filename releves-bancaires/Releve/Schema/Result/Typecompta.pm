use utf8;
package Releve::Schema::Result::Typecompta;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Typecompta

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<typecompta>

=cut

__PACKAGE__->table("typecompta");

=head1 ACCESSORS

=head2 typecompta_code

  data_type: 'text'
  is_nullable: 0

=head2 typecompta_mode

  data_type: 'text'
  is_nullable: 0

=head2 typecompta_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "typecompta_code",
  { data_type => "text", is_nullable => 0 },
  "typecompta_mode",
  { data_type => "text", is_nullable => 0 },
  "typecompta_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</typecompta_code>

=back

=cut

__PACKAGE__->set_primary_key("typecompta_code");

=head1 RELATIONS

=head2 explications

Type: has_many

Related object: L<Releve::Schema::Result::Explication>

=cut

__PACKAGE__->has_many(
  "explications",
  "Releve::Schema::Result::Explication",
  { "foreign.exp_comptatypecode" => "self.typecompta_code" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:mCqEI3riYxKooSbg1dLPLQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
