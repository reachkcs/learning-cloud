SELECT
    t.name AS TableName,
    c.name AS ColumnName,
    c.encryption_type_desc
FROM
    sys.columns c
JOIN
    sys.tables t
    ON c.object_id = t.object_id
WHERE
    c.encryption_type_desc IS NOT NULL;

