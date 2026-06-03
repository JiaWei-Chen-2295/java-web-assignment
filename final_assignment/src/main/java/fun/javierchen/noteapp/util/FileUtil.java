package fun.javierchen.noteapp.util;

import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * 文件上传工具
 */
public class FileUtil {

    private static final String UPLOAD_BASE = "uploads";
    private static final DateTimeFormatter DATE_FMT = DateTimeFormatter.ofPattern("yyyyMMdd");

    /**
     * 保存上传文件到指定用户目录
     *
     * @param part       上传的文件
     * @param userId     用户 ID
     * @param subDir     子目录（images / attachments）
     * @param uploadRoot 上传根目录（磁盘绝对路径）
     * @return 相对访问路径（如 /uploads/1/images/20260602_xxx.jpg）
     */
    public static String saveFile(Part part, long userId, String subDir, String uploadRoot) throws IOException {
        String originalName = getFileName(part);
        String ext = getExtension(originalName);
        String newName = DATE_FMT.format(LocalDate.now()) + "_" + UUID.randomUUID().toString().replace("-", "").substring(0, 8) + ext;

        String relativePath = UPLOAD_BASE + File.separator + userId + File.separator + subDir;
        File dir = new File(uploadRoot, relativePath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        File target = new File(dir, newName);
        part.write(target.getAbsolutePath());

        // 返回 URL 访问路径（正斜杠）
        return "/" + UPLOAD_BASE + "/" + userId + "/" + subDir + "/" + newName;
    }

    /**
     * 获取上传文件名
     */
    public static String getFileName(Part part) {
        String cd = part.getHeader("Content-Disposition");
        if (cd != null) {
            for (String token : cd.split(";")) {
                if (token.trim().startsWith("filename")) {
                    return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                }
            }
        }
        return "unknown";
    }

    /**
     * 获取文件扩展名（含点号）
     */
    public static String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return dot >= 0 ? fileName.substring(dot) : "";
    }

    /**
     * 判断是否为允许的图片类型
     */
    public static boolean isAllowedImage(String fileName) {
        String ext = getExtension(fileName).toLowerCase();
        return ext.equals(".jpg") || ext.equals(".jpeg") || ext.equals(".png")
                || ext.equals(".gif") || ext.equals(".webp") || ext.equals(".svg");
    }
}
