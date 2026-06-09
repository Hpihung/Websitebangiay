import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;

public class MigrationScript {
    public static void main(String[] args) {
        Jdbi jdbi = JDBIConnector.getJdbi();
        try {
            jdbi.useHandle(handle -> {
                try {
                    handle.execute("ALTER TABLE orders ADD COLUMN tracking_code VARCHAR(100);");
                    System.out.println("Added tracking_code");
                } catch (Exception e) {
                    System.out.println("Column tracking_code might already exist.");
                }
                
                try {
                    handle.execute("ALTER TABLE orders ADD COLUMN shipping_unit VARCHAR(100);");
                    System.out.println("Added shipping_unit");
                } catch (Exception e) {
                    System.out.println("Column shipping_unit might already exist.");
                }
                
                try {
                    handle.execute("ALTER TABLE orders ADD COLUMN processed_by VARCHAR(100);");
                    System.out.println("Added processed_by");
                } catch (Exception e) {
                    System.out.println("Column processed_by might already exist.");
                }

                // Update old statuses
                handle.execute("UPDATE orders SET order_status = 'PENDING' WHERE order_status = 'NEW'");
                handle.execute("UPDATE orders SET order_status = 'CONFIRMED' WHERE order_status = 'PROCESSING'");
                handle.execute("UPDATE orders SET order_status = 'SHIPPING' WHERE order_status = 'DELIVERED'");
                
                System.out.println("Database migration completed successfully!");
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
