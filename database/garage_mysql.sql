-- =============================================================================
-- File gộp cài đặt Garage Database MySQL 8.0+
-- Tự động DROP và CREATE lại DATABASE garage
-- Khớp 1:1 theo Sơ đồ Thiết kế Lớp (Class Diagram) & Wireframe
-- =============================================================================

CREATE DATABASE IF NOT EXISTS garage CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE garage;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS service_request_technicians;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS invoice_lines;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS spare_part_requests;
DROP TABLE IF EXISTS service_requests;
DROP TABLE IF EXISTS service_receptions;
DROP TABLE IF EXISTS appointments;
DROP TABLE IF EXISTS goods_receipt_details;
DROP TABLE IF EXISTS goods_receipts;
DROP TABLE IF EXISTS spare_parts;
DROP TABLE IF EXISTS spare_part_categories;
DROP TABLE IF EXISTS services;
DROP TABLE IF EXISTS service_categories;
DROP TABLE IF EXISTS vehicles;
DROP TABLE IF EXISTS warehouse_staff;
DROP TABLE IF EXISTS sales_staff;
DROP TABLE IF EXISTS managers;
DROP TABLE IF EXISTS technicians;
DROP TABLE IF EXISTS staff_users;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS persons;
DROP TABLE IF EXISTS suppliers;
DROP VIEW IF EXISTS customer_statistics;
DROP VIEW IF EXISTS service_statistics;
DROP VIEW IF EXISTS supplier_statistics;
DROP VIEW IF EXISTS spare_part_statistics;
SET FOREIGN_KEY_CHECKS = 1;



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


-- =============================================================================
-- Dữ liệu mẫu (Seed Data) chuẩn theo Sơ đồ Thiết kế Lớp & Wireframe
-- =============================================================================

-- 1. Danh mục dịch vụ & Dịch vụ
INSERT INTO service_categories (id, category_name, description) VALUES
    ('cat-maintenance', 'Bảo dưỡng', 'Dịch vụ bảo dưỡng định kỳ'),
    ('cat-repair', 'Sửa chữa', 'Kiểm tra và sửa chữa xe');

INSERT INTO services (id, service_code, service_name, image_url, description, price, availability_status, category_id, estimated_minutes) VALUES
    ('svc-oil-change', 'DV01', 'Thay dầu động cơ', 'oil.jpg', 'Thay dầu động cơ định kỳ', 100000.00, 'AVAILABLE', 'cat-maintenance', 45),
    ('svc-inject-clean', 'DV02', 'Vệ sinh kim phun', 'inject.jpg', 'Vệ sinh kim phun điện tử và họng hút', 200000.00, 'AVAILABLE', 'cat-repair', 40),
    ('svc-air-filter-check', 'DV03', 'Kiểm tra lọc gió', 'air_filter.jpg', 'Kiểm tra vệ sinh lọc gió động cơ', 80000.00, 'AVAILABLE', 'cat-maintenance', 20),
    ('svc-brake-check', 'DV04', 'Kiểm tra hệ thống phanh', 'brake.jpg', 'Kiểm tra má phanh và đĩa phanh', 150000.00, 'AVAILABLE', 'cat-repair', 30),
    ('svc-wheel-align', 'DV05', 'Cân chỉnh thước lái', 'wheel_align.jpg', 'Cân chỉnh góc đặt bánh xe giúp xe chạy ổn định', 350000.00, 'AVAILABLE', 'cat-repair', 60),
    ('svc-battery-check', 'DV06', 'Kiểm tra ắc quy', 'battery_check.jpg', 'Kiểm tra điện áp và khả năng nạp của ắc quy', 50000.00, 'AVAILABLE', 'cat-maintenance', 20),
    ('svc-aircon-clean', 'DV07', 'Vệ sinh điều hòa', 'aircon_clean.jpg', 'Vệ sinh dàn lạnh và khử mùi hệ thống điều hòa', 300000.00, 'AVAILABLE', 'cat-maintenance', 75),
    ('svc-tire-rotate', 'DV08', 'Đảo lốp xe', 'tire_rotate.jpg', 'Đảo vị trí lốp giúp lốp mòn đều', 180000.00, 'AVAILABLE', 'cat-maintenance', 45),
    ('svc-engine-scan', 'DV09', 'Chẩn đoán lỗi động cơ', 'engine_scan.jpg', 'Đọc lỗi bằng máy chẩn đoán chuyên dụng', 250000.00, 'AVAILABLE', 'cat-repair', 40),
    ('svc-brake-fluid', 'DV10', 'Thay dầu phanh', 'brake_fluid.jpg', 'Thay dầu phanh và xả khí hệ thống phanh', 220000.00, 'AVAILABLE', 'cat-maintenance', 50),
    ('svc-spark-plug', 'DV11', 'Thay bugi đánh lửa', 'spark_plug.jpg', 'Kiểm tra và thay bugi theo định kỳ', 280000.00, 'AVAILABLE', 'cat-maintenance', 45);

