package fun.javierchen.noteapp.util;

import at.favre.lib.crypto.bcrypt.BCrypt;

/**
 * 密码加密工具（BCrypt）
 */
public class PasswordUtil {

    private static final int COST = 10;

    /**
     * 加密密码
     */
    public static String hash(String plainPassword) {
        return BCrypt.withDefaults().hashToString(COST, plainPassword.toCharArray());
    }

    /**
     * 验证密码
     */
    public static boolean verify(String plainPassword, String hashedPassword) {
        BCrypt.Result result = BCrypt.verifyer()
                .verify(plainPassword.toCharArray(), hashedPassword);
        return result.verified;
    }
}
