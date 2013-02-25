#!/usr/bin/perl
use strict;
use ElasticSearch;
use Data::Dumper;
use RRD::Simple;

# set these values for your purposes
my $field = 'uri';
my $value = '/index.html';
my $rrd_dir = '/var/www/html/images/rrd/';
my $es_server = 'localhost:9200';
my $dt_period = 'now-1m';

# initialize ES connection
my $es = ElasticSearch->new(
               servers      => $es_server,
               transport    => 'http',
#               trace_calls  => 'log_file',
               no_refresh   => 0,
    ) || die "can't get new \$es\n";

# run the query
my $result = $es->search(
    queryb => {
	$field => $value,
	_timestamp => { 'gte' => $dt_period },
    },
    );

print Dumper($result->{'hits'}->{'total'}), "\n";

# update rrd file
my $rrdfile = "$rrd_dir/$field-$value.rrd";
my $rrd = RRD::Simple->new( file => $rrdfile );

$rrd->update(
    num => $result->{'hits'}->{'total'},
    );

# update rrd graphs
my %rtn = $rrd->graph(
    destination => $rrd_dir,
    title => "$field = $value",
    vertical_label => "requests / minute",
    );
printf("Created %s\n",join(", ",map { $rtn{$_}->[0] } keys %rtn));
