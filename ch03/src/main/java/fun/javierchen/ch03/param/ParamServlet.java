package fun.javierchen.ch03.param;

import java.io.*;
import java.util.Enumeration;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

@WebServlet(name = "paramServlet", value = "/param")
public class ParamServlet extends HttpServlet {

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

        out.println("=== 请求信息 ===");
        out.println("Method: " + request.getMethod());
        out.println("URI: " + request.getRequestURI());
        out.println("URL: " + request.getRequestURL());
        out.println("QueryString: " + request.getQueryString());
        out.println("Protocol: " + request.getProtocol());
        out.println("RemoteAddr: " + request.getRemoteAddr());

        out.println();
        out.println("=== 请求头 ===");
        Enumeration<String> headerNames = request.getHeaderNames();
        while (headerNames.hasMoreElements()) {
            String name = headerNames.nextElement();
            out.println(name + ": " + request.getHeader(name));
        }
    }
}
