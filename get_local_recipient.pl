#!/usr/bin/perl
#-------------------------------------------
# Version : 2006022401
# Writer  : Miko Cheng
# Use for : build local recipients table
# Host    : TBC MX Server
#-------------------------------------------
use DBI;

$tercel_database="dialup";
$tercel_hostname="tercel";
$tercel_port="3306";
$tercel_user="brucelai";
$tercel_password="ezmailat60";

$file = "/var/postfix/config/local_rcpt.map";

open FH,">$file" or die "can't create $file:$!\n";

#    Getting TBC Mail Account

print "Getting TBC account from Tercel\n";
$tercel_dbh = DBI->connect("DBI:mysql:$tercel_database:$tercel_hostname:$tercel_port", $tercel_user, $tercel_password);
$|=1;


$sql="select * from emailtbc";
$cursor=$tercel_dbh->prepare($sql);
$cursor->execute;

while (@data=$cursor->fetchrow_array){
    print FH "$data[1]\@$data[2]\t\tOK\n";
}
$cursor->finish;
$tercel_dbh->disconnect;

print "Getting hiway account from 59\n";
print "connecting to DB\n";

$tbc_dbh = DBI->connect('DBI:mysql:ezmail:203.79.224.59:6060','ezmail', 'apol888',{AutoCommit => 1}) or die "Coundn't connect to database:$!\n";

print "DB connected!\n";
$sql="select username from hiway_ezmail";
$cursor=$tbc_dbh->prepare($sql);
$cursor->execute;
print "executing $sql\n";

while (@data=$cursor->fetchrow_array){
    print FH "$data[0]\@hiway.net.tw\t\tOK\n";
}

$cursor->finish;
$tbc_dbh->disconnect;

print FH "*\t\tREJECT\n";

close(FH);

print "Already got all account......postmap now....\n";

system "/var/postfix/sbin/postmap /var/postfix/config/local_rcpt.map";
print "Done!\n";
