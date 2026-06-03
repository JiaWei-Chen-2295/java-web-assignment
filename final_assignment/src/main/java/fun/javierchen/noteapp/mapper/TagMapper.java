package fun.javierchen.noteapp.mapper;

import fun.javierchen.noteapp.model.entity.Tag;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface TagMapper {

    List<Tag> selectByUserId(Long userId);

    Tag selectById(Long id);

    int insert(Tag tag);

    int deleteById(Long id);

    int insertNoteTag(@Param("noteId") Long noteId, @Param("tagId") Long tagId);

    int deleteNoteTag(@Param("noteId") Long noteId, @Param("tagId") Long tagId);

    int deleteNoteTagsByNoteId(Long noteId);

    List<Tag> selectByNoteId(Long noteId);
}
