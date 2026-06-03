package fun.javierchen.noteapp.model.entity;

import java.util.Date;
import java.util.List;

public class Folder {

    private Long id;
    private Long userId;
    private Long parentId;
    private String name;
    private String icon;
    private Integer sortOrder;
    private Date createdAt;
    private Date updatedAt;

    // Transient: child folders (not mapped by MyBatis)
    private transient List<Folder> children;
    // Transient: note count in this folder
    private transient int noteCount;

    public Folder() {}

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getUserId() { return userId; }
    public void setUserId(Long userId) { this.userId = userId; }

    public Long getParentId() { return parentId; }
    public void setParentId(Long parentId) { this.parentId = parentId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getIcon() { return icon; }
    public void setIcon(String icon) { this.icon = icon; }

    public Integer getSortOrder() { return sortOrder; }
    public void setSortOrder(Integer sortOrder) { this.sortOrder = sortOrder; }

    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }

    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }

    public List<Folder> getChildren() { return children; }
    public void setChildren(List<Folder> children) { this.children = children; }

    public int getNoteCount() { return noteCount; }
    public void setNoteCount(int noteCount) { this.noteCount = noteCount; }
}
