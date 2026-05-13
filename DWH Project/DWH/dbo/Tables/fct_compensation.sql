CREATE TABLE [dbo].[fct_compensation] (
    [date_id]                INT           NULL,
    [time_id]                INT           NULL,
    [doc_id]                 INT           NULL,
    [doc_type_id]            INT           NULL,
    [store_id]               INT           NOT NULL,
    [storehouse_id]          INT           NULL,
    [cash_register_id]       INT           NULL,
    [user_id]                INT           NULL,
    [good_id]                INT           NOT NULL,
    [group_id]               INT           NULL,
    [service_id]             INT           NULL,
    [scaling_ratio_id]       INT           NULL,
    [supplier_id]            INT           NULL,
    [db_id]                  INT           NULL,
    [lot_id_old]             INT           NULL,
    [expire_date_id]         INT           NULL,
    [compensation_id]        INT           NULL,
    [internet_order_id]      INT           NULL,
    [store_vat_id]           INT           NULL,
    [supplier_vat_id]        INT           NULL,
    [fact_debit_net]         MONEY         NULL,
    [fact_debit_grs]         MONEY         NULL,
    [fact_charge_net]        MONEY         NULL,
    [fact_charge_grs]        MONEY         NULL,
    [client_id]              VARCHAR (255) NULL,
    [trust_letter_id]        INT           NULL,
    [ef2_PCX_TRANSACTION_ID] VARCHAR (40)  NULL,
    [ef2_PCX_BARCODE]        VARCHAR (128) NULL,
    [sales_channel_id]       INT           NULL,
    [lot_id]                 BIGINT        NULL,
    [attribute_id]           INT           NULL
);


GO

