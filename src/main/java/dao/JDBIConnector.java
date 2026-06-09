package dao;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.jdbi.v3.core.Jdbi;

import java.sql.SQLException;

public class JDBIConnector {

    private static Jdbi jdbi;

    public static Jdbi getJdbi() {
        if (jdbi == null) {
            connect();
            runMigrations();
        }
        return jdbi;
    }

    private static void connect() {
        HikariConfig config = new HikariConfig();

        config.setDriverClassName("com.mysql.cj.jdbc.Driver");
        config.setJdbcUrl("jdbc:mysql://localhost:3306/ltw_sportshoess?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh");
        config.setUsername("root");
        config.setPassword("123456");

        // Cấu hình Connection Pool tối ưu
        config.setMaximumPoolSize(25);      // Số kết nối tối đa được phép mở
        config.setMinimumIdle(5);           // Giữ tối thiểu 5 kết nối rảnh
        config.setIdleTimeout(300000);      // Giải phóng kết nối rảnh sau 5 phút
        config.setConnectionTimeout(20000); // Đợi tối đa 20 giây để mượn kết nối từ pool

        // Các thuộc tính tối ưu hóa MySQL Driver khi dùng pool
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");

        HikariDataSource ds = new HikariDataSource(config);
        jdbi = Jdbi.create(ds);
    }

    private static void runMigrations() {
        try {
            jdbi.useHandle(handle -> {
                try {
                    handle.execute("ALTER TABLE promotion ADD COLUMN is_flash_sale TINYINT(1) DEFAULT 0");
                    System.out.println("Migration: Added column is_flash_sale to promotion table");
                } catch (Exception e) {
                    // Already added or error
                }
                try {
                    handle.execute("UPDATE banner SET link_url = REPLACE(link_url, '/collectio/', '/collection/') WHERE link_url LIKE '/collectio/%'");
                    System.out.println("Migration: Corrected typo /collectio/ -> /collection/ in banner link URLs");
                } catch (Exception e) {
                    // Already corrected or error
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Test nhanh kết nối DB
    public static void main(String[] args) {
        Jdbi jdbi = JDBIConnector.getJdbi();
        jdbi.useHandle(h -> {
            System.out.println("--- DB PRODUCTS ---");
            System.out.println(h.createQuery("SELECT id, name, price FROM product WHERE id IN (94, 98, 99)").mapToMap().list());
            System.out.println("-------------------");
        });
    }


}
