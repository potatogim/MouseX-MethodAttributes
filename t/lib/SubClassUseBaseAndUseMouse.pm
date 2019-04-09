package SubClassUseBaseAndUseMouse;

use base qw/BaseClass/;

use Mouse;

sub bar : Bar {}

before affe => sub {};

no Mouse;

1;
