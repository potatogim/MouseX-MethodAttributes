package MouseX::MethodAttributes::Role::Meta::Map;
# ABSTRACT: generic role for storing code attributes used by classes and roles with attributes

our $VERSION = '0.1';

use Mouse::Role;
use MouseX::Types::Mouse qw/HashRef ArrayRef Str Int/;
use Data::Dumper;

use namespace::autoclean;

has _method_attribute_map =>
(
    is      => 'ro',
    isa     => HashRef[ArrayRef[Str]],
    lazy    => 1,
    default => sub { +{} },
);

has _method_attribute_list =>
(
    is      => 'ro',
    isa     => ArrayRef[Int],
    lazy    => 1,
    default => sub { [] },
);

#pod =method register_method_attributes ($code, $attrs)
#pod
#pod Register a list of attributes for a code reference.
#pod
#pod =cut

sub register_method_attributes
{
    my ($self, $code, $attrs) = @_;

    push(@{$self->_method_attribute_list}, 0 + $code);
    $self->_method_attribute_map->{0 + $code} = $attrs;

    #printf "register_method_attributes: %s\n", $self;
    #printf "register_method_attributes: %d\n", 0 + $code;
    #printf "register_method_attributes: %s", Dumper($attrs);
    #printf "mattr_map  : %s", Dumper($self->_method_attribute_map);
    #printf "mattr_list : %s", Dumper($self->_method_attribute_list);

    foreach ($self->linearized_isa())
    {
        next if ($_ =~ m/^(Mouse::|$self->{package})/);

        foreach my $method ($_->meta->get_method_list())
        {
            my $self_meta = $self->get_method($method);
            my $isa_meta  = $_->meta->get_method($method);

            next if (!$self_meta || $self_meta->name eq 'meta'
                    || ($self_meta->name ne $isa_meta->name));

            my $attrs = $_->meta->get_method_attributes(0 + $_->meta->get_method_body($method));

            unshift(@{$self->_method_attribute_map->{0 + $code}}, @{$attrs});
        }
    }

    return;
}

#pod =method unregister_method_attributes ($code)
#pod
#pod Unregister a list of attributes for a code reference.
#pod
#pod =cut

sub unregister_method_attributes
{
    my ($self, $code, $attrs) = @_;

    for (0..$#{$self->_method_attribute_list})
    {
        next if ($self->_method_attribute_list->[$_] != 0 + $code);
        splice(@{$self->_method_attribute_list}, $_, 1);
        last;
    }

    return delete($self->_method_attribute_map->{0 + $code});
}

#pod =method get_method_attributes ($code)
#pod
#pod Get a list of attributes associated with a coderef.
#pod
#pod =cut

sub get_method_attributes
{
    my ($self, $code) = @_;

    #printf "get_method_attributes: %s\n", $self;
    #printf "get_method_attributes: %d\n", 0 + $code;

    # TODO: Find inherited method's attributes

    return $self->_method_attribute_map->{0 + $code} || [];
}

1;

__END__

=pod

=encoding UTF-8

=head1 NAME

MouseX::MethodAttributes::Role::Meta::Map - generic role for storing code attributes used by classes and roles with attributes

=head1 VERSION

version 0.1

=head1 METHODS

=head2 register_method_attributes ($code, $attrs)

Register a list of attributes for a code reference.

=head2 unregister_method_attributes ($code)

Un-register a list of attributes from a code reference.

=head2 get_method_attributes ($code)

Get a list of attributes associated with a coderef.

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
