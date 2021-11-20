  -- #cypher删除关系
  MATCH (:PERSON)-[r:PERSON_INFO]-(:APPLY) 
  DELETE r

  -- #cypher删除实体
  MATCH(n:APPLY) DETACH
  DELETE n

-- #apoc语法，Connect工程文件也可使用, APOC语法的导入速度更快, 属性也不用单独配置
-- #导入实体和属性
    CALL apoc.periodic.iterate('CALL apoc.load.csv(\'./hw2/person.csv\') yield map as row return row',
                                'CREATE (person:PERSON) SET person = row', 
                                {batchSize:10000, iterateList:true, parallel:true})

    CALL apoc.periodic.iterate('CALL apoc.load.csv(\'./hw2/phone2phone.csv\') yield map as row return row',
                                'CREATE (phone:PHONE) SET phone = row', 
                                {batchSize:10000, iterateList:true, parallel:true})

    CALL apoc.periodic.iterate('CALL apoc.load.csv(\'./hw2/apply_train.csv\') yield map as row return row',
                                'CREATE (apply:APPLY) SET apply = row', 
                                {batchSize:10000, iterateList:true, parallel:true})

    CALL apoc.periodic.iterate('CALL apoc.load.csv(\'./hw2/phone.csv\') yield map as row return row',
                            'CREATE (blackinfo:BLACKINFO) SET blackinfo = row', 
                            {batchSize:10000, iterateList:true, parallel:true})

-- 导入关系
  MATCH(n:PERSON),(m:PHONE) where n.phone = m.from  merge(n)<-[r:RECEIVE]-(m) return r
  MATCH(n:PERSON),(m:PHONE) where n.phone = m.to  merge(n)-[c:CALL]->(m) return c
  MATCH(n:PERSON),(m:APPLY) where n.id = m.applicant  merge(n)<-[c:PERSON_INFO]-(m) return c
  MATCH(n:PERSON),(m:BLACKINFO) where n.phone = m.number  merge(n)-[c:check_black]->(m) return c
  

