package fun.javierchen.ch15circle;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/circle")
public class CircleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");

        String radiusStr = req.getParameter("radius");

        if (radiusStr == null || radiusStr.trim().isEmpty()) {
            req.setAttribute("error", "请输入半径");
            req.getRequestDispatcher("circle-form.jsp").forward(req, resp);
            return;
        }

        try {
            double radius = Double.parseDouble(radiusStr.trim());
            if (radius <= 0) {
                req.setAttribute("error", "半径必须为正数");
                req.getRequestDispatcher("circle-form.jsp").forward(req, resp);
                return;
            }

            Circle circle = new Circle(radius);

            req.setAttribute("radius", circle.getRadius());
            req.setAttribute("perimeter", circle.getPerimeter());
            req.setAttribute("area", circle.getArea());
            req.getRequestDispatcher("circle-view.jsp").forward(req, resp);

        } catch (NumberFormatException e) {
            req.setAttribute("error", "请输入有效的数字");
            req.getRequestDispatcher("circle-form.jsp").forward(req, resp);
        }
    }
}
