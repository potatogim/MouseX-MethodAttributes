package BaseClass;

package BaseClass::Meta::Role;
use Mouse::Role;

package BaseClass;

use Mouse;
use Mouse::Util::MetaRole;

BEGIN {
    Mouse::Util::MetaRole::apply_metaroles(
        for             => __PACKAGE__,
        class_metaroles => {
            class => [qw/BaseClass::Meta::Role/],
        }
    );

    with 'MouseX::MethodAttributes::Role::AttrContainer';
}

sub moo : Moo {}

{
    my $affe_was_run = 0;

    sub affe : Birne { $affe_was_run++; }
    sub no_calls_to_affe { $affe_was_run; }
}

sub foo : Foo {}

sub bar : Baz {}

{
    no warnings 'redefine';
    sub moo : Moo {}
}

1;