-- 2. Danh mục phụ tùng & Phụ tùng
INSERT INTO spare_part_categories (id, category_name, description) VALUES
    ('spcat-dau', 'Dầu nhớt & Dung dịch', 'Các loại dầu nhớt và dung dịch làm mát'),
    ('spcat-loc', 'Lọc động cơ', 'Các loại lọc dầu, lọc gió');

INSERT INTO spare_parts (id, part_code, part_name, image_url, brand, origin, specifications, unit,
                         description, selling_price, stock_quantity, warranty_period, business_status, category_id) VALUES
    ('part-oil-5w30', 'PT01', 'Dầu động cơ 5W-30', 'oil_5w30.jpg', 'Castrol', 'Việt Nam', 'Dầu tổng hợp toàn phần 5W-30', 'Lít',
     'Dầu nhớt bôi trơn động cơ', 250000.00, 100, 6, 'ACTIVE', 'spcat-dau'),
    ('part-oil-filter', 'PT02', 'Lọc dầu động cơ A', 'oil_filter.jpg', 'Denso', 'Nhật Bản', 'Lọc dầu tiêu chuẩn OEM', 'Chiếc',
     'Lọc dầu bảo dưỡng động cơ', 150000.00, 45, 6, 'ACTIVE', 'spcat-loc'),
    ('part-coolant', 'PT03', 'Nước làm mát', 'coolant.jpg', 'Prestone', 'Mỹ', 'Dung dịch làm mát động cơ', 'Lít',
     'Nước làm mát tuổi thọ cao', 120000.00, 50, 12, 'ACTIVE', 'spcat-dau'),
    ('part-air-filter', 'PT04', 'Lọc gió động cơ', 'air_filter_part.jpg', 'Toyota OEM', 'Thái Lan', 'Lọc gió giấy gấp', 'Chiếc',
     'Lọc gió bảo vệ động cơ', 180000.00, 30, 6, 'ACTIVE', 'spcat-loc'),
    ('part-brake-pad', 'PT05', 'Má phanh trước', 'brake_pad.jpg', 'Akebono', 'Nhật Bản', 'Bộ má phanh gốm cao cấp', 'bộ',
     'Má phanh trước cho xe sedan', 750000.00, 12, 12, 'ACTIVE', 'spcat-loc'),
    ('part-battery-45ah', 'PT06', 'Ắc quy 45Ah', 'battery_45ah.jpg', 'GS', 'Việt Nam', 'Ắc quy khô 12V 45Ah', 'Bình', 'Ắc quy khởi động cho xe sedan cỡ nhỏ', 1450000.00, 18, 12, 'ACTIVE', 'spcat-loc'),
    ('part-wiper-blade', 'PT07', 'Gạt mưa silicon', 'wiper_blade.jpg', 'Bosch', 'Đức', 'Gạt mưa silicon 24 inch', 'Cặp', 'Gạt mưa chống ồn, bám kính tốt', 320000.00, 36, 6, 'ACTIVE', 'spcat-loc'),
    ('part-brake-fluid', 'PT08', 'Dầu phanh DOT 4', 'brake_fluid_dot4.jpg', 'Bosch', 'Đức', 'Dầu phanh DOT 4, chai 500ml', 'Chai', 'Dầu phanh chịu nhiệt cao', 180000.00, 40, 24, 'ACTIVE', 'spcat-dau'),
    ('part-spark-plug', 'PT09', 'Bugi iridium', 'spark_plug_iridium.jpg', 'NGK', 'Nhật Bản', 'Bugi iridium chân dài', 'Chiếc', 'Bugi đánh lửa tuổi thọ cao', 220000.00, 60, 12, 'ACTIVE', 'spcat-loc'),
    ('part-tire-195-65', 'PT10', 'Lốp 195/65R15', 'tire_195_65.jpg', 'Michelin', 'Thái Lan', 'Lốp xe du lịch 195/65R15', 'Lốp', 'Lốp êm ái cho sedan hạng C', 1850000.00, 16, 36, 'ACTIVE', 'spcat-loc'),
    ('part-atf-oil', 'PT11', 'Dầu hộp số tự động ATF', 'atf_oil.jpg', 'Toyota', 'Thái Lan', 'Dầu hộp số tự động ATF WS', 'Lít', 'Dầu hộp số cho xe số tự động', 290000.00, 28, 12, 'ACTIVE', 'spcat-dau'),
    ('part-headlamp-h7', 'PT12', 'Bóng đèn pha H7', 'headlamp_h7.jpg', 'Philips', 'Ba Lan', 'Bóng halogen H7 12V 55W', 'Chiếc', 'Bóng đèn pha ánh sáng trắng', 190000.00, 48, 6, 'ACTIVE', 'spcat-loc'),
    ('part-cabin-filter', 'PT13', 'Lọc gió điều hòa', 'cabin_filter.jpg', 'Denso', 'Nhật Bản', 'Lọc gió cabin than hoạt tính', 'Chiếc', 'Lọc bụi mịn và khử mùi điều hòa', 260000.00, 32, 6, 'ACTIVE', 'spcat-loc');

