--
-- sqlldr userid=wdcnv/W0rkday@P2 control=loader.ctl log=loader.log bad=loader.bad discard=loader.dsc
--

options ( skip=1 )
load data
  infile PRJ_ONETIMER_SW_ACTIVE_WO.csv
  truncate into table src_prj_onetimer_sw_active_wo
  fields terminated by ","
  --fields terminated by X'9'
  optionally enclosed by '"'
  trailing nullcols (
    project_id
    , company
    , status
    , project_hierarchy
    , project_name
  )
