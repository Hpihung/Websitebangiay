package services;

import dao.Product.ProductDao;
import DTO.ProductDTO;
import model.product.Product;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

public class ProductService {
    ProductDao productDao = new ProductDao();
    PromotionService promotionService = new PromotionService();
    ProductImgService productImgService = new ProductImgService();

    private ProductDTO mapToProductDTO(Product p) {

        boolean isNew = productDao.isNew(p.getId());

        PromotionResult pr =
                promotionService.calculateBestPromotion(p.getId());

        String finalPrice =
                promotionService.formatVND(pr.getFinalPrice());

        String price =
                promotionService.formatVND(p.getPrice());

        String mainImgURL =
                productImgService.getMainImg(p.getId());

        String discountValue =
                promotionService.getDiscountValueString(
                        pr.getBestPromotion()
                );

        return new ProductDTO(
                p.getId(),
                p.getName(),
                price,
                finalPrice,
                mainImgURL,
                discountValue,
                isNew,
                p.isAvailable()
        );
    }

    private List<ProductDTO> mapToProductDTOList(List<Product> products) {
        List<ProductDTO> result = new ArrayList<>();
        for (Product p : products) {
            result.add(mapToProductDTO(p));
        }
        return result;
    }

    public List<ProductDTO> findTopCheapestProductsInPromotion(int limit) {

        List<Product> products =
                productDao.findProductsInPromotion();

        List<ProductDTO> result =
                mapToProductDTOList(products);

        result.sort(Comparator.comparing(ProductDTO::getFinalPrice));

        if (result.size() > limit) {
            return result.subList(0, limit);
        }

        return result;
    }

    public List<ProductDTO> getNewestByBrandLimit(int brandId, int limit) {

        List<Product> products =
                productDao.findNewestByBrandLimit(brandId, limit);

        return mapToProductDTOList(products);
    }

    public List<ProductDTO> getNewestProducts(int limit) {

        List<Product> products =
                productDao.getNewestProducts(limit);

        return mapToProductDTOList(products);
    }

    public List<ProductDTO> getAllActiveProducts() {
        List<Product> products = productDao.findAllActive();
        return mapToProductDTOList(products);
    }

