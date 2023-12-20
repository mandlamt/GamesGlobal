
drop table  #temp2
SELECT        
      distinct 
     ([aud_seqnum])
     ,([aud_key1])
       ,[aud_key2] 
      ,qddm_odo
      ,[aud_datetime]
      ,qdqm_type
      ,qddm_inscoy
      ,qddm_fk_facaccno
      ,SUBSTRING(aud_user,9,8) as [Username]
      ,[aud_table]
      ,[aud_field]
      ,[aud_user]   
      ,[aud_key3]
      ,[aud_key4]
      ,[aud_key5]
      ,[aud_before]
      ,[aud_after]
      ,[aud_desc]
      
  into #temp2   
  FROM [FleetActiv_Wesbank].[dbo].[FleetAudit]
 
  LEFT  join suma
        on SUBSTRING(aud_user,1,8) = sum_id
  LEFT  join qddm
        on aud_key1 = qddm.qddm_deal
  left join qdqm
        on qddm_fk_quote =  aud_key2 
 where aud_table='qddm' 
 and aud_field='qddm_odo'  
 --and qdqm_type LIKE '%W-MM%'
 and qdqm_type  = 'W-MM'
 and qdqm_fk_accno = '015478' and qdqm_fk_accno is not null
 and qddm_fk_facaccno = '015478'
order by aud_datetime desc 

  


select 
		aud_seqnum	
		,aud_key1	
		,aud_key2	
		,qddm_odo	
		,aud_datetime	
		,qdqm_type	
		,qddm_inscoy
		,qddm_fk_facaccno	
		,Username	
		,[sum_fullname] 
		,aud_table	
		,aud_field	
		,aud_before	
		,aud_after	
		,aud_desc

	from 
	#temp2

LEFT JOIN  suma
   on sum_name = Username
   ORDER BY aud_datetime DESC
   
--DEAL NUMBER 
--DATE 
--ODO
--WHO
--ROLLBACK
