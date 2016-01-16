use utf8;
package Pieces::Schema::Result::Banquemvt;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Pieces::Schema::Result::Banquemvt

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<BANQUEMVT>

=cut

__PACKAGE__->table("BANQUEMVT");

=head1 ACCESSORS

=head2 banquemvt_id

  data_type: 'integer'
  is_nullable: 0

=head2 banquemvt_releveid

  data_type: 'integer'
  is_auto_increment: 1
  is_foreign_key: 1
  is_nullable: 0

=head2 banquemvt_date

  data_type: 'date'
  is_nullable: 0

=head2 banquemvt_datevdevaleur

  data_type: 'date'
  is_nullable: 0

=head2 banquemvt_lib

  data_type: 'text'
  is_nullable: 0

=head2 banquemvt_exo

  data_type: 'booelan'
  default_value: 'NO'
  is_nullable: 0

=head2 banquemvt_type

  data_type: 'text'
  default_value: 'CREDIT'
  is_nullable: 0

=head2 banquemvt_amount

  data_type: 'numeric'
  is_nullable: 0
  size: [2,9]

=cut

__PACKAGE__->add_columns(
  "banquemvt_id",
  { data_type => "integer", is_nullable => 0 },
  "banquemvt_releveid",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_foreign_key    => 1,
    is_nullable       => 0,
  },
  "banquemvt_date",
  { data_type => "date", is_nullable => 0 },
  "banquemvt_datevdevaleur",
  { data_type => "date", is_nullable => 0 },
  "banquemvt_lib",
  { data_type => "text", is_nullable => 0 },
  "banquemvt_exo",
  { data_type => "booelan", default_value => "NO", is_nullable => 0 },
  "banquemvt_type",
  { data_type => "text", default_value => "CREDIT", is_nullable => 0 },
  "banquemvt_amount",
  { data_type => "numeric", is_nullable => 0, size => [2, 9] },
);

=head1 PRIMARY KEY

=over 4

=item * L</banquemvt_releveid>

=back

=cut

__PACKAGE__->set_primary_key("banquemvt_releveid");

=head1 RELATIONS

=head2 banquemvt_releveid

Type: belongs_to

Related object: L<Pieces::Schema::Result::Releve>

=cut

__PACKAGE__->belongs_to(
  "banquemvt_releveid",
  "Pieces::Schema::Result::Releve",
  { releve_id => "banquemvt_releveid" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07043 @ 2015-12-30 18:11:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:NMy00wUCQWXvhAgwLQfoRg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->resultset_class('DBIx::Class::ResultSet::HashRef');
1;
