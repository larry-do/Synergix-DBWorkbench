update pj_subconbc_new_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
update pj_subconbc_oht_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
select * from pj_subconbc_oht_email_setting;
select * from pj_subconbc_new_email_setting;

update mt_employee set email_address = 'lavie.pham@synergixtech.com' where employee_code is not null;
select email_address from mt_employee;
