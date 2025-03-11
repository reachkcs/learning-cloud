CREATE OR REPLACE FUNCTION create_next_month_partition_user_interactions()
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    start_date DATE;
    end_date DATE;
    partition_name TEXT;
    month_name TEXT;
    create_table_statement TEXT;
BEGIN
    -- Calculate next month's start and end dates
    start_date := date_trunc('month', current_date) + interval '1 month';
    end_date := start_date + interval '1 month';

    -- Format the partition name as user_interactions_monYYYY
    month_name := to_char(start_date, 'monYYYY'); -- e.g., jan2024
    partition_name := 'user_interactions_part_' || lower(month_name);

    -- Check if the partition already exists
    IF NOT EXISTS (SELECT 1 FROM pg_class WHERE relname = partition_name) THEN
        create_table_statement := format('CREATE TABLE %I PARTITION OF user_interactions_backup FOR VALUES FROM (%L) TO (%L)',
            partition_name, start_date, end_date);
        RAISE NOTICE 'Generated SQL: %', create_table_statement;

        -- Execute the CREATE TABLE statement
        EXECUTE create_table_statement;
    ELSE
        RAISE NOTICE 'Partition table % already exists!', partition_name;
    END IF;
END;
$$;
