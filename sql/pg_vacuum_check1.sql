SELECT schemaname,relname,last_autovacuum,last_autoanalyze FROM pg_stat_user_tables ORDER BY last_autovacuum DESC NULLS LAST;
