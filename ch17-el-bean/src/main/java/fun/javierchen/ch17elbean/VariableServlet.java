package fun.javierchen.ch17elbean;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/variables")
public class VariableServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // pageScope variables (set as request attributes, accessed via pageScope in EL)
        req.setAttribute("attrib1", "Page作用域变量1 - Hello");
        req.setAttribute("attrib2", "Page作用域变量2 - 12345");
        req.setAttribute("attrib3", "Page作用域变量3 - EL表达式");

        // session scope
        HttpSession session = req.getSession();
        session.setAttribute("attrib4", "会话作用域变量attrib4");

        // request scope (same name, different scope)
        req.setAttribute("attrib4", "请求作用域变量attrib4");

        // application scope
        ServletContext context = getServletContext();
        context.setAttribute("attrib4", "应用作用域变量attrib4");

        req.getRequestDispatcher("variables.jsp").forward(req, resp);
    }
}
