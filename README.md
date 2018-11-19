# kafka-docker
使用docker管理kafka集群

# Zookeeper
我们使用的版本号是3.4.13（http://mirrors.hust.edu.cn/apache/zookeeper/zookeeper-3.4.13/），下载压缩包重命名为zookeeper.tar.gz。

## 分布式配置
2. 对应修改zoo.cfg的配置。
```
# .1,.2,.3为myid的值。后面的值代表(主机名, 心跳端口、数据端口)
#server.my_id1=ip1:port1:port2
#server.my_id2=ip2:port1:port2
#server.my_id3=ip3:port1:port2
```
注：如果是多个服务器集群配置，则所有服务器信息都需要被列出来。

3. 修改docker-compose的ports参数映射端口出来。


$ sudo mkdir /zookeeper
$ sudo chmod -R 777 /zookeeper/
$ mkdir -p /zookeeper/s1 /zookeeper/s2 /zookeeper/s3
$ echo 1 >> /zookeeper/s1/myid
$ echo 2 >> /zookeeper/s2/myid
$ echo 3 >> /zookeeper/s3/myid
