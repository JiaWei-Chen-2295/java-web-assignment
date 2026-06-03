package fun.javierchen.noteapp.mapper;

import fun.javierchen.noteapp.model.entity.Folder;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FolderMapper {

    Folder selectById(Long id);

    List<Folder> selectByUserId(Long userId);

    List<Folder> selectByParentId(@Param("userId") Long userId, @Param("parentId") Long parentId);

    List<Folder> selectRootFolders(Long userId);

    int insert(Folder folder);

    int update(Folder folder);

    int deleteById(Long id);

    int updateSortOrder(@Param("id") Long id, @Param("sortOrder") int sortOrder);

    int countNotesInFolder(Long folderId);
}
