use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME               => 'MouseX::MethodAttributes',
    DISTNAME           => 'MouseX-MethodAttributes',
    AUTHOR             => 'Ji-Hyeon Gim <potatogim@gluesys.com>',
    VERSION_FROM       => 'lib/MouseX/MethodAttributes.pm',
    ABSTRACT_FROM      => 'lib/MouseX/MethodAttributes.pm',
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    PREREQ_PM => {
        'utf8'                   => 0,
        'strict'                 => 0,
        'warnings'               => 0,
        'overload'               => 0,
        'Mouse'                  => 0,
    },
    TEST_REQUIRES => {
        'utf8'         => 0,
        'List::Util'   => 0,
        'Scalar::Util' => 0,
        'Time::HiRes'  => 0,
        'Test::Deep'   => 0,
        'Test::More'   => 0,
        'Test::Most'   => 0,
        'Test::Class'  => 0,
    },
    PL_FILES => {},
    clean => {
        FILES => 'MouseX-MethodAttributes-*',
    },
    test => {
        TESTS => 't/*.t',
    },
    (
        eval { ExtUtils::MakeMaker->VERSION(6.46) }
            ? (
                META_MERGE => {
                    'meta-spec' => { version => 2 },
                    license     => ['perl_5'],
                    resources   => {
                        homepage   => 'https://github.com/potatogim/MouseX-MethodAttributes',
                        repository => {
                            type => 'git',
                            url  => 'https://github.com/potatogim/MouseX-MethodAttributes.git',
                            web  => 'https://github.com/potatogim/MouseX-MethodAttributes',
                        },
                        bugtracker => {
                            web => 'https://github.com/potatogim/MouseX-MethodAttributes/issues',
                        },
                    },
                }
            )
            : ()
    ),
);
