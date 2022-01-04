update pj_subconbc_new_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
update pj_subconbc_oht_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
select * from pj_subconbc_oht_email_setting;
select * from pj_subconbc_new_email_setting;

update mt_employee set email_address = null where employee_code is not null;
select email_address from mt_employee;

select * from mt_employee;

select company_code, company_name, * from mt_company;
-----------------------------------------------------------------------

INSERT INTO module_config (module_code, property_name, property_value, default_value, remarks, data_type, data_constraint, readonly, rendered, required, depending_properties,
                           tab_label, legacy_config, property_order, is_active, tab_order, created_by, created_datetime, last_updated_by, last_updated_datetime, object_version)
VALUES ('PJ', 'serviceCodeForUpdatingSubconMOSAmountToProjectCost', NULL, NULL,
        'When where is any MOS amount in Subcon Invoice updating project WIP, system will capture the MOS amount and update project actual cost using this service code', 'Entity',
        'searchService(main.mt.Mt_service)', 'N', 'Y', 'N', NULL,
        '', NULL, 170, 'Y', 0, NULL, NULL, NULL, NULL, 0);

/*note: Form set code cant not set. No record in sys_form_set*/
INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, FORM_SET_CODE, DESCRIPTION, URL, MODULE_CODE, VERSION_NO,
                         IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_ORDER_FUTAR', 'Project Order', 'PJ_PROJECT_ORDER', 'Futar', '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO,
                         IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_CLAIM_FUTAR', 'Project Claim', 'Futar', '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, DESCRIPTION, FORM_NAME, URL, IMPLEMENTED_STATUS, VERSION_NO, MODULE_CODE,TRANSACTION_TYPE_CODE, OBJECT_VERSION, IS_MOBILE, CREATED_BY, FORM_SET_CODE)
VALUES ('TH6_STOCK_ISSUE_PROJECT_MULTI_PMR_FUTAR', 'Futar', 'Project Stock Issue', '', 'I', 6, 'LG', 'STOCKISSUE', 0, 'N', 'Andrey', 'PJ_STOCK_ISSUE');

select *
from lg_delivery_oht_hdr as doh
         inner join pj_cus_clm_phs_fulfillment as pccpf
                    on (doh.delivery_order_no = pccpf.delivery_order_no)
         inner join pj_cus_clm_vch_hdr as pccvh
                    on (pccvh.clm_vch_no = pccpf.clm_vch_no and
                        (pccvh.status = 'D' or pccvh.status = 'PA' or pccvh.status = 'P' or pccvh.status = 'H') and
                        pccvh.clm_vch_no <> 'claim_voucher_no')
where doh.status = 'C'
  and doh.source_voucher_type = 'DIRECT'
  and doh.type = 'STOCKISSUE'
  and (doh.issue_type = 'PBS' or doh.issue_type = 'DPB')
  and doh.project_no = 'project_no';
-----------
select *
from module_config
where module_code = 'PJ'
  and property_name like '%displaySpecNoInProjectQuotationOrderClaim%';

INSERT INTO module_config(module_code, property_name, property_value, default_value, remarks, data_type, rendered,
                          tab_label, is_active, required, readonly)
VALUES ('PJ', 'displaySpecNoInProjectQuotationOrderClaim', null, 'N',
        'System will display "Spec No." column in Job Scope/ BQ tab of Project Quotation, Order and Claim screen.',
        'Boolean', 'N',
        '', 'N', 'N', 'N');

update module_config set is_active = 'Y' where property_name = 'displaySpecNoInProjectQuotationOrderClaim' and (is_active is null or is_active = 'N');
update module_config set rendered = 'Y' where property_name = 'displaySpecNoInProjectQuotationOrderClaim' and (rendered is null or rendered = 'N');

select property_name, data_constraint from module_config where property_name like '%enableCostControl%';

update module_config set data_constraint = 'validator(pjModuleConfigValidator.validatePjEnableCostControlByBudgetCategory)'
where property_name = 'enableCostControlbyBudgetCategory';

update module_config set data_constraint = 'validator(pjModuleConfigValidator.validatePjEnableCostControlByCostVarianceThreshold)'
where property_name = 'enableCostControlByCostVarianceThreshold';
---------
select * from Mt_email_alert_config where transaction_type_code = 'SCL';

INSERT INTO MT_EMAIL_ALERT_CONFIG (MODULE_CODE, TRANSACTION_TYPE_CODE, CONFIG_CODE, EMAIL_ALERT_JOB_CLASS, CONFIG_DESC, CONFIG_HINT, SEND_OPTIONS, SEND_EMAIL_LIST, SEND_DESC, ALERT_TYPE, ALERT_TIME, ALERT_HOUR, EMAIL_TEMPLATE) VALUES ('PJ', 'SCL', 'CLAIM_APPROVAL_TIME_LIMIT', 'emailAlertSubcontractorClaim', 'claim_approval_time_limit', NULL, '', NULL, 'claim_approval_time_limit', 'D', TIME '12:00:00', NULL, '/faces/global_setup/global_config/email_alert_configuration/AlertClaimApprovalTemplate.xhtml');

INSERT INTO MT_EMAIL_ALERT_CONFIG (MODULE_CODE, TRANSACTION_TYPE_CODE, CONFIG_CODE, EMAIL_ALERT_JOB_CLASS, CONFIG_DESC, CONFIG_HINT, SEND_OPTIONS, SEND_EMAIL_LIST, SEND_DESC, ALERT_TYPE, ALERT_TIME, ALERT_HOUR, EMAIL_TEMPLATE, IS_ACTIVE)
 VALUES ('PJ', 'SCL', 'INCLUDE_ATTACHMENT_CERTIFIED_CLAIM', NULL, '', '', 'ACC=true', NULL, 'include_attachment_certified_claim', 'N', NULL, NULL, '', 'Y');

update MT_EMAIL_ALERT_CONFIG set IS_ACTIVE = 'Y' where MODULE_CODE = 'PJ' and TRANSACTION_TYPE_CODE = 'SCL' and  CONFIG_CODE = 'ALERT_SUB_CLAIM_CERTIFIED';

