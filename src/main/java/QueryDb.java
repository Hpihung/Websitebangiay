import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;

public class QueryDb {
    public static void main(String[] args) {
        Jdbi jdbi = JDBIConnector.getJdbi();
        jdbi.useHandle(h -> {
            System.out.println("=== PRODUCT STATUS ===");
            h.createQuery("SELECT id, name, is_available, is_discontinue, status FROM product WHERE id IN (28, 29, 31, 33, 34, 46, 82)")
             .mapToMap()
             .list()
             .forEach(System.out::println);
            System.out.println("==================");
        });
    }
}
