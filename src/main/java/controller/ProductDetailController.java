package controller;

import DTO.ProductDetailDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.ProductDetailService;
import model.user.User;
import dao.WishlistDao;


import java.io.IOException;

@WebServlet("/product")
public class ProductDetailController extends HttpServlet {

    private ProductDetailService productDetailService;
    private WishlistDao wishlistDao;

    @Override
    public void init() {
        productDetailService = new ProductDetailService();
        wishlistDao = new WishlistDao();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String productIdParam = req.getParameter("id");
        if (productIdParam == null) {
            resp.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        int productId;
        try {
            productId = Integer.parseInt(productIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/menu");
            return;
        }

        Integer colorId = null;
        try {
            if (req.getParameter("colorId") != null) {
                colorId = Integer.parseInt(req.getParameter("colorId"));
            }
        } catch (NumberFormatException ignored) {}

        Integer sizeId = null;
        try {
            if (req.getParameter("sizeId") != null) {
                sizeId = Integer.parseInt(req.getParameter("sizeId"));
            }
        } catch (NumberFormatException ignored) {}

        ProductDetailDTO dto =
                productDetailService.buildProductDetailPage(
                        productId, colorId, sizeId
                );

        User user = (User) req.getSession().getAttribute("currentUser");

        boolean isInWishlist = false;
        if (user != null) {
            isInWishlist = wishlistDao.exists(user.getId(), productId);
        }

        req.setAttribute("product", dto);
        req.setAttribute("isInWishlist", isInWishlist);

        // Reviews
        dao.ReviewDao reviewDao = new dao.ReviewDao();
        req.setAttribute("productReviews", reviewDao.getReviewsByProductId(productId));
        req.setAttribute("avgRating", reviewDao.getAverageRating(productId));
        req.setAttribute("reviewCount", reviewDao.getReviewCount(productId));
        req.setAttribute("ratingDist", reviewDao.getRatingDistribution(productId));

        req.getRequestDispatcher("/chitietsanpham.jsp")
                .forward(req, resp);
    }
}

