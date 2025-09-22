ALTER TABLE `domain`
    ADD COLUMN `expiration_properties` varchar(255) DEFAULT NULL;

ALTER TABLE `psn`
    ADD COLUMN `encoded_expiration_date` smallint DEFAULT NULL;

ALTER TABLE `mpsn`
    ADD COLUMN `encoded_expiration_date` smallint DEFAULT NULL;