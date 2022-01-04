drop view pj_sub_con_hdr_view;

create view pj_sub_con_hdr_view (sub_con_contract_no, revision_no, letter_of_award, reference_no, sub_con_code, subject, start_date, end_date, defects_liability_period, currency_code, total_amount, project_no, approval_status, status, is_from_rev_table, sbu_code, variation_flag, contact_person, created_datetime, created_by, last_updated_by, last_updated_datetime, variation_by, posted_by, posted_datetime) as
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

select status, approval_status, * from pj_sub_con_rev_hdr where sub_con_contract_no = 'SUBCON0001';

select status, * from pj_sub_clm_hdr where sub_con_clm_voucher_no = 'S-CLM00008';

select * from pj_sub_clm_mos where sub_con_clm_vch_no = 'S-CLM00007';

select * from gl_ledger_summary where source_voucher_no = 'APCRN00001';

select total_pre_tax_home_amt, Total_pre_tax_amt,
       total_after_tax_amt, total_after_tax_home_amt, *
from pj_ap_inv_hst_hdr
where invoice_no = 'SUB-IN0003';

select seq_no, pk_no_mos, parent_pk_no_mos, * from pj_sub_clm_mos as mos where sub_con_clm_vch_no = 'S-CLM00013' order by mos.seq_no;


INSERT INTO module_config (module_code, property_name, property_value, default_value, remarks, data_type, data_constraint, readonly, rendered, required, depending_properties,
                           tab_label, legacy_config, property_order, is_active, tab_order, created_by, created_datetime, last_updated_by, last_updated_datetime, object_version)
VALUES ('PJ', 'serviceCodeForUpdatingSubconMOSAmountToProjectCost', NULL, NULL,
        'When where is any MOS amount in Subcon Invoice updating project WIP, system will capture the MOS amount and update project actual cost using this service code', 'Entity',
        'searchService(main.mt.Mt_service)', 'N', 'Y', 'N', NULL,
        '', NULL, 170, 'Y', 0, NULL, NULL, NULL, NULL, 0);



select cost_yet_to_receive_in_home_ccy as cytr, actual_cost_in_home_ccy as actual_cost, budget_cost_in_home_ccy as budget_cost, *
from pj_budget_ost_hdr
where project_no = 'EST0000005';

select cost_yet_to_receive_in_home_ccy as cytr, actual_cost_in_home_ccy as actual_cost, budget_cost_in_home_ccy as budget_cost, *
from pj_budget_ost_sch
where budget_no = 44
order by sch_seq_no;

select service_code as sv, cost_yet_to_receive_in_home_ccy as cytr, actual_cost_in_home_ccy as actual, *
from Pj_budget_ost_cst_itm
where budget_no = 44;

select det.alloc_seq_no as alloc_seq_no, hdr.voucher_no, det.cost_yet_to_receive_in_home_ccy, det.actual_cost_in_home_ccy, *
from Pj_committed_cost_track_trn_det as det
         join Pj_committed_cost_track_trn_hdr as hdr on det.project_no = hdr.project_no and det.trn_seq_no = hdr.trn_seq_no and det.no_of_alloc = hdr.no_of_alloc
where hdr.project_no = 'EST0000005';

select * from pj_committed_cost_track_trn_hdr where project_no = 'EST0000005';

select *
from pj_est_ost_cst_brkdwn as brkdwn
where project_no = 'EST0000005'
  and (year_posted_to <= 2021 and period_posted_to <= 12);

select service_code, budget_no, *
from pj_budget_ost_sch_cst_itm
where budget_no = 44;

select * from pj_budget_ost_sch_cst_itm_bq_itm where budget_no = 43;

select * from pj_ap_inv_hst_hdr where project_no = 'EST0000005';

select * from Pj_committed_cost_track_trn_hdr where voucher_no = 'SUB-IN0019';

select alloc_seq_no, * from pj_trn_alloc_cost where voucher_no = 'SUBCON0002';

select alloc_seq_no, * from pj_trn_alloc_cost where voucher_no = 'S-CLM00036';

select * from pj_trn_alloc_cost where ref_alloc_seq_no = '1898151981';

