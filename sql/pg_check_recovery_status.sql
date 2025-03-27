SELECT CASE 
    WHEN pg_is_in_recovery() THEN 'True' 
    ELSE 'False' 
END AS recovery_status;

\x on
SHOW transaction_read_only;

