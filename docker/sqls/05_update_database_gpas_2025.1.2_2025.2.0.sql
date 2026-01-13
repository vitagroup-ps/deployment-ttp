
DELIMITER $$

/* ============================
   convert_to_multi_psn_domain
   - prüft verschiedene Punkte, ob Kovertierung möglich ist
     - existiert die Domain
     - existiert die Domain bereits als multi-psn-domain
   - macht REPLACE (kein INSERT) und löscht psn-Zeilen
   - setzt MULTI_PSN_DOMAIN=true
   ============================ */
DROP PROCEDURE IF EXISTS `convert_to_multi_psn_domain`$$
CREATE PROCEDURE `convert_to_multi_psn_domain`(
    IN in_domain VARCHAR(255)
)
BEGIN
    DECLARE conflict INT DEFAULT 0;
    DECLARE msg VARCHAR(255);

    -- prüfe ob domain existiert
    SELECT IF(COUNT(*),0,1) INTO conflict FROM domain WHERE name = in_domain;
    IF conflict THEN
        SET msg = CONCAT('Domain "', in_domain, '" not exists.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;

    -- prüfe ob domain bereits in multi-psn vorhanden
    SELECT COUNT(*) INTO conflict FROM (
        SELECT originalValue FROM mpsn WHERE domain = in_domain LIMIT 1
    ) t;
    IF conflict THEN
        SET msg = CONCAT('Domain "', in_domain, '" already exists in mpsn-table.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;

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
END$$


/* ============================
   convert_to_single_psn_domain
   - prüft verschiedene Punkte, ob Kovertierung möglich ist
     - existiert die Domain
     - existiert die Domain bereits als single-psn-domain
	 - existieren identische originalValues in dieser Domain
   - macht INSERT (kein REPLACE) und löscht mpsn-Zeilen
   - setzt MULTI_PSN_DOMAIN=false
   ============================ */
DROP PROCEDURE IF EXISTS `convert_to_single_psn_domain`$$
CREATE PROCEDURE `convert_to_single_psn_domain`(
    IN in_domain VARCHAR(255)
)
BEGIN
    DECLARE conflict INT DEFAULT 0;
    DECLARE msg VARCHAR(255);

    -- prüfe ob domain existiert
    SELECT IF(COUNT(*),0,1) INTO conflict FROM domain WHERE name = in_domain;
    IF conflict THEN
        SET msg = CONCAT('Domain "', in_domain, '" not exists.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;

    -- prüfe ob domain bereits in single-psn vorhanden
    SELECT COUNT(*) INTO conflict FROM (
        SELECT originalValue FROM psn WHERE domain = in_domain LIMIT 1
    ) t;
    IF conflict THEN
        SET msg = CONCAT('Domain "', in_domain, '" already exists in psn-table.');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;

    -- prüfe Konflikte mit mehrfachen originalValue
    SELECT COUNT(*) INTO conflict FROM (
        SELECT originalValue FROM mpsn WHERE domain = in_domain
        GROUP BY originalValue, domain HAVING COUNT(*) > 1 LIMIT 1
    ) t;
    IF conflict THEN
        SET msg = CONCAT('At least one originalValue is not unique in domain "', in_domain, '".');
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = msg;
    END IF;

    START TRANSACTION;

    INSERT INTO psn (originalValue, pseudonym, domain, encoded_expiration_date)
    SELECT originalValue, pseudonym, domain, encoded_expiration_date FROM mpsn WHERE domain = in_domain;

    DELETE FROM mpsn WHERE domain = in_domain;

    UPDATE domain
    SET properties = REGEXP_REPLACE(properties, 'MULTI_PSN_DOMAIN=[^;]+', 'MULTI_PSN_DOMAIN=false')
    WHERE name = in_domain;

    COMMIT;
END$$

DELIMITER ;