select status, * from pj_trn_alloc_cost where voucher_no = 'SUB-IN0022';
select * from pj_committed_cost_track_trn_hdr where voucher_no = 'SUB-IN0022';
select * from pj_committed_cost_track_trn_det where project_no = 'EST0000002' and trn_seq_no = 55;

select * from mt_transaction_type where transaction_type_code = 'SUB_REV';


INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_RECOGNITION_OBAYASHI', 'Project Recognition', 'Obayashi', '', 'PJ', 6, 'I', 'N');
-----------------------------------REFERENCE TABLE------------------------------------------
select (select r.relname from pg_class r where r.oid = c.conrelid) as "table",
       (select array_agg(attname) from pg_attribute
        where attrelid = c.conrelid and ARRAY[attnum] <@ c.conkey) as col,
       (select r.relname from pg_class r where r.oid = c.confrelid) as ftable
from pg_constraint c
where c.confrelid = (select oid from pg_class where relname = 'pj_budget_ost_sch') and
      c.confkey @> (select array_agg(attnum) from pg_attribute
                    where (attname = 'budget_no' or attname = 'sch_seq_no') and attrelid = c.confrelid);

select (select array_agg(attname) from pg_attribute
        where attrelid = con.conrelid and ARRAY[attnum] <@ con.conkey) as fk_column,
       (select relname from pg_class where oid = con.conrelid) as fk_table,
       (select * from (select relname from pg_class where oid = con.conrelid) as kk) as records
from pg_constraint as con
where con.confrelid = (select oid from pg_class as cls where cls.relname = 'pj_budget_ost_sch')
  and con.confkey @> (select array_agg(attr.attnum)
                      from pg_attribute as attr
                      where (attr.attname = 'budget_no' or attr.attname = 'sch_seq_no')
                        and attr.attrelid = con.confrelid);

---- get primary key of a table
SELECT a.attname, format_type(a.atttypid, a.atttypmod) AS data_type
FROM   pg_index i
JOIN   pg_attribute a ON a.attrelid = i.indrelid
                     AND a.attnum = ANY(i.indkey)
WHERE  i.indrelid = 'pj_budget_ost_sch'::regclass
AND    i.indisprimary;


select con.confrelid, con.confkey, con.* from pg_constraint as con;

select array_agg(attr.attnum)
from pg_attribute as attr
where (attr.attname = 'budget_no' or attr.attname = 'sch_seq_no')
  and attr.attrelid = 274196;

select oid, * from pg_class where relname = 'pj_budget_ost_sch';
---------------------------------------------------------------------------
INSERT INTO module_config(module_code, property_name, property_value, default_value, remarks, data_type, rendered, tab_label, is_active, required, readonly) VALUES ('PJ', 'enableToCommitCostWhenBudgetIsUnderVariation', 'N', 'N','','Boolean', 'Y','tab_label_pj_5_project_budget', 'Y', 'N', 'N');

select * from module_config where property_name = 'dnsForThirdPartySubconClaimVoucher';

select cost_yet_to_receive_in_home_ccy, actual_cost_in_home_ccy, budget_cost_in_home_ccy, committed_qty, committed_qty, consumed_qty, *
from pj_budget_ost_hdr
where project_no = 'EST0000005';

select cost_yet_to_receive_in_home_ccy as cytr, actual_cost_in_home_ccy as actual_cost, budget_cost_in_home_ccy as budget_cost, committed_qty, consumed_qty, *
from pj_budget_ost_sch
where budget_no = 44
order by sch_seq_no;
--------------------- AO SHEET SUMMARY REPORT--------------------------------
select * from form_master where form_code = 'TH5R_PJ_700906';

INSERT INTO form_master(form_code,form_name,url,implemented_status,remarks,is_customized,module_code,transaction_type_code,version_no,is_mobile,created_by) VALUES ('TH5R_PJ_700906','AO Sheet Summary Report (Obayashi)','RPT_KEY=TH5R_PJ_700906','I',NULL,NULL,'PJ',NULL,5,'N','Larry');