-- 3. Nhân sự (Persons, Accounts, StaffUsers, SalesStaff, Technicians, WarehouseStaff)
-- Tài khoản nhân viên bán hàng mặc định: sales / 123456
INSERT INTO persons (id, full_name, phone_number, email, address) VALUES
    ('sales-001', 'Trần Thị Bán Hàng', '0988111222', 'sales@garage.com', 'Hà Nội'),
    ('tech-001', 'Nguyễn Kỹ Thuật', '0988333444', 'tech@garage.com', 'Hà Nội'),
    ('wh-001', 'Trần Thủ Kho', '0988555666', 'warehouse@garage.com', 'Hà Nội');

INSERT INTO accounts (id, username, password_hash, role, created_at) VALUES
    ('account-sales-001', 'sales', '123456', 'SALES', CURRENT_TIMESTAMP),
    ('account-tech-001', 'tech', '123456', 'TECH', CURRENT_TIMESTAMP),
    ('account-wh-001', 'warehouse', '123456', 'WAREHOUSE', CURRENT_TIMESTAMP);

INSERT INTO staff_users (person_id, account_id, start_date, work_shift, employment_status) VALUES
    ('sales-001', 'account-sales-001', '2023-01-15', 'Ca sáng (8h-17h)', 'ACTIVE'),
    ('tech-001', 'account-tech-001', '2022-05-10', 'Ca sáng (8h-17h)', 'ACTIVE'),
    ('wh-001', 'account-wh-001', '2021-08-01', 'Ca hành chính', 'ACTIVE');

INSERT INTO sales_staff (user_id, sales_staff_code) VALUES
    ('sales-001', 'NV001');

INSERT INTO technicians (user_id, specialization, skill_level) VALUES
    ('tech-001', 'Máy gầm - Điện lạnh', 'Bậc 4/7');

INSERT INTO warehouse_staff (user_id, assigned_warehouse_area) VALUES
    ('wh-001', 'Kho Phụ Tùng Tổng');

-- 4. Khách hàng và Xe (Customers, Vehicles)
INSERT INTO persons (id, full_name, phone_number, email, address) VALUES
    ('customer-demo', 'Nguyễn Văn A', '0901234567', 'nguyenvana@gmail.com', '123 Cầu Giấy, Hà Nội');

INSERT INTO customers (person_id, customer_code, created_at) VALUES
    ('customer-demo', 'KH01', CURRENT_TIMESTAMP);

INSERT INTO vehicles (id, customer_id, license_plate, chassis_number, make, model, manufacture_year, color) VALUES
    ('vehicle-demo', 'customer-demo', '30A-12345', 'VN1234567890', 'Toyota', 'Camry', 2022, 'Đen');

-- 5. Lịch hẹn và Tiếp nhận dịch vụ (Appointments, ServiceReceptions)
INSERT INTO appointments (id, scheduled_at, request_description, booking_channel, appointment_status, vehicle_id) VALUES
    ('app-demo', CURRENT_DATE, 'Bảo dưỡng thay dầu định kỳ', 'ONLINE', 'CONFIRMED', 'vehicle-demo');

