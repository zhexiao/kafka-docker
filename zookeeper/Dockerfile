#
# docker build -t zookeeper -f zookeeper/Dockerfile .
#
FROM ubuntu:xenial
EXPOSE 2181

ARG myid
ARG client_port

ADD ./common/sources.list /etc/apt/sources.list
RUN apt-get -y update && apt-get -y update --fix-missing

# JAVA环境
RUN apt-get install -y openjdk-8-jdk apt-transport-https

WORKDIR /home/zookeeper
RUN mkdir data_dir
RUN echo $myid >> ./data_dir/myid

ADD ./common/zookeeper.tar.gz .
RUN mv zookeeper* zookeeper
ADD ./zookeeper/zoo.cfg zookeeper/conf/
RUN echo "clientPort=$client_port" >> zookeeper/conf/zoo.cfg
RUN chown -R root:root zookeeper





