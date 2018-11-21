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
我们使用的版本号是2.11（https://www.apache.org/dyn/closer.cgi?path=/kafka/2.0.0/kafka_2.11-2.0.0.tgz），下载压缩包重命名为kafka.tgz。

## 配置 server.properties（范例）
1. broker.id=1
2. listeners=PLAINTEXT://:9092
3. advertised.listeners=PLAINTEXT://host_ip:9092
4. zookeeper.connect=zk_ip:zk_port