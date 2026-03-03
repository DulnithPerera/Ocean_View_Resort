package org.example.servlet;

import org.example.model.Food;
import org.example.model.ReservationFood;
import org.example.service.FoodService;
import org.example.service.ReservationService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;

public class FoodOrderServlet extends HttpServlet {

    private final FoodService foodService = new FoodService();
    private final ReservationService reservationService = new ReservationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String resIdParam = request.getParameter("reservationId");

        if (resIdParam != null) {
            int reservationId = Integer.parseInt(resIdParam);
            request.setAttribute("reservation", reservationService.getReservationById(reservationId));
            request.setAttribute("foodOrders", foodService.getFoodOrdersByReservation(reservationId));
            request.setAttribute("totalFoodCharges", foodService.getTotalFoodCharges(reservationId));
        }

        request.setAttribute("breakfastFoods", foodService.getFoodsByType("Breakfast"));
        request.setAttribute("lunchFoods", foodService.getFoodsByType("Lunch"));
        request.setAttribute("dinnerFoods", foodService.getFoodsByType("Dinner"));
        request.setAttribute("activeReservations", reservationService.getByStatus("Checked-In"));

        request.setAttribute("confirmedReservations", reservationService.getByStatus("Confirmed"));

        request.getRequestDispatcher("/food-orders.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        switch (action != null ? action : "") {
            case "add":
                handleAddOrder(request, response);
                break;
            case "delete":
                handleDeleteOrder(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/food-orders");
        }
    }

    private void handleAddOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int reservationId = Integer.parseInt(request.getParameter("reservationId"));
        int foodId = Integer.parseInt(request.getParameter("foodId"));
        int quantity = Integer.parseInt(request.getParameter("quantity"));

        Food food = foodService.getFoodById(foodId);
        if (food == null) {
            request.getSession().setAttribute("error", "Food item not found.");
            response.sendRedirect(request.getContextPath() + "/food-orders?reservationId=" + reservationId);
            return;
        }

        ReservationFood order = new ReservationFood();
        order.setReservationId(reservationId);
        order.setFoodId(foodId);
        order.setQuantity(quantity);
        order.setOrderDate(new Date(System.currentTimeMillis()));
        order.setTotalPrice(food.getPrice() * quantity);

        boolean success = foodService.addFoodOrder(order);
        if (success) {
            request.getSession().setAttribute("message", "Food order added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add food order.");
        }
        response.sendRedirect(request.getContextPath() + "/food-orders?reservationId=" + reservationId);
    }

    private void handleDeleteOrder(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String resId = request.getParameter("reservationId");
        boolean success = foodService.deleteFoodOrder(id);
        if (success) {
            request.getSession().setAttribute("message", "Food order removed successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to remove food order.");
        }
        response.sendRedirect(request.getContextPath() + "/food-orders?reservationId=" + resId);
    }
}

