use utf8;
package Releve::Schema::Result::Statusofreglement;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Statusofreglement

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<statusofreglement>

=cut

__PACKAGE__->table("statusofreglement");

=head1 ACCESSORS

=head2 statusofreg_code

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 statusofreg_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "statusofreg_code",
  { data_type => "char", is_nullable => 0, size => 1 },
  "statusofreg_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</statusofreg_code>

=back

=cut

__PACKAGE__->set_primary_key("statusofreg_code");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-01-27 19:07:25
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:s3ZJ1ytGxnZCFdp/YUydwg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
