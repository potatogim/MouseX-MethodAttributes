package MouseX::MethodAttributes::Role::Meta::Method;
# ABSTRACT: metamethod role allowing code attribute introspection

our $VERSION = '0.1';

use Mouse::Role;
use Mouse::Util qw/does_role/;

use namespace::autoclean;

#pod =attr attributes
#pod
#pod Gets the list of code attributes of the method represented by this meta method.
#pod
#pod =cut

has attributes => (
    is      => 'ro',
    lazy    => 1,
    builder => '_build_attributes',
);

#pod =method _build_attributes
#pod
#pod Builds the value of the C<attributes> attribute based on the attributes
#pod captured in the associated meta class.
#pod
#pod =cut

sub _build_attributes {
    my ($self) = @_;
    #print "_build_attributes: $self\n";
    return $self->associated_metaclass->get_method_attributes($self->_get_attributed_coderef);
}

sub _get_attributed_coderef {
    my ($self) = @_;
    #printf "_get_attributed_coderef: %s\n", $self;
    #printf "_get_attributed_coderef: %d\n", 0 + $self->body;
    return $self->body;
}

#override 'wrap' => sub {
#    my $self = super;
#    print "wrap(around)            : $self\n";
#
#    return $self;
#};

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MouseX::MethodAttributes::Role::Meta::Method - metamethod role allowing code attribute introspection

=head1 VERSION

version 0.1

=head1 ATTRIBUTES

=head2 attributes

Gets the list of code attributes of the method represented by this meta method.

=head1 METHODS

=head2 _build_attributes

Builds the value of the C<attributes> attribute based on the attributes
captured in the associated meta class.

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