select hdr.project_no       as project_no,
       hdr.subject          as project_name,
       2021                 as current_year,
       11                   as current_period,
       seq_no               as phs_seq,
       phase_desc           as phs_desc,
       pre_tax_extended_amt as phs_amt
from pj_est_ost_phs as phs
         join pj_est_ost_hdr as hdr on phs.project_no = hdr.project_no
where hdr.project_no = 'EST0000005';




select schView.project_no,
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
           when level = 'T2' then
               (select coalesce(sum(actual_cost_in_home_ccy), 0)
                from pj_cost_brkdwn_sch cstBrkdwnSch
                where cstBrkdwnSch.project_no = schView.project_no
                  and cstBrkdwnSch.budget_no = schView.budget_no
                  and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
                  and ((year_posted_to =
                        case
                            when finPer.financial_period > 1 then finPer.financial_year
                            else finPer.financial_year - 1
                            end
                    and period_posted_to <
                        case
                            when finPer.financial_period > 1 then finPer.financial_period - 1
                            else 12
                            end) or (year_posted_to <
                                     case
                                         when finPer.financial_period > 1 then finPer.financial_year
                                         else finPer.financial_year - 1
                                         end)))
           when level in ('T0', 'T1') then
               (select coalesce(sum(actual_cost_in_home_ccy), 0)
                from pj_cost_brkdwn_sch cstBrkdwnSch
                where cstBrkdwnSch.project_no = schView.project_no
                  and cstBrkdwnSch.budget_no = schView.budget_no
                  and cstBrkdwnSch.sch_seq_no like concat(schView.sch_seq_no, '.%')
                  and ((year_posted_to = case
                                             when finPer.financial_period > 1 then finPer.financial_year
                                             else finPer.financial_year - 1
                    end
                    and period_posted_to <
                        case
                            when finPer.financial_period > 1 then finPer.financial_period - 1
                            else 12
                            end) or (year_posted_to <
                                     case
                                         when finPer.financial_period > 1 then finPer.financial_year
                                         else finPer.financial_year - 1
                                         end)))
           when level = 'T3' then null
           end                 as cost_incurred_till_prev_last_month,

       case
           when level = 'T2' then
               coalesce((select actual_cost_in_home_ccy
                         from pj_cost_brkdwn_sch cstBrkdwnSch
                         where cstBrkdwnSch.project_no = schView.project_no
                           and cstBrkdwnSch.budget_no = schView.budget_no
                           and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
                           and year_posted_to =
                               case
                                   when finPer.financial_period > 1 then finPer.financial_year
                                   else finPer.financial_year - 1
                                   end
                           and period_posted_to =
                               case
                                   when finPer.financial_period > 1 then finPer.financial_period - 1
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
                          when finPer.financial_period > 1 then finPer.financial_year
                          else finPer.financial_year - 1
                          end
                  and period_posted_to =
                      case
                          when finPer.financial_period > 1 then finPer.financial_period - 1
                          else 12
                          end)
           when level = 'T3' then null
           end                 as cost_for_last_month,

       case
           when level = 'T2' then
               coalesce((select actual_cost_in_home_ccy
                         from pj_cost_brkdwn_sch cstBrkdwnSch
                         where cstBrkdwnSch.project_no = schView.project_no
                           and cstBrkdwnSch.budget_no = schView.budget_no
                           and cstBrkdwnSch.sch_seq_no = schView.sch_seq_no
                           and year_posted_to = finPer.financial_year
                           and period_posted_to = finPer.financial_period), 0)
           when level in ('T0', 'T1') then
               (select coalesce(sum(actual_cost_in_home_ccy), 0)
                from pj_cost_brkdwn_sch cstBrkdwnSch
                where cstBrkdwnSch.project_no = schView.project_no
                  and cstBrkdwnSch.budget_no = schView.budget_no
                  and cstBrkdwnSch.sch_seq_no like concat(schView.sch_seq_no, '.%')
                  and year_posted_to = finPer.financial_year
                  and period_posted_to = finPer.financial_period)
           when level = 'T3' then null
           end                 as cost_for_this_month,
       schView.final_estimated_cost,
       schView.hdr_final_estimated_cost,
       case
           when level <> 'T3' then
               (select coalesce(budget_cost_in_home_ccy, 0)
                from pj_budget_sch_as_at_e1 bgtAsAt
                where bgtAsAt.project_no = schView.project_no
                  and bgtAsAt.budget_no = schView.budget_no
                  and bgtAsAt.sch_seq_no = schView.sch_seq_no
                  and ((as_at_year = finPer.financial_year and as_at_period < finPer.financial_period) or (as_at_year < finPer.financial_year))
                order by bgtAsAt.revision_no desc fetch first 1 rows only)
           end                 as previous_month_est_cost,
       case
           when finPer.financial_period > 1 then finPer.financial_period - 1
           else 12
           end                 as prev_financial_period,
       case
           when finPer.financial_period > 1 then finPer.financial_year
           else finPer.financial_year - 1
           end                 as prev_financial_year,
       case
           when finPer.financial_period > 2 then finPer.financial_period - 2
           when finPer.financial_period = 2 then 12
           else 11
           end                 as before_prev_financial_period,
       case
           when finPer.financial_period > 1 then finPer.financial_year
           else finPer.financial_year - 1
           end                 as before_prev_financial_year,
       finPer.financial_year   as current_year,
       finPer.financial_period as current_period
from PJ_BUDGET_OBAYASHI_SCH_VIEW schView
         left join mt_financial_period finPer on CURRENT_DATE >= finPer.period_start_date AND CURRENT_DATE <= finPer.period_closing_date
where project_no = 'EST0000005'
  and level = 'T3'
order by schView.budget_no, schView.sch_ordering_no;




create view PJ_BUDGET_OBAYASHI_SCH_VIEW
AS
(
(select est.project_no,
        est.subject                                                                                                                          as project_name,
        ostSch.budget_no,
        ostSch.sch_seq_no,
        ostSch.parent_sch_seq_no,
        null                                                                                                                                    cst_itm_no,
        CASE
            WHEN ostSch.budget_category_division_code is not null then 'T0'
            WHEN ostSch.budget_category_group_code is not null then 'T1'
            WHEN ostSch.budget_category_code is not null then 'T2'
            END                                                                                                                              as level,
        ostSch.ordering_no                                                                                                                   as sch_ordering_no,
        coalesce(ostSch.budget_category_division_code, ostSch.budget_category_group_code, ostSch.budget_category_code)                       as item_code,
        CASE
            WHEN ostSch.budget_category_division_code is not null then bgtDiv.budget_category_division_desc
            WHEN ostSch.budget_category_group_code is not null then bgtGrp.budget_category_group_desc
            WHEN ostSch.budget_category_code is not null then bgtCat.budget_category_desc
            END                                                                                                                              as description,
        CASE
            WHEN ostHdr.revision_no = 0 then ostSch.budget_cost_in_home_ccy
            ELSE (select revSch.budget_cost_in_home_ccy
                  from pj_budget_rev_hst_sch revSch
                  where revSch.budget_no = ostSch.budget_no
                    and revSch.sch_seq_no = ostSch.sch_seq_no
                    and revSch.revision_no = 0)
            END                                                                                                                              AS tender_net,
        CASE
            WHEN ostHdr.route_for_approval = 'Y' then ostSch.budget_cost_in_home_ccy
            ELSE (select revSch.budget_cost_in_home_ccy
                  from pj_budget_rev_hst_sch revSch
                           inner join pj_budget_rev_hst_hdr revHdr on revHdr.budget_no = revSch.budget_no and revHdr.revision_no = revSch.revision_no
                  where revSch.budget_no = ostSch.budget_no
                    and revSch.sch_seq_no = ostSch.sch_seq_no
                    and revHdr.route_for_approval = 'Y'
                  order by revHdr.revision_no desc
                  limit 1)
            END                                                                                                                              AS execution_budget,
        CASE
            WHEN ostHdr.route_for_approval = 'Y' then ostHdr.budget_cost_in_home_ccy
            ELSE (select revHdr.budget_cost_in_home_ccy
                  from pj_budget_rev_hst_hdr revHdr
                  where revHdr.budget_no = ostHdr.budget_no
                    and revHdr.route_for_approval = 'Y'
                  order by revHdr.revision_no desc
                  limit 1)
            END                                                                                                                              AS hdr_execution_budget,
        coalesce(ostSch.cost_yet_to_receive_in_home_ccy, 0)                                                                                  as cost_yet_to_receive_in_home_ccy,
        coalesce(ostSch.actual_cost_in_home_ccy, 0)                                                                                          as actual_cost_in_home_ccy,
        coalesce(ostSch.cost_yet_to_receive_in_home_ccy, 0) + coalesce(ostSch.actual_cost_in_home_ccy, 0)                                    as accum_commit,
        ostSch.budget_cost_in_home_ccy - (coalesce(ostSch.cost_yet_to_receive_in_home_ccy, 0) + coalesce(ostSch.actual_cost_in_home_ccy, 0)) as to_commit,
        ostSch.budget_cost_in_home_ccy                                                                                                       as final_estimated_cost,
        ostHdr.budget_cost_in_home_ccy                                                                                                       as hdr_final_estimated_cost
 from pj_budget_ost_sch ostSch
          inner join pj_budget_ost_hdr ostHdr on ostHdr.budget_no = ostSch.budget_no
          inner join pj_est_ost_hdr est on est.project_no = ostHdr.project_no
          left join mt_budget_category_division bgtDiv on ostSch.budget_category_division_code = bgtDiv.budget_category_division_code
          left join mt_budget_category_group bgtGrp on ostSch.budget_category_group_code = bgtGrp.budget_category_group_code
          left join mt_budget_category bgtCat on ostSch.budget_category_code = bgtCat.budget_category_code
 order by ostSch.budget_no, ostSch.ordering_no
)
UNION
(select est.project_no,
        est.subject                                                                                                                           as project_name,
        coalesce(ostSchCstItm.budget_no, ostCstItm.budget_no)                                                                                 as budget_no,
        coalesce(ostSchCstItm.sch_seq_no, ostCstItm.sch_seq_no)                                                                               as sch_seq_no,
        null                                                                                                                                  as parent_sch_seq_no,
        coalesce(ostSchCstItm.cst_itm_no, ostCstItm.cst_itm_seq_no)                                                                           as cst_itm_no,
        'T3'                                                                                                                                  as level,
        concat(ostSch.ordering_no, LPAD(coalesce(ostSchCstItm.cst_itm_no, ostCstItm.cst_itm_seq_no)::text, 10, '0'))                          as sch_ordering_no,
        case
            when ostSchCstItm.dt_type = 'I' then ostSchCstItm.inventory_code
            when ostSchCstItm.dt_type = 'S' then ostSchCstItm.service_code
            when ostCstItm.dt_type = 'I' then ostCstItm.inventory_code
            when ostCstItm.dt_type = 'S' then ostCstItm.service_code
            end                                                                                                                               as item_code,
        case
            when (ostSchCstItm.dt_type = 'I' or ostCstItm.dt_type = 'I') then mtInv.main_desc
            when (ostSchCstItm.dt_type = 'S' or ostCstItm.dt_type = 'S') then mtSrv.service_desc
            end                                                                                                                               as description,
        CASE
            WHEN ostHdr.revision_no = 0 then ostSchCstItm.est_total_cost
            ELSE (select revSchCstItm.est_total_cost
                  from pj_budget_rev_hst_sch_cst_itm revSchCstItm
                  where revSchCstItm.budget_no = ostSchCstItm.budget_no
                    and revSchCstItm.sch_seq_no = ostSchCstItm.sch_seq_no
                    and revSchCstItm.cst_itm_no = ostSchCstItm.cst_itm_no
                    and revSchCstItm.revision_no = 0)
            END                                                                                                                               AS tender_net,
        CASE
            WHEN ostHdr.route_for_approval = 'Y' then ostSchCstItm.est_total_cost
            ELSE (select revSchCstItm.est_total_cost
                  from pj_budget_rev_hst_sch_cst_itm revSchCstItm
                           inner join pj_budget_rev_hst_hdr revHdr on revHdr.budget_no = revSchCstItm.budget_no and revHdr.revision_no = revSchCstItm.revision_no
                  where revSchCstItm.budget_no = ostSchCstItm.budget_no
                    and revSchCstItm.sch_seq_no = ostSchCstItm.sch_seq_no
                    and revSchCstItm.cst_itm_no = ostSchCstItm.cst_itm_no
                    and revHdr.route_for_approval = 'Y'
                  order by revHdr.revision_no desc
                  limit 1)
            END                                                                                                                               AS execution_budget,
        CASE
            WHEN ostHdr.route_for_approval = 'Y' then ostHdr.budget_cost_in_home_ccy
            ELSE (select revHdr.budget_cost_in_home_ccy
                  from pj_budget_rev_hst_hdr revHdr
                  where revHdr.budget_no = ostHdr.budget_no
                    and revHdr.route_for_approval = 'Y'
                  order by revHdr.revision_no desc
                  limit 1)
            END                                                                                                                               AS hdr_execution_budget,
        ostCstItm.cost_yet_to_receive_in_home_ccy                                                                                             as cost_yet_to_receive_in_home_ccy,
        ostCstItm.actual_cost_in_home_ccy                                                                                                     as actual_cost_in_home_ccy,
        ostCstItm.cost_yet_to_receive_in_home_ccy + ostCstItm.actual_cost_in_home_ccy                                                         as accum_commit,
        coalesce(ostSchCstItm.est_total_cost, 0) - coalesce(ostCstItm.cost_yet_to_receive_in_home_ccy + ostCstItm.actual_cost_in_home_ccy, 0) as to_commit,
        ostSchCstItm.est_total_cost                                                                                                           as final_estimated_cost,
        ostHdr.budget_cost_in_home_ccy                                                                                                        as hdr_final_estimated_cost
 from pj_budget_ost_sch_cst_itm ostSchCstItm

          full outer join pj_budget_ost_cst_itm ostCstItm on ostCstItm.budget_no = ostSchCstItm.budget_no and ostCstItm.sch_seq_no = ostSchCstItm.sch_seq_no
     and coalesce(ostCstItm.service_code, '') = coalesce(ostSchCstItm.service_code, '') and coalesce(ostCstItm.inventory_code, '') = coalesce(ostSchCstItm.inventory_code, '')

          inner join pj_budget_ost_hdr ostHdr on (ostHdr.budget_no = ostSchCstItm.budget_no or ostHdr.budget_no = ostCstItm.budget_no)
          inner join pj_budget_ost_sch ostSch on (ostSch.budget_no = ostSchCstItm.budget_no or ostSch.budget_no = ostCstItm.budget_no) and
                                                 (ostSch.sch_seq_no = ostSchCstItm.sch_seq_no or ostSch.sch_seq_no = ostCstItm.sch_seq_no)
          inner join pj_est_ost_hdr est on est.project_no = ostHdr.project_no
          left join mt_inventory mtInv on (mtInv.inventory_code = ostSchCstItm.inventory_code or mtInv.inventory_code = ostCstItm.inventory_code)
          left join mt_service mtSrv on (mtSrv.service_code = ostSchCstItm.service_code or mtSrv.service_code = ostCstItm.service_code)
 order by ostSch.budget_no, ostSch.ordering_no, ostSchCstItm.cst_itm_no
)
);


SELECT extract(month FROM date) AS month, extract(year FROM date) AS year
FROM (
    SELECT generate_series('2015-01-01'::date, '2017-12-31'::date, '1 month'::interval) AS date
) AS date_range;


select project_period.project_no        as project_no,
       pjo_hdr.subject                  as project_name,
       project_period.financial_year    as financial_year,
       project_period.financial_period  as financial_period,
       extract(year FROM monthly_date)  as year,
       extract(month FROM monthly_date) as month,
       case
           when pjo_hdr.revision_no = 0 and pjo_hdr.approval_status = 'C' then pjo_hdr.total_pre_tax_home_amt
           else (select revHdr.total_pre_tax_home_amt
                 from pj_est_rev_hst_hdr revHdr
                 where revHdr.project_no = pjo_hdr.project_no
                   and revHdr.revision_no = 0
                   and revHdr.approval_status = 'C')
           end                          as original_contract_sum,
       case
           when bgt_hdr.revision_no = 0 and bgt_hdr.approval_status = 'C' then bgt_hdr.budget_cost_in_home_ccy
           else (select rev_bgt.budget_cost_in_home_ccy
                 from pj_budget_rev_hst_hdr as rev_bgt
                 where rev_bgt.project_no = bgt_hdr.project_no
                   and rev_bgt.revision_no = 0
                   and rev_bgt.approval_status = 'C')
           end                          as tender_net,
       (select vo_addition_confirmed_home_amt + vo_omission_confirmed_home_amt
        from pj_est_ost_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as pjo_rev
                             from pj_est_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and coalesce(variation_datetime, estimation_date) <= project_period.period_closing_date
                             union
                             select revision_no as pjo_rev
                             from pj_est_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and coalesce(variation_datetime, estimation_date) <= project_period.period_closing_date
                             order by pjo_rev desc
                             limit 1)
        union
        select vo_addition_confirmed_home_amt + vo_omission_confirmed_home_amt
        from pj_est_rev_hst_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as pjo_rev
                             from pj_est_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and coalesce(variation_datetime, estimation_date) <= project_period.period_closing_date
                             union
                             select revision_no as pjo_rev
                             from pj_est_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and coalesce(variation_datetime, estimation_date) <= project_period.period_closing_date
                             order by pjo_rev desc
                             limit 1)
       )                                as confirmed_vo,
       (select vo_addition_unconfirmed_home_amt + vo_omission_unconfirmed_home_amt
        from pj_est_ost_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as pjo_rev
                             from pj_est_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and coalesce(variation_datetime, estimation_date) <= project_period.period_closing_date
                             union
                             select revision_no as pjo_rev
                             from pj_est_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and coalesce(variation_datetime, estimation_date) <= project_period.period_closing_date
                             order by pjo_rev desc
                             limit 1)
        union
        select vo_addition_unconfirmed_home_amt + vo_omission_unconfirmed_home_amt
        from pj_est_rev_hst_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as pjo_rev
                             from pj_est_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and coalesce(variation_datetime, estimation_date) <= project_period.period_closing_date
                             union
                             select revision_no as pjo_rev
                             from pj_est_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and coalesce(variation_datetime, estimation_date) <= project_period.period_closing_date
                             order by pjo_rev desc
                             limit 1)
       )                                as unconfirmed_vo,
       (select budget_cost_in_home_ccy
        from pj_budget_ost_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as rev
                             from pj_budget_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             union
                             select revision_no as rev
                             from pj_budget_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             order by rev desc
                             limit 1)
        union
        select budget_cost_in_home_ccy
        from pj_budget_rev_hst_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as rev
                             from pj_budget_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             union
                             select revision_no as rev
                             from pj_budget_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             order by rev desc
                             limit 1)
       )                                as execution_budget,
       (select cost_yet_to_receive_in_home_ccy + actual_cost_in_home_ccy
        from pj_budget_ost_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as rev
                             from pj_budget_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             union
                             select revision_no as rev
                             from pj_budget_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             order by rev desc
                             limit 1)
        union
        select  cost_yet_to_receive_in_home_ccy + actual_cost_in_home_ccy
        from pj_budget_rev_hst_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as rev
                             from pj_budget_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             union
                             select revision_no as rev
                             from pj_budget_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             order by rev desc
                             limit 1)
       )                                as accum_commit,
       (select actual_cost_in_home_ccy
        from pj_budget_ost_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as rev
                             from pj_budget_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             union
                             select revision_no as rev
                             from pj_budget_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             order by rev desc
                             limit 1)
        union
        select actual_cost_in_home_ccy
        from pj_budget_rev_hst_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as rev
                             from pj_budget_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             union
                             select revision_no as rev
                             from pj_budget_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and route_for_approval = 'Y'
                               and budget_date <= project_period.period_closing_date
                             order by rev desc
                             limit 1)
       )                                as accum_cost_to_date,
       (select budget_cost_in_home_ccy
        from pj_budget_ost_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as rev
                             from pj_budget_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and budget_date <= project_period.period_closing_date
                             union
                             select revision_no as rev
                             from pj_budget_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and budget_date <= project_period.period_closing_date
                             order by rev desc
                             limit 1)
        union
        select budget_cost_in_home_ccy
        from pj_budget_rev_hst_hdr
        where project_no = project_period.project_no
          and revision_no = (select revision_no as rev
                             from pj_budget_ost_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and budget_date <= project_period.period_closing_date
                             union
                             select revision_no as rev
                             from pj_budget_rev_hst_hdr
                             where project_no = project_period.project_no
                               and approval_status = 'C'
                               and budget_date <= project_period.period_closing_date
                             order by rev desc
                             limit 1)
       )                                as final_estimated_cost
