package DTO;

import model.Banner;
import model.product.Brand;

import java.io.Serializable;
import java.util.List;

public class MenuDTO implements Serializable {
    private List<Banner> bannerCollection;
    private List<Banner> bannerSlider;
    private List<ProductDTO> newestProduct;
    private List<Brand> brandList;
    private List<ProductDTO> specialProduct;
    private Banner bannerSpecialP;
    private List<FlashSaleProductDTO> flashSaleProducts;

    public List<Banner> getBannerCollection() {
        return bannerCollection;
    }

    public void setBannerCollection(List<Banner> bannerCollection) {
        this.bannerCollection = bannerCollection;
    }

    public List<ProductDTO> getnewestProduct() {
        return newestProduct;
    }

    public void setnewestProduct(List<ProductDTO> bestSeller) {
        this.newestProduct = bestSeller;
    }

    public List<Brand> getBrandList() {
        return brandList;
    }

    public void setBrandList(List<Brand> brandList) {
        this.brandList = brandList;
    }

    public List<ProductDTO> getSpecialProduct() {
        return specialProduct;
    }

    public void setSpecialProduct(List<ProductDTO> specialProduct) {
        this.specialProduct = specialProduct;
    }

    public Banner getBannerSpecialP() {
        return bannerSpecialP;
    }

    public void setBannerSpecialP(Banner bannerSpecialP) {
        this.bannerSpecialP = bannerSpecialP;
    }

    public List<Banner> getBannerSlider() {
        return bannerSlider;
    }

    public void setBannerSlider(List<Banner> bannerSlider) {
        this.bannerSlider = bannerSlider;
    }

    public List<FlashSaleProductDTO> getFlashSaleProducts() {
        return flashSaleProducts;
    }

    public void setFlashSaleProducts(List<FlashSaleProductDTO> flashSaleProducts) {
        this.flashSaleProducts = flashSaleProducts;
    }

    public MenuDTO(List<Banner> bannerCollection, List<ProductDTO> bestSeller,
            List<ProductDTO> specialProduct, Banner bannerSpecialP, List<Brand> brandList) {
        this.bannerCollection = bannerCollection;
        this.newestProduct = bestSeller;
        this.specialProduct = specialProduct;
        this.bannerSpecialP = bannerSpecialP;
        this.brandList = brandList;
    }

    public MenuDTO() {
    }
}
