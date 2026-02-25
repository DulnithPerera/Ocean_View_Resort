package org.example.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    private static final String DB_URL =
            "jdbc:sqlserver://localhost:1433;databaseName=OceanView_DB;encrypt=true;trustServerCertificate=true";

    private static final String DB_USER = "sa";
    private static final String DB_PASS = "dp123";

    public static Connection getConnection() {

        Connection con = null;

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            System.out.println("JDBC Driver Loaded");

            con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            System.out.println("Database Connected Successfully");

        } catch (ClassNotFoundException e) {
            System.out.println("SQL SERVER JDBC DRIVER NOT FOUND");
            System.out.println("Make sure mssql-jdbc is in your classpath");
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("DATABASE CONNECTION FAILED");
            System.out.println("Error: " + e.getMessage());
            System.out.println("Check your connection details:");
            System.out.println("  - Server: localhost:1433");
            System.out.println("  - Database: ocean_view_resort");
            System.out.println("  - User: " + DB_USER);
            System.out.println("  - Password is set (change 'dp123' to your actual password)");
            e.printStackTrace();
        } catch (Exception e) {
            System.out.println("UNEXPECTED ERROR");
            e.printStackTrace();
        }

        return con;
    }

    public static void closeConnection(Connection con) {
        if (con != null) {
            try {
                con.close();
                System.out.println("Database Connection Closed");
            } catch (SQLException e) {
                System.out.println("ERROR CLOSING CONNECTION");
                e.printStackTrace();
            }
        }
    }
}
