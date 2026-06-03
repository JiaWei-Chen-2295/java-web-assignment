package fun.javierchen.noteapp.servlet;

import fun.javierchen.noteapp.model.entity.Attachment;
import fun.javierchen.noteapp.model.entity.User;
import fun.javierchen.noteapp.service.FileService;
import fun.javierchen.noteapp.util.JsonUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@WebServlet("/api/upload/*")
@MultipartConfig(maxFileSize = 20971520, maxRequestSize = 52428800)
public class UploadServlet extends HttpServlet {

    private final FileService fileService = new FileService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String path = req.getPathInfo();
        if (path == null) {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }

        switch (path) {
            case "/image":
                handleImageUpload(req, resp);
                break;
            case "/attachment":
                handleAttachmentUpload(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void handleImageUpload(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "No file uploaded");
            return;
        }
        String noteIdStr = req.getParameter("noteId");
        Long noteId = (noteIdStr != null && !noteIdStr.isEmpty()) ? Long.parseLong(noteIdStr) : null;
        String uploadRoot = req.getServletContext().getRealPath("/");

        Attachment attachment = fileService.saveImage(filePart, currentUser.getId(), noteId, uploadRoot);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("url", attachment.getFilePath());
        result.put("fileName", attachment.getFileName());
        JsonUtil.writeJson(resp, result);
    }

    private void handleAttachmentUpload(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        User currentUser = (User) req.getSession().getAttribute("currentUser");
        Part filePart = req.getPart("file");
        if (filePart == null || filePart.getSize() == 0) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "No file uploaded");
            return;
        }
        String noteIdStr = req.getParameter("noteId");
        Long noteId = (noteIdStr != null && !noteIdStr.isEmpty()) ? Long.parseLong(noteIdStr) : null;
        String uploadRoot = req.getServletContext().getRealPath("/");

        Attachment attachment = fileService.saveAttachment(filePart, currentUser.getId(), noteId, uploadRoot);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("url", attachment.getFilePath());
        result.put("fileName", attachment.getFileName());
        result.put("fileSize", attachment.getFileSize());
        JsonUtil.writeJson(resp, result);
    }
}
