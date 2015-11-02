# in production this should probably be busybox, but let's use ubuntu for a
# fair comparison
FROM tutum/ubuntu

MAINTAINER Emre Can Yılmaz, ecylmz@bil.omu.edu.tr

RUN apt-get update
RUN apt-get install -y build-essential liblzma-dev
RUN apt-get install -y time

ADD pxz /pxz
WORKDIR /pxz

RUN make

CMD /usr/bin/time -f "%E real,%U user,%S sys" ./pxz -kvf -2 sample.txt
