package org.example.servlet;

import org.example.service.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DashboardServlet extends HttpServlet {

    private final ReservationService reservationService = new ReservationService();
    private final RoomService roomService = new RoomService();
    private final BillService billService = new BillService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("totalRooms", roomService.getTotalRooms());
        request.setAttribute("availableRooms", roomService.getAvailableRoomCount());
        request.setAttribute("occupiedRooms", roomService.getOccupiedRoomCount());
        request.setAttribute("activeReservations", reservationService.getActiveCount());
        request.setAttribute("todayCheckIns", reservationService.getTodayCheckIns());
        request.setAttribute("todayCheckOuts", reservationService.getTodayCheckOuts());
        request.setAttribute("todayRevenue", billService.getTodayRevenue());

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

}

