

-- Malyshev		20170120		добавил нотификацию по ошибкам по настроенным процедурам
--2024-05-21	#24456	Kornilov	Сделать возможность сохранять в таблицу SUP_LOG параметр "@row_count" процедуры p_sup_log при его указании
--2024-12-28	#27794	Poselskii	Добавить поле spid в таблицу dwh.dbo.sup_log со значением @@SPID

CREATE procedure [dbo].[p_sup_log]
	@name varchar(255) = null,		--obj_name
	@state_name varchar(255) = null,	--start, finish, error
	@row_count int = null,
	@task_id int = null
as
begin
	insert into sup_log
	(
		date_time
		,name
		,[system_user]
		,state_name
		,row_count
		,err_number
		,err_severity
		,err_state
		,err_object
		,err_line
		,err_message
		,spid		-- #27794	Poselskii
	)
	select 
		getdate()
		,@name
		,system_user
		,@state_name
		, case -->>#24456
			when @row_count is not null then @row_count
			when @state_name = 'finish' then @@rowcount
			when @state_name = 'error'  then -1
			else null
		  end  --<<#24456
		--,case  when 'finish' then @@rowcount when 'error' then -1 else null end  --#24456 OLD
		,error_number()
		,error_severity()
		,error_state()
		,error_procedure()
		,error_line()
		,error_message()
		,@@SPID		-- #27794	Poselskii
	
	WAITFOR DELAY '00:00:00.100'

	--DECLARE @state_name VARCHAR(100), @name VARCHAR(100)
	--SET @state_name='error'
	--SET @name= 'dwh.int.p_tmz'

	IF @state_name='error'
	BEGIN
	
	declare @type_info	VARCHAR(50),
			@sms_to	VARCHAR(255), 
			@mail_to VARCHAR(1000),
			@err_message VARCHAR(max)
		
	SELECT	@type_info=slm.type_info, 
			@sms_to=slm.sms_to, 
			@mail_to=slm.mail_to
	FROM sup_log_monitor_config AS slm (NOLOCK)
	WHERE slm.proc_name=@name AND check_error=1
	
	IF @@ROWCOUNT>0 
		BEGIN
			SET @err_message='OLAP. ошибка процедуры '+@name
			

			if (@type_info LIKE '%SMS%' AND isnull(@sms_to,'')!='') 
							EXEC p_send_sms 
								@phones = @sms_to, 
								@mes = @err_message
			IF (@type_info LIKE '%MAIL%' AND ISNULL(@mail_to,'') LIKE '%@%') 
							exec msdb..sp_send_dbmail 
								@profile_name='MAIL',
								@recipients=@mail_to,
								@subject='OLAP. ошибка в работе процедур',
								@body=@err_message
					
		END
		
		
	END
	   	 

	/*if @task_id is not null
	begin try
		if @state_name = 'start' update t set lastactive = getdate() from [ap].aplanreg.dbo.tasks t where t.task_id = @task_id
		if @state_name = 'finish' update t set successdate = getdate() from [ap].aplanreg.dbo.tasks t where t.task_id = @task_id		
	end try
	begin catch
		exec dwh.dbo.p_sup_log @name = 'aplanreg.dbo.tasks', @state_name = 'error'
	end catch */
end

GO

