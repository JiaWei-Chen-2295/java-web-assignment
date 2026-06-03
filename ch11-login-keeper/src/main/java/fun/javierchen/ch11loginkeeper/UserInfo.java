package fun.javierchen.ch11loginkeeper;

public class UserInfo {
    private String username;
    private String email;
    private long loginTime;

    public UserInfo() {}

    public UserInfo(String username) {
        this.username = username;
        this.loginTime = System.currentTimeMillis();
    }

    public UserInfo(String username, String email) {
        this.username = username;
        this.email = email;
        this.loginTime = System.currentTimeMillis();
    }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public long getLoginTime() { return loginTime; }
    public void setLoginTime(long loginTime) { this.loginTime = loginTime; }
}