package controller.admin;

import dao.ContactDao;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Contact;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin/contacts")
public class AdminContactController extends HttpServlet {
    private ContactDao contactDao;

    @Override
    public void init() throws ServletException {
        contactDao = new ContactDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Auto-mark all messages as read when entering the page
        contactDao.markAllAsRead();
        
        List<Contact> contacts = contactDao.getAllContacts();
        request.setAttribute("contacts", contacts);
        request.setAttribute("unreadCount", 0); // Reset count as they are all read now
        request.setAttribute("contentPage", "admin-views/admin-contacts.jsp");
        request.setAttribute("active", "admin/contacts");
        request.getRequestDispatcher("/Admin.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            contactDao.deleteContact(id);
        } else if ("markRead".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            contactDao.markAsRead(id);
        }
        response.sendRedirect(request.getContextPath() + "/admin/contacts");
    }
}
