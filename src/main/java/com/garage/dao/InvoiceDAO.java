package com.garage.dao;

import com.garage.model.Invoice4;
import com.garage.model.Customer4;
import com.garage.model.Account4;
import com.garage.model.SalesStaff4;
import com.garage.model.ServiceReception4;
import com.garage.model.ServiceRequest4;
import com.garage.model.Service4;
import com.garage.model.SparePartRequest4;
import com.garage.model.SparePart4;
import com.garage.model.Vehicle4;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;
import java.util.UUID;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

public class InvoiceDAO extends DAO {
    private static final int PASSWORD_ITERATIONS = 210_000;
    private static final int PASSWORD_KEY_BITS = 256;
    private static final SecureRandom PASSWORD_RANDOM = new SecureRandom();
    public InvoiceDAO() { this(Database::getConnection); }
    public InvoiceDAO(ConnectionProvider provider) { super(provider); }

    /** Password support belongs with the invoice payment workflow, not a controller. */
    public static String hashPassword(String password) {
        if (password == null || password.length() < 12) {
            throw new IllegalArgumentException("Mật khẩu phải có ít nhất 12 ký tự.");
        }
        byte[] salt = new byte[16];
        PASSWORD_RANDOM.nextBytes(salt);
        return "pbkdf2$" + PASSWORD_ITERATIONS + "$" + Base64.getEncoder().encodeToString(salt)
                + "$" + Base64.getEncoder().encodeToString(derivePassword(password, salt, PASSWORD_ITERATIONS));
    }

    public static boolean verifyPassword(String password, String encoded) {
        if (password == null || encoded == null) { return false; }
        if (password.equals(encoded)) { return true; }
        try {
            String[] parts = encoded.split("\\$");
            if (parts.length != 4 || !"pbkdf2".equals(parts[0])) { return false; }
            int iterations = Integer.parseInt(parts[1]);
            if (iterations < 100_000 || iterations > 1_000_000) { return false; }
            byte[] salt = Base64.getDecoder().decode(parts[2]);
            byte[] expected = Base64.getDecoder().decode(parts[3]);
            return salt.length == 16 && expected.length == 32
                    && MessageDigest.isEqual(expected, derivePassword(password, salt, iterations));
        } catch (IllegalArgumentException exception) {
            return false;
        }
    }

