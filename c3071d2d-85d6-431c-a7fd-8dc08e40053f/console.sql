select * from form_master where FORM_CODE = 'TH6_PJ_PROJECT_ORDER_FUTAR';

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, description, URL, MODULE_CODE, VERSION_NO,
                         IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_CLAIM_FUTAR', 'Project Claim', 'Futar', '', 'PJ', 6, 'I', 'N');

select *
from module_config
where module_code = 'PJ'
  and property_name like '%displaySpecNoInProjectQuotationOrderClaim%';

INSERT INTO module_config(module_code, property_name, property_value, default_value, remarks, data_type, rendered,
                          tab_label, is_active, required, readonly, property_order, tab_order)
VALUES ('PJ', 'displaySpecNoInProjectQuotationOrderClaim', 'N', 'N',
        'System will display "Spec No." column in Job Scope/ BQ tab of Project Quotation, Order and Claim screen.',
        'Boolean', 'N',
        '', 'Y', 'N', 'N', 0, 0);

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

select *
from MT_TRANSACTION_TYPE where MODULE_CODE = 'PJ';

select master_type_1 from mt_company_configuration;

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

insert into sys_dashpane(dashpane_code, dashpane_desc, dashpane_title, module_code, prefered_width, prefered_height)
values ('TH6_PJ_SALES_AMT_HIT_RATE_BY_SALES_MANAGER',
        'Display the total amount of quotations that are failed, confirmed and outstanding within the selected financial year & period (by sales manager and in home currency).',
        'proj_sales_amt_hit_rate_by_sales_manager', 'PJ', 1, 1);

select *
from sys_dashpane
where dashpane_code = 'TH6_PJ_SALES_AMT_HIT_RATE_BY_SALES_MANAGER';

select * from proj_sales_amt_hit_rate_view;

INSERT INTO module_config(module_code, property_name, property_value, default_value, remarks, data_type, rendered, tab_label, is_active, required, readonly) VALUES ('PJ', 'MandatoryWorkDonePeriodInProjectClaim', 'N', 'N', 'This module config will set Work Done Period in Project Claim is mandatory field.', 'Boolean', 'Y', 'tab_label_pj_3_progressive_claim', 'Y', 'N', 'N');

select * from module_config where property_name = 'MandatoryWorkDonePeriodInProjectClaim';


--------START FUTAR CLAIM SECTION---------------
select INVENTORY_CODE, LOCATION_CODE from MT_INVENTORY_LOCATION where INVENTORY_CODE = '.190214';

select location_code,
       qty_on_hand_without_pack,
       qty_on_hand_wo_pck_allocated,
       qty_on_hand_consigned_wo_pck,
       qty_reserved,
       qty_under_inspection_wo_pck,
       qty_under_ncr_wo_pck,
       unposted_qty_wo_pack,
       qty_under_insp_alloctd_wo_pck,
       qty_under_ncr_allocated_wo_pck
from mt_inventory_location
where inventory_code = 'ANNA-LOT1';
--
SELECT DELIVERY_ORDER_NO,
       ACTUAL_SHIPMENT_DATE,
       UNIT_NO
FROM LG_DELIVERY_OHT_HDR
WHERE STATUS = 'C'
  AND SOURCE_VOUCHER_TYPE = 'DIRECT'
  AND TYPE = 'STOCKISSUE'
  AND ISSUE_TYPE IN ('PBS', 'DPB')
  AND PROJECT_NO = 'MONG04'
  AND DELIVERY_ORDER_NO NOT IN (SELECT DO_HDR.DELIVERY_ORDER_NO
                                FROM LG_DELIVERY_OHT_HDR AS DO_HDR
                                         JOIN PJ_CUS_CLM_PHS_FULFILLMENT AS FUL ON FUL.DELIVERY_ORDER_NO = DO_HDR.DELIVERY_ORDER_NO
                                         JOIN PJ_CUS_CLM_VCH_HDR AS VCH ON VCH.CLM_VCH_NO = FUL.CLM_VCH_NO
                                WHERE VCH.STATUS IN ('D', 'PA', 'P', 'H')
                                  AND (VCH.CLM_VCH_NO <> 'PCC0003763' OR (VCH.CLM_VCH_NO = 'PCC0003763' AND FUL.CLM_PHASE_NO = 'PHS89607')));

