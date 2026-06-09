package dao;

import java.util.List;

public class ReviewDao {

    public List<Integer> getReviewedProductIds(int orderId) {
        return JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery("SELECT product_id FROM reviews WHERE order_id = :orderId")
                  .bind("orderId", orderId)
                  .mapTo(Integer.class)
                  .list()
        );
    }

    public List<model.Review> getReviewsByOrderId(int orderId) {
        return JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery("SELECT id, user_id as userId, product_id as productId, order_id as orderId, " +
                               "rating, comment, image_url as imageUrl, seller_service_rating as sellerServiceRating, " +
                               "delivery_speed_rating as deliverySpeedRating, driver_rating as driverRating, " +
                               "is_anonymous as \"anonymous\", created_at as createdAt, " +
                               "COALESCE(status,'VISIBLE') as status " +
                               "FROM reviews WHERE order_id = :orderId")
                  .bind("orderId", orderId)
                  .mapToBean(model.Review.class)
                  .list()
        );
    }

    public void insertReview(int userId, int productId, int orderId, int rating, String comment,
                             String imageUrl, int sellerRating, int deliveryRating, int driverRating,
                             boolean isAnonymous) {
        JDBIConnector.getJdbi().useHandle(handle -> {
            handle.createUpdate(
                "INSERT INTO reviews (user_id, product_id, order_id, rating, comment, image_url, " +
                "seller_service_rating, delivery_speed_rating, driver_rating, is_anonymous, status) " +
                "VALUES (:userId, :productId, :orderId, :rating, :comment, :imageUrl, " +
                ":sellerRating, :deliveryRating, :driverRating, :isAnonymous, 'VISIBLE')")
                  .bind("userId", userId)
                  .bind("productId", productId)
                  .bind("orderId", orderId)
                  .bind("rating", rating)
                  .bind("comment", comment)
                  .bind("imageUrl", imageUrl)
                  .bind("sellerRating", sellerRating)
                  .bind("deliveryRating", deliveryRating)
                  .bind("driverRating", driverRating)
                  .bind("isAnonymous", isAnonymous)
                  .execute();
        });
    }

    public List<model.Review> getReviewsByProductId(int productId) {
        return JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery(
                "SELECT r.id, r.user_id as userId, r.product_id as productId, r.order_id as orderId, " +
                "r.rating, r.comment, r.image_url as imageUrl, r.created_at as createdAt, " +
                "r.is_anonymous as \"anonymous\", COALESCE(r.status,'VISIBLE') as status, u.full_name as userName " +
                "FROM reviews r LEFT JOIN users u ON r.user_id = u.id " +
                "WHERE r.product_id = :productId AND COALESCE(r.status,'VISIBLE') = 'VISIBLE' " +
                "ORDER BY r.created_at DESC")
                  .bind("productId", productId)
                  .map((rs, ctx) -> {
                      model.Review rev = new model.Review();
                      rev.setId(rs.getInt("id"));
                      rev.setUserId(rs.getInt("userId"));
                      rev.setProductId(rs.getInt("productId"));
                      rev.setOrderId(rs.getInt("orderId"));
                      rev.setRating(rs.getInt("rating"));
                      rev.setComment(rs.getString("comment"));
                      rev.setImageUrl(rs.getString("imageUrl"));
                      rev.setAnonymous(rs.getBoolean("anonymous"));
                      rev.setStatus(rs.getString("status"));
                      java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                      if (ts != null) rev.setCreatedAt(ts.toLocalDateTime());
                      String uName = rs.getString("userName");
                      rev.setUserName(rs.wasNull() || rev.isAnonymous() ? "Ẩn danh" : uName);
                      return rev;
                  })
                  .list()
        );
    }

    public double getAverageRating(int productId) {
        return JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery("SELECT COALESCE(AVG(rating), 0) FROM reviews WHERE product_id = :productId AND COALESCE(status,'VISIBLE') = 'VISIBLE'")
                  .bind("productId", productId)
                  .mapTo(Double.class)
                  .one()
        );
    }

    public int getReviewCount(int productId) {
        return JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery("SELECT COUNT(*) FROM reviews WHERE product_id = :productId AND COALESCE(status,'VISIBLE') = 'VISIBLE'")
                  .bind("productId", productId)
                  .mapTo(Integer.class)
                  .one()
        );
    }

    /** Returns int[5] where index 0 = count of 1-star, index 4 = count of 5-star */
    public int[] getRatingDistribution(int productId) {
        int[] dist = new int[5];
        JDBIConnector.getJdbi().useHandle(handle -> {
            handle.createQuery("SELECT rating, COUNT(*) as cnt FROM reviews WHERE product_id = :productId AND COALESCE(status,'VISIBLE') = 'VISIBLE' GROUP BY rating")
                  .bind("productId", productId)
                  .map((rs, ctx) -> {
                      int r = rs.getInt("rating");
                      int c = rs.getInt("cnt");
                      if (r >= 1 && r <= 5) dist[r - 1] = c;
                      return null;
                  }).list();
        });
        return dist;
    }

    // ============================================================
    // ADMIN methods
    // ============================================================

    /** Lấy tất cả reviews với JOIN user và product để admin quản lý */
    public List<model.Review> getAllReviewsForAdmin(String keyword, Integer minStar, Integer maxStar, String status) {
        StringBuilder sql = new StringBuilder(
            "SELECT r.id, r.user_id as userId, r.product_id as productId, r.order_id as orderId, " +
            "r.rating, r.comment, r.image_url as imageUrl, r.created_at as createdAt, " +
            "r.is_anonymous as \"anonymous\", COALESCE(r.status,'VISIBLE') as status, " +
            "u.full_name as userName, p.name as productName " +
            "FROM reviews r " +
            "LEFT JOIN users u ON r.user_id = u.id " +
            "LEFT JOIN product p ON r.product_id = p.id " +
            "WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (u.full_name LIKE :kw OR p.name LIKE :kw OR r.comment LIKE :kw)");
        }
        if (minStar != null) sql.append(" AND r.rating >= :minStar");
        if (maxStar != null) sql.append(" AND r.rating <= :maxStar");
        if (status != null && !status.isEmpty()) sql.append(" AND COALESCE(r.status,'VISIBLE') = :status");

        sql.append(" ORDER BY r.created_at DESC");

        return JDBIConnector.getJdbi().withHandle(handle -> {
            var query = handle.createQuery(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) query.bind("kw", "%" + keyword + "%");
            if (minStar != null) query.bind("minStar", minStar);
            if (maxStar != null) query.bind("maxStar", maxStar);
            if (status != null && !status.isEmpty()) query.bind("status", status);

            return query.map((rs, ctx) -> {
                model.Review rev = new model.Review();
                rev.setId(rs.getInt("id"));
                rev.setUserId(rs.getInt("userId"));
                rev.setProductId(rs.getInt("productId"));
                rev.setRating(rs.getInt("rating"));
                rev.setComment(rs.getString("comment"));
                rev.setImageUrl(rs.getString("imageUrl"));
                rev.setStatus(rs.getString("status"));
                rev.setUserName(rs.getString("userName"));
                rev.setProductName(rs.getString("productName"));
                rev.setAnonymous(rs.getBoolean("anonymous"));
                java.sql.Timestamp ts = rs.getTimestamp("createdAt");
                if (ts != null) rev.setCreatedAt(ts.toLocalDateTime());
                return rev;
            }).list();
        });
    }

    public void updateStatus(int reviewId, String status) {
        JDBIConnector.getJdbi().useHandle(handle ->
            handle.createUpdate("UPDATE reviews SET status = :status WHERE id = :id")
                  .bind("status", status)
                  .bind("id", reviewId)
                  .execute()
        );
    }

    public void deleteReview(int reviewId) {
        JDBIConnector.getJdbi().useHandle(handle ->
            handle.createUpdate("DELETE FROM reviews WHERE id = :id")
                  .bind("id", reviewId)
                  .execute()
        );
    }

    public void addAdminReply(int reviewId, int adminId, String content) {
        JDBIConnector.getJdbi().useHandle(handle -> {
            // Delete old reply if exists (only one reply per review)
            handle.createUpdate("DELETE FROM review_replies WHERE review_id = :rid").bind("rid", reviewId).execute();
            handle.createUpdate("INSERT INTO review_replies (review_id, admin_id, content) VALUES (:rid, :aid, :content)")
                  .bind("rid", reviewId)
                  .bind("aid", adminId)
                  .bind("content", content)
                  .execute();
        });
    }

    public String getAdminReply(int reviewId) {
        return JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery("SELECT content FROM review_replies WHERE review_id = :rid ORDER BY created_at DESC LIMIT 1")
                  .bind("rid", reviewId)
                  .mapTo(String.class)
                  .findOne()
                  .orElse(null)
        );
    }

    /** Thống kê tổng quan */
    public java.util.Map<String, Object> getStats() {
        return JDBIConnector.getJdbi().withHandle(handle -> {
            java.util.Map<String, Object> stats = new java.util.LinkedHashMap<>();
            stats.put("total", handle.createQuery("SELECT COUNT(*) FROM reviews").mapTo(Long.class).one());
            stats.put("visible", handle.createQuery("SELECT COUNT(*) FROM reviews WHERE COALESCE(status,'VISIBLE') = 'VISIBLE'").mapTo(Long.class).one());
            stats.put("hidden", handle.createQuery("SELECT COUNT(*) FROM reviews WHERE status = 'HIDDEN'").mapTo(Long.class).one());
            stats.put("avg", handle.createQuery("SELECT COALESCE(ROUND(AVG(rating),1),0) FROM reviews WHERE COALESCE(status,'VISIBLE') = 'VISIBLE'").mapTo(Double.class).one());
            return stats;
        });
    }
}
