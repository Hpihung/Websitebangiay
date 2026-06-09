package controller.shipper;

import dao.Order.OrderDao;
import dao.Order.OrderDetailDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Order.Order;
import model.user.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/shipper/orders")
public class ShipperOrderController extends HttpServlet {
    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"SHIPPER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Action view order detail
        String action = request.getParameter("action");
        String orderIdParam = request.getParameter("orderId");
        if ("view".equals(action) && orderIdParam != null) {
            try {
                int id = Integer.parseInt(orderIdParam);
                List<Order> found = orderDao.findWithFilter(id, null, null, null);
                if (!found.isEmpty()) {
                    Order selectedOrder = found.get(0);
                    if (selectedOrder.getShipperId() != null && selectedOrder.getShipperId() == user.getId()) {
                        OrderDetailDao orderDetailDao = new OrderDetailDao();
                        selectedOrder.setItems(orderDetailDao.findByOrderId(id));
                        request.setAttribute("selectedOrder", selectedOrder);
                    }
                }
            } catch (NumberFormatException ignored) {}
        }

        // Get orders assigned to this shipper - show active delivery orders
        String sql = "SELECT * FROM orders WHERE shipper_id = :shipperId " +
                     "AND order_status IN ('ORDER_SHIPPING','PENDING_COD','RESCHEDULED','RETURNING','ORDER_DELIVERED','ORDER_COMPLETED') " +
                     "ORDER BY FIELD(order_status,'ORDER_SHIPPING','RESCHEDULED','PENDING_COD','RETURNING','ORDER_DELIVERED','ORDER_COMPLETED'), created_at DESC";
        List<Order> orders = dao.JDBIConnector.getJdbi().withHandle(handle ->
            handle.createQuery(sql)
                  .bind("shipperId", user.getId())
                  .mapToBean(Order.class)
                  .list()
        );

        request.setAttribute("orders", orders);
        request.getRequestDispatcher("/shipper-views/shipper-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("currentUser");
        if (user == null || !"SHIPPER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String orderIdParam = request.getParameter("orderId");

        try {
            int orderId = Integer.parseInt(orderIdParam);
            List<Order> found = orderDao.findWithFilter(orderId, null, null, null);

            if (found.isEmpty() || found.get(0).getShipperId() == null
                    || found.get(0).getShipperId() != (long) user.getId()) {
                // Not authorized or not found
                response.sendRedirect(request.getContextPath() + "/shipper/orders");
                return;
            }

            Order order = found.get(0);

            switch (action) {
                case "deliver": {
                    // Shipper xác nhận đã giao thành công
                    // Nếu là COD và chưa thanh toán => PENDING_COD (chờ đối soát)
                    // Nếu đã thanh toán online => ORDER_DELIVERED
                    String newStatus = "ORDER_DELIVERED";
                    String paymentStatusUpdate = "";
                    if ("COD".equalsIgnoreCase(order.getPaymentMethod())
                            && !"PAID".equalsIgnoreCase(order.getPaymentStatus())) {
                        newStatus = "PENDING_COD";
                        paymentStatusUpdate = ", payment_status = 'COD_COLLECTED'";
                    }
                    final String finalStatus = newStatus;
                    final String finalPayment = paymentStatusUpdate;
                    dao.JDBIConnector.getJdbi().useHandle(handle ->
                        handle.createUpdate("UPDATE orders SET order_status = :status" + finalPayment +
                                            ", delivered_at = NOW(), processed_by = :processedBy WHERE id = :orderId")
                              .bind("status", finalStatus)
                              .bind("processedBy", "Shipper: " + user.getFullName())
                              .bind("orderId", orderId)
                              .execute()
                    );
                    request.getSession().setAttribute("shipperMsg", "✅ Đã cập nhật giao thành công! Đơn #" + orderId + " đang chờ đối soát COD.");
                    break;
                }

                case "reschedule": {
                    // Khách hẹn lại - giao thất bại tạm thời
                    String rescheduleNote = request.getParameter("rescheduleNote");
                    String noteText = (rescheduleNote != null && !rescheduleNote.isBlank())
                                      ? rescheduleNote : "Khách hẹn giao lại";
                    dao.JDBIConnector.getJdbi().useHandle(handle ->
                        handle.createUpdate("UPDATE orders SET order_status = 'RESCHEDULED', " +
                                            "order_note = CONCAT(IFNULL(order_note,''), ' | Hẹn lại: ', :note), " +
                                            "processed_by = :processedBy WHERE id = :orderId")
                              .bind("note", noteText)
                              .bind("processedBy", "Shipper: " + user.getFullName())
                              .bind("orderId", orderId)
                              .execute()
                    );
                    request.getSession().setAttribute("shipperMsg", "🔄 Đã cập nhật hẹn giao lại cho đơn #" + orderId);
                    break;
                }

                case "boom": {
                    // Khách boom / không nhận hàng => chuyển về hoàn hàng
                    String boomReason = request.getParameter("boomReason");
                    String reasonText = (boomReason != null && !boomReason.isBlank())
                                        ? boomReason : "Khách không nhận hàng";
                    dao.JDBIConnector.getJdbi().useHandle(handle ->
                        handle.createUpdate("UPDATE orders SET order_status = 'RETURNING', " +
                                            "cancel_reason = :reason, " +
                                            "processed_by = :processedBy WHERE id = :orderId")
                              .bind("reason", reasonText)
                              .bind("processedBy", "Shipper: " + user.getFullName())
                              .bind("orderId", orderId)
                              .execute()
                    );
                    request.getSession().setAttribute("shipperMsg", "⚠️ Đơn #" + orderId + " đã được chuyển về trạng thái hoàn hàng.");
                    break;
                }

                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        if ("XMLHttpRequest".equalsIgnoreCase(request.getHeader("X-Requested-With"))) {
            // Get orders assigned to this shipper - show active delivery orders
            String sql = "SELECT * FROM orders WHERE shipper_id = :shipperId " +
                         "AND order_status IN ('ORDER_SHIPPING','PENDING_COD','RESCHEDULED','RETURNING','ORDER_DELIVERED','ORDER_COMPLETED') " +
                         "ORDER BY FIELD(order_status,'ORDER_SHIPPING','RESCHEDULED','PENDING_COD','RETURNING','ORDER_DELIVERED','ORDER_COMPLETED'), created_at DESC";
            List<Order> orders = dao.JDBIConnector.getJdbi().withHandle(handle ->
                handle.createQuery(sql)
                      .bind("shipperId", user.getId())
                      .mapToBean(Order.class)
                      .list()
            );
            request.setAttribute("orders", orders);
            request.getRequestDispatcher("/shipper-views/shipper-orders.jsp").forward(request, response);
            return;
        }

        response.sendRedirect(request.getContextPath() + "/shipper/orders");
    }
}
