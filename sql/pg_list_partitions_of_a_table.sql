\prompt table_name

SELECT inhrelid::regclass AS partition
FROM pg_inherits
WHERE inhparent = :'table_name'::regclass;

