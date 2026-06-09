package controller;

import DTO.ProductDTO;
import dao.Product.BrandDao;
import dao.Product.ColorDao;
import dao.Product.SizeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.product.Brand;
import model.product.Color;
import model.product.Size;
import services.ProductService;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
@WebServlet("/products")
public class ProductsController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    private ProductService productService;
    private BrandDao brandDao;
    private SizeDao sizeDao;
    private ColorDao colorDao;

    @Override
    public void init() {
        productService = new ProductService();
        brandDao = new BrandDao();
        sizeDao = new SizeDao();
        colorDao = new ColorDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String query = request.getParameter("q");
        int page = parseInt(request.getParameter("page"), 1);
        String sortBy = request.getParameter("sort");

        List<Integer> brandIds = parseIntList(request.getParameterValues("brand"));
        List<Integer> sizeIds = parseIntList(request.getParameterValues("size"));
        List<Integer> colorIds = parseIntList(request.getParameterValues("color"));
        BigDecimal minPrice = parseBigDecimal(request.getParameter("minPrice"));
        BigDecimal maxPrice = parseBigDecimal(request.getParameter("maxPrice"));

        boolean hasFilter = (query != null && !query.trim().isEmpty())
                || brandIds != null || sizeIds != null || colorIds != null
                || minPrice != null || maxPrice != null
                || (sortBy != null && !sortBy.equals("default"));

        String cleanQuery = (query != null) ? query.trim() : null;

        int totalPages = hasFilter
                ? Math.max(1, productService.getFilteredTotalPages(cleanQuery, brandIds, sizeIds, colorIds, minPrice, maxPrice, PAGE_SIZE))
                : Math.max(1, productService.getTotalPages(PAGE_SIZE));

        page = Math.max(1, Math.min(page, totalPages));

        List<ProductDTO> products;
        if (hasFilter) {
            products = productService.filterProducts(cleanQuery, brandIds, sizeIds, colorIds, minPrice, maxPrice, sortBy, page, PAGE_SIZE);

            if (cleanQuery != null && !cleanQuery.isEmpty()) {
                request.setAttribute("searchQuery", cleanQuery);
            }
            request.setAttribute("selectedBrands", brandIds);
            request.setAttribute("selectedSizes", sizeIds);
            request.setAttribute("selectedColors", colorIds);
            request.setAttribute("minPrice", minPrice);
            request.setAttribute("maxPrice", maxPrice);
            request.setAttribute("sortBy", sortBy);
        } else {
            products = productService.getProductsPage(page, PAGE_SIZE);
        }

        request.setAttribute("brands", brandDao.findAllActive());
        request.setAttribute("sizes", sizeDao.findAllActive());
        request.setAttribute("colors", colorDao.findAllActive());
        request.setAttribute("productList", products);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("page", page);

        response.setCharacterEncoding("UTF-8");
        boolean isAjax = "1".equals(request.getParameter("ajax"));
        String targetJsp = isAjax ? "/products_fragment.jsp" : "/products.jsp";
        request.getRequestDispatcher(targetJsp).forward(request, response);
    }

    private int parseInt(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private BigDecimal parseBigDecimal(String value) {
        try {
            return new BigDecimal(value);
        } catch (Exception e) {
            return null;
        }
    }

    private List<Integer> parseIntList(String[] values) {
        if (values == null) return null;
        List<Integer> list = new ArrayList<>();
        for (String v : values) {
            try {
                list.add(Integer.parseInt(v));
            } catch (NumberFormatException ignored) {}
        }
        return list.isEmpty() ? null : list;
    }
}