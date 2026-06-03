package fun.javierchen.noteapp.service;

import fun.javierchen.noteapp.mapper.AttachmentMapper;
import fun.javierchen.noteapp.model.entity.Attachment;
import fun.javierchen.noteapp.util.DBUtil;
import fun.javierchen.noteapp.util.FileUtil;
import jakarta.servlet.http.Part;
import org.apache.ibatis.session.SqlSession;

import java.io.IOException;
import java.util.Date;
import java.util.List;

public class FileService {

    public Attachment saveImage(Part part, Long userId, Long noteId, String uploadRoot) {
        String fileName = FileUtil.getFileName(part);
        if (!FileUtil.isAllowedImage(fileName)) {
            throw new RuntimeException("Not an allowed image type: " + fileName);
        }
        return saveFileRecord(part, userId, noteId, "images", uploadRoot);
    }

    public Attachment saveAttachment(Part part, Long userId, Long noteId, String uploadRoot) {
        return saveFileRecord(part, userId, noteId, "attachments", uploadRoot);
    }

    public List<Attachment> getAttachments(Long noteId) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            AttachmentMapper attachmentMapper = session.getMapper(AttachmentMapper.class);
            return attachmentMapper.selectByNoteId(noteId);
        } finally {
            session.close();
        }
    }

    private Attachment saveFileRecord(Part part, Long userId, Long noteId,
                                      String subDir, String uploadRoot) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            String savedPath = FileUtil.saveFile(part, userId, subDir, uploadRoot);

            Attachment attachment = new Attachment();
            attachment.setNoteId(noteId);
            attachment.setUserId(userId);
            attachment.setFileName(FileUtil.getFileName(part));
            attachment.setFilePath(savedPath);
            attachment.setFileSize(part.getSize());
            attachment.setFileType(part.getContentType());
            attachment.setCreatedAt(new Date());

            AttachmentMapper attachmentMapper = session.getMapper(AttachmentMapper.class);
            attachmentMapper.insert(attachment);
            session.commit();
            return attachment;
        } catch (IOException e) {
            session.rollback();
            throw new RuntimeException("Failed to save file", e);
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }
}
