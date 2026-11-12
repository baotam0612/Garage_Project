package com.garage.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public final class Database {
    private static final String DEFAULT_URL = "jdbc:mysql://localhost:3306/garage?useSSL=false&allowPublicKeyRetrieval=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASSWORD = "Tam06122005@";

    private Database() {
    }

    public static Connection getConnection() throws SQLException {
        String url = System.getenv("GARAGE_DB_URL");
        if (url == null || url.isBlank()) {
            url = System.getProperty("GARAGE_DB_URL", DEFAULT_URL);
        }

        String user = System.getenv("GARAGE_DB_USER");
        if (user == null || user.isBlank()) {
            user = System.getProperty("GARAGE_DB_USER", DEFAULT_USER);
        }

        String password = System.getenv("GARAGE_DB_PASSWORD");
        if (password == null) {
            password = System.getProperty("GARAGE_DB_PASSWORD", DEFAULT_PASSWORD);
        }

        try {
            Class.forName(url.startsWith("jdbc:h2:") ? "org.h2.Driver" : "com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException exception) {
            throw new SQLException("JDBC driver is unavailable", exception);
        }
        return DriverManager.getConnection(url, user, password);
    }
}
