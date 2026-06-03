package fun.javierchen.ch14filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;

public class ResValidatorFilter implements Filter {

    private static final int USERNAME_MIN = 3;
    private static final int USERNAME_MAX = 20;
    private static final int PASSWORD_MIN = 6;
    private static final int PASSWORD_MAX = 20;

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[ResValidatorFilter] init()");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;

        String username = request.getParameter("username");
        String nickname = request.getParameter("nickname");
        String password = request.getParameter("password");

        String errorMsg = null;

        if (isBlank(username)) {
            errorMsg = "用户名不能为空！";
        } else if (username.length() < USERNAME_MIN || username.length() > USERNAME_MAX) {
            errorMsg = "用户名长度必须在 " + USERNAME_MIN + "~" + USERNAME_MAX + " 位之间！";
        } else if (isBlank(password)) {
            errorMsg = "密码不能为空！";
        } else if (password.length() < PASSWORD_MIN || password.length() > PASSWORD_MAX) {
            errorMsg = "密码长度必须在 " + PASSWORD_MIN + "~" + PASSWORD_MAX + " 位之间！";
        }

        if (errorMsg != null) {
            System.out.println("[ResValidatorFilter] 验证未通过: " + errorMsg);
            request.setAttribute("errorMsg", errorMsg);
            request.setAttribute("username", username);
            request.setAttribute("nickname", nickname);
            RequestDispatcher rd = request.getRequestDispatcher("/register.jsp");
            rd.forward(request, response);
            return;
        }

        System.out.println("[ResValidatorFilter] 验证通过，username=" + username);
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("[ResValidatorFilter] destroy()");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
