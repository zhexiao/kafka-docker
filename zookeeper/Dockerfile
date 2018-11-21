#
# docker build -t zookeeper -f zookeeper/Dockerfile .
#
FROM ubuntu:xenial

ADD ./common/sources.list /etc/apt/sources.list
RUN apt-get -y update && apt-get -y update --fix-missing && apt-get -y update

# JAVA环境
RUN apt-get install -y openjdk-8-jdk apt-transport-https

# 创建用户
RUN groupadd -r zookeeper && useradd -r -l -d /home/zookeeper -g zookeeper -m zookeeper



