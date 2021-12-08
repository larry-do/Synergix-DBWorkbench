update pj_subconbc_new_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
update pj_subconbc_oht_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
select * from pj_subconbc_oht_email_setting;
select * from pj_subconbc_new_email_setting;

update mt_employee set email_address = 'larry.do@synergixtech.com' where employee_code is not null;
select email_address, * from mt_employee;
select * from mt_user where lower(alias) like lower('%nne%'); --PD0361 ;

delete from attachment_hdr where module_code is not null;
delete from audit_det where object_version is not  null;
delete from audit_hdr where object_version is not  null;
select * from attachment_hdr;
----------------------

select rev.*
from pj_trn_alloc_cost as rev
         left outer join pj_trn_alloc_cost as ost on ost.alloc_seq_no = rev.ref_alloc_seq_no
where rev.voucher_no = 'SUB0000274'
  and rev.revision_no = 15
  and (rev.alloc_amt_in_bgt_ccy <> ost.alloc_amt_in_bgt_ccy or rev.variance_amt_in_bgt_ccy <> ost.variance_amt_in_bgt_ccy or rev.ref_alloc_seq_no is null);

select sub_con_sch_seq_no, sub_con_rev_sch_seq_no, revision_no, alloc_amt_in_bgt_ccy
from pj_trn_alloc_cost
where voucher_no = 'SUB0000274'
  and revision_no = 15
order by sub_con_sch_seq_no;

select * from pj_sub_con_phs where sub_con_contract_no = 'SUB0000274' order by phase_no;

select * from pj_sub_con_phs_bgt_sch where sub_con_contract_no = 'SUB0000274' order by phase_no;

select * from pj_trn_alloc_cost where voucher_no = 'SUB0000274' and sub_con_sch_seq_no is not null;


select * from pj_sub_con_rev_phs;

insert into Pj_sub_con_rev_phs_bgt_sch(seq_no, revision_no, sub_con_contract_no, phase_no, budget_no, sch_seq_no, trn_alloc_seq_no, alloc_amt, alloc_home_amt, actual_cost, actual_home_cost, phase_desc, status, created_by, created_datetime, last_updated_by, last_updated_datetime, last_modified_by, last_modified_datetime)
select seq_no, 19 as revision_no, sub_con_contract_no, phase_no, budget_no, sch_seq_no, trn_alloc_seq_no, alloc_amt, alloc_home_amt, actual_cost, actual_home_cost, phase_desc, status, created_by, created_datetime, last_updated_by, last_modified_datetime, last_modified_by, last_modified_datetime
from Pj_sub_con_phs_bgt_sch
where sub_con_contract_no = 'SUB0000274'
  and seq_no = '13226';

select * from pj_sub_con_rev_phs_bgt_sch;

select 19 as revision_no, * from Pj_sub_con_phs_bgt_sch where sub_con_contract_no = 'SUB0000274' and seq_no = '13226';

select * from Pj_sub_con_rev_phs_bgt_sch where sub_con_contract_no = 'SUB0000274' and seq_no = '13226';

select * from vh_ost_approval where voucher_no = 'SUB0000451';

SELECT phase_no, omitted_phase_no, parent_phase_no, revision_no, *
FROM pj_sub_con_rev_phs as phs
WHERE sub_con_contract_no = 'SUB0000451' and revision_no = 27
  and (omitted_phase_no = '1.1.4' or parent_phase_no = '1.1.4');

select sub_con_sch_seq_no as seq_no, sub_con_rev_sch_seq_no as seq_rev_no, revision_no as rev, alloc_amt_in_home_ccy as amt, *
from pj_trn_alloc_cost as cst
where cst.voucher_no = 'SUB0000274' and cst.revision_no < 11 and cst.sub_con_sch_seq_no is not null
order by cst.revision_no;
----------- CORRECT DATA DO LỖI UPDATE PJ_TRN_ALLOC_COST: KHÔNG TẠO ĐƯỢC SUBCON VARIATION MỚI--------------
select sub_con_sch_seq_no, sub_con_rev_sch_seq_no, last_updated_datetime, alloc_amt_in_bgt_ccy, variance_amt_in_bgt_ccy, *
from pj_trn_alloc_cost
where voucher_no like '%SUB0000699%' and revision_no >= 0 order by revision_no, sub_con_sch_seq_no, sub_con_rev_sch_seq_no;


