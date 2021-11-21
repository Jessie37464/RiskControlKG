package com.greedy.ai.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;

@Data
@ConfigurationProperties(prefix = "neo4j.datasource")
public class Neo4jProperties {
    private String uri;
    private String username;
    private String password;

}
