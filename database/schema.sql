-- =============================================================================
-- Schema Garage chuẩn 1:1 theo Sơ đồ Thiết kế Lớp (Class Diagram)
-- Phiên bản MySQL 8.0.16+
-- =============================================================================

-- 1. Bảng persons (tương ứng Person4)
CREATE TABLE persons (
    id VARCHAR(36) NOT NULL,
    full_name VARCHAR(160) NOT NULL,
    date_of_birth DATE,
    gender VARCHAR(30),
    phone_number VARCHAR(30),
    email VARCHAR(254),
    address VARCHAR(500),
    PRIMARY KEY (id),
    KEY idx_persons_name (full_name)
);

-- 2. Bảng accounts (tương ứng Account4)
CREATE TABLE accounts (
    id VARCHAR(36) NOT NULL,
    username VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(40) NOT NULL DEFAULT 'SALES',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_accounts_username (username)
);

-- 3. Bảng customers (tương ứng Customer4 kế thừa Person4)
CREATE TABLE customers (
    person_id VARCHAR(36) NOT NULL,
    customer_code VARCHAR(40) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (person_id),
    UNIQUE KEY uq_customers_code (customer_code),
    CONSTRAINT fk_customers_person FOREIGN KEY (person_id) REFERENCES persons (id) ON DELETE CASCADE
);

-- 4. Bảng staff_users (tương ứng User4 kế thừa Person4, liên kết Account4)
CREATE TABLE staff_users (
    person_id VARCHAR(36) NOT NULL,
    account_id VARCHAR(36) NOT NULL,
    start_date DATE,
    work_shift VARCHAR(80),
    employment_status VARCHAR(40) NOT NULL DEFAULT 'ACTIVE',
    PRIMARY KEY (person_id),
    UNIQUE KEY uq_staff_users_account (account_id),
    CONSTRAINT fk_staff_users_person FOREIGN KEY (person_id) REFERENCES persons (id) ON DELETE CASCADE,
    CONSTRAINT fk_staff_users_account FOREIGN KEY (account_id) REFERENCES accounts (id) ON DELETE CASCADE
);

-- 5. Bảng technicians (tương ứng Technician4 kế thừa User4)
CREATE TABLE technicians (
    user_id VARCHAR(36) NOT NULL,
    specialization VARCHAR(160),
    skill_level VARCHAR(80),
    PRIMARY KEY (user_id),
    CONSTRAINT fk_technicians_user FOREIGN KEY (user_id) REFERENCES staff_users (person_id) ON DELETE CASCADE
);

-- 6. Bảng managers (tương ứng Manager4 kế thừa User4)
CREATE TABLE managers (
    user_id VARCHAR(36) NOT NULL,
    management_level VARCHAR(80),
    PRIMARY KEY (user_id),
    CONSTRAINT fk_managers_user FOREIGN KEY (user_id) REFERENCES staff_users (person_id) ON DELETE CASCADE
);

-- 7. Bảng sales_staff (tương ứng SalesStaff4 kế thừa User4)
CREATE TABLE sales_staff (
    user_id VARCHAR(36) NOT NULL,
    sales_staff_code VARCHAR(40) NOT NULL,
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_sales_staff_code (sales_staff_code),
    CONSTRAINT fk_sales_staff_user FOREIGN KEY (user_id) REFERENCES staff_users (person_id) ON DELETE CASCADE
);

-- 8. Bảng warehouse_staff (tương ứng WarehouseStaff4 kế thừa User4)
CREATE TABLE warehouse_staff (
    user_id VARCHAR(36) NOT NULL,
    assigned_warehouse_area VARCHAR(160),
    PRIMARY KEY (user_id),
    CONSTRAINT fk_warehouse_staff_user FOREIGN KEY (user_id) REFERENCES staff_users (person_id) ON DELETE CASCADE
);

-- 9. Bảng vehicles (tương ứng Vehicle4)
CREATE TABLE vehicles (
    id VARCHAR(36) NOT NULL,
    customer_id VARCHAR(36) NOT NULL,
    license_plate VARCHAR(30) NOT NULL,
    chassis_number VARCHAR(80),
    make VARCHAR(120) NOT NULL,
    model VARCHAR(120) NOT NULL,
    manufacture_year INT,
    color VARCHAR(60),
    PRIMARY KEY (id),
    UNIQUE KEY uq_vehicles_plate (license_plate),
    KEY idx_vehicles_customer (customer_id),
    CONSTRAINT fk_vehicles_customer FOREIGN KEY (customer_id) REFERENCES customers (person_id) ON DELETE CASCADE
);

