-- Updates automatic match threshold
UPDATE
    domain
SET
    config = REPLACE(config, '<threshold-automatic-match>1000', '<threshold-automatic-match>1001')  -- 1000, 1000.0 --> 1001, 1001.0
WHERE
    1 = 1;


-- Updates possible match threshold
UPDATE
	domain
SET
	config = REPLACE(config, '<threshold-possible-match>1000', '<threshold-possible-match>1001')  -- 1000, 1000.0 --> 1001, 1001.0
WHERE
	1 = 1;
