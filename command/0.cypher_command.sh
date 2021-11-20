# 1.初始化数据
  ./bin/neo4j/-admin import --nodes Person.csv --nodes Phone.csv --nodes Apllication.csv --relationships
  Person_Apllication.csv --relationships Person_Relation.csv --relationships Phone_Phone.csv --relationships Person_Phone.csv

# 2.APOC-JDBC语法（可以返回以行为单位的数据流，使用这些行更新或者创建图形数据结构）
  call
  apoc.load.jdbc("jdbc:mysql://{IP}:{PORT}/{DBNAME}?user={USERNAME}&password={PASSWAORD}","TABLENAME")yield row

# 3.cypher查询语句 match相当于sql中的select
  eg1:
    match (node)-[relationship]-(node)
    where (node|relationship)
    return (node|relationship)

  eg2:#n是Person的别名
    match (n:Person) return n limit 10

  eg3:#关系查询
    match (n:Person)-[:HAS_PHONE]-(p:Phone) ruturn n,p limit 10

  eg4:#where
    match (n:Person)-[:HAS_PHONE]-(p:Phone) where n.name="姓名6" ruturn n,p limit 10

  eg5:#多维关系查询
    match (n:Person)-[:HAS_PHONE]->(p:Phone)-[:CALL]->(p1.Phone) where n.name="姓名6" ruturn n,p,p1 limit 10

  eg6:#实体查询
    match p=()-[c:CALL]-() return p limit 10

  eg7:#正则法查找,使用波浪线~
    match(n:USERS) where n.names=~'Jack.*' return n limit 10

  eg8:#包含
    match (n:USERS) where n.name contains 'J' return n limit 1

  eg9:#创建实体
    create (n:Person)-[:LOVES]->(m:dog)

  eg10:#创建带有属性的实体
    create (n:Person{name:"李四"})-[:FEAR{"LEVEL":1}]-> (t:Tiger{type:"东北虎"})

  eg11:#创建孤立的实体,并为孤立的实体连接关系
    create (n:Person(name:"赵六"))
    create (n:Person(name:"王五"))
    match (n:Person(name:"赵六")),(m:Person(name:"王五")) create (m)-[k:know]->(n) return k

  eg12:#merge,无则新建,有则返回;create,不管有没都创建
    match (n:Persom(name:"赵六")),(m:Persom(name:"王五")) merge (m)-[l:love]->(n) return l

  eg13:#删除实体关系1
    match (n:Person(name:"赵六"))
    delete n

  eg14:#删除实体关系2
    match (n:Person)-[l:love]-> (t:Tiger)
    delete n,l,t

  eg15:#给实体加上另一个标签,使用set,一个实体可以有多个标签
    match (t:Tiger) where id(t)=1837 set t:A Return t

  eg16:#给实体加上属性,使用set
    match (a:A) where id(a)=1837 set a.年龄=10 return a
    match (n:Person)-[l:Love]-(:Person) set l.date = "1990" return n,l

  eg17:创建索引,能提高查询速度
    语法:create index on :<标签名称>(属性名称),创建的在索引的
    create index on :Person(name)

  eg18:删除索引
    drop index on :Person(name)

  eg19:给索引创建/删除约束
    create contraint on :Person(name) assert (p.name) is unique
    drop contraint on :Person(name) assert (p.name) is unique

  eg20:删除所有数据
    match (n) detach delete n

# 4.cypher的复杂查询
  eg1:姓名12 他的三度內的朋友有哪些
  match (p:Persopn)-[:FREIEND_OF]-(p1:Persion)-[:FREIEND_OF]-(p2:Person)
  where p.name = "姓名12" return p,p1,p2

  eg2:姓名12 他的三度內有关系的有哪些
  match (p:Persopn)-[]-(p1:Person)-[]-(p2:Person)
    where p.name = "姓名12" return p,p1,p2

  eg3:姓名11 的通话记录中的电话有哪些
  match (p:Person)-[:HAS_PHONE]->(p2:Phone)-[:CALL]-[H:Phone] where p.name = "姓名11"
  return p1,p2,h2

  eg4:查询姓名2 和姓名10 的最短路径shortestpath
  match (p1:Person{name:"姓名2"}), (p2:Person{name:"姓名10"}), p=shortestpath((p1)-[*..10]-(p2))
  return p

  eg5:查询姓名2 和姓名10 的所有最短路径shortestpaths
    match (p1:Person{name:"姓名2"}), (p2:Person{name:"姓名10"}), p=shortestpaths((p1)-[*..10]-(p2))
    return p
  
  eg6:删除索引和约束
    CALL apoc.schema.assert({},{},true) YIELD label, key
    RETURN *

# 5.规则编写
  eg1:#申请人之前有多少个逾期的进件
  match (p:Person)-[h:HAS_APPLICATION]-[a:APPLICATION] where a.status = "OVER_DUE" and
  p.personID="243001" return count(a)

  eg2:申请人的一度关系中有多少个触碰黑名单
  match(p:Person)-[]-(p1:Person)-[h:HAS_PHONE]-(b:Black) where p.personID="243010"
  return count(b)

  eg3:申请人的二度关系中有多少个触碰黑名单
    match(p:Person)-[]-(p1:Person)-[h:HAS_PHONE]-(p1:Person)-[h:HAS_PHONE]-(b:Black) where p.personID="243010"
  return count(b)

# 6.微服务--springboot--在mysql中加入相应规则
  eg1:申请人之前有多少个逾期的进件(替换具体人物¥)
  match (p:Person)-[h:HAS_APPLICATION]-[a:APPLICATION] where a.status = "OVER_DUE" and
  p.personID=$personID return count(a)

  eg2:申请人的一度关系中有多少个触碰黑名单(替换具体人物¥)
  match(p:Person)-[]-(p1:Person)-[h:HAS_PHONE]-(b:Black) where p.personID=$personID
  return count(b)

  eg3:申请人的二度关系中有多少个触碰黑名单
    match(p:Person)-[]-(p1:Person)-[h:HAS_PHONE]-(p1:Person)-[h:HAS_PHONE]-(b:Black) where p.personID=$personID
  return count(b)

  eg4:springboot swagger网址
  http://localhost:8888/swagger-ui-html