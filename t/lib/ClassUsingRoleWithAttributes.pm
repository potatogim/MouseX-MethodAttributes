package ClassUsingRoleWithAttributes;

use Mouse;
use MouseX::MethodAttributes;

use namespace::autoclean;

with 'RoleWithAttributes';

__PACKAGE__->meta->make_immutable;
