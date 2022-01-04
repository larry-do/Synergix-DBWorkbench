select * from form_master where FORM_CODE = 'TH6_PJ_PROJECT_ORDER_FUTAR';

select * from SYS_FORM_SET;

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, FORM_SET_CODE, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_ORDER_FUTAR', 'Project Order', 'PJ_PROJECT_ORDER', 'Futar', '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_ORDER_FUTAR', 'Project Order', 'Futar', '', 'PJ', 6, 'I', 'N');

select *
from mt_email_alert_config
where module_code = 'PJ'
  and transaction_type_code = 'BGT';

insert into mt_email_alert_config(module_code, transaction_type_code, config_code, email_template,
                                  email_content_include, config_desc, is_active)
values ('PJ', 'BGT', 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL',
        'ALERT: BUDGET_THRESHOLD% BUDGET THRESHOLD HAS REACHED - PROJECT_NO',
        'project_no=true,project_name=true,customer_name=true,customer_job_no=true,budget_schedule_no=true,budget_schedule_desc=true,budget_category=true,budget_cost=true,committed_cost=true,actual_cost=true,total_cost=true,total_cost_usage=true',
            '100.0', 'N');

select MODULE_CODE, TRANSACTION_TYPE_CODE, TRANSACTION_TYPE_DESC
from MT_TRANSACTION_TYPE where MODULE_CODE = 'PJ';

select *
from sys_dashpane
where dashpane_code = 'TH6_PJ_SALES_AMT_HIT_RATE_BY_SALES_MANAGER';

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, description, URL, MODULE_CODE, VERSION_NO,
                         IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_CLAIM_FUTAR', 'Project Claim', 'Futar', '', 'PJ', 6, 'I', 'N');

select * from MT_COMPANY;

select * from SYS_CONFIG where PROPERTIES_NAME = 'synergixCustomer';

select *
from mt_sys_email_template where email_template_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL';

select * from sys_config where properties_name like '%projectQuotationAndOrderVersion%';

select * from Rpt_main where rpt_key = 'BFPJEST0002';

select * from mt_transaction_type where module_code = 'PJ' and transaction_type_desc like '%Project Order (%';

select * from mt_company;

select * from sys_config where properties_name like '%displayFormDescription%';

select * from global_config where property_name = 'folderPathForAttachmentFiles';
