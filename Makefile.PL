use inc::Module::Install;
name 'HTML-FormFu-Declare';
all_from 'lib/HTML/FormFu/Declare.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
