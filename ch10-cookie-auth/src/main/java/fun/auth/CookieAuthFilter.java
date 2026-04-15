package fun.auth;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@WebFilter("/*")
public class CookieAuthFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        String uri = req.getRequestURI();

        // Pass through for assets, login, and registration logic
        if (uri.endsWith("login.jsp") || uri.endsWith("register.jsp") || 
            uri.endsWith("sendCookieServlet") || uri.endsWith("registerServlet")) {
            chain.doFilter(request, response);
            return;
        }

        // Check for session/attribute first (for immediate login)
        if (req.getAttribute("user") != null) {
            chain.doFilter(request, response);
            return;
        }

        // Check cookies for auto-login
        Cookie[] cookies = req.getCookies();
        String studentId = null;
        String name = null;

        if (cookies != null) {
            for (Cookie c : cookies) {
                if ("user_id".equals(c.getName())) {
                    studentId = c.getValue();
                } else if ("user_name".equals(c.getName())) {
                    name = URLDecoder.decode(c.getValue(), StandardCharsets.UTF_8);
                }
            }
        }

        if (studentId != null && name != null) {
            User user = new User(studentId, name, ""); // Password not needed here
            req.setAttribute("user", user);
        }

        chain.doFilter(request, response);
    }
}
