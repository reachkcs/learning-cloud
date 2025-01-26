\prompt table_name
SELECT indexname, indexdef FROM pg_indexes WHERE tablename = :'table_name';

