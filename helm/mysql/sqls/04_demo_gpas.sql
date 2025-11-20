USE gpas;

-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server Version:               8.0.14 - MySQL Community Server - GPL
-- Server Betriebssystem:        Linux
-- HeidiSQL Version:             10.1.0.5464
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Exportiere Daten aus Tabelle gpas.domain: ~13 rows (ungefähr)
/*!40000 ALTER TABLE `domain` DISABLE KEYS */;
INSERT INTO `domain` (`name`, `label`, `alphabet`, `comment`, `generatorClass`, `properties`, `create_timestamp`, `update_timestamp`) VALUES
	('bc', 'BC', 'org.emau.icmvc.ganimed.ttp.psn.alphabets.Symbol31', 'Master Patient Index Pseudonyms', 'org.emau.icmvc.ganimed.ttp.psn.generator.NoCheckDigits', 'FORCE_CACHE=DEFAULT;INCLUDE_PREFIX_IN_CHECK_DIGIT_CALCULATION=false;INCLUDE_SUFFIX_IN_CHECK_DIGIT_CALCULATION=false;MAX_DETECTED_ERRORS=2;PSN_LENGTH=10;PSN_PREFIX=bc_;PSNS_DELETABLE=true;USE_LAST_CHAR_AS_DELIMITER_AFTER_X_CHARS=0;', '2025-08-26 10:39:54.979', '2025-08-26 10:39:55.008'),
	('pdr', 'pDR', 'org.emau.icmvc.ganimed.ttp.psn.alphabets.Symbol31', 'pDR Pseudonyms', 'org.emau.icmvc.ganimed.ttp.psn.generator.NoCheckDigits', 'FORCE_CACHE=DEFAULT;INCLUDE_PREFIX_IN_CHECK_DIGIT_CALCULATION=false;INCLUDE_SUFFIX_IN_CHECK_DIGIT_CALCULATION=false;MAX_DETECTED_ERRORS=2;PSN_LENGTH=10;PSN_PREFIX=pdr_;PSNS_DELETABLE=true;USE_LAST_CHAR_AS_DELIMITER_AFTER_X_CHARS=0;', '2025-08-26 10:39:54.979', '2025-08-26 10:39:55.008'),
	('stud01', 'Study_01', 'org.emau.icmvc.ganimed.ttp.psn.alphabets.Symbol31', 'Study 01 Pseudonyms', 'org.emau.icmvc.ganimed.ttp.psn.generator.NoCheckDigits', 'FORCE_CACHE=DEFAULT;INCLUDE_PREFIX_IN_CHECK_DIGIT_CALCULATION=false;INCLUDE_SUFFIX_IN_CHECK_DIGIT_CALCULATION=false;MAX_DETECTED_ERRORS=2;PSN_LENGTH=10;PSN_PREFIX=stud01_;PSNS_DELETABLE=true;USE_LAST_CHAR_AS_DELIMITER_AFTER_X_CHARS=0;', '2025-08-26 10:39:54.979', '2025-08-26 10:39:55.008');
/*!40000 ALTER TABLE `domain` ENABLE KEYS */;

-- Exportiere Daten aus Tabelle gpas.domain_parents: ~0 rows (ungefähr)
/*!40000 ALTER TABLE `domain_parents` DISABLE KEYS */;
INSERT INTO `domain_parents` (`domain`, `parentDomain`) VALUES
	('pdr', 'bc'),
	('stud01', 'bc');
/*!40000 ALTER TABLE `domain_parents` ENABLE KEYS */;

INSERT INTO `psn` (`originalValue`, `pseudonym`, `domain`) VALUES
	('mpi_0000000001', 'bc_0000000001', 'bc'),
	('mpi_0000000002', 'bc_0000000002', 'bc'),
	('mpi_0000000003', 'bc_0000000003', 'bc'),
	('mpi_0000000004', 'bc_0000000004', 'bc'),
	('bc_0000000001', 'pdr_0000000001', 'pdr'),
	('bc_0000000002', 'pdr_0000000002', 'pdr'),
	('bc_0000000003', 'pdr_0000000003', 'pdr'),
	('bc_0000000004', 'pdr_0000000004', 'pdr'),
	('bc_0000000001', 'stud01_0000000001', 'stud01'),
	('bc_0000000002', 'stud01_0000000002', 'stud01'),
	('bc_0000000003', 'stud01_0000000003', 'stud01'),
	('bc_0000000004', 'stud01_0000000004', 'stud01');
/*!40000 ALTER TABLE `psn` ENABLE KEYS */;

-- Exportiere Daten aus Tabelle gpas.sequence: ~1 rows (ungefähr)
/*!40000 ALTER TABLE `sequence` DISABLE KEYS */;
INSERT INTO `sequence` (`SEQ_NAME`, `SEQ_COUNT`) VALUES
	('statistic_index', 50);
/*!40000 ALTER TABLE `sequence` ENABLE KEYS */;

-- Exportiere Daten aus Tabelle gpas.stat_entry: ~0 rows (ungefähr)
/*!40000 ALTER TABLE `stat_entry` DISABLE KEYS */;
INSERT INTO `stat_entry` (`STAT_ENTRY_ID`, `ENTRYDATE`) VALUES
	(1, '2021-10-26 10:47:48.571');
/*!40000 ALTER TABLE `stat_entry` ENABLE KEYS */;

-- Exportiere Daten aus Tabelle gpas.stat_value: ~0 rows (ungefähr)
/*!40000 ALTER TABLE `stat_value` DISABLE KEYS */;
INSERT INTO `stat_value` (`stat_value_id`, `stat_value`, `stat_attr`) VALUES
	(1, 0, 'anonyms_per_domain.pdr'),
	(1, 0, 'anonyms_per_domain.mpi'),
	(1, 0, 'anonyms_per_domain.stud01'),
	(1, 4, 'pseudonyms_per_domain.pdr'),
	(1, 4, 'pseudonyms_per_domain.mpi'),
	(1, 4, 'pseudonyms_per_domain.stud01'),
	(1, 12, 'pseudonyms'),
	(1, 0, 'calculation_time'),
	(1, 2, 'domains'),
	(1, 0, 'anonyms');
/*!40000 ALTER TABLE `stat_value` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;