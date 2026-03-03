package org.example.service;

import org.example.dao.ReportDao;

import java.sql.Date;
import java.util.Map;

public class ReportService {

    private final ReportDao reportDao = new ReportDao();

    public Map<String, Object> getRevenueReport(Date startDate, Date endDate) {
        return reportDao.getRevenueReport(startDate, endDate);
    }

    public Map<String, Object> getOccupancyReport(Date startDate, Date endDate) {
        return reportDao.getOccupancyReport(startDate, endDate);
    }
}
