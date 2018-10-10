--
-- sqlldr userid=wdcnv/W0rkday@P2 control=loader.ctl log=loader.log bad=loader.bad discard=loader.dsc
--

options ( skip=1 )
load data
  infile PRJ_ONETIMER_SE_ACTIVE_WBS.csv
  badfile loader.bad
  discardfile loader.dsc
  truncate into table src_prj_onetimer_se_active_wbs
  fields terminated by ","
  --fields terminated by X'9'
  optionally enclosed by '"'
  trailing nullcols (
    project_id
    , project_name
    , description
    , start_date
    , end_date
    , status
    , project_hierarchy
    , company
  )