    private static byte[] derivePassword(String password, byte[] salt, int iterations) {
        PBEKeySpec spec = new PBEKeySpec(password.toCharArray(), salt, iterations, PASSWORD_KEY_BITS);
        try {
            return SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).getEncoded();
        } catch (Exception exception) {
            throw new IllegalStateException("Không thể tạo mã băm mật khẩu.", exception);
        } finally {
            spec.clearPassword();
        }
    }

    /** Generates a PBKDF2 hash for creating the first sales account. */
    public static void main(String[] args) {
        if (args.length != 0) { throw new IllegalArgumentException("Chạy không cần tham số."); }
        char[] password = System.console() == null ? new char[0] : System.console().readPassword("Mật khẩu nhân viên mới: ");
        if (password.length == 0) { throw new IllegalStateException("Hãy chạy lệnh trong terminal tương tác để nhập mật khẩu."); }
        try { System.out.println(hashPassword(new String(password))); }
        finally { java.util.Arrays.fill(password, '\0'); }
    }

    public SalesStaff4 findSalesStaffByUsername(String username) throws SQLException {
        String sql = """
                SELECT s.user_id, p.full_name, a.password_hash
                FROM accounts a JOIN staff_users u ON u.account_id = a.id
                JOIN sales_staff s ON s.user_id = u.person_id
                JOIN persons p ON p.id = s.user_id
                WHERE a.username = ? AND a.role = 'SALES' AND u.employment_status = 'ACTIVE'
                """;
        try (Connection connection = openConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, username);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) { return null; }
                Account4 account = new Account4();
                account.setPasswordHash(rows.getString(3));
                SalesStaff4 staff = new SalesStaff4();
                staff.setId(rows.getString(1));
                staff.setFullName(rows.getString(2));
                staff.setAccount(account);
                return staff;
            }
        }
    }

    public void registerSalesStaff(String username, String password, String fullName, String staffCode) throws SQLException {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
        }
        if (password == null || password.isBlank()) {
            throw new IllegalArgumentException("Mật khẩu không được để trống.");
        }
        if (fullName == null || fullName.isBlank()) {
            throw new IllegalArgumentException("Họ và tên không được để trống.");
        }

        try (Connection connection = openConnection()) {
            connection.setAutoCommit(false);
            try {
                try (PreparedStatement check = connection.prepareStatement("SELECT id FROM accounts WHERE username = ?")) {
                    check.setString(1, username.trim());
                    try (ResultSet rs = check.executeQuery()) {
                        if (rs.next()) {
                            throw new IllegalArgumentException("Tên đăng nhập đã tồn tại, vui lòng chọn tên khác.");
                        }
                    }
                }

                String code = (staffCode == null || staffCode.isBlank())
                        ? "NV" + (System.currentTimeMillis() % 10000)
                        : staffCode.trim();

                try (PreparedStatement checkCode = connection.prepareStatement("SELECT user_id FROM sales_staff WHERE sales_staff_code = ?")) {
                    checkCode.setString(1, code);
                    try (ResultSet rs = checkCode.executeQuery()) {
                        if (rs.next()) {
                            code = code + "_" + (System.currentTimeMillis() % 1000);
                        }
                    }
                }

                String personId = UUID.randomUUID().toString();
                String accountId = UUID.randomUUID().toString();

                try (PreparedStatement ps = connection.prepareStatement("INSERT INTO persons (id, full_name) VALUES (?, ?)")) {
                    ps.setString(1, personId);
                    ps.setString(2, fullName.trim());
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO accounts (id, username, password_hash, role, created_at) VALUES (?, ?, ?, 'SALES', CURRENT_TIMESTAMP)")) {
                    ps.setString(1, accountId);
                    ps.setString(2, username.trim());
                    ps.setString(3, password);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO staff_users (person_id, account_id, employment_status) VALUES (?, ?, 'ACTIVE')")) {
                    ps.setString(1, personId);
                    ps.setString(2, accountId);
                    ps.executeUpdate();
                }

                try (PreparedStatement ps = connection.prepareStatement(
                        "INSERT INTO sales_staff (user_id, sales_staff_code) VALUES (?, ?)")) {
                    ps.setString(1, personId);
                    ps.setString(2, code);
                    ps.executeUpdate();
                }

                connection.commit();
            } catch (SQLException | RuntimeException e) {
                connection.rollback();
                throw e;
            }
        }
    }

    public void resetPassword(String username, String newPassword) throws SQLException {
        if (username == null || username.isBlank()) {
            throw new IllegalArgumentException("Tên đăng nhập không được để trống.");
        }
        if (newPassword == null || newPassword.isBlank()) {
            throw new IllegalArgumentException("Mật khẩu mới không được để trống.");
        }

        try (Connection connection = openConnection()) {
            try (PreparedStatement check = connection.prepareStatement("SELECT id FROM accounts WHERE username = ?")) {
                check.setString(1, username.trim());
                try (ResultSet rs = check.executeQuery()) {
                    if (!rs.next()) {
                        throw new IllegalArgumentException("Tên đăng nhập không tồn tại trong hệ thống.");
                    }
                }
            }

            try (PreparedStatement update = connection.prepareStatement("UPDATE accounts SET password_hash = ? WHERE username = ?")) {
                update.setString(1, newPassword);
                update.setString(2, username.trim());
                update.executeUpdate();
            }
        }
    }

    public List<Customer4> searchCustomers(String keyword) throws SQLException {
        String sql = """
                SELECT c.person_id, c.customer_code, p.full_name, p.phone_number,
                       v.license_plate, v.make, v.model
                FROM customers c JOIN persons p ON p.id = c.person_id
                LEFT JOIN vehicles v ON v.customer_id = c.person_id
                WHERE LOWER(p.full_name) LIKE ? ESCAPE '!'
                ORDER BY p.full_name, c.person_id, v.license_plate LIMIT 300
                """;
        java.util.Map<String, Customer4> found = new java.util.LinkedHashMap<>();
        try (Connection connection = openConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, searchPattern(keyword));
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    String id = rows.getString("person_id");
                    Customer4 customer = found.get(id);
                    if (customer == null) {
                        customer = new Customer4(id, rows.getString("customer_code"),
                                rows.getString("full_name"), rows.getString("phone_number"), null);
                        found.put(id, customer);
                    }
                    String plate = rows.getString("license_plate");
                    if (plate != null) {
                        Vehicle4 vehicle = new Vehicle4();
                        vehicle.setLicensePlate(plate);
                        vehicle.setMake(rows.getString("make"));
                        vehicle.setModel(rows.getString("model"));
                        vehicle.setCustomer(customer);
                        customer.getVehicles().add(vehicle);
                    }
                }
            }
        }
        return new ArrayList<>(found.values());
    }

    public Invoice4 getUnpaidInvoiceByCustomer(String customerId) throws SQLException {
        if (customerId == null || customerId.isBlank()) { return null; }
        String sql = """
                SELECT i.id, i.invoice_number, i.issued_at, v.license_plate, i.total_amount
                FROM invoices i JOIN service_receptions r ON r.id = i.reception_id
                JOIN vehicles v ON v.id = r.vehicle_id
                WHERE v.customer_id = ? AND i.payment_status = 'UNPAID'
                ORDER BY i.issued_at DESC, i.invoice_number LIMIT 1
                """;
        try (Connection connection = openConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, customerId);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) { return null; }
                Invoice4 invoice = new Invoice4();
                invoice.setId(rows.getString(1));
                invoice.setInvoiceNumber(rows.getString(2));
                invoice.setIssuedAt(rows.getTimestamp(3).toLocalDateTime());
                invoice.setTotalAmount(rows.getBigDecimal(5));
                Vehicle4 vehicle = new Vehicle4();
                vehicle.setLicensePlate(rows.getString(4));
                ServiceReception4 reception = new ServiceReception4();
                reception.setVehicle(vehicle);
                invoice.setServiceReception(reception);
                return invoice;
            }
        }
    }

    public static class InvoiceMeta {
        public final String id;
        public final String invoiceNumber;
        public final String invoiceStatus;
        public final String paymentStatus;
        public final BigDecimal totalAmount;
        public final String receptionId;

        public InvoiceMeta(String id, String invoiceNumber, String invoiceStatus, String paymentStatus,
                           BigDecimal totalAmount, String receptionId) {
            this.id = id;
            this.invoiceNumber = invoiceNumber;
            this.invoiceStatus = invoiceStatus;
            this.paymentStatus = paymentStatus;
            this.totalAmount = totalAmount;
            this.receptionId = receptionId;
        }
    }

    private InvoiceMeta findInvoiceMeta(Connection connection, String invoiceId) throws SQLException {
        if (invoiceId == null || invoiceId.isBlank()) {
            return null;
        }
        String sql = "SELECT id, invoice_number, invoice_status, payment_status, total_amount, reception_id "
                + "FROM invoices WHERE (id = ? OR invoice_number = ?) LIMIT 1 FOR UPDATE";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, invoiceId);
            statement.setString(2, invoiceId);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) {
                    return null;
                }
                return new InvoiceMeta(
                        rows.getString("id"),
                        rows.getString("invoice_number"),
                        rows.getString("invoice_status"),
                        rows.getString("payment_status"),
                        rows.getBigDecimal("total_amount"),
                        rows.getString("reception_id")
                );
            }
        }
    }

    public Invoice4 getInvoiceById(String invoiceId) throws SQLException {
        String sql = """
                SELECT i.*, c.person_id AS customer_id, c.customer_code,
                       p.full_name, p.phone_number, v.license_plate, v.make, v.model
                FROM invoices i JOIN service_receptions r ON r.id = i.reception_id
                JOIN vehicles v ON v.id = r.vehicle_id
                JOIN customers c ON c.person_id = v.customer_id
                JOIN persons p ON p.id = c.person_id WHERE (i.id = ? OR i.invoice_number = ?)
                """;
        try (Connection connection = openConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, invoiceId);
            statement.setString(2, invoiceId);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) { return null; }
                Invoice4 invoice = new Invoice4();
                invoice.setId(rows.getString("id"));
                invoice.setInvoiceNumber(rows.getString("invoice_number"));
                invoice.setIssuedAt(rows.getTimestamp("issued_at").toLocalDateTime());
                invoice.setInvoiceStatus(rows.getString("invoice_status"));
                invoice.setPaymentStatus(rows.getString("payment_status"));
                invoice.setPaymentMethod(rows.getString("payment_method"));
                invoice.setServiceTotal(rows.getBigDecimal("service_total"));
                invoice.setSparePartTotal(rows.getBigDecimal("spare_part_total"));
                invoice.setDiscountAmount(rows.getBigDecimal("discount_amount"));
                invoice.setTotalAmount(rows.getBigDecimal("total_amount"));
                Customer4 customer = new Customer4(rows.getString("customer_id"), rows.getString("customer_code"),
                        rows.getString("full_name"), rows.getString("phone_number"), null);
                Vehicle4 vehicle = new Vehicle4();
                vehicle.setLicensePlate(rows.getString("license_plate"));
                vehicle.setMake(rows.getString("make"));
                vehicle.setModel(rows.getString("model"));
                vehicle.setCustomer(customer);
                ServiceReception4 reception = new ServiceReception4();
                reception.setVehicle(vehicle);
                loadInvoiceItems(connection, invoice.getId(), reception);
                invoice.setServiceReception(reception);
                return invoice;
            }
        }
    }

    /** Exact diagram method: returns the latest invoice of one customer. */
    public Invoice4 getInvoiceByCustomer(String customerId) throws SQLException {
        String sql = """
                SELECT i.*, r.id AS reception_id
                FROM invoices i JOIN service_receptions r ON r.id = i.reception_id
                JOIN vehicles v ON v.id = r.vehicle_id
                WHERE v.customer_id = ? ORDER BY i.issued_at DESC LIMIT 1
                """;
        try (Connection connection = openConnection(); PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, customerId);
            try (ResultSet rows = statement.executeQuery()) {
                if (!rows.next()) { return null; }
                Invoice4 invoice = new Invoice4();
                invoice.setId(rows.getString("id"));
                invoice.setInvoiceNumber(rows.getString("invoice_number"));
                Timestamp issuedAt = rows.getTimestamp("issued_at");
                invoice.setIssuedAt(issuedAt == null ? null : issuedAt.toLocalDateTime());
                invoice.setServiceTotal(rows.getBigDecimal("service_total"));
                invoice.setSparePartTotal(rows.getBigDecimal("spare_part_total"));
                invoice.setDiscountAmount(rows.getBigDecimal("discount_amount"));
                invoice.setTotalAmount(rows.getBigDecimal("total_amount"));
                invoice.setInvoiceStatus(rows.getString("invoice_status"));
                invoice.setPaymentStatus(rows.getString("payment_status"));
                invoice.setPaymentMethod(rows.getString("payment_method"));
                Timestamp paidAt = rows.getTimestamp("paid_at");
                invoice.setPaidAt(paidAt == null ? null : paidAt.toLocalDateTime());
                ServiceReception4 reception = new ServiceReception4();
                reception.setId(rows.getString("reception_id"));
                invoice.setServiceReception(reception);
                return invoice;
            }
        }
    }

    public boolean updateInvoiceTotal(String invoiceId) throws SQLException {
        try (Connection connection = openConnection()) {
            if (invoiceId == null || invoiceId.isBlank()) { return false; }
            InvoiceMeta meta = findInvoiceMeta(connection, invoiceId);
            if (meta == null) { return false; }
            refreshTotals(connection, meta.id);
            return true;
        }
    }

    private void loadInvoiceItems(Connection connection, String invoiceId, ServiceReception4 reception) throws SQLException {
        String sql = "SELECT * FROM invoice_lines WHERE invoice_id = ? ORDER BY item_type, item_code, id";
        try (PreparedStatement statement = connection.prepareStatement(sql)) {
            statement.setString(1, invoiceId);
            try (ResultSet rows = statement.executeQuery()) {
                while (rows.next()) {
                    if ("SERVICE".equals(rows.getString("item_type"))) {
                        Service4 service = new Service4();
                        service.setId(rows.getString("catalog_id")); service.setServiceCode(rows.getString("item_code"));
                        service.setServiceName(rows.getString("item_name"));
                        ServiceRequest4 request = new ServiceRequest4();
                        request.setService(service); request.setQuantity(rows.getInt("quantity"));
                        request.setUnitPrice(rows.getBigDecimal("unit_price")); request.setServiceReception(reception);
                        reception.getServiceRequests().add(request);
                    } else {
                        SparePart4 part = new SparePart4();
                        part.setId(rows.getString("catalog_id")); part.setPartCode(rows.getString("item_code"));
                        part.setPartName(rows.getString("item_name")); part.setUnit(rows.getString("unit"));
                        SparePartRequest4 request = new SparePartRequest4();
                        request.setSparePart(part); request.setQuantity(rows.getInt("quantity"));
                        request.setActualUsedQuantity(rows.getInt("quantity")); request.setUnitPrice(rows.getBigDecimal("unit_price"));
                        request.setServiceReception(reception); reception.getSpareParts().add(request);
                    }
                }
            }
        }
    }

    public void addItem(String invoiceId, String type, String itemId, int quantity) throws SQLException {
        if (!"SERVICE".equals(type) && !"SPARE_PART".equals(type)) {
            throw new IllegalArgumentException("Loại hạng mục không hợp lệ.");
        }
        try (Connection connection = openConnection()) {
            connection.setAutoCommit(false);
            try {
                InvoiceMeta meta = findInvoiceMeta(connection, invoiceId);
                if (meta == null) {
                    throw new IllegalStateException("Không tìm thấy hóa đơn: " + invoiceId);
                }
                if (!"UNPAID".equalsIgnoreCase(meta.paymentStatus)) {
                    throw new IllegalStateException("Hóa đơn đã thanh toán, không thể chỉnh sửa.");
                }
                String realInvoiceId = meta.id;

                String itemCode;
                String itemName;
                String unit;
                BigDecimal unitPrice;
                if ("SERVICE".equals(type)) {
                    ServiceRequest4 request = ServiceRequestDAO4.addServiceRequest(
                            connection, meta.receptionId, itemId, quantity);
                    itemCode = request.getService().getServiceCode();
                    itemName = request.getService().getServiceName();
                    unit = "Lần";
                    unitPrice = request.getUnitPrice();
                } else {
                    SparePartRequest4 request = SparePartRequestDAO4.addSparePartRequest(
                            connection, meta.receptionId, itemId, quantity);
                    itemCode = request.getSparePart().getPartCode();
                    itemName = request.getSparePart().getPartName();
                    unit = request.getSparePart().getUnit();
                    unitPrice = request.getUnitPrice();
                }

                // Kiểm tra xem dòng hạng mục này đã có trên hóa đơn chưa
                String checkLineSql = "SELECT id, quantity, unit_price FROM invoice_lines WHERE invoice_id = ? AND item_code = ? LIMIT 1";
                boolean updated = false;
                try (PreparedStatement checkStmt = connection.prepareStatement(checkLineSql)) {
                    checkStmt.setString(1, realInvoiceId);
                    checkStmt.setString(2, itemCode);
                    try (ResultSet rs = checkStmt.executeQuery()) {
                        if (rs.next()) {
                            String lineId = rs.getString("id");
                            int newQty = rs.getInt("quantity") + quantity;
                            BigDecimal existingUnitPrice = rs.getBigDecimal("unit_price");
                            BigDecimal newLineTotal = existingUnitPrice.multiply(BigDecimal.valueOf(newQty));
                            try (PreparedStatement updateStmt = connection.prepareStatement(
                                    "UPDATE invoice_lines SET quantity = ?, line_total = ? WHERE id = ?")) {
                                updateStmt.setInt(1, newQty);
                                updateStmt.setBigDecimal(2, newLineTotal);
                                updateStmt.setString(3, lineId);
                                updateStmt.executeUpdate();
                                updated = true;
                            }
                        }
                    }
                }

                if (!updated) {
                    String sql = """
                            INSERT INTO invoice_lines (id, invoice_id, item_type, catalog_id, item_code, item_name,
                                unit, quantity, unit_price, line_total) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
                            """;
                    try (PreparedStatement statement = connection.prepareStatement(sql)) {
                        statement.setString(1, UUID.randomUUID().toString());
                        statement.setString(2, realInvoiceId);
                        statement.setString(3, type);
                        statement.setString(4, itemId);
                        statement.setString(5, itemCode);
                        statement.setString(6, itemName);
                        statement.setString(7, unit);
                        statement.setInt(8, quantity);
                        statement.setBigDecimal(9, unitPrice);
                        statement.setBigDecimal(10, unitPrice.multiply(BigDecimal.valueOf(quantity)));
                        statement.executeUpdate();
                    }
                }

                refreshTotals(connection, realInvoiceId);

                // Sau khi bổ sung mục mới vào hóa đơn chưa thanh toán, cập nhật trạng thái hóa đơn về DRAFT để NV có thể xác nhận lại
                try (PreparedStatement updateStatus = connection.prepareStatement(
                        "UPDATE invoices SET invoice_status = 'DRAFT' WHERE id = ?")) {
                    updateStatus.setString(1, realInvoiceId);
                    updateStatus.executeUpdate();
                }

                connection.commit();
            } catch (SQLException | RuntimeException exception) {
                connection.rollback();
                throw exception;
            }
        }
    }

    private BigDecimal requireInvoice(Connection connection, String invoiceId, String requiredStatus) throws SQLException {
        InvoiceMeta meta = findInvoiceMeta(connection, invoiceId);
        if (meta == null) {
            throw new IllegalStateException("Không tìm thấy hóa đơn: " + invoiceId);
        }
        if (!"UNPAID".equalsIgnoreCase(meta.paymentStatus)) {
            throw new IllegalStateException("Hóa đơn đã thanh toán, không thể thao tác.");
        }
        return meta.totalAmount;
    }

    private void refreshTotals(Connection connection, String invoiceId) throws SQLException {
        String sumSql = """
                SELECT COALESCE(SUM(CASE WHEN item_type = 'SERVICE' THEN line_total ELSE 0 END), 0),
                       COALESCE(SUM(CASE WHEN item_type = 'SPARE_PART' THEN line_total ELSE 0 END), 0)
                FROM invoice_lines WHERE invoice_id = ?
                """;
        try (PreparedStatement statement = connection.prepareStatement(sumSql)) {
            statement.setString(1, invoiceId);
            try (ResultSet rows = statement.executeQuery()) {
                rows.next();
                BigDecimal services = rows.getBigDecimal(1);
                BigDecimal parts = rows.getBigDecimal(2);
                try (PreparedStatement update = connection.prepareStatement("""
                        UPDATE invoices SET service_total = ?, spare_part_total = ?,
                            total_amount = ? + ? - discount_amount WHERE id = ?
                        """)) {
                    update.setBigDecimal(1, services);
                    update.setBigDecimal(2, parts);
                    update.setBigDecimal(3, services);
                    update.setBigDecimal(4, parts);
                    update.setString(5, invoiceId);
                    update.executeUpdate();
                }
            }
        }
    }

    public void confirm(String invoiceId, String staffId) throws SQLException {
        try (Connection connection = openConnection()) {
            connection.setAutoCommit(false);
            try {
                InvoiceMeta meta = findInvoiceMeta(connection, invoiceId);
                if (meta == null) {
                    throw new IllegalStateException("Không tìm thấy hóa đơn: " + invoiceId);
                }
                if (!"UNPAID".equalsIgnoreCase(meta.paymentStatus)) {
                    throw new IllegalStateException("Hóa đơn đã thanh toán, không thể xác nhận.");
                }
                String realInvoiceId = meta.id;

                try (PreparedStatement check = connection.prepareStatement("SELECT COUNT(*) FROM invoice_lines WHERE invoice_id = ?")) {
                    check.setString(1, realInvoiceId);
                    try (ResultSet rows = check.executeQuery()) {
                        rows.next();
                        if (rows.getInt(1) == 0) { throw new IllegalStateException("Hóa đơn chưa có hạng mục."); }
                    }
                }
                refreshTotals(connection, realInvoiceId);
                try (PreparedStatement update = connection.prepareStatement(
                        "UPDATE invoices SET invoice_status = 'CONFIRMED', sales_staff_id = COALESCE(?, sales_staff_id) WHERE id = ?")) {
                    update.setString(1, staffId);
                    update.setString(2, realInvoiceId);
                    update.executeUpdate();
                }
                connection.commit();
            } catch (SQLException | RuntimeException exception) {
                connection.rollback(); throw exception;
            }
        }
    }

    public void pay(String invoiceId, String staffId, String method, BigDecimal received) throws SQLException {
        if (!"CASH".equals(method) && !"BANK_TRANSFER".equals(method) && !"CARD".equals(method)) {
            throw new IllegalArgumentException("Phương thức thanh toán không hợp lệ.");
        }
        try (Connection connection = openConnection()) {
            connection.setAutoCommit(false);
            try {
                InvoiceMeta meta = findInvoiceMeta(connection, invoiceId);
                if (meta == null) {
                    throw new IllegalStateException("Không tìm thấy hóa đơn: " + invoiceId);
                }
                if ("PAID".equalsIgnoreCase(meta.paymentStatus)) {
                    throw new IllegalStateException("Hóa đơn đã được thanh toán.");
                }
                String realInvoiceId = meta.id;
                BigDecimal amount = meta.totalAmount;
                if (received.compareTo(amount) < 0) {
                    throw new IllegalArgumentException("Số tiền nhận chưa đủ để thanh toán hóa đơn.");
                }
                try (PreparedStatement insert = connection.prepareStatement("""
                        INSERT INTO payments (id, invoice_id, amount, amount_received, payment_method, paid_at, sales_staff_id)
                        VALUES (?, ?, ?, ?, ?, ?, ?)
                        """)) {
                    insert.setString(1, UUID.randomUUID().toString());
                    insert.setString(2, realInvoiceId);
                    insert.setBigDecimal(3, amount);
                    insert.setBigDecimal(4, received);
                    insert.setString(5, method);
                    insert.setTimestamp(6, Timestamp.valueOf(java.time.LocalDateTime.now()));
                    insert.setString(7, staffId);
                    insert.executeUpdate();
                }
                try (PreparedStatement update = connection.prepareStatement("""
                        UPDATE invoices SET payment_status = 'PAID', payment_method = ?, paid_at = CURRENT_TIMESTAMP,
                               sales_staff_id = COALESCE(?, sales_staff_id) WHERE id = ?
                        """)) {
                    update.setString(1, method);
                    update.setString(2, staffId);
                    update.setString(3, realInvoiceId);
                    update.executeUpdate();
                }
                connection.commit();
            } catch (SQLException | RuntimeException exception) {
                connection.rollback(); throw exception;
            }
        }
    }
}
