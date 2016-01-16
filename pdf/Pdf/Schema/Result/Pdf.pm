use utf8;
package Pdf::Schema::Result::Pdf;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Pdf::Schema::Result::Pdf

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<pdf>

=cut

__PACKAGE__->table("pdf");

=head1 ACCESSORS

=head2 pdf_id

  data_type: 'text'
  is_nullable: 0

=head2 pdf_nbocc

  data_type: 'integer'
  is_nullable: 0

=head2 pdf_mtime

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "pdf_id",
  { data_type => "text", is_nullable => 0 },
  "pdf_nbocc",
  { data_type => "integer", is_nullable => 0 },
  "pdf_mtime",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pdf_id>

=back

=cut

__PACKAGE__->set_primary_key("pdf_id");

=head1 RELATIONS

=head2 locations

Type: has_many

Related object: L<Pdf::Schema::Result::Location>

=cut

__PACKAGE__->has_many(
  "locations",
  "Pdf::Schema::Result::Location",
  { "foreign.loc_id" => "self.pdf_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-09 00:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:t51wHqFzAEdgT2ySvVygjQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
