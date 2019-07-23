# kafka-docker
使用docker管理kafka集群

# Zookeeper
拉取对应的镜像
```
$ docker pull zookeeper:3.4.14
```

使用docker-compose.yml启动ZK集群
```
$ docker-compose -f docker-compose-zk.yml up
```

测试集群
```
$ docker network ls
$ docker run -it \
		--rm \
        --link zoo1:zk1 \
        --link zoo2:zk2 \
        --link zoo3:zk3 \
        --net kafka-docker_mynet1 \
        zookeeper /zookeeper/zookeeper-3.4.14/bin/zkCli.sh -server zk1:2181,zk2:2181,zk3:2181
```


# 下载安装包到PKG目录
1. kafka: http://mirrors.tuna.tsinghua.edu.cn/apache/kafka/2.3.0/kafka_2.12-2.3.0.tgz
2. zookeeper: https://mirrors.tuna.tsinghua.edu.cn/apache/zookeeper/zookeeper-3.4.14/zookeeper-3.4.14.tar.gz

# 安装镜像
```
$ docker build -t java-base -f Dockerfile-java-base .
$ docker build -t zookeeper -f Dockerfile-zookeeper .
$ docker build -t kafka -f Dockerfile-kafka .
```

# 配置
## zookeeper
创建数据文件：
```
$ sudo mkdir -p /opt/zookeeper/data
$ sudo chmod -R 777 /opt/zookeeper/data
```

zoo.cfg 按需修改配置文件：
1. dataDir=/zookeeper/data
2. clientPort=2181

## kafka
按需复制server.properties文件，建议命名为server.properties.n。

例如：
```
$ cp server.properties.example server.properties.1
$ cp server.properties.example server.properties.2
$ cp server.properties.example server.properties.3
```

为每个新复制的文件更新配置：
1. broker.id=1 # 保证每个文件的broker唯一
2. zookeeper.connect=zookeeper:2181	# 通过docker-compose启动，默认可以连上zookeeper这个container


# 启动测试
```
# 启动服务
$ cd kafka-docker
$ docker-compose up

# 创建topic
$ bin/kafka-topics.sh --create --zookeeper 0.0.0.0:2181 --replication-factor 3 --partitions 1 --topic mytest
$ bin/kafka-topics.sh --describe --zookeeper 0.0.0.0:2181 --topic mytest

# 消息测试
$ bin/kafka-console-producer.sh --broker-list 0.0.0.0:9092 --topic mytest
$ bin/kafka-console-consumer.sh --bootstrap-server 0.0.0.0:9092 --topic mytest --from-beginning
```

# 部署服务
```
$ docker stack deploy -c docker-compose.yml kafka_v1
```
