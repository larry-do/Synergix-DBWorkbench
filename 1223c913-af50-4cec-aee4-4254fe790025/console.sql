select * from pj_est_new_hdr;

select sum(pre_tax_extended_amt)
from pj_est_new_phs
where vo_confirmation_status = 'C'
  and phase_level_no = 1
  and (vo_type = 'VO' or (vo_type = 'N' and pre_tax_extended_amt >= 0));

select sub_con_backcharge_no, email_subject, * from pj_subconbc_new_email_setting;

select * from Mt_email_alert_config;

select * from vh_ost_approval;

select * from mt_transaction_type where module_code = 'PJ' and transaction_type_desc like '%Project Order (%';