INSERT INTO MT_EMAIL_ALERT_CONFIG (MODULE_CODE, TRANSACTION_TYPE_CODE, CONFIG_CODE, CONFIG_DESC, CONFIG_HINT, SEND_OPTIONS, SEND_EMAIL_LIST, SEND_DESC, ALERT_TIME, ALERT_HOUR, EMAIL_TEMPLATE, OBJECT_VERSION, EMAIL_ALERT_JOB_CLASS, CREATED_BY, CREATED_DATETIME, LAST_UPDATED_BY, LAST_UPDATED_DATETIME, ALERT_TYPE, IS_ACTIVE, ATTACHMENT_LIST, ATTACHMENT_LIST_DESC) VALUES ('PJ', 'SCL', 'ALERT_SUB_CLAIM_CERTIFIED', 'alert_sub_claim_certified', 'alert_sub_claim_certified_hint', NULL, NULL, 'alert_sub_claim_certified', '10:14:00', 0, '/faces/processing/approval/approval_summary/email_template/SubClaimCertMailTemplate.xhtml', 50, 'emailAlertSubconClaimCertified', NULL, NULL, NULL, '2014-10-02 17:03:00', 'D/M', 'N', NULL, 'format_to_be_attached_in_email_for_certified_claim');
INSERT INTO MT_EMAIL_ALERT_CONFIG (MODULE_CODE, TRANSACTION_TYPE_CODE, CONFIG_CODE, CONFIG_DESC, CONFIG_HINT, SEND_OPTIONS, SEND_EMAIL_LIST, SEND_DESC, ALERT_TIME, ALERT_HOUR, EMAIL_TEMPLATE, OBJECT_VERSION, EMAIL_ALERT_JOB_CLASS, CREATED_BY, CREATED_DATETIME, LAST_UPDATED_BY, LAST_UPDATED_DATETIME, ALERT_TYPE, IS_ACTIVE, ATTACHMENT_LIST, ATTACHMENT_LIST_DESC) VALUES
('PJ', 'SCL', 'NOTIFY_CLAIM_FULL_APPROVAL', NULL, NULL, 'SMT=true,FNO=false,GA=false', null, 'email_alert_recipients_upon_claim_is_fully_approved', NULL, NULL, NULL, 18, NULL, NULL, NULL, NULL, '2014-10-02 17:03:00', 'C', 'Y', NULL, NULL);

select *
from mt_email_alert_config where config_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL';

insert into mt_email_alert_config(module_code, transaction_type_code, config_code, email_template,
                                  email_content_include, config_desc, is_active)
values ('PJ', 'BGT', 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL',
        'ALERT: BUDGET_THRESHOLD% BUDGET THRESHOLD HAS REACHED - PROJECT_NO',
        'project_no=true,project_name=true,customer_name=true,customer_job_no=true,budget_schedule_no=false,budget_schedule_desc=true,budget_category=true,budget_cost=true,committed_cost=true,actual_cost=true,total_cost=true,total_cost_usage=true',
        '100.0', 'N');

update mt_email_alert_config set is_active = 'N' where config_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL' and is_active is null;

select send_options, is_active from mt_email_alert_config where config_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL';

update mt_email_alert_config set is_active = null, send_options = null where config_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL';

update mt_email_alert_config set is_active = 'N' where config_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL';
----------------
select *
from sys_dashpane
where dashpane_code = 'TH6_PJ_SALES_AMT_HIT_RATE_BY_SALES_MANAGER';

insert into sys_dashpane(dashpane_code, dashpane_desc, dashpane_title, module_code, prefered_width, prefered_height)
values ('TH6_PJ_SALES_AMT_HIT_RATE_BY_SALES_MANAGER',
        'Display the total amount of quotations that are failed, confirmed and outstanding within the selected financial year & period (by sales manager and in home currency).',
        'proj_sales_amt_hit_rate_by_sales_manager', 'PJ', 1, 1);

drop view proj_sales_amt_hit_rate_view;

create view proj_sales_amt_hit_rate_view as
select mem.employee_code,
       emp.employee_short_name,
       fin.financial_year,
       fin.financial_period,
       (select coalesce(sum(total_pre_tax_home_amt), 0)
        from pj_qtn_hst_hdr as qtn1
                 inner join pj_qtn_hst_team_member as mem1
                            on mem1.quotation_no = qtn1.quotation_no and mem1.revision_no = qtn1.revision_no
                 inner join pj_qtn_hst_role_in_proj as role1
                            on mem1.quotation_no = role1.quotation_no and mem1.revision_no = role1.revision_no and
                               mem1.seq_no = role1.team_member_seq_no
                 inner join mt_financial_period as fin1 on qtn1.quotation_date >= fin1.period_start_date and
                                                           qtn1.quotation_date <= fin1.period_closing_date
        where role1.employee_role_code = 'SAM'
          and (qtn1.confirmation_status is null or qtn1.confirmation_status in ('C', 'F'))
          and qtn1.status in ('H', 'O')
          and mem1.employee_code = mem.employee_code
          and fin1.financial_year = fin.financial_year
          and fin1.financial_period = fin.financial_period
       ) as quoted_amt,

       (select coalesce(sum(total_pre_tax_home_amt), 0)
        from pj_qtn_hst_hdr as qtn1
                 inner join pj_qtn_hst_team_member as mem1
                            on mem1.quotation_no = qtn1.quotation_no and mem1.revision_no = qtn1.revision_no
                 inner join pj_qtn_hst_role_in_proj as role1
                            on mem1.quotation_no = role1.quotation_no and mem1.revision_no = role1.revision_no and
                               mem1.seq_no = role1.team_member_seq_no
                 inner join mt_financial_period as fin1 on qtn1.quotation_date >= fin1.period_start_date and
                                                           qtn1.quotation_date <= fin1.period_closing_date
        where role1.employee_role_code = 'SAM'
          and qtn1.confirmation_status = 'C'
          and qtn1.status = 'H'
          and mem1.employee_code = mem.employee_code
          and fin1.financial_year = fin.financial_year
          and fin1.financial_period = fin.financial_period
       ) as win_amt,

       (select coalesce(sum(total_pre_tax_home_amt), 0)
        from pj_qtn_hst_hdr as qtn1
                 inner join pj_qtn_hst_team_member as mem1
                            on mem1.quotation_no = qtn1.quotation_no and mem1.revision_no = qtn1.revision_no
                 inner join pj_qtn_hst_role_in_proj as role1
                            on mem1.quotation_no = role1.quotation_no and mem1.revision_no = role1.revision_no and
                               mem1.seq_no = role1.team_member_seq_no
                 inner join mt_financial_period as fin1 on qtn1.quotation_date >= fin1.period_start_date and
                                                           qtn1.quotation_date <= fin1.period_closing_date
        where role1.employee_role_code = 'SAM'
          and qtn1.confirmation_status is null
          and qtn1.status = 'O'
          and mem1.employee_code = mem.employee_code
          and fin1.financial_year = fin.financial_year
          and fin1.financial_period = fin.financial_period
       ) as ost_amt,

       (select coalesce(sum(total_pre_tax_home_amt), 0)
        from pj_qtn_hst_hdr as qtn1
                 inner join pj_qtn_hst_team_member as mem1
                            on mem1.quotation_no = qtn1.quotation_no and mem1.revision_no = qtn1.revision_no
                 inner join pj_qtn_hst_role_in_proj as role1
                            on mem1.quotation_no = role1.quotation_no and mem1.revision_no = role1.revision_no and
                               mem1.seq_no = role1.team_member_seq_no
                 inner join mt_financial_period as fin1 on qtn1.quotation_date >= fin1.period_start_date and
                                                           qtn1.quotation_date <= fin1.period_closing_date
        where role1.employee_role_code = 'SAM'
          and qtn1.confirmation_status = 'F'
          and qtn1.status = 'H'
          and mem1.employee_code = mem.employee_code
          and fin1.financial_year = fin.financial_year
          and fin1.financial_period = fin.financial_period
       ) as fail_amt

