-- Correction DB-schema
ALTER TABLE `domain` MODIFY COLUMN `name` VARCHAR(255) NOT NULL;
ALTER TABLE `domain` MODIFY COLUMN `properties` VARCHAR(1023) DEFAULT NULL;
ALTER TABLE `domain` MODIFY COLUMN `expiration_properties` VARCHAR(255) DEFAULT NULL AFTER `update_timestamp`;
ALTER TABLE `domain_parents` MODIFY COLUMN `domain` VARCHAR(255) NOT NULL;
ALTER TABLE `domain_parents` MODIFY COLUMN `parentDomain` VARCHAR(255) NOT NULL;
ALTER TABLE `psn` MODIFY COLUMN `pseudonym` VARCHAR(255) NOT NULL;
ALTER TABLE `sequence` DEFAULT COLLATE=utf8mb4_unicode_ci;
ALTER TABLE `sequence` MODIFY COLUMN `SEQ_NAME` VARCHAR(50) NOT NULL;

-- add stored procedure
DELIMITER $
CREATE PROCEDURE convert_to_multi_psn_domain(
    IN in_domain VARCHAR(255)
)
BEGIN
    START TRANSACTION;

    REPLACE INTO mpsn (originalValue, pseudonym, domain, encoded_expiration_date)
    SELECT originalValue, pseudonym, domain, encoded_expiration_date FROM psn WHERE domain = in_domain;

    DELETE FROM psn WHERE domain = in_domain;

    UPDATE domain
    SET properties = CONCAT(
        REGEXP_REPLACE(REGEXP_REPLACE(
            IFNULL(properties,''), ';?MULTI_PSN_DOMAIN=[^;]+', ''
        ), '^;', ''),
        IF(IFNULL(properties,'')='' OR RIGHT(properties, 1)=';', '', ';'),
        'MULTI_PSN_DOMAIN=true;'
    )
    WHERE name = in_domain;

    COMMIT;
END$
DELIMITER ;
