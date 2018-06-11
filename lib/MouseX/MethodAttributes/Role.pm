package MouseX::MethodAttributes::Role;
# ABSTRACT: code attribute introspection

our $VERSION = '0.1';

use Mouse ();
use Mouse::Exporter;
use Mouse::Util::MetaRole;
use Mouse::Util qw/find_meta does_role apply_all_roles/;
# Ensure trait is registered
use MouseX::MethodAttributes::Role::Meta::Role ();
use namespace::autoclean;

#pod =head1 SYNOPSIS
#pod
#pod     package MyRole;
#pod     use MouseX::MethodAttributes::Role;
#pod
#pod     sub foo : Bar Baz('corge') { ... }
#pod
#pod     my $attrs = MyRole->meta->get_method('foo')->attributes; # ["Bar", "Baz('corge')"]
#pod
#pod =head1 DESCRIPTION
#pod
#pod This module allows you to write a Mouse Role with code attributes of methods to
#pod be introspected using Mouse meta method objects.
#pod
#pod =begin Pod::Coverage
#pod
#pod init_meta
#pod
#pod =end Pod::Coverage
#pod
#pod =cut

Mouse::Exporter->setup_import_methods(also => 'Mouse::Role');

sub init_meta
{
    my ($class, %options) = @_;

    my $for_class = $options{for_class};
    my $meta = find_meta($for_class);

    return $meta if ($meta)
        && does_role($meta, 'MouseX::MethodAttributes::Role::Meta::Role');

    $meta = Mouse::Meta::Role->create($for_class)
        unless $meta;

    $meta = Mouse::Util::MetaRole::apply_metaroles(
        for            => $meta->name,
        role_metaroles => {
            role => ['MouseX::MethodAttributes::Role::Meta::Role'],
        },
    );

    apply_all_roles(
        $meta->name,
        'MouseX::MethodAttributes::Role::AttrContainer',
    );

    return $meta;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MouseX::MethodAttributes::Role - code attribute introspection

=head1 VERSION

version 0.1

=head1 SYNOPSIS

    package MyRole;
    use MouseX::MethodAttributes::Role;

    sub foo : Bar Baz('corge') { ... }

    my $attrs = MyRole->meta->get_method('foo')->attributes; # ["Bar", "Baz('corge')"]

=head1 DESCRIPTION

This module allows you to write a Mouse Role with code attributes of methods to
be introspected using Mouse meta method objects.

=for Pod::Coverage init_meta

=head1 SUPPORT

Bugs may be submitted through L<the GitHub issue tracker|https://github.com/potatogim/MouseX-MethodAttributes/issues>

There is also a mailing list available for users of this distribution, at
L<http://lists.perl.org/list/moose.html>.

There is also an irc channel available for users of this distribution, at
irc://irc.perl.org/#moose.

=head1 AUTHORS

=over 4

=item *

Ji-Hyeon Gim <potatogim@potatogim.net>

=back

=head1 COPYRIGHT AND LICENCE

This software is copyright 2018 by Ji-Hyeon Gim.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
