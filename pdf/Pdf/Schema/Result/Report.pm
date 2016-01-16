use utf8;
package Pdf::Schema::Result::Report;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Pdf::Schema::Result::Report

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<report>

=cut

__PACKAGE__->table("report");

=head1 ACCESSORS

=head2 report_id

  data_type: 'text'
  is_nullable: 0

=head2 report_nbdirsread

  data_type: 'text'
  is_nullable: 0

=head2 report_nbfilesread

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "report_id",
  { data_type => "text", is_nullable => 0 },
  "report_nbdirsread",
  { data_type => "text", is_nullable => 0 },
  "report_nbfilesread",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</report_id>

=back

=cut

__PACKAGE__->set_primary_key("report_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-09 00:01:40
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:1LSLZOHj986uoa6dhbFPSw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
