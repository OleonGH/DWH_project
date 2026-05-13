CREATE TABLE [dbo].[sup_log] (
    [date_time]    DATETIME       NULL,
    [name]         NVARCHAR (255) NULL,
    [state_name]   NVARCHAR (255) NULL,
    [row_count]    INT            NULL,
    [err_number]   INT            NULL,
    [err_severity] INT            NULL,
    [err_state]    INT            NULL,
    [err_object]   NVARCHAR (MAX) NULL,
    [err_line]     INT            NULL,
    [err_message]  NVARCHAR (MAX) NULL,
    [system_user]  NVARCHAR (255) NULL,
    [spid]         SMALLINT       DEFAULT (NULL) NULL
);


GO

