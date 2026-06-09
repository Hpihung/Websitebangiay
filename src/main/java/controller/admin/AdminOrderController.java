package controller.admin;

import dao.Order.OrderDao;
import dao.Order.OrderDetailDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order.Order;

import java.io.IOException;
import java.util.List;

@WebServlet({ "/admin/orders", "/admin/carts" })
public class AdminOrderController extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        orderDao.autoConfirmDeliveredOrders();
        String uri = request.getRequestURI();

        // ====== CARTs ======
        if (uri.endsWith("/admin/carts")) {
            String userIdParam = request.getParameter("userId");
            Integer userId = null;

            try {
                if (userIdParam != null && !userIdParam.isBlank())
                    userId = Integer.parseInt(userIdParam);
            } catch (NumberFormatException ignored) {
            }

            request.setAttribute("contentPage", "/admin-views/admin-carts.jsp");
            request.setAttribute("active", "admin/carts");

        } else {
            // ====== ORDERS ======
            String orderIdParam = request.getParameter("orderId");
            String userIdParam = request.getParameter("userId");
            String action = request.getParameter("action"); // view

            if ("view".equals(action) && orderIdParam != null) {
                try {
                    int id = Integer.parseInt(orderIdParam);
                    List<Order> found = orderDao.findWithFilter(id, null, null, null);
                    if (!found.isEmpty()) {
                        Order selectedOrder = found.get(0);
                        OrderDetailDao orderDetailDao = new OrderDetailDao();
                        selectedOrder.setItems(orderDetailDao.findByOrderId(id));
                        request.setAttribute("selectedOrder", selectedOrder);

                        dao.UserDao uDao = new dao.UserDao();
                        model.user.User customer = uDao.findById(selectedOrder.getUserId());
                        request.setAttribute("selectedCustomer", customer);
                    }
                } catch (NumberFormatException ignored) {
                }
            }

            String status = request.getParameter("status");
            if (status != null && !status.isEmpty()) {
                status = status.toUpperCase();
            } else {
                status = null;
            }

            Integer orderId = null;
            Integer userId = null;
            try {
                if (orderIdParam != null && !orderIdParam.isBlank())
                    orderId = Integer.parseInt(orderIdParam);
                if (userIdParam != null && !userIdParam.isBlank())
                    userId = Integer.parseInt(userIdParam);
            } catch (NumberFormatException ignorred) {
            }

            String dateFilter = request.getParameter("date");

            List<Order> orders;
            if (orderId != null || userId != null || (status != null && !status.isBlank()) || (dateFilter != null && !dateFilter.isBlank())) {
                orders = orderDao.findWithFilter(orderId, userId, status, dateFilter);
            } else {
                orders = orderDao.findAll();
            }
            request.setAttribute("orders", orders);

            dao.UserDao userDao = new dao.UserDao();
            request.setAttribute("shippers", userDao.getUsersByRole("SHIPPER"));

            request.setAttribute("contentPage", "/admin-views/admin-orders.jsp");
            request.setAttribute("active", "admin/orders");
        }

        request.getRequestDispatcher("/Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/admin/carts")) {
            // Handle cart CRUD
            response.sendRedirect(request.getContextPath() + "/admin/carts");
        } else {
            String action = request.getParameter("action");
            if ("updateStatus".equals(action)) {
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String newStatus = request.getParameter("newStatus");
                    String trackingCode = request.getParameter("trackingCode");
                    String shippingUnit = request.getParameter("shippingUnit");
                    
                    model.user.User adminUser = (model.user.User) request.getSession().getAttribute("currentUser");
                    String processedBy = adminUser != null ? adminUser.getFullName() : "Admin";

                    // Check if transitioning to ORDER_CONFIRMED to deduct stock
                    if ("ORDER_CONFIRMED".equals(newStatus)) {
                        dao.JDBIConnector.getJdbi().useTransaction(handle -> {
                            // 1. Update status
                            handle.createUpdate("UPDATE orders SET order_status = :status, processed_by = :processedBy WHERE id = :orderId")
                                  .bind("status", newStatus)
                                  .bind("processedBy", processedBy)
                                  .bind("orderId", orderId)
                                  .execute();

                            // 2. Deduct stock
                            dao.Product.ProductVariantDao variantDao = new dao.Product.ProductVariantDao();
                            dao.Order.OrderDetailDao detailDao = new dao.Order.OrderDetailDao();
                            java.util.List<model.Order.OrderDetailDTO> items = detailDao.findByOrderId(orderId);
                            for (model.Order.OrderDetailDTO item : items) {
                                variantDao.updateStock(handle, item.getProductId(), item.getColorId(), item.getSizeId(), item.getQuantity());
                            }
                        });
                    } else {
                        // Other transitions
                        orderDao.updateStatus(orderId, newStatus, trackingCode, shippingUnit, processedBy);

                        // If assigning shipper
                        String shipperIdStr = request.getParameter("shipperId");
                        if ("ORDER_SHIPPING".equals(newStatus) && shipperIdStr != null && !shipperIdStr.isEmpty()) {
                            long shipperId = Long.parseLong(shipperIdStr);
                            dao.JDBIConnector.getJdbi().useHandle(handle -> {
                                handle.createUpdate("UPDATE orders SET shipper_id = :shipperId WHERE id = :orderId")
                                        .bind("shipperId", shipperId)
                                        .bind("orderId", orderId)
                                        .execute();
                            });
                        }
                    }
                    
                } catch (Exception e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("msg", "Có lỗi xảy ra: " + e.getMessage());
                    request.getSession().setAttribute("msgType", "error");
                }
            } else if ("confirm-cod".equals(action)) {
                // Admin xác nhận đã nhận tiền COD từ Shipper => chuyển sang ORDER_COMPLETED
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    model.user.User adminUser = (model.user.User) request.getSession().getAttribute("currentUser");
                    String processedBy = adminUser != null ? adminUser.getFullName() : "Admin";

                    dao.JDBIConnector.getJdbi().useHandle(handle -> {
                        handle.createUpdate("UPDATE orders SET order_status = 'ORDER_COMPLETED', payment_status = 'PAID', processed_by = :processedBy WHERE id = :orderId AND order_status = 'PENDING_COD'")
                                .bind("processedBy", processedBy)
                                .bind("orderId", orderId)
                                .execute();
                    });
                    request.getSession().setAttribute("msg", "Xác nhận nhận tiền COD thành công! Đơn đã hoàn thành.");
                    request.getSession().setAttribute("msgType", "success");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("msg", "Có lỗi xảy ra: " + e.getMessage());
                    request.getSession().setAttribute("msgType", "error");
                }
            } else if ("received-return".equals(action)) {
                // Admin xác nhận đã nhận lại hàng hoàn từ Shipper → RETURNED
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    model.user.User adminUser = (model.user.User) request.getSession().getAttribute("currentUser");
                    String processedBy = adminUser != null ? adminUser.getFullName() : "Admin";

                    dao.JDBIConnector.getJdbi().useHandle(handle -> {
                        handle.createUpdate("UPDATE orders SET order_status = 'RETURNED', processed_by = :processedBy WHERE id = :orderId AND order_status = 'RETURNING'")
                                .bind("processedBy", processedBy)
                                .bind("orderId", orderId)
                                .execute();
                    });
                    request.getSession().setAttribute("msg", "Xác nhận đã nhận lại hàng hoàn thành công.");
                    request.getSession().setAttribute("msgType", "success");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("msg", "Có lỗi xảy ra: " + e.getMessage());
                    request.getSession().setAttribute("msgType", "error");
                }
            } else if ("reject-return".equals(action)) {
                // Admin từ chối yêu cầu hoàn hàng → RETURN_REJECTED
                try {
                    int orderId = Integer.parseInt(request.getParameter("orderId"));
                    String rejectionReason = request.getParameter("rejectionReason");
                    if (rejectionReason == null || rejectionReason.trim().isEmpty()) {
                        rejectionReason = "Shop từ chối yêu cầu hoàn hàng";
                    }
                    model.user.User adminUser = (model.user.User) request.getSession().getAttribute("currentUser");
                    String processedBy = adminUser != null ? adminUser.getFullName() : "Admin";

                    orderDao.rejectReturn(orderId, rejectionReason.trim(), processedBy);
                    request.getSession().setAttribute("msg", "Đã từ chối yêu cầu hoàn hàng cho đơn #" + orderId + ".");
                    request.getSession().setAttribute("msgType", "success");
                } catch (Exception e) {
                    e.printStackTrace();
                    request.getSession().setAttribute("msg", "Có lỗi xảy ra: " + e.getMessage());
                    request.getSession().setAttribute("msgType", "error");
                }
            }

            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
