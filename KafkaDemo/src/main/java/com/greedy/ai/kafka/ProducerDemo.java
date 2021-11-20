package com.greedy.ai.kafka;

import org.apache.kafka.clients.producer.KafkaProducer;
import org.apache.kafka.clients.producer.Producer;
import org.apache.kafka.clients.producer.ProducerRecord;

import java.util.Properties;

public class ProducerDemo {
    public static void main(String[] args) {
        Properties pros = new Properties();
        pros.put("bootstrap.servers", "localhost:9092");
        pros.put("asks", "all");
        pros.put("retries", 0);
        pros.put("buffer.memory", 33554432);
        pros.put("batch.size", 163824);
        pros.put("linger.ms", 1);
        pros.put("key.serializer", "org.apache.kafka.common.serialization.StringSerializer");
        pros.put("value.serializer", "org.apache.kafka.common.serialization.StringSerializer");

        Producer<String, String> producer = new KafkaProducer<String, String>(pros);
        for (int i=0; i<2; i++){
            producer.send(new ProducerRecord<String, String>("my_test", Integer.toString(i+1), Integer.toString(i)));
        }
        producer.close();
    }
}