-- 10. Bảng appointments (tương ứng Appointment4)
CREATE TABLE appointments (
    id VARCHAR(36) NOT NULL,
    scheduled_at DATE NOT NULL,
    request_description TEXT,
    booking_channel VARCHAR(40),
    appointment_status VARCHAR(40) NOT NULL DEFAULT 'PENDING',
    vehicle_id VARCHAR(36) NOT NULL,
    PRIMARY KEY (id),
    KEY idx_appointments_vehicle (vehicle_id),
    KEY idx_appointments_scheduled (scheduled_at),
    CONSTRAINT fk_appointments_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id) ON DELETE CASCADE
);

-- 11. Bảng service_categories (tương ứng ServiceCategory4)
CREATE TABLE service_categories (
    id VARCHAR(36) NOT NULL,
    category_name VARCHAR(120) NOT NULL,
    description TEXT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_service_categories_name (category_name)
);

-- 12. Bảng services (tương ứng Service4)
CREATE TABLE services (
    id VARCHAR(36) NOT NULL,
    service_code VARCHAR(40) NOT NULL,
    service_name VARCHAR(160) NOT NULL,
    image_url VARCHAR(500),
    description TEXT,
    price DECIMAL(15, 2) NOT NULL,
    availability_status VARCHAR(20) NOT NULL DEFAULT 'AVAILABLE',
    category_id VARCHAR(36) NOT NULL,
    estimated_minutes INT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_services_code (service_code),
    KEY idx_services_name (service_name),
    KEY idx_services_category (category_id),
    CONSTRAINT fk_services_category FOREIGN KEY (category_id) REFERENCES service_categories (id)
);

-- 13. Bảng spare_part_categories (tương ứng SparePartCategory4)
CREATE TABLE spare_part_categories (
    id VARCHAR(36) NOT NULL,
    category_name VARCHAR(120) NOT NULL,
    description TEXT,
    PRIMARY KEY (id),
    UNIQUE KEY uq_spare_part_categories_name (category_name)
);