from pj_qtn_hst_role_in_proj role
         inner join pj_qtn_hst_team_member as mem
                    on mem.quotation_no = role.quotation_no and mem.revision_no = role.revision_no and
                       mem.seq_no = role.team_member_seq_no
         inner join pj_qtn_hst_hdr as qtn on role.quotation_no = qtn.quotation_no and role.revision_no = qtn.revision_no
         inner join mt_financial_period as fin on qtn.quotation_date >= fin.period_start_date and
                                                  qtn.quotation_date <= fin.period_closing_date
         inner join mt_employee as emp on mem.employee_code = emp.employee_code
where role.employee_role_code = 'SAM'
  and qtn.status not in ('P')
  and (qtn.confirmation_status is null or qtn.confirmation_status not in ('R'))
group by fin.financial_year, fin.financial_period, mem.employee_code, emp.employee_short_name;

select *
from proj_sales_amt_hit_rate_view
where employee_short_name like '%%'
order by win_amt desc;

select emp.employee_code,
       emp.employee_short_name,
       qtn.total_pre_tax_home_amt,
       qtn.confirmation_status,
       qtn.status,
       qtn.quotation_no,
       qtn.quotation_date,
       fin_period.financial_year,
       fin_period.financial_period
from (((mt_employee as emp join pj_qtn_hst_team_member as mem on emp.employee_code = mem.employee_code)
    join pj_qtn_hst_role_in_proj as role
    on mem.quotation_no = role.quotation_no and mem.revision_no = role.revision_no and
       mem.seq_no = role.team_member_seq_no and
       role.employee_role_code = 'SAM')
    join pj_qtn_hst_hdr as qtn on qtn.quotation_no = mem.quotation_no and qtn.revision_no = mem.revision_no and
                                  qtn.status not in ('P') and
                                  (qtn.confirmation_status is null or qtn.confirmation_status not in ('R')))
         join mt_financial_period fin_period on qtn.quotation_date >= fin_period.period_start_date and
                                                qtn.quotation_date <= fin_period.period_closing_date;

select quotation_no, quotation_date, status, confirmation_status, total_pre_tax_home_amt
from pj_qtn_hst_hdr where quotation_no = 'SQ00000232';
---------------------
INSERT INTO module_config(module_code, property_name, property_value, default_value, remarks, data_type, rendered, tab_label, is_active, required, readonly)
VALUES ('PJ', 'MandatoryWorkDonePeriodInProjectClaim', 'N', 'N', 'This module config will set Work Done Period in Project Claim is mandatory field.', 'Boolean', 'Y', 'tab_label_pj_3_progressive_claim', 'Y', 'N', 'N');

select * from module_config where property_name = 'MandatoryWorkDonePeriodInProjectClaim';
---------------
select role.project_no, role.employee_role_code, mem.employee_code, emp.employee_short_name, role.seq_no, proj.revision_no, role.is_key_person
from pj_est_ost_role_in_proj as role
         join pj_est_ost_team_member as mem on role.project_no = mem.project_no and role.team_member_seq_no = mem.seq_no
            join mt_employee as emp on mem.employee_code = emp.employee_code
                join pj_est_ost_hdr as proj on proj.project_no = role.project_no
where role.project_no = 'EST0001423' order by role.employee_role_code desc;

select * from sys_employee_sys_role where module = 'PJ' and is_approving_role = 'Y';

select qty_on_hand_without_pack,
       qty_on_hand_wo_pck_allocated,
       qty_on_hand_consigned_wo_pck,
       qty_reserved,
       qty_under_inspection_wo_pck,
       qty_under_ncr_wo_pck,
       unposted_qty_wo_pack,
       qty_under_insp_alloctd_wo_pck,
       qty_under_ncr_allocated_wo_pck,
       inventory_code,
       location_code
from mt_inventory_location
where inventory_code like '%IVT0007/IC%';

select * from mt_financial_period where period_start_date <= '2021-04-14' and period_closing_date >= '2021-04-14';

--------------------------------
INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_CONSTRUCTION_TEMPLATE', 'Project Construction Template', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_CONSTRUCTION_DETAILS', 'Project Construction Details', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_SAFETY_TEMPLATE', 'Project Safety Template', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_SAFETY_DETAILS', 'Project Safety Details', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_OVERVIEW_TEMPLATE', 'Project Overview Template', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_OVERVIEW_DETAILS', 'Project Overview Details', null, '', 'PJ', 6, 'I', 'N');
--------------------------------
update pj_est_new_cst_itm set claim_qty_factor = 'LB' WHERE claim_qty_factor = 'L, B';
update pj_est_ost_cst_itm set claim_qty_factor = 'LB' WHERE claim_qty_factor = 'L, B';
--------------------------------
---------------- SEGMENT ------------------
UPDATE MT_COMPANY_CONFIGURATION
SET ENABLE_SEGMENT = 'N',
MASTER_TYPE_1_EDITABLE = 'Y',
MASTER_TYPE_2_EDITABLE = 'N',
MASTER_TYPE_3_EDITABLE = 'N',
MASTER_TYPE_4_EDITABLE = 'N'
WHERE POINTER_KEY = 0;


UPDATE MT_COMPANY_CONFIGURATION
SET ENABLE_SEGMENT = 'Y',
MASTER_TYPE_1_EDITABLE = 'Y',
MASTER_TYPE_2_EDITABLE = 'N',
MASTER_TYPE_3_EDITABLE = 'N',
MASTER_TYPE_4_EDITABLE = 'N'
WHERE POINTER_KEY = 0;
---------------- END SEGMENT ------------------
---------- change layout of attachment
update module_config set property_value = 'F' where module_config.property_name = 'layoutofAttachmentPanelinProjectQuotationandProjectOrder';
----------------------
------------------------------
drop view pj_sub_con_hdr_view;

