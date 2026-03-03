package org.example.servlet;

import org.example.model.Room;
import org.example.service.RoomService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class RoomServlet extends HttpServlet {

    private final RoomService roomService = new RoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int roomId = Integer.parseInt(request.getParameter("id"));
            Room room = roomService.getRoomById(roomId);
            request.setAttribute("editRoom", room);
        }

        request.setAttribute("rooms", roomService.getAllRooms());
        request.getRequestDispatcher("/rooms.jsp").forward(request, response);
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
            default:
                response.sendRedirect(request.getContextPath() + "/rooms");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Room room = new Room();
        room.setRoomNumber(request.getParameter("roomNumber"));
        room.setRoomType(request.getParameter("roomType"));
        room.setRatePerNight(Double.parseDouble(request.getParameter("ratePerNight")));
        room.setStatus("Available");
        room.setFloor(Integer.parseInt(request.getParameter("floor")));
        room.setDescription(request.getParameter("description"));
        room.setMaxGuests(Integer.parseInt(request.getParameter("maxGuests")));

        boolean success = roomService.addRoom(room);
        if (success) {
            request.getSession().setAttribute("message", "Room added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add room.");
        }
        response.sendRedirect(request.getContextPath() + "/rooms");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Room room = new Room();
        room.setRoomId(Integer.parseInt(request.getParameter("roomId")));
        room.setRoomNumber(request.getParameter("roomNumber"));
        room.setRoomType(request.getParameter("roomType"));
        room.setRatePerNight(Double.parseDouble(request.getParameter("ratePerNight")));
        room.setStatus(request.getParameter("status"));
        room.setFloor(Integer.parseInt(request.getParameter("floor")));
        room.setDescription(request.getParameter("description"));
        room.setMaxGuests(Integer.parseInt(request.getParameter("maxGuests")));

        boolean success = roomService.updateRoom(room);
        if (success) {
            request.getSession().setAttribute("message", "Room updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update room.");
        }
        response.sendRedirect(request.getContextPath() + "/rooms");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int roomId = Integer.parseInt(request.getParameter("id"));
        boolean success = roomService.deleteRoom(roomId);
        if (success) {
            request.getSession().setAttribute("message", "Room deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete room. It may have reservations.");
        }
        response.sendRedirect(request.getContextPath() + "/rooms");
    }
}
