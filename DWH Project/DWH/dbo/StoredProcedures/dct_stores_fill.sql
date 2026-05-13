CREATE PROCEDURE [dbo].[dct_stores_fill]  
AS  
declare @rowcount int = 2  
declare @name varchar(max) = 'dbo.dct_Stores_fill'  
declare @result int  
  
begin try  
  
--------------------------------------------------------------------------------------------------  
--  Запускаем процедуру логирования  
--------------------------------------------------------------------------------------------------  
 exec dbo.p_sup_log @name = @name, @state_name = 'start', @task_id=null   
--------------------------------------------------------------------------------------------------  
--Проверяем доступность таблицы в источнике  
--------------------------------------------------------------------------------------------------  
  
--------------------------------------------------------------------------------------------------  
--  Создаем и заполняем временную таблицу для нужных нам данных  
--------------------------------------------------------------------------------------------------  

-- Создаем временную таблицу явно
CREATE TABLE #tblDrugstores (
    [store_id] int,
    [sales_id] int,
    [number] int,
    [name] varchar(500),
    [type_name] varchar(500),
    [company_id] int,
    [company_name] varchar(500),
    [company_full_name] varchar(500),
    [company_inn] varchar(50),
    [branch_id] int,
    [branch_name] varchar(500),
    [unit_code] varchar(50),
    [unit_name] varchar(500),
    [address] varchar(1000),
    [subject_id] int,
    [subject_name] varchar(500),
    [city_name] varchar(500),
    [street_name] varchar(500),
    [metro_name] varchar(500),
    [business_unit_id] int,
    [business_unit_name] varchar(500),
    [region_company_id] int,
    [region_company_name] varchar(500),
    [division_id] int,
    [division_name] varchar(500),
    [control_dir_id] int,
    [control_dir_name] varchar(500),
    [area_total] decimal(18,2),
    [area_sales] decimal(18,2),
    [is_disabled] bit,
    [disabled_date] datetime,
    [opening_date] datetime,
    [brand_id] int,
    [brand_name] varchar(500),
    [category_name] varchar(500),
    [price_group_name] varchar(500),
    [form_name] varchar(500),
    [format_name] varchar(500),
    [location_name] varchar(500),
    [is_franchise] bit,
    [holding_name] varchar(500),
    [lease_name] varchar(500),
    [lease_end_date] datetime,
    [area_sublease] decimal(18,2),
    [opening_type_name] varchar(500),
    [project_name] varchar(500),
    [open_year_type_name] varchar(500),
    [is_calc_tmz] bit,
    [is_controller] bit,
    [is_video] bit,
    [is_pkkn] bit,
    [is_pku] bit,
    [phone_1] varchar(50),
    [phone_2] varchar(50),
    [hours_monday] varchar(500),
    [hours_tuesday] varchar(500),
    [hours_wednesday] varchar(500),
    [hours_thursday] varchar(500),
    [hours_friday] varchar(500),
    [hours_saturday] varchar(500),
    [hours_sunday] varchar(500),
    [db_id] int,
    [jv_id] int,
    [jv_name] varchar(500),
    [jv_cost_50] decimal(18,2),
    [jv_cost_50_500] decimal(18,2),
    [jv_cost_500] decimal(18,2),
    [jv_sale_50] decimal(18,2),
    [jv_sale_50_500] decimal(18,2),
    [jv_sale_500] decimal(18,2),
    [place_id] int,
    [Cluster_Id] int,
    [Cluster_Name] varchar(500),
    [is_Coming_Soon] bit,
    [store_type_id] int,
    [store_type_name] varchar(500),
    [time_shift] int,
    [MedPoint] bit,
    [MedLicense] varchar(500),
    [HubStoreId] int,
    [region_management_id] int,
    [region_management_name] varchar(500),
    [like_for_like] bit,
    [is_shop_in_shop] bit,
    [protek_supplier_id] int,
    [protek_supplier_name] varchar(500),
    [protek_warehouse_code] varchar(50),
    [board_id] int,
    [board_name] varchar(500),
    [cash_register_cnt] int
);

