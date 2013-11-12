#!/usr/bin/env perl 

use strict;
use warnings;
use LWP::UserAgent;
use Encode qw(encode decode);
binmode(STDOUT, ":utf8");

my $top_str = '[-Naver Top 10-]';
my $rank_url = 'http://openapi.naver.com/search?key=b7d595844816c0b937e204837a33b432&query=nexearch&target=rank';

my $ua = LWP::UserAgent->new;
my $resp = $ua->get($rank_url);
my $decode_body;

if ($resp->is_success) {
     $decode_body = $resp->decoded_content;
}
else {
    die $resp->status_line;
}

my @html_body = $decode_body =~ m{<K>(.*?)</K>}gsm; 

my @top_tens;
my $i = 1;

push @top_tens, $top_str;

foreach my $p (@html_body) {
    push @top_tens, "$i. $p";
    $i++;
}

my $top_ten = join('/', @top_tens);
#print "$top_ten\n";

my $fp = '/tmp/info_pipe';

system("echo $top_ten > /tmp/info_pipe");