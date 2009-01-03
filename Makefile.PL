use inc::Module::Install;

name     'MooseX-Attribute';
all_from 'lib/MooseX/Attribute.pm';
author   'Christopher Brown <ctbrown@cpan.org>';

build_requires 'Test::More';

requires 'Moose' => 0.63;
requires 'MooseX::AttributeHelpers' => 0.13;
requires 'Moose::Exporter' => 0;
requires 'Moose::Util' => 0;
requires 'Moose::Util::MetaRole' => 0;

auto_install;

WriteAll;

