package fun.javierchen.ch06;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collection;

/**
 * 文件上传Servlet - 支持单文件和多文件上传
 * 使用Jakarta Servlet 6.x 新版API
 */
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,      // 1MB - 超过此大小写入磁盘
        maxFileSize = 1024 * 1024 * 10,       // 10MB - 单个文件最大大小
        maxRequestSize = 1024 * 1024 * 50     // 50MB - 整个请求最大大小
)
public class FileUploadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. 设置编码
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // 2. 获取文件保存路径
        String savePath = getServletContext().getRealPath("/WEB-INF/uploadFile");
        File uploadDir = new File(savePath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 获取学号和姓名参数
        String studentId = request.getParameter("studentId");
        String studentName = request.getParameter("studentName");

        // 3. 获取form表单上传的多个文件
        Collection<Part> parts = request.getParts();

        StringBuilder uploadedFiles = new StringBuilder();
        int fileCount = 0;

        // 4. 循环遍历多个文件
        for (Part part : parts) {
            // 5. 获取原文件名 - 新版API直接使用getSubmittedFileName()
            String fileName = part.getSubmittedFileName();

            // 判断是否为文件（排除普通表单字段）
            if (fileName != null && !fileName.isEmpty()) {
                // 6. 保存文件到指定路径
                part.write(savePath + File.separator + fileName);
                uploadedFiles.append(fileName).append("<br>");
                fileCount++;
            }
        }

        // 获取当前时间
        String currentTime = LocalDateTime.now()
                .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));

        // 输出响应信息 - 亮色简洁风格
        PrintWriter out = response.getWriter();
        out.println("<!DOCTYPE html>");
        out.println("<html lang='zh-CN'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<title>提交成功</title>");
        out.println("<style>");
        out.println("* { margin: 0; padding: 0; box-sizing: border-box; }");
        out.println("body { font-family: -apple-system, 'Segoe UI', sans-serif; min-height: 100vh; background: #fafafa; display: flex; justify-content: center; align-items: center; padding: 20px; }");
        out.println(".card { width: 100%; max-width: 420px; background: #fff; border-radius: 16px; box-shadow: 0 4px 24px rgba(0,0,0,0.06); overflow: hidden; }");
        out.println(".header { padding: 32px 32px 40px; background: linear-gradient(135deg, #10b981 0%, #059669 100%); position: relative; text-align: center; }");
        out.println(".header::after { content: ''; position: absolute; bottom: -20px; left: 0; right: 0; height: 40px; background: #fff; border-radius: 20px 20px 0 0; }");
        out.println(".check-icon { width: 56px; height: 56px; margin: 0 auto 16px; background: rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; }");
        out.println(".check-icon::before { content: '\\2713'; color: #fff; font-size: 28px; font-weight: bold; }");
        out.println(".header h1 { color: #fff; font-size: 20px; font-weight: 600; }");
        out.println(".header p { color: rgba(255,255,255,0.85); font-size: 13px; margin-top: 4px; }");
        out.println(".body { padding: 16px 32px 32px; }");
        out.println(".info-item { display: flex; justify-content: space-between; align-items: center; padding: 14px 0; border-bottom: 1px solid #f1f5f9; }");
        out.println(".info-item:last-of-type { border-bottom: none; }");
        out.println(".info-label { font-size: 13px; color: #64748b; }");
        out.println(".info-value { font-size: 14px; color: #1e293b; font-weight: 500; }");
        out.println(".file-box { margin-top: 16px; padding: 16px; background: #f8fafc; border-radius: 10px; }");
        out.println(".file-title { font-size: 12px; color: #64748b; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 0.5px; }");
        out.println(".file-item { padding: 8px 12px; background: #fff; border-radius: 6px; margin-bottom: 6px; font-size: 13px; color: #475569; border: 1px solid #e2e8f0; }");
        out.println(".file-item:last-child { margin-bottom: 0; }");
        out.println(".back-btn { display: block; width: 100%; padding: 14px; margin-top: 20px; background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 100%); border: none; border-radius: 10px; color: #fff; font-size: 14px; font-weight: 600; text-decoration: none; text-align: center; transition: all 0.2s; }");
        out.println(".back-btn:hover { transform: translateY(-1px); box-shadow: 0 6px 20px rgba(99,102,241,0.35); }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='card'>");
        out.println("<div class='header'>");
        out.println("<div class='check-icon'></div>");
        out.println("<h1>提交成功</h1>");
        out.println("<p>Submission Complete</p>");
        out.println("</div>");
        out.println("<div class='body'>");
        out.println("<div class='info-item'><span class='info-label'>学号</span><span class='info-value'>" + (studentId != null ? studentId : "-") + "</span></div>");
        out.println("<div class='info-item'><span class='info-label'>姓名</span><span class='info-value'>" + (studentName != null ? studentName : "-") + "</span></div>");
        out.println("<div class='info-item'><span class='info-label'>提交时间</span><span class='info-value'>" + currentTime + "</span></div>");
        out.println("<div class='info-item'><span class='info-label'>文件数量</span><span class='info-value'>" + fileCount + " 个</span></div>");
        if (fileCount > 0) {
            out.println("<div class='file-box'>");
            out.println("<div class='file-title'>文件列表</div>");
            for (String file : uploadedFiles.toString().split("<br>")) {
                if (!file.trim().isEmpty()) {
                    out.println("<div class='file-item'>" + file + "</div>");
                }
            }
            out.println("</div>");
        }
        out.println("<a href='upload.html' class='back-btn'>返回上传</a>");
        out.println("</div>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}