create view pj_sub_con_hdr_view (
    sub_con_contract_no,
    revision_no,
    letter_of_award,
    reference_no,
    sub_con_code,
    subject,
    start_date,
    end_date,
    defects_liability_period,
    currency_code,
    total_amount,
    project_no,
    approval_status,
    status,
    is_from_rev_table,
    sbu_code,
    variation_flag,
    contact_person,
    created_datetime,
    created_by,
    last_updated_by,
    last_updated_datetime,
    variation_by,
    posted_by,
    posted_datetime
) as
select pj_sub_con_hdr.sub_con_contract_no,
       pj_sub_con_hdr.revision_no,
       pj_sub_con_hdr.letter_of_award,
       pj_sub_con_hdr.reference_no,
       pj_sub_con_hdr.sub_con_code,
       pj_sub_con_hdr.subject,
       pj_sub_con_hdr.start_date,
       pj_sub_con_hdr.end_date,
       pj_sub_con_hdr.defects_liability_period,
       pj_sub_con_hdr.currency_code,
       pj_sub_con_hdr.total_amount,
       pj_sub_con_hdr.project_no,
       pj_sub_con_hdr.approval_status,
       pj_sub_con_hdr.status,
       'N' as is_from_rev_table,
       pj_sub_con_hdr.sbu_code,
       pj_sub_con_hdr.variation_flag,
       pj_sub_con_hdr.contact_person,
       pj_sub_con_hdr.created_datetime,
       pj_sub_con_hdr.created_by,
       pj_sub_con_hdr.last_updated_by,
       pj_sub_con_hdr.last_updated_datetime,
       pj_sub_con_hdr.variation_by,
       pj_sub_con_hdr.posted_by,
       pj_sub_con_hdr.posted_datetime
from pj_sub_con_hdr
union
select pj_sub_con_rev_hdr.sub_con_contract_no,
       pj_sub_con_rev_hdr.revision_no,
       pj_sub_con_rev_hdr.letter_of_award,
       pj_sub_con_rev_hdr.reference_no,
       pj_sub_con_rev_hdr.sub_con_code,
       pj_sub_con_rev_hdr.subject,
       pj_sub_con_rev_hdr.start_date,
       pj_sub_con_rev_hdr.end_date,
       pj_sub_con_rev_hdr.defects_liability_period,
       pj_sub_con_rev_hdr.currency_code,
       pj_sub_con_rev_hdr.total_amount,
       pj_sub_con_rev_hdr.project_no,
       pj_sub_con_rev_hdr.approval_status,
       pj_sub_con_rev_hdr.status,
       'Y' as is_from_rev_table,
       pj_sub_con_rev_hdr.sbu_code,
       pj_sub_con_rev_hdr.variation_flag,
       pj_sub_con_rev_hdr.contact_person,
       pj_sub_con_rev_hdr.created_datetime,
       pj_sub_con_rev_hdr.created_by,
       pj_sub_con_rev_hdr.last_updated_by,
       pj_sub_con_rev_hdr.last_updated_datetime,
       pj_sub_con_rev_hdr.variation_by,
       pj_sub_con_rev_hdr.posted_by,
       pj_sub_con_rev_hdr.posted_datetime
from pj_sub_con_rev_hdr
join pj_sub_con_hdr p on pj_sub_con_rev_hdr.sub_con_contract_no = p.sub_con_contract_no
where pj_sub_con_rev_hdr.project_no is not null;
----------------------------------

------ SYSTEM DATA VIEW --------
-- OPS: Original Project Sum
select total_pre_tax_home_amt
from (
         select project_no,
                revision_no,
                total_pre_tax_home_amt
         from pj_est_ost_hdr
         where approval_status = 'C'
         union
         select project_no,
                revision_no,
                total_pre_tax_home_amt
         from pj_est_rev_hst_hdr
         where approval_status = 'C'
     ) as res
where res.project_no = 'PJO0000216'
  and res.revision_no = (select min(revision_no)
                         from (select revision_no
                               from pj_est_ost_hdr
                               where approval_status = 'C'
                                 and project_no = 'PJO0000216'
                               union
                               select revision_no
                               from pj_est_rev_hst_hdr
                               where approval_status = 'C'
                                 and project_no = 'PJO0000216') as p);



select approval_status, * from pj_est_ost_hdr where project_no = 'PJO0000216';
select approval_status, * from pj_est_rev_hst_hdr where project_no = 'PJO0000216';

-- APS: Adjusted Project Sum
select * from (
              select project_no,
       revision_no,
       to_number(to_char(coalesce(variation_datetime, project_start_date), 'YYYY'), '9999') as year,
       to_number(to_char(coalesce(variation_datetime, project_start_date), 'MM'), '99')     as month,
       total_pre_tax_home_amt
from pj_est_ost_hdr where approval_status = 'C'
union
select project_no,
       revision_no,
       to_number(to_char(coalesce(variation_datetime, project_start_date), 'YYYY'), '9999') as year,
       to_number(to_char(coalesce(variation_datetime, project_start_date), 'MM'), '99')     as month,
       total_pre_tax_home_amt
from pj_est_rev_hst_hdr where approval_status = 'C'
                  ) as hdr
where hdr.project_no = 'PJE000004I';

select project_no, max(revision_no) as latest_rev, year, month
    from (
             select project_no,
                    revision_no,
                    to_number(to_char(coalesce(variation_datetime, project_start_date), 'YYYY'), '9999') as year,
                    to_number(to_char(coalesce(variation_datetime, project_start_date), 'MM'), '99')     as month,
                    total_pre_tax_home_amt
             from pj_est_ost_hdr where approval_status = 'C'
             union
             select project_no,
                    revision_no,
                    to_number(to_char(coalesce(variation_datetime, project_start_date), 'YYYY'), '9999') as year,
                    to_number(to_char(coalesce(variation_datetime, project_start_date), 'MM'), '99')     as month,
                    total_pre_tax_home_amt
             from pj_est_rev_hst_hdr where approval_status = 'C'
         ) as a where make_date(int4(a.year), int4(a.month), 1) <= make_date(2021, 8, 1) and project_no = 'PJE000004I'
    group by project_no, year, month;

select hdr.total_pre_tax_home_amt
from (
         select project_no,
                revision_no,
                to_number(to_char(coalesce(variation_datetime, project_start_date), 'YYYY'), '9999') as year,
                to_number(to_char(coalesce(variation_datetime, project_start_date), 'MM'), '99')     as month,
                total_pre_tax_home_amt
         from pj_est_ost_hdr where approval_status = 'C'
         union
         select project_no,
                revision_no,
                to_number(to_char(coalesce(variation_datetime, project_start_date), 'YYYY'), '9999') as year,
                to_number(to_char(coalesce(variation_datetime, project_start_date), 'MM'), '99')     as month,
                total_pre_tax_home_amt
         from pj_est_rev_hst_hdr where approval_status = 'C'
     ) as hdr
         join (
    select project_no, max(revision_no) as latest_rev, year, month
    from (
             select project_no,
                    revision_no,
                    to_number(to_char(coalesce(variation_datetime, project_start_date), 'YYYY'), '9999') as year,
                    to_number(to_char(coalesce(variation_datetime, project_start_date), 'MM'), '99')     as month,
                    total_pre_tax_home_amt
             from pj_est_ost_hdr where approval_status = 'C'
             union
             select project_no,
                    revision_no,
                    to_number(to_char(coalesce(variation_datetime, project_start_date), 'YYYY'), '9999') as year,
                    to_number(to_char(coalesce(variation_datetime, project_start_date), 'MM'), '99')     as month,
                    total_pre_tax_home_amt
             from pj_est_rev_hst_hdr where approval_status = 'C'
         ) as a
    group by project_no, year, month)
    as rev on rev.latest_rev = hdr.revision_no and rev.project_no = hdr.project_no and rev.year = hdr.year and rev.month = hdr.month
