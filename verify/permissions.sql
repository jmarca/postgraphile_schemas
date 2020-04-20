-- Verify postgraphile_schemas:permissions on pg

BEGIN;

-- verify sequences public

create sequence public.curbgraph_serial;
create sequence app_public.curbgraph_serial;
create sequence app_hidden.curbgraph_serial;
create sequence app_private.curbgraph_serial;

-- sqitch user (superuser) has permissions
SELECT 1/count(*)
from (select has_sequence_privilege('public.curbgraph_serial', 'usage') as usge) a
where usge;
SELECT 1/count(*)
from (select has_sequence_privilege('app_public.curbgraph_serial', 'usage') as usge) a
where usge;
SELECT 1/count(*)
from (select has_sequence_privilege('app_hidden.curbgraph_serial', 'usage') as usge) a
where usge;
SELECT 1/count(*)
from (select has_sequence_privilege('app_private.curbgraph_serial', 'usage') as usge) a
where usge;

-- public user does not
SELECT 1/count(*)
from (select has_sequence_privilege('public','public.curbgraph_serial', 'usage') as usge) a
where not usge;
SELECT 1/count(*)
from (select has_sequence_privilege('public','app_public.curbgraph_serial', 'usage') as usge) a
where not usge;
SELECT 1/count(*)
from (select has_sequence_privilege('public','app_hidden.curbgraph_serial', 'usage') as usge) a
where not usge;
SELECT 1/count(*)
from (select has_sequence_privilege('public','app_private.curbgraph_serial', 'usage') as usge) a
where not usge;
-- select test
SELECT 1/count(*)
from (select has_sequence_privilege('public','public.curbgraph_serial', 'select') as usge) a
where not usge;
SELECT 1/count(*)
from (select has_sequence_privilege('public','app_public.curbgraph_serial', 'select') as usge) a
where not usge;
SELECT 1/count(*)
from (select has_sequence_privilege('public','app_hidden.curbgraph_serial', 'select') as usge) a
where not usge;
SELECT 1/count(*)
from (select has_sequence_privilege('public','app_private.curbgraph_serial', 'select') as usge) a
where not usge;

-- visitor user does ...
SELECT 1/count(*)
from (select has_sequence_privilege(:'DATABASE_VISITOR','public.curbgraph_serial', 'usage') as usge) a where usge;
SELECT 1/count(*)
from (select has_sequence_privilege(:'DATABASE_VISITOR','app_public.curbgraph_serial', 'usage') as usge) a where usge;
SELECT 1/count(*)
from (select has_sequence_privilege(:'DATABASE_VISITOR','app_hidden.curbgraph_serial', 'usage') as usge) a where usge;
-- but not for app_private
SELECT 1/count(*)
from (select has_sequence_privilege(:'DATABASE_VISITOR','app_private.curbgraph_serial', 'usage') as usge) a where not usge;

-- select permission
SELECT 1/count(*)
from (select has_sequence_privilege(:'DATABASE_VISITOR','public.curbgraph_serial', 'select') as usge) a where usge;
SELECT 1/count(*)
from (select has_sequence_privilege(:'DATABASE_VISITOR','app_public.curbgraph_serial', 'select') as usge) a where usge;
SELECT 1/count(*)
from (select has_sequence_privilege(:'DATABASE_VISITOR','app_hidden.curbgraph_serial', 'select') as usge) a where usge;
-- but not for app_private
SELECT 1/count(*)
from (select has_sequence_privilege(:'DATABASE_VISITOR','app_private.curbgraph_serial', 'select') as usge) a where not usge;



-- To verify execute, can test by creating a fuction, trying to run it

create function public.deleteme_add(a int, b int) returns int as $$
  select a + b
$$ language sql stable;
create function app_public.deleteme_add(a int, b int) returns int as $$
  select a + b
$$ language sql stable;
create function app_private.deleteme_add(a int, b int) returns int as $$
  select a + b
$$ language sql stable;
create function app_hidden.deleteme_add(a int, b int) returns int as $$
  select a + b
$$ language sql stable;


-- sqitch user has execute
SELECT 1/count(*) from (select  has_function_privilege('public.deleteme_add(int,int)', 'execute') as exec) a where exec;
SELECT 1/count(*) from (select  has_function_privilege('app_public.deleteme_add(int,int)', 'execute') as exec) a where exec;
SELECT 1/count(*) from (select  has_function_privilege('app_private.deleteme_add(int,int)', 'execute') as exec) a where exec;
SELECT 1/count(*) from (select  has_function_privilege('app_hidden.deleteme_add(int,int)', 'execute') as exec) a where exec;

-- public does not
SELECT 1/count(*) from (select  has_function_privilege('public','public.deleteme_add(int,int)', 'execute') as exec) a where not exec;
SELECT 1/count(*) from (select  has_function_privilege('public','app_public.deleteme_add(int,int)', 'execute') as exec) a where not exec;
SELECT 1/count(*) from (select  has_function_privilege('public','app_private.deleteme_add(int,int)', 'execute') as exec) a where not exec;
SELECT 1/count(*) from (select  has_function_privilege('public','app_hidden.deleteme_add(int,int)', 'execute') as exec) a where not exec;

-- visitor does
SELECT 1/count(*) from (select  has_function_privilege(:'DATABASE_VISITOR','public.deleteme_add(int,int)', 'execute') as exec) a where exec;
SELECT 1/count(*) from (select  has_function_privilege(:'DATABASE_VISITOR','app_public.deleteme_add(int,int)', 'execute') as exec) a where exec;
SELECT 1/count(*) from (select  has_function_privilege(:'DATABASE_VISITOR','app_hidden.deleteme_add(int,int)', 'execute') as exec) a where exec;
-- except app_private
SELECT 1/count(*) from (select  has_function_privilege(:'DATABASE_VISITOR','app_private.deleteme_add(int,int)', 'execute') as exec) a where not exec;


ROLLBACK;
