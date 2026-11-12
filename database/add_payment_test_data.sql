-- Dữ liệu test cho module thanh toán.
-- Chạy sau khi đã tạo schema + seed; có thể chạy lại vì tất cả INSERT dùng IGNORE.

INSERT IGNORE INTO persons (id, full_name, phone_number, email, address) VALUES
    ('customer-pay-01', 'Nguyễn Thị Bình', '0912345678', 'binh.nguyen@example.com', 'Quận 1, TP.HCM'),
    ('customer-pay-02', 'Lê Minh Cường', '0987654321', 'cuong.le@example.com', 'Quận 3, TP.HCM'),
    ('customer-pay-03', 'Phạm Thu Dung', '0908123456', 'dung.pham@example.com', 'Quận 7, TP.HCM'),
    ('customer-pay-04', 'Đỗ Quang Huy', '0933445566', 'huy.do@example.com', 'Thủ Đức, TP.HCM');

INSERT IGNORE INTO customers (person_id, customer_code, created_at) VALUES
    ('customer-pay-01', 'KH02', CURRENT_TIMESTAMP),
    ('customer-pay-02', 'KH03', CURRENT_TIMESTAMP),
    ('customer-pay-03', 'KH04', CURRENT_TIMESTAMP),
    ('customer-pay-04', 'KH05', CURRENT_TIMESTAMP);

INSERT IGNORE INTO vehicles (id, customer_id, license_plate, chassis_number, make, model, manufacture_year, color) VALUES
    ('vehicle-pay-01', 'customer-pay-01', '51A-23456', 'HND-TEST-0001', 'Honda', 'City', 2021, 'Trắng'),
    ('vehicle-pay-02', 'customer-pay-02', '51H-56789', 'KIA-TEST-0002', 'Kia', 'Seltos', 2022, 'Đỏ'),
    ('vehicle-pay-03', 'customer-pay-03', '50F-13579', 'MAZ-TEST-0003', 'Mazda', '3', 2020, 'Xám'),
    ('vehicle-pay-04', 'customer-pay-04', '60A-24680', 'TOY-TEST-0004', 'Toyota', 'Vios', 2023, 'Đen');

INSERT IGNORE INTO appointments (id, scheduled_at, request_description, booking_channel, appointment_status, vehicle_id) VALUES
    ('app-pay-01', CURRENT_DATE, 'Kiểm tra phanh định kỳ', 'WALK_IN', 'CONFIRMED', 'vehicle-pay-01'),
    ('app-pay-02', CURRENT_DATE, 'Vệ sinh kim phun và châm nước làm mát', 'PHONE', 'CONFIRMED', 'vehicle-pay-02'),
    ('app-pay-03', CURRENT_DATE, 'Bảo dưỡng lọc gió', 'ONLINE', 'CONFIRMED', 'vehicle-pay-03'),
    ('app-pay-04', CURRENT_DATE, 'Bảo dưỡng và thay dầu', 'WALK_IN', 'CONFIRMED', 'vehicle-pay-04');

INSERT IGNORE INTO service_receptions (id, receive_at, actual_delivery_at, status, description, vehicle_id, appointment_id, sales_staff_id, technician_id) VALUES
    ('reception-pay-01', CURRENT_DATE, CURRENT_DATE, 'IN_PROGRESS', 'Kiểm tra và thay má phanh', 'vehicle-pay-01', 'app-pay-01', 'sales-001', 'tech-001'),
    ('reception-pay-02', CURRENT_DATE, CURRENT_DATE, 'IN_PROGRESS', 'Vệ sinh kim phun và bổ sung nước làm mát', 'vehicle-pay-02', 'app-pay-02', 'sales-001', 'tech-001'),
    ('reception-pay-03', CURRENT_DATE, CURRENT_DATE, 'IN_PROGRESS', 'Kiểm tra lọc gió động cơ', 'vehicle-pay-03', 'app-pay-03', 'sales-001', 'tech-001'),
    ('reception-pay-04', CURRENT_DATE, CURRENT_DATE, 'IN_PROGRESS', 'Bảo dưỡng dầu động cơ', 'vehicle-pay-04', 'app-pay-04', 'sales-001', 'tech-001');

