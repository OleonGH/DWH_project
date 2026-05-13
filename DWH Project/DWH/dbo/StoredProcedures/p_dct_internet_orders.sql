CREATE PROCEDURE dbo.p_dct_internet_orders @dd int=7
AS
-- polyakov    #9406 (#10258) DWH ïðèçíàê îíëàéí îïëàòû
-- polyakov    #10416 Èíòåðíåò-çàêàç. Êîððåêòíîå çàïîëíåíèå àòðèáóòà «Èñòî÷íèê çàêàçà» ïðè îòñóòñòâèè äàííûõ magento
-- safonov     #11641 Ñèíõðîíèçèðîâàòü ãëóáèíó çàãðóçêè èíòåðíåò-çàêàçîâ ef2 è magento
-- safonov     #13022 Çàêàçû market.yandex â DWH
-- polyakov    #13636 Ïðîãðóçèòü äàííûå ïî ìàðêåòïëåéñàì 
-- polyakov    #13102 Âîðîíêà ïðîäàæ â Êóáå
-- polyakov    #13902 Îïåðàòîð êîë-öåíòðà â èíòåðíåò-çàêàçàõ
-- khizhnyakov #15157 Êîððåêòèðîâêà çàïîëíåíèÿ site_name ïðè çíà÷åíèÿõ app_point ñîäåðæàùèõ "mobile"
-- khizhnyakov #15100 Ðåôàêòîðèíã êîäà çàïîëíåíèÿ ìàðêåòïëåéñîâ
-- khizhnyakov #15107 Çàïîëíåíèå äàòû èíòåðíåò-çàêàçà ïî äàòå ñîçäàíèÿ çàêàçà ecom
-- polyakov    #15589 èíêðåìåíòíàÿ çàãðóçêà äëÿ magento ïî òàáëèöàì magento_sales.sales_order_* è magento_master.tagesjump_xport
-- martynov    #15946 Êîððåêòèðîâàòü èíêðåìåíò dct_tables äëÿ ñàéòîâ magento ñ ó÷åòîì äàííûõ eF ïî èíòåðíåò-çàêàçàì
-- kornilov    #15161 Ñîçäàòü è çàïîëíÿòü â òàáëèöå ldr.ecom_orders, dwh.dct_internet_orders ïîëå domain_name
-- khizhnyakov #17123 Ïðèâåäåíèå íîìåðà òåëåôîíà ê ôîðìàòó +7ÕÕÕÕÕÕÕÕÕÕ
-- khizhnyakov #17692 Áëîêèðîâêà êîäà îáíîâëåíèÿ àòðèáóòîâ èíòåðíåò-çàêàçîâ
-- kornilov    #15723 Äîáàâëåí [customer_group] 
-- khizhnyakov #18388 Ñáðîñ íå êîððåêòíûõ íîìåðîâ
-- martynov    #18483 Óñòðàíåíèå ïðîáëåìû íåîáíîâëåíèÿ àòðèáóòà "èñòî÷íèê" èíòåðíåò-çàêàç
-- khizhnyakov #19274 Êîððåêòèðîâêà çàïîëíåíèÿ site_name ïðè çíà÷åíèÿõ app_point ñîäåðæàùèõ "mobile"
-- khizhnyakov #20635 èñïðàâèòü îøèáî÷íóþ ïðèâÿçêó çàêàçîâ eapteka ê ñàéòó apteka.ru
-- kornilov    #21864 Ðåôàêòîðèíã dct_internet_orders_fill â ÷àñòè ïðèìåíåíèÿ èñòî÷íèêà LDR.dbo.magento, p_dct_tables_increment_id â ÷àñòè îòêàòà èíêðåìåíòà
-- kornilov    #22515 Óñòðàíèòü çàìíîæåíèå çàêàçîâ â dct_internet_orders ñ îäèíàêîâûì guid 
-- kornilov    #22416 Âîññòàíîâëåíèå íîìåðîâ çàêàçîâ è àòðèáóòîâ, ïîäëåæàùèõ èçìåíåíèþ íà èíòåðâàëå çàãðóçêè ecom 	
-- strekalov   #23449 Äîáàâëåíî ïîëå parent_internet_order_id
-- kornilov    #24899 Îøèáêà Invalid object name '#parent_orders' â ðàáîòå ïðîöåäóðû dbo.references_fill
-- kornilov    #26386 Íàïîëíåíèå internet_order_id â òàáëèöå dct_lots
-- pisarev     #26742 ïîðÿäêîâûé íîìåð çàêàçà ïî íîìåðó òåëåôîíà, òîëüêî äëÿ òåõ, êîòîðûå áûëè äîáàâëåíû â òàáëèöó
-- mishin      #28196 Èçìåíåíèå ïîðÿäêà ïîëåé â èíäåêñå ix_tmp_internet_order_#t; äîáàâëåíèå ïîäñêàçêè forceseek; Çàìåíà merge dct_internet_orders.phone íà update ñ where ïî äàòå
-- kornilov    #27843 óñòðàíèòü çàìíîæåíèå è ïðè÷èíû ecom_orders (ìåðæèíã âî âðåìÿ ïðèåìêè polyakov)
-- polyakov	   #29100 Ïðîïàëè èíòåðíåò çàêàçû Íîâãîðîä ñ 20250304
-- polyakov	   #26059 äîïîëíåíèå ñîáûòèé ïî èíòåðíåò-çàêàçó âèðòóàëüíûì ñîáûòèåì ecom.new
-- polyakov	   #26059 V2 (óñòàíîâêà #30139) èñêëþ÷åíèå ðèñêà çàìíîæåíèÿ èíòåðíåò-çàêàçîâ (êîððåêòíîå âû÷èñëåíèå is_new, åñëè çàêàç íå äîøåë äî eF, íî åñòü â ecom)
-- ufimtsev	   #29788 Íå çàïèñûâàòü äàòû ñîçäàíèÿ îðäåðîâ èç áóäóùåãî â dct_internet_orders
-- mishin	   #30640 îòêëþ÷èòü ðàññûëêó sms ïðè ïîÿâëåíèè îðäåðîâ ñ äàòîé èç áóäóþùåãî
-- mishin      #30708 èñïîëüçîâàòü òàáëèöó ecom_orders_items
-- mishin      #27690 çàïîëíåíèå ïîëÿ app_point
-- si_surin    #33735 Íåêîððåêòíîå îïðåäåëåíèÿ ðîäèòåëüñêîãî îðäåðà. Îòâÿçàòü ïîèñê îò dct_stores
-- mishin      #34807 Ðàçáèòü èíòåðíåò-çàêàçû íà îòäåëüíûå èçìåðåíèÿ
-- mishin      #36574 Èçìåíèòü dct_internet_order_attributes
-- mishin      #36998 Íåêîððåêòíîå çàïîëíåíèå ïîëÿ app_point â dct_internet_orders
declare @name varchar(max) = 'dwh.dbo.' +  object_name( @@procid )
declare @step_name varchar (max) -- polyakov íàèìåíîâàíèå øàãà ëîãèðîâàíèÿ
declare @start_state varchar(255) = 'start'
declare @finish_state varchar(255) = 'finish'

