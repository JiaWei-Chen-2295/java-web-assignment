package fun.javierchen.noteapp.model.entity;

import java.util.Date;

public class Tag {

    private Long id;
    private Long userId;
    private String name;
    private String color;
    private Date createdAt;

    public Tag() {
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getColor() {
        return color;
    }

    public void setColor(String color) {
        this.color = color;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Tag{" +
                "id=" + id +
                ", userId=" + userId +
                ", name='" + name + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
