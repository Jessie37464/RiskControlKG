package com.greedy.ai.controller;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import org.mybatis.spring.SqlSessionTemplate;
import org.neo4j.driver.v1.Driver;
import org.neo4j.driver.v1.Record;
import org.neo4j.driver.v1.Session;
import org.neo4j.driver.v1.StatementResult;
import org.springframework.beans.factory.annotation.Autowire;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;


@RestController
@Api(value = "v1", description = "规则引擎服务")
@RequestMapping("v1")
public class RuleController {
    @Autowired
    private SqlSessionTemplate template;

    @Autowired
    private Driver driver;

    @ApiOperation(value = "获取规则引擎中规则执行的结果", httpMethod = "POST")
    @RequestMapping(value = "/getRuleResult", method = RequestMethod.POST)
    public int getRuleResult(@RequestParam String ruleID, @RequestParam String PersonID){
        //从mysql中拿到规则
        String ruleCypher = template.selectOne("getRule", ruleID);

        //获取neo4j的session对象，用来执行cypher语句
        Session session = driver.session();
        Map ruleMap = new HashMap();
        ruleMap.put("PersonId",  PersonID);

         //用来存储Cypher最终执行的结果
        int resultCount = 0;

        //执行Cypher语句
        StatementResult result = session.run(ruleCypher, ruleMap);

        Map resultMap = new HashMap();
        while (result.hasNext()){
            Record record = result.next();
            resultMap = record.asMap();
            Long resultLong = (Long) resultMap.get("count(b)");
            resultCount = Math.toIntExact(resultLong);
        }
        return resultCount;
    }

}
