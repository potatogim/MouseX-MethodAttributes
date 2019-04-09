package SubSubClass;

use base qw/OtherSubClass/;

sub meta { 'foo' }

sub bar : Quux {}

1;

