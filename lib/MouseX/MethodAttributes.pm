package MouseX::MethodAttributes;
# ABSTRACT: Code attribute introspection

our $VERSION = '0.1';

use Mouse ();
use Mouse::Exporter;
use Mouse::Util::MetaRole;
use Mouse::Util qw/find_meta does_role/;
# Ensure trait is registered
use MouseX::MethodAttributes::Role::Meta::Role ();
use namespace::autoclean;

#pod =head1 SYNOPSIS
#pod
#pod     package MyClass;
#pod
#pod     use Mouse;
#pod     use MouseX::MethodAttributes;
#pod
#pod     sub foo : Bar Baz('corge') { ... }
#pod
#pod     my $attrs = MyClass->meta->get_method('foo')->attributes; # ["Bar", "Baz('corge')"]
#pod
#pod =head1 DESCRIPTION
#pod
#pod This module allows code attributes of methods to be introspected using Mouse
#pod meta method objects.
#pod
#pod =begin Pod::Coverage
#pod
#pod init_meta
#pod
#pod =end Pod::Coverage
#pod
#pod =cut

Mouse::Exporter->setup_import_methods(
    also => 'Mouse',
);

sub init_meta {
    my ($class, %options) = @_;

    my $for_class = $options{for_class};
    my $meta = find_meta($for_class);

    return $meta if $meta
        && does_role($meta, 'MouseX::MethodAttributes::Role::Meta::Class')
        && does_role($meta->method_metaclass, 'MouseX::MethodAttributes::Role::Meta::Method')
        && does_role($meta->wrapped_method_metaclass, 'MouseX::MethodAttributes::Role::Meta::Method::MaybeWrapped');

    $meta = Mouse::Meta::Class->create( $for_class )
        unless $meta;

    $meta = Mouse::Util::MetaRole::apply_metaroles(
        for             => $for_class,
        class_metaroles => {
            class  => ['MouseX::MethodAttributes::Role::Meta::Class'],
            method => ['MouseX::MethodAttributes::Role::Meta::Method'],
            #wrapped_method => [
            #    'MouseX::MethodAttributes::Role::Meta::Method::MaybeWrapped'
            #],
        },
    );

    Mouse::Util::MetaRole::apply_base_class_roles(
        for_class => $for_class,
        roles     => ['MouseX::MethodAttributes::Role::AttrContainer'],
    );

    return $meta;
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MouseX::MethodAttributes - Code attribute introspection

=head1 VERSION

version 0.1

=head1 SYNOPSIS

    package MyClass;

    use Mouse;
    use MouseX::MethodAttributes;

    sub foo : Bar Baz('corge') { ... }

    my $attrs = MyClass->meta->get_method('foo')->attributes; # ["Bar", "Baz('corge')"]

    package MyChild;

    use Mouse;
    use MouseX::MethodAttributes;

    override foo : Qux { ... }

    my $attrs = MyChild->meta->get_method('foo')->attributes; # ["Bar", "Baz('corge')", "Qux"]

=head1 DESCRIPTION

This module allows code attributes of methods to be introspected using Mouse
meta method objects.

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

=head1 CONTRIBUTORS

=head1 COPYRIGHT AND LICENCE

This software is copyright 2018 by Ji-Hyeon Gim.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
