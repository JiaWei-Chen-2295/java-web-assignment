package fun.javierchen.noteapp.service;

import fun.javierchen.noteapp.mapper.LinkMapper;
import fun.javierchen.noteapp.mapper.NoteMapper;
import fun.javierchen.noteapp.model.dto.BacklinkDTO;
import fun.javierchen.noteapp.model.dto.ForwardLinkDTO;
import fun.javierchen.noteapp.model.entity.Note;
import fun.javierchen.noteapp.util.DBUtil;
import fun.javierchen.noteapp.util.EditorContentHelper;
import fun.javierchen.noteapp.util.LinkParser;
import fun.javierchen.noteapp.util.WikiLinkRef;
import org.apache.ibatis.session.SqlSession;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

public class LinkService {

    public void updateLinks(SqlSession session, Long noteId, String content) {
        updateLinks(session, noteId, content, null);
    }

    /**
     * 根据正文中的维基链接更新 note_links（优先按 ID 解析，其次按标题）
     */
    public void updateLinks(SqlSession session, Long noteId, String content, String contentFormat) {
        LinkMapper linkMapper = session.getMapper(LinkMapper.class);
        NoteMapper noteMapper = session.getMapper(NoteMapper.class);

        linkMapper.deleteBySourceId(noteId);

        List<WikiLinkRef> refs = LinkParser.extractLinkRefs(content, contentFormat);
        if (refs.isEmpty()) {
            return;
        }

        Note sourceNote = noteMapper.selectById(noteId);
        if (sourceNote == null) {
            return;
        }
        Long userId = sourceNote.getUserId();
        Set<Long> inserted = new LinkedHashSet<>();

        for (WikiLinkRef ref : refs) {
            Note target = resolveTarget(noteMapper, userId, noteId, ref);
            if (target != null && inserted.add(target.getId())) {
                linkMapper.insertLink(noteId, target.getId());
            }
        }
    }

    /**
     * 目标笔记标题变更时，同步更新所有引用该笔记的源文档正文中的 [[...]] 文本
     */
    public void syncReferrersTitle(SqlSession session, long targetNoteId, Long userId,
                                   String oldTitle, String newTitle) {
        if (newTitle == null || newTitle.isBlank()) {
            return;
        }
        if (oldTitle != null && oldTitle.trim().equals(newTitle.trim())) {
            return;
        }

        LinkMapper linkMapper = session.getMapper(LinkMapper.class);
        NoteMapper noteMapper = session.getMapper(NoteMapper.class);
        List<BacklinkDTO> backlinks = linkMapper.selectBacklinks(targetNoteId);

        for (BacklinkDTO backlink : backlinks) {
            Note source = noteMapper.selectById(backlink.getSourceId());
            if (source == null || !userId.equals(source.getUserId())) {
                continue;
            }
            String format = source.getContentFormat() != null ? source.getContentFormat() : "editorjs";
            String updated = LinkParser.replaceTargetNoteTitleInContent(
                    source.getContent(), format, targetNoteId, oldTitle, newTitle);

            if (updated.equals(source.getContent())) {
                continue;
            }

            source.setContent(updated);
            String plain = EditorContentHelper.extractPlainText(updated, format);
            source.setSummary(buildSummary(plain));
            source.setWordCount(countWords(plain));
            noteMapper.update(source);
            updateLinks(session, source.getId(), updated, format);
        }
    }

    private Note resolveTarget(NoteMapper noteMapper, Long userId, Long sourceNoteId, WikiLinkRef ref) {
        if (ref.hasTargetId()) {
            Note byId = noteMapper.selectById(ref.getTargetId());
            if (byId != null && userId.equals(byId.getUserId()) && !byId.getId().equals(sourceNoteId)) {
                return byId;
            }
        }
        if (ref.getTitle() != null && !ref.getTitle().isEmpty()) {
            Note byTitle = noteMapper.selectByTitle(userId, ref.getTitle());
            if (byTitle != null && !byTitle.getId().equals(sourceNoteId)) {
                return byTitle;
            }
        }
        return null;
    }

    public List<BacklinkDTO> getBacklinks(Long noteId) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(LinkMapper.class).selectBacklinks(noteId);
        } finally {
            session.close();
        }
    }

    public List<ForwardLinkDTO> getForwardLinks(Long noteId) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(LinkMapper.class).selectForwardLinks(noteId);
        } finally {
            session.close();
        }
    }

    private static String buildSummary(String plain) {
        if (plain == null || plain.isEmpty()) {
            return "";
        }
        String text = plain.replaceAll("\\s+", " ").trim();
        return text.length() > 200 ? text.substring(0, 200) + "..." : text;
    }

    private static int countWords(String plain) {
        if (plain == null || plain.isEmpty()) {
            return 0;
        }
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
