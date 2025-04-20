SELECT
    OBJECT_NAME(object_id),
    definition
FROM
    sys.sql_modules
WHERE
    definition LIKE '%EncryptByKey%'
    OR definition LIKE '%DecryptByKey%';

