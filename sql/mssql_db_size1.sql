select db_name(database_id) as database_name, type_desc, name as FielName, size/128.0 as CurrentSizeMB
from sys.master_files
where database_id > 0 and type in (0,1)
order by CurrentSizeMB desc;
