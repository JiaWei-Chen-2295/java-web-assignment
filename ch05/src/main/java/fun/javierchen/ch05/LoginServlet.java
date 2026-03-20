package fun.javierchen.ch05;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class LoginServlet extends HttpServlet {

    private static final String DATA_FILE = "users.txt";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        String account = request.getParameter("account");
        String password = request.getParameter("password");

        if (account == null || password == null ||
            account.trim().isEmpty() || password.trim().isEmpty()) {
            response.getWriter().write("登录失败");
            return;
        }

        account = account.trim();
        password = password.trim();

        Path filePath = getDataFilePath();

        if (validateUser(filePath, account, password)) {
            String currentTime = LocalDateTime.now()
                    .format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
            response.getWriter().write(currentTime);
        } else {
            response.getWriter().write("登录失败");
        }
    }

    private Path getDataFilePath() {
        String dataDir = getServletContext().getRealPath("/WEB-INF/data");
        return Paths.get(dataDir, DATA_FILE);
    }

    private boolean validateUser(Path filePath, String account, String password) throws IOException {
        if (!Files.exists(filePath)) {
            return false;
        }
        try (BufferedReader reader = Files.newBufferedReader(filePath, StandardCharsets.UTF_8)) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length >= 2 && parts[0].equals(account) && parts[1].equals(password)) {
                    return true;
                }
            }
        }
        return false;
    }
}