where hdr.project_no = 'PJE000004I'
  and hdr.year = 2021
  and hdr.month = 8;

-- TNC: Tender Net Cost
select coalesce(sum(bgt.budget_cost_in_home_ccy), 0)
from (
         select project_no, revision_no, budget_cost_in_home_ccy
         from pj_budget_ost_hdr where approval_status = 'C'
         union
         select project_no, revision_no, budget_cost_in_home_ccy
         from pj_budget_rev_hst_hdr where approval_status = 'C'
     ) as bgt
where bgt.project_no = 'PJE000001I'
  and bgt.revision_no = 0;

-- FEC: Final Estimated Cost
select *
from (
         select project_no, revision_no, budget_date, budget_cost_in_home_ccy
         from pj_budget_ost_hdr where approval_status = 'C'
         union
         select project_no, revision_no, budget_date, budget_cost_in_home_ccy
         from pj_budget_rev_hst_hdr where approval_status = 'C'
     ) as bgt
where bgt.project_no = 'PJE000004I'
order by bgt.revision_no;

select bgt.budget_cost_in_home_ccy
from (
         select project_no,
                revision_no,
                to_number(to_char(budget_date, 'YYYY'), '9999') as year,
                to_number(to_char(budget_date, 'MM'), '99')     as month,
                budget_cost_in_home_ccy
         from pj_budget_ost_hdr where approval_status = 'C'
         union
         select project_no,
                revision_no,
                to_number(to_char(budget_date, 'YYYY'), '9999') as year,
                to_number(to_char(budget_date, 'MM'), '99')     as month,
                budget_cost_in_home_ccy
         from pj_budget_rev_hst_hdr where approval_status = 'C'
     ) as bgt
         join (
    select project_no, max(revision_no) as latest_rev, year, month
    from (
             select project_no,
                    revision_no,
                    to_number(to_char(budget_date, 'YYYY'), '9999') as year,
                    to_number(to_char(budget_date, 'MM'), '99')     as month,
                    budget_cost_in_home_ccy
             from pj_budget_ost_hdr where approval_status = 'C'
             union
             select project_no,
                    revision_no,
                    to_number(to_char(budget_date, 'YYYY'), '9999') as year,
                    to_number(to_char(budget_date, 'MM'), '99')     as month,
                    budget_cost_in_home_ccy
             from pj_budget_rev_hst_hdr where approval_status = 'C'
         ) as a
    group by project_no, year, month
) as rev on rev.project_no = bgt.project_no and rev.year = bgt.year and rev.month = bgt.month and rev.latest_rev = bgt.revision_no
where bgt.project_no = 'PJE000004I' and bgt.year = 2021 and bgt.month = 6;

-- MCA: This Month Certified Amt
select coalesce(sum(this_certified_home_amt), 0)
from pj_cus_clm_vch_hdr
where status = 'H' and project_no = 'PJE000004I'
  and to_number(to_char(certified_date, 'YYYY'), '9999') = 2021 and to_number(to_char(certified_date, 'MM'), '99') = 8;

select status, * from pj_cus_clm_vch_hdr;

-- CCA: Cumulative Certified Amt
select coalesce(sum(this_cum_certified_home_amt), 0)
from pj_cus_clm_vch_hdr
where status = 'H'
  and project_no = 'PJE000004I'
  and clm_seq_no = (select max(clm_seq_no)
                    from pj_cus_clm_vch_hdr
                    where status = 'H'
                      and project_no = 'PJE000004I'
                      and make_date(int4(to_char(certified_date, 'YYYY')), int4(to_char(certified_date, 'MM')), 1) <= make_date(2022, 10, 1));

-- MAC: This Month Actual Cost
select coalesce(sum(total_actual_cost_home), 0)
from pj_est_ost_cst_brkdwn as brkdwn
         join mt_financial_period as period
             on brkdwn.year_posted_to = period.financial_year and brkdwn.period_posted_to = period.financial_period
where project_no = 'PJE000004I'
  and make_date(int4(to_number(to_char(period.period_start_date, 'YYYY'), '9999')), int4(to_number(to_char(period.period_start_date, 'MM'), '99')), 1) <= make_date(2020, 8, 1)
and make_date(int4(to_number(to_char(period.period_closing_date, 'YYYY'), '9999')), int4(to_number(to_char(period.period_closing_date, 'MM'), '99')), 1) >= make_date(2020, 8, 1);

-- CAC: Cumulative Actual Cost
select coalesce(sum(total_actual_cost_home), 0)
from pj_est_ost_cst_brkdwn as brkdwn
         join mt_financial_period as period
             on brkdwn.year_posted_to = period.financial_year and brkdwn.period_posted_to = period.financial_period
where project_no = 'PJE000004I'
  and make_date(int4(to_number(to_char(period.period_start_date, 'YYYY'), '9999')), int4(to_number(to_char(period.period_start_date, 'MM'), '99')), 1) <= make_date(2021, 10, 1);


select total_actual_cost_home, * from pj_est_ost_cst_brkdwn where project_no = 'PJE000004I';

-- MAR: This Month Received Amt CAR: Cumulative Received Amt
select coalesce(sum(rec_apl.applied_inv_home_amt), 0)
from ar_rec_hst_apl as rec_apl,
     pj_ar_inv_hst_hdr as inv_hdr
where rec_apl.invoice_no = inv_hdr.invoice_no
  and inv_hdr.project_no = 'PJE0000067'
  and rec_apl.application_date >= '2021-10-01'
  and rec_apl.application_date <= '2021-10-31';

select coalesce(sum(ctm.applied_inv_home_amt), 0)
from party_contra_hst_apl_ctm as ctm
         join party_contra_hst_hdr as ctm_hdr on ctm_hdr.contra_voucher_no = ctm.contra_voucher_no,
     pj_ar_inv_hst_hdr as inv_hdr
where ctm.ar_invoice_no = inv_hdr.invoice_no
  and inv_hdr.project_no = 'PJE0000067'
  and ctm_hdr.contra_voucher_date >= '2021-10-01'
  and ctm_hdr.contra_voucher_date <= '2021-10-31';

select coalesce(sum(rcc_det.applied_inv_home_amt), 0) as cash_in
from ar_rcc_hst_det as rcc_det,
     pj_ar_inv_hst_hdr as inv_hdr
where rcc_det.invoice_no = inv_hdr.invoice_no
  and inv_hdr.project_no = 'PJE0000067'
  and rcc_det.application_date <= '2021-10-31';
------ SYSTEM DATA VIEW --------
INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_RECOGNITION_OBAYASHI', 'Project Recognition', 'Obayashi', '', 'PJ', 6, 'I', 'N');


select * from Mt_ap_officer_unavail;

select * from Mt_ap_officer_on_behalf;

select this_clm_amt, * from pj_sub_clm_hdr where sub_con_clm_voucher_no = 'T-CL21';

