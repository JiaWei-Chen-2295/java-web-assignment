package fun.javierchen.noteapp.util;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import fun.javierchen.noteapp.mapper.NoteMapper;
import fun.javierchen.noteapp.model.entity.Note;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.function.Function;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 双向链接：[[标题]]、[[标题#id]]、[[#id]]
 */
public final class LinkParser {

    /** [[标题#12]] 或 [[标题|12]] */
    private static final Pattern TITLE_WITH_ID = Pattern.compile("\\[\\[([^#\\]|\\]]+?)(?:#|\\|)(\\d+)]]");
    /** [[#12]] */
    private static final Pattern ID_ONLY = Pattern.compile("\\[\\[#(\\d+)]]");
    /** [[标题]]（不含 # / |） */
    private static final Pattern TITLE_ONLY = Pattern.compile("\\[\\[(?!#)([^#\\]|\\]]+?)]]");
    private static final Pattern WIKI_LINK_HTML = Pattern.compile(
            "class=\"wiki-link\"[^>]*data-note-id=\"(\\d+)\"[^>]*data-note-title=\"([^\"]*)\"|"
                    + "class=\"wiki-link\"[^>]*data-note-title=\"([^\"]*)\"[^>]*data-note-id=\"(\\d+)\"",
            Pattern.CASE_INSENSITIVE);

    private LinkParser() {}

    public static List<String> extractLinkTitles(String content) {
        List<String> titles = new ArrayList<>();
        for (WikiLinkRef ref : extractLinkRefs(content, null)) {
            if (!ref.getTitle().isEmpty()) {
                titles.add(ref.getTitle());
            }
        }
        return titles;
    }

    public static List<String> extractLinkTitles(String content, String contentFormat) {
        List<String> titles = new ArrayList<>();
        for (WikiLinkRef ref : extractLinkRefs(content, contentFormat)) {
            if (!ref.getTitle().isEmpty()) {
                titles.add(ref.getTitle());
            }
        }
        return titles;
    }

    /**
     * 提取去重后的引用（同一 targetId 只保留一条）
     */
    public static List<WikiLinkRef> extractLinkRefs(String content, String contentFormat) {
        Map<String, WikiLinkRef> ordered = new LinkedHashMap<>();
        if (content == null || content.isEmpty()) {
            return new ArrayList<>();
        }
        if ("editorjs".equalsIgnoreCase(contentFormat) || EditorContentHelper.isEditorJsJson(content)) {
            extractFromEditorJs(content, ordered);
        } else {
            collectFromText(content, ordered);
        }
        return new ArrayList<>(ordered.values());
    }

    /**
     * 保存前规范化：能解析到的链接一律写成 [[当前标题#id]]
     */
    public static String normalizeWikiLinksInContent(String content, String contentFormat, Long userId, NoteMapper noteMapper) {
        if (content == null || content.isEmpty() || userId == null || noteMapper == null) {
            return content;
        }
        Function<String, String> replacer = text -> normalizeTextWikiLinks(text, userId, noteMapper);
        if ("editorjs".equalsIgnoreCase(contentFormat) || EditorContentHelper.isEditorJsJson(content)) {
            return transformEditorJs(content, replacer);
        }
        return replacer.apply(content);
    }

    /**
     * 某笔记改名后，更新所有引用该笔记的源文档正文
     */
    public static String replaceTargetNoteTitleInContent(
            String content, String contentFormat, long targetNoteId, String oldTitle, String newTitle) {
        if (content == null || content.isEmpty()) {
            return content;
        }
        String safeOld = oldTitle != null ? oldTitle.trim() : "";
        String safeNew = newTitle != null ? newTitle.trim() : "";
        Function<String, String> replacer = text -> replaceTargetInText(text, targetNoteId, safeOld, safeNew);
        if ("editorjs".equalsIgnoreCase(contentFormat) || EditorContentHelper.isEditorJsJson(content)) {
            return transformEditorJs(content, replacer);
        }
        return replacer.apply(content);
    }

    private static String normalizeTextWikiLinks(String text, Long userId, NoteMapper noteMapper) {
        if (text == null || text.isEmpty()) {
            return text;
        }
        String result = text;
        result = replaceAllRefs(result, TITLE_WITH_ID, m -> {
            long id = Long.parseLong(m.group(2));
            Note note = loadOwnedNote(noteMapper, userId, id);
            return note != null ? "[[" + note.getTitle() + "#" + id + "]]" : m.group(0);
        });
        result = replaceAllRefs(result, ID_ONLY, m -> {
            long id = Long.parseLong(m.group(1));
            Note note = loadOwnedNote(noteMapper, userId, id);
            return note != null ? "[[" + note.getTitle() + "#" + id + "]]" : m.group(0);
        });
        result = replaceAllRefs(result, TITLE_ONLY, m -> {
            String title = m.group(1).trim();
            Note note = noteMapper.selectByTitle(userId, title);
            return note != null ? "[[" + note.getTitle() + "#" + note.getId() + "]]" : m.group(0);
        });
        return result;
    }

    private static String replaceTargetInText(String text, long targetNoteId, String oldTitle, String newTitle) {
        if (text == null || text.isEmpty()) {
            return text;
        }
        String id = String.valueOf(targetNoteId);
        String result = text;

        // [[任意标题#id]] / [[任意|id]]
        result = result.replaceAll(
                "\\[\\[[^#\\]|\\]]+?(?:#|\\|)" + id + "]]",
                "[[" + newTitle + "#" + id + "]]");
        // [[#id]]
        result = result.replaceAll(
                "\\[\\[#" + id + "]]",
                "[[" + newTitle + "#" + id + "]]");

        if (!oldTitle.isEmpty()) {
            result = result.replace("[[" + oldTitle + "]]", "[[" + newTitle + "#" + id + "]]");
        }
        return result;
    }

    private static String replaceAllRefs(String text, Pattern pattern, Function<Matcher, String> replacement) {
        Matcher matcher = pattern.matcher(text);
        StringBuffer sb = new StringBuffer();
        while (matcher.find()) {
            matcher.appendReplacement(sb, Matcher.quoteReplacement(replacement.apply(matcher)));
        }
        matcher.appendTail(sb);
        return sb.toString();
    }

    private static Note loadOwnedNote(NoteMapper noteMapper, Long userId, long id) {
        Note note = noteMapper.selectById(id);
        if (note == null || !userId.equals(note.getUserId())) {
            return null;
        }
        return note;
    }

    private static void extractFromEditorJs(String json, Map<String, WikiLinkRef> ordered) {
        try {
            JsonObject root = JsonParser.parseString(json.trim()).getAsJsonObject();
            JsonArray blocks = root.getAsJsonArray("blocks");
            if (blocks == null) {
                collectFromText(json, ordered);
                return;
            }
            for (JsonElement el : blocks) {
                if (!el.isJsonObject()) continue;
                JsonObject block = el.getAsJsonObject();
                String type = block.has("type") ? block.get("type").getAsString() : "";
                JsonObject data = block.has("data") && block.get("data").isJsonObject()
                        ? block.get("data").getAsJsonObject() : null;
                if (data == null) continue;
                switch (type) {
                    case "header":
                    case "paragraph":
                    case "quote":
                        if (data.has("text")) collectFromText(data.get("text").getAsString(), ordered);
                        break;
                    case "list":
                        collectListItems(data.getAsJsonArray("items"), ordered);
                        break;
                    case "checklist":
                        if (data.has("items") && data.get("items").isJsonArray()) {
                            for (JsonElement item : data.getAsJsonArray("items")) {
                                if (item.isJsonObject() && item.getAsJsonObject().has("text")) {
                                    collectFromText(item.getAsJsonObject().get("text").getAsString(), ordered);
                                }
                            }
                        }
                        break;
                    default:
                        if (data.has("text")) collectFromText(data.get("text").getAsString(), ordered);
                        break;
                }
            }
        } catch (Exception e) {
            collectFromText(json, ordered);
        }
    }

    private static String transformEditorJs(String json, Function<String, String> textTransform) {
        try {
            JsonObject root = JsonParser.parseString(json.trim()).getAsJsonObject();
            JsonArray blocks = root.getAsJsonArray("blocks");
            if (blocks == null) {
                return json;
            }
            for (JsonElement el : blocks) {
                if (!el.isJsonObject()) continue;
                JsonObject block = el.getAsJsonObject();
                String type = block.has("type") ? block.get("type").getAsString() : "";
                JsonObject data = block.has("data") && block.get("data").isJsonObject()
                        ? block.get("data").getAsJsonObject() : null;
                if (data == null) continue;
                switch (type) {
                    case "header":
                    case "paragraph":
                    case "quote":
                        transformField(data, "text", textTransform);
                        break;
                    case "list":
                        transformListItems(data.getAsJsonArray("items"), textTransform);
                        break;
                    case "checklist":
                        if (data.has("items") && data.get("items").isJsonArray()) {
                            for (JsonElement item : data.getAsJsonArray("items")) {
                                if (item.isJsonObject()) {
                                    transformField(item.getAsJsonObject(), "text", textTransform);
                                }
                            }
                        }
                        break;
                    default:
                        transformField(data, "text", textTransform);
                        break;
                }
            }
            return root.toString();
        } catch (Exception e) {
            return textTransform.apply(json);
        }
    }

    private static void transformField(JsonObject data, String key, Function<String, String> textTransform) {
        if (data.has(key) && !data.get(key).isJsonNull()) {
            String raw = data.get(key).getAsString();
            data.addProperty(key, textTransform.apply(raw));
        }
    }

    private static void transformListItems(JsonArray items, Function<String, String> textTransform) {
        if (items == null) return;
        for (JsonElement el : items) {
            if (el.isJsonPrimitive()) {
                String updated = textTransform.apply(el.getAsString());
                // JsonPrimitive is immutable in gson tree - need replace via parent; skip string items
            } else if (el.isJsonObject()) {
                JsonObject item = el.getAsJsonObject();
                transformField(item, "content", textTransform);
                if (item.has("items") && item.get("items").isJsonArray()) {
                    transformListItems(item.getAsJsonArray("items"), textTransform);
                }
            }
        }
    }

    private static void collectListItems(JsonArray items, Map<String, WikiLinkRef> ordered) {
        if (items == null) return;
        for (JsonElement el : items) {
            if (el.isJsonPrimitive()) {
                collectFromText(el.getAsString(), ordered);
            } else if (el.isJsonObject()) {
                JsonObject item = el.getAsJsonObject();
                if (item.has("content")) {
                    collectFromText(item.get("content").getAsString(), ordered);
                }
                if (item.has("items") && item.get("items").isJsonArray()) {
                    collectListItems(item.getAsJsonArray("items"), ordered);
                }
            }
        }
    }

    private static void collectFromText(String text, Map<String, WikiLinkRef> ordered) {
        if (text == null || text.isEmpty()) return;

        Matcher idTitle = TITLE_WITH_ID.matcher(text);
        while (idTitle.find()) {
            addRef(ordered, idTitle.group(1).trim(), Long.parseLong(idTitle.group(2)));
        }
        Matcher idOnly = ID_ONLY.matcher(text);
        while (idOnly.find()) {
            addRef(ordered, "", Long.parseLong(idOnly.group(1)));
        }
        Matcher titleOnly = TITLE_ONLY.matcher(text);
        while (titleOnly.find()) {
            addRef(ordered, titleOnly.group(1).trim(), null);
        }

        Matcher html = WIKI_LINK_HTML.matcher(text);
        while (html.find()) {
            String idStr = html.group(1) != null ? html.group(1) : html.group(4);
            String title = html.group(2) != null ? html.group(2) : html.group(3);
            if (idStr != null) {
                addRef(ordered, title != null ? title.trim() : "", Long.parseLong(idStr));
            }
        }
    }

    private static void addRef(Map<String, WikiLinkRef> ordered, String title, Long targetId) {
        String key = targetId != null ? "id:" + targetId : "t:" + title;
        WikiLinkRef existing = ordered.get(key);
        if (existing == null) {
            ordered.put(key, new WikiLinkRef(title, targetId));
            return;
        }
        if (existing.getTitle().isEmpty() && title != null && !title.isEmpty()) {
            ordered.put(key, new WikiLinkRef(title, targetId != null ? targetId : existing.getTargetId()));
        }
    }

    public static String toHtml(String content) {
        if (content == null || content.isEmpty()) {
            return content;
        }
        String result = content;
        result = replaceAllRefs(result, TITLE_WITH_ID, m ->
                wikiAnchor(m.group(1).trim(), Long.parseLong(m.group(2))));
        result = replaceAllRefs(result, ID_ONLY, m ->
                wikiAnchor("", Long.parseLong(m.group(1))));
        result = replaceAllRefs(result, TITLE_ONLY, m ->
                wikiAnchor(m.group(1).trim(), null));
        return result;
    }

    private static String wikiAnchor(String title, Long id) {
        String label = title != null && !title.isEmpty() ? title : (id != null ? "笔记#" + id : "");
        StringBuilder sb = new StringBuilder("<a class=\"wiki-link\" href=\"#\"");
        if (id != null) {
            sb.append(" data-note-id=\"").append(id).append("\"");
        }
        sb.append(" data-note-title=\"").append(escapeAttr(label)).append("\">");
        sb.append(escapeHtml(label));
        sb.append("</a>");
        return sb.toString();
    }

    private static String escapeAttr(String s) {
        return s.replace("&", "&amp;").replace("\"", "&quot;").replace("<", "&lt;");
    }

    private static String escapeHtml(String s) {
        return escapeAttr(s);
    }
}