update pj_trn_alloc_cost set sub_con_rev_sch_seq_no = sub_con_sch_seq_no where voucher_no = 'SUB0000274' and revision_no = 10 and alloc_amt_in_bgt_ccy = 0 and sub_con_rev_sch_seq_no is null;
update pj_trn_alloc_cost set sub_con_sch_seq_no = null where voucher_no = 'SUB0000274' and revision_no = 10 and alloc_amt_in_bgt_ccy = 0 and sub_con_rev_sch_seq_no = sub_con_sch_seq_no;

--------------------------------CORRECT DATA DO LỖI UPDATE PJ_TRN_ALLOC_COST: KHÔNG SUBMIT ĐƯỢC MÀN INVOICE---------------------------------------
--- các cost không được xử lý
select alloc_seq_no, ref_alloc_seq_no
from pj_trn_alloc_cost as cst
where cst.voucher_no = 'SUB0000160'
  and cst.revision_no = 1
  and cst.alloc_seq_no not in (select rev_cst.alloc_seq_no
                               from pj_trn_alloc_cost as rev_cst
                                        left outer join pj_trn_alloc_cost as ost_cst on ost_cst.alloc_seq_no = rev_cst.ref_alloc_seq_no
                               where rev_cst.voucher_no = 'SUB0000160'
                                 and rev_cst.revision_no = 1
                                 and (rev_cst.alloc_amt_in_bgt_ccy <> ost_cst.alloc_amt_in_bgt_ccy
                                   or rev_cst.variance_amt_in_bgt_ccy <> ost_cst.variance_amt_in_bgt_ccy or rev_cst.ref_alloc_seq_no is null));

--- danh sách các trn_det
select trn_det.alloc_seq_no
from Pj_committed_cost_track_trn_det as trn_det
         join Pj_committed_cost_track_trn_hdr as trn_hdr
              on trn_det.project_no = trn_hdr.project_no and trn_det.trn_seq_no = trn_hdr.trn_seq_no and trn_det.no_of_alloc = trn_hdr.no_of_alloc
where trn_hdr.transaction_type_code = 'SUB' and trn_hdr.voucher_no = 'SUB0000160';

--- query correct data
update Pj_committed_cost_track_trn_det as trn_det
set alloc_seq_no = unchanged_cst.alloc_seq_no
from (select alloc_seq_no, ref_alloc_seq_no
      from pj_trn_alloc_cost as cst
      where cst.voucher_no = 'SUB0000160'
        and cst.revision_no = 1
        and cst.alloc_seq_no not in (select rev_cst.alloc_seq_no
                                     from pj_trn_alloc_cost as rev_cst
                                              left outer join pj_trn_alloc_cost as ost_cst on ost_cst.alloc_seq_no = rev_cst.ref_alloc_seq_no
                                     where rev_cst.voucher_no = 'SUB0000160'
                                       and rev_cst.revision_no = 1
                                       and (rev_cst.alloc_amt_in_bgt_ccy <> ost_cst.alloc_amt_in_bgt_ccy
                                         or rev_cst.variance_amt_in_bgt_ccy <> ost_cst.variance_amt_in_bgt_ccy or rev_cst.ref_alloc_seq_no is null))) as unchanged_cst
where unchanged_cst.ref_alloc_seq_no = trn_det.alloc_seq_no;
--- xem lại các trn_det đã được correct
select *
from Pj_committed_cost_track_trn_det as trn_det
         join (select alloc_seq_no, ref_alloc_seq_no
               from pj_trn_alloc_cost as cst
               where cst.voucher_no = 'SUB0000160'
                 and cst.revision_no = 1
                 and cst.alloc_seq_no not in (select rev_cst.alloc_seq_no
                                              from pj_trn_alloc_cost as rev_cst
                                                       left outer join pj_trn_alloc_cost as ost_cst on ost_cst.alloc_seq_no = rev_cst.ref_alloc_seq_no
                                              where rev_cst.voucher_no = 'SUB0000160'
                                                and rev_cst.revision_no = 1
                                                and (rev_cst.alloc_amt_in_bgt_ccy <> ost_cst.alloc_amt_in_bgt_ccy
                                                  or rev_cst.variance_amt_in_bgt_ccy <> ost_cst.variance_amt_in_bgt_ccy or rev_cst.ref_alloc_seq_no is null))) as unchanged_cst
              on trn_det.alloc_seq_no = unchanged_cst.alloc_seq_no
