#!/bin/bash

for ((i=0;i<1;i++)); do ./linux.sh; done
for ((i=0;i<1;i++)); do ./docker.sh; done
for ((i=0;i<1;i++)); do ./vm-raw.sh; done
for ((i=0;i<1;i++)); do ./rkt.sh; done
