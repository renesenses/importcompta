use utf8;
package Releve::Schema::Result::Status;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Releve::Schema::Result::Status

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<status>

=cut

__PACKAGE__->table("status");

=head1 ACCESSORS

=head2 statusofprove_code

  data_type: 'char'
  is_nullable: 0
  size: 1

=head2 statusofprove_lib

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "statusofprove_code",
  { data_type => "char", is_nullable => 0, size => 1 },
  "statusofprove_lib",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</statusofprove_code>

=back

=cut

__PACKAGE__->set_primary_key("statusofprove_code");

=head1 RELATIONS

=head2 explications

Type: has_many

Related object: L<Releve::Schema::Result::Explication>

=cut

__PACKAGE__->has_many(
  "explications",
  "Releve::Schema::Result::Explication",
  { "foreign.exp_status" => "self.status_lib" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2016-01-16 00:38:14
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GXQjAtA6FMqd4+qZwjZm8Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
