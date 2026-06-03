package fun.javierchen.ch11loginkeeper;

import jakarta.enterprise.event.Event;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private final SessionManager sessionManager = SessionManager.getInstance();
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (sessionManager.validate(username, password)) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            
            sessionManager.login(session.getId(), username);
            
            session.setAttribute("cookieCreatedAt", System.currentTimeMillis());
            
            Cookie cookie = new Cookie("userLogin", username);
            cookie.setMaxAge(300);
            cookie.setPath("/");
            cookie.setHttpOnly(true);
            cookie.setSecure(false);
            
            session.setAttribute("cookieMaxAge", 300);
            session.setAttribute("cookiePath", "/");
            session.setAttribute("cookieHttpOnly", true);
            
            response.addCookie(cookie);
            
            response.sendRedirect("welcome.jsp");
        } else {
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}