    /**
     * Lightweight method for newsletter product selection panel.
     * Uses a single JOIN query instead of N*3 queries per product.
     * Returns only id, name, price, mainImageUrl – no promotion calculation.
     */
    public List<ProductDTO> getProductsForNewsletter() {
        String sql = """
            SELECT p.id, p.name, p.price,
                   COALESCE(mi.img_url, pi.img_url, '') AS mainImageUrl
            FROM product p
            LEFT JOIN product_main_img mi ON mi.product_id = p.id
            LEFT JOIN (
                SELECT product_id, MIN(img_url) AS img_url
                FROM product_img
                WHERE sort_order = 0
                GROUP BY product_id
            ) pi ON pi.product_id = p.id
            WHERE p.is_available = 1 AND p.is_discontinue = 0
            ORDER BY p.name ASC
        """;
        try {
            return dao.JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                    .map((rs, ctx) -> {
                        ProductDTO dto = new ProductDTO();
                        dto.setId(rs.getInt("id"));
                        dto.setName(rs.getString("name"));
                        String rawPrice = rs.getString("price");
                        dto.setPrice(rawPrice != null ? rawPrice : "");
                        dto.setFinalPrice(rawPrice != null ? rawPrice : "");
                        dto.setMainImageUrl(rs.getString("mainImageUrl") != null ? rs.getString("mainImageUrl") : "");
                        dto.setDiscountValue("");
                        return dto;
                    })
                    .list()
            );
        } catch (Exception e) {
            e.printStackTrace();
            return java.util.Collections.emptyList();
        }
    }

    public ProductDTO getProductById(int id) {

        Product p = productDao.findById(id);

        if (p == null) {
            return null;
        }

        return mapToProductDTO(p);
    }

    public String getDes(int productId) {
        return productDao.getDes(productId);
    }

    public List<ProductDTO> getRelatedProduct(int productId, int limit) {

        Product currentProduct = productDao.findById(productId);

        if (currentProduct == null) {
            return Collections.emptyList();
        }
        List<Product> products =
                productDao.getRelatedProduct(
                        currentProduct.getId(),
                        currentProduct.getBrandId(),
                        currentProduct.getPrice(),
                        limit
                );

        return mapToProductDTOList(products);
    }





    public List<ProductDTO> getProductsPage(int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int limit = pageSize;
        int offset = (safePage - 1) * limit;

        List<Product> products = productDao.findActivePage(limit, offset);
        List<ProductDTO> result = new ArrayList<>();

        for (Product p : products) {
            boolean isNew = productDao.isNew(p.getId());
            PromotionResult pr = promotionService.calculateBestPromotion(p.getId());
            String finalPrice = promotionService.formatVND(pr.getFinalPrice());
            String price = promotionService.formatVND(p.getPrice());
            String mainImgURL = productImgService.getMainImg(p.getId());
            String discountValue = promotionService.getDiscountValueString(pr.getBestPromotion());

            result.add(new ProductDTO(
                    p.getId(), p.getName(), price, finalPrice, mainImgURL, discountValue, isNew, p.isAvailable()));
        }
        return result;
    }

    public int getTotalPages(int pageSize) {
        int total = productDao.countActive(); // ví dụ 100
        return (int) Math.ceil(total * 1.0 / pageSize); // 12 => 9 trang
    }

    public List<ProductDTO> searchProducts(String keyword, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int offset = (safePage - 1) * pageSize;
        List<Product> products = productDao.searchByName(keyword, pageSize, offset);
        List<ProductDTO> result = new ArrayList<>();
        for (Product p : products) {
            boolean isNew = productDao.isNew(p.getId());
            PromotionResult pr = promotionService.calculateBestPromotion(p.getId());
            String finalPrice = promotionService.formatVND(pr.getFinalPrice());
            String price = promotionService.formatVND(p.getPrice());
            String mainImgURL = productImgService.getMainImg(p.getId());
            String discountValue = promotionService.getDiscountValueString(pr.getBestPromotion());
            result.add(new ProductDTO(
                    p.getId(), p.getName(), price, finalPrice, mainImgURL, discountValue, isNew, p.isAvailable()));
        }
        return result;
    }

    public int getSearchTotalPages(String keyword, int pageSize) {
        int total = productDao.countSearchResults(keyword);
        return (int) Math.ceil(total * 1.0 / pageSize);
    }

    // Lọc sản phẩm theo nhiều tiêu chí
    public List<ProductDTO> filterProducts(String keyword, List<Integer> brandIds,
                                           List<Integer> sizeIds, List<Integer> colorIds,
                                           java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice,
                                           String sortBy, int page, int pageSize) {
        int safePage = Math.max(page, 1);
        int offset = (safePage - 1) * pageSize;

        List<Product> products = productDao.filterProducts(keyword, brandIds, sizeIds, colorIds,
                minPrice, maxPrice, sortBy, pageSize, offset);
        List<ProductDTO> result = new ArrayList<>();

        for (Product p : products) {
            boolean isNew = productDao.isNew(p.getId());
            PromotionResult pr = promotionService.calculateBestPromotion(p.getId());
            String finalPrice = promotionService.formatVND(pr.getFinalPrice());
            String price = promotionService.formatVND(p.getPrice());
            String mainImgURL = productImgService.getMainImg(p.getId());
            String discountValue = promotionService.getDiscountValueString(pr.getBestPromotion());

            result.add(new ProductDTO(
                    p.getId(), p.getName(), price, finalPrice, mainImgURL, discountValue, isNew, p.isAvailable()));
        }
        return result;
    }

    // Tính tổng số trang sau khi lọc
    public int getFilteredTotalPages(String keyword, List<Integer> brandIds,
                                     List<Integer> sizeIds, List<Integer> colorIds,
                                     java.math.BigDecimal minPrice, java.math.BigDecimal maxPrice,
                                     int pageSize) {
        int total = productDao.countFilteredProducts(keyword, brandIds, sizeIds, colorIds, minPrice, maxPrice);
        return (int) Math.ceil(total * 1.0 / pageSize);
    }

    public List<DTO.FlashSaleProductDTO> getActiveFlashSaleProducts() {
        dao.Promotion.PromotionDao promotionDao = new dao.Promotion.PromotionDao();
        dao.Product.ProductVariantDao variantDao = new dao.Product.ProductVariantDao();
        dao.Order.OrderDetailDao orderDetailDao = new dao.Order.OrderDetailDao();
        
        List<model.Promotion.Promotion> activeFlashSales = promotionDao.findActiveFlashSales();
        List<DTO.FlashSaleProductDTO> result = new ArrayList<>();
        
        for (model.Promotion.Promotion promo : activeFlashSales) {
            List<Integer> productIds = promotionDao.getProductIdsByPromotionId(promo.getId());
            if (productIds == null || productIds.isEmpty()) continue;
            
            for (Integer prodId : productIds) {
                model.product.Product p = productDao.findById(prodId);
                if (p == null || !p.isAvailable() || p.isDiscontinue() || "stopped".equalsIgnoreCase(p.getStatus())) continue;
                
                // Colors
                List<model.product.Color> colors = variantDao.findColorsByProduct(prodId);
                StringBuilder colorSb = new StringBuilder();
                for (int i = 0; i < colors.size(); i++) {
                    colorSb.append(colors.get(i).getName());
                    if (i < colors.size() - 1) colorSb.append(", ");
                }
                String colorStr = colorSb.toString();
                if (colorStr.isEmpty()) colorStr = "Đang cập nhật";
                
                // Sizes
                StringBuilder sizeSb = new StringBuilder();
                List<Integer> sizeIds = dao.JDBIConnector.getJdbi().withHandle(h ->
                    h.createQuery("SELECT DISTINCT size_id FROM product_variant WHERE product_id = :prodId AND is_discontinue_variant = 0 ORDER BY size_id")
                     .bind("prodId", prodId)
                     .mapTo(Integer.class)
                     .list()
                );
                for (int i = 0; i < sizeIds.size(); i++) {
                    String sizeName = variantDao.getSizeName(sizeIds.get(i));
                    if (!sizeName.isEmpty()) {
                        sizeSb.append(sizeName);
                        if (i < sizeIds.size() - 1) sizeSb.append(" ");
                    }
                }
                String sizeStr = sizeSb.toString();
                if (sizeStr.isEmpty()) sizeStr = "Liên hệ";
                
                // Stock - use real sold count from orders
                int remainingStock = variantDao.getTotalStock(prodId);
                int soldQty = orderDetailDao.countSoldByProduct(prodId);
                int totalCapacity = soldQty + remainingStock;
                
                // Image
                String mainImg = productImgService.getMainImg(prodId);
                
                // Price after discount
                java.math.BigDecimal originalPrice = p.getPrice();
                java.math.BigDecimal discountVal = promo.getDiscountValue();
                java.math.BigDecimal savingsAmt = java.math.BigDecimal.ZERO;
                java.math.BigDecimal flashPrice = originalPrice;
                String discountValStr = "";

                if ("PERCENT".equalsIgnoreCase(promo.getDiscountType())) {
                    savingsAmt = originalPrice.multiply(discountVal).divide(java.math.BigDecimal.valueOf(100));
                    flashPrice = originalPrice.subtract(savingsAmt);
                    discountValStr = "-" + discountVal.stripTrailingZeros().toPlainString() + "%";
                } else if ("FIXED".equalsIgnoreCase(promo.getDiscountType())) {
                    savingsAmt = discountVal;
                    flashPrice = originalPrice.subtract(savingsAmt);
                    if (originalPrice.compareTo(java.math.BigDecimal.ZERO) > 0) {
                        java.math.BigDecimal pct = savingsAmt.multiply(java.math.BigDecimal.valueOf(100)).divide(originalPrice, 1, java.math.RoundingMode.HALF_UP);
                        discountValStr = "-" + pct.stripTrailingZeros().toPlainString() + "%";
                    } else {
                        discountValStr = "-" + promotionService.formatVND(savingsAmt);
                    }
                } else {
                    savingsAmt = originalPrice.multiply(discountVal).divide(java.math.BigDecimal.valueOf(100));
                    flashPrice = originalPrice.subtract(savingsAmt);
                    discountValStr = "-" + discountVal.stripTrailingZeros().toPlainString() + "%";
                }

                if (flashPrice.compareTo(java.math.BigDecimal.ZERO) < 0) flashPrice = java.math.BigDecimal.ZERO;
                
                String priceStr = promotionService.formatVND(originalPrice);
                String finalPriceStr = promotionService.formatVND(flashPrice);
                String savingsStr = "Tiết kiệm " + promotionService.formatVND(savingsAmt);
                
                String endIsoStr = "";
                if (promo.getEndDate() != null) {
                    endIsoStr = promo.getEndDate().toString(); // ISO 8601 format
                }
                
                result.add(new DTO.FlashSaleProductDTO(
                    p.getId(),
                    p.getName(),
                    priceStr,
                    finalPriceStr,
                    discountValStr,
                    savingsStr,
                    mainImg,
                    colorStr,
                    sizeStr,
                    remainingStock,
                    totalCapacity,
                    endIsoStr,
                    true
                ));
            }
        }
        return result;
    }

}




