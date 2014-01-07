#!/usr/bin/env perl

use strict;
use Data::Dumper;

my @mayor_results;
my %unique;
my $mayor=1;
my $loc;

my $mayor_candidates = "Cesar Bello,Idris Ben-Tahir,Clive Doucet,Joseph Furtenbacher,Robert G. Gauthier,Andrew Haydon,Robert Larter,Robin Lawrance,Vincent Libweshya,Fraser Liscumb,Daniel J. Lyrette,Mike Maguire,Larry O\'Brien,Julio Pita,Sean Ryan,Michael St. Arnaud,Jane Scharf,Charlie Taylor,Jim Watson,Samuel Wright";

my @mayor_candidates = split (",",$mayor_candidates);
my $mayor_index=0;
my %mayor_candidates = map { $mayor_index++ => $_   } @mayor_candidates;

foreach my $key (keys(%mayor_candidates)) {
  $mayor_candidates{$key}=~s/'/\\'/;
  my $sql = "insert into vote_candidates
            (id, position, name ) values
            ($key, 1, '".$mayor_candidates{$key}."');";

  print $sql."\n";
}


#print Dumper (\%mayor_candidates);
my @other_header = "Ward,LocationCode,LocationName,Reg. Voters,Total Votes";
my @mayor_header = (@other_header, @mayor_candidates);
my $mayor_header = join (",", @mayor_header);

push @mayor_results, $mayor_header; 

while (<>) {
  chomp;
  s/\r//g;
  s/^\s+//;
  my ($ward) = $ARGV =~ /Ward-([0-9]+).csv/;
  if(!$unique{$ward}) {
    $unique{$ward}=1;
    $mayor=1;
    $loc=1;
  }
  elsif (/^,,,,,,,/) {
    $mayor=0;
  }
  elsif(/^Polling/) {

  }
  elsif(/^Adv/){

  }
  elsif(/^Total/){

  }
  elsif($mayor==1) {
    my $ward_loc = sprintf('%02d-%03d', $ward, $loc);
    
    my @results = split(",", $_);
    for my $i (1 .. 2) {
      my $candidate_index=100+$i; # reg and total votes
      my $votes = int ($results[$i]);
        my $sql = "insert into vote_results 
          (ward, location, position, candidate, votes) 
            values 
          ($ward, '$ward_loc', 1, $candidate_index, $votes);\n";
        print $sql;
    } 
    for my $i (3 .. $#results ) { 
        my $candidate_index=$i-3;
        my $votes = int($results[$i]);
        my $sql = "insert into vote_results 
          (ward, location, position, candidate, votes) 
            values 
          ($ward, '$ward_loc', 1, $candidate_index, $votes);\n";
        print $sql;

    }
    #push @mayor_results, $result;
    $loc++;
  }
  
  
}

#print join( "\n", @mayor_results);

1;
