package dao;

import model.Contact;
import java.util.List;

public class ContactDao {

    public void insertContact(String name, String email, String phone, String subject, String message) {
        JDBIConnector.getJdbi().useHandle(handle -> {
            handle.createUpdate("INSERT INTO contacts (name, email, phone, subject, message, created_at) " +
                    "VALUES (:name, :email, :phone, :subject, :message, NOW())")
                  .bind("name", name)
                  .bind("email", email)
                  .bind("phone", phone)
                  .bind("subject", subject)
                  .bind("message", message)
                  .execute();
        });
    }

    public List<Contact> getAllContacts() {
        return JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery("SELECT id, name, email, phone, subject, message, is_read as isRead, created_at as createdAt " +
                               "FROM contacts ORDER BY created_at DESC")
                  .mapToBean(Contact.class)
                  .list()
        );
    }

    public int getUnreadCount() {
        return JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery("SELECT COUNT(*) FROM contacts WHERE is_read = FALSE")
                  .mapTo(Integer.class)
                  .one()
        );
    }

    public void markAsRead(int id) {
        JDBIConnector.getJdbi().useHandle(handle -> {
            handle.createUpdate("UPDATE contacts SET is_read = TRUE WHERE id = :id")
                  .bind("id", id)
                  .execute();
        });
    }

    public void markAllAsRead() {
        JDBIConnector.getJdbi().useHandle(handle -> {
            handle.createUpdate("UPDATE contacts SET is_read = TRUE WHERE is_read = FALSE")
                  .execute();
        });
    }
    
    public void deleteContact(int id) {
        JDBIConnector.getJdbi().useHandle(handle -> {
            handle.createUpdate("DELETE FROM contacts WHERE id = :id")
                  .bind("id", id)
                  .execute();
        });
    }
}
