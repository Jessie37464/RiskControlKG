# ## 终端上运行
# # 删除表
DROP TABLE if exists kg.apply;
# # 创建库
CREATE DATABASE IF NOT EXISTS kg;
# # 创建表,单独设置主键
CREATE TABLE kg.apply(id BIGINT,amount BIGINT,term BIGINT,job VARCHAR(20),city VARCHAR(20),parent_phone BIGINT, colleague_phone BIGINT,company_phone BIGINT,applicant BIGINT,status VARCHAR(20));
alter table kg.apply add primary key(id);
# # 导入csv文件
load data local infile '/Users/zhengqixin/1.学习/18.RiskControlKG/1.project_2/data/apply_train.csv' into table kg.apply FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;


## person表
# ## 终端上运行
# # 删除表
DROP TABLE if exists kg.person;
# # 创建库
CREATE DATABASE IF NOT EXISTS kg;
# # 创建表，单独设置主键
CREATE TABLE IF NOT EXISTS kg.person(id BIGINT,name VARCHAR(20),sex VARCHAR(20),phone BIGINT,flag VARCHAR(20));
alter table kg.person add primary key(id);
# # 导入csv文件
load data local infile '/Users/zhengqixin/1.学习/18.RiskControlKG/1.project_2/data/person.csv' into table kg.person FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;


## phone表
# ## 终端上运行
# # 删除表
DROP TABLE if exists kg.phone;
# # 创建库
CREATE DATABASE IF NOT EXISTS kg;
# # 创建表,建表时，设置自增id为主键
CREATE TABLE IF NOT EXISTS kg.phone(from_id BIGINT,to_id BIGINT,start_time VARCHAR(20),end_time VARCHAR(20),id int primary key auto_increment);
# # 导入csv文件
load data local infile '/Users/zhengqixin/1.学习/18.RiskControlKG/1.project_2/data/phone2phone.csv' into table kg.phone FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;


## phone_info表
# ## 终端上运行
# # 删除表
DROP TABLE if exists kg.phone_info;
# # 创建库
CREATE DATABASE IF NOT EXISTS kg;
# # 创建表,建表时，设置自增id为主键
CREATE TABLE IF NOT EXISTS kg.phone_info(number BIGINT,flag VARCHAR(20));
# # 导入csv文件
load data local infile '/Users/zhengqixin/1.学习/18.RiskControlKG/1.project_2/data/phone.csv' into table kg.phone_info FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 LINES;




## 查询关系
-- select * from kg.phone limit 10

-- select * from kg.phone_info limit 10

-- select * from kg.apply limit 10

-- select * from kg.person limit 10

## rule规则表
# # 删除表
DROP TABLE if exists kg.rule;
# # 创建库
CREATE DATABASE IF NOT EXISTS kg;
# # 创建表,建表时，设置自增id为主键
CREATE TABLE IF NOT EXISTS kg.rule(id BIGINT,cypher VARCHAR(100), rule_id VARCHAR(10));
# # 导入rule
    INSERT INTO kg.rule
    (id, cypher, rule_id)
    VALUES
    ('0', 'match(p:PERSON) where p.id=$id return p.sex', 'rule001');