-- Заполняем временную таблицу
INSERT INTO #tblDrugstores (
    [store_id], [sales_id], [number], [name], [type_name], [company_id], [company_name],
    [company_full_name], [company_inn], [branch_id], [branch_name], [unit_code], [unit_name],
    [address], [subject_id], [subject_name], [city_name], [street_name], [metro_name],
    [business_unit_id], [business_unit_name], [region_company_id], [region_company_name],
    [division_id], [division_name], [control_dir_id], [control_dir_name], [area_total],
    [area_sales], [is_disabled], [disabled_date], [opening_date], [brand_id], [brand_name],
    [category_name], [price_group_name], [form_name], [format_name], [location_name],
    [is_franchise], [holding_name], [lease_name], [lease_end_date], [area_sublease],
    [opening_type_name], [project_name], [open_year_type_name], [is_calc_tmz], [is_controller],
    [is_video], [is_pkkn], [is_pku], [phone_1], [phone_2], [hours_monday], [hours_tuesday],
    [hours_wednesday], [hours_thursday], [hours_friday], [hours_saturday], [hours_sunday],
    [db_id], [jv_id], [jv_name], [jv_cost_50], [jv_cost_50_500], [jv_cost_500], [jv_sale_50],
    [jv_sale_50_500], [jv_sale_500], [place_id], [Cluster_Id], [Cluster_Name], [is_Coming_Soon],
    [store_type_id], [store_type_name], [time_shift], [MedPoint], [MedLicense], [HubStoreId],
    [region_management_id], [region_management_name], [like_for_like], [is_shop_in_shop],
    [protek_supplier_id], [protek_supplier_name], [protek_warehouse_code], [board_id], [board_name],
    [cash_register_cnt]
)
SELECT 
    [DS].[StoreID] as [store_id],
    isnull([DS].[SalesID], -1) as [sales_id],
    isnull([DS].[NumApt], -1) as [number],
    isnull([DS].[StoreName], 'НЕ ОПРЕДЕЛЕНО') as [name],
    isnull([OfficeTypeName], 'НЕ ОПРЕДЕЛЕНО') as [type_name],
    isnull([comp].[CompanyID], -1) as [company_id],
    isnull([CompanyName], 'НЕ ОПРЕДЕЛЕНО') as [company_name],
    [comp].[FullName] as [company_full_name],
    [comp].[INN] as [company_inn],
    [comp].[BranchID] as [branch_id],
    [comp].[BranchName] as [branch_name],
    [comp].[UnitCode] as [unit_code],
    [comp].[UnitName] as [unit_name],
    [DS].[Address] as [address],
    [subj].[SubjectID] as [subject_id],
    [subj].[SubjectName] as [subject_name],
    [city].[CityName] as [city_name],
    [DS].[StreetName] as [street_name],
    [metro].[StationName] as [metro_name],
    [comp].[BusinessUnitId] as [business_unit_id],
    [comp].[BusinessUnitName] as [business_unit_name],
    [comp].[RegionCompanyID] as [region_company_id],
    [comp].[RegionCompanyName] as [region_company_name],
    [d].[DivisionID] as [division_id],
    [d].[DivisionName] as [division_name],
    [comp].[ControlDirID] as [control_dir_id],
    [comp].[ControlDirName] as [control_dir_name],
    [DS].[AreaTotal] as [area_total],
    [DS].[AreaSales] as [area_sales],
    [DS].[IsDisabled] as [is_disabled],
    [DS].[DisabledDate] as [disabled_date],
    [DS].[OpeningDate] as [opening_date],
    [br].[BrandId] as [brand_id],
    [br].[BrandName] as [brand_name],
    [ctg].[CategoryName] as [category_name],
    [ctg].[PriceGroupName] as [price_group_name],
    [ctg].[FormName] as [form_name],
    [format].[StoreFormatName] as [format_name],
    [location].[LocationName] as [location_name],
    [DS].[IsFranchise] as [is_franchise],
    [cu].[CompanyUnionName] as [holding_name],
    [Lease].[LeaseName] as [lease_name],
    [Lease].[LeaseEndDate] as [lease_end_date],
    [DS].[AreaSublease] as [area_sublease],
    [open].[OpenName] as [opening_type_name],
    [DS].[ProjectName] as [project_name],
    [DS].[OpenYearTypeName] as [open_year_type_name],
    [DS].[IsCalcTMZ] as [is_calc_tmz],
    [DS].[IsController] as [is_controller],
    [DS].[IsVideo] as [is_video],
    [DS].[IsPKKN] as [is_pkkn],
    [DS].[IsPKU] as [is_pku],
    [DS].[Phone1] as [phone_1],
    [DS].[Phone2] as [phone_2],
    [DS].[HoursMonday] as [hours_monday],
    [DS].[HoursTuesday] as [hours_tuesday],
    [DS].[HoursWednesday] as [hours_wednesday],
    [DS].[HoursThursday] as [hours_thursday],
    [DS].[HoursFriday] as [hours_friday],
    [DS].[HoursSaturday] as [hours_saturday],
    [DS].[HoursSunday] as [hours_sunday],
    [DS].[db_id] as [db_id],
    [jv].[JNVLPId] as [jv_id],
    [jv].[Name] as [jv_name],
    [jv].[Cost_50] as [jv_cost_50],
    [jv].[Cost_50_500] as [jv_cost_50_500],
    [jv].[Cost_500] as [jv_cost_500],
    [jv].[Sale_50] as [jv_sale_50],
    [jv].[Sale_50_500] as [jv_sale_50_500],
    [jv].[Sale_500] as [jv_sale_500],
    [DS].[PlaceId] as [place_id],
    [sc].[ClusterId] as [Cluster_Id],
    [sc].[ClusterName] as [Cluster_Name],
    [DS].[IsComingSoon] as [is_Coming_Soon],
    [st].[StoreTypeId] as [store_type_id],
    [st].[StoreTypeName] as [store_type_name],
    [DS].[TimeShift] as [time_shift],
    [DS].[MedPoint] as [MedPoint],
    [DS].[MedLicense] as [MedLicense],
    [DS].[HubStoreId] as [HubStoreId],
    [rm].[RegionManagementId] as [region_management_id],
    [rm].[RegionManagementName] as [region_management_name],
    [DS].[LikeForLike] as [like_for_like],
    [DS].[IsShopInShop] as [is_shop_in_shop],
    [comp].[ProtekSupplierId] as [protek_supplier_id],
    [comp].[ProtekSupplierName] as [protek_supplier_name],
    [comp].[ProtekWarehouseCode] as [protek_warehouse_code],
    [brd].[BoardId] as [board_id],
    [brd].[BoardName] as [board_name],
    [DS].[CashRegisterCnt] as [cash_register_cnt]
