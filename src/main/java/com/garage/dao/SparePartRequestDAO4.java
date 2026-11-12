package com.garage.dao;

import com.garage.model.ServiceReception4;
import com.garage.model.SparePart4;
import com.garage.model.SparePartRequest4;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/** Truy cập các yêu cầu phụ tùng của một lần tiếp nhận xe. */
public class SparePartRequestDAO4 extends DAO {
    public SparePartRequestDAO4() { this(Database::getConnection); }
    public SparePartRequestDAO4(ConnectionProvider provider) { super(provider); }

    public boolean addSparePartRequest(SparePartRequest4 request) throws SQLException {
        try (Connection connection = openConnection()) {
            return insert(connection, request);
        }
    }

    /** Tạo yêu cầu đã được khách hàng duyệt trong transaction bổ sung hóa đơn. */
    static SparePartRequest4 addSparePartRequest(Connection connection, String receptionId,
                                                 String partId, int quantity) throws SQLException {
        if (receptionId == null || receptionId.isBlank() || partId == null || partId.isBlank()
                || quantity < 1) {
            throw new IllegalArgumentException("Yêu cầu phụ tùng không hợp lệ.");
        }
        String sql = "SELECT id, part_code, part_name, unit, selling_price, stock_quantity FROM spare_parts "
                + "WHERE (id = ? OR part_code = ?) AND business_status = 'ACTIVE'";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, partId);
            statement.setString(2, partId);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) {
                    throw new IllegalArgumentException("Phụ tùng không còn kinh doanh.");
                }
                String realPartId = rows.getString("id");
                int stock = rows.getInt("stock_quantity");
                try (PreparedStatement requested = connection.prepareStatement(
                        "SELECT COALESCE(SUM(quantity), 0) FROM spare_part_requests "
                                + "WHERE reception_id = ? AND spare_part_id = ?")) {
                    requested.setString(1, receptionId);
                    requested.setString(2, realPartId);
                    try (ResultSet totals = requested.executeQuery()) {
                        totals.next();
                        if (totals.getInt(1) + quantity > stock) {
                            throw new IllegalArgumentException("Số lượng phụ tùng vượt tồn kho (" + stock + ").");
                        }
                    }
                }
                BigDecimal price = rows.getBigDecimal("selling_price");
                if (price == null) {
                    throw new IllegalArgumentException("Phụ tùng này chưa có đơn giá hợp lệ.");
                }
                String unit = rows.getString("unit");
                if (unit == null || unit.isBlank()) {
                    unit = "Chiếc";
                }

                SparePart4 part = new SparePart4();
                part.setId(realPartId);
                part.setPartCode(rows.getString("part_code"));
                part.setPartName(rows.getString("part_name"));
                part.setUnit(unit);
                part.setSellingPrice(price);

                ServiceReception4 reception = new ServiceReception4();
                reception.setId(receptionId);
                SparePartRequest4 request = new SparePartRequest4();
                request.setId(UUID.randomUUID().toString());
                request.setServiceReception(reception);
                request.setSparePart(part);
                request.setQuantity(quantity);
                request.setActualUsedQuantity(quantity);
                request.setUnitPrice(price);
                request.setCustomerApprovalStatus("APPROVED");
                request.setNotes("Bổ sung khi lập hóa đơn");
                insert(connection, request);
                return request;
            }
        }
    }

    public List<SparePartRequest4> getByReceptionId(String receptionId) throws SQLException {
        String sql = "SELECT r.*, p.id AS catalog_id, p.part_code, p.part_name, p.unit, p.selling_price "
                + "FROM spare_part_requests r JOIN spare_parts p ON p.id = r.spare_part_id "
                + "WHERE r.reception_id = ? ORDER BY r.id";
        List<SparePartRequest4> requests = new ArrayList<>();
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, receptionId);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    SparePart4 part = new SparePart4();
                    part.setId(rows.getString("catalog_id"));
                    part.setPartCode(rows.getString("part_code"));
                    part.setPartName(rows.getString("part_name"));
                    part.setUnit(rows.getString("unit"));
                    part.setSellingPrice(rows.getBigDecimal("selling_price"));

                    ServiceReception4 reception = new ServiceReception4();
                    reception.setId(receptionId);
                    SparePartRequest4 request = new SparePartRequest4();
                    request.setId(rows.getString("id"));
                    request.setQuantity(rows.getInt("quantity"));
                    request.setActualUsedQuantity(rows.getInt("actual_used_quantity"));
                    request.setUnitPrice(rows.getBigDecimal("unit_price"));
                    request.setCustomerApprovalStatus(rows.getString("customer_approval_status"));
                    request.setNotes(rows.getString("notes"));
                    request.setSparePart(part);
                    request.setServiceReception(reception);
                    requests.add(request);
                }
            }
        }
        return requests;
    }

    private static boolean insert(Connection connection, SparePartRequest4 request) throws SQLException {
        requirePartRequest(request);
        if (request.getId() == null || request.getId().isBlank()) {
            request.setId(UUID.randomUUID().toString());
        }
        String sql = "INSERT INTO spare_part_requests (id, reception_id, spare_part_id, quantity, "
                + "actual_used_quantity, unit_price, customer_approval_status, notes) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, request.getId());
            statement.setString(2, request.getServiceReception().getId());
            statement.setString(3, request.getSparePart().getId());
            statement.setInt(4, request.getQuantity());
            statement.setInt(5, request.getActualUsedQuantity());
            statement.setBigDecimal(6, request.getUnitPrice());
            statement.setString(7, request.getCustomerApprovalStatus());
            statement.setString(8, request.getNotes());
            return statement.executeUpdate() == 1;
        }
    }

    private static void requirePartRequest(SparePartRequest4 request) {
        if (request == null || request.getServiceReception() == null
                || request.getServiceReception().getId() == null
                || request.getSparePart() == null || request.getSparePart().getId() == null
                || request.getQuantity() == null || request.getQuantity() < 1
                || request.getActualUsedQuantity() == null || request.getActualUsedQuantity() < 0
                || request.getActualUsedQuantity() > request.getQuantity()
                || request.getUnitPrice() == null || request.getCustomerApprovalStatus() == null) {
            throw new IllegalArgumentException("Yêu cầu phụ tùng không hợp lệ.");
        }
    }
}
