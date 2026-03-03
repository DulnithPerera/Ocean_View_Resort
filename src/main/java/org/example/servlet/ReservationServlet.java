package org.example.servlet;

import org.example.model.Reservation;
import org.example.model.User;
import org.example.service.ReservationService;
import org.example.service.RoomService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

public class ReservationServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();
    private final RoomService roomService = new RoomService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            request.setAttribute("reservationNumber", reservationService.generateReservationNumber());
            request.setAttribute("rooms", roomService.getAllRooms());
            request.getRequestDispatcher("/reservation-form.jsp").forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Reservation res = reservationService.getReservationById(id);
            request.setAttribute("reservation", res);
            request.setAttribute("rooms", roomService.getAllRooms());
            request.getRequestDispatcher("/reservation-form.jsp").forward(request, response);
            return;
        }

        if ("view".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Reservation res = reservationService.getReservationById(id);
            request.setAttribute("reservation", res);
            request.getRequestDispatcher("/reservation-view.jsp").forward(request, response);
            return;
        }

        String statusFilter = request.getParameter("status");
        if (statusFilter != null && !statusFilter.isEmpty()) {
            request.setAttribute("reservations", reservationService.getByStatus(statusFilter));
            request.setAttribute("currentFilter", statusFilter);
        } else {
            request.setAttribute("reservations", reservationService.getAllReservations());
        }
        request.getRequestDispatcher("/reservations.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        User currentUser = (User) request.getSession().getAttribute("user");

        switch (action != null ? action : "") {
            case "add":
                handleAdd(request, response, currentUser);
                break;
            case "update":
                handleUpdate(request, response);
                break;
            case "delete":
                handleDelete(request, response);
                break;
            case "checkin":
                handleCheckIn(request, response);
                break;
            case "checkout":
                handleCheckOut(request, response);
                break;
            case "cancel":
                handleCancel(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/reservations");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response, User currentUser)
            throws IOException {
        try {
            if (currentUser == null) {
                request.getSession().setAttribute("error", "Session expired. Please login again.");
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }

            Reservation res = new Reservation();
            res.setReservationNumber(request.getParameter("reservationNumber"));
            res.setGuestName(request.getParameter("guestName"));
            res.setAddress(request.getParameter("address"));
            res.setContactNumber(request.getParameter("contactNumber"));
            res.setEmail(request.getParameter("email"));
            res.setRoomId(Integer.parseInt(request.getParameter("roomId")));
            res.setCheckInDate(Date.valueOf(request.getParameter("checkInDate")));
            res.setCheckOutDate(Date.valueOf(request.getParameter("checkOutDate")));
            res.setNumGuests(Integer.parseInt(request.getParameter("numGuests")));
            res.setSpecialRequests(request.getParameter("specialRequests"));
            res.setCreatedBy(currentUser.getUserId());

            System.out.println("handleAdd - reservationNumber: " + res.getReservationNumber());
            System.out.println("handleAdd - roomId: " + res.getRoomId());
            System.out.println("handleAdd - checkIn: " + res.getCheckInDate());
            System.out.println("handleAdd - checkOut: " + res.getCheckOutDate());
            System.out.println("handleAdd - createdBy: " + res.getCreatedBy());

            int newId = reservationService.createReservation(res);
            if (newId > 0) {
                request.getSession().setAttribute("message", "Reservation created successfully! ID: " + res.getReservationNumber());
            } else {
                String dbError = reservationService.getLastError();
                String errorMsg = "Failed to create reservation.";
                if (dbError != null && !dbError.isEmpty()) {
                    errorMsg += " Error: " + dbError;
                }
                request.getSession().setAttribute("error", errorMsg);
            }
        } catch (Exception e) {
            System.out.println("Exception in handleAdd: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Error creating reservation: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/reservations");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Reservation res = new Reservation();
        res.setReservationId(Integer.parseInt(request.getParameter("reservationId")));
        res.setGuestName(request.getParameter("guestName"));
        res.setAddress(request.getParameter("address"));
        res.setContactNumber(request.getParameter("contactNumber"));
        res.setEmail(request.getParameter("email"));
        res.setRoomId(Integer.parseInt(request.getParameter("roomId")));
        res.setCheckInDate(Date.valueOf(request.getParameter("checkInDate")));
        res.setCheckOutDate(Date.valueOf(request.getParameter("checkOutDate")));
        res.setNumGuests(Integer.parseInt(request.getParameter("numGuests")));
        res.setSpecialRequests(request.getParameter("specialRequests"));
        res.setStatus(request.getParameter("status"));

        boolean success = reservationService.updateReservation(res);
        if (success) {
            request.getSession().setAttribute("message", "Reservation updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update reservation.");
        }
        response.sendRedirect(request.getContextPath() + "/reservations");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = reservationService.deleteReservation(id);
        if (success) {
            request.getSession().setAttribute("message", "Reservation deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete reservation.");
        }
        response.sendRedirect(request.getContextPath() + "/reservations");
    }

    private void handleCheckIn(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = reservationService.checkIn(id);
        if (success) {
            request.getSession().setAttribute("message", "Guest checked in successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to check in guest.");
        }
        response.sendRedirect(request.getContextPath() + "/reservations");
    }

    private void handleCheckOut(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = reservationService.checkOut(id);
        if (success) {
            request.getSession().setAttribute("message", "Guest checked out successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to check out guest.");
        }
        response.sendRedirect(request.getContextPath() + "/reservations");
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        boolean success = reservationService.cancelReservation(id);
        if (success) {
            request.getSession().setAttribute("message", "Reservation cancelled successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to cancel reservation.");
        }
        response.sendRedirect(request.getContextPath() + "/reservations");
    }
}

