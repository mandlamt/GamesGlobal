USE [FleetActiv_Wesbank]
GO
/****** Object:  StoredProcedure [dbo].[pHorizontalDetails1]    Script Date: 3/20/2020 12:26:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--declare @ClientName varchar(50)
alter PROCEDURE [dbo].[pHorizontalDetails1] (@ClientName as varchar(100))

AS
					 IF OBJECT_ID('tempdb..#Temp') IS NOT NULL     --Remove temp here 
						DROP TABLE #Temp 

						IF OBJECT_ID('tempdb..#Temp1') IS NOT NULL     --Remove temp here 
						DROP TABLE #Temp1 
select 


qddm_deal 'DealNumber',
	   isnull(drm_name, drm_longname) 'ClientName',
	   NULL 'SellingDealer',
	   qdqm_vbcpkmaintsell,
	   qdqm_quote,
	   qddm_chassisno 'ChassisNo'
	  
		                      
into #Temp from qddm deal
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
			[ClientName],	
			[SellingDealer],	
			[qdqm_vbcpkmaintsell],	
			[qdqm_quote],
			[ChassisNo],	
			--[aud_datetime],
			[aud_after]


			
			into #Temp1 from #Temp tm
            left join FleetAudit fa on 
            fa.aud_key1 = tm.qdqm_quote
            where

		   [ClientName] = @ClientName ----'VALUE LOGISTICS LIMITED' --
            and 
            aud_field = 'qdqm_vbcpkmaintsell'
            order by [DealNumber],aud_datetime desc



DECLARE @cols AS NVARCHAR(MAX),
@query  AS NVARCHAR(MAX)
select @cols = STUFF((SELECT ',' + QUOTENAME([aud_after]) --,[ClientName]	
                 from #Temp1
                group by [aud_after]--, [ClientName]
                order by [aud_after] ASC
        FOR XML PATH(''), TYPE
        ).value('.', 'NVARCHAR(MAX)') 
    ,1,1,'')
set @query = 'SELECT [DealNumber],
                     [ClientName],
					 [ChassisNo],
					 --[aud_datetime],
					 ' + @cols + ' from 
         (
            select [DealNumber],[ClientName],[ChassisNo],
					--[aud_datetime], 
					[aud_after]
            from  #Temp1
        ) x
        pivot 
        (
		    max(aud_after)
           
            for [aud_after] in (' + @cols + ')
        ) p '
        
        execute(@query);

	
        
		exec pHorizontalDetails1 'VALUE LOGISTICS LIMITED'