where unchanged_cst.ref_alloc_seq_no = trn_det.alloc_seq_no;
-------------------------
-------------------- CORRECT SUBCON VARIATION SINH THỪA PJ_SUB_CON_PHS_BGT_SCH
-- XÓA Ở REV HIỆN TẠI
select *
from PJ_SUB_CON_PHS_BGT_SCH
where SUB_CON_CONTRACT_NO = 'SUB0000390'
  and seq_no not in (select SUB_CON_SCH_SEQ_NO from pj_trn_alloc_cost where voucher_no = 'SUB0000390' and revision_no = 19);

select *
from pj_sub_clm_phs_bgt_sch
where SOURCE_SEQ_NO in (select seq_no
                        from PJ_SUB_CON_PHS_BGT_SCH
                        where SUB_CON_CONTRACT_NO = 'SUB0000390'
                          and seq_no not in (select SUB_CON_SCH_SEQ_NO from pj_trn_alloc_cost where voucher_no = 'SUB0000390' and revision_no = 19))
order by sub_con_clm_voucher_no, phase_no;

delete
from pj_sub_clm_phs_bgt_sch
where SOURCE_SEQ_NO in (select seq_no
                        from PJ_SUB_CON_PHS_BGT_SCH
                        where SUB_CON_CONTRACT_NO = 'SUB0000390'
                          and seq_no not in (select SUB_CON_SCH_SEQ_NO from pj_trn_alloc_cost where voucher_no = 'SUB0000390' and revision_no = 19));

delete
from PJ_SUB_CON_PHS_BGT_SCH
where SUB_CON_CONTRACT_NO = 'SUB0000390'
  and seq_no in (select seq_no
                 from PJ_SUB_CON_PHS_BGT_SCH
                 where SUB_CON_CONTRACT_NO = 'SUB0000390'
                   and seq_no not in (select SUB_CON_SCH_SEQ_NO from pj_trn_alloc_cost where voucher_no = 'SUB0000390' and revision_no = 19));


--- XÓA Ở REV VARIATION
select cst.sub_con_rev_sch_seq_no, rev_sch.sch_seq_no, rev_sch.phase_no, cst.*
from pj_trn_alloc_cost as cst
         inner join pj_sub_con_rev_phs_bgt_sch as rev_sch on cst.sub_con_rev_sch_seq_no = rev_sch.seq_no
where cst.voucher_no = 'SUB0000390'
  and cst.revision_no = 20
  and cst.sub_con_rev_sch_seq_no is not null
  and rev_sch.revision_no = 20
  and rev_sch.sub_con_contract_no = 'SUB0000390'
order by rev_sch.phase_no;


delete from Pj_trn_alloc_cost where alloc_seq_no = '1393849312' and revision_no = 19 and voucher_no = 'SUB0000390';
delete from Pj_trn_alloc_cost where alloc_seq_no = '1708792242' and revision_no = 19 and voucher_no = 'SUB0000390';
delete from Pj_trn_alloc_cost where alloc_seq_no = '1665730643' and revision_no = 19 and voucher_no = 'SUB0000390';
delete from Pj_trn_alloc_cost where alloc_seq_no = '1772225760' and revision_no = 19 and voucher_no = 'SUB0000390';


select *
from PJ_SUB_CON_REV_PHS_BGT_SCH
where SUB_CON_CONTRACT_NO = 'SUB0000390'
  and revision_no = 20
  and seq_no in (select seq_no
                 from PJ_SUB_CON_REV_PHS_BGT_SCH
                 where SUB_CON_CONTRACT_NO = 'SUB0000390'
                   and revision_no = 20
                   and seq_no not in (select SUB_CON_REV_SCH_SEQ_NO from pj_trn_alloc_cost where voucher_no = 'SUB0000390' and revision_no = 20));

delete
from PJ_SUB_CON_REV_PHS_BGT_SCH
where SUB_CON_CONTRACT_NO = 'SUB0000390'
  and revision_no = 20
  and seq_no in (select seq_no
                 from PJ_SUB_CON_REV_PHS_BGT_SCH
                 where SUB_CON_CONTRACT_NO = 'SUB0000390'
                   and revision_no = 20
                   and seq_no not in (select SUB_CON_REV_SCH_SEQ_NO from pj_trn_alloc_cost where voucher_no = 'SUB0000390' and revision_no = 20));



select binary_file_no, * from attachment_hdr where mt_code_vch_no = 'SUB0000705';

select * from attachment_binary;

select * from attachment_hdr where binary_file_no = 13021;

