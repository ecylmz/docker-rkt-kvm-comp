FROM tutum/ubuntu

MAINTAINER Emre Can Yılmaz, ecylmz@bil.omu.edu.tr

RUN apt-get update
RUN apt-get -qq install -y libgomp1 numactl
ADD bin /
CMD numactl --localalloc /gups.exe
