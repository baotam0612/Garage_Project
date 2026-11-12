-- Nạp thêm 15 hạng mục mẫu vào database Garage đang có.
-- Có thể chạy lại nhiều lần: mã trùng sẽ được bỏ qua.
INSERT IGNORE INTO services (id, service_code, service_name, image_url, description, price, availability_status, category_id, estimated_minutes) VALUES
    ('svc-wheel-align', 'DV05', 'Cân chỉnh thước lái', 'wheel_align.jpg', 'Cân chỉnh góc đặt bánh xe giúp xe chạy ổn định', 350000.00, 'AVAILABLE', 'cat-repair', 60),
    ('svc-battery-check', 'DV06', 'Kiểm tra ắc quy', 'battery_check.jpg', 'Kiểm tra điện áp và khả năng nạp của ắc quy', 50000.00, 'AVAILABLE', 'cat-maintenance', 20),
    ('svc-aircon-clean', 'DV07', 'Vệ sinh điều hòa', 'aircon_clean.jpg', 'Vệ sinh dàn lạnh và khử mùi hệ thống điều hòa', 300000.00, 'AVAILABLE', 'cat-maintenance', 75),
    ('svc-tire-rotate', 'DV08', 'Đảo lốp xe', 'tire_rotate.jpg', 'Đảo vị trí lốp giúp lốp mòn đều', 180000.00, 'AVAILABLE', 'cat-maintenance', 45),
    ('svc-engine-scan', 'DV09', 'Chẩn đoán lỗi động cơ', 'engine_scan.jpg', 'Đọc lỗi bằng máy chẩn đoán chuyên dụng', 250000.00, 'AVAILABLE', 'cat-repair', 40),
    ('svc-brake-fluid', 'DV10', 'Thay dầu phanh', 'brake_fluid.jpg', 'Thay dầu phanh và xả khí hệ thống phanh', 220000.00, 'AVAILABLE', 'cat-maintenance', 50),
    ('svc-spark-plug', 'DV11', 'Thay bugi đánh lửa', 'spark_plug.jpg', 'Kiểm tra và thay bugi theo định kỳ', 280000.00, 'AVAILABLE', 'cat-maintenance', 45);

INSERT IGNORE INTO spare_parts (id, part_code, part_name, image_url, brand, origin, specifications, unit, description, selling_price, stock_quantity, warranty_period, business_status, category_id) VALUES
    ('part-battery-45ah', 'PT06', 'Ắc quy 45Ah', 'battery_45ah.jpg', 'GS', 'Việt Nam', 'Ắc quy khô 12V 45Ah', 'Bình', 'Ắc quy khởi động cho xe sedan cỡ nhỏ', 1450000.00, 18, 12, 'ACTIVE', 'spcat-loc'),
    ('part-wiper-blade', 'PT07', 'Gạt mưa silicon', 'wiper_blade.jpg', 'Bosch', 'Đức', 'Gạt mưa silicon 24 inch', 'Cặp', 'Gạt mưa chống ồn, bám kính tốt', 320000.00, 36, 6, 'ACTIVE', 'spcat-loc'),
    ('part-brake-fluid', 'PT08', 'Dầu phanh DOT 4', 'brake_fluid_dot4.jpg', 'Bosch', 'Đức', 'Dầu phanh DOT 4, chai 500ml', 'Chai', 'Dầu phanh chịu nhiệt cao', 180000.00, 40, 24, 'ACTIVE', 'spcat-dau'),
    ('part-spark-plug', 'PT09', 'Bugi iridium', 'spark_plug_iridium.jpg', 'NGK', 'Nhật Bản', 'Bugi iridium chân dài', 'Chiếc', 'Bugi đánh lửa tuổi thọ cao', 220000.00, 60, 12, 'ACTIVE', 'spcat-loc'),
    ('part-tire-195-65', 'PT10', 'Lốp 195/65R15', 'tire_195_65.jpg', 'Michelin', 'Thái Lan', 'Lốp xe du lịch 195/65R15', 'Lốp', 'Lốp êm ái cho sedan hạng C', 1850000.00, 16, 36, 'ACTIVE', 'spcat-loc'),
    ('part-atf-oil', 'PT11', 'Dầu hộp số tự động ATF', 'atf_oil.jpg', 'Toyota', 'Thái Lan', 'Dầu hộp số tự động ATF WS', 'Lít', 'Dầu hộp số cho xe số tự động', 290000.00, 28, 12, 'ACTIVE', 'spcat-dau'),
    ('part-headlamp-h7', 'PT12', 'Bóng đèn pha H7', 'headlamp_h7.jpg', 'Philips', 'Ba Lan', 'Bóng halogen H7 12V 55W', 'Chiếc', 'Bóng đèn pha ánh sáng trắng', 190000.00, 48, 6, 'ACTIVE', 'spcat-loc'),
    ('part-cabin-filter', 'PT13', 'Lọc gió điều hòa', 'cabin_filter.jpg', 'Denso', 'Nhật Bản', 'Lọc gió cabin than hoạt tính', 'Chiếc', 'Lọc bụi mịn và khử mùi điều hòa', 260000.00, 32, 6, 'ACTIVE', 'spcat-loc');
