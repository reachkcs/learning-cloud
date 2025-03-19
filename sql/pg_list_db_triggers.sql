SELECT
    t.tgname AS trigger_name,
    c.relname AS table_name,
    n.nspname AS schema_name,
    CASE 
        WHEN t.tgtype = 1 THEN 'BEFORE'
        WHEN t.tgtype = 2 THEN 'AFTER'
        WHEN t.tgtype = 3 THEN 'INSTEAD OF'
        ELSE 'UNKNOWN'
    END AS trigger_timing,
    CASE 
        WHEN t.tgtype IN (1, 2) THEN 
            CASE 
                WHEN t.tgtype & 8 = 8 THEN 'INSERT'
                WHEN t.tgtype & 4 = 4 THEN 'UPDATE'
                WHEN t.tgtype & 2 = 2 THEN 'DELETE'
                ELSE 'UNKNOWN'
            END
        ELSE 'UNKNOWN'
    END AS trigger_event,
    pg_catalog.pg_get_triggerdef(t.oid) AS trigger_definition
FROM
    pg_catalog.pg_trigger t
JOIN
    pg_catalog.pg_class c ON c.oid = t.tgrelid
JOIN
    pg_catalog.pg_namespace n ON n.oid = c.relnamespace
WHERE
    NOT t.tgisinternal  -- Exclude internal system triggers
    AND n.nspname <> 'pg_catalog'  -- Exclude system schemas
    AND n.nspname <> 'information_schema'  -- Exclude information_schema
ORDER BY
    schema_name, table_name, trigger_name;

