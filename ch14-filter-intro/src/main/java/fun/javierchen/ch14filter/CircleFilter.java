package fun.javierchen.ch14filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.ServletContext;

import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicInteger;

public class CircleFilter implements Filter {

    private static final AtomicInteger REQUEST_COUNTER = new AtomicInteger(0);
    private static final String LOG_ATTR = "circleFilterLogs";
    private static final DateTimeFormatter TIME_FORMATTER = DateTimeFormatter.ofPattern("HH:mm:ss");

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        appendLog(filterConfig.getServletContext(), "init() 生命周期开始");
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        ServletContext servletContext = request.getServletContext();
        int count = REQUEST_COUNTER.incrementAndGet();
        String before = "doFilter-前置代码，第 " + count + " 次请求";
        appendLog(servletContext, before);

        request.setAttribute("circleFilterTrace", before);
        chain.doFilter(request, response);

        String after = "doFilter-后置代码，第 " + count + " 次请求";
        appendLog(servletContext, after);
    }

    @Override
    public void destroy() {
        // 容器销毁阶段仍保留控制台日志，方便观测最终生命周期回调
        System.out.println("[CircleFilter] " + now() + " | destroy() 生命周期结束");
    }

    private void appendLog(ServletContext context, String message) {
        @SuppressWarnings("unchecked")
        List<String> logs = (List<String>) context.getAttribute(LOG_ATTR);
        if (logs == null) {
            logs = new CopyOnWriteArrayList<>();
            context.setAttribute(LOG_ATTR, logs);
        }
        String line = now() + " | " + message;
        logs.add(line);
        System.out.println("[CircleFilter] " + line);
    }

    private String now() {
        return LocalDateTime.now().format(TIME_FORMATTER);
    }
}