from (select budget.project_no,
             period.financial_year,
             period.financial_period,
             period.period_closing_date,
             generate_series(budget.budget_date, period.period_closing_date, '1 month'::interval) as monthly_date
      from (select project_no, budget_date, route_for_approval, revision_no
            from pj_budget_ost_hdr
            union
            select project_no, budget_date, route_for_approval, revision_no
            from pj_budget_rev_hst_hdr) as budget,
           mt_financial_period as period
      where budget.route_for_approval = 'Y'
        and budget.revision_no = (select min(bgt.revision_no)
                                  from (select revision_no
                                        from pj_budget_ost_hdr
                                        where project_no = budget.project_no
                                          and route_for_approval = 'Y'
                                        union
                                        select revision_no
                                        from pj_budget_rev_hst_hdr
                                        where project_no = budget.project_no
                                          and route_for_approval = 'Y') as bgt)) as project_period
         left outer join pj_est_ost_hdr as pjo_hdr on pjo_hdr.project_no = project_period.project_no
         join pj_budget_ost_hdr as bgt_hdr on bgt_hdr.project_no = project_period.project_no
where project_period.project_no = 'EST0000001'
  and project_period.financial_year = 2022
  and project_period.financial_period = 3;


select case
           when ostHdr.revision_no = 0 and ostHdr.approval_status = 'C' then ostHdr.total_pre_tax_home_amt
           else (select revHdr.total_pre_tax_home_amt from pj_est_rev_hst_hdr revHdr where revHdr.project_no = ostHdr.project_no and revHdr.revision_no = 0 and revHdr.approval_status = 'C')
           end
