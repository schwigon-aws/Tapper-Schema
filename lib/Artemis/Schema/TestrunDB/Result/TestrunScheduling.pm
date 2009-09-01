# TODO: rename into "(Scheduler|Result)::Job"?

package Artemis::Schema::TestrunDB::Result::TestrunScheduling;

use strict;
use warnings;

use parent 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::Object::Enum", "Core");
__PACKAGE__->table("testrun_scheduling");
__PACKAGE__->add_columns
    (
     "id",              { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,  is_auto_increment => 1,                                 },
     "testrun_id",      { data_type => "INT",       default_value => undef,                is_nullable => 0, size => 11,  is_foreign_key => 1,                                    },
     "queue_id",        { data_type => "INT",       default_value => 0,                    is_nullable => 1, size => 11,  is_foreign_key => 1,                                    },
     "mergedqueue_seq", { data_type => "INT",       default_value => undef,                is_nullable => 1, size => 11,                                                          },
     "host_id",         { data_type => "INT",       default_value => 0,                    is_nullable => 1, size => 11,  is_foreign_key => 1,                                    },
     "status",          { data_type => "VARCHAR",   default_value => "prepare",            is_nullable => 1, size => 255, is_enum => 1, extra => { list => [qw(prepare schedule running finished)] } },
     "created_at",      { data_type => "TIMESTAMP", default_value => \'CURRENT_TIMESTAMP', is_nullable => 1,                                                                      }, # '
     "updated_at",      { data_type => "DATETIME",  default_value => undef,                is_nullable => 1,                                                                      },
    );

__PACKAGE__->set_primary_key(qw/testrun_id/);

__PACKAGE__->belongs_to( testrun            => 'Artemis::Schema::TestrunDB::Result::Testrun',                 { 'foreign.id'         => 'self.testrun_id' });
__PACKAGE__->belongs_to( queue              => 'Artemis::Schema::TestrunDB::Result::Queue',                   { 'foreign.id'         => 'self.queue_id'   });
__PACKAGE__->belongs_to( host               => 'Artemis::Schema::TestrunDB::Result::Host',                    { 'foreign.id'         => 'self.host_id'    });

__PACKAGE__->has_many  ( requested_features => 'Artemis::Schema::TestrunDB::Result::TestrunRequestedFeature', { 'foreign.testrun_id' => 'self.id'         });
__PACKAGE__->has_many  ( requested_hosts    => 'Artemis::Schema::TestrunDB::Result::TestrunRequestedHost',    { 'foreign.testrun_id' => 'self.id'         });


1;

=head1 NAME

Artemis::Schema::TestrunDB::Result::PrePrecondition - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::TestrunDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

