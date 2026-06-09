package controller;

import dao.Order.OrderDao;
import dao.Order.OrderDetailDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Order.Order;
import model.user.User;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-success")
public class OrderSuccessController extends HttpServlet {

    private final OrderDao orderDao = new OrderDao();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Integer orderId = null;

        if (session != null) {
            orderId = (Integer) session.getAttribute("lastOrderId");
            if (orderId != null) {
                session.removeAttribute("lastOrderId");
                session.setAttribute("allowedOrderId", orderId);
            } else {
                String idParam = req.getParameter("orderId");
                if (idParam != null) {
                    try {
                        orderId = Integer.parseInt(idParam);
                    } catch (NumberFormatException ignored) {}
                }
            }
        }

        if (orderId != null) {
            try {
                List<Order> found = orderDao.findWithFilter(orderId, null, null, null);
                if (!found.isEmpty()) {
                    Order order = found.get(0);
                    
                    boolean isAllowed = false;
                    if (session != null) {
                        Integer allowedId = (Integer) session.getAttribute("allowedOrderId");
                        if (allowedId != null && allowedId.equals(orderId)) {
                            isAllowed = true;
                        } else {
                            User currentUser = (User) session.getAttribute("currentUser");
                            if (currentUser != null && order.getUserId() == currentUser.getId()) {
                                isAllowed = true;
                            }
                        }
                    }

                    if (isAllowed) {
                        OrderDetailDao detailDao = new OrderDetailDao();
                        order.setItems(detailDao.findByOrderId(orderId));
                        req.setAttribute("order", order);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        req.getRequestDispatcher("/order-success.jsp").forward(req, resp);
    }
}