--
select CLM_VCH_NO, STATUS, PROJECT_NO from PJ_CUS_CLM_VCH_HDR where STATUS in ('D', 'PA', 'P', 'H') and PROJECT_NO = '00000143' ORDER BY STATUS;
SELECT INVOICE_NO, IS_CANCELLED, PROJECT_NO FROM PJ_AR_INV_HST_HDR where INVOICE_NO = 'IN0004075AGA';
SELECT CREDIT_NOTE_NO, INVOICE_NO, IS_CANCELLED, PROJECT_NO FROM PJ_AR_crn_HST_HDR where CREDIT_NOTE_NO = 'PCN0823/10';
select * from PJ_CUS_CLM_VCH_HDR where CLM_VCH_NO = 'PCC0003456';
select * from PJ_CUS_CLM_PHS where CLM_VCH_NO = 'PCC0003763';

SELECT PHASE_NO, DELIVERY_ORDER_NO, PK_NO_DET, FULFILLED_NO_OF_PCS, COST_ITEM_NO
FROM LG_DELIVERY_OHT_DET where DELIVERY_ORDER_NO = 'SI00000382';

SELECT DELIVERY_ORDER_NO, UNIT_NO
FROM LG_DELIVERY_OHT_HDR where DELIVERY_ORDER_NO = 'SI00000385';

select IS_CANCELLED from PJ_AR_CRN_HST_HDR WHERE IS_CANCELLED = 'Y';

select * from PJ_EST_OST_CST_ITM where PROJECT_NO = 'MONG04' and PHASE_NO = 'PHS87662' AND COST_ITEM_NO = 1;

select *
from PJ_CUS_CLM_PHS_FULFILLMENT where CLM_VCH_NO = 'PCC0003769';
-------- END FUTAR CLAIM SECTION---------------

select PHASE_NO, COST_ITEM_NO, FULFILLED_QTY
from LG_DELIVERY_OHT_DET
where PHASE_NO is not null
  and COST_ITEM_NO is not null
order by PHASE_NO;

select det.PHASE_NO, det.COST_ITEM_NO, det.RECEIVED_QTY, hdr.TYPE
from LG_GDSRECEIPT_OHT_DET as det
         join LG_GDSRECEIPT_OHT_HDR as hdr on det.GOODS_RECEIPT_NO = hdr.GOODS_RECEIPT_NO
where hdr.TYPE = 'R'
order by det.PHASE_NO;

select SCH_SEQ_NO, BUDGET_COST_IN_HOME_CCY, COST_YET_TO_RECEIVE_IN_HOME_CCY, ACTUAL_COST_IN_HOME_CCY from PJ_BUDGET_OST_SCH where BUDGET_NO = '624';


select * from Rpt_attributes where module_code = 'PJ' and transaction_type_code = 'EST';

select attachment_list from mt_email_alert_config where config_code = 'NOTIFY_SUBCON_BACK_CHARGE_REGISTRY';

select * from pj_ar_rec_hst_apl_view as view
join PJ_EST_OST_HDR as est on view.PROJECT_NO = est.PROJECT_NO;

update pj_est_new_cst_itm set claim_qty_factor = 'LB' WHERE claim_qty_factor = 'L, B';
update pj_est_ost_cst_itm set claim_qty_factor = 'LB' WHERE claim_qty_factor = 'L, B';

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
where inventory_code  = '.0190214';

ALTER TABLE PJ_SUB_CON_HDR ALTER COLUMN SUBJECT SET DATA TYPE VARCHAR(2000);

select * from COMMON_FILE_IMPORT;

select * from pj_safety_Details where project_no = 'MONG04' and item_code = 'AA' and year = 2020 and month = 4;

select cst.status, cst.* from pj_trn_alloc_cost as cst where voucher_no = 'T-CL22';
select cst.status, cst.* from pj_trn_alloc_cost as cst where voucher_no = 'T-CL23';

delete from module_config where property_name = 'allowCostAllocationToMultipleProjects';

INSERT INTO module_config (module_code, property_name, property_value, default_value, remarks, data_type, data_constraint, readonly, rendered, required, depending_properties,
                           tab_label, legacy_config, property_order, is_active, tab_order, created_by, created_datetime, last_updated_by, last_updated_datetime, object_version,
                           in_used_version, last_modified_by, last_modified_datetime, customized_label_code, customized_hint_code)
VALUES ('PJ', 'allowCostAllocationToMultipleProjects', 'Y', 'Y', 'Yes - System allows user to perform cost allocation to multiple projects in one cost allocation voucher.
No - System does not allow user to perform cost allocation to multiple projects in one cost allocation voucher', 'Boolean', '', 'N', 'Y', 'Y', NULL, '', NULL, 146, 'Y', 0, NULL,
        NULL, NULL, NULL, 0, NULL, NULL, NULL, NULL, NULL);