select employee_role_code, *
from Mt_approving_by_sbu_amt_role ;

select employee_code, employee_role_code, * from Mt_employee_sys_role where employee_code = 'EMP00188';

select distinct sbu_amt_role.module_code, sbu_amt_role.transaction_type_code
from Mt_approving_by_sbu_amt_role sbu_amt_role
         cross join Mt_employee_sys_role sr
         cross join Mt_employee_sbu emp_sbu
         cross join Mt_approving_by_sbu_amt sbu_amt
         cross join Mt_approving_by_sbu sbu
where sbu_amt_role.MODULE_CODE = sbu_amt.module_code
  and sbu_amt_role.PK_NO_AMT = sbu_amt.pk_no_amt
  and sbu_amt_role.PK_NO_SBU = sbu_amt.pk_no_sbu
  and sbu_amt_role.TRANSACTION_TYPE_CODE = sbu_amt.transaction_type_code
  and sbu_amt.MODULE_CODE = sbu.module_code
  and sbu_amt.PK_NO_SBU = sbu.pk_no_sbu
  and sbu_amt.TRANSACTION_TYPE_CODE = sbu.transaction_type_code
  and sbu_amt_role.employee_role_code = sr.employee_role_code
  and (sbu.sbu_code is null or sbu.sbu_code = emp_sbu.sbu_code and sr.employee_code = emp_sbu.employee_code)
  and sr.employee_code = 'SYN00020';

INSERT INTO module_config(module_code, property_name, property_value, default_value, remarks, data_type, rendered, tab_label, is_active, required, readonly) VALUES ('PJ', 'enableToCommitCostWhenBudgetIsUnderVariation', 'N', 'N','','Boolean', 'Y','tab_label_pj_5_project_budget', 'Y', 'N', 'N');

--------------------- AO SHEET SUMMARY REPORT--------------------------------
INSERT INTO form_master(form_code,form_name,url,implemented_status,remarks,is_customized,module_code,transaction_type_code,version_no,is_mobile,created_by) VALUES ('TH5R_PJ_700906','AO Sheet Summary Report (Obayashi)','RPT_KEY=TH5R_PJ_700906','I',NULL,NULL,'PJ',NULL,5,'N','Larry');

---------------------END AO SHEET SUMMARY REPORT--------------------------------
select inv_home_amt_to_recog, * from pj_rcg_hst_hdr where project_no = 'PJO0000299';
select * from pj_est_rev_hst_hdr where project_no = 'PJO0000299';

select * from Pj_rcg_new_phs where project_no = 'PJO0000299';

select inv_home_amt_to_recog, Cost_home_to_recog, Nett_inv_pre_tax_home_amt, current_recog_percent, current_cost_recog_percent, current_revenue_recog_percent, *
from pj_rcg_new_hdr
where project_no = 'PJO0000299';


select inv_home_amt_to_recog, Cost_home_to_recog, Nett_inv_pre_tax_home_amt, current_recog_percent, *
from pj_rcg_new_phs
where project_no = 'PJO0000299';

select * from pj_est_ost_cst_brkdwn;

select * from mt_transaction_type where transaction_type_code = 'SCL';



select approval_status, status, * from pj_sub_clm_hdr where sub_con_contract_no = 'SUB0000189';

select TOL_TOTAL_USED_HOME, * from PJ_EST_OST_CST_ITM;

select type, * from attachment_hdr where transaction_type_code = 'SCL';

select recog_total_cost_home, recog_inv_pre_tax_home_amt, total_actual_cost_home, inv_home_amt_to_recog, inv_amt_to_recog, Cost_home_to_recog, cost_to_recog, Nett_inv_pre_tax_home_amt, current_recog_percent, current_cost_recog_percent, current_revenue_recog_percent, *
from pj_rcg_hst_hdr
where project_no = 'PJO0000364' order by recognition_date;

select recog_total_cost_home, recog_inv_pre_tax_home_amt
from pj_rcg_hst_hdr;


select bypass_budget_check, * from pj_budget_ost_sch;

select * from attachment_binary;

select parent_attachment_no, attachment_no, file_name, file_desc, * from attachment_hdr where mt_code_vch_no = 'PJE000063I' and revision_no = 17 and transaction_type_code = 'EST_REV';

select parent_attachment_no, * from attachment_hdr where mt_code_vch_no = 'PJE000063I' and revision_no = 17 and transaction_type_code = 'EST';

select revision_no, * from attachment_hdr where attachment_no = '1255';
select * from attachment_binary where binary_no = 1626;
select file_name, binary_no from attachment_binary where binary_no in (select binary_file_no from attachment_hdr where mt_code_vch_no = 'PJE000063I');

delete
from attachment_hdr
where content_type is not null
  and binary_file_no not in (select file_name, binary_no from attachment_binary where binary_no in (select binary_file_no from attachment_hdr where mt_code_vch_no = 'PJE000063I'));






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


select * from attachment_hdr where mt_code_vch_no = 'SUB0000199';

select * from module_config where property_name = 'hyperlinkForEmailAlertNotification';


select Inv_home_amt_to_recog, Cost_home_to_recog, Total_actual_cost_home, Recog_total_cost_home, recog_inv_pre_tax_home_amt, * from pj_rcg_hst_hdr where project_no = 'PJO0000395' order by recognition_no;
select Inv_home_amt_to_recog, Cost_home_to_recog, Total_actual_cost_home, Recog_total_cost_home, recog_inv_pre_tax_home_amt, * from pj_rcg_new_hdr where project_no = 'PJO0000395';
select recog_inv_pre_tax_home_amt, recog_total_cost_home, * from pj_est_ost_hdr where project_no = 'PJO0000395';

select recog_total_cost_home, * from pj_rcg_new_hdr where project_no = 'PJO0000311';

select recog_total_cost_home, recog_inv_pre_tax_home_amt, gen_recognition_flag, * from pj_est_ost_hdr where project_no = 'PJO0000311';

select * from pj_est_ost_cst_brkdwn where project_no = 'PJO0000311';

select * from gl_ledger_summary where source_voucher_no = 'PJO0000395' order by line_item_no, transaction_type_code, gl_entry_type;
select * from gl_ledger_detail where source_voucher_no='PJO0000395';