-- HD002 và HD005 là DRAFT: dùng để test bổ sung hạng mục / xác nhận hóa đơn.
-- HD003 và HD004 là CONFIRMED: dùng để test ngay màn hình thanh toán tiền mặt / chuyển khoản.
INSERT IGNORE INTO invoices (id, invoice_number, reception_id, sales_staff_id, issued_at, service_total, spare_part_total, discount_amount, total_amount, invoice_status, payment_status) VALUES
    ('invoice-pay-01', 'HD002', 'reception-pay-01', 'sales-001', CURRENT_TIMESTAMP, 150000.00, 750000.00, 0.00, 900000.00, 'DRAFT', 'UNPAID'),
    ('invoice-pay-02', 'HD003', 'reception-pay-02', 'sales-001', CURRENT_TIMESTAMP, 200000.00, 240000.00, 0.00, 440000.00, 'CONFIRMED', 'UNPAID'),
    ('invoice-pay-03', 'HD004', 'reception-pay-03', 'sales-001', CURRENT_TIMESTAMP, 80000.00, 180000.00, 0.00, 260000.00, 'CONFIRMED', 'UNPAID'),
    ('invoice-pay-04', 'HD005', 'reception-pay-04', 'sales-001', CURRENT_TIMESTAMP, 100000.00, 250000.00, 0.00, 350000.00, 'DRAFT', 'UNPAID');

INSERT IGNORE INTO invoice_lines (id, invoice_id, item_type, catalog_id, item_code, item_name, unit, quantity, unit_price, line_total) VALUES
    ('line-pay-01a', 'invoice-pay-01', 'SERVICE', 'svc-brake-check', 'DV04', 'Kiểm tra hệ thống phanh', 'Lần', 1, 150000.00, 150000.00),
    ('line-pay-01b', 'invoice-pay-01', 'SPARE_PART', 'part-brake-pad', 'PT05', 'Má phanh trước', 'Bộ', 1, 750000.00, 750000.00),
    ('line-pay-02a', 'invoice-pay-02', 'SERVICE', 'svc-inject-clean', 'DV02', 'Vệ sinh kim phun', 'Lần', 1, 200000.00, 200000.00),
    ('line-pay-02b', 'invoice-pay-02', 'SPARE_PART', 'part-coolant', 'PT03', 'Nước làm mát', 'Lít', 2, 120000.00, 240000.00),
    ('line-pay-03a', 'invoice-pay-03', 'SERVICE', 'svc-air-filter-check', 'DV03', 'Kiểm tra lọc gió', 'Lần', 1, 80000.00, 80000.00),
    ('line-pay-03b', 'invoice-pay-03', 'SPARE_PART', 'part-air-filter', 'PT04', 'Lọc gió động cơ', 'Chiếc', 1, 180000.00, 180000.00),
    ('line-pay-04a', 'invoice-pay-04', 'SERVICE', 'svc-oil-change', 'DV01', 'Thay dầu động cơ', 'Lần', 1, 100000.00, 100000.00),
    ('line-pay-04b', 'invoice-pay-04', 'SPARE_PART', 'part-oil-5w30', 'PT01', 'Dầu động cơ 5W-30', 'Lít', 1, 250000.00, 250000.00);

-- Hai khách hàng và hóa đơn bổ sung để test luồng chọn khách hàng -> chi tiết hóa đơn.
INSERT IGNORE INTO persons (id, full_name, phone_number, email, address) VALUES
    ('customer-pay-05', 'Võ Ngọc Lan', '0977123456', 'lan.vo@example.com', 'Bình Thạnh, TP.HCM'),
    ('customer-pay-06', 'Trần Quốc Nam', '0966234567', 'nam.tran@example.com', 'Tân Bình, TP.HCM');

INSERT IGNORE INTO customers (person_id, customer_code, created_at) VALUES
    ('customer-pay-05', 'KH06', CURRENT_TIMESTAMP),
    ('customer-pay-06', 'KH07', CURRENT_TIMESTAMP);

INSERT IGNORE INTO vehicles (id, customer_id, license_plate, chassis_number, make, model, manufacture_year, color) VALUES
    ('vehicle-pay-05', 'customer-pay-05', '51G-67890', 'FOR-TEST-0005', 'Ford', 'EcoSport', 2021, 'Xanh'),
    ('vehicle-pay-06', 'customer-pay-06', '51K-11223', 'HYU-TEST-0006', 'Hyundai', 'Accent', 2022, 'Bạc');

