package fun.javierchen.noteapp.util;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

/**
 * Editor.js JSON 与纯文本提取（含 List v2 嵌套结构）
 */
public final class EditorContentHelper {

    private EditorContentHelper() {}

    public static boolean isEditorJsJson(String content) {
        if (content == null || content.isBlank()) {
            return false;
        }
        String trimmed = content.trim();
        if (!trimmed.startsWith("{")) {
            return false;
        }
        try {
            JsonObject root = JsonParser.parseString(trimmed).getAsJsonObject();
            return root.has("blocks") && root.get("blocks").isJsonArray();
        } catch (Exception e) {
            return false;
        }
    }

    public static String extractPlainText(String content, String contentFormat) {
        if (content == null || content.isEmpty()) {
            return "";
        }
        if ("editorjs".equalsIgnoreCase(contentFormat) || isEditorJsJson(content)) {
            return extractFromEditorJs(content);
        }
        return stripMarkdown(content);
    }

    private static String extractFromEditorJs(String json) {
        StringBuilder sb = new StringBuilder();
        try {
            JsonObject root = JsonParser.parseString(json.trim()).getAsJsonObject();
            JsonArray blocks = root.getAsJsonArray("blocks");
            if (blocks == null) {
                return "";
            }
            for (JsonElement el : blocks) {
                if (!el.isJsonObject()) {
                    continue;
                }
                JsonObject block = el.getAsJsonObject();
                String type = block.has("type") ? block.get("type").getAsString() : "";
                JsonObject data = block.has("data") && block.get("data").isJsonObject()
                        ? block.get("data").getAsJsonObject() : null;
                if (data == null) {
                    continue;
                }
                switch (type) {
                    case "header":
                    case "paragraph":
                    case "quote":
                        appendIfPresent(sb, data, "text");
                        break;
                    case "code":
                        appendIfPresent(sb, data, "code");
                        break;
                    case "list":
                        appendListItemsV2(sb, data);
                        break;
                    case "checklist":
                        appendChecklistItems(sb, data);
                        break;
                    default:
                        appendIfPresent(sb, data, "text");
                        break;
                }
                sb.append(' ');
            }
        } catch (Exception e) {
            return json;
        }
        return sb.toString().trim();
    }

    private static void appendIfPresent(StringBuilder sb, JsonObject data, String key) {
        if (data.has(key) && !data.get(key).isJsonNull()) {
            sb.append(stripHtml(data.get(key).getAsString())).append(' ');
        }
    }

    /** List v1：items 为字符串数组 */
    private static void appendListItemsV1(StringBuilder sb, JsonArray items) {
        for (JsonElement item : items) {
            if (item.isJsonPrimitive()) {
                sb.append(stripHtml(item.getAsString())).append(' ');
            }
        }
    }

    /** List v2：items 为 { content, meta, items[] }，兼容 v1 字符串 */
    private static void appendListItemsV2(StringBuilder sb, JsonObject data) {
        if (!data.has("items") || !data.get("items").isJsonArray()) {
            return;
        }
        JsonArray items = data.getAsJsonArray("items");
        if (items.isEmpty()) {
            return;
        }
        JsonElement first = items.get(0);
        if (first.isJsonPrimitive()) {
            appendListItemsV1(sb, items);
            return;
        }
        appendListItemsRecursive(sb, items);
    }

    private static void appendListItemsRecursive(StringBuilder sb, JsonArray items) {
        for (JsonElement el : items) {
            if (!el.isJsonObject()) {
                continue;
            }
            JsonObject item = el.getAsJsonObject();
            if (item.has("content") && !item.get("content").isJsonNull()) {
                sb.append(stripHtml(item.get("content").getAsString())).append(' ');
            } else if (item.has("text") && !item.get("text").isJsonNull()) {
                sb.append(stripHtml(item.get("text").getAsString())).append(' ');
            }
            if (item.has("items") && item.get("items").isJsonArray()) {
                appendListItemsRecursive(sb, item.getAsJsonArray("items"));
            }
        }
    }

    private static void appendChecklistItems(StringBuilder sb, JsonObject data) {
        if (!data.has("items") || !data.get("items").isJsonArray()) {
            return;
        }
        for (JsonElement item : data.getAsJsonArray("items")) {
            if (item.isJsonObject()) {
                JsonObject obj = item.getAsJsonObject();
                if (obj.has("text")) {
                    sb.append(stripHtml(obj.get("text").getAsString())).append(' ');
                } else if (obj.has("content")) {
                    sb.append(stripHtml(obj.get("content").getAsString())).append(' ');
                }
            }
        }
    }

    private static String stripHtml(String text) {
        if (text == null) {
            return "";
        }
        return text.replaceAll("<[^>]+>", " ");
    }

    private static String stripMarkdown(String content) {
        return content.replaceAll("[#*`\\[\\]>~_-]", "")
                .replaceAll("\\n+", " ")
                .trim();
    }
}