-------------------- Fix AO Sheet------------------
select * from pj_budget_obayashi_sch_view where budget_no = '309';
select * from pj_cost_brkdwn_sch_cst_itm where budget_no = '309' and sch_seq_no = '2.1.1';
--Comment out to prevent show error indicators of DataGrip
/*select schView.project_no,
       schView.project_name,
       schView.budget_no,
       schView.sch_seq_no,
       schView.parent_sch_seq_no,
       schView.cst_itm_no,
       schView.sch_ordering_no,
       schView.level,
       schView.item_code,
       schView.description,
       schView.tender_net,
       schView.execution_budget,
       schView.hdr_execution_budget,
       schView.cost_yet_to_receive_in_home_ccy,
       schView.actual_cost_in_home_ccy,
       schView.accum_commit,
       schView.to_commit,
       case
           when level in ('T2') then
               (select coalesce(sum(actual_cost_in_home_ccy), 0)
                from pj_cost_brkdwn_sch cstBrkdwnSch
                where cstBrkdwnSch.project_no = schView.project_no
                  and cstBrkdwnSch.budget_no = schView.budget_no
                  and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
                  and ((year_posted_to =
                        case
                            when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                            else $P{FINANCIAL_YEAR} - 1
                            end
                    and period_posted_to <
                        case
                            when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} - 1
                            else 12
                            end) or (year_posted_to <
                                     case
                                         when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                                         else $P{FINANCIAL_YEAR} - 1
                                         end)))
           when level in ('T0', 'T1') then
               (select coalesce(sum(actual_cost_in_home_ccy), 0)
                from pj_cost_brkdwn_sch cstBrkdwnSch
                where cstBrkdwnSch.project_no = schView.project_no
                  and cstBrkdwnSch.budget_no = schView.budget_no
                  and cstBrkdwnSch.sch_seq_no like concat(schView.sch_seq_no, '.%')
                  and ((year_posted_to = case
                                             when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                                             else $P{FINANCIAL_YEAR} - 1
                    end
                    and period_posted_to <
                        case
                            when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} - 1
                            else 12
                            end) or (year_posted_to <
                                     case
                                         when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                                         else $P{FINANCIAL_YEAR} - 1
                                         end)))
           when level in ('T3') then
               (select coalesce(sum(actual_cost_in_home_ccy), 0)
                from pj_cost_brkdwn_sch_cst_itm cstBrkdwnSchCstItem
                where cstBrkdwnSchCstItem.project_no = schView.project_no
                  and cstBrkdwnSchCstItem.budget_no = schView.budget_no
                  and cstBrkdwnSchCstItem.sch_seq_no = schView.sch_seq_no
                  and cstBrkdwnSchCstItem.cst_itm_seq_no = schView.cst_itm_no
                  and ((year_posted_to =
                        case
                            when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                            else $P{FINANCIAL_YEAR} - 1
                            end
                    and period_posted_to <
                        case
                            when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} - 1
                            else 12
                            end) or (year_posted_to <
                                     case
                                         when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                                         else $P{FINANCIAL_YEAR} - 1
                                         end)))
           else null
           end as cost_incurred_till_prev_last_month,

       case
           when level in ('T2') then
               coalesce((select actual_cost_in_home_ccy
                         from pj_cost_brkdwn_sch cstBrkdwnSch
                         where cstBrkdwnSch.project_no = schView.project_no
                           and cstBrkdwnSch.budget_no = schView.budget_no
                           and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
                           and year_posted_to =
                               case
                                   when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                                   else $P{FINANCIAL_YEAR} - 1
                                   end
                           and period_posted_to =
                               case
                                   when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} - 1
                                   else 12
                                   end), 0)
           when level in ('T0', 'T1') then
               (select coalesce(sum(actual_cost_in_home_ccy), 0)
                from pj_cost_brkdwn_sch cstBrkdwnSch
                where cstBrkdwnSch.project_no = schView.project_no
                  and cstBrkdwnSch.budget_no = schView.budget_no
                  and cstBrkdwnSch.sch_seq_no like concat(schView.sch_seq_no, '.%')
                  and year_posted_to =
                      case
                          when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                          else $P{FINANCIAL_YEAR} - 1
                          end
                  and period_posted_to =
                      case
                          when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} - 1
                          else 12
                          end)
           when level in ('T3') then
               coalesce((select actual_cost_in_home_ccy
                         from pj_cost_brkdwn_sch_cst_itm cstBrkdwnSchCstItm
                         where cstBrkdwnSchCstItm.project_no = schView.project_no
                           and cstBrkdwnSchCstItm.budget_no = schView.budget_no
                           and cstBrkdwnSchCstItm.sch_seq_no = schView.sch_seq_no
                           and cstBrkdwnSchCstItm.cst_itm_seq_no = schView.cst_itm_no
                           and year_posted_to =
                               case
                                   when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
                                   else $P{FINANCIAL_YEAR} - 1
                                   end
                           and period_posted_to =
                               case
                                   when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} - 1
                                   else 12
                                   end), 0)
           else null
           end as cost_for_last_month,

       case
           when level in ('T2') then
               coalesce((select actual_cost_in_home_ccy
                         from pj_cost_brkdwn_sch cstBrkdwnSch
                         where cstBrkdwnSch.project_no = schView.project_no
                           and cstBrkdwnSch.budget_no = schView.budget_no
                           and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
                           and year_posted_to = $P{FINANCIAL_YEAR}
                           and period_posted_to = $P{FINANCIAL_PERIOD}), 0)
           when level in ('T0', 'T1') then
               (select coalesce(sum(actual_cost_in_home_ccy), 0)
                from pj_cost_brkdwn_sch cstBrkdwnSch
                where cstBrkdwnSch.project_no = schView.project_no
                  and cstBrkdwnSch.budget_no = schView.budget_no
                  and cstBrkdwnSch.sch_seq_no like concat(schView.sch_seq_no, '.%')
                  and year_posted_to = $P{FINANCIAL_YEAR}
                  and period_posted_to = $P{FINANCIAL_PERIOD})
           when level in ('T3') then
               coalesce((select actual_cost_in_home_ccy
                         from pj_cost_brkdwn_sch_cst_itm cstBrkdwnSchCstItm
                         where cstBrkdwnSchCstItm.project_no = schView.project_no
                           and cstBrkdwnSchCstItm.budget_no = schView.budget_no
                           and cstBrkdwnSchCstItm.sch_seq_no = schView.sch_seq_no
                           and cstBrkdwnSchCstItm.cst_itm_seq_no = schView.cst_itm_no
                           and year_posted_to = $P{FINANCIAL_YEAR}
                           and period_posted_to = $P{FINANCIAL_PERIOD}), 0)
           else null
           end as cost_for_this_month,
       schView.final_estimated_cost,
       schView.hdr_final_estimated_cost,
       case
           when level <> '' then
               (select coalesce(budget_cost_in_home_ccy, 0)
                from pj_budget_sch_as_at_e1 bgtAsAt
                where bgtAsAt.project_no = schView.project_no
                  and bgtAsAt.budget_no = schView.budget_no
                  and bgtAsAt.sch_seq_no = schView.sch_seq_no
                  and ((as_at_year = $P{FINANCIAL_YEAR} and as_at_period < $P{FINANCIAL_PERIOD}) or (as_at_year < $P{FINANCIAL_YEAR}))
                order by bgtAsAt.revision_no desc fetch first 1 rows only)
           else null
           end as previous_month_est_cost
from PJ_BUDGET_OBAYASHI_SCH_VIEW schView
where project_no = $P{PROJECT_NO}
  and level = 'T3'
  and $P{REPORT_LEVEL} = 'T3'
  and sch_seq_no = $P{PARENT_SCH_SEQ_NO}
order by schView.budget_no, schView.sch_ordering_no;
*/