FROM ldr.dbo.ap_tblDrugstores [DS] (nolock)
left join [LDR].[dbo].[ap_tblCompanyInReg] (nolock) cir on DS.[CompInRegId] = cir.CompInRegId
left join [LDR].[dbo].[ap_tblCompany] (nolock) as comp on DS.CompanyId = comp.CompanyId
left join [LDR].[dbo].[ap_tblBrands] (nolock) br on DS.BrandId = br.BrandId
left join [LDR].[dbo].[ap_tblCFO] (nolock) cfo on DS.CFOID = cfo.CFOID
left join [LDR].[dbo].[ap_tblCategories] ctg (nolock) on DS.CategoryID = ctg.CategoryID
left join [LDR].[dbo].[ap_tblCities] (nolock) city on [DS].CityId = city.CityId
left join [LDR].[dbo].[ap_tblSubjectRF] (nolock) subj on city.SubjectId = subj.SubjectID
left join [LDR].[dbo].[ap_tbldivisions] as d (nolock) on d.divisionid = cir.divisionid
left join [LDR].[dbo].[ap_tblCompanyUnions] as cu (nolock) on ds.companyunionid = cu.companyunionid
left join [LDR].[dbo].[ap_tblOfficeType] as office (nolock) on ds.office = office.[OfficeTypeId]
left join [LDR].[dbo].[ap_tblmetrostations] as metro (nolock) on ds.StoreStationID = metro.[StationID]
left join [LDR].[dbo].[ap_tblSprLease] as [Lease] (nolock) on ds.[LeaseId] = [Lease].[LeaseId]
left join [LDR].[dbo].[ap_tblSprOpen] as [open] (nolock) on ds.openid = [open].openid
left join [LDR].[dbo].[ap_tblStoreFormats] as [format] (nolock) on ds.storeformatid = [format].storeformatid
left join [LDR].[dbo].[ap_tblSprLocation] as [location] (nolock) on ds.locationid = [location].locationid
left join [LDR].[dbo].[ap_tblSprMarkup] as [mrk] (nolock) on ds.MarkupId = [mrk].MarkupId
left join [LDR].[dbo].[ap_tblJNVLP] as jv (nolock) on jv.JNVLPId = ds.JNVLPId
left join [LDR].[dbo].[ap_tblSprCluster] sc (nolock) on sc.ClusterId = ds.ClusterId
left join ldr.dbo.ap_tblStoreTypes st (nolock) on st.StoreTypeId = ds.StoreTypeId
left join [LDR].[dbo].[ap_tblRegionManagement] rm (nolock) on rm.RegionManagementId = ds.RegionManagementId
left join [LDR].[dbo].[ap_tblBoard] brd (nolock) on brd.BoardId = DS.BoardId
order by [store_id];

