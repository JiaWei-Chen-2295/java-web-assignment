package fun.javierchen.noteapp.servlet;

import fun.javierchen.noteapp.mapper.TagMapper;
import fun.javierchen.noteapp.model.dto.BacklinkDTO;
import fun.javierchen.noteapp.model.dto.ForwardLinkDTO;
import fun.javierchen.noteapp.model.entity.Folder;
import fun.javierchen.noteapp.model.entity.Note;
import fun.javierchen.noteapp.model.entity.Tag;
import fun.javierchen.noteapp.model.entity.User;
import fun.javierchen.noteapp.service.FolderService;
import fun.javierchen.noteapp.service.LinkService;
import fun.javierchen.noteapp.service.NoteService;
import fun.javierchen.noteapp.util.DBUtil;
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

@WebServlet(urlPatterns = {"/note/*", "/api/note/*"})
public class NoteServlet extends HttpServlet {

    private final NoteService noteService = new NoteService();
    private final LinkService linkService = new LinkService();
    private final FolderService folderService = new FolderService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null || path.equals("/")) {
            path = "/list";
        }

        switch (path) {
            case "/list":
                handleList(req, resp);
                break;
            case "/edit":
                handleEdit(req, resp);
                break;
            case "/new":
                handleNew(req, resp);
                break;
            case "/search":
                handleSearch(req, resp);
                break;
            case "/backlinks":
                handleBacklinks(req, resp);
                break;
            case "/forward-links":
                handleForwardLinks(req, resp);
                break;
            case "/resolve":
                handleResolve(req, resp);
                break;
            case "/favorites":
                handleFavorites(req, resp);
                break;
            case "/recent":
                handleRecent(req, resp);
                break;
            case "/content":
                handleContent(req, resp);
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
        if (path == null || path.equals("/")) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        switch (path) {
            case "/create":
                handleCreate(req, resp);
                break;
            case "/update":
                handleUpdate(req, resp);
                break;
            case "/delete":
                handleDelete(req, resp);
                break;
            case "/pin":
                handlePin(req, resp);
                break;
            case "/favorite":
                handleFavorite(req, resp);
                break;
            case "/move":
                handleMove(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        String keyword = req.getParameter("keyword");
        String folderIdStr = req.getParameter("folderId");

        List<Note> notes;
        if (keyword != null && !keyword.trim().isEmpty()) {
            notes = noteService.searchNotes(currentUser.getId(), keyword.trim());
            req.setAttribute("keyword", keyword.trim());
        } else if (folderIdStr != null && !folderIdStr.isEmpty()) {
            Long folderId = Long.parseLong(folderIdStr);
            notes = noteService.getNotesByFolder(currentUser.getId(), folderId);
            req.setAttribute("currentFolderId", folderId);
            Folder folder = folderService.getFolder(folderId);
            req.setAttribute("currentFolder", folder);
        } else {
            notes = noteService.getUserNotes(currentUser.getId());
        }

        // Load folder tree for sidebar
        List<Folder> folderTree = folderService.getFolderTree(currentUser.getId());
        List<Note> recentNotes = noteService.getRecentNotes(currentUser.getId(), 10);

        req.setAttribute("notes", notes);
        req.setAttribute("folderTree", folderTree);
        req.setAttribute("recentNotes", recentNotes);
        req.setAttribute("activeNav", folderIdStr != null && !folderIdStr.isEmpty() ? "folder" : "all");
        req.setAttribute("breadcrumb", keyword != null && !keyword.trim().isEmpty() ? "搜索" :
                (folderIdStr != null && !folderIdStr.isEmpty() ? "文件夹" : "全部笔记"));
        req.getRequestDispatcher("/WEB-INF/views/note-list.jsp").forward(req, resp);
    }

    private void handleEdit(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        String idParam = req.getParameter("id");
        if (idParam != null) {
            Note note = noteService.getNote(Long.parseLong(idParam));
            if (note == null || !note.getUserId().equals(currentUser.getId())) {
                resp.sendRedirect(req.getContextPath() + "/note/list");
                return;
            }
            org.apache.ibatis.session.SqlSession session = DBUtil.getAutoCommitSqlSession();
            try {
                TagMapper tagMapper = session.getMapper(TagMapper.class);
                note.setTags(tagMapper.selectByNoteId(note.getId()));
            } finally {
                session.close();
            }
            if (note.getFolderId() != null) {
                Folder folder = folderService.getFolder(note.getFolderId());
                if (folder != null) note.setFolderName(folder.getName());
            }
            req.setAttribute("note", note);
        } else {
            resp.sendRedirect(req.getContextPath() + "/note/list");
            return;
        }
        // Load folder tree for sidebar
        List<Folder> folderTree = folderService.getFolderTree(currentUser.getId());
        req.setAttribute("folderTree", folderTree);
        req.setAttribute("pageLayout", "editor");
        req.getRequestDispatcher("/WEB-INF/views/note-editor.jsp").forward(req, resp);
    }

    private void handleNew(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        String folderIdStr = req.getParameter("folderId");
        Long folderId = (folderIdStr != null && !folderIdStr.isEmpty()) ? Long.parseLong(folderIdStr) : null;

        String emptyEditorJs = "{\"time\":" + System.currentTimeMillis()
                + ",\"blocks\":[{\"type\":\"paragraph\",\"data\":{\"text\":\"\"}}],\"version\":\"2.28.0\"}";
        Note note = noteService.createNote(currentUser.getId(), "无标题笔记", emptyEditorJs, folderId, "editorjs");
        resp.sendRedirect(req.getContextPath() + "/note/edit?id=" + note.getId());
    }

    private void handleContent(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        Note note = noteService.getNote(Long.parseLong(idParam));
        if (note == null || !note.getUserId().equals(currentUser.getId())) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        Map<String, Object> payload = new HashMap<>();
        payload.put("id", note.getId());
        payload.put("title", note.getTitle());
        payload.put("content", noteService.normalizeNoteContent(note));
        payload.put("contentFormat", note.getContentFormat() != null ? note.getContentFormat() : "markdown");
        payload.put("updatedAt", note.getUpdatedAt());
        payload.put("wordCount", note.getWordCount());
        payload.put("isPinned", note.getIsPinned());
        payload.put("isFavorite", note.getIsFavorite());
        payload.put("folderId", note.getFolderId());
        JsonUtil.writeJson(resp, payload);
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        String keyword = req.getParameter("keyword");
        List<Note> notes = noteService.searchNotes(currentUser.getId(), keyword);
        JsonUtil.writeJson(resp, notes);
    }

    private void handleBacklinks(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idParam = req.getParameter("id");
        List<BacklinkDTO> backlinks = linkService.getBacklinks(Long.parseLong(idParam));
        JsonUtil.writeJson(resp, backlinks);
    }

    private void handleForwardLinks(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String idParam = req.getParameter("id");
        List<ForwardLinkDTO> links = linkService.getForwardLinks(Long.parseLong(idParam));
        JsonUtil.writeJson(resp, links);
    }

    /** 按标题解析笔记，用于点击 [[链接]] */
    private void handleResolve(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Map<String, Object> result = new HashMap<>();

        String idParam = req.getParameter("id");
        if (idParam != null && !idParam.isBlank()) {
            Note byId = noteService.getNote(Long.parseLong(idParam.trim()));
            if (byId != null && byId.getUserId().equals(currentUser.getId())) {
                result.put("found", true);
                result.put("id", byId.getId());
                result.put("title", byId.getTitle());
            } else {
                result.put("found", false);
            }
            JsonUtil.writeJson(resp, result);
            return;
        }

        String title = req.getParameter("title");
        if (title == null || title.isBlank()) {
            result.put("found", false);
            JsonUtil.writeJson(resp, result);
            return;
        }
        List<Note> notes = noteService.searchNotes(currentUser.getId(), title.trim());
        Note exact = null;
        for (Note n : notes) {
            if (title.trim().equals(n.getTitle())) {
                exact = n;
                break;
            }
        }
        Note target = exact != null ? exact : (notes.isEmpty() ? null : notes.get(0));
        if (target != null) {
            result.put("found", true);
            result.put("id", target.getId());
            result.put("title", target.getTitle());
        } else {
            result.put("found", false);
        }
        JsonUtil.writeJson(resp, result);
    }

    private void handleFavorites(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        List<Note> notes = noteService.getFavoriteNotes(currentUser.getId());
        List<Folder> folderTree = folderService.getFolderTree(currentUser.getId());
        List<Note> recentNotes = noteService.getRecentNotes(currentUser.getId(), 10);

        req.setAttribute("notes", notes);
        req.setAttribute("folderTree", folderTree);
        req.setAttribute("recentNotes", recentNotes);
        req.setAttribute("viewMode", "favorites");
        req.setAttribute("activeNav", "favorites");
        req.setAttribute("breadcrumb", "我的收藏");
        req.getRequestDispatcher("/WEB-INF/views/note-list.jsp").forward(req, resp);
    }

    private void handleRecent(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        List<Note> notes = noteService.getRecentNotes(currentUser.getId(), 50);
        List<Folder> folderTree = folderService.getFolderTree(currentUser.getId());
        List<Note> recentNotes = noteService.getRecentNotes(currentUser.getId(), 10);

        req.setAttribute("notes", notes);
        req.setAttribute("folderTree", folderTree);
        req.setAttribute("recentNotes", recentNotes);
        req.setAttribute("viewMode", "recent");
        req.setAttribute("activeNav", "recent");
        req.setAttribute("breadcrumb", "最近编辑");
        req.getRequestDispatcher("/WEB-INF/views/note-list.jsp").forward(req, resp);
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Map<String, String> body = JsonUtil.readJson(req, Map.class);

        Long folderId = null;
        String folderIdStr = body.get("folderId");
        if (folderIdStr != null && !folderIdStr.isEmpty()) {
            folderId = Long.parseLong(folderIdStr);
        }

        Note note = noteService.createNote(currentUser.getId(),
                body.getOrDefault("title", "Untitled"),
                body.getOrDefault("content", ""),
                folderId, "markdown");

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("id", note.getId());
        result.put("title", note.getTitle());
        JsonUtil.writeJson(resp, result);
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Map<String, Object> body = JsonUtil.readJson(req, Map.class);

        Long id = ((Number) body.get("id")).longValue();
        String title = (String) body.get("title");
        String content = (String) body.get("content");
        String contentFormat = body.get("contentFormat") != null ? String.valueOf(body.get("contentFormat")) : "editorjs";
        noteService.updateNote(id, currentUser.getId(), title, content, contentFormat);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        JsonUtil.writeJson(resp, result);
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Map<String, Object> body = JsonUtil.readJson(req, Map.class);

        Long id = ((Number) body.get("id")).longValue();
        noteService.deleteNote(id, currentUser.getId());

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        JsonUtil.writeJson(resp, result);
    }

    private void handlePin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Map<String, Object> body = JsonUtil.readJson(req, Map.class);
        Long id = ((Number) body.get("id")).longValue();

        try {
            noteService.togglePin(id, currentUser.getId());
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

    private void handleFavorite(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Map<String, Object> body = JsonUtil.readJson(req, Map.class);
        Long id = ((Number) body.get("id")).longValue();

        try {
            noteService.toggleFavorite(id, currentUser.getId());
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

    private void handleMove(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Map<String, Object> body = JsonUtil.readJson(req, Map.class);
        Long id = ((Number) body.get("id")).longValue();
        Long folderId = body.get("folderId") != null ? ((Number) body.get("folderId")).longValue() : null;

        try {
            noteService.moveToFolder(id, currentUser.getId(), folderId);
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
