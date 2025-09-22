ALTER TABLE `notifications`
	CHANGE COLUMN `data` `data` TEXT NOT NULL COLLATE 'utf8_general_ci' AFTER `creationDate`;
