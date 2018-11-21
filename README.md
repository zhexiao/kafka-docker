# kafka-docker
使用docker管理kafka集群

# Zookeeper
我们使用的版本号是3.4.13（http://mirrors.hust.edu.cn/apache/zookeeper/zookeeper-3.4.13/）。

## 解压包 
```
$ sudo mkdir /opt/zookeeper
$ sudo chmod -R 777 /opt/zookeeper/
$ tar -zxvf zookeeper-3.4.13.tar.gz -C /opt/zookeeper/

# 创建数据目录
$ cd /opt/zookeeper/zookeeper-3.4.13
$ mkdir data_dir
```

## 配置 zoo.cfg
```
$ cp conf/zoo_sample.cfg conf/zoo.cfg
$ vi conf/zoo.cfg
"""
dataDir=/opt/zookeeper/zookeeper-3.4.13/data_dir
"""
```

## 创建image
```
$ cd kafka-docker
$ docker build -t zookeeper -f zookeeper/Dockerfile .
```

# Kafka
我们使用的版本号是2.11（https://www.apache.org/dyn/closer.cgi?path=/kafka/2.0.0/kafka_2.11-2.0.0.tgz）。

## 解压包 
```
$ sudo mkdir /opt/kafka
$ sudo chmod -R 777 /opt/kafka/
$ tar -zxvf kafka_2.11-2.0.0.tgz -C /opt/kafka/

# 有几个server.property,就创建几个日志目录
$ mkdir -p /opt/kafka/kafka_2.11-2.0.0/runtime-log
$ cd runtime-log
$ mkdir -p server-logs-1 server-logs-2 server-logs-3
```

## 创建image
```
$ cd kafka-docker
$ docker build -t kafka -f kafka/Dockerfile .
```

## 配置 server.properties
```
1. broker.id=1
2. listeners=PLAINTEXT://:9092
3. advertised.listeners=PLAINTEXT://host_ip:9092
4. zookeeper.connect=zk_ip:zk_port
```

## QA
如果有kakfa启动失败，记得清除下 runtime-log 里面的日志数据。

# 启动测试
```
# 启动服务
$ cd kafka-docker
$ docker-compose up

# 测试kakfa
$ cd /opt/kafka/kafka_2.11-2.0.0/

# 创建topic
$ bin/kafka-topics.sh --create --zookeeper localhost:2181 --replication-factor 3 --partitions 1 --topic zhexiao
$ bin/kafka-topics.sh --describe --zookeeper localhost:2181 --topic zhexiao

# 消息测试
$ bin/kafka-console-producer.sh --broker-list localhost:9092 --topic test
$ bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic test --from-beginning
```