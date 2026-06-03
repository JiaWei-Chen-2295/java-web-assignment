package fun.javierchen.noteapp.mapper;

import fun.javierchen.noteapp.model.entity.User;

public interface UserMapper {

    User selectByUsername(String username);

    User selectByEmail(String email);

    User selectById(Long id);

    int insert(User user);

    int update(User user);
}
