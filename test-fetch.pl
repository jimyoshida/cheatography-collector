#!/usr/bin/env perl
use strict;
use warnings;
use File::Path qw(remove_tree);

my $pass = 0;
my $fail = 0;
my $test_num = 0;

print "1..9\n";

sub ok {
    my ($cond, $name) = @_;
    $test_num++;
    if ($cond) {
        print "ok $test_num - $name\n";
        $pass++;
    } else {
        print "not ok $test_num - $name\n";
        $fail++;
    }
}

# Clean up before tests
remove_tree('downloads') if -d 'downloads';

# --- Test 1: Filename parsing + URL construction ---
my $url = `bash fetch.sh --dry-run downloads/davechild_linux-command-line.pdf`;
chomp $url;
ok($url eq "https://cheatography.com/davechild/cheat-sheets/linux-command-line/pdf/",
   "URL construction: davechild linux-command-line");

# --- Test 2: URL construction ---
$url = `bash fetch.sh --dry-run downloads/davechild_regular-expressions.pdf`;
chomp $url;
ok($url eq "https://cheatography.com/davechild/cheat-sheets/regular-expressions/pdf/",
   "URL construction: davechild regular-expressions");

# --- Test 3: Parsing with different filename ---
$url = `bash fetch.sh --dry-run downloads/gambit_docker.pdf`;
chomp $url;
ok($url eq "https://cheatography.com/gambit/cheat-sheets/docker/pdf/",
   "URL construction: gambit docker");

# --- Test 4: Directory creation ---
system("bash fetch.sh downloads/davechild_linux-command-line.pdf");
ok(-d "downloads", "Directory structure: downloads/ directory created");

# --- Test 5: File download ---
ok(-f "downloads/davechild_linux-command-line.pdf", "File download: PDF file exists");

# --- Test 6: Downloaded file is a valid PDF ---
if (-f "downloads/davechild_linux-command-line.pdf") {
    open my $fh, '<:raw', "downloads/davechild_linux-command-line.pdf" or die $!;
    read $fh, my $header, 4;
    close $fh;
    ok($header eq '%PDF', "File download: file starts with PDF header");
} else {
    ok(0, "File download: file starts with PDF header (file missing)");
}

# --- Test 7: Multiple files ---
system("bash fetch.sh downloads/davechild_regular-expressions.pdf");
ok(-f "downloads/davechild_regular-expressions.pdf", "Multiple files: second PDF downloaded");

# --- Test 8: Error handling - invalid target ---
my $rc = system("bash fetch.sh downloads/nonexistent-user_nonexistent-sheet.pdf");
ok($rc != 0 || ! -f "downloads/nonexistent-user_nonexistent-sheet.pdf" || -z "downloads/nonexistent-user_nonexistent-sheet.pdf",
   "Error handling: invalid target does not produce a valid file");

# --- Test 9: Directory management - downloads dir still intact after multiple runs ---
ok(-d "downloads", "Directory management: downloads/ persists across runs");

# Clean up
remove_tree('downloads') if -d 'downloads';

exit($fail > 0 ? 1 : 0);
