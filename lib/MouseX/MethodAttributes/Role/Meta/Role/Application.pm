package MouseX::MethodAttributes::Role::Meta::Role::Application;
# ABSTRACT: generic role for applying a role with method attributes to something

our $VERSION = '0.1';

use Mouse::Role;
use Mouse::Util qw/find_meta/;
use MouseX::MethodAttributes ();
use MouseX::MethodAttributes::Role ();
use Carp qw/croak/;
use namespace::autoclean;

requires qw/
    _copy_attributes
    apply
/;

#pod =method apply
#pod
#pod The apply method is wrapped to ensure that the correct metaclasses to hold and propagate
#pod method attribute data are present on the target for role application, delegates to
#pod the original method to actually apply the role, then ensures that any attributes from
#pod the role are copied to the target class.
#pod
#pod =cut

around 'apply' => sub
{
    my ($orig, $self, $thing, %opts) = @_;

    $thing = $self->_apply_metaclasses($thing);

    my $ret = $self->$orig($thing, %opts);

    $self->_copy_attributes($thing);

    return $ret;
};

sub _apply_metaclasses
{
    my ($self, $thing) = @_;

    if ($thing->isa('Mouse::Meta::Class'))
    {
        $thing = MouseX::MethodAttributes->init_meta( for_class => $thing->name );
    }
    elsif ($thing->isa('Mouse::Meta::Role'))
    {
        $thing = MouseX::MethodAttributes::Role->init_meta( for_class => $thing->name );
    }
    else
    {
        croak("Composing " . __PACKAGE__ . " onto instances is unsupported");
    }

    # Note that the metaclass instance we started out with may have been turned
    # into lies by the metatrait role application process, so we explicitly
    # re-fetch it here.

    return find_meta($thing->name);
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MouseX::MethodAttributes::Role::Meta::Role::Application - generic role for applying a role with method attributes to something

=head1 VERSION

version 0.1

=head1 METHODS

=head2 apply

The apply method is wrapped to ensure that the correct metaclasses to hold and propagate
method attribute data are present on the target for role application, delegates to
the original method to actually apply the role, then ensures that any attributes from
the role are copied to the target class.

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
