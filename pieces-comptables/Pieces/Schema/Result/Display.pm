use utf8;
package Pieces::Schema::Result::Display;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Pieces::Schema::Result::Display

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<DISPLAY>

=cut

__PACKAGE__->table("DISPLAY");

=head1 ACCESSORS

=head2 display_id

  data_type: 'text'
  is_nullable: 0

=head2 display_lang

  data_type: 'text'
  default_value: 'FR'
  is_nullable: 0

=head2 display_value

  data_type: 'text'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "display_id",
  { data_type => "text", is_nullable => 0 },
  "display_lang",
  { data_type => "text", default_value => "FR", is_nullable => 0 },
  "display_value",
  { data_type => "text", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</display_id>

=back

=cut

__PACKAGE__->set_primary_key("display_id");


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-12-30 18:11:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:N+dyDKA7PKmvgQYjA7z0NQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->resultset_class('DBIx::Class::ResultSet::HashRef');
1;
