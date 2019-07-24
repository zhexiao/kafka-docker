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

按需复制server.properties文件，命名为server.properties.n
```
$ cp server.properties.example server.properties.1
$ cp server.properties.example server.properties.2
$ cp server.properties.example server.properties.3
```

为每个新复制的文件更新配置
```
# 保证每个文件的broker唯一，n=1或2或3....
1. broker.id=n 

#通过docker-compose-zk.yml启动,需要外联zoo1,zoo2,zoo3
2. zookeeper.connect=zoo1:2181,zoo2:2181,zoo3:2181 
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
