FROM tutum/ubuntu

MAINTAINER Emre Can Yılmaz, ecylmz@bil.omu.edu.tr

RUN apt-get -qq install -y fio

ADD test.fio /

RUN mkdir /fio_dir

ENTRYPOINT ["fio"]

CMD ["test.fio"]
