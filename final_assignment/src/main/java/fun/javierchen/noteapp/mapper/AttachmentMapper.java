package fun.javierchen.noteapp.mapper;

import fun.javierchen.noteapp.model.entity.Attachment;

import java.util.List;

public interface AttachmentMapper {

    int insert(Attachment attachment);

    List<Attachment> selectByNoteId(Long noteId);

    int deleteById(Long id);
}
