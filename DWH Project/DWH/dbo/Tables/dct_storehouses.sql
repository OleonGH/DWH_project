CREATE TABLE [dbo].[dct_storehouses] (
    [storehouse_id]     INT              IDENTITY (1, 1) NOT NULL,
    [storehouse_guid]   UNIQUEIDENTIFIER NULL,
    [name]              NVARCHAR (255)   NULL,
    [store_id]          INT              NULL,
    [store_name]        NVARCHAR (255)   NULL,
    [type_code]         CHAR (255)       NULL,
    [type_name]         NVARCHAR (255)   NULL,
    [disabled_date]     DATETIME         NULL,
    [db_id]             INT              NULL,
    [ext_storehouse_id] BIGINT           NULL,
    [ts]                ROWVERSION       NOT NULL,
    CONSTRAINT [PK_dct_storehouses] PRIMARY KEY CLUSTERED ([storehouse_id] ASC)
);


GO

