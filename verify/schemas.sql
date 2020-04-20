-- Verify postgraphile_schemas:schemas on pg

BEGIN;

SELECT pg_catalog.has_schema_privilege('app_public', 'usage');
SELECT pg_catalog.has_schema_privilege('app_private', 'usage');
SELECT pg_catalog.has_schema_privilege('app_hidden', 'usage');


ROLLBACK;
