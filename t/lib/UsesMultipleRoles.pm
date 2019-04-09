package UsesMultipleRoles;

use Mouse;
use namespace::autoclean;

with qw/
    RoleWithAttributes
    OtherRoleWithAttributes
/;
