SET client_min_messages TO warning;
CREATE EXTENSION IF NOT EXISTS pgtap;
RESET client_min_messages;

BEGIN;
-- SELECT no_plan();
SELECT plan(10);

SELECT pass('Test permissions!');


-- authenticated role should have no permissions to speak of

-- should also pass for owner
--SET ROLE :DATABASE_OWNER;
SET client_min_messages = warning;
CREATE TABLE public.plaba(
    user_name  TEXT UNIQUE NOT NULL,
    uid        INT PRIMARY KEY
);
alter table public.plaba enable row level security;
create policy select_all on public.plaba for select using (true);
grant select on public.plaba to :DATABASE_VISITOR;


INSERT INTO public.plaba VALUES
  ('admin',0),
  ('james',1),
  ('jmarca',2);

-- app_public
CREATE TABLE app_public.plaba(
    user_name  TEXT UNIQUE NOT NULL,
    uid        INT PRIMARY KEY
);
alter table app_public.plaba enable row level security;
create policy select_all on app_public.plaba for select using (true);
grant select on app_public.plaba to :DATABASE_VISITOR;


INSERT INTO app_public.plaba VALUES
  ('admin',0),
  ('james',1),
  ('jmarca',2);

-- app_private
CREATE TABLE app_private.plaba(
    user_name  TEXT UNIQUE NOT NULL,
    uid        INT PRIMARY KEY
);
alter table app_private.plaba enable row level security;
create policy select_all on app_private.plaba for select using (true);
grant select on app_private.plaba to :DATABASE_VISITOR;


INSERT INTO app_private.plaba VALUES
  ('admin',0),
  ('james',1),
  ('jmarca',2);

-- create functions to access the data
create function public.get_plaba() returns public.plaba as $$
       SELECT user_name, uid FROM public.plaba order by uid LIMIT 1;
       $$ language sql stable;
create function app_public.get_plaba() returns app_public.plaba as $$
       SELECT user_name, uid FROM app_public
       .plaba order by uid LIMIT 1;
       $$ language sql stable;
create function app_private.get_plaba() returns app_private.plaba as $$
       SELECT user_name, uid FROM app_private.plaba order by uid LIMIT 1;
       $$ language sql stable;

RESET client_min_messages;



PREPARE get_public_user AS SELECT user_name, uid FROM public.get_plaba();
PREPARE get_app_public_user AS SELECT user_name, uid FROM app_public.get_plaba();
PREPARE get_app_private_user AS SELECT user_name, uid FROM app_private.get_plaba();

-- obviously this should work okay for sqitch user
SELECT row_eq( 'get_public_user', ROW('admin', 0)::public.plaba );
SELECT row_eq( 'get_app_public_user', ROW('admin', 0)::app_public.plaba );
SELECT row_eq( 'get_app_private_user', ROW('admin', 0)::app_private.plaba );

-- should fail for db owner...not used here for owner
SET ROLE :DATABASE_OWNER;

SELECT throws_matching( 'get_public_user', 'permission denied ', 'should error due to missing permissions');
SELECT throws_matching( 'get_app_public_user',  'permission denied ', 'should error due to missing permissions');
SELECT throws_matching( 'get_app_private_user', 'permission denied ', 'should error due to missing permissions');

-- should fail for authenticator
-- actually, don't even bother...  db authenticator account can't even see throws_matching function
-- SELECT throws_matching( 'get_public_user', 'permission denied ', 'should error due to missing permissions');
-- SELECT throws_matching( 'get_app_public_user',  'permission denied ', 'should error due to missing permissions');
-- SELECT throws_matching( 'get_app_private_user', 'permission denied ', 'should error due to missing permissions');

-- only private should fail for visitor
SET ROLE :DATABASE_VISITOR;

SELECT row_eq( 'get_public_user', ROW('admin', 0)::public.plaba );
SELECT row_eq( 'get_app_public_user', ROW('admin', 0)::app_public.plaba );

-- but even though granted select permission, DB Visitor cannot see schema app_private, and so cannot use function
SELECT throws_matching( 'get_app_private_user', 'permission denied ', 'should error due to missing permissions private user');


SELECT finish();
ROLLBACK;
