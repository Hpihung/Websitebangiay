package services;

import DTO.MenuDTO;
import dao.BannerDao;
import dao.Product.BrandDao;

public class MenuService {
    BannerDao bannerDao = new BannerDao();
    ProductService productService = new ProductService();
    BrandDao brandDao = new BrandDao();

    /** Dùng cho MenuFilterController (brand filter tabs - không phân trang) */
    public MenuDTO buildMenuPage(String brandId) {
        return buildMenuPagePaged(brandId, 1, Integer.MAX_VALUE);
    }

    /** Dùng cho MenuController (có phân trang) */
    public MenuDTO buildMenuPagePaged(String brandId, int page, int pageSize) {
        MenuDTO dto = new MenuDTO();
        dto.setBannerSpecialP(bannerDao.findByPosition("menu_special-product"));
        dto.setSpecialProduct(productService.findTopCheapestProductsInPromotion(9));
        dto.setBannerCollection(bannerDao.findByPositions("menu_collection"));
        dto.setBannerSlider(bannerDao.findByPositions("products_slide"));
        dto.setBrandList(brandDao.findAllActive());
        dto.setFlashSaleProducts(productService.getActiveFlashSaleProducts());

        if ("all".equalsIgnoreCase(brandId)) {
            if (pageSize == Integer.MAX_VALUE) {
                dto.setnewestProduct(productService.getNewestProducts(16));
            } else {
                dto.setnewestProduct(productService.getProductsPage(page, pageSize));
            }
        } else {
            int id = Integer.parseInt(brandId);
            dto.setnewestProduct(productService.getNewestByBrandLimit(id, 100));
        }
        return dto;
    }

    /** Tổng số trang cho section "Sản phẩm mới" khi chọn All */
    public int getTotalNewestPages(int pageSize) {
        return productService.getTotalPages(pageSize);
    }
}
