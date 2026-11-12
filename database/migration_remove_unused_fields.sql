-- Apply once to an existing database after making a backup.
-- This migration removes columns no longer used by the application.
USE garage;

DELIMITER //
CREATE PROCEDURE drop_foreign_key_if_present(IN table_name_in VARCHAR(64), IN key_name_in VARCHAR(64))
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.table_constraints
        WHERE table_schema = DATABASE() AND table_name = table_name_in
          AND constraint_name = key_name_in AND constraint_type = 'FOREIGN KEY'
    ) THEN
        SET @drop_fk_sql = CONCAT('ALTER TABLE `', table_name_in, '` DROP FOREIGN KEY `', key_name_in, '`');
        PREPARE drop_fk_statement FROM @drop_fk_sql;
        EXECUTE drop_fk_statement;
        DEALLOCATE PREPARE drop_fk_statement;
    END IF;
END //

CREATE PROCEDURE drop_index_if_present(IN table_name_in VARCHAR(64), IN key_name_in VARCHAR(64))
BEGIN
    IF EXISTS (
        SELECT 1 FROM information_schema.statistics
        WHERE table_schema = DATABASE() AND table_name = table_name_in AND index_name = key_name_in
    ) THEN
        SET @drop_index_sql = CONCAT('ALTER TABLE `', table_name_in, '` DROP INDEX `', key_name_in, '`');
        PREPARE drop_index_statement FROM @drop_index_sql;
        EXECUTE drop_index_statement;
        DEALLOCATE PREPARE drop_index_statement;
    END IF;
END //
DELIMITER ;

-- These constraints only exist if the retired merge migration was run.
CALL drop_foreign_key_if_present('service_receptions', 'fk_receptions_customer');
CALL drop_foreign_key_if_present('service_receptions', 'fk_receptions_vehicle_customer');
CALL drop_index_if_present('service_receptions', 'idx_receptions_customer');
DROP PROCEDURE drop_foreign_key_if_present;
DROP PROCEDURE drop_index_if_present;

ALTER TABLE appointments
    DROP COLUMN notes,
    DROP COLUMN created_at;

ALTER TABLE service_receptions
    DROP COLUMN customer_id;

ALTER TABLE invoice_lines
    DROP COLUMN brand,
    DROP COLUMN origin,
    DROP COLUMN specifications,
    DROP COLUMN component_names,
    DROP COLUMN warranty_period;
