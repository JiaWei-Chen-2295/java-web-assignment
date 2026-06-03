package fun.javierchen.ch14filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebFilter("/student")
public class WelcomeFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setAttribute("welcomeMessage", StudentConstants.WELCOME_MESSAGE);
        if (response instanceof HttpServletResponse httpServletResponse) {
            httpServletResponse.setContentType("text/html;charset=UTF-8");
            httpServletResponse.setHeader("X-Welcome-Status", "active");
        }
        chain.doFilter(request, response);
    }
}
