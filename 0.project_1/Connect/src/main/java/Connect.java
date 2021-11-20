import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;

public class Connect {
    public static void main(String[] args) {
        Driver driver = GraphDatabase.driver("bolt://localhost:7687", AuthTokens.basic("neo4j", "199915"));
        Session session = driver.session();
        String person_cypher = "CALL apoc.periodic.iterate('CALL apoc.load.csv(\\'person.csv\\') yield map as row return row',\n" +
                "                                'CREATE (person:PERSON) SET person = row', \n" +
                "                                {batchSize:10000, iterateList:true, parallel:true})";
        session.run(person_cypher);
        String phone_cypher = "CALL apoc.periodic.iterate('CALL apoc.load.csv(\\'phone.csv\\') yield map as row return row',\n" +
                "                                'CREATE (phone:PHONE) SET phone = row', \n" +
                "                                {batchSize:10000, iterateList:true, parallel:true})";
        session.run(phone_cypher);
        String apply_cypher = "CALL apoc.periodic.iterate('CALL apoc.load.csv(\\'apply.csv\\') yield map as row return row',\n" +
                "                                'CREATE (apply:APPLY) SET apply = row', \n" +
                "                                {batchSize:10000, iterateList:true, parallel:true})";
        session.run(apply_cypher);
        String relation_cypher = "MATCH(n:PERSON),(m:PHONE) where n.phone = m.from  merge(n)<-[r:RECEIVE]-(m) return r";
        session.run(relation_cypher);
        String relation_cypher2 = "MATCH(n:PERSON),(m:PHONE) where n.phone = m.to  merge(n)-[c:CALL]->(m) return c";
        session.run(relation_cypher2);
        String relation_cypher5 = "MATCH(n:PERSON),(m:APPLY) where n.id = m.applicant  merge(n)<-[c:PERSON_INFO]-(m) return c";
        session.run(relation_cypher5);
        session.close();
        driver.close();
    }
}