package org.example.servlet;

import org.example.service.ReportService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.Map;

public class ReportServlet extends HttpServlet {

    private final ReportService reportService = new ReportService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String reportType = request.getParameter("type");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");

        Date startDate;
        Date endDate;
        if (startDateStr != null && endDateStr != null && !startDateStr.isEmpty() && !endDateStr.isEmpty()) {
            startDate = Date.valueOf(startDateStr);
            endDate = Date.valueOf(endDateStr);
        } else {
            java.util.Calendar cal = java.util.Calendar.getInstance();
            endDate = new Date(cal.getTimeInMillis());
            cal.set(java.util.Calendar.DAY_OF_MONTH, 1);
            startDate = new Date(cal.getTimeInMillis());
        }

        request.setAttribute("startDate", startDate.toString());
        request.setAttribute("endDate", endDate.toString());

        if ("occupancy".equals(reportType)) {
            Map<String, Object> occupancyReport = reportService.getOccupancyReport(startDate, endDate);
            request.setAttribute("occupancyReport", occupancyReport);
            request.setAttribute("reportType", "occupancy");
        } else {
            Map<String, Object> revenueReport = reportService.getRevenueReport(startDate, endDate);
            request.setAttribute("revenueReport", revenueReport);
            request.setAttribute("reportType", "revenue");
        }

        request.getRequestDispatcher("/reports.jsp").forward(request, response);
    }
}