INSERT INTO service_receptions (id, receive_at, actual_delivery_at, status, description, vehicle_id, appointment_id, sales_staff_id, technician_id) VALUES
    ('reception-demo', CURRENT_DATE, CURRENT_DATE, 'IN_PROGRESS', 'Tiếp nhận xe bảo dưỡng thay dầu', 'vehicle-demo', 'app-demo', 'sales-001', 'tech-001');

-- 6. Yêu cầu dịch vụ & Yêu cầu phụ tùng (ServiceRequests, SparePartRequests)
INSERT INTO service_requests (id, quantity, unit_price, customer_approval_status, fulfillment_status, notes, service_id, reception_id, technician_id) VALUES
    ('req-svc-demo', 1, 100000.00, 'APPROVED', 'COMPLETED', 'Thay dầu động cơ hoàn tất', 'svc-oil-change', 'reception-demo', 'tech-001');

INSERT INTO service_request_technicians (service_request_id, technician_id, assigned_at) VALUES
    ('req-svc-demo', 'tech-001', CURRENT_TIMESTAMP);

INSERT INTO spare_part_requests (id, actual_used_quantity, unit_price, spare_part_id, reception_id, service_request_id, quantity, customer_approval_status, notes) VALUES
    ('req-part-demo', 1, 150000.00, 'part-oil-filter', 'reception-demo', 'req-svc-demo', 1, 'APPROVED', 'Đã thay lọc dầu động cơ A'),
    ('req-part-oil', 4, 250000.00, 'part-oil-5w30', 'reception-demo', 'req-svc-demo', 4, 'APPROVED', 'Đã châm 4 lít dầu 5W-30');

-- 7. Hóa đơn (Invoices, InvoiceLines)
INSERT INTO invoices (id, invoice_number, reception_id, sales_staff_id, issued_at, service_total,
                      spare_part_total, discount_amount, total_amount, invoice_status, payment_status) VALUES
    ('invoice-demo', 'HD001', 'reception-demo', 'sales-001', CURRENT_TIMESTAMP, 100000.00, 1150000.00, 0.00, 1250000.00, 'DRAFT', 'UNPAID');

INSERT INTO invoice_lines (id, invoice_id, item_type, catalog_id, item_code, item_name, unit, quantity, unit_price, line_total) VALUES
    ('line-svc-01', 'invoice-demo', 'SERVICE', 'svc-oil-change', 'DV01', 'Thay dầu động cơ', 'Lần', 1, 100000.00, 100000.00),
    ('line-pt-01', 'invoice-demo', 'SPARE_PART', 'part-oil-5w30', 'PT01', 'Dầu động cơ 5W-30', 'Lít', 4, 250000.00, 1000000.00),
    ('line-pt-02', 'invoice-demo', 'SPARE_PART', 'part-oil-filter', 'PT02', 'Lọc dầu động cơ A', 'Chiếc', 1, 150000.00, 150000.00);

-- 8. Nhà cung cấp và Nhập kho (Suppliers, GoodsReceipts, GoodsReceiptDetails)
INSERT INTO suppliers (id, supplier_name, tax_code, address, phone_number, email, contact_person, cooperation_status) VALUES
    ('sup-bosch', 'Công ty TNHH Phụ tùng Bosch Việt Nam', '0101234567', 'Tầng 12, Tòa nhà Keangnam, Hà Nội', '0243123456', 'contact@bosch.vn', 'Nguyễn Đại Diện', 'ACTIVE');

INSERT INTO goods_receipts (id, receipt_code, confirmed_at, delivery_note_number, receipt_status, total_amount, notes, supplier_id, warehouse_staff_id) VALUES
    ('gr-demo', 'NK2026-001', CURRENT_TIMESTAMP, 'PNK-001', 'CONFIRMED', 1800000.00, 'Nhập lô lọc dầu Denso', 'sup-bosch', 'wh-001');

INSERT INTO goods_receipt_details (id, goods_receipt_id, spare_part_id, received_quantity, purchase_unit_price, line_total) VALUES
    ('grd-demo', 'gr-demo', 'part-oil-filter', 10, 180000.00, 1800000.00);
