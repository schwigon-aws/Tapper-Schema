package Artemis::Schema::TestrunDB::Result::Host;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components(qw/InflateColumn::DateTime Core/);
__PACKAGE__->table("host");
__PACKAGE__->add_columns
    (
     "id",                        { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,    is_auto_increment => 1, },
     "name",                      { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           },
     "allowed_context",           { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           }, # "live", "development", "test", ""/NULL
     "busy",                      { data_type => "VARCHAR",   default_value => "",                   is_nullable => 1, size => 255,                           },
     "created_at",                { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1,                                        }, # '
     "updated_at",                { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                        },

     # the host's feature set is read dynamically from HardwareDB inside application

    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many ( testrunschedulings => 'Artemis::Schema::TestrunDB::Result::TestrunScheduling', { 'foreign.host_id' => 'self.id' });

# -------------------- methods on results --------------------

sub to_string
{
        my ($self) = @_;

        my $format = join( $Artemis::Schema::TestrunDB::DELIM, qw/%s %s %s %s %s %s %s %s %s %s %s %s %s %s /, '');
        sprintf (
                 $format,
                 map {
                      defined $self->$_
                      ? $self->$_
                      : $Artemis::Schema::TestrunDB::NULL
                     } @{$self->result_source->{_ordered_columns} }
                );
}

=head2 is_member($head, @tail)

Checks if the first element is already in the list of the remaining
elements.

=cut

sub is_member
{
        my ($head, @tail) = @_;
        grep { $head->id eq $_->id } @tail;
}

=head2 ordered_preconditions

Returns all preconditions in the order they need to be installed.

=cut

sub ordered_preconditions
{
        my ($self) = @_;

        my @done = ();
        my %seen = ();
        my @todo = ();

        @todo = $self->preconditions->search({}, {order_by => 'succession'})->all;

        while (my $head = shift @todo)
        {
                if ($seen{$head->id})
                {
                        push @done, $head unless is_member($head, @done);
                }
                else
                {
                        $seen{$head->id} = 1;
                        my @pre_todo = $head->child_preconditions->search({}, { order_by => 'succession' } )->all;
                        unshift @todo, @pre_todo, $head;
                }
        }
        return @done;
}


1;

=head1 NAME

Artemis::Schema::TestrunDB::Testrun - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestrunDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008..2009 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive
