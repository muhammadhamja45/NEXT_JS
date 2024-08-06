WITH cte AS (
select
 x0_.`mandant_id`,
 x0_.`cardstatus`,
 x0_.`state`,
 x0_.`atm_id`,
 x0_.bin_card,
 x0_.tid_3, 
 x0_.dt_server_5, 
 x0_.dt_atm_6, 
 x0_.amount_7,
 x0_.total_trx, 
 x0_.currency_8, 
 x0_.sclr_14, 
 x0_.servicecode_17, 
 x0_.beleg_18,  
 x0_.proccode_28,  
 x0_.location_37, 
 x0_.posentry_38, 
 x0_.resultstr_48, 
 x0_.sclr_49, 
 x0_.`cancel_reason`,
 upper(t1_.`name`) AS name_20, 
 t1_.`technical` AS technical_21,
 a2_.descriptiontext AS descriptiontext_30, 
 a2_.shortid AS shortid_31, 
 l3_.`comment` AS comment_35, 
 l3_.`description` AS description_36, 
 SUBSTRING_INDEX(m4_.name, '_', -1)  AS name_46, 
 a5_.`name` AS name_47, 
 l6_.`description` AS description_50, 
 c7_.`name` AS name_52, 
 x0_.`result`,
 case 
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 in ('9910','9904','9908','9943','9906','9912') then 'Pinpad Cancel'
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 in ('9999','9911','9909','9931','9905','9907','1000') then 'Timeout/No Activity'
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 in ('9950') then 'Get BIN Group Failed'
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 in ('9930') then 'System Error'
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 in ('9932') then 'Pinpad Error'
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 not like '00%' and a5_.`name` <>'' then concat(a5_.`name`, ' (',x0_.resultstr_48,')') 
 when length(x0_.resultstr_48) = 4 then concat(l3_.`description`, ' (',x0_.resultstr_48,')')
 else concat(a5_.`name`, ' (',x0_.resultstr_48,')') end as response_code,
 case when x0_.resultstr_48 in ('00','8000','9000') then 'Success'
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 like '00%' then 'Anomaly' 
 when x0_.resultstr_48 in ('0068', '0091', '0200', '0097') then 'Anomaly'
 when x0_.resultstr_48 in ('9930','9932','9950','9993','9995') then 'Gagal Sistem'
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 like '99%' then 'Gagal Nasabah' 
 when length(x0_.resultstr_48) = 4 and x0_.resultstr_48 like '19%' then 'Gagal Nasabah' 
 when x0_.resultstr_48 in ('13','17','18','19','44','51','53','55','61','65','75') then 'Gagal Nasabah'
 else 'Gagal Sistem' end kategori_rc,
 case when t1_.`name` in ('BALANCE INQUIRY') then 'BI'
 when t1_.`name` in ('BILL PAYMENT') then 'BP'
 when t1_.`name` in ('BILL PAYMENT INQ') then 'BP INQ'
 when t1_.`name` in ('CASH WITHDRAWAL') then 'CW'
 when t1_.`name` in ('FAST CASH') then 'FC'
 when t1_.`name` in ('MINI STATEMENT') then 'MS'
 when t1_.`name` in ('TRANSFER TO OTHER ACCOUNT') then 'TR'
 when t1_.`name` in ('TRANSFER TO OTHER INQUIRY') then 'TR INQ'
 when t1_.`name` = '' then ''
 else 'Other' end trx_type,
 row_number() over(partition by x0_.dt_atm_6, x0_.tid_3, t1_.name, x0_.resultstr_48) as nomor
 from
 (
  SELECT 
    t0_.`atm_id`,
    t0_.`mandant_id`,
    t0_.`cardstatus`,
    left(t0_.`vispan` ,6) as bin_card,
    t0_.`tid` AS tid_3, 
    DATE_FORMAT(t0_.`dt_server`, "%Y-%m-%d %H:00:00") AS dt_server_5,
    DATE_FORMAT(t0_.`dt_atm`, "%Y-%m-%d %H:00:00") AS dt_atm_6,
    sum(t0_.`amount`) AS amount_7,
    count(distinct trace) as total_trx, 
    t0_.`currency` AS currency_8, 
    t0_.`dcc_currency` AS sclr_14, 
    t0_.`servicecode` AS servicecode_17, 
    t0_.`beleg` AS beleg_18,  
    t0_.`proccode` AS proccode_28,  
    t0_.`state` AS `state`, 
    t0_.`location` AS location_37, 
    t0_.`posentry` AS posentry_38, 
    t0_.`resultstr` AS resultstr_48, 
    t0_.`cardstatus` AS sclr_49, 
    t0_.`cancel_reason`,
    t0_.`type`,
    t0_.`result`
  FROM `transaction` t0_ 
  WHERE (t0_.`dt_server` BETWEEN $__timeFrom() AND $__timeTo())
  GROUP BY
    t0_.`atm_id`,
    t0_.`mandant_id`,
    t0_.`cardstatus`,
    left(t0_.`vispan` ,6),
    t0_.`tid`, 
    t0_.`dt_server`,
    t0_.`dt_atm`,
    t0_.`amount`,
    t0_.`currency`, 
    t0_.`dcc_currency`, 
    t0_.`servicecode`, 
    t0_.`beleg`,  
    t0_.`proccode`,  
    t0_.`state`, 
    t0_.`location`, 
    t0_.`posentry`, 
    t0_.`resultstr`,  
    t0_.`cancel_reason`,
    t0_.`type`,
    t0_.`result`
  )x0_
 LEFT JOIN atm a2_ ON x0_.`atm_id` = a2_.`id` 
 LEFT JOIN `cancelreasons` c7_ ON x0_.`cancel_reason` = c7_.`reason` 
 LEFT JOIN `transaction_type` t1_ ON x0_.`type` = t1_.`id`
 LEFT JOIN mandant m4_ ON x0_.`mandant_id` = m4_.`id` 
 LEFT JOIN `lookup` l6_ ON x0_.`cardstatus` = l6_.`key` AND l6_.`lookup_type_id` IN ('30') 
 LEFT JOIN `lookup` l3_ ON x0_.`state` = l3_.`key` AND l3_.`lookup_type_id` IN ('6') 
 LEFT JOIN `atm_result` a5_ ON x0_.`result` = a5_.`code` 
 WHERE SUBSTRING_INDEX(m4_.name, '_', -1) in ('BTN') 
 AND tid_3 in ($terminal_id)
)

SELECT
  CASE WHEN COUNT(DISTINCT tid_3) > 1 THEN 'All' ELSE MAX(tid_3) END AS terminal_id,
  SUM(total_trx) AS total_transactions,
  SUM(CASE WHEN kategori_rc = "Success" THEN total_trx ELSE 0 END) AS success_transactions,
  SUM(CASE WHEN kategori_rc = "Gagal Nasabah" THEN total_trx ELSE 0 END) AS gagal_nasabah_transactions,
  SUM(CASE WHEN kategori_rc = "Gagal Sistem" THEN total_trx ELSE 0 END) AS gagal_sistem_transactions,
  SUM(CASE WHEN kategori_rc = "Anomaly" THEN total_trx ELSE 0 END) AS anomaly_transactions,
  (SUM(CASE WHEN kategori_rc in ("Success","Gagal Nasabah","Gagal Sistem") THEN total_trx ELSE 0 END) / SUM(total_trx)) * 100 AS succes_rate,
  (SUM(CASE WHEN kategori_rc = "Success"  THEN total_trx ELSE 0 END) / SUM(total_trx)) * 100 AS approved_rate,
  (SUM(CASE WHEN kategori_rc = "Gagal Nasabah"  THEN total_trx ELSE 0 END) / SUM(total_trx)) * 100 AS gagal_nasabah_rate,
  (SUM(CASE WHEN kategori_rc = "Gagal Sistem" THEN total_trx ELSE 0 END) / SUM(total_trx)) * 100 AS gagal_sistem_rate,
  (SUM(CASE WHEN kategori_rc = "Anomaly" THEN total_trx ELSE 0 END) / SUM(total_trx)) * 100 AS anomaly_rate
FROM
  cte
where 
    (kategori_rc = 'Anomaly' and nomor = 1)
    or kategori_rc != 'Anomaly'