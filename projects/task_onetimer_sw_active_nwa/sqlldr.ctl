--
-- sqlldr userid=wdcnv/W0rkday@P2 control=loader.ctl log=loader.log bad=loader.bad discard=loader.dsc
--

options ( skip=1 )
load data
  infile TASK_ONETIMER_SW_ACTIVE_NWA.TXT
  truncate into table src_task_onetimer_sw_active_nwa
  --fields terminated by ","
  fields terminated by X'9'
  optionally enclosed by '"'
  trailing nullcols (
    project_id
    , project_task_number
    , project_task_name
    , start_date
    , status
    , phase
  )
