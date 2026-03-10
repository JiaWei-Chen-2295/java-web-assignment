package fun.javierchen.ch02;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDate;

public class LoginServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/html;charset=UTF-8");

        String account = request.getParameter("account");
        String password = request.getParameter("password");

        PrintWriter out = response.getWriter();
        out.println("<html><body>");

        if (account != null && password != null &&
            "2023154202陈佳玮".equals(account) &&
                "123456".equals(password)
        ) {
            out.println("<h1>登录成功！</h1>");
            out.println("<p>当前日期：" + LocalDate.now() + "</p>");
        } else {
            out.println("<h1>登录失败！</h1>");
            out.println("<p>账号与密码不一致</p>");
        }

        out.println("<a href='LoginForm.jsp'>返回登录页面</a>");
        out.println("</body></html>");
    }
}