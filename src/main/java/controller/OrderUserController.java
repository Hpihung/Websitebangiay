package controller;

import dao.Order.OrderDao;
import dao.Order.OrderDetailDao;
import dao.ReviewDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order.Order;
import model.Order.OrderDetailDTO;
import model.user.User;

import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet("/orders/*")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class OrderUserController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();
    private final OrderDetailDao orderDetailDao = new OrderDetailDao();
    private final ReviewDao reviewDao = new ReviewDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/account#order-history");
            return;
        }

        try {
            int orderId = Integer.parseInt(pathInfo.substring(1)); // Extract ID from "/21"
            orderDao.autoConfirmDeliveredOrders();
            List<Order> orders = orderDao.findWithFilter(orderId, currentUser.getId(), null, null);
            if (orders.isEmpty()) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy đơn hàng");
                return;
            }

            Order order = orders.get(0);
            List<OrderDetailDTO> details = orderDetailDao.findByOrderId(orderId);
            List<model.Review> reviews = reviewDao.getReviewsByOrderId(orderId);

            req.setAttribute("order", order);
            req.setAttribute("orderDetails", details);
            req.setAttribute("reviews", reviews);

            req.getRequestDispatcher("/order-detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn hàng không hợp lệ");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        if (currentUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/account#order-history");
            return;
        }

        try {
            int orderId = Integer.parseInt(pathInfo.substring(1));
            String action = req.getParameter("action");

            if ("cancel".equals(action)) {
                String cancelReason = req.getParameter("cancelReason");
                if (cancelReason == null || cancelReason.trim().isEmpty()) {
                    cancelReason = "Người dùng hủy đơn";
                }
                List<Order> orders = orderDao.findWithFilter(orderId, currentUser.getId(), null, null);
                if (!orders.isEmpty() && "PENDING".equals(orders.get(0).getOrderStatus())) {
                    orderDao.cancelOrder(orderId, cancelReason, "User");
                    req.getSession().setAttribute("msg", "Hủy đơn hàng thành công!");
                    req.getSession().setAttribute("msgType", "success");
                }
            } else if ("receive".equals(action)) {
                List<Order> orders = orderDao.findWithFilter(orderId, currentUser.getId(), null, null);
                if (!orders.isEmpty()) {
                    Order order = orders.get(0);
                    String st = order.getOrderStatus();
                    if ("ORDER_COMPLETED".equals(st) || "COMPLETED".equals(st)) {
                        if (order.getReceivedAt() == null) {
                            orderDao.confirmReceived(orderId);
                            req.getSession().setAttribute("msg", "Cảm ơn bạn đã xác nhận nhận hàng!");
                            req.getSession().setAttribute("msgType", "success");
                        } else {
                            req.getSession().setAttribute("msg", "Đơn hàng đã được xác nhận nhận hàng trước đó.");
                            req.getSession().setAttribute("msgType", "warning");
                        }
                    } else if ("SHIPPING".equals(st) || "ORDER_SHIPPING".equals(st) || "ORDER_DELIVERED".equals(st) || "DELIVERED".equals(st)) {
                        if ("COD".equals(order.getPaymentMethod()) && !"PAID".equals(order.getPaymentStatus())) {
                            orderDao.userConfirmReceived(orderId, "PENDING_COD", order.getTrackingCode(), order.getShippingUnit(), "User");
                            req.getSession().setAttribute("msg", "Cảm ơn bạn đã xác nhận nhận hàng! Đơn hàng đang chờ đối soát thanh toán.");
                            req.getSession().setAttribute("msgType", "success");
                        } else {
                            orderDao.userConfirmReceived(orderId, "ORDER_COMPLETED", order.getTrackingCode(), order.getShippingUnit(), "User");
                            req.getSession().setAttribute("msg", "Cảm ơn bạn đã xác nhận nhận hàng!");
                            req.getSession().setAttribute("msgType", "success");
                        }
                    } else {
                        req.getSession().setAttribute("msg", "Trạng thái đơn hàng không hợp lệ.");
                        req.getSession().setAttribute("msgType", "danger");
                    }
                }
            } else if ("review".equals(action)) {
                int productId = Integer.parseInt(req.getParameter("productId"));
                int rating = Integer.parseInt(req.getParameter("rating"));
                String comment = req.getParameter("comment");
                boolean isAnonymous = "on".equals(req.getParameter("isAnonymous"));
                
                String imageUrl = "";
                try {
                    Part filePart = req.getPart("imageFile");
                    if (filePart != null && filePart.getSize() > 0) {
                        String fileName = filePart.getSubmittedFileName();
                        if (fileName != null && !fileName.isEmpty()) {
                            String fileExt = "";
                            int lastDot = fileName.lastIndexOf('.');
                            if (lastDot >= 0) {
                                fileExt = fileName.substring(lastDot);
                            }
                            String newFileName = "review_" + orderId + "_" + productId + "_" + System.currentTimeMillis() + fileExt;
                            
                            String uploadPath = req.getServletContext().getRealPath("/assets/images/reviews");
                            File uploadDir = new File(uploadPath);
                            if (!uploadDir.exists()) {
                                uploadDir.mkdirs();
                            }
                            
                            filePart.write(uploadPath + File.separator + newFileName);
                            imageUrl = "/assets/images/reviews/" + newFileName;
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                
                // Add minor ratings
                int sellerRating = Integer.parseInt(req.getParameter("sellerRating") != null ? req.getParameter("sellerRating") : "5");
                int deliveryRating = Integer.parseInt(req.getParameter("deliveryRating") != null ? req.getParameter("deliveryRating") : "5");
                int driverRating = Integer.parseInt(req.getParameter("driverRating") != null ? req.getParameter("driverRating") : "5");

                List<Integer> reviewedProductIds = reviewDao.getReviewedProductIds(orderId);
                if (!reviewedProductIds.contains(productId)) {
                    reviewDao.insertReview(currentUser.getId(), productId, orderId, rating, comment, imageUrl, sellerRating, deliveryRating, driverRating, isAnonymous);
                    req.getSession().setAttribute("msg", "Gửi đánh giá thành công!");
                    req.getSession().setAttribute("msgType", "success");
                }
            }
            resp.sendRedirect(req.getContextPath() + "/orders/" + orderId);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "ID đơn hàng không hợp lệ");
        }
    }
}
