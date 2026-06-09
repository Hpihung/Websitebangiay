package dao.Product;

import dao.JDBIConnector;
import model.product.ProductImage;
import model.product.ProductMainImage;
import org.jdbi.v3.core.Jdbi;

import java.util.Collections;
import java.util.List;

public class ProductDaoImage {

    private final Jdbi jdbi;

    public ProductDaoImage() {
        this.jdbi = JDBIConnector.getJdbi();
    }

    public ProductMainImage findMainImage(int productId) {

        String sql = """
        SELECT mi.*
        FROM product_main_img mi
        JOIN product p ON mi.product_id = p.id
        WHERE mi.product_id = :productId
        LIMIT 1
    """;

        try {
            ProductMainImage mainImg = jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("productId", productId)
                            .mapToBean(ProductMainImage.class)
                            .findFirst()
                            .orElse(null)
            );
            
            if (mainImg == null) {
                // Fallback to product_img for old products
                String fallbackSql = "SELECT img_url FROM product_img WHERE product_id = :productId ORDER BY sort_order ASC LIMIT 1";
                String url = jdbi.withHandle(h -> h.createQuery(fallbackSql).bind("productId", productId).mapTo(String.class).findOne().orElse(null));
                if (url != null) {
                    mainImg = new ProductMainImage();
                    mainImg.setProductId(productId);
                    mainImg.setImgUrl(url);
                }
            }
            return mainImg;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<ProductImage> findSubImages(int productId, int colorId) {

        String sql = """
        SELECT pi.*
        FROM product_img pi
        JOIN product p ON pi.product_id = p.id
        WHERE pi.product_id = :productId
          AND (pi.color_id = :colorId OR pi.color_id IS NULL OR :colorId = 0)
          AND pi.sort_order BETWEEN 1 AND 5
        ORDER BY pi.sort_order ASC
    """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("productId", productId)
                            .bind("colorId", colorId)
                            .mapToBean(ProductImage.class)
                            .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public void replaceSubImages(int productId, List<String> subImgUrls) {
        String deleteSql = "DELETE FROM product_img WHERE product_id = :productId AND (color_id IS NULL) AND sort_order BETWEEN 1 AND 5";
        String insertSql = "INSERT INTO product_img (product_id, color_id, img_url, sort_order, is_active) VALUES (:productId, NULL, :imgUrl, :sortOrder, 1)";

        jdbi.useHandle(handle -> {
            handle.createUpdate(deleteSql)
                    .bind("productId", productId)
                    .execute();
                    
            int sortOrder = 1;
            for (String url : subImgUrls) {
                if (url != null && !url.trim().isEmpty()) {
                    handle.createUpdate(insertSql)
                            .bind("productId", productId)
                            .bind("imgUrl", url.trim())
                            .bind("sortOrder", sortOrder++)
                            .execute();
                }
            }
        });
    }

    public ProductImage findMainColorImage(int productId, int colorId) {

        String sql = """
        SELECT pi.*
        FROM product_img pi
        JOIN product p ON pi.product_id = p.id
        WHERE pi.product_id = :productId
          AND pi.color_id = :colorId
          AND pi.sort_order = 0
        LIMIT 1
    """;

        try {
            return jdbi.withHandle(handle ->
                    handle.createQuery(sql)
                            .bind("productId", productId)
                            .bind("colorId", colorId)
                            .mapToBean(ProductImage.class)
                            .findFirst()
                            .orElse(null)
            );
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public void upsertMainImage(int productId, String imgUrl) {
        String checkSql = "SELECT COUNT(*) FROM product_main_img WHERE product_id = :productId";
        String insertSql = "INSERT INTO product_main_img (product_id, img_url, is_active) VALUES (:productId, :imgUrl, 1)";
        String updateSql = "UPDATE product_main_img SET img_url = :imgUrl, is_active = 1 WHERE product_id = :productId";

        jdbi.useHandle(handle -> {
            int count = handle.createQuery(checkSql)
                    .bind("productId", productId)
                    .mapTo(int.class)
                    .one();
            if (count > 0) {
                handle.createUpdate(updateSql)
                        .bind("productId", productId)
                        .bind("imgUrl", imgUrl)
                        .execute();
            } else {
                handle.createUpdate(insertSql)
                        .bind("productId", productId)
                        .bind("imgUrl", imgUrl)
                        .execute();
            }
        });
    }
}
