package fun.javierchen.ch15circle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/rectangle")
public class RectangleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String lengthStr = req.getParameter("length");
        String widthStr = req.getParameter("width");

        if (lengthStr == null || lengthStr.trim().isEmpty()
                || widthStr == null || widthStr.trim().isEmpty()) {
            req.setAttribute("error", "请输入长度和宽度");
            req.getRequestDispatcher("rectangle-form.jsp").forward(req, resp);
            return;
        }

        try {
            double length = Double.parseDouble(lengthStr.trim());
            double width = Double.parseDouble(widthStr.trim());

            if (length <= 0 || width <= 0) {
                req.setAttribute("error", "长度和宽度必须为正数");
                req.getRequestDispatcher("rectangle-form.jsp").forward(req, resp);
                return;
            }

            Rectangle rectangle = new Rectangle(length, width);

            req.setAttribute("rectangle", rectangle);
            req.getRequestDispatcher("rectangle-view.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "请输入有效的数字");
            req.getRequestDispatcher("rectangle-form.jsp").forward(req, resp);
        }
    }
}
