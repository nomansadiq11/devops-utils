# How we can add readonly user in postgres

```sql
-- 🔧 Change these values before running
DO $$
DECLARE
    v_username text := 'readonly_user';
    v_password text := 'readonly_pass';
    v_schema   text := 'public';
BEGIN
    -- 👤 Create user
    EXECUTE format('CREATE USER %I WITH PASSWORD %L', v_username, v_password);

    -- 🔐 Grant connect to database (only needed if run outside target DB)
    -- Not possible directly here because DBeaver executes within a connected DB

    -- 📂 Grant schema usage
    EXECUTE format('GRANT USAGE ON SCHEMA %I TO %I', v_schema, v_username);

    -- 📄 Grant read access to all existing tables
    EXECUTE format('GRANT SELECT ON ALL TABLES IN SCHEMA %I TO %I', v_schema, v_username);

    -- 🧬 Grant read access to future tables
    EXECUTE format('ALTER DEFAULT PRIVILEGES IN SCHEMA %I GRANT SELECT ON TABLES TO %I', v_schema, v_username);
END
$$;

```
