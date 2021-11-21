-- 1.基于规则的特征

    -- 申请人的性别(person,sex)
    match(p:PERSON) where p.id="20000348" 
    return p.sex

    match(p:PERSON) where p.id=$id
    return p.sex

    -- 申请人在不在黑名单中(person,flag)
    match(p:PERSON) where p.id="20000348" 
    return p.flag

    -- 申请人的电话在不在黑名单中(phone,flag)
    match(p1:PERSON), (p2:BLACKINFO) where p1.id="20000348" and p1.phone = p2.number
    return p2.flag

    -- 申请人的贷款额度(apply_train,amount)
    match(p1:PERSON)-[:PERSON_INFO]-(p2:APPLY) where p1.id="20000348" 
    return p2.amount

    -- 申请人的贷款期限(apply_train,term)
     match(p1:PERSON)-[:PERSON_INFO]-(p2:APPLY) where p1.id="20000348" 
    return p2.term

    -- 申请人的工作(apply_train,job)
    match(p1:PERSON)-[:PERSON_INFO]-(p2:APPLY) where p1.id="20000348" 
    return p2.job 

    -- 申请人的城市(apply_train,city)
    match(p1:PERSON)-[:PERSON_INFO]-(p2:APPLY) where p1.id="20000348" 
    return p2.city 


-- 2.直接提取出来的数值类型特征

    -- 申请人的一度关系中有多少个触碰黑名单
    match(p:PERSON)-[]-(p1:PERSON)-[h:check_black]-(b:BLACKINFO) where p.id="20000348" and b.flag='BLACK'
    return count(b)

    -- 申请人的二度关系中有多少个触碰黑名单
    match(p:PERSON)-[]-(p1:PERSON)-[]-(p2:PERSON)-[h:check_black]-(b:BLACKINFO) where p.id="20000348" and b.flag='BLACK'
    return count(b)

    -- 申请人的一度关系中有多少个逾期
    match(p:PERSON)-[]-(p1:PERSON)-[h:PERSON_INFO]-(b:APPLY) where p.id="20000348" and b.status='OVERDUE'
    return count(b)

    -- 申请人的二度关系中有多少个逾期
    match(p:PERSON)-[]-(p1:PERSON)-[]-(p2:PERSON)-[h:PERSON_INFO]-(b:APPLY) where p.id="20000348" and b.status='OVERDUE'
    return count(b)