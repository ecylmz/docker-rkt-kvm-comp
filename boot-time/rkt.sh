#!/bin/bash

# time rkt
(/usr/bin/time -f "%E real,%U user,%S sys" sudo rkt -insecure-skip-verify run tutum-ubuntu-trusty.aci) |& tee -a results/rkt.txt
