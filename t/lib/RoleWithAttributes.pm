package RoleWithAttributes;

use MouseX::MethodAttributes::Role;
use namespace::autoclean;

sub foo : AnAttr { 'foo' }

sub fnord {}

after 'fnord' => sub {};

1;
