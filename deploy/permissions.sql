-- Deploy postgraphile_schemas:permissions to pg
-- requires: schemas
-- requires: postgraphile_roles:owner_role
-- requires: postgraphile_roles:authenticated_role
-- requires: postgraphile_roles:anonymous_role

BEGIN;


alter default privileges revoke all on sequences from public;
alter default privileges revoke all on functions from public;
revoke all on schema public from public;

grant all on schema public, app_public, app_hidden to :DATABASE_OWNER;
grant usage on schema public, app_public, app_hidden to :DATABASE_VISITOR;

alter default privileges in schema public, app_public, app_hidden grant usage, select on sequences to :DATABASE_VISITOR;
alter default privileges in schema public, app_public, app_hidden grant execute on functions to :DATABASE_VISITOR;


COMMIT;
