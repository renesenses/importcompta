use utf8;
package Releve::Schema::Result::Mvtxl;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Mvtxl

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<mvtxls>

=cut

__PACKAGE__->table("mvtxls");

=head1 ACCESSORS

=head2 mvtxls_no

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 mvtxls_date

  data_type: 'date'
  is_nullable: 0

=head2 mvtxls_lib

  data_type: 'text'
  is_nullable: 0

=head2 mvtxls_datevaleur

  data_type: 'date'
  is_nullable: 0

=head2 mvtxls_exo

  data_type: 'text'
  default_value: (empty string)
  is_nullable: 0

=head2 mvtxls_amountdeb

  data_type: 'numeric'
  is_nullable: 1
  size: [9,2]

=head2 mvtxls_amountcred

  data_type: 'numeric'
  is_nullable: 1
  size: [9,2]

=cut

__PACKAGE__->add_columns(
  "mvtxls_no",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "mvtxls_date",
  { data_type => "date", is_nullable => 0 },
  "mvtxls_lib",
  { data_type => "text", is_nullable => 0 },
  "mvtxls_datevaleur",
  { data_type => "date", is_nullable => 0 },
  "mvtxls_exo",
  { data_type => "text", default_value => "", is_nullable => 0 },
  "mvtxls_amountdeb",
  { data_type => "numeric", is_nullable => 1, size => [9, 2] },
  "mvtxls_amountcred",
  { data_type => "numeric", is_nullable => 1, size => [9, 2] },
);

=head1 PRIMARY KEY

=over 4

=item * L</mvtxls_no>

=back

=cut

__PACKAGE__->set_primary_key("mvtxls_no");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ObzUuCxdbs7dt76iQ1H79A


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