-- Первая вставка в целевую таблицу (минимальный набор полей)
INSERT [dbo].[dct_stores] ( 
    [store_id], [sales_id], [number], [name], [type_name], [company_id], [company_name]
) 
SELECT 
    [store_id], [sales_id], [number], [name], [type_name], [company_id], [company_name]
FROM #tblDrugstores;

-- Вторая вставка в целевую таблицу (полный набор полей)
INSERT [dbo].[dct_stores] ( 
    [store_id], [sales_id], [number], [name], [type_name], [company_id], [company_name],
    [company_full_name], [company_inn], [branch_id], [branch_name], [unit_code], [unit_name],
    [address], [subject_id], [subject_name], [city_name], [street_name], [metro_name],
    [business_unit_id], [business_unit_name], [region_company_id], [region_company_name],
    [division_id], [division_name], [control_dir_id], [control_dir_name], [area_total],
    [area_sales], [is_disabled], [disabled_date], [opening_date], [brand_id], [brand_name],
    [category_name], [price_group_name], [form_name], [format_name], [location_name],
    [is_franchise], [holding_name], [lease_name], [lease_end_date], [area_sublease],
    [opening_type_name], [project_name], [open_year_type_name], [is_calc_tmz], [is_controller],
    [is_video], [is_pkkn], [is_pku], [phone_1], [phone_2], [hours_monday], [hours_tuesday],
    [hours_wednesday], [hours_thursday], [hours_friday], [hours_saturday], [hours_sunday],
    [db_id], [jv_id], [jv_name], [jv_cost_50], [jv_cost_50_500], [jv_cost_500], [jv_sale_50],
    [jv_sale_50_500], [jv_sale_500], [place_id], [Cluster_Id], [Cluster_Name], [is_Coming_Soon],
    [store_type_id], [store_type_name], [time_shift], [MedPoint], [MedLicense], [HubStoreId],
    [region_management_id], [region_management_name], [like_for_like], [is_shop_in_shop],
    [protek_supplier_id], [protek_supplier_name], [protek_warehouse_code], [board_id], [board_name],
    [cash_register_cnt]
) 
SELECT 
    [store_id], [sales_id], [number], [name], [type_name], [company_id], [company_name],
    [company_full_name], [company_inn], [branch_id], [branch_name], [unit_code], [unit_name],
    [address], [subject_id], [subject_name], [city_name], [street_name], [metro_name],
    [business_unit_id], [business_unit_name], [region_company_id], [region_company_name],
    [division_id], [division_name], [control_dir_id], [control_dir_name], [area_total],
    [area_sales], [is_disabled], [disabled_date], [opening_date], [brand_id], [brand_name],
    [category_name], [price_group_name], [form_name], [format_name], [location_name],
    [is_franchise], [holding_name], [lease_name], [lease_end_date], [area_sublease],
    [opening_type_name], [project_name], [open_year_type_name], [is_calc_tmz], [is_controller],
    [is_video], [is_pkkn], [is_pku], [phone_1], [phone_2], [hours_monday], [hours_tuesday],
    [hours_wednesday], [hours_thursday], [hours_friday], [hours_saturday], [hours_sunday],
    [db_id], [jv_id], [jv_name], [jv_cost_50], [jv_cost_50_500], [jv_cost_500], [jv_sale_50],
    [jv_sale_50_500], [jv_sale_500], [place_id], [Cluster_Id], [Cluster_Name], [is_Coming_Soon],
    [store_type_id], [store_type_name], [time_shift], [MedPoint], [MedLicense], [HubStoreId],
    ISNULL([region_management_id], -1), ISNULL([region_management_name], 'НЕ ОПРЕДЕЛЕНО'),
    [like_for_like], [is_shop_in_shop], [protek_supplier_id], [protek_supplier_name],
    [protek_warehouse_code], [board_id], [board_name], [cash_register_cnt]
