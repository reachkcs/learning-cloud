SELECT
    db.name,
    db.is_encrypted,
    dm.encryption_state,
    dm.key_algorithm,
    dm.key_length
FROM
    sys.databases db
LEFT JOIN
    sys.dm_database_encryption_keys dm
ON
    db.database_id = dm.database_id;

