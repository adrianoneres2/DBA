col sessao for a25
col event for a50
col username for a25
col osuser for a25
set lines 200
 with a as (
   select level lev,
 CONNECT_BY_ROOT  COL1 BLOCKER, col1 lev1
 from ((select  inst_id||','||sid col1,event,sql_id,program,blocking_instance 
||','||blocking_session  col2,seconds_in_wait
   from gv$session))
  connect by nocycle prior col2=col1
 start with col2 in (select blocking_instance ||','||blocking_session from gv$session where 
blocking_session is not null)
 ) ,
 b as (
 select distinct lev1 from a where (a.lev,a.blocker) in (select max(lev),blocker from a group by 
blocker)
 )  
          select 
     lpad(' ',3*(level-1)) || col1 sessao,username, osuser, event,sql_id,seconds_in_wait
    from ((select  inst_id||','||sid col1,username,  osuser, event,sql_id,program,blocking_instance 
||','||blocking_session  col2,seconds_in_wait 
      from gv$session))
    connect by nocycle prior col1=col2
    start with col1 in (select lev1 from b) 
    ;
