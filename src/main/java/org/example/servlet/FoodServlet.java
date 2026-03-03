package org.example.servlet;

import org.example.model.Food;
import org.example.service.FoodService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class FoodServlet extends HttpServlet {

    private final FoodService foodService = new FoodService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            int foodId = Integer.parseInt(request.getParameter("id"));
            Food food = foodService.getFoodById(foodId);
            request.setAttribute("editFood", food);
        }

        request.setAttribute("foods", foodService.getAllFoods());
        request.getRequestDispatcher("/foods.jsp").forward(request, response);
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
                response.sendRedirect(request.getContextPath() + "/foods");
        }
    }

    private void handleAdd(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Food food = new Food();
        food.setFoodName(request.getParameter("foodName"));
        food.setFoodType(request.getParameter("foodType"));
        food.setPrice(Double.parseDouble(request.getParameter("price")));
        food.setDescription(request.getParameter("description"));
        food.setAvailable(true);

        boolean success = foodService.addFood(food);
        if (success) {
            request.getSession().setAttribute("message", "Food item added successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to add food item.");
        }
        response.sendRedirect(request.getContextPath() + "/foods");
    }

    private void handleUpdate(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Food food = new Food();
        food.setFoodId(Integer.parseInt(request.getParameter("foodId")));
        food.setFoodName(request.getParameter("foodName"));
        food.setFoodType(request.getParameter("foodType"));
        food.setPrice(Double.parseDouble(request.getParameter("price")));
        food.setDescription(request.getParameter("description"));
        food.setAvailable("on".equals(request.getParameter("isAvailable")));

        boolean success = foodService.updateFood(food);
        if (success) {
            request.getSession().setAttribute("message", "Food item updated successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to update food item.");
        }
        response.sendRedirect(request.getContextPath() + "/foods");
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int foodId = Integer.parseInt(request.getParameter("id"));
        boolean success = foodService.deleteFood(foodId);
        if (success) {
            request.getSession().setAttribute("message", "Food item deleted successfully!");
        } else {
            request.getSession().setAttribute("error", "Failed to delete food item.");
        }
        response.sendRedirect(request.getContextPath() + "/foods");
    }
}

