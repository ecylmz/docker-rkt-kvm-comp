#!/bin/bash

# time docker
(/usr/bin/time -f "%E real,%U user,%S sys" docker run tutum/ubuntu:trusty true) |& tee -a results/docker.txt
