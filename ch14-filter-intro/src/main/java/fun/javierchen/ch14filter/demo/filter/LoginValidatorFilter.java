package fun.javierchen.ch14filter.demo.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * 登录验证码验证过滤器
 * 拦截 POST /login 请求，校验用户输入的验证码是否与 session 中存储的一致。
 * 验证码错误则 forward 回 login.jsp 并携带错误信息；
 * 验证码正确则放行，由 LoginServlet 继续处理用户名密码。
 */
public class LoginValidatorFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("[LoginValidatorFilter] init()");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpReq = (HttpServletRequest) request;

        // 只拦截 POST 请求（GET 直接放行，让 login.jsp 生成验证码）
        if (!"POST".equalsIgnoreCase(httpReq.getMethod())) {
            chain.doFilter(request, response);
            return;
        }

        String inputCode = request.getParameter("captcha");
        HttpSession session = httpReq.getSession(false);
        String sessionCode = (session != null) ? (String) session.getAttribute("captcha") : null;

        System.out.println("[LoginValidatorFilter] 用户输入=" + inputCode + ", session验证码=" + sessionCode);

        if (sessionCode == null || !sessionCode.equalsIgnoreCase(inputCode)) {
            // 验证码错误，回传错误信息
            System.out.println("[LoginValidatorFilter] 验证码错误，拦截请求");
            request.setAttribute("captchaError", "验证码错误，请重新输入！");
            // 保留用户已输入的用户名
            request.setAttribute("username", request.getParameter("username"));
            RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
            rd.forward(request, response);
            return;
        }

        // 验证码正确，清除 session 中的验证码（防止重复使用），放行
        session.removeAttribute("captcha");
        System.out.println("[LoginValidatorFilter] 验证码正确，放行到 LoginServlet");
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        System.out.println("[LoginValidatorFilter] destroy()");
    }
}
