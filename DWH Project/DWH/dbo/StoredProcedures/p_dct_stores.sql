CREATE procedure p_dct_stores
as 

insert into dct_stores (store_id, name, city, country)
select a.store_id, a.Name, asa.name, asa2.name
from ldr.dbo.ap_stores a 
join ldr.dbo.ap_link_store_attributes alsa on alsa.store_id = a.store_id and alsa.store_attribute_id = 1 
join ldr.dbo.ap_store_attributes asa on asa.store_attribute_id = alsa.store_attribute_id
join ldr.dbo.ap_link_store_attributes alsa2 on alsa2.store_id = a.store_id and alsa2.store_attribute_id = 2 
join ldr.dbo.ap_store_attributes asa2 on asa2.store_attribute_id = alsa2.store_attribute_id

GO

