-- Deploy postgraphile_schemas:schemas to pg

BEGIN;

create schema app_public;
create schema app_private;
create schema app_hidden;

COMMIT;