INSERT IGNORE INTO appointments (id, scheduled_at, request_description, booking_channel, appointment_status, vehicle_id) VALUES
    ('app-pay-05', CURRENT_DATE, 'Vệ sinh điều hòa và thay lọc gió cabin', 'PHONE', 'CONFIRMED', 'vehicle-pay-05'),
    ('app-pay-06', CURRENT_DATE, 'Kiểm tra và thay dầu phanh', 'WALK_IN', 'CONFIRMED', 'vehicle-pay-06');

INSERT IGNORE INTO service_receptions (id, receive_at, actual_delivery_at, status, description, vehicle_id, appointment_id, sales_staff_id, technician_id) VALUES
    ('reception-pay-05', CURRENT_DATE, CURRENT_DATE, 'IN_PROGRESS', 'Bảo dưỡng hệ thống điều hòa', 'vehicle-pay-05', 'app-pay-05', 'sales-001', 'tech-001'),
    ('reception-pay-06', CURRENT_DATE, CURRENT_DATE, 'IN_PROGRESS', 'Bảo dưỡng hệ thống phanh', 'vehicle-pay-06', 'app-pay-06', 'sales-001', 'tech-001');

INSERT IGNORE INTO service_requests (id, quantity, unit_price, customer_approval_status, fulfillment_status, notes, service_id, reception_id, technician_id) VALUES
    ('req-svc-pay-05', 1, 300000.00, 'APPROVED', 'COMPLETED', 'Đã vệ sinh hệ thống điều hòa', 'svc-aircon-clean', 'reception-pay-05', 'tech-001'),
    ('req-svc-pay-06', 1, 220000.00, 'APPROVED', 'COMPLETED', 'Đã thay dầu phanh', 'svc-brake-fluid', 'reception-pay-06', 'tech-001');

INSERT IGNORE INTO service_request_technicians (service_request_id, technician_id, assigned_at) VALUES
    ('req-svc-pay-05', 'tech-001', CURRENT_TIMESTAMP),
    ('req-svc-pay-06', 'tech-001', CURRENT_TIMESTAMP);

INSERT IGNORE INTO spare_part_requests (id, actual_used_quantity, unit_price, spare_part_id, reception_id, service_request_id, quantity, customer_approval_status, notes) VALUES
    ('req-part-pay-05', 1, 260000.00, 'part-cabin-filter', 'reception-pay-05', 'req-svc-pay-05', 1, 'APPROVED', 'Đã thay lọc gió điều hòa'),
    ('req-part-pay-06', 2, 180000.00, 'part-brake-fluid', 'reception-pay-06', 'req-svc-pay-06', 2, 'APPROVED', 'Đã sử dụng hai chai dầu phanh DOT 4');

-- HD006 dùng để test bổ sung/xác nhận; HD007 dùng để vào thẳng màn hình thanh toán.
INSERT IGNORE INTO invoices (id, invoice_number, reception_id, sales_staff_id, issued_at, service_total, spare_part_total, discount_amount, total_amount, invoice_status, payment_status) VALUES
    ('invoice-pay-05', 'HD006', 'reception-pay-05', 'sales-001', CURRENT_TIMESTAMP, 300000.00, 260000.00, 0.00, 560000.00, 'DRAFT', 'UNPAID'),
    ('invoice-pay-06', 'HD007', 'reception-pay-06', 'sales-001', CURRENT_TIMESTAMP, 220000.00, 360000.00, 0.00, 580000.00, 'CONFIRMED', 'UNPAID');

INSERT IGNORE INTO invoice_lines (id, invoice_id, item_type, catalog_id, item_code, item_name, unit, quantity, unit_price, line_total) VALUES
    ('line-pay-05a', 'invoice-pay-05', 'SERVICE', 'svc-aircon-clean', 'DV07', 'Vệ sinh điều hòa', 'Lần', 1, 300000.00, 300000.00),
    ('line-pay-05b', 'invoice-pay-05', 'SPARE_PART', 'part-cabin-filter', 'PT13', 'Lọc gió điều hòa', 'Chiếc', 1, 260000.00, 260000.00),
    ('line-pay-06a', 'invoice-pay-06', 'SERVICE', 'svc-brake-fluid', 'DV10', 'Thay dầu phanh', 'Lần', 1, 220000.00, 220000.00),
    ('line-pay-06b', 'invoice-pay-06', 'SPARE_PART', 'part-brake-fluid', 'PT08', 'Dầu phanh DOT 4', 'Chai', 2, 180000.00, 360000.00);
