package com.garage.dao;

import com.garage.model.AvailabilityStatus;
import com.garage.model.Service4;
import com.garage.model.ServiceCategory4;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class ServiceDAO extends DAO {
    private static final String SELECT = """
            SELECT s.id, s.service_code, s.service_name, s.image_url, s.description,
                   s.estimated_minutes,
                   s.price, s.availability_status, c.id AS category_id,
                   c.category_name, c.description AS category_description
            FROM services s
            LEFT JOIN service_categories c ON c.id = s.category_id
            """;

    public ServiceDAO() {
        this(Database::getConnection);
    }

    public ServiceDAO(ConnectionProvider connectionProvider) {
        super(connectionProvider);
    }

    public Optional<Service4> findById(String id) throws SQLException {
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT + " WHERE s.id = ?")) {
            statement.setString(1, id);
            try (ResultSet rows = statement.executeQuery()) {
                return rows.next() ? Optional.of(mapService(rows)) : Optional.empty();
            }
        }
    }

    /**
     * Finds services whose name contains the supplied keyword.
     * The keyword is bound as a parameter so wildcard characters entered by a
     * customer are treated as normal text, not as SQL wildcards.
     */
    public List<Service4> searchServices(String keyword) throws SQLException {
        String sql = SELECT + " WHERE LOWER(s.service_name) LIKE ? ESCAPE '!'"
                + " ORDER BY s.service_name, s.service_code LIMIT 100";
        List<Service4> services = new ArrayList<>();
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, searchPattern(keyword));
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    services.add(mapService(rows));
                }
            }
        }
        return services;
    }

    private Service4 mapService(ResultSet rows) throws SQLException {
        ServiceCategory4 category = null;
        String catId = rows.getString("category_id");
        if (catId != null) {
            category = new ServiceCategory4(
                    catId,
                    rows.getString("category_name"),
                    rows.getString("category_description")
            );
        }
        AvailabilityStatus status = AvailabilityStatus.AVAILABLE;
        String statusStr = rows.getString("availability_status");
        if (statusStr != null) {
            try {
                status = AvailabilityStatus.valueOf(statusStr.trim().toUpperCase());
            } catch (IllegalArgumentException ignored) {
            }
        }
        return new Service4(
                rows.getString("id"),
                rows.getString("service_code"),
                rows.getString("service_name"),
                rows.getString("image_url"),
                rows.getString("description"),
                rows.getBigDecimal("price"),
                status,
                category
        );
    }
}
