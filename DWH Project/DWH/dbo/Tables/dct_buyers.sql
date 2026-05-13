CREATE TABLE [dbo].[dct_buyers] (
    [buyer_id]          INT           NOT NULL,
    [name]              VARCHAR (256) NULL,
    [parent_buyer_id]   INT           NULL,
    [parent_buyer_name] VARCHAR (255) NULL,
    [address]           VARCHAR (255) NULL,
    [is_envd]           BIT           NOT NULL,
    [inn]               VARCHAR (255) NULL,
    [is_eec]            BIT           NULL,
    [ts]                ROWVERSION    NOT NULL,
    CONSTRAINT [PK_dct_buyers_buyer_id] PRIMARY KEY CLUSTERED ([buyer_id] ASC)
);


GO

