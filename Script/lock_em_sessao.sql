col "SESSAO" for a50
set lines 190

SELECT DECODE(l.request, 0, 'Bloqueando: ', 'Aguardando: ') || 'Inst-> ' ||
       s.inst_id || ' Sid:serial-> ' || l.sid || ',' || s.serial# "SESSAO",
       substr(s.username, 1, 15) Username,
       l.lmode,
       l.request,
       l.type,
       sql_hash_value,
       ctime "TEMPO"
  FROM GV$LOCK L, GV$SESSION S
 WHERE (l.id1, l.id2, l.type) IN
       (SELECT l2.id1, l2.id2, l2.type FROM GV$LOCK l2 WHERE l2.request > 0)
   AND s.sid = l.sid
 ORDER BY l.id1, l.request, l.ctime DESC;
