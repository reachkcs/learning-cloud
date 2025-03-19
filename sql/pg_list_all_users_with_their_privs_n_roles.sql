SELECT 
    rolname AS role_name,
    CASE WHEN rolcanlogin THEN 'TRUE' ELSE 'FALSE' END AS can_login,
    CASE WHEN rolsuper THEN 'TRUE' ELSE 'FALSE' END AS is_superuser,
    CASE WHEN rolinherit THEN 'TRUE' ELSE 'FALSE' END AS can_inherit,
    CASE WHEN rolcreaterole THEN 'TRUE' ELSE 'FALSE' END AS can_create_roles,
    CASE WHEN rolcreatedb THEN 'TRUE' ELSE 'FALSE' END AS can_create_db,
    CASE WHEN rolreplication THEN 'TRUE' ELSE 'FALSE' END AS can_replicate,
    CASE WHEN rolbypassrls THEN 'TRUE' ELSE 'FALSE' END AS can_bypass_rls
FROM pg_roles
ORDER BY rolname;

