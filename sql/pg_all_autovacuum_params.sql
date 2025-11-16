SELECT name, setting, unit, source, short_desc
FROM pg_settings
WHERE category LIKE 'Autovacuum%'
ORDER BY name;
