# kafka-docker
使用docker管理kafka集群

# Zookeeper
拉取对应的镜像
```
$ docker pull zookeeper:3.5.5
```

使用docker-compose.yml启动ZK集群
```
$ docker-compose -f docker-compose-zk.yml up
```

集群状态，可以看到mode为follower或者leader
```
$ docker exec -it zoo1 /apache-zookeeper-3.5.5-bin/bin/zkServer.sh status
$ docker exec -it zoo2 /apache-zookeeper-3.5.5-bin/bin/zkServer.sh status
$ docker exec -it zoo3 /apache-zookeeper-3.5.5-bin/bin/zkServer.sh status
```

# Kafka
下载安装包到PKG目录
```
$ wget http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/2.3.0/kafka_2.12-2.3.0.tgz
```

安装镜像
```
$ docker build -t java-base -f Dockerfile-java-base .
$ docker build -t kafka -f Dockerfile-kafka .
```

更新kafka compose的配置
```
1. KAFKA_BROKER_ID: n
2. KAFKA_LISTENERS: PLAINTEXT://:9092
3. KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
```

环境配置规则如下，以KAFKA_BROKER_ID为例
```
1. 默认读取以KAFKA_开头的变量，然后格式化的时候去掉KAFKA_
2. 将BROKER_ID转为小写broker_id
3. 把 _ 以 . 号替换
4. 得到配置参数 broker.id
```

# 启动整套服务
```
# zookeeper
$ docker-compose -f docker-compose-zk.yml up

# kafka
$ docker-compose -f docker-compose-kf.yml up

# 创建topic
$ docker exec -it kf1 /kafka/kafka_2.12-2.3.0/bin/kafka-topics.sh --create --zookeeper zoo1:2181,zoo2:2181,zoo3:2181 --replication-factor 3 --partitions 1 --topic mytest
$ docker exec -it kf1 /kafka/kafka_2.12-2.3.0/bin/kafka-topics.sh --describe --zookeeper zoo1:2181,zoo2:2181,zoo3:2181 --topic mytest

# 消息测试
$ docker exec -it kf1 /kafka/kafka_2.12-2.3.0/bin/kafka-console-consumer.sh --bootstrap-server kf1:9092,kf2:9092,kf3:9092 --topic mytest --from-beginning
$ docker exec -it kf1 /kafka/kafka_2.12-2.3.0/bin/kafka-console-producer.sh --broker-list kf1:9092,kf2:9092,kf3:9092 --topic mytest
```
