package controller.admin;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/admin/*")
public class AdminAuthFilter implements Filter
{
    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException
    {
        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String uri = request.getRequestURI();

        // Login & logout
        if (uri.endsWith("/admin/login") || uri.endsWith("/admin/logout"))
        {
            chain.doFilter(req, res);
            return;
        }

        // test
        boolean test = Boolean.parseBoolean(request.getServletContext().getInitParameter("test"));

        if (test && !uri.endsWith("/admin/login") && !uri.endsWith("/admin/logout"))

        {
            HttpSession session = request.getSession(true);
            if (session.getAttribute("adminId") == null)
            {
                session.setAttribute("adminId", 1);
            }
            chain.doFilter(req, res);
            return;
        }

        // product test
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null)
        {
            response.sendRedirect(request.getContextPath() + "/admin/login");
            return;
        }

        chain.doFilter(req, res);
    }
}
