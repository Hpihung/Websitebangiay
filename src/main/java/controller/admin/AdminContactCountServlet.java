package controller.admin;

import dao.ContactDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/admin/contacts/count")
public class AdminContactCountServlet extends HttpServlet {
    private ContactDao contactDao;

    @Override
    public void init() throws ServletException {
        contactDao = new ContactDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        int count = contactDao.getUnreadCount();
        response.getWriter().write("{\"count\": " + count + "}");
    }
}
