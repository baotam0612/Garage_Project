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
    ('part-battery-45ah', 'PT06', 'Ắc quy 45Ah', 'battery_45ah.jpg', 'GS', 'Việt Nam', 'Ắc quy khô 12V 45Ah', 'Bình',
     'Ắc quy khởi động cho xe sedan cỡ nhỏ', 1450000.00, 18, 12, 'ACTIVE', 'spcat-loc'),
    ('part-wiper-blade', 'PT07', 'Gạt mưa silicon', 'wiper_blade.jpg', 'Bosch', 'Đức', 'Gạt mưa silicon 24 inch', 'Cặp',
     'Gạt mưa chống ồn, bám kính tốt', 320000.00, 36, 6, 'ACTIVE', 'spcat-loc'),
    ('part-brake-fluid', 'PT08', 'Dầu phanh DOT 4', 'brake_fluid_dot4.jpg', 'Bosch', 'Đức', 'Dầu phanh DOT 4, chai 500ml', 'Chai',
     'Dầu phanh chịu nhiệt cao', 180000.00, 40, 24, 'ACTIVE', 'spcat-dau'),
    ('part-spark-plug', 'PT09', 'Bugi iridium', 'spark_plug_iridium.jpg', 'NGK', 'Nhật Bản', 'Bugi iridium chân dài', 'Chiếc',
     'Bugi đánh lửa tuổi thọ cao', 220000.00, 60, 12, 'ACTIVE', 'spcat-loc'),
    ('part-tire-195-65', 'PT10', 'Lốp 195/65R15', 'tire_195_65.jpg', 'Michelin', 'Thái Lan', 'Lốp xe du lịch 195/65R15', 'Lốp',
     'Lốp êm ái cho sedan hạng C', 1850000.00, 16, 36, 'ACTIVE', 'spcat-loc'),
    ('part-atf-oil', 'PT11', 'Dầu hộp số tự động ATF', 'atf_oil.jpg', 'Toyota', 'Thái Lan', 'Dầu hộp số tự động ATF WS', 'Lít',
     'Dầu hộp số cho xe số tự động', 290000.00, 28, 12, 'ACTIVE', 'spcat-dau'),
    ('part-headlamp-h7', 'PT12', 'Bóng đèn pha H7', 'headlamp_h7.jpg', 'Philips', 'Ba Lan', 'Bóng halogen H7 12V 55W', 'Chiếc',
     'Bóng đèn pha ánh sáng trắng', 190000.00, 48, 6, 'ACTIVE', 'spcat-loc'),
    ('part-cabin-filter', 'PT13', 'Lọc gió điều hòa', 'cabin_filter.jpg', 'Denso', 'Nhật Bản', 'Lọc gió cabin than hoạt tính', 'Chiếc',
     'Lọc bụi mịn và khử mùi điều hòa', 260000.00, 32, 6, 'ACTIVE', 'spcat-loc');

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
