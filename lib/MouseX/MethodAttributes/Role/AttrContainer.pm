package MouseX::MethodAttributes::Role::AttrContainer;
# ABSTRACT: capture code attributes in the class' metaclass

our $VERSION = '0.1';

use Mouse::Role;
use Mouse::Util qw/find_meta/;

use namespace::autoclean;

#pod =method MODIFY_CODE_ATTRIBUTES ($code, @attrs)
#pod
#pod Accepts a list of attributes for a coderef and stores it the class' metaclass.
#pod
#pod See L<attributes>.
#pod
#pod =cut

sub MODIFY_CODE_ATTRIBUTES {
    my ($class, $code, @attrs) = @_;
    find_meta($class)->register_method_attributes($code, \@attrs);
    return ();
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MouseX::MethodAttributes::Role::AttrContainer - capture code attributes in the class' metaclass

=head1 VERSION

version 0.1

=head1 METHODS

=head2 MODIFY_CODE_ATTRIBUTES ($code, @attrs)

Accepts a list of attributes for a coderef and stores it the class' metaclass.

See L<attributes>.

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
