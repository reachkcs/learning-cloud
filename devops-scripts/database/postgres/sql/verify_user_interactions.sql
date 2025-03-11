SELECT count(*) FROM user_interactions_part;
SELECT count(*) FROM user_interactions;
SELECT * FROM user_interactions_part WHERE created_at >= NOW() - INTERVAL '20 minutes';
SELECT * FROM user_interactions WHERE created_at >= NOW() - INTERVAL '20 minutes';
