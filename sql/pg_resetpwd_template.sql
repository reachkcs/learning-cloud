SELECT rolname, rolvaliduntil, rolcanlogin, rolsuper, rolcreaterole, rolcreatedb
FROM pg_roles
WHERE rolname = '<user>';

ALTER ROLE <user> WITH PASSWORD '<pwd>';
ALTER ROLE <user> VALID UNTIL '2000-01-01';
