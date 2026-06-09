package dao.admin.user;

import dao.JDBIConnector;
import model.Collection.Collection;
import org.jdbi.v3.core.Jdbi;

import java.util.List;

public class CollectionDao {

    private final Jdbi jdbi;

    public CollectionDao() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    /* ================= FIND ================= */

    public List<Collection> findAll() {
        String sql = """
            SELECT *
            FROM collection
            ORDER BY id DESC
        """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .mapToBean(Collection.class)
                        .list()
        );
    }

    /**
     * FILTER theo name + ruleSet
     */
    public List<Collection> filter(String name, String ruleSet) {
        StringBuilder sbSQL = new StringBuilder("""
                    SELECT *
                    FROM collection
                    WHERE 1 = 1
                """);

        if (name != null && !name.isBlank()) {
            sbSQL.append(" AND name LIKE :name ");
        }

        if (ruleSet != null && !ruleSet.isBlank()) {
            sbSQL.append(" AND rule_set_type = :ruleSet ");
        }

        sbSQL.append(" ORDER BY id DESC ");

        return jdbi.withHandle(h -> {
            var query = h.createQuery(sbSQL.toString());

            if (name != null && !name.isBlank()) {
                query.bind("name", "%" + name.trim() + "%");
            }

            if (ruleSet != null && !ruleSet.isBlank()) {
                query.bind("ruleSet", ruleSet);
            }

            return query.mapToBean(Collection.class).list();
        });
    }

    public Collection findById(int id) {
        String sql = "SELECT * FROM collection WHERE id = :id";

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("id", id)
                        .mapToBean(Collection.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public Collection findBySlug(String slug) {
        String sql = """
            SELECT *
            FROM collection
            WHERE slug = :slug
            LIMIT 1
        """;

        return jdbi.withHandle(h ->
                h.createQuery(sql)
                        .bind("slug", slug)
                        .mapToBean(Collection.class)
                        .findOne()
                        .orElse(null)
        );
    }

    /* ================= INSERT ================= */

    public void insert(Collection collection) {
        String sql = """
            INSERT INTO collection(name, slug, rule_set_type, is_active)
            VALUES (:name, :slug, :ruleSetType, :active)
        """;

        jdbi.useHandle(h ->
                h.createUpdate(sql)
                        .bindBean(collection)
                        .execute()
        );
    }

    /* ================= UPDATE ================= */

    public void update(Collection collection) {
        String sql = """
            UPDATE collection SET
                name = :name,
                slug = :slug,
                rule_set_type = :ruleSetType,
                is_active = :active
            WHERE id = :id
        """;

        jdbi.useHandle(h ->
                h.createUpdate(sql)
                        .bindBean(collection)
                        .execute()
        );
    }

    /* ================= SOFT DELETE ================= */

    public void delete(int id) {
        String sql = "UPDATE collection SET is_active = 0 WHERE id = :id";

        jdbi.useHandle(h ->
                h.createUpdate(sql)
                        .bind("id", id)
                        .execute()
        );
    }
}
