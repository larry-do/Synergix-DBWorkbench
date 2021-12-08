INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, description, URL, MODULE_CODE, VERSION_NO,
                         IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_CLAIM_FUTAR', 'Project Claim', 'Futar', '', 'PJ', 6, 'I', 'N');

insert into mt_email_alert_config(module_code, transaction_type_code, config_code, email_template,
                                  email_content_include, config_desc, is_active)
values ('PJ', 'BGT', 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL',
        'ALERT: BUDGET_THRESHOLD% BUDGET THRESHOLD HAS REACHED - PROJECT_NO',
        'project_no=true,project_name=true,customer_name=true,customer_job_no=true,budget_schedule_no=true,budget_schedule_desc=true,budget_category=true,budget_cost=true,committed_cost=true,actual_cost=true,total_cost=true,total_cost_usage=true',
            '100.0', 'N');

select *
from MT_TRANSACTION_TYPE where MODULE_CODE = 'PJ';

insert into sys_dashpane(dashpane_code, dashpane_desc, dashpane_title, module_code, prefered_width, prefered_height)
values ('TH6_PJ_SALES_AMT_HIT_RATE_BY_SALES_MANAGER',
        'Display the total amount of quotations that are failed, confirmed and outstanding within the selected financial year & period (by sales manager and in home currency).',
        'proj_sales_amt_hit_rate_by_sales_manager', 'PJ', 1, 1);

INSERT INTO module_config (module_code, property_name, property_value, default_value, remarks, data_type, data_constraint, readonly, rendered, required, depending_properties,
                           tab_label, legacy_config, property_order, is_active, tab_order, created_by, created_datetime, last_updated_by, last_updated_datetime, object_version)
VALUES ('PJ', 'serviceCodeForUpdatingSubconMOSAmountToProjectCost', NULL, NULL,
        'When where is any MOS amount in Subcon Invoice updating project WIP, system will capture the MOS amount and update project actual cost using this service code', 'Entity',
        'searchService(main.mt.Mt_service)', 'N', 'Y', 'N', NULL,
        '', NULL, 170, 'Y', 0, NULL, NULL, NULL, NULL, 0);