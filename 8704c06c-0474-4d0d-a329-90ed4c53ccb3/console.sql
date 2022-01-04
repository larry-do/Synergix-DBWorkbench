update pj_subconbc_new_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
update pj_subconbc_oht_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
select * from pj_subconbc_oht_email_setting;
select * from pj_subconbc_new_email_setting;

update mt_employee set email_address = 'lavie.pham@synergixtech.com' where employee_code is not null;
select email_address from mt_employee;
select * from mt_user where lower(alias) like lower('%TAN CHEE TANG%'); --PD0361 ;
delete from attachment_binary where binary_no is not null;
delete from attachment_hdr where transaction_type_code is not null;
delete from audit_det where seq_no is not null;
delete from audit_hdr where audit_id is not null;
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
-----------END ATTACHMENT ENHANCEMENT-----------------------
select phase_level_no, vo_type, * from PJ_EST_OST_PHS where project_no = 'PJES000015' and phase_level_no = 7;

select *
from pj_est_ost_phs as est_phs
where project_no = 'PJES000015'
order by phase_level_no asc, case est_phs.vo_type when 'OMISSION' then 2 else 1 end;


--Order for delete phases
select est_phs.phase_level_no, clm_phs.*
from pj_cus_clm_phs as clm_phs
         join pj_cus_clm_vch_hdr as clm_hdr on clm_phs.clm_vch_no = clm_hdr.clm_vch_no
         join pj_est_ost_phs as est_phs on clm_phs.clm_phase_no = est_phs.phase_no and clm_hdr.project_no = est_phs.project_no
where clm_phs.clm_vch_no = 'PJPC000155'
order by est_phs.phase_level_no desc, case est_phs.vo_type when 'OMISSION' then 1 else 2 end;


select est_phs.phase_level_no, est_phs.omitted_phase_no, clm_phs.*
from pj_cus_clm_phs as clm_phs
         join pj_cus_clm_vch_hdr as clm_hdr on clm_phs.clm_vch_no = clm_hdr.clm_vch_no
         join pj_est_ost_phs as est_phs on clm_phs.clm_phase_no = est_phs.phase_no and clm_hdr.project_no = est_phs.project_no
where clm_phs.clm_vch_no = 'PJPC000188'
order by est_phs.phase_level_no asc, case clm_phs.vo_type when 'OMISSION' then 2 else 1 end;


select clm_phs.this_cum_claim_amt as this_cum_claim_amt
from Pj_cus_clm_phs clm_phs
         cross join Pj_cus_clm_vch_hdr clm_hdr
where clm_phs.CLM_VCH_NO = clm_hdr.clm_vch_no
  and clm_hdr.project_no = 'PJES000015'
  and clm_hdr.status <> 'X'
  and clm_phs.clm_phase_no = 'PHS16946'
  and clm_hdr.clm_seq_no = 0;



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



select total_actual_cost_home, * from pj_rcg_new_hdr where (project_no is not null) is not false;

select * from Pj_est_ost_cst_brkdwn e where e.project_no = 'PJES000006' and (e.year_posted_to < 2021 or (e.year_posted_to = 2021 and e.period_posted_to <= 10));



select budget_cost_in_home_ccy, revision_no, budget_date, *
from pj_budget_ost_hdr
where project_no = 'PJES000006';

select Total_pre_tax_home_amt, variation_datetime, approval_status, revision_no, * from pj_est_rev_hst_hdr where project_no = 'PJES000006' order by revision_no;
select Total_pre_tax_home_amt, variation_datetime, approval_status, * from pj_est_ost_hdr where project_no = 'PJES000001';


select recog_total_cost_home, recog_inv_pre_tax_home_amt, * from Pj_est_ost_cst_brkdwn e where e.project_no = 'PJES000001' and period_posted_to = 10 and year_posted_to = 2021;
select cost_home_to_recog, total_actual_cost_home, recog_total_cost_home, * from pj_rcg_hst_hdr where project_no = 'PJES000001' order by recognition_no;
select cost_home_to_recog, total_actual_cost_home, recog_total_cost_home, * from pj_rcg_new_hdr where project_no = 'PJES000001';

select original_seq_no, * from pj_est_var_phs where project_no = 'PJES000014';

