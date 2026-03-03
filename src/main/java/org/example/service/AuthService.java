package org.example.service;

import org.example.dao.UserDao;
import org.example.model.User;
import org.example.util.PasswordUtil;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthService {

    private final UserDao userDao = new UserDao();

    public User login(String username, String password) {
        String passwordHash = PasswordUtil.hashPassword(password);
        return userDao.authenticate(username, passwordHash);
    }

    public void createSession(HttpServletRequest request, User user, boolean rememberMe, HttpServletResponse response) {
        HttpSession session = request.getSession(true);
        session.setAttribute("user", user);
        session.setAttribute("userId", user.getUserId());
        session.setAttribute("username", user.getUsername());
        session.setAttribute("fullName", user.getFullName());
        session.setAttribute("role", user.getRole());
        session.setMaxInactiveInterval(30 * 60);

        if (rememberMe) {
            Cookie userCookie = new Cookie("remember_user", user.getUsername());
            userCookie.setMaxAge(7 * 24 * 60 * 60);
            userCookie.setPath("/");
            response.addCookie(userCookie);
        }
    }

    public void logout(HttpServletRequest request, HttpServletResponse response) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        Cookie userCookie = new Cookie("remember_user", "");
        userCookie.setMaxAge(0);
        userCookie.setPath("/");
        response.addCookie(userCookie);
    }

    public User getCurrentUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            return (User) session.getAttribute("user");
        }
        return null;
    }

    public boolean isLoggedIn(HttpServletRequest request) {
        return getCurrentUser(request) != null;
    }

    public boolean isAdmin(HttpServletRequest request) {
        User user = getCurrentUser(request);
        return user != null && user.isAdmin();
    }

    public String getRememberedUsername(HttpServletRequest request) {
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("remember_user".equals(cookie.getName())) {
                    return cookie.getValue();
                }
            }
        }
        return null;
    }
}
