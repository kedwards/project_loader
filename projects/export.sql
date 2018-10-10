begin
   execute immediate 'drop table tar_projects';
exception
   when others then
      if sqlcode != -942 then
         raise;
      end if;
end;
/

create table tar_projects
as
select project_id
  , project_name
  , cast(null as varchar2(200)) description
  , cast(start_date as varchar2(200)) start_date
  , cast(null as varchar2(200)) end_date
  , currency
  , project_hierarchy
  , 'Y' include_code_in_name
  , 'FIN' src
from (
    select a.project_id, a.project_name, a.description, a.start_date, a.end_date
    , case project_hierarchy
        when 'Spectra East Projects' then 'CAD'
        when 'Spectra West Projects' then 'CAD'
        when 'Spectra USA Projects' then 'USD'
    end as currency
    , case project_hierarchy
        when 'Spectra East Projects' then 'LSE_East_Projects'
        when 'Spectra West Projects' then 'LSE_West_Projects'
        when 'Spectra USA Projects' then 'LSE_USA_Projects'
        else project_hierarchy
    end as project_hierarchy
    from src_prj_onetimer_se_active_io a
    union all
    select b.project_id, b.project_name, b.description, b.start_date, b.end_date
    , case project_hierarchy
        when 'Spectra East Projects' then 'CAD'
        when 'Spectra West Projects' then 'CAD'
        when 'Spectra USA Projects' then 'USD'
    end as currency
    , null project_hierarchy
    from src_prj_onetimer_se_active_wbs b
    union all
    select c.project_id, c.project_name, c.description, c.start_date, c.end_date
    , case project_hierarchy
        when 'Spectra East Projects' then 'CAD'
        when 'Spectra West Projects' then 'CAD'
        when 'Spectra USA Projects' then 'USD'
    end as currency
    , case project_hierarchy
        when 'Spectra East Projects' then 'LSE_East_Projects'
        when 'Spectra West Projects' then 'LSE_West_Projects'
        when 'Spectra USA Projects' then 'LSE_USA_Projects'
        else project_hierarchy
    end as project_hierarchy
    from src_prj_onetimer_sw_active_io c
    union all
    select d.project_id, d.project_name, d.description, d.start_date, d.end_date
    , case project_hierarchy
        when 'Spectra East Projects' then 'CAD'
        when 'Spectra West Projects' then 'CAD'
        when 'Spectra USA Projects' then 'USD'
    end as currency
    , case project_hierarchy
        when 'Spectra East Projects' then 'LSE_East_Projects'
        when 'Spectra West Projects' then 'LSE_West_Projects'
        when 'Spectra USA Projects' then 'LSE_USA_Projects'
        else project_hierarchy
    end as project_hierarchy
    from src_prj_onetimer_sw_active_nw d
    union all
    select f.project_id, f.project_name, f.description, f.start_date, f.end_date
    , case project_hierarchy
        when 'Spectra East Projects' then 'CAD'
        when 'Spectra West Projects' then 'CAD'
        when 'Spectra USA Projects' then 'USD'
    end as currency
    , case project_hierarchy
        when 'Spectra East Projects' then 'LSE_East_Projects'
        when 'Spectra West Projects' then 'LSE_West_Projects'
        when 'Spectra USA Projects' then 'LSE_USA_Projects'
        else project_hierarchy
    end as project_hierarchy
    from src_prj_onetimer_usa_active_wbs f
)
/

begin
   execute immediate 'drop table tar_project_tasks';
exception
   when others then
      if sqlcode != -942 then
         raise;
      end if;
end;
/

create table tar_project_tasks
as
select project_id, project_task_number task_name, start_date, end_date, 'PROJECT_PLAN_PHASE' || '-' || project_id  phase
    , project_id || ' - ' || project_task_name custom_task_name
from (
    select *
    from src_task_onetimer_sw_active_nwa
)
/

begin
   execute immediate 'drop table tar_full_tasks';
exception
   when others then
      if sqlcode != -942 then
         raise;
      end if;
end;
/

create table tar_full_tasks
as
select project_task_number task_name
from (
    select *
    from src_task_onetimer_sw_active_nwa
)
/

set colsep ,
set headsep off
set pagesize 0
set linesize 2000
set trimspool on
set termout off
set trim on
set wrap off
set feedback off

SPOOL exports/429_PROJECTS.txt

SELECT
  'PROJECT_ID'        || chr(9) ||
  'PROJECT_NAME'      || chr(9) ||
  'DESCRIPTION'       || chr(9) ||
  'START DATE'        || chr(9) ||
  'END DATE'          || chr(9) ||
  'CURRENCY'          || chr(9) ||
  'PROJECT HIERARCHY' || chr(9) ||
  'SRC'
FROM DUAL
;

SELECT
  PROJECT_ID        || chr(9) ||
  PROJECT_NAME      || chr(9) ||
  DESCRIPTION       || chr(9) ||
  START_DATE        || chr(9) ||
  END_DATE          || chr(9) ||
  CURRENCY          || chr(9) ||
  PROJECT_HIERARCHY || chr(9) ||
  SRC
FROM TAR_PROJECTS
;

SPOOL exports/428_PROJECT_TASKS.txt

SELECT
  'PROJECT_ID'        || chr(9) ||
  'TASK_NAME'         || chr(9) ||
  'START_DATE'        || chr(9) ||
  'END_DATE'          || chr(9) ||
  'PHASE'             || chr(9) ||
  'CUSTOM_TASK_NAME'
FROM DUAL
;

SELECT
  PROJECT_ID        || chr(9) ||
  TASK_NAME         || chr(9) ||
  START_DATE        || chr(9) ||
  END_DATE          || chr(9) ||
  PHASE             || chr(9) ||
  CUSTOM_TASK_NAME
FROM TAR_PROJECT_TASKS
;

SPOOL exports/428_FULL_TASKS.txt

SELECT
  'TASK_NAME'
FROM DUAL
;

SELECT
  TASK_NAME
FROM TAR_FULL_TASKS
;

SPOOL OFF

exit
