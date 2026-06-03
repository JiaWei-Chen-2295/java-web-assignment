package fun.javierchen.ch17elbean;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

@WebServlet("/bigCities")
public class BigCitiesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        // 国家 -> 首都
        Map<String, String> capitals = new LinkedHashMap<>();
        capitals.put("中国", "北京");
        capitals.put("美国", "华盛顿");
        capitals.put("日本", "东京");
        capitals.put("英国", "伦敦");
        capitals.put("法国", "巴黎");

        // 国家 -> 大城市数组
        Map<String, String[]> bigCities = new LinkedHashMap<>();
        bigCities.put("中国", new String[]{"北京", "上海", "广州", "深圳"});
        bigCities.put("美国", new String[]{"纽约", "洛杉矶", "芝加哥"});
        bigCities.put("日本", new String[]{"东京", "大阪", "横滨"});
        bigCities.put("英国", new String[]{"伦敦", "曼彻斯特", "伯明翰"});
        bigCities.put("法国", new String[]{"巴黎", "马赛", "里昂"});

        req.setAttribute("capitals", capitals);
        req.setAttribute("bigCities", bigCities);

        req.getRequestDispatcher("bigCities.jsp").forward(req, resp);
    }
}
