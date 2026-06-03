package fun.javierchen.noteapp.service;

import fun.javierchen.noteapp.mapper.LinkMapper;
import fun.javierchen.noteapp.mapper.NoteMapper;
import fun.javierchen.noteapp.mapper.TagMapper;
import fun.javierchen.noteapp.model.entity.Note;
import fun.javierchen.noteapp.util.DBUtil;
import fun.javierchen.noteapp.util.EditorContentHelper;
import fun.javierchen.noteapp.util.LinkParser;
import org.apache.ibatis.session.SqlSession;

import java.util.Date;
import java.util.List;

public class NoteService {

    private final LinkService linkService = new LinkService();

    public Note createNote(Long userId, String title, String content) {
        return createNote(userId, title, content, null, "markdown");
    }

    public Note createNote(Long userId, String title, String content, Long folderId, String contentFormat) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);

            Note note = new Note();
            note.setUserId(userId);
            note.setTitle(title);
            note.setContent(content != null ? content : "");
            note.setContentFormat(contentFormat != null ? contentFormat : "markdown");
            note.setFolderId(folderId);
            String plain = EditorContentHelper.extractPlainText(content, note.getContentFormat());
            note.setSummary(generateSummary(plain));
            note.setWordCount(countWords(plain));
            note.setCreatedAt(new Date());
            note.setUpdatedAt(new Date());

            noteMapper.insert(note);

            // parse [[links]] and update note_links within the same session
            linkService.updateLinks(session, note.getId(), content, note.getContentFormat());

            session.commit();
            return note;
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public Note updateNote(Long id, Long userId, String title, String content) {
        return updateNote(id, userId, title, content, null);
    }

    public Note updateNote(Long id, Long userId, String title, String content, String contentFormat) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);

            Note note = noteMapper.selectById(id);
            if (note == null) {
                throw new RuntimeException("Note not found: " + id);
            }
            if (!note.getUserId().equals(userId)) {
                throw new RuntimeException("Access denied: note does not belong to user");
            }

            String format = contentFormat != null && !contentFormat.isBlank()
                    ? contentFormat
                    : (note.getContentFormat() != null ? note.getContentFormat() : "editorjs");

            String oldTitle = note.getTitle();
            String newTitle = title != null ? title.trim() : oldTitle;

            // 将 [[标题]] 规范为 [[标题#id]]，便于标题变更后仍能定位
            content = LinkParser.normalizeWikiLinksInContent(content, format, userId, noteMapper);

            note.setTitle(newTitle);
            note.setContent(content);
            note.setContentFormat(format);
            String plain = EditorContentHelper.extractPlainText(content, format);
            note.setSummary(generateSummary(plain));
            note.setWordCount(countWords(plain));
            note.setUpdatedAt(new Date());

            noteMapper.update(note);

            linkService.updateLinks(session, id, content, format);

            // 标题改名 → 同步所有引用本篇的文档正文
            if (oldTitle != null && newTitle != null && !newTitle.equals(oldTitle)) {
                linkService.syncReferrersTitle(session, id, userId, oldTitle, newTitle);
            }

            session.commit();
            return note;
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void deleteNote(Long id, Long userId) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);

            Note note = noteMapper.selectById(id);
            if (note == null) {
                throw new RuntimeException("Note not found: " + id);
            }
            if (!note.getUserId().equals(userId)) {
                throw new RuntimeException("Access denied: note does not belong to user");
            }

            // Clean up related data
            LinkMapper linkMapper = session.getMapper(LinkMapper.class);
            linkMapper.deleteBySourceId(id);
            linkMapper.deleteByTargetId(id);

            TagMapper tagMapper = session.getMapper(TagMapper.class);
            tagMapper.deleteNoteTagsByNoteId(id);

            noteMapper.deleteById(id);
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public Note getNote(Long id) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);
            Note note = noteMapper.selectById(id);
            if (note != null) {
                noteMapper.incrementViewCount(id);
            }
            return note;
        } finally {
            session.close();
        }
    }

    /** 加载编辑器时规范化正文中的维基链接为 [[标题#id]] */
    public String normalizeNoteContent(Note note) {
        if (note == null || note.getContent() == null) {
            return "";
        }
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);
            String format = note.getContentFormat() != null ? note.getContentFormat() : "editorjs";
            return LinkParser.normalizeWikiLinksInContent(
                    note.getContent(), format, note.getUserId(), noteMapper);
        } finally {
            session.close();
        }
    }

    public List<Note> getUserNotes(Long userId) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(NoteMapper.class).selectByUserId(userId);
        } finally {
            session.close();
        }
    }

    public List<Note> getNotesByFolder(Long userId, Long folderId) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(NoteMapper.class).selectByFolderId(userId, folderId);
        } finally {
            session.close();
        }
    }

    public List<Note> getFavoriteNotes(Long userId) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(NoteMapper.class).selectFavorites(userId);
        } finally {
            session.close();
        }
    }

    public List<Note> getRecentNotes(Long userId, int limit) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(NoteMapper.class).selectRecent(userId, limit);
        } finally {
            session.close();
        }
    }

    public List<Note> searchNotes(Long userId, String keyword) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(NoteMapper.class).searchByTitle(userId, keyword);
        } finally {
            session.close();
        }
    }

    public void togglePin(Long id, Long userId) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);
            Note note = noteMapper.selectById(id);
            if (note == null || !note.getUserId().equals(userId)) {
                throw new RuntimeException("Access denied");
            }
            noteMapper.togglePin(id, !note.getIsPinned());
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void toggleFavorite(Long id, Long userId) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);
            Note note = noteMapper.selectById(id);
            if (note == null || !note.getUserId().equals(userId)) {
                throw new RuntimeException("Access denied");
            }
            noteMapper.toggleFavorite(id, !note.getIsFavorite());
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void moveToFolder(Long id, Long userId, Long folderId) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);
            Note note = noteMapper.selectById(id);
            if (note == null || !note.getUserId().equals(userId)) {
                throw new RuntimeException("Access denied");
            }
            noteMapper.moveToFolder(id, folderId);
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    private String generateSummary(String plain) {
        if (plain == null || plain.isEmpty()) return "";
        String text = plain.replaceAll("\\s+", " ").trim();
        return text.length() > 200 ? text.substring(0, 200) + "..." : text;
    }

    private int countWords(String plain) {
        if (plain == null || plain.isEmpty()) return 0;
        int chinese = 0;
        for (char c : plain.toCharArray()) {
            if (Character.toString(c).matches("[\\u4e00-\\u9fa5]")) {
                chinese++;
            }
        }
        String stripped = plain.replaceAll("[\\u4e00-\\u9fa5]", " ").trim();
        int english = stripped.isEmpty() ? 0 : stripped.split("\\s+").length;
        return chinese + english;
    }
}
