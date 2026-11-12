package com.garage.dao;

import com.garage.model.BusinessStatus;
import com.garage.model.SparePart4;
import com.garage.model.SparePartCategory4;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class SparePartDAO extends DAO {
    private static final String SELECT = """
            SELECT p.id, p.part_code, p.part_name, p.image_url, p.brand, p.origin, p.specifications,
                   p.unit, p.description, p.selling_price, p.stock_quantity, p.warranty_period,
                   p.business_status, c.id AS category_id, c.category_name, c.description AS category_description
            FROM spare_parts p
            LEFT JOIN spare_part_categories c ON c.id = p.category_id
            """;

    public SparePartDAO() {
        this(Database::getConnection);
    }

    public SparePartDAO(ConnectionProvider connectionProvider) {
        super(connectionProvider);
    }

    public Optional<SparePart4> findById(String id) throws SQLException {
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(SELECT + " WHERE p.id = ?")) {
            statement.setString(1, id);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) {
                    return Optional.empty();
                }
                return Optional.of(mapPart(rows));
            }
        }
    }

    /**
     * Finds spare parts by part name.
     */
    public List<SparePart4> searchSpareParts(String keyword) throws SQLException {
        String sql = SELECT + " WHERE LOWER(p.part_name) LIKE ? ESCAPE '!'"
                + " ORDER BY p.part_name, p.part_code LIMIT 100";
        List<SparePart4> parts = new ArrayList<>();
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, searchPattern(keyword));
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    parts.add(mapPart(rows));
                }
            }
        }
        return parts;
    }

    private SparePart4 mapPart(ResultSet rows) throws SQLException {
        BusinessStatus status = BusinessStatus.ACTIVE;
        String statusStr = rows.getString("business_status");
        if (statusStr != null) {
            try {
                status = BusinessStatus.valueOf(statusStr.trim().toUpperCase());
            } catch (IllegalArgumentException ignored) {
            }
        }
        SparePartCategory4 category = null;
        String categoryId = rows.getString("category_id");
        if (categoryId != null) {
            category = new SparePartCategory4(categoryId, rows.getString("category_name"), rows.getString("category_description"));
        }
        return new SparePart4(
                rows.getString("id"),
                rows.getString("part_code"),
                rows.getString("part_name"),
                rows.getString("image_url"),
                rows.getString("brand"),
                rows.getString("origin"),
                rows.getString("specifications"),
                rows.getString("unit"),
                rows.getString("description"),
                rows.getBigDecimal("selling_price"),
                rows.getInt("stock_quantity"),
                rows.getInt("warranty_period"),
                status,
                category
        );
    }
}
