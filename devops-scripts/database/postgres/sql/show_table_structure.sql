-- Prompt user for the table name
\prompt table_name

-- Display the structure of the specified table
SELECT 
    column_name AS "Column Name",
    data_type AS "Data Type",
    is_nullable AS "Is Nullable",
    column_default AS "Default Value"
FROM 
    information_schema.columns
WHERE 
    table_name = :'table_name'
    AND table_schema = 'public'
ORDER BY 
    ordinal_position;

