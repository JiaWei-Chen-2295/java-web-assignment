package fun.javierchen.ch14filter.demo.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

public class PermissionFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[PermissionFilter] init()");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpServletResponse httpResp = (HttpServletResponse) response;

        HttpSession session = httpReq.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            System.out.println("[PermissionFilter] 未登录，拦截: " + httpReq.getRequestURI());
            httpResp.sendRedirect(httpReq.getContextPath() + "/login.jsp?error=2");
            return;
        }

        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        String uri = httpReq.getRequestURI();

        System.out.println("[PermissionFilter] username=" + username + ", role=" + role + ", uri=" + uri);

        if (uri.contains("/admin/") && !"admin".equals(role)) {
            System.out.println("[PermissionFilter] 权限不足，拒绝: " + username + " 访问 /admin/");
            httpResp.sendError(HttpServletResponse.SC_FORBIDDEN, "权限不足：仅管理员可访问此页面");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("[PermissionFilter] destroy()");
    }
}
