package fun.javierchen.ch07;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * RefreshServlet - 显示学号姓名和当前时间，支持自动刷新
 */
public class RefreshServlet extends HttpServlet {

    // 学号和姓名（可根据实际情况修改）
    private static final String STUDENT_ID = "2023154202";
    private static final String STUDENT_NAME = "陈佳玮";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 获取当前时间
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String currentTime = sdf.format(new Date());

        // 设置请求属性
        request.setAttribute("studentId", STUDENT_ID);
        request.setAttribute("studentName", STUDENT_NAME);
        request.setAttribute("currentTime", currentTime);

        // 转发到JSP页面
        request.getRequestDispatcher("/refresh.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
