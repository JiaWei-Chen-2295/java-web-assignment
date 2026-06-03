package fun.javierchen.showcase;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.yaml.snakeyaml.Yaml;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;
import java.util.Map;

@WebServlet("/api/modules")
public class ModulesServlet extends HttpServlet {

    private volatile String cachedJson;
    private volatile long lastModified;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String json = cachedJson;

        try {
            long currentMod = getServletContext()
                    .getResource("/WEB-INF/classes/modules.yml")
                    .openConnection()
                    .getLastModified();

            if (json == null || currentMod != lastModified) {
                json = loadAndConvert();
                cachedJson = json;
                lastModified = currentMod;
            }
        } catch (Exception e) {
            // 文件不可读时用缓存
            if (json == null) json = "[]";
        }

        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(json);
    }

    @Override
    public void init() throws ServletException {
        try {
            lastModified = getServletContext()
                    .getResource("/WEB-INF/classes/modules.yml")
                    .openConnection()
                    .getLastModified();
            cachedJson = loadAndConvert();
        } catch (Exception ignored) {
        }
    }

    private String loadAndConvert() {
        try (InputStream is = getServletContext().getResourceAsStream("/WEB-INF/classes/modules.yml")) {
            if (is == null) return "[]";

            Yaml yaml = new Yaml();
            Map<String, Object> root = yaml.load(is);
            List<Map<String, Object>> groups = (List<Map<String, Object>>) root.get("groups");

            StringBuilder sb = new StringBuilder("[");
            for (int gi = 0; gi < groups.size(); gi++) {
                Map<String, Object> group = groups.get(gi);
                if (gi > 0) sb.append(",");
                sb.append("{\"label\":\"").append(escapeJson((String) group.get("label"))).append("\",\"items\":[");

                List<Map<String, Object>> items = (List<Map<String, Object>>) group.get("items");
                for (int ii = 0; ii < items.size(); ii++) {
                    Map<String, Object> item = items.get(ii);
                    if (ii > 0) sb.append(",");
                    sb.append("{")
                      .append("\"id\":\"").append(escapeJson(String.valueOf(item.get("id")))).append("\",")
                      .append("\"title\":\"").append(escapeJson((String) item.get("title"))).append("\",")
                      .append("\"desc\":\"").append(escapeJson((String) item.get("desc"))).append("\",")
                      .append("\"url\":\"").append(escapeJson((String) item.get("url"))).append("\"")
                      .append("}");
                }
                sb.append("]}");
            }
            sb.append("]");
            return sb.toString();
        } catch (Exception e) {
            throw new RuntimeException("Failed to load modules.yml", e);
        }
    }

    private static String escapeJson(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n")
                .replace("\r", "\\r")
                .replace("\t", "\\t");
    }
}
