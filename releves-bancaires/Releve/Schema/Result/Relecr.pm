use utf8;
package Releve::Schema::Result::Relecr;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Relecr

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<relecr>

=cut

__PACKAGE__->table("relecr");

=head1 ACCESSORS

=head2 ecr_no

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 ecr_date

  data_type: 'date'
  is_nullable: 0

=head2 ecr_year

  data_type: 'integer'
  is_nullable: 0

=head2 ecr_month

  data_type: 'integer'
  is_nullable: 0

=head2 ecr_day

  data_type: 'integer'
  is_nullable: 0

=head2 ecr_lib

  data_type: 'text'
  is_nullable: 0

=head2 ecr_amount

  data_type: 'numeric'
  is_nullable: 0
  size: [9,2]

=head2 ecr_deborcred

  data_type: 'char'
  default_value: 'd'
  is_nullable: 0
  size: 1

=head2 ecr_solde

  data_type: 'numeric'
  is_nullable: 0
  size: [9,2]

=head2 ecr_source

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ecr_no",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "ecr_date",
  { data_type => "date", is_nullable => 0 },
  "ecr_year",
  { data_type => "integer", is_nullable => 0 },
  "ecr_month",
  { data_type => "integer", is_nullable => 0 },
  "ecr_day",
  { data_type => "integer", is_nullable => 0 },
  "ecr_lib",
  { data_type => "text", is_nullable => 0 },
  "ecr_amount",
  { data_type => "numeric", is_nullable => 0, size => [9, 2] },
  "ecr_deborcred",
  { data_type => "char", default_value => "d", is_nullable => 0, size => 1 },
  "ecr_solde",
  { data_type => "numeric", is_nullable => 0, size => [9, 2] },
  "ecr_source",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ecr_no>

=back

=cut

__PACKAGE__->set_primary_key("ecr_no");

=head1 RELATIONS

=head2 relecrhasmvts

Type: has_many

Related object: L<Releve::Schema::Result::Relecrhasmvt>

=cut

__PACKAGE__->has_many(
  "relecrhasmvts",
  "Releve::Schema::Result::Relecrhasmvt",
  { "foreign.relecrhmvt_ecrno" => "self.ecr_no" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-16 00:38:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:iA1b/9Z2D0IlFSUOXJBxhQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