INSERT INTO module_config (module_code, property_name, property_value, default_value, remarks, data_type, data_constraint, readonly, rendered, required, depending_properties, tab_label, legacy_config, property_order, is_active, tab_order, created_by, created_datetime, last_updated_by, last_updated_datetime, object_version)
VALUES ('PJ', 'serviceCodeForUpdatingSubconMOSAmountToProjectCost', NULL, NULL, 'When where is any MOS amount in Subcon Invoice updating project WIP, system will capture the MOS amount and update project actual cost using this service code', 'Entity', 'searchService(main.mt.Mt_service)', 'N', 'Y', 'N', NULL, '', NULL, 170, 'Y', 0, NULL, NULL, NULL, NULL, 0);





select ar_rec_hst_apl.invoice_no, ar_rec_hst_apl.* from ar_rec_hst_apl;
select party_contra_new_apl_ctm.ar_invoice_no, party_contra_new_apl_ctm.* from party_contra_new_apl_ctm;
select ar_rcc_hst_det.invoice_no, ar_rcc_hst_det.* from ar_rcc_hst_det;
select pj_ar_inv_hst_hdr.invoice_no, pj_ar_inv_hst_hdr.* from pj_ar_inv_hst_hdr where invoice_no like '%%';


select * from MT_TRANSACTION_TYPE where MODULE_CODE = 'PJ' and TRANSACTION_TYPE_CODE IN ('EST', 'EST_REV');


insert into pj_cus_clm_phs(clm_vch_no,
                           clm_phase_no,
                           phase_seq_no,
                           parent_phase_no,
                           clm_phase_desc,
                           vo_type,
                           claim_type,
                           uom,
                           unit_price,
                           spec_no,
                           qty,
                           total_amount,
                           customer_item_code,
                           discount_amt,
                           discount_percent,
                           is_retain,
                           prg_ret_percent,
                           this_retention_percent_bal,
                           this_retention_percent_bal_clm)
select 'PJPC000144', --Change
       est_phs.phase_no,
       est_phs.seq_no,
       est_phs.parent_phase_no,
       est_phs.phase_desc,
       est_phs.vo_type,
       'A',
       est_phs.unit_desc,
       est_phs.base_unit_selling_price,
       est_phs.spec_no,
       case (select property_value from module_config where property_name = 'enableToInputClaimAndCertifiedAmountForOmissionPhase')
           when 'Y' then est_phs.qty
           else est_phs.qty - est_phs.omitted_qty end,
       case (select property_value from module_config where property_name = 'enableToInputClaimAndCertifiedAmountForOmissionPhase')
           when 'Y' then est_phs.pre_tax_extended_amt
           else est_phs.pre_tax_extended_amt - est_phs.omitted_pre_tax_amt end,
       case (select property_value from module_config where property_name = 'enableCustomerItemCode') when 'Y' then est_phs.customer_item_code end,
       est_phs.discount_amt,
       est_phs.discount_percent,
       est_phs.is_retain,
       est_phs.prg_ret_percent,
       est_phs.prg_ret_percent,
       est_phs.prg_ret_percent
from pj_est_ost_phs as est_phs
where (
        ((select property_value from module_config where property_name = 'claimByPhaseWithZeroAmt') = 'N')
        and (est_phs.pre_tax_extended_amt = 0)
        and (est_phs.vo_type != 'N' or
             (select count(child_phs.phase_no)
              from pj_est_ost_phs as child_phs
              where child_phs.parent_phase_no = est_phs.phase_no
                and child_phs.pre_tax_extended_amt != 0) = 0)
        and ((select coalesce(clm_phs.this_cum_claim_amt, 0)
              from pj_cus_clm_phs as clm_phs
                       join pj_cus_clm_vch_hdr as clm_hdr on clm_phs.clm_vch_no = clm_hdr.clm_vch_no
              where clm_hdr.project_no = 'PJES000015' --Change
                and clm_hdr.status != 'X'
                and clm_hdr.clm_seq_no = 0            --Change to prev claim no.
                and clm_phs.clm_phase_no = est_phs.phase_no) = 0)) = false
  and est_phs.project_no = 'PJES000015'; --Change


select budget_cost_in_home_ccy, revision_no, budget_date, *
from pj_budget_ost_hdr
where project_no = 'PJES000006';