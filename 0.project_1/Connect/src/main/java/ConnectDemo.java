import org.neo4j.driver.AuthTokens;
import org.neo4j.driver.Driver;
import org.neo4j.driver.GraphDatabase;
import org.neo4j.driver.Session;

public class ConnectDemo {
    public static void main(String[] args) {
        Driver driver = GraphDatabase.driver("bolt://localhost:7687", AuthTokens.basic("neo4j", "199915"));
        Session session = driver.session();
        String cypher = "create (b:bbbb) ";
        session.run(cypher);
        session.close();
        driver.close();
    }
}