FROM #tblDrugstores;

exec dbo.p_sup_log @name = @name, @state_name = 'finish', @task_id=null
  
drop table #tblDrugstores

-- #28055
declare @date_start_id int 
select @date_start_id = dbo.f_conv_datetime_to_int(Date_start) from LDR.dbo.Date_param (nolock)

-- polyakov когда формируется справочник, движения отстают на один день
-- новые аптеки будут включаться 
if OBJECT_ID('tempdb..#stores_is_used') is not null drop table #stores_is_used
select distinct fct.store_id
into #stores_is_used
from dbo.fct_movement (nolock) fct
where date_id between @date_start_id and dbo.f_conv_datetime_to_int(getdate())
-- mishin: если аптека новая, то на момент запуска данных в fct_movement еще нет, они расчитаются чуть позже.
-- В итоге в куб в измерение аптека попадет только на следующий день, хотя движение в fct_movement будет
-- Из-за этого сработает мониторинг, поэтому проверим аптеки через ef2_lot
UNION 
SELECT DISTINCT isnull(c.A_COD, - 1) AS store_id
FROM LDR.dbo.ef2_lot lot(NOLOCK)
 JOIN LDR.dbo.ef2_STORE AS s(NOLOCK) ON lot.ID_STORE = s.ID_STORE AND lot.db_id = s.db_id
 JOIN LDR.dbo.ef2_CONTRACTOR AS c(NOLOCK) ON s.ID_CONTRACTOR = c.ID_CONTRACTOR AND s.db_id = c.db_id

update st
set st.is_olap = IIF(ust.store_id is null and st.store_id <> -1,0,1)
from dct_stores (nolock) st
left join #stores_is_used ust on st.store_id = ust.store_id
where ISNULL(st.is_olap,0) = 0 -- polyakov включаем только для тех, которые еще не были включены
-- #28055

end try        
begin catch  
 exec dbo.p_sup_log @name = @name, @state_name = 'error', @task_id=null
end catch

GO

