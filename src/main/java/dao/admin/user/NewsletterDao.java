package dao.admin.user;

import dao.JDBIConnector;
import model.user.Newsletter;

import java.util.List;

public class NewsletterDao
{
    public List<Newsletter> findAll()
    {
        String sql = "SELECT * FROM newsletter";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(Newsletter.class)
                        .list()
        );
    }

    public Newsletter findById(int id)
    {
        String sql = "SELECT * FROM newsletter WHERE id = :id";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Newsletter.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public Newsletter findByEmail(String email)
    {
        String sql = "SELECT * FROM newsletter WHERE email = :email";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("email", email)
                        .mapToBean(Newsletter.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public boolean insert(Newsletter newsletter)
    {
        String sql = """
            INSERT INTO newsletter
            (email, is_active, subscribed_at)
            VALUES (:email, :active, :subscribedAt)
        """;

        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(newsletter)
                        .execute() > 0
        );
    }

    public boolean update(Newsletter newsletter)
    {
        String sql = """
            UPDATE newsletter SET
                email = :email,
                is_active = :isActive,
                subscribed_at = :subscribedAt
            WHERE id = :id
        """;

        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("email", newsletter.getEmail())
                        .bind("isActive", newsletter.isActive())
                        .bind("subscribedAt", newsletter.getSubscribedAt())
                        .bind("id", newsletter.getId())
                        .execute() > 0
        );
    }

    public boolean delete(int id)
    {
        String sql = "DELETE FROM newsletter WHERE id = :id";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute() > 0
        );
    }

    /**
     * Toggle is_active directly in SQL to avoid any Java bean mapping issues.
     */
    public boolean toggleActive(int id)
    {
        String sql = "UPDATE newsletter SET is_active = NOT is_active WHERE id = :id";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute() > 0
        );
    }

    public List<Newsletter> filter(String email, String status) {

        StringBuilder sql = new StringBuilder("""
        SELECT * FROM newsletter
        WHERE 1=1
    """);

        if (email != null && !email.isBlank()) {
            sql.append(" AND email LIKE :email");
        }

        if ("active".equals(status)) {
            sql.append(" AND is_active = 1");
        } else if ("inactive".equals(status)) {
            sql.append(" AND is_active = 0");
        }

        sql.append(" ORDER BY subscribed_at DESC");

        return JDBIConnector.getJdbi().withHandle(h -> {
            var q = h.createQuery(sql.toString());

            if (email != null && !email.isBlank()) {
                q.bind("email", "%" + email + "%");
            }

            return q.mapToBean(Newsletter.class).list();
        });
    }
}
