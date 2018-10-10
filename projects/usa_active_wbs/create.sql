begin
   execute immediate 'drop table src_prj_onetimer_usa_active_wbs';
exception
   when others then
      if sqlcode != -942 then
         raise;
      end if;
end;
/

create table src_prj_onetimer_usa_active_wbs (
  project_id  varchar(200)
  , project_name  varchar2(200)
  , description varchar2(200)
  , start_date varchar2(200)
  , end_date varchar2(200)
  , status varchar2(200)
  , project_hierarchy varchar2(200)
  , company varchar2(200)
)
/

exit
