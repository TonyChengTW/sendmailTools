#!/bin/sh
/root/mrtg/catch.pl > /root/mrtg/mrtg.log
/usr/local/bin/ncftpput -E -u mrtg -p 123qwe 210.201.31.28 html/mico/tbc-mx01.apol.com.tw /root/mrtg/mrtg.log
