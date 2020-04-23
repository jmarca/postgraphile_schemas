-- Revert postgraphile_schemas:permissions from pg

BEGIN;

alter default privileges in schema public, app_public, app_hidden revoke usage, select on sequences from :DATABASE_VISITOR;
alter default privileges in schema public, app_public, app_hidden revoke execute on functions from :DATABASE_VISITOR;

grant all on schema public to public;
alter default privileges grant all on sequences to public;
alter default privileges grant all on functions to public;

revoke all on schema public, app_public, app_hidden from :DATABASE_OWNER;

revoke all on schema public, app_public, app_hidden from :DATABASE_VISITOR;

COMMIT;
