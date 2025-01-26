-- Prompt for username
\prompt 'Enter username: ' user_name

DO $$
	DECLARE
	    user_name TEXT := :'user_name'; -- Use the entered username
	BEGIN
		    -- Output system-level privileges
    RAISE NOTICE 'System Privileges:';
    SELECT grantee, privilege_type, is_grantable
    FROM information_schema.role_table_grants
    WHERE grantee = user_name
    UNION ALL
    SELECT grantee, privilege_type, is_grantable
    FROM information_schema.role_routine_grants
    WHERE grantee = user_name
    UNION ALL
    SELECT grantee, privilege_type, is_grantable
    FROM information_schema.role_usage_grants
    WHERE grantee = user_name;

    -- Output object-level privileges
    RAISE NOTICE 'Object Privileges:';
    SELECT table_schema, table_name, privilege_type, is_grantable
    FROM information_schema.role_table_grants
    WHERE grantee = user_name;

    SELECT routine_schema, routine_name, privilege_type, is_grantable
    FROM information_schema.role_routine_grants
    WHERE grantee = user_name;

    SELECT schema_name, object_name, object_type, privilege_type
    FROM information_schema.role_usage_grants
    WHERE grantee = user_name;
END $$;

