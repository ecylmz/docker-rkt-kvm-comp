FROM tutum/ubuntu

MAINTAINER Emre Can Yılmaz, emrecan@ecylmz.com

RUN apt-get update
# install netperf
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty multiverse" >> /etc/apt/sources.list
RUN apt-get update
RUN apt-get install --reinstall netperf

COPY run_netserver /usr/bin/run_netserver

EXPOSE 12865
CMD ["run_netserver"]
