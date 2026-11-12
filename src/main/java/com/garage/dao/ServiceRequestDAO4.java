package com.garage.dao;

import com.garage.model.Service4;
import com.garage.model.ServiceReception4;
import com.garage.model.ServiceRequest4;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/** Truy cập các yêu cầu dịch vụ của một lần tiếp nhận xe. */
public class ServiceRequestDAO4 extends DAO {
    public ServiceRequestDAO4() { this(Database::getConnection); }
    public ServiceRequestDAO4(ConnectionProvider provider) { super(provider); }

    public boolean addServiceRequest(ServiceRequest4 request) throws SQLException {
        try (Connection connection = openConnection()) {
            return insert(connection, request);
        }
    }

    /** Tạo yêu cầu đã được khách hàng duyệt trong transaction bổ sung hóa đơn. */
    static ServiceRequest4 addServiceRequest(Connection connection, String receptionId,
                                             String serviceId, int quantity) throws SQLException {
        if (receptionId == null || receptionId.isBlank() || serviceId == null || serviceId.isBlank()
                || quantity < 1) {
            throw new IllegalArgumentException("Yêu cầu dịch vụ không hợp lệ.");
        }
        String sql = "SELECT id, service_code, service_name, price FROM services "
                + "WHERE (id = ? OR service_code = ?) AND availability_status = 'AVAILABLE'";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, serviceId);
            statement.setString(2, serviceId);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) {
                    throw new IllegalArgumentException("Dịch vụ không còn được cung cấp.");
                }
                BigDecimal price = rows.getBigDecimal("price");
                if (price == null) {
                    throw new IllegalArgumentException("Dịch vụ này chưa có đơn giá hợp lệ.");
                }

                Service4 service = new Service4();
                service.setId(rows.getString("id"));
                service.setServiceCode(rows.getString("service_code"));
                service.setServiceName(rows.getString("service_name"));
                service.setPrice(price);

                ServiceReception4 reception = new ServiceReception4();
                reception.setId(receptionId);
                ServiceRequest4 request = new ServiceRequest4();
                request.setId(UUID.randomUUID().toString());
                request.setServiceReception(reception);
                request.setService(service);
                request.setQuantity(quantity);
                request.setUnitPrice(price);
                request.setCustomerApprovalStatus("APPROVED");
                request.setFulfillmentStatus("PENDING");
                request.setNotes("Bổ sung khi lập hóa đơn");
                insert(connection, request);
                return request;
            }
        }
    }

    public List<ServiceRequest4> getByReceptionId(String receptionId) throws SQLException {
        String sql = "SELECT r.*, s.id AS catalog_id, s.service_code, s.service_name, s.price "
                + "FROM service_requests r JOIN services s ON s.id = r.service_id "
                + "WHERE r.reception_id = ? ORDER BY r.id";
        List<ServiceRequest4> requests = new ArrayList<>();
        try (Connection connection = openConnection();
             PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, receptionId);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    Service4 service = new Service4();
                    service.setId(rows.getString("catalog_id"));
                    service.setServiceCode(rows.getString("service_code"));
                    service.setServiceName(rows.getString("service_name"));
                    service.setPrice(rows.getBigDecimal("price"));

                    ServiceReception4 reception = new ServiceReception4();
                    reception.setId(receptionId);
                    ServiceRequest4 request = new ServiceRequest4();
                    request.setId(rows.getString("id"));
                    request.setQuantity(rows.getInt("quantity"));
                    request.setUnitPrice(rows.getBigDecimal("unit_price"));
                    request.setCustomerApprovalStatus(rows.getString("customer_approval_status"));
                    request.setFulfillmentStatus(rows.getString("fulfillment_status"));
                    request.setNotes(rows.getString("notes"));
                    request.setService(service);
                    request.setServiceReception(reception);
                    requests.add(request);
                }
            }
        }
        return requests;
    }

    private static boolean insert(Connection connection, ServiceRequest4 request) throws SQLException {
        requireServiceRequest(request);
        if (request.getId() == null || request.getId().isBlank()) {
            request.setId(UUID.randomUUID().toString());
        }
        String sql = "INSERT INTO service_requests (id, reception_id, service_id, quantity, unit_price, "
                + "customer_approval_status, fulfillment_status, notes) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, request.getId());
            statement.setString(2, request.getServiceReception().getId());
            statement.setString(3, request.getService().getId());
            statement.setInt(4, request.getQuantity());
            statement.setBigDecimal(5, request.getUnitPrice());
            statement.setString(6, request.getCustomerApprovalStatus());
            statement.setString(7, request.getFulfillmentStatus());
            statement.setString(8, request.getNotes());
            return statement.executeUpdate() == 1;
        }
    }

    private static void requireServiceRequest(ServiceRequest4 request) {
        if (request == null || request.getServiceReception() == null
                || request.getServiceReception().getId() == null
                || request.getService() == null || request.getService().getId() == null
                || request.getQuantity() == null || request.getQuantity() < 1
                || request.getUnitPrice() == null || request.getCustomerApprovalStatus() == null
                || request.getFulfillmentStatus() == null) {
            throw new IllegalArgumentException("Yêu cầu dịch vụ không hợp lệ.");
        }
    }
}
