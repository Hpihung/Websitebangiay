package services.admin;

import dao.JDBIConnector;
import org.mindrot.jbcrypt.BCrypt;

public class AdminService
{

    public String adminGetUserName(int adminId)
    {
        String sql = """
                SELECT full_name
                FROM users
                WHERE LOWER(role) = 'admin' AND id = :adminId;
                """;
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("adminId", adminId)
                        .mapTo(String.class)
                        .findOne()
                        .orElse(null)
        );
    }
    public void adminUpdateUserName(int adminId, String userName)
    {
        String sql = """
                UPDATE users
                SET full_name = :userName
                WHERE id = :adminId AND LOWER(role) = 'admin';
                """;
        JDBIConnector.getJdbi().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("userName", userName)
                        .bind("adminId", adminId)
                        .execute());
    }
    public void adminUpdatePassword(int adminId, String rawPassword)
    {
        String sql = """
            UPDATE users
            SET password_hash = :hash_password
            WHERE id = :adminId AND LOWER(role) = 'admin';
            """;
        String hashed = BCrypt.hashpw(rawPassword, BCrypt.gensalt());
        JDBIConnector.getJdbi().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("hash_password", hashed)
                        .bind("adminId", adminId)
                        .execute()
        );
    }
    public boolean adminCheckPassword(int adminId, String rawPassord)
    {
        String sql = """
                SELECT password_hash
                FROM users
                WHERE LOWER(role) = 'admin' AND id = :adminId;
                """;
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("adminId",adminId)
                        .mapTo(String.class)
                        .findOne()
                        .map(hash -> BCrypt.checkpw(rawPassord,hash))
                        .orElse(false));
    }
}
