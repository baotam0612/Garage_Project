package com.garage.dao;

import java.sql.Connection;
import java.sql.SQLException;
import java.util.Objects;

public abstract class DAO {
    private final ConnectionProvider connectionProvider;

    protected DAO(ConnectionProvider connectionProvider) {
        this.connectionProvider = Objects.requireNonNull(connectionProvider);
    }

    protected Connection openConnection() throws SQLException {
        return connectionProvider.getConnection();
    }

    protected static String searchPattern(String keyword) {
        String text = keyword == null ? "" : keyword.trim().toLowerCase(java.util.Locale.ROOT);
        return "%" + text.replace("!", "!!").replace("%", "!%").replace("_", "!_") + "%";
    }
}
