
select   
qdqm_create 'Create Date',
qdqm_fk_accno,
drm_name 'Debtor_Name',
qdqm_quote 'Quote_Number',
sum_name 'User Code',
sum_fullname 'User Name'   from 
qdqm
left join drm drm 
on drm_accno = qdqm_fk_accno
left join qddm 
on qddm_fk_quote = qdqm_quote
left join suma
on suma.sum_id = qdqm_actrequestuser
where (qdqm_create >= '2019-11-01') and  (qdqm_create <='2019-11-30')
order by qdqm.qdqm_create desc


SELECT top 100 * from fleetaudit
where aud_key2 = '0000108909'
order by aud_datetime desc
--2012-02-20 14:26:29.870


