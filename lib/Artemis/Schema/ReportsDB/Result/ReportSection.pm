package Artemis::Schema::ReportsDB::Result::ReportSection;

use strict;
use warnings;

use parent 'DBIx::Class';
use parent 'Artemis::Schema::Printable';

__PACKAGE__->load_components("Core");
__PACKAGE__->table("reportsection");
__PACKAGE__->add_columns
    (
     "id",                      { data_type => "INT",      default_value => undef, is_nullable => 0, size => 11, is_auto_increment => 1, },
     "report_id",               { data_type => "INT",      default_value => undef, is_nullable => 0, size => 11, is_foreign_key => 1, },
     "succession",              { data_type => "INT",      default_value => undef, is_nullable => 1, size => 10,                      },
     "name",                    { data_type => "VARCHAR",  default_value => undef, is_nullable => 1, size => 255,                     },
     #
     "osname",                  { data_type => "VARCHAR",  default_value => undef, is_nullable => 1, size => 255,                     },
     "uname",                   { data_type => "VARCHAR",  default_value => undef, is_nullable => 1, size => 255,                     },
     "language_description",    { data_type => "TEXT",     default_value => undef, is_nullable => 1, size => 255,                     },
     "cpuinfo",                 { data_type => "TEXT",     default_value => undef, is_nullable => 1, size => 65535,                   },
     "ram",                     { data_type => "VARCHAR",  default_value => undef, is_nullable => 1, size => 50,                      },
     "lspci",                   { data_type => "TEXT",     default_value => undef, is_nullable => 1, size => 65535,                   },
     "lsusb",                   { data_type => "TEXT",     default_value => undef, is_nullable => 1, size => 65535,                   },
     "flags",                   { data_type => "VARCHAR",  default_value => undef, is_nullable => 1, size => 255,                     },
     "xen_changeset",           { data_type => "VARCHAR",  default_value => undef, is_nullable => 1, size => 255,                     },
     "xen_hvbits",              { data_type => "VARCHAR",  default_value => undef, is_nullable => 1, size => 10,                      },
     "xen_dom0_kernel",         { data_type => "TEXT",     default_value => undef, is_nullable => 1, size => 65535,                   },
     "xen_base_os_description", { data_type => "TEXT",     default_value => undef, is_nullable => 1, size => 65535,                   },
     "xen_guest_description",   { data_type => "TEXT",     default_value => undef, is_nullable => 1, size => 65535,                   },
     "test_was_on_guest",       { data_type => "INT",      default_value => undef, is_nullable => 1, size => 1,                       },
     "test_was_on_hv",          { data_type => "INT",      default_value => undef, is_nullable => 1, size => 1,                       },
     "xen_guest_flags",         { data_type => "VARCHAR",  default_value => undef, is_nullable => 1, size => 255,                     },
    );

__PACKAGE__->set_primary_key("id");

__PACKAGE__->has_many   ( report => 'Artemis::Schema::ReportsDB::Result::Report', { 'foreign.id' => 'self.report_id' });


# -------------------- methods on results --------------------

sub some_meta_available
{
        my ($self) = @_;
        my %cols = $self->get_columns;
        my @meta_cols = qw/osname
                           uname
                           language_description
                           cpuinfo
                           ram
                           lspci
                           lsusb
                           flags
                           xen_changeset
                           xen_hvbits
                           xen_dom0_kernel
                           xen_base_os_description
                           xen_guest_description
                           xen_guest_flags
                           test_was_on_guest
                           test_was_on_hv
                          /;
        return 1 if grep { defined } @cols{@meta_cols};
        return 0;
}


1;

=head1 NAME

Artemis::Schema::ReportsDB::ReportSection - A ResultSet description


=head1 SYNOPSIS

Abstraction for the database table.

 use Artemis::Schema::ReportsDB;


=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>


=head1 BUGS

None.


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

