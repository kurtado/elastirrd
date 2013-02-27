elastirrd
=========

Create simple RRD graphs from Elasticsearch queries.

Just set a few values at the top of the script, and set to run from cron. Elastirrd will look back one minute (by default) and graph the average / minute value of number of matches on an RRD graph.

Example:

./elastirrd.pl uri /index.html

./elastirrd.pl severity 4

./elastirrd.pl response_code 412


