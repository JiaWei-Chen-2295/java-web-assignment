package fun.javierchen.ch12;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/accessCount")
public class AccessCountServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. 获取 Session 对象，如果不存在则创建
        HttpSession session = request.getSession();

        // 2. 获取 accesscount 属性
        Integer count = (Integer) session.getAttribute("accesscount");

        // 3. 计算新的访问次数
        if (count == null) {
            count = 1;
        } else {
            count++;
        }

        // 4. 将新的次数存回 Session
        session.setAttribute("accesscount", count);

        // 5. 输出响应
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        out.println("<html>");
        out.println("<head><title>访问次数统计</title></head>");
        out.println("<body>");
        out.println("<h1>Session 属性测试</h1>");
        out.println("<p>您是第 <b>" + count + "</b> 次访问本页面（当前 Session）。</p>");
        out.println("<p>Session ID: " + session.getId() + "</p>");
        out.println("</body>");
        out.println("</html>");
    }
}
