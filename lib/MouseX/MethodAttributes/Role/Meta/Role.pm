package MouseX::MethodAttributes::Role::Meta::Role;
# ABSTRACT: metarole role for storing code attributes

our $VERSION = '0.1';

use Mouse ();
use Mouse::Util::MetaRole;
use Mouse::Util qw/find_meta does_role apply_all_roles/;

use Mouse::Role;

use MouseX::MethodAttributes ();
use MouseX::MethodAttributes::Role ();

use namespace::autoclean;

#pod =head1 SYNOPSIS
#pod
#pod     package MyRole;
#pod     use MouseX::MethodAttributes::Role;
#pod
#pod     sub foo : Bar Baz('corge') { ... }
#pod
#pod     package MyClass
#pod     use Mouse;
#pod
#pod     with 'MyRole';
#pod
#pod     my $attrs = MyClass->meta->get_method('foo')->attributes; # ["Bar", "Baz('corge')"]
#pod
#pod =head1 DESCRIPTION
#pod
#pod This module is a metaclass role which is applied by L<MouseX::MethodAttributes::Role>, allowing
#pod you to add code attributes to methods in Mouse roles.
#pod
#pod These attributes can then be found by introspecting the role metaclass, and are automatically copied
#pod into any classes or roles that the role is composed onto.
#pod
#pod =head1 CAVEATS
#pod
#pod =over
#pod
#pod =item *
#pod
#pod Currently roles with attributes cannot have methods excluded
#pod or aliased, and will in turn confer this property onto any roles they
#pod are composed onto.
#pod
#pod =back
#pod
#pod =cut

with qw/
    MouseX::MethodAttributes::Role::Meta::Map
    MouseX::MethodAttributes::Role::Meta::Role::Application
/;

around composition_class_roles => sub
{
    my ($orig, $self) = @_;
    return $self->$orig,
        'MouseX::MethodAttributes::Role::Meta::Role::Application::Summation';
};

#pod =method initialize
#pod
#pod Ensures that the package containing the role methods does the
#pod L<MouseX::MethodAttributes::Role::AttrContainer> role during initialisation,
#pod which in turn is responsible for capturing the method attributes on the class
#pod and registering them with the metaclass.
#pod
#pod =cut

after 'initialize' => sub
{
    my ($self, $class, %args) = @_;
    apply_all_roles($class, 'MouseX::MethodAttributes::Role::AttrContainer');
};

#pod =method method_metaclass
#pod
#pod Wraps the normal method and ensures that the method metaclass performs the
#pod L<MouseX::MethodAttributes::Role::Meta::Method> role, which allows you to
#pod introspect the attributes from the method objects returned by the MOP when
#pod querying the metaclass.
#pod
#pod =cut

# FIXME - Skip this logic if the method metaclass already does the right role?
around method_metaclass => sub
{
    my $orig = shift;
    my $self = shift;
    return $self->$orig(@_) if scalar @_;
    Mouse::Meta::Class->create_anon_class(
        superclasses => [ $self->$orig ],
        roles        => [qw/MouseX::MethodAttributes::Role::Meta::Method/],
        cache        => 1,
    )->name();
};

sub _copy_attributes
{
    my ($self, $thing) = @_;

    push @{ $thing->_method_attribute_list }, @{ $self->_method_attribute_list };
    @{ $thing->_method_attribute_map }{ (keys(%{ $self->_method_attribute_map }), keys(%{ $thing->_method_attribute_map })) }
        = (values(%{ $self->_method_attribute_map }), values(%{ $thing->_method_attribute_map }));
};

# This allows you to say use Mouse::Role -traits => 'MethodAttributes'
# This is replaced by MouseX::MethodAttributes::Role, and this trait registration
# is now only present for backwards compatibility reasons.
package # Hide from PAUSE
    Mouse::Meta::Role::Custom::Trait::MethodAttributes;

sub register_implementation
{
    return 'MouseX::MethodAttributes::Role::Meta::Role';
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MouseX::MethodAttributes::Role::Meta::Role - metarole role for storing code attributes

=head1 VERSION

version 0.1

=head1 SYNOPSIS

    package MyRole;
    use MouseX::MethodAttributes::Role;

    sub foo : Bar Baz('corge') { ... }

    package MyClass
    use Mouse;

    with 'MyRole';

    my $attrs = MyClass->meta->get_method('foo')->attributes; # ["Bar", "Baz('corge')"]

=head1 DESCRIPTION

This module is a metaclass role which is applied by L<MouseX::MethodAttributes::Role>, allowing
you to add code attributes to methods in Mouse roles.

These attributes can then be found by introspecting the role metaclass, and are automatically copied
into any classes or roles that the role is composed onto.

=head1 METHODS

=head2 initialize

Ensures that the package containing the role methods does the
L<MouseX::MethodAttributes::Role::AttrContainer> role during initialisation,
which in turn is responsible for capturing the method attributes on the class
and registering them with the metaclass.

=head2 method_metaclass

Wraps the normal method and ensures that the method metaclass performs the
L<MouseX::MethodAttributes::Role::Meta::Method> role, which allows you to
introspect the attributes from the method objects returned by the MOP when
querying the metaclass.

=head1 CAVEATS

=over

=item *

Currently roles with attributes cannot have methods excluded
or aliased, and will in turn confer this property onto any roles they
are composed onto.

=back

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