-- 14. Bảng spare_parts (tương ứng SparePart4)
CREATE TABLE spare_parts (
    id VARCHAR(36) NOT NULL,
    part_code VARCHAR(40) NOT NULL,
    part_name VARCHAR(160) NOT NULL,
    image_url VARCHAR(500),
    brand VARCHAR(120),
    origin VARCHAR(120),
    specifications TEXT,
    unit VARCHAR(40) NOT NULL,
    description TEXT,
    selling_price DECIMAL(15, 2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    warranty_period INT NOT NULL DEFAULT 0,
    business_status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE',
    category_id VARCHAR(36),
    PRIMARY KEY (id),
    UNIQUE KEY uq_spare_parts_code (part_code),
    KEY idx_spare_parts_name (part_name),
    KEY idx_spare_parts_category (category_id),
    CONSTRAINT fk_spare_parts_category FOREIGN KEY (category_id) REFERENCES spare_part_categories (id)
);

-- 15. Bảng service_receptions (tương ứng ServiceReception4)
CREATE TABLE service_receptions (
    id VARCHAR(36) NOT NULL,
    receive_at DATE NOT NULL,
    actual_delivery_at DATE,
    status VARCHAR(40) NOT NULL,
    description TEXT,
    vehicle_id VARCHAR(36) NOT NULL,
    appointment_id VARCHAR(36),
    sales_staff_id VARCHAR(36),
    technician_id VARCHAR(36),
    PRIMARY KEY (id),
    KEY idx_receptions_vehicle (vehicle_id),
    KEY idx_receptions_appointment (appointment_id),
    KEY idx_receptions_sales_staff (sales_staff_id),
    KEY idx_receptions_technician (technician_id),
    CONSTRAINT fk_receptions_vehicle FOREIGN KEY (vehicle_id) REFERENCES vehicles (id),
    CONSTRAINT fk_receptions_appointment FOREIGN KEY (appointment_id) REFERENCES appointments (id),
    CONSTRAINT fk_receptions_sales_staff FOREIGN KEY (sales_staff_id) REFERENCES sales_staff (user_id),
    CONSTRAINT fk_receptions_technician FOREIGN KEY (technician_id) REFERENCES technicians (user_id)
);

-- 16. Bảng service_requests (tương ứng ServiceRequest4)
CREATE TABLE service_requests (
    id VARCHAR(36) NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    unit_price DECIMAL(15, 2) NOT NULL,
    customer_approval_status VARCHAR(40) NOT NULL DEFAULT 'APPROVED',
    fulfillment_status VARCHAR(40) NOT NULL DEFAULT 'PENDING',
    notes TEXT,
    service_id VARCHAR(36) NOT NULL,
    reception_id VARCHAR(36) NOT NULL,
    technician_id VARCHAR(36),
    PRIMARY KEY (id),
    KEY idx_service_requests_reception (reception_id),
    KEY idx_service_requests_service (service_id),
    KEY idx_service_requests_technician (technician_id),
    CONSTRAINT fk_service_requests_reception FOREIGN KEY (reception_id) REFERENCES service_receptions (id) ON DELETE CASCADE,
    CONSTRAINT fk_service_requests_service FOREIGN KEY (service_id) REFERENCES services (id),
    CONSTRAINT fk_service_requests_technician FOREIGN KEY (technician_id) REFERENCES technicians (user_id)
);

-- 16b. Bảng liên kết service_request_technicians (tương ứng technicians: Technician[] trong ServiceRequest4)
CREATE TABLE service_request_technicians (
    service_request_id VARCHAR(36) NOT NULL,
    technician_id VARCHAR(36) NOT NULL,
    assigned_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (service_request_id, technician_id),
    KEY idx_srt_technician (technician_id),
    CONSTRAINT fk_srt_request FOREIGN KEY (service_request_id) REFERENCES service_requests (id) ON DELETE CASCADE,
    CONSTRAINT fk_srt_technician FOREIGN KEY (technician_id) REFERENCES technicians (user_id) ON DELETE CASCADE
);

-- 17. Bảng spare_part_requests (tương ứng SparePartRequest4)
CREATE TABLE spare_part_requests (
    id VARCHAR(36) NOT NULL,
    actual_used_quantity INT NOT NULL DEFAULT 0,
    unit_price DECIMAL(15, 2) NOT NULL,
    spare_part_id VARCHAR(36) NOT NULL,
    reception_id VARCHAR(36) NOT NULL,
    service_request_id VARCHAR(36),
    quantity INT NOT NULL DEFAULT 1,
    customer_approval_status VARCHAR(40) NOT NULL DEFAULT 'APPROVED',
    notes TEXT,
    PRIMARY KEY (id),
    KEY idx_part_requests_reception (reception_id),
    KEY idx_part_requests_part (spare_part_id),
    KEY idx_part_requests_service_request (service_request_id),
    CONSTRAINT fk_part_requests_reception FOREIGN KEY (reception_id) REFERENCES service_receptions (id) ON DELETE CASCADE,
    CONSTRAINT fk_part_requests_part FOREIGN KEY (spare_part_id) REFERENCES spare_parts (id),
    CONSTRAINT fk_part_requests_service_request FOREIGN KEY (service_request_id) REFERENCES service_requests (id) ON DELETE SET NULL
);

-- 18. Bảng invoices (tương ứng Invoice4)
CREATE TABLE invoices (
    id VARCHAR(36) NOT NULL,
    invoice_number VARCHAR(50) NOT NULL,
    issued_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    service_total DECIMAL(15, 2) NOT NULL DEFAULT 0,
    spare_part_total DECIMAL(15, 2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(15, 2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(15, 2) NOT NULL DEFAULT 0,
    invoice_status VARCHAR(40) NOT NULL DEFAULT 'DRAFT',
    payment_status VARCHAR(40) NOT NULL DEFAULT 'UNPAID',
    payment_method VARCHAR(40),
    paid_at DATETIME,
    reception_id VARCHAR(36) NOT NULL,
    sales_staff_id VARCHAR(36),
    PRIMARY KEY (id),
    UNIQUE KEY uq_invoices_number (invoice_number),
    UNIQUE KEY uq_invoices_reception (reception_id),
    KEY idx_invoices_sales_staff (sales_staff_id),
    CONSTRAINT fk_invoices_reception FOREIGN KEY (reception_id) REFERENCES service_receptions (id),
    CONSTRAINT fk_invoices_sales_staff FOREIGN KEY (sales_staff_id) REFERENCES sales_staff (user_id)
);

-- 19. Bảng dòng chi tiết hóa đơn
CREATE TABLE invoice_lines (
    id VARCHAR(36) NOT NULL,
    invoice_id VARCHAR(36) NOT NULL,
    item_type VARCHAR(20) NOT NULL,
    catalog_id VARCHAR(36) NOT NULL,
    item_code VARCHAR(40) NOT NULL,
    item_name VARCHAR(160) NOT NULL,
    unit VARCHAR(40) NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(15, 2) NOT NULL,
    line_total DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (id),
    KEY idx_invoice_lines_invoice (invoice_id),
    CONSTRAINT fk_invoice_lines_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (id) ON DELETE CASCADE
);

-- 20. Bảng phụ trợ payments (lưu lịch sử giao dịch thanh toán)
CREATE TABLE payments (
    id VARCHAR(36) NOT NULL,
    invoice_id VARCHAR(36) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    amount_received DECIMAL(15, 2) NOT NULL,
    payment_method VARCHAR(40) NOT NULL,
    paid_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    sales_staff_id VARCHAR(36) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_payments_invoice (invoice_id),
    CONSTRAINT fk_payments_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (id),
    CONSTRAINT fk_payments_staff FOREIGN KEY (sales_staff_id) REFERENCES sales_staff (user_id)
);

-- 21. Bảng suppliers (tương ứng Supplier4)
CREATE TABLE suppliers (
    id VARCHAR(36) NOT NULL,
    supplier_name VARCHAR(160) NOT NULL,
    tax_code VARCHAR(40),
    address VARCHAR(500),
    phone_number VARCHAR(30),
    email VARCHAR(254),
    contact_person VARCHAR(160),
    cooperation_status VARCHAR(40) NOT NULL DEFAULT 'ACTIVE',
    PRIMARY KEY (id),
    UNIQUE KEY uq_suppliers_tax_code (tax_code),
    KEY idx_suppliers_name (supplier_name)
);

-- 22. Bảng goods_receipts (tương ứng GoodsReceipt4)
CREATE TABLE goods_receipts (
    id VARCHAR(36) NOT NULL,
    receipt_code VARCHAR(50) NOT NULL,
    confirmed_at DATETIME,
    delivery_note_number VARCHAR(80),
    receipt_status VARCHAR(20) NOT NULL DEFAULT 'DRAFT',
    total_amount DECIMAL(15, 2) NOT NULL DEFAULT 0,
    notes TEXT,
    supplier_id VARCHAR(36) NOT NULL,
    warehouse_staff_id VARCHAR(36),
    PRIMARY KEY (id),
    UNIQUE KEY uq_goods_receipts_code (receipt_code),
    KEY idx_goods_receipts_supplier (supplier_id),
    KEY idx_goods_receipts_staff (warehouse_staff_id),
    CONSTRAINT fk_goods_receipts_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers (id),
    CONSTRAINT fk_goods_receipts_staff FOREIGN KEY (warehouse_staff_id) REFERENCES warehouse_staff (user_id)
);

-- 23. Bảng goods_receipt_details (tương ứng GoodsReceiptDetail4)
CREATE TABLE goods_receipt_details (
    id VARCHAR(36) NOT NULL,
    goods_receipt_id VARCHAR(36) NOT NULL,
    spare_part_id VARCHAR(36) NOT NULL,
    received_quantity INT NOT NULL,
    purchase_unit_price DECIMAL(15, 2) NOT NULL,
    line_total DECIMAL(15, 2) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_receipt_details_part (goods_receipt_id, spare_part_id),
    KEY idx_receipt_details_part (spare_part_id),
    CONSTRAINT fk_receipt_details_receipt FOREIGN KEY (goods_receipt_id) REFERENCES goods_receipts (id) ON DELETE CASCADE,
    CONSTRAINT fk_receipt_details_part FOREIGN KEY (spare_part_id) REFERENCES spare_parts (id)
);

-- =============================================================================
-- CÁC VIEW THỐNG KÊ (Tương ứng 4 class Statistics trong sơ đồ)
-- =============================================================================

-- View customer_statistics (tương ứng CustomerStatistics4)
CREATE OR REPLACE VIEW customer_statistics AS
SELECT 
    COUNT(*) AS total_customers,
    COALESCE(SUM(CASE WHEN YEAR(created_at) = YEAR(CURRENT_DATE)
                      AND MONTH(created_at) = MONTH(CURRENT_DATE) THEN 1 ELSE 0 END), 0) AS new_customers
FROM customers;

-- View service_statistics (tương ứng ServiceStatistics4)
CREATE OR REPLACE VIEW service_statistics AS
SELECT 
    (SELECT COUNT(*) FROM service_requests) AS total_service_requests,
    (SELECT COALESCE(SUM(service_total), 0) FROM invoices WHERE payment_status = 'PAID') AS total_service_revenue;

-- View supplier_statistics (tương ứng SupplierStatistics4)
CREATE OR REPLACE VIEW supplier_statistics AS
SELECT 
    COUNT(*) AS total_receipts,
    COALESCE(SUM(total_amount), 0) AS total_purchase_amount
FROM goods_receipts 
WHERE receipt_status = 'CONFIRMED';

-- View spare_part_statistics (tương ứng SparePartStatistics4)
CREATE OR REPLACE VIEW spare_part_statistics AS
SELECT 
    (SELECT COALESCE(SUM(r.actual_used_quantity), 0)
     FROM spare_part_requests r
     JOIN invoices i ON i.reception_id = r.reception_id
     WHERE i.payment_status = 'PAID') AS total_parts_sold,
    (SELECT COALESCE(SUM(spare_part_total), 0) FROM invoices WHERE payment_status = 'PAID') AS total_spare_part_revenue;
