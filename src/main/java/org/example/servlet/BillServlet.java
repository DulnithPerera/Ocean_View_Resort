package org.example.servlet;

import org.example.model.Bill;
import org.example.model.Reservation;
import org.example.model.User;
import org.example.service.BillService;
import org.example.service.FoodService;
import org.example.service.ReservationService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class BillServlet extends HttpServlet {

    private final BillService billService = new BillService();
    private final ReservationService reservationService = new ReservationService();
    private final FoodService foodService = new FoodService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("view".equals(action)) {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            Bill bill = billService.getBillByReservation(reservationId);
            Reservation res = reservationService.getReservationById(reservationId);
            request.setAttribute("bill", bill);
            request.setAttribute("reservation", res);
            request.setAttribute("foodOrders", foodService.getFoodOrdersByReservation(reservationId));
            request.getRequestDispatcher("/bill-view.jsp").forward(request, response);
            return;
        }

        if ("generate".equals(action)) {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            Reservation res = reservationService.getReservationById(reservationId);
            request.setAttribute("reservation", res);
            request.setAttribute("foodOrders", foodService.getFoodOrdersByReservation(reservationId));
            request.getRequestDispatcher("/bill-generate.jsp").forward(request, response);
            return;
        }

        request.setAttribute("bills", billService.getAllBills());
        request.getRequestDispatcher("/bills.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("generate".equals(action)) {
            int reservationId = Integer.parseInt(request.getParameter("reservationId"));
            String billingType = request.getParameter("billingType");
            User currentUser = (User) request.getSession().getAttribute("user");

            Bill bill = billService.generateBill(reservationId, billingType, currentUser.getUserId());
            if (bill != null) {
                request.getSession().setAttribute("message", "Bill generated successfully!");
                response.sendRedirect(request.getContextPath() + "/bills?action=view&reservationId=" + reservationId);
            } else {
                request.getSession().setAttribute("error", "Failed to generate bill.");
                response.sendRedirect(request.getContextPath() + "/bills");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/bills");
        }
    }
}

