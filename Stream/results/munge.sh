#!/bin/bash

# This script processes the following log files and generates data suitable for pasting into stream.xlsx

egrep "^Copy:|^Scale:|^Add:|^Triad:" vm.log  | sed 's/://' | sort -k2n | awk -v caption=1 -f munge.awk > /tmp/vm.$$
egrep "^Copy:|^Scale:|^Add:|^Triad:" rkt.log  | sed 's/://' | sort -k2n | awk -v caption=1 -f munge.awk > /tmp/rkt.$$
egrep "^Copy:|^Scale:|^Add:|^Triad:" docker.log  | sed 's/://' | sort -k2n | awk -v caption=1 -f munge.awk > /tmp/docker.$$
egrep "^Copy:|^Scale:|^Add:|^Triad:" linux.log  | sed 's/://' | sort -k2n | awk -v caption=1 -f munge.awk > /tmp/linux.$$

paste /tmp/linux.$$ /tmp/docker.$$ /tmp/rkt.$$ /tmp/vm.$$

rm -f /tmp/linux.$$ /tmp/docker.$$ /tmp/rkt.$$ /tmp/vm.$$
