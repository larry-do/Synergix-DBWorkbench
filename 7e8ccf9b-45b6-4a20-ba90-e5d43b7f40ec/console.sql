update pj_subconbc_new_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
update pj_subconbc_oht_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
select * from pj_subconbc_oht_email_setting;
select * from pj_subconbc_new_email_setting;

update mt_employee set email_address = 'larry.do@synergixtech.com' where employee_code is not null;
select email_address, * from mt_employee;
select * from mt_user where lower(alias) like lower('%Fyn%'); --PD0361 ;

delete from attachment_hdr where module_code is not null;
delete from audit_det where object_version is not  null;
delete from audit_hdr where object_version is not  null;
select * from attachment_hdr;

select * from pj_sub_con_rev_hdr where sub_con_contract_no = 'SUB0000319' order by revision_no;

select vch_revision_no, * from vh_ost_approval where voucher_no = 'SUB0000319';

