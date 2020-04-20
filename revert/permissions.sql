-- Revert postgraphile_schemas:permissions from pg

BEGIN;

grant all on schema public to public;
alter default privileges grant all on sequences to public;
alter default privileges grant all on functions to public;

grant all on schema public to :DATABASE_OWNER;

revoke all on schema public, app_public, app_hidden from :DATABASE_VISITOR;

COMMIT;
