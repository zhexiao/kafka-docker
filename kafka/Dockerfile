#
# docker build -t zookeeper -f zookeeper/Dockerfile .
#
FROM ubuntu:xenial
EXPOSE 9092

ADD ./common/sources.list /etc/apt/sources.list
RUN apt-get -y update && apt-get -y update --fix-missing

# JAVA环境
RUN apt-get install -y openjdk-8-jdk apt-transport-https

WORKDIR /home/kafka
ADD ./common/kafka.tgz .
RUN mv kafka* kafka

ADD ./kafka/server.properties kafka/config/

RUN chown -R root:root kafka





