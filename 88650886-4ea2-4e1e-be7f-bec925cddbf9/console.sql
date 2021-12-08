update pj_subconbc_new_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
update pj_subconbc_oht_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
select * from pj_subconbc_oht_email_setting;
select * from pj_subconbc_new_email_setting;

update mt_employee set email_address = 'larry.do@synergixtech.com' where employee_code is not null;
select email_address from mt_employee;
-----------------------------------------------------------------------

select * from vh_ost_approval where module_code = 'PJ';
select * from vh_ost_approval where voucher_no = 'PJPC000044';
select * from vh_ost_approval_pend_officer where voucher_no = 'PJPC000047';

select * from mt_document_numbering_scheme where module_key = 'PJ' and transaction_type_key = 'CAP';

select u.alias, clm.status, clm.confirmation_status, clm.*
from Pj_cus_clm_vch_hdr as clm
         join mt_user as u on u.user_id = cert_input_by
where project_no = 'PJES000003';

select cert_input_by, status, confirmation_status, *
from Pj_cus_clm_vch_hdr
where clm_vch_no = 'PJPC000047';

