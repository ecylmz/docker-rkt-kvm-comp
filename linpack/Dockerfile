FROM tutum/ubuntu

MAINTAINER Emre Can Yılmaz, ecylmz@bil.omu.edu.tr

RUN apt-get update
RUN apt-get -qq install -y libgomp1 libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 numactl

ADD bin /
CMD numactl --physcpubind=0 --interleave=0 /runme_xeon32
