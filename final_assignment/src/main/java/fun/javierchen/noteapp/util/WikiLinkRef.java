package fun.javierchen.noteapp.util;

/**
 * 正文中的维基链接引用（标题 + 可选的稳定笔记 ID）
 */
public class WikiLinkRef {

    private final String title;
    private final Long targetId;

    public WikiLinkRef(String title, Long targetId) {
        this.title = title != null ? title.trim() : "";
        this.targetId = targetId;
    }

    public String getTitle() {
        return title;
    }

    public Long getTargetId() {
        return targetId;
    }

    public boolean hasTargetId() {
        return targetId != null && targetId > 0;
    }

    /** 规范存储格式：[[标题#id]] */
    public String toCanonicalBracket(String resolvedTitle) {
        String label = (resolvedTitle != null && !resolvedTitle.isBlank()) ? resolvedTitle.trim() : title;
        if (targetId != null && targetId > 0) {
            return "[[" + label + "#" + targetId + "]]";
        }
        return "[[" + label + "]]";
    }

    @Override
    public String toString() {
        return "WikiLinkRef{title='" + title + "', targetId=" + targetId + '}';
    }
}
