# kafka-docker
使用docker管理kafka集群

# 下载安装包到PKG目录
kafka: http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/2.3.0/kafka_2.12-2.3.0.tgz
zookeeper: https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.5.5/apache-zookeeper-3.5.5.tar.gz

# 安装镜像
```
$ docker build -t java-base -f Dockerfile-java-base .
$ docker build -t zookeeper -f Dockerfile-zookeeper .
$ docker build -t kafka -f Dockerfile-kafka .
```


## 解压包 
```
$ sudo mkdir /opt/zookeeper
$ sudo chmod -R 777 /opt/zookeeper/
$ tar -zxvf zookeeper-3.4.13.tar.gz -C /opt/zookeeper/

# 创建数据目录
$ mkdir /opt/zookeeper/zookeeper-3.4.13/data_dir
```

## 配置 conf/zoo.cfg
```
$ cp zoo.cfg.example zoo.cfg
```
按需配置服务，下面是自定义的配置：
1. dataDir=/home/zookeeper/data_dir

注：保证配置里面的端口号与docker-compose.yml里面的port对应上。

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

## 配置 conf/server.properties
```
$ cp server.properties.example server.properties.1
$ cp server.properties.example server.properties.2
$ cp server.properties.example server.properties.3
```
按需配置服务，下面是自定义的配置：
1. broker.id
2. listeners=PLAINTEXT://:port
3. advertised.listeners=PLAINTEXT://host_ip:port
4. log.dirs
5. zookeeper.connect=host_ip:2181

注：保证配置里面的端口号与docker-compose.yml里面的port对应上。


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
$ bin/kafka-topics.sh --create --zookeeper host_ip:2181 --replication-factor 3 --partitions 1 --topic question_view_count
$ bin/kafka-topics.sh --describe --zookeeper host_ip:2181 --topic question_view_count

# 消息测试
$ bin/kafka-console-producer.sh --broker-list host_ip:9092 --topic test
$ bin/kafka-console-consumer.sh --bootstrap-server host_ip:9092 --topic test --from-beginning
```

# 部署服务
```
$ docker stack deploy -c docker-compose.yml kafka_v1
```