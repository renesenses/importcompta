use utf8;
package Piecescomptables::Schema::Result::Typepiece;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Piecescomptables::Schema::Result::Typepiece

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<typepiece>

=cut

__PACKAGE__->table("typepiece");

=head1 ACCESSORS

=head2 typepiece_id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 typepiece_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "typepiece_id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "typepiece_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</typepiece_id>

=back

=cut

__PACKAGE__->set_primary_key("typepiece_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-04 22:09:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0iZYhLzKhqap7rbZuKlP5Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
