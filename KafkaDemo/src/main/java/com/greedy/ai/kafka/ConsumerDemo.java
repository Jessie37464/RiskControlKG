package com.greedy.ai.kafka;

import org.apache.kafka.clients.consumer.ConsumerRecord;
import org.apache.kafka.clients.consumer.ConsumerRecords;
import org.apache.kafka.clients.consumer.KafkaConsumer;

import java.time.Duration;
import java.util.Arrays;
import java.util.Properties;

public class ConsumerDemo {
    public static void main(String[] args) {
        Properties pros = new Properties();
        pros.put("bootstrap.servers", "localhost:9092");
        pros.put("group.id", "test");//用来表示消费者进程所在组的一个字符串，如果设置同样的group_id，表示进程属于同一个consumer group
        pros.put("enable.auto.commit", "true");//如果设置为真，consumer所接到的消息offset将会自动同步到zookeeper
        pros.put("auto.commit,interval.ms", "1000");//consumer向zookeeper提交offset的频率，单位为秒
        pros.put("key.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");
        pros.put("value.deserializer", "org.apache.kafka.common.serialization.StringDeserializer");

        KafkaConsumer<String, String> consumer = new KafkaConsumer<String, String>(pros);
        consumer.subscribe(Arrays.asList("my_test"));

        while (true){
            ConsumerRecords<String,String> records = consumer.poll(Duration.ofSeconds(1));
            for(ConsumerRecord<String, String> record: records){
                System.out.printf("offset=%d, key=%s, value=%s%n", record.offset(), record.key(), record.value());
            }
        }
    }
}
