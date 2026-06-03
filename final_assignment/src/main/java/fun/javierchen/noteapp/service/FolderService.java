package fun.javierchen.noteapp.service;

import fun.javierchen.noteapp.mapper.FolderMapper;
import fun.javierchen.noteapp.mapper.NoteMapper;
import fun.javierchen.noteapp.model.entity.Folder;
import fun.javierchen.noteapp.util.DBUtil;
import org.apache.ibatis.session.SqlSession;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FolderService {

    public Folder createFolder(Long userId, String name, Long parentId, String icon) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            FolderMapper mapper = session.getMapper(FolderMapper.class);
            Folder folder = new Folder();
            folder.setUserId(userId);
            folder.setName(name);
            folder.setParentId(parentId);
            folder.setIcon(icon != null ? icon : "folder");
            folder.setSortOrder(0);
            mapper.insert(folder);
            session.commit();
            return folder;
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public Folder getFolder(Long id) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(FolderMapper.class).selectById(id);
        } finally {
            session.close();
        }
    }

    public List<Folder> getUserFolders(Long userId) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            return session.getMapper(FolderMapper.class).selectByUserId(userId);
        } finally {
            session.close();
        }
    }

    /**
     * Build a tree structure from flat folder list.
     */
    public List<Folder> getFolderTree(Long userId) {
        SqlSession session = DBUtil.getAutoCommitSqlSession();
        try {
            FolderMapper mapper = session.getMapper(FolderMapper.class);
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);
            List<Folder> allFolders = mapper.selectByUserId(userId);

            // Count notes per folder
            Map<Long, Integer> noteCountMap = new HashMap<>();
            for (Folder f : allFolders) {
                int count = noteMapper.countByFolderId(f.getId());
                noteCountMap.put(f.getId(), count);
            }

            // Build tree
            Map<Long, Folder> folderMap = new HashMap<>();
            List<Folder> roots = new ArrayList<>();

            for (Folder f : allFolders) {
                f.setChildren(new ArrayList<>());
                f.setNoteCount(noteCountMap.getOrDefault(f.getId(), 0));
                folderMap.put(f.getId(), f);
            }

            for (Folder f : allFolders) {
                if (f.getParentId() == null) {
                    roots.add(f);
                } else {
                    Folder parent = folderMap.get(f.getParentId());
                    if (parent != null) {
                        parent.getChildren().add(f);
                    } else {
                        roots.add(f); // orphan -> treat as root
                    }
                }
            }

            return roots;
        } finally {
            session.close();
        }
    }

    public void updateFolder(Long id, Long userId, String name, String icon) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            FolderMapper mapper = session.getMapper(FolderMapper.class);
            Folder folder = mapper.selectById(id);
            if (folder == null || !folder.getUserId().equals(userId)) {
                throw new RuntimeException("Access denied");
            }
            folder.setName(name);
            if (icon != null) folder.setIcon(icon);
            mapper.update(folder);
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }

    public void deleteFolder(Long id, Long userId) {
        SqlSession session = DBUtil.getSqlSession();
        try {
            FolderMapper mapper = session.getMapper(FolderMapper.class);
            Folder folder = mapper.selectById(id);
            if (folder == null || !folder.getUserId().equals(userId)) {
                throw new RuntimeException("Access denied");
            }
            // Move notes in this folder to "no folder"
            NoteMapper noteMapper = session.getMapper(NoteMapper.class);
            List<fun.javierchen.noteapp.model.entity.Note> notes =
                noteMapper.selectByFolderId(userId, id);
            for (fun.javierchen.noteapp.model.entity.Note note : notes) {
                noteMapper.moveToFolder(note.getId(), null);
            }
            mapper.deleteById(id);
            session.commit();
        } catch (Exception e) {
            session.rollback();
            throw e;
        } finally {
            session.close();
        }
    }
}