begin try

	exec dbo.p_sup_log @name = @name, @state_name = @start_state, @task_id=null 

 	exec dbo.p_sup_exist_table @table_name = '[LDR].[dbo].[ef2_internet_order]'
 
	-->> polyakov #27843 ñîçäàåì òàáëèöó äëÿ îòñåèâàíèÿ ñòàðûõ äóáëåé
	-- ïðåäïîëàãàåì ÷òî âñÿ àêòóàëüíàÿ èíôîðìàöèÿ ïåðåíîñèòñÿ â ecom íà íîâûå çàïèñè ñ òåì æå guid 
	-- (òàê îíî è áûëî ïðè èíöèäåíòå â êîíöå 2024 ãîäà)

	if  Object_ID('tempdb..#exclude_ecom_orders') is not null drop table #exclude_ecom_orders
	select order_id 
	into #exclude_ecom_orders
	from (
		 select e.order_guid,e.order_id, e.ts, 
		 row_number() over (partition by e.order_guid order by e.order_id desc) rn
		 from ldr.dbo.ecom_orders (NOLOCK) e
		 where order_guid IN (select eord.order_guid
				from ldr.dbo.ecom_orders eord (NOLOCK)
				group by eord.order_guid
				having COUNT(1) > 1)
		 ) res where rn > 1

	--<< polyakov #27843

    -->> polyakov #21864 îòáîð èäåíòèôèêàòîðîâ çàêàçîâ, êîòîðûå èçìåíèëèñü
    -- îò eF áåðåì òîëüêî ñîñòîÿíèå
    -- îò ecom ïî äàòå ñîçäàíèÿ è òàéìøòàìïó â ðàìêàõ óñòàíîâëåííîé ãëóáèíû
    -- òåñò íà áîþ äî ïðèìåíåíèÿ #guids 00:35:41
    -- ñ ïðèìåíåíèåì giuds 00:02:22
	set @step_name = concat(@name,' insert #guids')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null
	
	-- #26059 polyakov ïðè îòáîðå èäåíòèôèêàòîðîâ íóæíî ñîåäèíÿòü ïî full join, ò.ê. íå âñå çàêàçû ñâîåâðåìåííî äîõîäÿò äî eF
	-- #26059 V2 polyakov äëÿ íåäîøåäøèõ äî eF çàêàçîâ íåîáõîäèìî äåëàòü êîíòðîëá íà äîáàâëåíèå â ñïðàâî÷íèê çàêàçîâ
	select distinct isnull(eford.internet_order_guid, try_cast(eord.order_guid as uniqueidentifier)) [internet_order_guid], 
		case when ord.internet_order_guid is null 
				and ord_by_ecom.internet_order_guid is null -- #26059 V2
				then 1 end is_new
        into #guids
        from LDR.dbo.ef2_internet_order (nolock) eford
		full join LDR.dbo.ecom_orders (nolock) eord on try_cast(eord.order_guid as uniqueidentifier) = eford.internet_order_guid 
        left join dct_internet_orders (nolock)  ord on eford.internet_order_guid = ord.internet_order_guid and eford.db_id = ord.db_id
		-->> #26059 V2
		left join dct_stores (nolock) st on eord.store_id = st.store_id
		left join dct_internet_orders (nolock)  ord_by_ecom on try_cast(eord.order_guid as uniqueidentifier) = ord_by_ecom.internet_order_guid 
														and st.db_id = ord_by_ecom.db_id
		--<< #26059 V2
	    where (isnull(eford.state,'') <> isnull(ord.state,'')
        or ord.internet_order_guid is null
        or eord.order_guid is not null)
		-->> #29100
		--and eord.order_id not in (select order_id from #exclude_ecom_orders) -- #27843
		and isnull(eord.order_id,-1) not in (select order_id from #exclude_ecom_orders) -- #27843 #29100 polyakov Çàêàçîâ Íîâãîðîäà íåò â ecom, ïðèìåÿåì isnull äëÿ êîððåêòíîãî îòáîðà
		--<< #29100
   	 and 
		((try_cast(eord.order_guid as uniqueidentifier) is not null and (eord.order_date >=   CONVERT(date,GETDATE()-@dd) or eord.ts >=           CONVERT(date,GETDATE()-@dd)))
			or (eford.internet_order_guid is not null and eford.create_date >= CONVERT(date,GETDATE()-@dd))
		)


    --<< polyakov #21864 îòáîð èäåíòèôèêàòîðîâ çàêàçîâ, êîòîðûå èçìåíèëèñü
	print 'guids = ' + ltrim(@@rowcount)
    create clustered index ix_tmp_#guids on #guids (internet_order_guid) 
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null
	
	set @step_name = concat(@name,' insert #internet_order_wait_type')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

	-->> polyakov #13102
	if  Object_ID('tempdb..#internet_order_wait_type') is not null drop table #internet_order_wait_type
		select DISTINCT  -- #22515 
			  WAIT, WAIT_HUB, WAIT_PROTEK, 
		try_cast(order_guid as uniqueidentifier) order_guid
		into #internet_order_wait_type
		from (
		select ROW_NUMBER() over (partition by order_id order by state) rn,
		sum(iif(state = 'WAIT',1,0)) over (partition by order_id) WAIT,
		sum(iif(state = 'WAIT_HUB',1,0)) over (partition by order_id) WAIT_HUB,
		sum(iif(state = 'WAIT_PROTEK',1,0)) over (partition by order_id) WAIT_PROTEK,
		try_cast(order_guid as uniqueidentifier) order_guid
		from (
			  select distinct evt.STATE, evt.order_id, ord.order_guid from ldr.dbo.ecom_order_states (nolock) evt
			   inner join ldr.dbo.ecom_orders (nolock) ord on evt.order_id = ord.order_id 
			   inner join #guids gds on try_cast(ord.order_guid as uniqueidentifier) = gds.internet_order_guid
			  where state like 'WAIT%' and evt.ext_source_id = 1
				and ord.order_id not in (select order_id from #exclude_ecom_orders) -- #27843
			 ) res 
			) res1
		where rn = 1 and WAIT <> 0 and WAIT_HUB <> 0
	print 'wait = ' + ltrim(@@rowcount)
	
	create clustered index ix_tmp_internet_order_wait_type on #internet_order_wait_type (order_guid)
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null
	--<< polyakov #13102
	
	set @step_name = concat(@name,' check and insert default value')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

	IF not exists (select * from [dbo].[dct_internet_orders] (nolock) where [internet_order_id] = -1) 
	BEGIN
		set identity_insert [dbo].[dct_internet_orders]  on
		INSERT INTO [dbo].[dct_internet_orders] 
		(		
			  [internet_order_id]
			, [internet_order_guid]
			, [number]
			, [create_date]
			, [phone]
			, [delivery_type]
			, [delivery_service_name]
			, [state]
			, [db_id]
			, [site_name]
			, [source]
			, [delivery_date]
			, [payment_method_name]   -- polyakov #9406 (#10258)
			, [income_date]
			, [wait_type]             -- polyakov #13102
			, [wait]                  -- polyakov #13102
			, [is_callcentr]          -- polyakov #13902
			, [operator_email]        -- polyakov #13902
			, [domain_name]           -- kornilov #15161
			, [customer_group]        -- kornilov #15723
			, [parent_internet_order_id]    -- strekalov #23449
		)
		SELECT
			  [internet_order_id] = -1
			, [internet_order_guid] =   '00000000-0000-0000-0000-000000000000'
			, [number] =                'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
			, [create_date] =           '1900-01-01'
			, [phone] =                 'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
			, [delivery_type] =         'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
			, [delivery_service_name] = 'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
			, [state] =                 'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
			, [db_id] =                  -1
			, [site_name] =             'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
			, [source] =                'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
			, [delivery_date] =         '1900-01-01'
			, [payment_method_name] =   'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- polyakov #9406 (#10258)
			, [income_date] =           '1900-01-01'
			, [wait_type] =             'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- polyakov #13102
			, [wait] =                  'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- polyakov #13102
			, [is_callcentr] =          'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- polyakov #13102
			, [operator_email] =        'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- polyakov #13102
			, [domain_name] =           'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- kornilov #15161
			, [customer_group]  =       'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- kornilov #15723
			, [parent_internet_order_id] = -1		    -- strekalov #23449
		set identity_insert [dbo].[dct_internet_orders]  off
	END
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

	if  Object_ID('tempdb..#t') is not null drop table #t
	
	CREATE TABLE #t
	(
		[db_id]					int				NULL,
		[number]				varchar(255)	NULL,
		[create_date]			datetime		NOT NULL,
		[phone]					varchar(255)	NULL,
		[delivery_type]			varchar(255)	NULL,
		[state]					varchar(255)	NULL,
		[internet_order_guid]	uniqueidentifier,
		store_id				BIGINT			 NULL,
		site_name				VARCHAR(255)	 NULL,
		[source]				VARCHAR(255)	 NULL,
		[delivery_date]			DATETIME,
		[payment_method_name]	VARCHAR(255)	 NULL,	-- polyakov #9406 (#10258)
		[ecom_order_flag]		bit				 NULL,	-- safonov  #13022
		[income_date]			DATETIME		 NULL,		
		[wait_type]				VARCHAR (255)	 NULL,	-- polyakov #13102
		[wait]					VARCHAR (255)	 NULL,	-- polyakov #13102
		[is_callcentr]			VARCHAR (255)    NULL,	-- polyakov #13902
		[operator_email]		VARCHAR (255)    NULL,	-- polyakov #13902
		[domain_name]           VARCHAR (255)    NULL,  -- kornilov #15161
		[customer_group]        VARCHAR (255)    NULL,  -- kornilov #15723		
		[is_new]                BIT              NULL,
		[is_sip_site]           BIT              NULL,
		[is_own_site]           BIT              NULL,
		calc_site_name AS
			CASE site_name
				WHEN 'ïðèëîæåíèå rigla' THEN 'rigla.ru'
				WHEN 'ïðèëîæåíèå budzdorov' THEN 'budzdorov.ru'
				WHEN 'ïðèëîæåíèå aptekazhivika' THEN 'aptekazhivika.ru'
				WHEN 'eapteka.ru/stock' THEN 'eapteka.ru'
				WHEN 'eapteka.ru/ship-invoice' THEN 'eapteka.ru'
				ELSE ISNULL(site_name,'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
			END 
	) 

	--create clustered index ix_tmp_internet_order_#t on #t (db_id,internet_order_guid) -- 28196
	create clustered index ix_tmp_internet_order_#t on #t (internet_order_guid,db_id) -- 28196
	
	set @step_name = concat(@name,' insert #eo')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

	if  Object_ID('tempdb..#eo') is not null drop table #eo
		select 
	           TRY_CAST(e.order_guid as uniqueidentifier) [order_guid]
	         , e.ext_source_id, e.income_date, e.is_callcentr, e.operator_email, ext_source_code, e.order_id, e.order_date, es.msk_dt 
		     , e.domain_name, e.customer_group
		     , e.order_number, e.app_point 
		     , e.[source], e.[delivery_date] 
			 , e.delivery_type -- #23449
			 , e.[payment_method_name]
			 , e.[state] --#26386
			 , e.[phone] --#26386
			 , e.[db_id] -- #26059
			 , e.[store_id] -- #26059
			 into #eo
		from 
		(
			select e.order_guid, e.ext_source_id, ISNULL(max(eoi.income_date),max(ed.income_date)) income_date, e.[is_callcentr], e.[operator_email]
				 , src.ext_source_code      -- khizhnyakov #15100
				 , max(e.order_id) order_id -- kornilov #22515
				 , e.order_date             -- khizhnyakov #15107
				 , e.domain_name            -- kornilov #15161
				 , e.customer_group         -- kornilov #15723
				 , e.order_number           --#21864
				 , e.app_point              --#21864
				 , case 
					   when e.app_point = 'mobile' and e.ext_source_id in (2,3,71) then 'ìîá ïðèëîæåíèå'
					   when e.ext_source_id = 1 or e.ext_source_id is null then 'eF' 
					   when e.ext_source_id is null then 'eF' 
					   when e.app_point = 'eapteka.ru' then 'ìàðêåòïëåéñ'
					   when e.ext_source_id in (9,10,70) then 'ìàðêåòïëåéñ'
					   when e.ext_source_id in (2,3,71) then 'ñàéò' 
				   else 'ÍÅ ÎÏÐÅÄÅËÅÍÎ' 
			       end as [source] 
                 , e.delivery_date
				 , e.delivery_type -- #23449
                 , case
				       when e.ext_source_id in (2,3,4,71) and prepaid = 1 then 'Ñáåðáàíê'
				       when e.ext_source_id not in (2,3,4,71) and prepaid = 1 then 'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- ò.å. íåèçâåñòíî íà ÷åé ñ÷åò
				       when ISNULL(prepaid,0) = 0 then 'Ïðè ïîëó÷åíèè'
				   else 'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
			       end  as [payment_method_name],
				   e.order_state as [state], --#26386
				   e.client_phone as [phone], --#26386
				   isnull(st.db_id,-1) as [db_id], -- #26059
				   isnull(st.store_id,-1) as [store_id] -- #26059
			  from       
			      [LDR].[dbo].[ecom_orders] e          (nolock)
				  inner join #guids gds on TRY_CAST(e.order_guid as uniqueidentifier) = gds.internet_order_guid
			      LEFT JOIN [LDR].[dbo].[ecom_orders_details] ed (nolock) on ed.order_id=e.order_id
			      LEFT JOIN [LDR].[dbo].[ecom_orders_items] eoi (nolock) on eoi.order_id=e.order_id -- 30708
				  INNER JOIN [LDR].[dbo].[ecom_ext_sources] src   (nolock) on e.ext_source_id = src.ext_source_id  -- khizhnyakov #15100
			      left join dct_stores (nolock) st on e.store_id = st.store_id -- #26059														   
			where e.order_id not in (select order_id from #exclude_ecom_orders) -- #27843
			GROUP BY e.order_guid,e.ext_source_id, e.[is_callcentr], e.[operator_email]
				   , src.ext_source_code      -- khizhnyakov #15100
				   --, e.order_id             -- kornilov #22515
				   , e.order_date             -- khizhnyakov #15107
				   , e.domain_name            -- kornilov #15161
				   , e.customer_group         -- kornilov #15723
				   , e.order_number           --#21864
				   , e.app_point              --#21864
				   , case 
						 when e.app_point = 'mobile' and e.ext_source_id in (2,3,71) then 'ìîá ïðèëîæåíèå'
						 when e.ext_source_id = 1 or e.ext_source_id is null then 'eF' 
						 when e.ext_source_id is null then 'eF' 
						 when e.app_point = 'eapteka.ru' then 'ìàðêåòïëåéñ'
					  	 when e.ext_source_id in (9,10,70) then 'ìàðêåòïëåéñ'
						 when e.ext_source_id in (2,3,71) then 'ñàéò'
				     else 'ÍÅ ÎÏÐÅÄÅËÅÍÎ' 
                     end -- [source] 
                   , e.delivery_date 
				   , e.delivery_type -- #23449
			       , case
					     when e.ext_source_id in (2,3,4,71)     and e.prepaid = 1 then 'Ñáåðáàíê'
					     when e.ext_source_id not in (2,3,4,71) and e.prepaid = 1 then 'ÍÅ ÎÏÐÅÄÅËÅÍÎ' -- ò.å. íåèçâåñòíî íà ÷åé ñ÷åò
					     when ISNULL(prepaid,0) = 0 then 'Ïðè ïîëó÷åíèè'
					 else 'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
					 end  -- [payment_method_name]

					, e.order_state  --#26386
				    , e.client_phone --#26386
					, isnull(st.db_id,-1) -- #26059
					, isnull(st.store_id,-1) -- #26059
		) e
		left join (
		        	select max(eos.msk_dt) msk_dt, eos.order_id        -- kornilov #22515
					from [LDR].[dbo].[ecom_order_states] eos (nolock)
					where eos.state = 'NEW' and eos.ext_source_id = 1
						and eos.order_id not in (select order_id from #exclude_ecom_orders) -- #27843
					group by  eos.order_id                             -- kornilov #22515
		          ) es on es.order_id = e.order_id

	create clustered index ix_tmp_eo on #eo ([order_guid])
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

	set @step_name = concat(@name,' insert #ap_tblDomains')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

	if  Object_ID('tempdb..#ap_tblDomains') is not null drop table #ap_tblDomains	
		SELECT DISTINCT replace(OrderPrefix, '/','') OrderPrefix
		INTO #ap_tblDomains
		  from 
				ldr.dbo.[ap_tblDomains]
				where replace(OrderPrefix, '/','') not like 'protek_%'    -- èñêëþ÷àåì (protek1.ru, protek.ru')
				  and replace(OrderPrefix, '/','') not like 'vseapteki_%' -- èñêëþ÷àåì (vseapteki.ru) 
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

	set @step_name = concat(@name,' insert #t')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

	INSERT INTO #t
	(
	   [db_id]
      ,[number]
      ,[create_date]
      ,[phone]
      ,[delivery_type]
      ,[state]
	  ,[internet_order_guid]
	  ,[site_name]
	  ,[Store_id]
	  ,[ecom_order_flag]
	  ,[income_date]
	  ,[wait_type]           -- polyakov #13102
	  ,[wait]                -- polyakov #13102
	  ,[is_callcentr]        -- polyakov #13902
	  ,[operator_email]      -- polyakov #13902
	  ,[domain_name]         -- kornilov #15161
	  ,[customer_group]      -- kornilov #15723
	  ,[source] 
	  ,[delivery_date]		
	  ,[payment_method_name]
	  ,[is_new]
	)
	
	SELECT 
       --COALESCE(i.[db_id], ds.[db_id], -1) as [db_id] --#26386
	  COALESCE(i.[db_id], ds.[db_id], eo.[db_id], -1) as [db_id] --#26059
      ,case 
		when eo.ext_source_id = 1 then isnull(eo.order_number, i.[number]) 
		when charindex('.ru',  COALESCE(i.number, eo.order_number,'')) = 0 then isnull(eo.order_number, i.[number])   -- #22416
		else ISNULL(eo.order_number, i.[number]) 
       end 
	     as [number] --,i.[number]
    --  ,iif(eo.order_date IS NULL, ISNULL(eo.msk_dt, i.[create_date]), eo.order_date) as create_date  -- khizhnyakov #15107
     ,COALESCE(eo.order_date, eo.msk_dt, i.[create_date]) as create_date --#26386
     ,dbo.f_FormatPhoneNumber(ISNULL(i.[phone], eo.[phone])) as [phone]	-- khizhnyakov #17123  --,i.[phone]-- khizhnyakov #17123

	-->> #23449 polyakov äîïîëíåíèå ïî êîððåêòèðîâêå çíà÷åíèé òèïà äîñòàâêè â ñîîòâåòñòâèè ñ åêîì (íà îñíîâàíèè ïåðåïèñêè)
      --,i.[delivery_type] 
	  ,iif (eo.order_guid is not null, case
				when isnull(eo.delivery_type,'PICKUP') = 'PICKUP' then '0'
				else '1'
			end,  i.[delivery_type]) 
		 as [delivery_type] 
	  --<< #23449 polyakov äîïîëíåíèå ïî êîððåêòèðîâêå çíà÷åíèé òèïà äîñòàâêè â ñîîòâåòñòâèè ñ åêîì (íà îñíîâàíèè ïåðåïèñêè)
      --,ISNULL(i.[state], eo.[state]) as [state]
	  ,COALESCE(i.[state], eo.[state],'ÍÅ ÎÏÐÅÄÅËÅÍÎ') as [state] --#26059																			  
	  ,ISNULL(i.[internet_order_guid], eo.[order_guid]) as [internet_order_guid] --#26386
	  ,case /*Ïðîñòàâëÿåì ïðåäâàðèòåëüíî äîìåííûå èìåííà, îíè èçâåñòíû - äëÿ âñåõ îñòàëüíûå áåðåì èç tblDomains íèæå êîä*/
		when CHARINDEX('yandex', internet_order_source_val) > 0
				and CHARINDEX('market', internet_order_source_val) > 0 
				and CHARINDEX('dbs', internet_order_source_val) > 0 then 'dbs.market.yandex.ru'
		when CHARINDEX('yandex', internet_order_source_val) > 0 
				and CHARINDEX('market', internet_order_source_val) > 0 
				and CHARINDEX('fbs', internet_order_source_val) > 0 then 'fbs.market.yandex.ru'
		--when eo.ext_source_id = 11 then 'dbs.market.yandex.ru'  -- khizhnyakov #15100
		--when eo.ext_source_id = 12 then 'fbs.market.yandex.ru'  -- khizhnyakov #15100
		when CHARINDEX('yandex', ext_source_code) > 0 and CHARINDEX('market', ext_source_code) > 0 and CHARINDEX('dbs', ext_source_code) > 0 then 'dbs.market.yandex.ru'  -- khizhnyakov #15100
		when CHARINDEX('yandex', ext_source_code) > 0 and CHARINDEX('market', ext_source_code) > 0 and CHARINDEX('fbs', ext_source_code) > 0 then 'fbs.market.yandex.ru'  -- khizhnyakov #15100		
   		-->>#21864

		when ISNUMERIC(isnull(eo.order_number, i.number)) = 1 and eo.ext_source_id = 2                     then IIF(charindex('mobile', eo.app_point)>0,'ïðèëîæåíèå rigla'        ,'rigla.ru') --'rigla.ru'
        when CHARINDEX('rigla.ru',         IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then IIF(charindex('mobile', eo.app_point)>0,'ïðèëîæåíèå rigla'        ,'rigla.ru') --'rigla.ru'
        when CHARINDEX('budzdorov.ru',     IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then IIF(charindex('mobile', eo.app_point)>0,'ïðèëîæåíèå budzdorov'    ,'budzdorov.ru') --'budzdorov.ru'
        when CHARINDEX('aptekazhivika.ru', IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then IIF(charindex('mobile', eo.app_point)>0,'ïðèëîæåíèå aptekazhivika','aptekazhivika.ru') --'aptekazhivika.ru'
		--Îñòàâèòü äëÿ èñòîðè÷åñêîé ÷àñòè
		when CHARINDEX('aloe39.ru',        IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then 'aloe39.ru'
        when CHARINDEX('lekstore.ru',      IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then 'lekstore.ru'
		when CHARINDEX('olekstra.ru',      IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then 'olekstra.ru'
     
		when CHARINDEX('eapteka.ru/stock', IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then 'eapteka.ru/stock' 
        when CHARINDEX('eapteka.ru/ship-invoice', IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then 'eapteka.ru/ship-invoice'
        when CHARINDEX('eapteka.ru',       IIF(eo.order_guid is not null, eo.order_number, i.number )) > 0 then 'eapteka.ru'
        else COALESCE(
                       a.OrderPrefix, 
					   iif(eo.ext_source_id = 9,  eo.app_point,       NULL), -- ìàðêåòïëåéñû ÷åðåç pharmdelivery.ru
					   iif(eo.ext_source_id = 10, 'protek',           NULL), -- ìàðêåòïëåéñû ÷åðåç pharmdelivery.ru
					   iif(eo.ext_source_id = 70, eo.ext_source_code, NULL), -- apteka.ru
                      'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
                     )
        end 
		   as [site_name]
 	   --,c.[A_COD] as Store_id
	   ,isnull(c.[A_COD], eo.store_id) [store_id] --#26059
	   ,iif(eo.order_guid is null, 0, 1) [ecom_order_flag]
	   ,eo.income_date
	  -->> polyakov #13102
	   ,case 
			when iowt.order_guid is not null and iowt.WAIT_PROTEK = 1 then 'Ïðîòåê'
			when iowt.order_guid is not null and iowt.WAIT = 1 and iowt.WAIT_HUB = 1 then 'Õàá Ïîñòàâùèê'
			when iowt.order_guid is not null and iowt.WAIT = 1 then 'Ïîñòàâùèê'
			when iowt.order_guid is not null and iowt.WAIT_HUB = 1 then 'Õàá'
			when eo.order_guid is not null then 'Íåò'
			else 'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
		 end
			as [wait_type] 
	   ,case
			when eo.order_guid is not null and (iowt.WAIT_PROTEK = 1 or iowt.WAIT = 1 or WAIT_HUB = 1) then 'Äà'
			when eo.order_guid is not null then 'Íåò'
			else 'ÍÅ ÎÏÐÅÄÅËÅÍÎ'
		 end
			as [wait],    
	  --<< polyakov #13102
	  -->> polyakov #13902
	  iif(eo.[is_callcentr] is not null, iif(eo.[is_callcentr] = 1,'Äà','Íåò'),'ÍÅ ÎÏÐÅÄÅËÅÍÎ') [is_callcentr],
	  isnull(eo.operator_email,        'ÍÅ ÎÏÐÅÄÅËÅÍÎ')           [operator_email],
	  --<< polyakov #13902
	  isnull(eo.domain_name,           'ÍÅ ÎÏÐÅÄÅËÅÍÎ')           [domain_name],    -- kornilov #15161
	  isnull(eo.customer_group ,       'ÍÅ ÎÏÐÅÄÅËÅÍÎ')           [customer_group], -- kornilov #15723
	  isnull(eo.[source],              'ÍÅ ÎÏÐÅÄÅËÅÍÎ')           [source],    
	  isnull(eo.[delivery_date],       '1900-01-01 00:00:00.000') [delivery_date],  
	  isnull(eo.[payment_method_name], 'ÍÅ ÎÏÐÅÄÅËÅÍÎ')           [payment_method_name],	  
	  gds.is_new
  FROM      #guids gds --#26386
  left join #eo eo ON eo.order_guid  = gds.internet_order_guid  --#26386
  left join [LDR].[dbo].[ef2_internet_order] i with (nolock) ON gds.internet_order_guid = i.internet_order_guid  --eo.order_guid = i.internet_order_guid --#26386
  left join [LDR].[dbo].[ef2_CONTRACTOR]     c with (nolock) ON c.db_id = i.db_id
	                                                        and c.ID_CONTRACTOR = i.id_contractor_owner
  left join #internet_order_wait_type     iowt  ON iowt.order_guid = COALESCE (i.[internet_order_guid], eo.order_guid) -- polyakov #13102
  left join #ap_tblDomains                a     ON CHARINDEX(a.OrderPrefix, ISNULL(i.number, eo.order_number)) = 1
  left join dct_stores ds                     with (nolock)  ON c.[A_COD] = ds.store_id --#26386
  WHERE 
    COALESCE(eo.order_date, eo.msk_dt, i.[create_date]) IS NOT NULL --#26386
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

	UPDATE a SET
		is_sip_site = b.IsSip
		,is_own_site = b.IsOwn
	FROM #t a 
		JOIN LAKE.ap.tblSites b ON a.calc_site_name = b.SiteName

	IF exists (select top (1) 1 from #t) 
	BEGIN
		
		set @step_name = concat(@name,' insert #dct_internet_orders_phones')
		exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

	  --#26742 start çàïîëíèòü íîìåðàìè òåëåôîíîâ
	    if  Object_ID('tempdb..#dct_internet_orders_phones') is not null  DROP TABLE #dct_internet_orders_phones	  
	    select 
		   DISTINCT isnull(phone,'ÍÅ ÎÏÐÅÄÅËÅÍÎ') AS phone
		   into #dct_internet_orders_phones
		from #t
		where is_new = 1
		---#26742 end 
		
		exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

		set @step_name = concat(@name,' insert dct_internet_orders')
		exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

		INSERT INTO [dbo].[dct_internet_orders]
		(
		   [db_id]
		  ,[number]
		  ,[create_date]
		  ,[phone]
		  ,[delivery_type]
		  ,[state]
		  ,[internet_order_guid]
		  ,[site_name]
		  ,[Store_id]
		  ,[source]
		  ,[delivery_date]
		  ,[payment_method_name] -- polyakov #9406 (#10258)
		  ,[income_date]
		  ,[wait_type]           -- polyakov #13102
		  ,[wait]                -- polyakov #13102
		  ,[is_callcentr]
		  ,[operator_email]
		  ,[domain_name]         -- kornilov #15161
		  ,[customer_group]      -- kornilov #15723
		  ,[parent_internet_order_id]	-- strekalov #23449
		  ,is_sip_site
		  ,is_own_site
		)
		select
		   s.[db_id]
		  ,isnull(s.[number],              'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
		  ,isnull(iif(s.[create_date] > getdate(), '1900-01-01', s.[create_date]),         '1900-01-01')
		  ,isnull(s.[phone],               'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
		  ,isnull(s.[delivery_type],       'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
		  ,isnull(s.[state],               'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
		  ,		  s.[internet_order_guid]
		  ,ISNULL(s.[site_name],           'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
		  ,ISNULL(s.[Store_id], -1)
		  ,isnull(s.[source],              'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
		  ,isnull(s.[delivery_date],       '1900-01-01')
		  ,isnull(s.[payment_method_name], 'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- polyakov #9406 (#10258)
		  ,isnull(s.[income_date],         '1900-01-01')
		  ,isnull(s.[wait_type],           'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- polyakov #13102
		  ,isnull(s.[wait],                'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- polyakov #13102
		  ,isnull(s.[is_callcentr],        'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- polyakov #13902
		  ,isnull(s.[operator_email],      'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- polyakov #13902
		  ,isnull(s.[domain_name],         'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- kornilov #15161
		  ,isnull(s.[customer_group],      'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- kornilov #15723
		  ,								    -1		        -- strekalov #23449
		  ,s.is_sip_site
		  ,s.is_own_site
		from #t s (nolock)
		-->> #26059 V2 Íåëüçÿ êîíòðîëèðîâàòü ïî ôëàãó ÒÎËÜÊÎ is_new ò.ê. äàííûå NAS íå ïðèõîäÿò â ecom
		--where
		--	is_new = 1
		left join [dbo].[dct_internet_orders] t (nolock) 
			on t.[db_id] = s.[db_id] and
			t.internet_order_guid = s.internet_order_guid
		where t.internet_order_guid is null
		--<< #26059 V2 


		if(exists(select 1 from #t where create_date > getdate()))
		begin
		  declare @step1_name varchar(255)
		  set @step1_name = @name + ' create_date > getdate(), example=' 
				+ (
					select concat(internet_order_guid,';')
					from (select top 3 internet_order_guid from #t where create_date > getdate()) a				
					for xml path('')
					)
	  
		  exec dbo.p_sup_log @name = @step1_name, @state_name = 'warning', @task_id=null 
		end
		
		exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null
		
		set @step_name = concat(@name,' exec p_dct_internet_orders_fill_order_count')
		exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

		--#26742 start íóìåðàöèÿ çàêàçîâ ïî íîìåðó òåëåôîíà, òîëüêî äëÿ òåõ, êîòîðûå áûëè äîáàâëåíû â òàáëèöó
		exec [dbo].[p_dct_internet_orders_fill_order_count] 
		drop table #dct_internet_orders_phones
		--#26742 end
		
		exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

		/* -- 21864
		-- #23449 Strekalov âû÷èñëåíèå parent_order_id	
		if object_id('tempdb..#parent_orders') is not null drop table #parent_orders
     
	    select  try_cast(o.order_guid as uniqueidentifier)    order_guid, 
                d.internet_order_id                           parent_internet_order_id,
                s.			                                  [db_id]

        into #parent_orders 
        from LDR.dbo.ecom_orders o (nolock)
        join LDR.dbo.ecom_orders p (nolock) on p.order_id = o.parent_order_id
        join dct_stores			 s (nolock) on p.store_id = s.store_id
        join dct_internet_orders d (nolock) on d.internet_order_guid = try_cast(p.order_guid as uniqueidentifier) and d.db_id = s.db_id
        where o.parent_order_id is not null

		print 'parent_order_id = ' + ltrim(@@rowcount)
		create index ix_tmp_parent on #parent_orders(order_guid, db_id)
			*/   
		------------------------------------------------------------------------
		set @step_name = concat(@name,' update dct_internet_orders')
		exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

		update t  
		set	
    		  t.[state]				= isnull(s.[state], 'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
            , t.[income_date] 		= iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[income_date], '1900-01-01'),    isnull(t.[income_date], '1900-01-01'))
			, t.[wait_type]			= iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[wait_type],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[wait_type],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ')) -- polyakov #13102
			, t.[wait]				= iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[wait],        'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[wait],        'ÍÅ ÎÏÐÅÄÅËÅÍÎ'))           -- polyakov #13102
			, t.[source]			= iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[source],      'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[source],      'ÍÅ ÎÏÐÅÄÅËÅÍÎ'))    
			, t.[site_name]			= iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[site_name],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[site_name],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ'))  
			, t.[delivery_type]			= iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[delivery_type],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[delivery_type],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ'))  -- #23449 polyakov
			, t.is_sip_site = s.is_sip_site
			, t.is_own_site = s.is_own_site
		from [dbo].[dct_internet_orders] t (nolock)
		inner join #t s (nolock) on s.[db_id] = t.[db_id] 
			and s.internet_order_guid =t.internet_order_guid
		where 
		    isnull(s.[state], 'ÍÅ ÎÏÐÅÄÅËÅÍÎ') != t.[state]
            or iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[income_date], '1900-01-01'),    isnull(t.[income_date], '1900-01-01'))	  != isnull(t.[income_date], '1900-01-01')
			or iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[wait_type],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[wait_type],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ')) != isnull(t.[wait_type],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- polyakov #13102
			or iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[wait],        'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[wait],        'ÍÅ ÎÏÐÅÄÅËÅÍÎ')) != isnull(t.[wait],        'ÍÅ ÎÏÐÅÄÅËÅÍÎ')                -- polyakov #13102
			or iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[source],      'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[source],      'ÍÅ ÎÏÐÅÄÅËÅÍÎ')) != isnull(t.[source], 'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- martynov #18483
			or iif(s.[ecom_order_flag]=1 and s.[create_date]>=convert(date,getdate()-@dd), isnull(s.[site_name],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ'), isnull(t.[site_name],   'ÍÅ ÎÏÐÅÄÅËÅÍÎ')) != isnull(t.[site_name], 'ÍÅ ÎÏÐÅÄÅËÅÍÎ') -- khizhnyakov #19274
			or isnull(t.is_sip_site,-1) <> s.is_sip_site
			or isnull(t.is_own_site,-1) <> s.is_own_site
-- khizhnyakov #17692 		
	  OPTION ( QUERYTRACEON 610)
		
		exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

	END
	
	-->> 28196
	set @step_name = concat(@name,' update dct_internet_orders.phone')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null

	update a set 
		phone = dbo.f_formatphonenumber(phone)
	from(
		  select phone
		  from dbo.dct_internet_orders (nolock)
		  where
		  (
			(([phone] not like '+7%' and [phone] <> 'ÍÅ ÎÏÐÅÄÅËÅÍÎ')
			 or (not len([phone]) = len('+7õõõõõõõõõõ') and [phone] <> 'ÍÅ ÎÏÐÅÄÅËÅÍÎ'))
		  ) and create_date >= convert(date,getdate()-@dd)
	) a
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

	--<< 28196

	--> 21864 ïåðåíåñåíà íåïîñðåäñòâåííî ïåðåä update, òàê êàê  select top (1) 1 from #t) ìîæåò áûòü =  Ïóñòî

	   -- #23449 Strekalov âû÷èñëåíèå parent_order_id	
	if object_id('tempdb..#parent_orders') is not null drop table #parent_orders
    
	set @step_name = concat(@name,' insert #parent_orders')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null   

	select  try_cast(o.order_guid as uniqueidentifier)    order_guid, 
            d.internet_order_id                         parent_internet_order_id,
            so.[db_id]                                  [db_id]       -- #33735
    into #parent_orders 
    from LDR.dbo.ecom_orders o (nolock)
    join dct_stores			 so (nolock) on o.store_id = so.store_id            -- #33735
    join LDR.dbo.ecom_orders p (nolock) on p.order_id = o.parent_order_id
    join dct_stores			 s (nolock) on p.store_id = s.store_id
    join dct_internet_orders d (nolock) on d.internet_order_guid = try_cast(p.order_guid as uniqueidentifier) and d.db_id = s.db_id
    where o.parent_order_id is not null
		and o.order_id not in (select order_id from #exclude_ecom_orders) -- #27843

	print 'parent_order_id = ' + ltrim(@@rowcount)
	create index ix_tmp_parent on #parent_orders(order_guid, db_id)
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null

	set @step_name = concat(@name,' update dct_internet_orders.parent_internet_order_id')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null  

	   -- #23449 Strekalov ôèíàëüíîå îáíîâëåíèå parent_order_id	
	update dio set parent_internet_order_id = po.parent_internet_order_id
	from #parent_orders   po
	join dct_internet_orders dio on po.order_guid = dio.internet_order_guid and po.db_id = dio.db_id
	where isnull(dio.parent_internet_order_id,-1) <> isnull(po.parent_internet_order_id,-1)
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null  
	   --<
	--< 21864

	-->> #27690
	set @step_name = concat(@name,' update dct_internet_orders.app_point')
	exec dbo.p_sup_log @name = @step_name, @state_name = @start_state, @task_id=null  

	SELECT
		e.order_guid
		,CASE
			WHEN zc.service_type is not null THEN ISNULL(e.app_point + '/','') + zc.service_type
			ELSE e.app_point
		END AS app_point
	INTO #app_point
	FROM LDR.dbo.ecom_orders e (nolock)
		 LEFT JOIN (
				SELECT TOP 1 WITH TIES -- èñêëþ÷èì äóáëèêàòû åñëè åñòü
					order_num
					,service_type
				FROM LDR.dbo.zdravcity_zc_rigla_orders with(nolock)
				WHERE date_update > GETDATE()-30 -- äåëàåì ñìåùåíèå íà ñëó÷àé íåðóãåëÿðíîé âûãðóçêè äàííûõ
				ORDER BY ROW_NUMBER() OVER(PARTITION BY order_num ORDER BY date_update DESC)
				) zc on zc.order_num = e.order_number
	WHERE
		e.order_date > GETDATE()-30

	CREATE CLUSTERED INDEX ix_tmp ON #app_point (order_guid)

	UPDATE a SET
		app_point = b.app_point
	FROM dct_internet_orders a (NOLOCK)
		JOIN #app_point b ON a.internet_order_guid = b.order_guid
	WHERE
		ISNULL(a.app_point,'') <> b.app_point
		AND a.create_date > GETDATE()-30
	
	exec dbo.p_sup_log @name = @step_name, @state_name = @finish_state, @task_id=null  
	--<< #27690

	exec dbo.p_sup_log @name = @name, @state_name = @finish_state, @task_id=null
	
end try      
begin catch
	exec dbo.p_sup_log @name = @name, @state_name = 'error', @task_id=null 
end catch

GO

