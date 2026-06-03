package fun.javierchen.sessionprofile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Random;

@WebServlet("/captcha")
public class CaptchaServlet extends HttpServlet {

    private static final int WIDTH = 120;
    private static final int HEIGHT = 40;
    private static final int CODE_LEN = 4;
    private static final String CHARS = "ABCDEFGHJKLMNPQRSTUVWXYZabcdefghjkmnpqrstuvwxyz23456789";

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setHeader("Pragma", "no-cache");
        resp.setHeader("Cache-Control", "no-cache");
        resp.setDateHeader("Expires", 0);
        resp.setContentType("image/jpeg");

        BufferedImage image = new BufferedImage(WIDTH, HEIGHT, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = image.createGraphics();

        Random rand = new Random();

        // 背景
        g.setColor(new Color(245, 245, 247));
        g.fillRect(0, 0, WIDTH, HEIGHT);

        // 干扰线
        for (int i = 0; i < 6; i++) {
            g.setColor(new Color(200 + rand.nextInt(40), 200 + rand.nextInt(40), 200 + rand.nextInt(40)));
            int x1 = rand.nextInt(WIDTH), y1 = rand.nextInt(HEIGHT);
            int x2 = rand.nextInt(WIDTH), y2 = rand.nextInt(HEIGHT);
            g.drawLine(x1, y1, x2, y2);
        }

        // 验证码字符
        StringBuilder code = new StringBuilder();
        g.setFont(new Font("SansSerif", Font.BOLD, 28));
        for (int i = 0; i < CODE_LEN; i++) {
            String ch = String.valueOf(CHARS.charAt(rand.nextInt(CHARS.length())));
            code.append(ch);
            // 每个字符随机颜色（柔和色系）
            g.setColor(new Color(
                    50 + rand.nextInt(100),
                    50 + rand.nextInt(100),
                    50 + rand.nextInt(100)
            ));
            // 轻微旋转
            double theta = Math.toRadians(rand.nextInt(30) - 15);
            Graphics2D g2 = (Graphics2D) g.create();
            g2.rotate(theta, 20 + i * 26, 28);
            g2.drawString(ch, 12 + i * 26, 30);
            g2.dispose();
        }

        g.dispose();

        HttpSession session = req.getSession();
        session.setAttribute("captcha", code.toString());

        OutputStream out = resp.getOutputStream();
        ImageIO.write(image, "JPEG", out);
        out.flush();
    }
}
