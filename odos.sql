--drop table  #temp2

SELECT --top 10 
       [aud_seqnum],
       qddm_odo,
      qdqm_type,
      -- [sum_fullname]
       qddm_inscoy
      ,qddm_fk_facaccno
      ,SUBSTRING(aud_user,9,8) as [Username]
      --,[sum_fullname]    
      ,[aud_table]
      ,[aud_field]
      ,[aud_user]
      ,[aud_datetime]
      ,[aud_key1]
      ,[aud_key2]
      ,[aud_key3]
      ,[aud_key4]
      ,[aud_key5]
      ,[aud_before]
      ,[aud_after]
      ,[aud_desc]
      
      into #temp2
  FROM  [FleetActiv_Wesbank].[dbo].[FleetAudit]
 
  LEFT  join suma
  on SUBSTRING(aud_user,1,8) = sum_id
  
  left join qddm
  on aud_key1 = qddm.qddm_deal
  
  left join qdqm 
  on qdqm_quote = qddm_fk_quote
  
 where aud_table='qddm' and aud_field='qddm_odo' 
 and qddm.qddm_fk_facaccno = '015478' 
 AND qdqm_type = 'W-OR-COMM-MM'
 order by aud_datetime desc
 
 SELECT * FROM qdqm
 
 LEFT JOIN [FleetAudit]
 ON aud_key2 = qdqm_quote 
 left join qddm 
  on qdqm_quote = qddm_fk_quote
  
 WHERE qdqm_type = 'W-MM'
  and aud_key1 = '015478'
 and qddm.qddm_fk_facaccno = '015478' 
 
 --select top 100 * from qddm
 
 --select * from qddm  where  qddm.qddm_fk_facaccno = '015478' 
 
 
 --truncate table  #temp2
 
 --select * from #temp2 t
 --where Username = 'w4995392'
 
 ----left join
 ----suma
 ----on t.Username = sum_name
 
 
 
 
 select --top 100 
 
   [aud_key1] as DealNumber,
   qdqm_type as ManagedMaintenanceDeals,
  
   [aud_datetime]  AS AuditDate,
   qddm_odo as ODO
    ,SUBSTRING(aud_user,9,8) as [Username]
      ,[sum_fullname] as FullName   
      ,[aud_table]
      ,[aud_field]
      [aud_seqnum],
       [sum_fullname],
       --qddm_inscoy,
      qddm_fk_facaccno as AccountNumber   
      --,[aud_user]
      ,[aud_key2] as QuoteNumber
      ,[aud_key3]
      ,[aud_key4]
      ,[aud_key5]
      ,[aud_before]
      ,[aud_after]
      ,[aud_desc] 
 
 from suma
 RIGHT join #temp2
  on sum_name = Username
  
  ORDER BY AuditDate DESC
  ---------------------------MMMMMMMMMMMMMMMM
  SELECT * FROM qdqm
  LEFT JOIN
  qddm
  on qdqm_quote = qddm_fk_quote
  
--  inner join suma
--ON 
--sum_name = qddm_signby

  WHERE qdqm_type LIKE '%W-MM%'
  
and  qdqm_fk_accno = '015478'

order by qdqm_create desc


 --and aud_key4='015478'
 --and aud_key1='0000110458'
 --sum_fullname
--SECURITY
 
 ------------select top 100 * from suma
  


--DATE 
--ODO
--WHO