-- same as the above but non-formatted style
/*
select
  schView.project_no,
  schView.project_name,
  schView.budget_no,
  schView.sch_seq_no,
  schView.parent_sch_seq_no,
  schView.cst_itm_no,
  schView.sch_ordering_no,
  schView.level,
  schView.item_code,
  schView.description,
  schView.tender_net,
  schView.execution_budget,
  schView.hdr_execution_budget,
  schView.cost_yet_to_receive_in_home_ccy,
  schView.actual_cost_in_home_ccy,
  schView.accum_commit,
  schView.to_commit,
  case
    when level in ('T2') then
      (select coalesce(sum(actual_cost_in_home_ccy), 0) from pj_cost_brkdwn_sch cstBrkdwnSch
      where cstBrkdwnSch.project_no = schView.project_no and cstBrkdwnSch.budget_no = schView.budget_no and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
      and ((year_posted_to =
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end
	  and period_posted_to <
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} -1
	  else 12
	  end) or (year_posted_to <
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end)))
    when level in ('T0', 'T1') then
      (select coalesce(sum(actual_cost_in_home_ccy), 0) from pj_cost_brkdwn_sch cstBrkdwnSch
      where cstBrkdwnSch.project_no = schView.project_no and cstBrkdwnSch.budget_no = schView.budget_no and cstBrkdwnSch.sch_seq_no like concat(schView.sch_seq_no, '.%')
      and ((year_posted_to = case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end
	  and period_posted_to <
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} -1
	  else 12
	  end) or (year_posted_to <
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end)))
when level in ('T3') then
     (select coalesce(sum(actual_cost_in_home_ccy), 0) from pj_cost_brkdwn_sch_cst_itm cstBrkdwnSchCstItem
      where cstBrkdwnSchCstItem.project_no = schView.project_no and cstBrkdwnSchCstItem.budget_no = schView.budget_no and cstBrkdwnSchCstItem.sch_seq_no = schView.sch_seq_no and cstBrkdwnSchCstItem.cst_itm_seq_no = schView.cst_itm_no
      and ((year_posted_to =
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end
	  and period_posted_to <
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} -1
	  else 12
	  end) or (year_posted_to <
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end)))
    else null
  end as cost_incurred_till_prev_last_month,

  case
    when level in ('T2') then
      coalesce( (select actual_cost_in_home_ccy from pj_cost_brkdwn_sch cstBrkdwnSch
      where cstBrkdwnSch.project_no = schView.project_no and cstBrkdwnSch.budget_no = schView.budget_no and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
      and year_posted_to =
	  case
	  when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end
	  and period_posted_to =
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} -1
      else 12
      end), 0)
    when level in ('T0', 'T1') then
      (select coalesce(sum(actual_cost_in_home_ccy), 0) from pj_cost_brkdwn_sch cstBrkdwnSch
      where cstBrkdwnSch.project_no = schView.project_no and cstBrkdwnSch.budget_no = schView.budget_no and cstBrkdwnSch.sch_seq_no like concat(schView.sch_seq_no, '.%')
      and year_posted_to =
	  case
	  when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end
	  and period_posted_to =
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} -1
      else 12
      end)
 when level in ('T3') then
     coalesce( (select actual_cost_in_home_ccy from pj_cost_brkdwn_sch_cst_itm cstBrkdwnSchCstItm
      where cstBrkdwnSchCstItm.project_no = schView.project_no and cstBrkdwnSchCstItm.budget_no = schView.budget_no and cstBrkdwnSchCstItm.sch_seq_no = schView.sch_seq_no  and cstBrkdwnSchCstItm.cst_itm_seq_no = schView.cst_itm_no
      and year_posted_to =
	  case
	  when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_YEAR}
      else $P{FINANCIAL_YEAR} -1
      end
	  and period_posted_to =
	  case
      when $P{FINANCIAL_PERIOD} > 1 then $P{FINANCIAL_PERIOD} -1
      else 12
      end), 0)
    else null
  end as cost_for_last_month,

  case
    when level in ('T2') then
      coalesce( (select actual_cost_in_home_ccy from pj_cost_brkdwn_sch cstBrkdwnSch
      where cstBrkdwnSch.project_no = schView.project_no and cstBrkdwnSch.budget_no = schView.budget_no and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
      and year_posted_to = $P{FINANCIAL_YEAR} and period_posted_to = $P{FINANCIAL_PERIOD}), 0)
    when level in ('T0', 'T1') then
      (select coalesce(sum(actual_cost_in_home_ccy), 0) from pj_cost_brkdwn_sch cstBrkdwnSch
      where cstBrkdwnSch.project_no = schView.project_no and cstBrkdwnSch.budget_no = schView.budget_no and cstBrkdwnSch.sch_seq_no like concat(schView.sch_seq_no, '.%')
      and year_posted_to = $P{FINANCIAL_YEAR} and period_posted_to = $P{FINANCIAL_PERIOD})
 when level in ('T3') then
      coalesce( (select actual_cost_in_home_ccy from pj_cost_brkdwn_sch_cst_itm cstBrkdwnSchCstItm
      where cstBrkdwnSchCstItm.project_no = schView.project_no and cstBrkdwnSchCstItm.budget_no = schView.budget_no and cstBrkdwnSchCstItm.sch_seq_no = schView.sch_seq_no and cstBrkdwnSchCstItm.cst_itm_seq_no = schView.cst_itm_no
      and year_posted_to = $P{FINANCIAL_YEAR} and period_posted_to = $P{FINANCIAL_PERIOD}), 0)
    else null
  end as cost_for_this_month,
  schView.final_estimated_cost,
  schView.hdr_final_estimated_cost,
  case
    when level <> '' then
      (select coalesce(budget_cost_in_home_ccy, 0) from pj_budget_sch_as_at_e1 bgtAsAt
      where bgtAsAt.project_no = schView.project_no and bgtAsAt.budget_no = schView.budget_no and bgtAsAt.sch_seq_no = schView.sch_seq_no
      and ((as_at_year = $P{FINANCIAL_YEAR} and as_at_period < $P{FINANCIAL_PERIOD}) or (as_at_year < $P{FINANCIAL_YEAR})) order by bgtAsAt.revision_no desc fetch first 1 rows only)
    else null
  end as previous_month_est_cost
from PJ_BUDGET_OBAYASHI_SCH_VIEW schView
where project_no = $P{PROJECT_NO}
and level = 'T3'
and $P{REPORT_LEVEL} = 'T3'
and sch_seq_no = $P{PARENT_SCH_SEQ_NO}
order by schView.budget_no, schView.sch_ordering_no*/

--------------------END Fix AO Sheet------------------

select budget_date, variation_date, variation_datetime from pj_budget_ost_hdr;