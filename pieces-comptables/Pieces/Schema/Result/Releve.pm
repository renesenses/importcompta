use utf8;
package Pieces::Schema::Result::Releve;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Pieces::Schema::Result::Releve

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<RELEVE>

=cut

__PACKAGE__->table("RELEVE");

=head1 ACCESSORS

=head2 releve_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 releve_date

  data_type: 'date'
  is_nullable: 0

=head2 releve_no

  data_type: 'integer'
  is_nullable: 0

=head2 releve_duration

  data_type: 'text'
  is_nullable: 0

=head2 releve_nbmvt

  data_type: 'integer'
  is_nullable: 0

=head2 releve_soldedebut

  data_type: 'numeric'
  is_nullable: 0
  size: [2,9]

=head2 releve_soldefin

  data_type: 'numeric'
  is_nullable: 0
  size: [2,9]

=cut

__PACKAGE__->add_columns(
  "releve_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "releve_date",
  { data_type => "date", is_nullable => 0 },
  "releve_no",
  { data_type => "integer", is_nullable => 0 },
  "releve_duration",
  { data_type => "text", is_nullable => 0 },
  "releve_nbmvt",
  { data_type => "integer", is_nullable => 0 },
  "releve_soldedebut",
  { data_type => "numeric", is_nullable => 0, size => [2, 9] },
  "releve_soldefin",
  { data_type => "numeric", is_nullable => 0, size => [2, 9] },
);

=head1 PRIMARY KEY

=over 4

=item * L</releve_id>

=back

=cut

__PACKAGE__->set_primary_key("releve_id");

=head1 RELATIONS

=head2 banquemvt

Type: might_have

Related object: L<Pieces::Schema::Result::Banquemvt>

=cut

__PACKAGE__->might_have(
  "banquemvt",
  "Pieces::Schema::Result::Banquemvt",
  { "foreign.banquemvt_releveid" => "self.releve_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-12-30 18:11:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:pq2JiCu/VJD2mmYM5pEeew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->resultset_class('DBIx::Class::ResultSet::HashRef');
1;
