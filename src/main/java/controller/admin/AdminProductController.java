package controller.admin;

import dao.Product.BrandDao;
import dao.Product.ColorDao;
import dao.Product.ProductDao;
import dao.Product.ProductVariantDao;
import dao.Product.SizeDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.product.Product;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet({ "/admin/products", "/admin/variants" })
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AdminProductController extends HttpServlet {
    private final ProductDao productDao = new ProductDao();
    private final BrandDao brandDao = new BrandDao();
    private final ProductVariantDao variantDao = new ProductVariantDao();
    private final ColorDao colorDao = new ColorDao();
    private final SizeDao sizeDao = new SizeDao();
    private final dao.Product.ProductDaoImage productDaoImage = new dao.Product.ProductDaoImage();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/variants")) {
            // ... (keep as is)
            Integer productId = null;
            Integer sizeId = null;
            Integer colorId = null;

            try {
                if (request.getParameter("productId") != null &&
                        !request.getParameter("productId").isBlank())
                    productId = Integer.parseInt(request.getParameter("productId"));

                if (request.getParameter("sizeId") != null &&
                        !request.getParameter("sizeId").isBlank())
                    sizeId = Integer.parseInt(request.getParameter("sizeId"));

                if (request.getParameter("colorId") != null &&
                        !request.getParameter("colorId").isBlank())
                    colorId = Integer.parseInt(request.getParameter("colorId"));

            } catch (NumberFormatException ignored) {
            }

            // ===== LIST (TABLE) =====
            List<?> variants;
            if (productId != null || sizeId != null || colorId != null) {
                variants = variantDao.findWithFilter(productId, sizeId, colorId);
            } else {
                variants = variantDao.findAllActive();
            }
            request.setAttribute("variants", variants);

            // ===== EDIT (FORM) =====
            if ("true".equals(request.getParameter("edit"))
                    && productId != null && sizeId != null && colorId != null) {

                var list = variantDao.findWithFilter(productId, sizeId, colorId);
                if (!list.isEmpty()) {
                    request.setAttribute("variant", list.get(0));
                }
            }

            request.setAttribute("sizes", sizeDao.findAll());
            request.setAttribute("colors", colorDao.findAll());
            
            List<Product> allProducts = productDao.findAll();
            request.setAttribute("allProducts", allProducts);
            
            if (productId != null) {
                Product selectedProduct = productDao.findById(productId);
                request.setAttribute("selectedProduct", selectedProduct);
            }

            request.setAttribute("contentPage", "/admin-views/admin-variants.jsp");
            request.setAttribute("active", "admin/variants");
        } else {
            List<Product> products;
            java.util.Map<Integer, String> productImgMap = new java.util.HashMap<>();

            try {
                String idParam = request.getParameter("id");
                String nameParam = request.getParameter("name");
                if (nameParam != null && nameParam.isBlank())
                    nameParam = null;

                String brandIdParam = request.getParameter("brandId");
                if (brandIdParam != null && brandIdParam.isBlank())
                    brandIdParam = null;

                Integer id = null;
                Integer brandId = null;

                try {
                    if (idParam != null && !idParam.isBlank())
                        id = Integer.parseInt(idParam);

                    if (brandIdParam != null && !brandIdParam.isBlank())
                        brandId = Integer.parseInt(brandIdParam);
                } catch (NumberFormatException ignored) {
                }

                int page = 1;
                int pageSize = 10;
                try {
                    if (request.getParameter("page") != null) {
                        page = Integer.parseInt(request.getParameter("page"));
                    }
                } catch (NumberFormatException ignored) {}

                if (id != null ||
                        (nameParam != null && !nameParam.trim().isEmpty()) ||
                        brandId != null) {
                    products = productDao.findWithFilter(id, nameParam, brandId);
                    request.setAttribute("totalPages", 1);
                } else {
                    int totalProducts = productDao.countAll();
                    int totalPages = (int) Math.ceil(totalProducts * 1.0 / pageSize);
                    if (page < 1) page = 1;
                    if (page > totalPages && totalPages > 0) page = totalPages;
                    
                    products = productDao.findAllPaged(pageSize, (page - 1) * pageSize);
                    request.setAttribute("totalPages", totalPages);
                }
                request.setAttribute("currentPage", page);
                
                java.util.Map<String, Double> productRatingMap = new java.util.HashMap<>();
                java.util.Map<String, Integer> productVoteMap = new java.util.HashMap<>();
                java.util.Map<String, Integer> productStockMap = new java.util.HashMap<>();
                dao.ReviewDao reviewDao = new dao.ReviewDao();

                for (Product p : products) {
                    var img = productDaoImage.findMainImage(p.getId());
                    productImgMap.put(p.getId(), img != null ? img.getImgUrl() : "");
                    
                    String pIdStr = String.valueOf(p.getId());
                    productRatingMap.put(pIdStr, reviewDao.getAverageRating(p.getId()));
                    productVoteMap.put(pIdStr, reviewDao.getReviewCount(p.getId()));
                    productStockMap.put(pIdStr, variantDao.getTotalStock(p.getId()));
                }

                request.setAttribute("products", products);
                request.setAttribute("productImgMap", productImgMap);
                request.setAttribute("productRatingMap", productRatingMap);
                request.setAttribute("productVoteMap", productVoteMap);
                request.setAttribute("productStockMap", productStockMap);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", e.getMessage());
            }

            request.setAttribute("brands", brandDao.findAll());
            request.setAttribute("sizes", sizeDao.findAll());
            request.setAttribute("colors", colorDao.findAll());

            // ===== EDIT =====
            String editId = request.getParameter("edit");
            if (editId != null && !editId.isBlank()) {
                try {
                    Product p = productDao.findById(Integer.parseInt(editId));
                    if (p != null) {
                        request.setAttribute("product", p);
                        request.setAttribute("isEdit", true);
                        var img = productDaoImage.findMainImage(p.getId());
                        request.setAttribute("productImg", img != null ? img.getImgUrl() : "");
                        
                        java.util.List<model.product.ProductImage> subImgs = productDaoImage.findSubImages(p.getId(), 0);
                        String subImgStr = subImgs.stream().map(model.product.ProductImage::getImgUrl).collect(java.util.stream.Collectors.joining(","));
                        request.setAttribute("subImgUrls", subImgStr);
                    } else {
                        request.setAttribute("product", new Product());
                        request.setAttribute("isEdit", false);
                        request.setAttribute("error", "Product not found");
                    }
                } catch (NumberFormatException e) {
                    Product newProduct = new Product();
                    newProduct.setAvailable(true);
                    request.setAttribute("product", newProduct);
                    request.setAttribute("isEdit", false);
                    request.setAttribute("error", "Invalid product ID");
                }
            } else {
                request.setAttribute("product", new Product());
                request.setAttribute("isEdit", false);
            }

            request.setAttribute("contentPage", "/admin-views/admin-products.jsp");
            request.setAttribute("active", "admin/products");
        }

        request.getRequestDispatcher("/Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/variants")) {
            // Handle variant CRUD
            try {
                String action = request.getParameter("action");
                String productIdStr = request.getParameter("productId");
                String sizeIdStr = request.getParameter("sizeId");
                String colorIdStr = request.getParameter("colorId");
                String stockStr = request.getParameter("stock");
                
                if (productIdStr != null && sizeIdStr != null && colorIdStr != null) {
                    int productId = Integer.parseInt(productIdStr);
                    int sizeId = Integer.parseInt(sizeIdStr);
                    int colorId = Integer.parseInt(colorIdStr);
                    
                    if ("delete".equals(action)) {
                        variantDao.delete(productId, sizeId, colorId);
                    } else {
                        int stock = Integer.parseInt(stockStr);
                        String sizeIdOldStr = request.getParameter("sizeIdOld");
                        String colorIdOldStr = request.getParameter("colorIdOld");
                        
                        if (sizeIdOldStr != null && !sizeIdOldStr.isBlank() && colorIdOldStr != null && !colorIdOldStr.isBlank()) {
                            int sizeIdOld = Integer.parseInt(sizeIdOldStr);
                            int colorIdOld = Integer.parseInt(colorIdOldStr);
                            variantDao.update(productId, sizeIdOld, colorIdOld, sizeId, colorId, stock);
                        } else {
                            if (variantDao.existsProductVariant(productId, colorId, sizeId)) {
                                response.sendRedirect(request.getContextPath() + "/admin/variants?error=duplicate");
                                return;
                            }
                            variantDao.insert(productId, sizeId, colorId, stock);
                        }
                    }
                    response.sendRedirect(request.getContextPath() + "/admin/variants?productId=" + productId);
                    return;
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect(request.getContextPath() + "/admin/variants?error=" + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "unknown", "UTF-8"));
                return;
            }
            response.sendRedirect(request.getContextPath() + "/admin/variants");
        } else {
            // ====== DELETE (available) ======
            String deleteId = request.getParameter("deleteId");
            if (deleteId != null && !deleteId.isBlank()) {
                try {
                    productDao.delete(Integer.parseInt(deleteId));
                } catch (NumberFormatException ignore) {
                }
                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            }
            // ADD && DELETE
            String idParam = request.getParameter("id");
            String name = request.getParameter("name");
            String description = request.getParameter("description");
            String priceParam = request.getParameter("price");
            String brandIdParam = request.getParameter("brandId");

            if (name == null || priceParam == null || brandIdParam == null) {
                response.sendRedirect(request.getContextPath() + "/admin/products");
                return;
            }

            BigDecimal price;
            try {
                price = new BigDecimal(priceParam);
            } catch (NumberFormatException ignored) {
                response.sendRedirect(request.getContextPath() + "/admin/products?error=price");
                return;
            }
            int brandId = Integer.parseInt(brandIdParam);
            
            // Handle main image file upload
            String imgUrl = request.getParameter("existingImgUrl");
            try {
                Part mainImgPart = request.getPart("imgFile");
                if (mainImgPart != null && mainImgPart.getSize() > 0) {
                    String fileName = mainImgPart.getSubmittedFileName();
                    if (fileName != null && !fileName.isEmpty()) {
                        String fileExt = "";
                        int lastDot = fileName.lastIndexOf('.');
                        if (lastDot >= 0) {
                            fileExt = fileName.substring(lastDot);
                        }
                        String newFileName = "product_" + System.currentTimeMillis() + fileExt;
                        String uploadPath = request.getServletContext().getRealPath("/assets/images/Products");
                        java.io.File uploadDir = new java.io.File(uploadPath);
                        if (!uploadDir.exists()) {
                            uploadDir.mkdirs();
                        }
                        mainImgPart.write(uploadPath + java.io.File.separator + newFileName);
                        imgUrl = "/assets/images/Products/" + newFileName;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

            // Handle sub-images file upload
            java.util.List<String> subImgList = new java.util.ArrayList<>();
            for (int i = 1; i <= 4; i++) {
                String existingUrl = request.getParameter("existingSubImgUrl" + i);
                String subImgUrl = (existingUrl != null) ? existingUrl : "";
                try {
                    Part subPart = request.getPart("subImgFile" + i);
                    if (subPart != null && subPart.getSize() > 0) {
                        String fileName = subPart.getSubmittedFileName();
                        if (fileName != null && !fileName.isEmpty()) {
                            String fileExt = "";
                            int lastDot = fileName.lastIndexOf('.');
                            if (lastDot >= 0) {
                                fileExt = fileName.substring(lastDot);
                            }
                            String newFileName = "product_sub_" + i + "_" + System.currentTimeMillis() + fileExt;
                            String uploadPath = request.getServletContext().getRealPath("/assets/images/Products");
                            java.io.File uploadDir = new java.io.File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            subPart.write(uploadPath + java.io.File.separator + newFileName);
                            subImgUrl = "/assets/images/Products/" + newFileName;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                if (subImgUrl != null && !subImgUrl.trim().isEmpty()) {
                    subImgList.add(subImgUrl);
                }
            }

            String status = request.getParameter("status");
            if (status == null || status.isBlank()) {
                status = "selling";
            }
            boolean available = "selling".equalsIgnoreCase(status);

            Product product;
            if (idParam != null && !idParam.isBlank() && !"0".equals(idParam)) {
                product = productDao.findById(Integer.parseInt(idParam));
                if (product == null || product.isDiscontinue()) {
                    response.sendRedirect(request.getContextPath() + "/admin/products");
                    return;
                }
                product.setAvailable(available);
                product.setStatus(status);
            } else {
                // ====== INSERT ======
                product = new Product();
                product.setAddedAt(java.time.LocalDateTime.now());
                product.setDiscontinue(false);
                product.setAvailable(available);
                product.setStatus(status);
            }

            product.setName(name);
            product.setDescription(description);
            product.setPrice(price);
            product.setBrandId(brandId);

            // ====== SAVE ======
            try {
                if (product.getId() > 0) {
                    productDao.update(product);
                    if (imgUrl != null && !imgUrl.isBlank()) {
                        productDaoImage.upsertMainImage(product.getId(), imgUrl);
                    }
                    productDaoImage.replaceSubImages(product.getId(), subImgList);
                } else {
                    int newId = productDao.insert(product);
                    if (newId > 0 && imgUrl != null && !imgUrl.isBlank()) {
                        productDaoImage.upsertMainImage(newId, imgUrl);
                    }
                    if (newId > 0 && !subImgList.isEmpty()) {
                        productDaoImage.replaceSubImages(newId, subImgList);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
                String msg = e.getMessage() != null ? e.getMessage().toLowerCase() : "";
                if (msg.contains("duplicate") || msg.contains("unique")) {
                    response.sendRedirect(request.getContextPath() + "/admin/products?error=duplicate_name");
                } else {
                    response.sendRedirect(request.getContextPath() + "/admin/products?error=" + java.net.URLEncoder.encode(e.getMessage() != null ? e.getMessage() : "unknown", "UTF-8"));
                }
                return;
            }

            response.sendRedirect(request.getContextPath() + "/admin/products");
        }
    }
}