package services.admin;

import dao.JDBIConnector;

public class SettingService {

    /* ========== SETTING ========== */
    public void settingUpdate(String key, String value) {
        String sql = """
            UPDATE setting
            SET value = :value
            WHERE key_name = :key
        """;

        JDBIConnector.getJdbi().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("value", value)
                        .bind("key", key)
                        .execute()
        );

    }

    // ===== GET A SETTING ===== //
    public String settingGet(String key) {
        String sql = """
            SELECT value
            FROM setting
            WHERE key_name = :key
        """;
        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("key",key)
                        .mapTo(String.class)
                        .findOne()
                        .orElse(null)
        );
    }

    // ===== CHECK EXIST ===== //
    public boolean settingExists(String key) {
        String sql = """
            SELECT 1
            FROM setting
            WHERE key_name = :key
        """;

        return JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("key", key)
                        .mapTo(Integer.class)
                        .findOne()
                        .isPresent()
        );
    }

    // ===== INSERT IF NOT EXISTS ===== //
    public void settingSave(String key, String value) {
        if (settingExists(key)) {
            settingUpdate(key, value);
            return;
        }

        String sql = """
            INSERT INTO setting (key_name, value)
            VALUES (:key, :value)
        """;

        JDBIConnector.getJdbi().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("key", key)
                        .bind("value", value)
                        .execute()
        );
    }
}
