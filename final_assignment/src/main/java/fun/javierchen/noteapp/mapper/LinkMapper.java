package fun.javierchen.noteapp.mapper;

import fun.javierchen.noteapp.model.dto.BacklinkDTO;
import fun.javierchen.noteapp.model.dto.ForwardLinkDTO;
import fun.javierchen.noteapp.model.entity.NoteLink;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface LinkMapper {

    int insertLink(@Param("sourceId") Long sourceId, @Param("targetId") Long targetId);

    int deleteBySourceId(Long sourceId);

    int deleteByTargetId(Long targetId);

    List<BacklinkDTO> selectBacklinks(Long targetId);

    List<NoteLink> selectBySourceId(Long sourceId);

    List<ForwardLinkDTO> selectForwardLinks(Long sourceId);
}
