-- Revert postgraphile_schemas:schemas from pg

BEGIN;

drop schema app_public;
drop schema app_private;
drop schema app_hidden;

COMMIT;
