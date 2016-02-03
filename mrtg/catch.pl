#!/usr/bin/perl
#for Linux FC4

$_ = `/bin/ps ax|grep catch|grep -v grep|wc -l`;
($result) = ($_ =~ /^\s+(\d+)/);
print "\$result=$result\n";
if ($result gt 1) {
    print "mrtg is still running\n";
    print "exit...\n";
    exit 0;
}

$hostname = "tbc-mx01.apol.com.tw";
$hostip = "203.79.224.57";
$outfile = "mrtg.log";

open (OUT,">$outfile") || die "Can't open $outfile!!\n";

print "host $hostname\n";
print "ip $hostip\n";

#  09:10:50 up 3 days, 21:11,  2 users,  load average: 0.02, 0.41, 0.67

$_ = `uptime`;
if (/up\ (.+),.+user.+average\: (\d+\.\d+)\, (\d+\.\d+)\, (\d+\.\d+)/)
{
  $uptime = "$1";
  print "uptime $uptime\n";
  $load1 += $2*100;
  $load2 += $3*100;
  $load3 += $4*100;
  print "cpu $load1 $load2\n";
}

$diskuseage = 'df -k |';
open (DSK,$diskuseage)||die "can executing df program!!";
while(<DSK>)
{
  chomp;
  if (/(\S+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+%)\s+(\/\S*)/)
  {
    $diskfree = int $3/1000;
    $diskall = int $2/1000;
    print "disk_$6 $diskfree $diskall $5\n";
  }
}

$_ = `ps ax|grep "smtpd -n smtp -t"|wc -l`;
($smtpd_process) = ($_ =~ /^(\d+)$/);
print "smtpd $smtpd_process $smtpd_process\n";

$_ = `/usr/bin/free|grep Mem`;
#             total       used       free     shared    buffers     cached
#Mem:       2068456     647068    1421388          0     224848     207792

chomp($_);
($mem_total,$mem_used) = ($_ =~ /^Mem:\s+(\d+)\s+(\d+)/);
$mem_total = $mem_total/1024;
$mem_used = $mem_used/1024;
$mem_total = int($mem_total);
$mem_used = int($mem_used);
print "mem $mem_used $mem_total\n";

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
    print "mqueue $deferred_mailq $working_mailq\n";
