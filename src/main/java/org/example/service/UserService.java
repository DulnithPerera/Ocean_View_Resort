package org.example.service;

import org.example.dao.UserDao;
import org.example.model.User;
import org.example.util.PasswordUtil;

import java.util.List;

public class UserService {

    private final UserDao userDao = new UserDao();

    public List<User> getAllUsers() {
        return userDao.getAll();
    }

    public User getUserById(int userId) {
        return userDao.getById(userId);
    }

    public boolean addUser(String username, String password, String fullName, String email, String role) {
        if (userDao.getByUsername(username) != null) {
            return false;
        }
        User user = new User();
        user.setUsername(username);
        user.setPasswordHash(PasswordUtil.hashPassword(password));
        user.setFullName(fullName);
        user.setEmail(email);
        user.setRole(role);
        return userDao.add(user);
    }

    public boolean updateUser(User user) {
        return userDao.update(user);
    }

    public boolean updatePassword(int userId, String newPassword) {
        String hash = PasswordUtil.hashPassword(newPassword);
        return userDao.updatePassword(userId, hash);
    }


    public boolean deleteUser(int userId) {
        return userDao.delete(userId);
    }

    public int getActiveUserCount() {
        return userDao.getActiveUserCount();
    }
}
