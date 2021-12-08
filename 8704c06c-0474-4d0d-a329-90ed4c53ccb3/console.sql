update pj_subconbc_new_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
update pj_subconbc_oht_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
select * from pj_subconbc_oht_email_setting;
select * from pj_subconbc_new_email_setting;

update mt_employee set email_address = 'lavie.pham@synergixtech.com' where employee_code is not null;
select email_address from mt_employee;
select * from mt_user where lower(alias) like lower('%TAN CHEE TANG%'); --PD0361 ;
----------------------------------------------------------------------
SELECT pg_size_pretty(pg_database_size('OBYMAIN'));

SELECT pg_size_pretty(pg_total_relation_size('attachment_binary'));



----------- ATTACHMENT ENHANCEMENT-----------------------
--backup
select module_code, transaction_type_code, mt_code_vch_no, renewal_no, attachment_no, last_modified_by, binary_file_no
from attachment_hdr
where level = 1
  and file_attachment is not null;

--temporary id
update attachment_hdr
set last_modified_by = nextval('id_seq')
where level = 1
  and file_attachment is not null;

-- create binary
insert into attachment_binary(binary_no, binary_data, file_name, content_type, size, last_modified_by)
select nextval('id_seq'), hdr.file_attachment, hdr.file_name, hdr.content_type, hdr.size, hdr.last_modified_by
from attachment_hdr as hdr
where hdr.level = 1
  and hdr.file_attachment is not null;

-- update attachment point to new binary
update attachment_hdr
set binary_file_no  = bin.binary_no,
    file_attachment = null
from attachment_binary as bin
where level = 1
  and file_attachment is not null
  and attachment_hdr.last_modified_by = bin.last_modified_by;

select * from attachment_hdr where level = 1;
select count(binary_no) from attachment_binary;
select sum(size) from attachment_binary;
select sum(size) from attachment_hdr;

select claim_type, * from pj_cus_clm_vch_hdr;

select * from pj_cus_clm_vch_hdr where project_no = 'PJES000015';
