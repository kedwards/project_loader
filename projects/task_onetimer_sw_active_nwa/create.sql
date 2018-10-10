begin
   execute immediate 'drop table src_task_onetimer_sw_active_nwa';
exception
   when others then
      if sqlcode != -942 then
         raise;
      end if;
end;
/

create table src_task_onetimer_sw_active_nwa (
  project_id  varchar(200)
  , project_task_number  varchar2(200)
  , project_task_name varchar2(200)
  , description varchar2(200)
  , start_date varchar2(200)
  , end_date varchar2(200)
  , status varchar2(200)
  , phase varchar2(200)
)
/

exit
