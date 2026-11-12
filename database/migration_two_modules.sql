-- Apply once to an existing garage database created with the earlier schema.
-- Back up the database before running this migration.
USE garage;

ALTER TABLE services ADD COLUMN estimated_minutes INT NULL AFTER description;
ALTER TABLE services ADD CONSTRAINT chk_services_duration
    CHECK (estimated_minutes IS NULL OR estimated_minutes > 0);

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
    CONSTRAINT fk_invoice_lines_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (id),
    CONSTRAINT chk_invoice_lines_type CHECK (item_type IN ('SERVICE', 'SPARE_PART')),
    CONSTRAINT chk_invoice_lines_quantity CHECK (quantity > 0),
    CONSTRAINT chk_invoice_lines_price CHECK (unit_price >= 0),
    CONSTRAINT chk_invoice_lines_total CHECK (line_total = quantity * unit_price)
);

CREATE TABLE payments (
    id VARCHAR(36) NOT NULL,
    invoice_id VARCHAR(36) NOT NULL,
    amount DECIMAL(15, 2) NOT NULL,
    amount_received DECIMAL(15, 2) NOT NULL,
    payment_method VARCHAR(40) NOT NULL,
    paid_at DATETIME NOT NULL,
    sales_staff_id VARCHAR(36) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_payments_invoice (invoice_id),
    KEY idx_payments_staff (sales_staff_id),
    CONSTRAINT fk_payments_invoice FOREIGN KEY (invoice_id) REFERENCES invoices (id),
    CONSTRAINT fk_payments_staff FOREIGN KEY (sales_staff_id) REFERENCES sales_staff (user_id),
    CONSTRAINT chk_payments_amount CHECK (amount >= 0 AND amount_received >= amount),
    CONSTRAINT chk_payments_method CHECK (payment_method IN ('CASH', 'BANK_TRANSFER', 'CARD'))
);

-- Copy existing reception items into printable invoice snapshots.
INSERT INTO invoice_lines (id, invoice_id, item_type, catalog_id, item_code, item_name,
                           unit, quantity, unit_price, line_total)
SELECT UUID(), i.id, 'SERVICE', s.id, s.service_code, s.service_name,
       'lần', r.quantity, r.unit_price, r.quantity * r.unit_price
FROM invoices i JOIN service_requests r ON r.reception_id = i.reception_id
JOIN services s ON s.id = r.service_id;

INSERT INTO invoice_lines (id, invoice_id, item_type, catalog_id, item_code, item_name,
                           unit, quantity, unit_price, line_total)
SELECT UUID(), i.id, 'SPARE_PART', p.id, p.part_code, p.part_name,
       p.unit, r.actual_used_quantity, r.unit_price,
       r.actual_used_quantity * r.unit_price
FROM invoices i JOIN spare_part_requests r ON r.reception_id = i.reception_id
JOIN spare_parts p ON p.id = r.spare_part_id
WHERE r.actual_used_quantity > 0;

UPDATE invoices SET invoice_status = 'DRAFT'
WHERE invoice_status = 'ISSUED' AND payment_status = 'UNPAID';
UPDATE invoices SET invoice_status = 'CONFIRMED'
WHERE invoice_status = 'ISSUED' AND payment_status = 'PAID';

-- Reconcile any historical paid invoices separately; this migration does not
-- fabricate payment records for transactions whose receipt details are unknown.
