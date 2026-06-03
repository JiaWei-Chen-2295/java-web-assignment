package fun.javierchen.noteapp.servlet;

import fun.javierchen.noteapp.model.entity.Folder;
import fun.javierchen.noteapp.model.entity.User;
import fun.javierchen.noteapp.service.FolderService;
import fun.javierchen.noteapp.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/api/folder/*")
public class FolderServlet extends HttpServlet {

    private final FolderService folderService = new FolderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            path = "/list";
        }

        User currentUser = (User) req.getSession().getAttribute("currentUser");

        switch (path) {
            case "/list":
                handleList(req, resp, currentUser);
                break;
            case "/tree":
                handleTree(req, resp, currentUser);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        User currentUser = (User) req.getSession().getAttribute("currentUser");

        switch (path) {
            case "/create":
                handleCreate(req, resp, currentUser);
                break;
            case "/update":
                handleUpdate(req, resp, currentUser);
                break;
            case "/delete":
                handleDelete(req, resp, currentUser);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        List<Folder> folders = folderService.getUserFolders(user.getId());
        JsonUtil.writeJson(resp, folders);
    }

    private void handleTree(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        List<Folder> tree = folderService.getFolderTree(user.getId());
        JsonUtil.writeJson(resp, tree);
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        Map<String, Object> body = JsonUtil.readJson(req, Map.class);
        String name = (String) body.get("name");
        Long parentId = body.get("parentId") != null ? ((Number) body.get("parentId")).longValue() : null;
        String icon = (String) body.getOrDefault("icon", "folder");

        if (name == null || name.trim().isEmpty()) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "Folder name is required");
            JsonUtil.writeJson(resp, err);
            return;
        }

        Folder folder = folderService.createFolder(user.getId(), name.trim(), parentId, icon);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("id", folder.getId());
        result.put("name", folder.getName());
        JsonUtil.writeJson(resp, result);
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        Map<String, Object> body = JsonUtil.readJson(req, Map.class);
        Long id = ((Number) body.get("id")).longValue();
        String name = (String) body.get("name");
        String icon = (String) body.get("icon");

        try {
            folderService.updateFolder(id, user.getId(), name, icon);
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            JsonUtil.writeJson(resp, result);
        } catch (Exception e) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", e.getMessage());
            JsonUtil.writeJson(resp, err);
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp, User user)
            throws IOException {
        Map<String, Object> body = JsonUtil.readJson(req, Map.class);
        Long id = ((Number) body.get("id")).longValue();

        try {
            folderService.deleteFolder(id, user.getId());
            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            JsonUtil.writeJson(resp, result);
        } catch (Exception e) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", e.getMessage());
            JsonUtil.writeJson(resp, err);
        }
    }
}
