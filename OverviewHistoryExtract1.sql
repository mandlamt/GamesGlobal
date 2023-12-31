USE [FleetActiv_Wesbank]
GO
/****** Object:  StoredProcedure [dbo].[pHorizontalDetails]    Script Date: 3/20/2020 12:26:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--declare @ClientName varchar(50)
ALTER PROCEDURE [dbo].[pHorizontalDetails] (@ClientName as varchar(100))

AS
begin
					 
						

						IF OBJECT_ID('tempdb..#Temps1') IS NOT NULL     --Remove temp here 
						DROP TABLE #Temps1 

					 IF OBJECT_ID('tempdb..#Temp3') IS NOT NULL     --Remove temp here 
						DROP TABLE #Temp3

						 IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL     --Remove temp here 
						DROP TABLE #Temp2 

							 IF OBJECT_ID('tempdb..#Temp4') IS NOT NULL     --Remove temp here 
						DROP TABLE #Temp4

						IF OBJECT_ID('tempdb..#Temp5') IS NOT NULL     --Remove temp here 
						DROP TABLE #Temp5 
							
select 


	   qddm_deal 'DealNumber',
	   isnull(drm_name, drm_longname) 'ClientName',
	   qdqm_vbcpkmaintsell,
	   qdqm_quote,
	   qddm_regno 'RegistrationNo',
	   qddm_chassisno 'ChassisNo'	                      
into #Temp5 from qddm deal
            left join qdqm on qdqm_quote = qddm_fk_quote
            left join (select qddt_fk_deal,
                                       sum(qddt_amount) ServiceAmount
                            from qddt
                              where qddt_ref = 'SERVICES'
                              group by qddt_fk_deal) AdminFee on AdminFee.qddt_fk_deal = qddm_deal
            left join drm on drm_accno =  qdqm_fk_accno
            left join bvvm on qdqm_fk_man = bvvm_fk_man and qdqm_fk_mod = bvvm_fk_mod and qdqm_fk_var = bvvm_var
            left join bvmm on bvvm_fk_man = bvmm_man
            

            left join bvmom on bvvm_fk_man = bvmom_fk_man and bvvm_fk_mod =bvmom_mod
            left join ( select current_dealno, maint_income, maint_expense
                        from Func_QD_ReloadedDealDetails( NULL, getdate())) ReloadedDeal on ReloadedDeal.current_dealno = qddm_deal
            where qddm_new = 'y'
            and qddm_term != 'y'
            and qdqm_type in ('W-SP-CPK','W-SP-MONTHLY','W-SP-UPFRONT','W-MP-CPK','W-MP-MONTHLY','W-MP-UPFRONT')
                
				  					 
select 
	
			[DealNumber],	
			[aud_after],
			[ClientName],	
			[qdqm_vbcpkmaintsell],
			[qdqm_quote],	--
			[ChassisNo],	--
			[aud_table],--
			[aud_field],--
			[aud_user],--
			[aud_datetime],--
			[aud_key1],
			[aud_key2],
			[aud_key3],
			[aud_key4],
			[aud_key5],
			[aud_before],			
			[aud_desc]			
			into #Temp2 from #Temp5 tm
            left join FleetAudit fa on 
            fa.aud_key1 = tm.qdqm_quote
            where
		   [ClientName] = @ClientName 
            and aud_field = 'qdqm_vbcpkmaintsell'            
			order by [DealNumber],aud_datetime desc




SELECT *
 FROM 
(
    SELECT 

DealNumber,
[qdqm_quote],	
[ChassisNo],	
[aud_table],
[aud_field],
[ClientName],	
[aud_after],
[qdqm_vbcpkmaintsell]
		   --,		 [aud_datetime]
    
 FROM #Temp2 
)  AS SourceTable PIVOT(max(aud_after) FOR [aud_after] IN(--[0.00] ,
														  [37.00],
														  [38.00],
														  [41.00],
														  [43.00],
														  [65.00]                                                       
                                                         )) AS PivotTable ;



end
--execute pHorizontalDetails 'VALUE LOGISTICS LIMITED'