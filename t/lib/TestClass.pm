package TestClass;

use Mouse;
use MouseX::MethodAttributes;

sub foo : SomeAttribute AnotherAttribute('with argument') {}

sub bar : SomeAttribute {}

after foo => sub {};

package SubClass;

use Mouse;
use MouseX::MethodAttributes;

extends qw/TestClass/;

sub foo : Attributes Attributes Attributes {}

sub bar {}

1;
