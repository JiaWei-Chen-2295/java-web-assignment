package fun.javierchen.ch03.param;

import java.io.*;
import java.util.Enumeration;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "requestParamServlet", value = "/request-param")
public class RequestParamServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("text/plain;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("=== 请求参数 ===");
        Enumeration<String> paramNames = request.getParameterNames();
        if (!paramNames.hasMoreElements()) {
            out.println("(无参数)");
        } else {
            while (paramNames.hasMoreElements()) {
                String name = paramNames.nextElement();
                String value = request.getParameter(name);
                out.println(name + " = " + value);
            }
        }
    }
}
