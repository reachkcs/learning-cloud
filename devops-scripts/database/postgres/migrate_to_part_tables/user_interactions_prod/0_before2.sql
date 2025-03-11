\set ECHO queries
\o log/0_before2.log
select now();
SELECT
	AVG(
		CASE
			WHEN ACTION IN (
				'MemoryGame - Match Guess',
				'WhackAMoleGame - correct',
				'Flashcards - Click - Correct',
				'SkyRollerVocabulary - Word Completion',
				'Story - Click - Exercise Success'
			) THEN 1
			ELSE 0
		END
	)
FROM
	"user_interactions"
WHERE
	"user_interactions"."user_profile_id" = 2262
	AND (
		"user_interactions"."action" IN (
			'Story - Click - Exercise Success',
			'Story - Click - Loose a heart'
		)
		AND (
			LOWER(NOTE ->> 'exercise') IN (
				SELECT
					LOWER(EXERCISE_NAME)
				FROM
					"exercise_classifications"
			)
		)
		OR "user_interactions"."action" IN (
			'WhackAMoleGame - wrong',
			'Flashcards - Click - Incorrect',
			'MemoryGame - Match Guess',
			'WhackAMoleGame - correct',
			'Flashcards - Click - Correct',
			'SkyRollerVocabulary - Word Completion'
		)
	)
	AND (
		DATE_TRUNC('month'::TEXT, CREATED_AT) = '2024-12-01 00:00:00'
	);
select now();
EXPLAIN (VERBOSE, ANALYZE) SELECT
	AVG(
		CASE
			WHEN ACTION IN (
				'MemoryGame - Match Guess',
				'WhackAMoleGame - correct',
				'Flashcards - Click - Correct',
				'SkyRollerVocabulary - Word Completion',
				'Story - Click - Exercise Success'
			) THEN 1
			ELSE 0
		END
	)
FROM
	"user_interactions"
WHERE
	"user_interactions"."user_profile_id" = 2262
	AND (
		"user_interactions"."action" IN (
			'Story - Click - Exercise Success',
			'Story - Click - Loose a heart'
		)
		AND (
			LOWER(NOTE ->> 'exercise') IN (
				SELECT
					LOWER(EXERCISE_NAME)
				FROM
					"exercise_classifications"
			)
		)
		OR "user_interactions"."action" IN (
			'WhackAMoleGame - wrong',
			'Flashcards - Click - Incorrect',
			'MemoryGame - Match Guess',
			'WhackAMoleGame - correct',
			'Flashcards - Click - Correct',
			'SkyRollerVocabulary - Word Completion'
		)
	)
	AND (
		DATE_TRUNC('month'::TEXT, CREATED_AT) = '2024-12-01 00:00:00'
	);
\o
\set ECHO none

