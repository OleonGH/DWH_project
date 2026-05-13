create view v_fct_sales 
as
select fm.store_id, fm.date_id
from fct_movement fm 
join dct_stores ds on ds.store_id = fm.store_id

GO

