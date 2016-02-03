#!/usr/bin/perl
#==============================================================
#-----------------------
# Version : 2004082701
# Writer  : Mico Cheng
# Use for : Accounting Mail Queue for
# Host    : Rmail MS Server
# Filename: queuenum.pl
#-----------------------

$active_mailq=0;$deferred_mailq=0;$incoming_mailq=0;
$queue_base_dir = "/var/postfix/queue";
@queue_main_array = qw/ deferred /;
@queue_hash_array = qw/ 0 1 2 3 4 5 6 7 8 9 A B C D E F /;

foreach $queue_main_dir (@queue_main_array) {
    foreach $queue_hash1_dir (@queue_hash_array) {
         foreach $queue_hash2_dir (@queue_hash_array) {
              foreach $queue_hash3_dir (@queue_hash_array) {
                  $queue_whole_dir = $queue_base_dir."/".$queue_main_dir."/".$queue_hash1_dir."/".$queue_hash2_dir."/".$queue_hash3_dir;
                  opendir DH, $queue_whole_dir;
                  foreach (readdir DH) {
                        #next if $_ =~ /^\..*/;
                        next if $_ eq "..";
                        next if $_ eq ".";
                        $deferred_mailq++;
                  }
                  closedir DH;
              }
         }
    }
}
#=======================================================================
@queue_main_array = qw/ incoming active /;
foreach $queue_main_dir (@queue_main_array) {
    $queue_whole_dir = $queue_base_dir."/"."$queue_main_dir";
    opendir DH, $queue_whole_dir;
    foreach (readdir DH) {
        next if $_ eq "..";
        next if $_ eq ".";
        $working_mailq++;
    }
    closedir DH;
}
    #for MRTG
    print "Incoming: $deferred_mailq\n";
    print "Active  : $working_mailq\n";
