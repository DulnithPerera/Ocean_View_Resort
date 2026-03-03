package org.example.servlet;

import org.example.model.User;
import org.example.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class UserServlet extends HttpServlet {

    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int userId = Integer.parseInt(request.getParameter("id"));
            User user = userService.getUserById(userId);
            request.setAttribute("editUser", user);
        }

        request.setAttribute("users", userService.getAllUsers());
        request.getRequestDispatcher("/users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : "") {
            case "add":
                handleAdd(request, response);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "resetPassword":
                handleResetPassword(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/users");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String role = request.getParameter("role");

        boolean success = userService.addUser(username, password, fullName, email, role);
        if (success) {
            request.getSession().setAttribute("message", "User added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add user. Username may already exist.");
        }
        response.sendRedirect(request.getContextPath() + "/users");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = new User();
        user.setUserId(Integer.parseInt(request.getParameter("userId")));
        user.setUsername(request.getParameter("username"));
        user.setFullName(request.getParameter("fullName"));
        user.setEmail(request.getParameter("email"));
        user.setRole(request.getParameter("role"));
        user.setActive("on".equals(request.getParameter("isActive")));

        boolean success = userService.updateUser(user);
        if (success) {
            request.getSession().setAttribute("message", "User updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update user.");
        }
        response.sendRedirect(request.getContextPath() + "/users");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        boolean success = userService.deleteUser(userId);
        if (success) {
            request.getSession().setAttribute("message", "User deactivated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to deactivate user.");
        }
        response.sendRedirect(request.getContextPath() + "/users");
    }

    private void handleResetPassword(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String newPassword = request.getParameter("newPassword");
        boolean success = userService.updatePassword(userId, newPassword);
        if (success) {
            request.getSession().setAttribute("message", "Password reset successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to reset password.");
        }
        response.sendRedirect(request.getContextPath() + "/users");
    }
}
