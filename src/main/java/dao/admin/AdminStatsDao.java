package dao.admin;

import DTO.MonthlyRevenueDTO;
import DTO.TopCustomerDTO;
import DTO.TopProductDTO;
import dao.JDBIConnector;
import org.jdbi.v3.core.Jdbi;

import java.math.BigDecimal;
import java.util.List;

public class AdminStatsDao {

    private final Jdbi jdbi;

    public AdminStatsDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public int getLatestOrderYear() {
        String sql = "SELECT COALESCE(MAX(YEAR(created_at)), YEAR(CURDATE())) FROM orders";
        return jdbi.withHandle(handle -> handle.createQuery(sql).mapTo(Integer.class).one());
    }

    public BigDecimal getTotalRevenue(Integer year, Integer month) {
        String sql = "SELECT COALESCE(SUM(grand_total), 0) FROM orders WHERE order_status = 'ORDER_COMPLETED'";
        if (year != null) {
            sql += " AND YEAR(created_at) = :year";
        }
        if (month != null) {
            sql += " AND MONTH(created_at) = :month";
        }
        String finalSql = sql;
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql);
            if (year != null) query.bind("year", year);
            if (month != null) query.bind("month", month);
            return query.mapTo(BigDecimal.class).one();
        });
    }

    public int getTotalOrders(Integer year, Integer month) {
        String sql = "SELECT COUNT(*) FROM orders";
        boolean hasWhere = false;
        if (year != null) {
            sql += " WHERE YEAR(created_at) = :year";
            hasWhere = true;
        }
        if (month != null) {
            sql += (hasWhere ? " AND " : " WHERE ") + "MONTH(created_at) = :month";
        }
        String finalSql = sql;
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql);
            if (year != null) query.bind("year", year);
            if (month != null) query.bind("month", month);
            return query.mapTo(Integer.class).one();
        });
    }

    public int getTotalUsers(Integer year, Integer month) {
        String sql = "SELECT COUNT(*) FROM users";
        boolean hasWhere = false;
        if (year != null) {
            sql += " WHERE YEAR(created_at) = :year";
            hasWhere = true;
        }
        if (month != null) {
            sql += (hasWhere ? " AND " : " WHERE ") + "MONTH(created_at) = :month";
        }
        String finalSql = sql;
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql);
            if (year != null) query.bind("year", year);
            if (month != null) query.bind("month", month);
            return query.mapTo(Integer.class).one();
        });
    }

    public List<TopProductDTO> getTop10Products(Integer year, Integer month) {
        String sql = """
                SELECT p.id as productId, p.name, 
                       (SELECT img_url FROM product_img WHERE product_id = p.id AND sort_order = 0 LIMIT 1) as image,
                       SUM(od.quantity) as totalSold,
                       SUM(od.subtotal) as totalRevenue
                FROM order_detail od
                JOIN product p ON od.product_id = p.id
                JOIN orders o ON od.order_id = o.id
                WHERE o.order_status = 'ORDER_COMPLETED'
                """;
        if (year != null) {
            sql += " AND YEAR(o.created_at) = :year";
        }
        if (month != null) {
            sql += " AND MONTH(o.created_at) = :month";
        }
        sql += " GROUP BY p.id, p.name ORDER BY totalSold DESC LIMIT 10";
        
        String finalSql = sql;
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql);
            if (year != null) query.bind("year", year);
            if (month != null) query.bind("month", month);
            return query.mapToBean(TopProductDTO.class).list();
        });
    }

    public List<TopCustomerDTO> getTop5Customers(Integer year, Integer month) {
        String sql = """
                SELECT u.id as userId, u.full_name as fullName, u.email,
                       COUNT(o.id) as orderCount,
                       SUM(o.grand_total) as totalSpent
                FROM orders o
                JOIN users u ON o.user_id = u.id
                WHERE o.order_status = 'ORDER_COMPLETED'
                """;
        if (year != null) {
            sql += " AND YEAR(o.created_at) = :year";
        }
        if (month != null) {
            sql += " AND MONTH(o.created_at) = :month";
        }
        sql += " GROUP BY u.id, u.full_name, u.email ORDER BY totalSpent DESC LIMIT 5";

        String finalSql = sql;
        return jdbi.withHandle(handle -> {
            var query = handle.createQuery(finalSql);
            if (year != null) query.bind("year", year);
            if (month != null) query.bind("month", month);
            return query.mapToBean(TopCustomerDTO.class).list();
        });
    }

    public List<MonthlyRevenueDTO> getMonthlyRevenue(int year) {
        String sql = """
                SELECT MONTH(created_at) as month, YEAR(created_at) as year,
                       SUM(grand_total) as totalRevenue,
                       COUNT(id) as orderCount
                FROM orders
                WHERE YEAR(created_at) = :year AND order_status = 'ORDER_COMPLETED'
                GROUP BY MONTH(created_at), YEAR(created_at)
                ORDER BY month ASC
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .bind("year", year)
                .mapToBean(MonthlyRevenueDTO.class)
                .list());
    }

    // Fallback for Staff since no tracking exists in orders
    public List<TopCustomerDTO> getTopStaff() {
        String sql = """
                SELECT id as userId, full_name as fullName, email,
                       0 as orderCount, 0 as totalSpent
                FROM users
                WHERE LOWER(role) = 'admin'
                LIMIT 5
                """;
        return jdbi.withHandle(handle -> handle.createQuery(sql)
                .mapToBean(TopCustomerDTO.class)
                .list());
    }
}
