package fun.javierchen.ch19.entity;

import java.sql.Timestamp;

/**
 * 用户实体类 - 对应 users 表
 */
public class User {

    private int id;
    private String name;
    private String email;
    private Integer age;       // 可为 null
    private Timestamp created; // 数据库自动生成

    // ---- 无参构造 ----
    public User() {}

    // ---- 全参构造（不含 id 和 created，插入时使用）----
    public User(String name, String email, Integer age) {
        this.name = name;
        this.email = email;
        this.age = age;
    }

    // ---- 全参构造（含 id 和 created，查询时使用）----
    public User(int id, String name, String email, Integer age, Timestamp created) {
        this.id = id;
        this.name = name;
        this.email = email;
        this.age = age;
        this.created = created;
    }

    // ---- Getter / Setter ----

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public Integer getAge() { return age; }
    public void setAge(Integer age) { this.age = age; }

    public Timestamp getCreated() { return created; }
    public void setCreated(Timestamp created) { this.created = created; }

    @Override
    public String toString() {
        return "User{id=" + id + ", name='" + name + "', email='" + email + "', age=" + age + ", created=" + created + "}";
    }
}
