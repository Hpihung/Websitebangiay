package dao.admin.user;

import dao.JDBIConnector;
import model.user.NewsletterSchedule;
import java.util.List;

public class NewsletterScheduleDao {
    
    public List<NewsletterSchedule> findAll() {
        String sql = "SELECT * FROM newsletter_schedules ORDER BY id ASC";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .mapToBean(NewsletterSchedule.class)
                        .list()
        );
    }

    public NewsletterSchedule findById(int id) {
        String sql = "SELECT * FROM newsletter_schedules WHERE id = :id";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(NewsletterSchedule.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public boolean insert(NewsletterSchedule schedule) {
        String sql = """
            INSERT INTO newsletter_schedules (name, scheduled_at, status)
            VALUES (:name, :scheduledAt, :status)
        """;
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(schedule)
                        .execute() > 0
        );
    }

    public boolean update(NewsletterSchedule schedule) {
        String sql = """
            UPDATE newsletter_schedules SET
                name = :name,
                scheduled_at = :scheduledAt,
                status = :status
            WHERE id = :id
        """;
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bindBean(schedule)
                        .execute() > 0
        );
    }

    public boolean delete(int id) {
        String sql = "DELETE FROM newsletter_schedules WHERE id = :id";
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("id", id)
                        .execute() > 0
        );
    }
}