from pj_est_ost_hdr as ostHdr
where project_no = 'EST0000006';

select pjo_rev.confirmed_vo, pjo_rev.unconfirmed_vo
from (
         select project_no,
                vo_addition_confirmed_home_amt + vo_omission_confirmed_home_amt     as confirmed_vo,
                vo_addition_unconfirmed_home_amt + vo_omission_unconfirmed_home_amt as unconfirmed_vo,
                coalesce(variation_datetime, estimation_date)                       as date
         from pj_est_ost_hdr
         where approval_status = 'C'
         union
         select project_no,
                vo_addition_confirmed_home_amt + vo_omission_confirmed_home_amt     as confirmed_vo,
                vo_addition_unconfirmed_home_amt + vo_omission_unconfirmed_home_amt as unconfirmed_vo,
                coalesce(variation_datetime, estimation_date)                       as date
         from pj_est_rev_hst_hdr
         where approval_status = 'C'
     ) as pjo_rev
where pjo_rev.project_no = 'EST0000006'
    and pjo_rev.date <= '2022-03-31'::date;


select route_for_approval, * from pj_budget_rev_hst_hdr where project_no = 'EST0000001';
select route_for_approval, * from pj_budget_ost_hdr where project_no = 'EST0000001';


---------------------END AO SHEET SUMMARY REPORT--------------------------------
select * from attachment_hdr where mt_code_vch_no = 'SUB-IN0037';

select * from attachment_binary where binary_no = '4615';


select * from pj_subconbc_oht_hdr where sub_con_contract_no = 'SUBCON0007';

select back_charge_claimed_qty, back_charge_claimed_amt, back_charge_claimed_home_amt, *
from Pj_sub_con_back_charge
where sub_con_contract_no = 'SUBCON0007';

select qty, total_amt, total_home_amt, * from pj_sub_clm_back_charge where sub_con_clm_voucher_no = 'S-CLM00054';





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





