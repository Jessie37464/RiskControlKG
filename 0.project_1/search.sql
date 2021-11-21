-- # 导入语句
  位于0.data2sql.ipynb

-- # 搜索语句mysl
SELECT * FROM kg.apply
SELECT * FROM kg.person limit 10
SELECT * FROM kg.phone limit 10

-- # cypher语法，Connect工程文件也可使用
  -- #cypher导入实体
  LOAD CSV FROM 'file:///person.csv' AS line
  CREATE (person:PERSON {id:line[0],name:line[1],sex:line[2],phone:line[3]})

  LOAD CSV FROM 'file:///phone.csv' AS line
  CREATE (phone:PHONE {from:line[0],to:line[1],start_time:line[2],end_time:line[3]})

  LOAD CSV FROM 'file:///apply.csv' AS line
  CREATE (apply:APPLY {id:line[0],amount:line[1],term:line[2],job:line[3],city:line[4],parent_phone:line[5],
                      colleague_phone:line[6],company_phone:line[7],applicant:line[8],status:line[9]})

  -- #cypher导入关系
  MATCH(n:PERSON),(m:PHONE) where n.phone = m.from  create(n)<-[r:RECEIVE]-(m) return r
  MATCH(n:PERSON),(m:PHONE) where n.phone = m.to  create(n)-[c:CALL]->(m) return c
  MATCH(n:PERSON),(m:APPLY) where n.id = m.applicant  create(n)<-[c:PERSON_INFO]-(m) return h

  -- #cypher删除关系
  MATCH (:PERSON)-[r:PERSON_INFO]-(:APPLY) 
  DELETE r

  -- #cypher删除实体
  MATCH(n:APPLY) DETACH
  DELETE n

-- #apoc语法，Connect工程文件也可使用, APOC语法的导入速度更快, 属性也不用单独配置
  -- #导入实体和属性
    CALL apoc.periodic.iterate('CALL apoc.load.csv(\'person.csv\') yield map as row return row',
                                'CREATE (person:PERSON) SET person = row', 
                                {batchSize:10000, iterateList:true, parallel:true})

    CALL apoc.periodic.iterate('CALL apoc.load.csv(\'phone.csv\') yield map as row return row',
                                'CREATE (phone:PHONE) SET phone = row', 
                                {batchSize:10000, iterateList:true, parallel:true})


    CALL apoc.periodic.iterate('CALL apoc.load.csv(\'apply.csv\') yield map as row return row',
                                'CREATE (apply:APPLY) SET apply = row', 
                                {batchSize:10000, iterateList:true, parallel:true})

-- 导入关系
  MATCH(n:PERSON),(m:PHONE) where n.phone = m.from  merge(n)<-[r:RECEIVE]-(m) return r
  MATCH(n:PERSON),(m:PHONE) where n.phone = m.to  merge(n)-[c:CALL]->(m) return c
  MATCH(n:PERSON),(m:APPLY) where n.id = m.applicant  merge(n)<-[c:PERSON_INFO]-(m) return c


