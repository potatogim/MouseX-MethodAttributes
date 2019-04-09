package OtherRoleWithAttributes;

use MouseX::MethodAttributes::Role;
use namespace::autoclean;

sub bar : AnAttr { 'bar' }

1;
