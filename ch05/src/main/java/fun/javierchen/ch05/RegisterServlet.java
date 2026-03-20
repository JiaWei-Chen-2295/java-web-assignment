package fun.javierchen.ch05;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

public class RegisterServlet extends HttpServlet {

    private static final String DATA_FILE = "users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        String account = request.getParameter("account");
        String password = request.getParameter("password");

        if (account == null || account.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            response.sendRedirect("failure.html");
            return;
        }

        account = account.trim();
        password = password.trim();

        Path filePath = getDataFilePath();

        // 检查账号是否已存在
        if (isAccountExists(filePath, account)) {
            response.sendRedirect("failure.html");
            return;
        }

        // 保存账号密码到文件
        saveUser(filePath, account, password);

        response.sendRedirect("success.html");
    }

    private Path getDataFilePath() {
        String dataDir = getServletContext().getRealPath("/WEB-INF/data");
        File dir = new File(dataDir);
        if (!dir.exists()) {
            dir.mkdirs();
        }
        return Paths.get(dataDir, DATA_FILE);
    }

    private boolean isAccountExists(Path filePath, String account) throws IOException {
        if (!Files.exists(filePath)) {
            return false;
        }
        try (BufferedReader reader = Files.newBufferedReader(filePath, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 1 && parts[0].equals(account)) {
                    return true;
                }
            }
        }
        return false;
    }

    private void saveUser(Path filePath, String account, String password) throws IOException {
        String record = account + "," + password + System.lineSeparator();
        Files.writeString(filePath, record, StandardCharsets.UTF_8,
                StandardOpenOption.CREATE, StandardOpenOption.APPEND);
    }
}
