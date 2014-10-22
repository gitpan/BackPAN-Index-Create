#! perl

use strict;
use warnings;
use Test::More 0.88 tests => 5;
use File::Compare qw/ compare /;

use BackPAN::Index::Create              qw/ create_backpan_index /;

use lib 't/lib';
use BackPAN::Index::Create::TestUtils   qw/ setup_testpan /;

my $generated_file_name = 't/generated-releases-index.txt';
my $expected_file_name  = 't/expected-releases-index.txt';

ok(setup_testpan(), "Set mtime on all files in the TestPAN");

eval {
    create_backpan_index({
        basedir         => 't/testpan',
        output          => $generated_file_name,
        releases_only   => 1,
    });
};

ok(!$@, "create_backpan_index() should without croaking");
ok(compare($generated_file_name, $expected_file_name) == 0,
   "generated releases index should match the expected content");
ok(unlink($generated_file_name),
   "Should be able to remove the generated index file");
ok(!-f $generated_file_name,
   "The generated file should no longer exist");

