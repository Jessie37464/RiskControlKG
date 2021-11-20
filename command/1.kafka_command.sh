#7.kafka命令行--单点kafka环境部署
#kafka安装路径:/Users/zhengqixin/kafka_2.13-3.0.0
	7.1 #启动zookeeper(所有的主从配置、管理都在这)
		bin/zookeeper-server-start.sh config/zookeeper.properties

	7.2 #kafak server服务启动
		bin/kafka-server-start.sh config/server.properties

	7.3 #创建主题
		bin/kafka-topics.sh --create  --bootstrap-server localhost:9092 --replication-factor 1 --partitions 1 --topic my_test

	7.4 #查看主题
		bin/kafka-topics.sh --list --bootstrap-server localhost:9092
  
  7.5 #生产者启动
    bin/kafka-console-producer.sh --broker-list localhost:9092 --topic mytest
  
  7.6 #消费者启动
    bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic mytest --from-beginning

#8.kafka命令行--kafka集群环境部署(在7的基础上进行下面的操作)
  8.1 #拷贝配置文件
    cp config/server.properties config/server-1.properties
  
  8.2 #修改配置文件(每个文件修改三个地方)
    vim config/server-1.properties
      broker.id=0 --> broker.id=1
      listeners=PLAINTEXT://:9092 --> listeners=PLAINTEXT://:9093
      log.dirs=/tmp/kafka-logs --> log.dirs=/tmp/kafka-logs-1

    vim config/server-2.properties
      broker.id=0 --> broker.id=2
      listeners=PLAINTEXT://:9092 --> listeners=PLAINTEXT://:9094
      log.dirs=/tmp/kafka-logs --> log.dirs=/tmp/kafka-logs-2

  8.3 #kafak server服务启动
		bin/kafka-server-start.sh config/server-1.properties
    bin/kafka-server-start.sh config/server-2.properties

  8.4 #新创建主题
		bin/kafka-topics.sh --create  --bootstrap-server localhost:9092 --replication-factor 3 --partitions 1 --topic replication-topic

  8.5 #主题描述
    bin/kafka-topics.sh --describe --bootstrap-server localhost:9092 --topic replication-topic
  
  8.6 #生产者启动
    bin/kafka-console-producer.sh --broker-list localhost:9092 --topic mytest
  
  8.7 #消费者启动
    bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic mytest --from-beginning

