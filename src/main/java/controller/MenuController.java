package controller;

import java.io.IOException;

import DTO.MenuDTO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import services.MenuService;

@WebServlet("/menu")
public class MenuController extends HttpServlet {
    private MenuService homeService;
    private static final int PAGE_SIZE = 12;

    @Override
    public void init() {
        homeService = new MenuService();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null && !pageParam.isBlank()) {
                page = Integer.parseInt(pageParam);
            }
        } catch (NumberFormatException ignored) {}

        int totalPages = homeService.getTotalNewestPages(PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        MenuDTO homePage = homeService.buildMenuPagePaged("all", page, PAGE_SIZE);
        req.setAttribute("menu", homePage);
        req.setAttribute("currentPage", page);
        req.setAttribute("totalPages", totalPages);
        req.getRequestDispatcher("/menu.jsp").forward(req, resp);
    }
}