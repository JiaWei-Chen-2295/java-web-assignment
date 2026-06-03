package fun.javierchen.noteapp.mapper;

import fun.javierchen.noteapp.model.entity.Note;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface NoteMapper {

    Note selectById(Long id);

    List<Note> selectByUserId(Long userId);

    List<Note> selectByFolderId(@Param("userId") Long userId, @Param("folderId") Long folderId);

    List<Note> selectFavorites(Long userId);

    List<Note> selectPinned(Long userId);

    List<Note> selectRecent(@Param("userId") Long userId, @Param("limit") int limit);

    List<Note> searchByTitle(@Param("userId") Long userId, @Param("keyword") String keyword);

    Note selectByTitle(@Param("userId") Long userId, @Param("title") String title);

    int insert(Note note);

    int update(Note note);

    int updateContent(@Param("id") Long id, @Param("title") String title,
                      @Param("content") String content, @Param("summary") String summary,
                      @Param("wordCount") int wordCount);

    int togglePin(@Param("id") Long id, @Param("isPinned") boolean isPinned);

    int toggleFavorite(@Param("id") Long id, @Param("isFavorite") boolean isFavorite);

    int moveToFolder(@Param("id") Long id, @Param("folderId") Long folderId);

    int incrementViewCount(Long id);

    int deleteById(Long id);

    int countByUserId(Long userId);

    int countByFolderId(Long folderId);
}
