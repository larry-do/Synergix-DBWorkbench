update pj_subconbc_new_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
update pj_subconbc_oht_email_setting set email_to = 'larry.do@synergixtech.com', email_cc = 'lavie.pham@synergixtech.com' where sub_con_backcharge_no is not null;
select * from pj_subconbc_oht_email_setting;
select * from pj_subconbc_new_email_setting;

update mt_employee set email_address = 'lavie.pham@synergixtech.com' where employee_code is not null;
select email_address from mt_employee;

delete from attachment_hdr where module_code is not null;
delete from audit_det where audit_id is not null;
delete from audit_hdr where audit_id is not null;
select * from attachment_hdr;
-------------------------------------
select cst.alloc_seq_no, cst.ref_alloc_seq_no, cst.alloc_amt_in_home_ccy
from pj_trn_alloc_cost as cst
where cst.voucher_no = 'SC00000592'
  and cst.revision_no = 2
  and cst.alloc_seq_no not in (select rev_cst.alloc_seq_no
                               from pj_trn_alloc_cost as rev_cst
                                        left outer join pj_trn_alloc_cost as ost_cst on ost_cst.alloc_seq_no = rev_cst.ref_alloc_seq_no
                               where rev_cst.voucher_no = 'SC00000592'
                                 and rev_cst.revision_no = 2
                                 and (rev_cst.alloc_amt_in_bgt_ccy <> ost_cst.alloc_amt_in_bgt_ccy
                                   or rev_cst.variance_amt_in_bgt_ccy <> ost_cst.variance_amt_in_bgt_ccy or rev_cst.ref_alloc_seq_no is null));

select trn_det.*
from Pj_committed_cost_track_trn_det as trn_det
         join (select cst.alloc_seq_no, cst.ref_alloc_seq_no
               from pj_trn_alloc_cost as cst
               where cst.voucher_no = 'SC00000592'
                 and cst.revision_no = 1
                 and cst.alloc_seq_no not in (select rev_cst.alloc_seq_no
                                              from pj_trn_alloc_cost as rev_cst
                                                       left outer join pj_trn_alloc_cost as ost_cst on ost_cst.alloc_seq_no = rev_cst.ref_alloc_seq_no
                                              where rev_cst.voucher_no = 'SC00000592'
                                                and rev_cst.revision_no = 1
                                                and (rev_cst.alloc_amt_in_bgt_ccy <> ost_cst.alloc_amt_in_bgt_ccy
                                                  or rev_cst.variance_amt_in_bgt_ccy <> ost_cst.variance_amt_in_bgt_ccy or rev_cst.ref_alloc_seq_no is null))) as unchanged_cst
              on trn_det.alloc_seq_no = unchanged_cst.ref_alloc_seq_no;

update Pj_committed_cost_track_trn_det as trn_det
set alloc_seq_no = unchanged_cst.alloc_seq_no
from (select cst.alloc_seq_no, cst.ref_alloc_seq_no
      from pj_trn_alloc_cost as cst
      where cst.voucher_no = 'SC00000592'
        and cst.revision_no = 1
        and cst.alloc_seq_no not in (select rev_cst.alloc_seq_no
                                     from pj_trn_alloc_cost as rev_cst
                                              left outer join pj_trn_alloc_cost as ost_cst on ost_cst.alloc_seq_no = rev_cst.ref_alloc_seq_no
                                     where rev_cst.voucher_no = 'SC00000592'
                                       and rev_cst.revision_no = 1
                                       and (rev_cst.alloc_amt_in_bgt_ccy <> ost_cst.alloc_amt_in_bgt_ccy
                                         or rev_cst.variance_amt_in_bgt_ccy <> ost_cst.variance_amt_in_bgt_ccy or rev_cst.ref_alloc_seq_no is null))) as unchanged_cst
where trn_det.alloc_seq_no = unchanged_cst.ref_alloc_seq_no;

select trn_det.alloc_seq_no
from Pj_committed_cost_track_trn_det as trn_det
         join Pj_committed_cost_track_trn_hdr as trn_hdr
              on trn_det.project_no = trn_hdr.project_no and trn_det.trn_seq_no = trn_hdr.trn_seq_no and trn_det.no_of_alloc = trn_hdr.no_of_alloc
where trn_hdr.transaction_type_code = 'SUB' and trn_hdr.voucher_no = 'SC00000280';

--------- AUTO CORRECT
-- danh sách các sub con đã variate với rev thấp nhất (dùng để tự động correct)
select sub.sub_con_contract_no, min(sub.revision_no) as revision_no
from (
         select sub_con_contract_no, revision_no
         from pj_sub_con_rev_hdr
         where variation_datetime >= '2021-08-28 00:00:00'
           and variation_datetime <= '2021-09-28 00:00:00'
         union
         select sub_con_contract_no, revision_no
         from pj_sub_con_hdr
         where variation_datetime >= '2021-08-28 00:00:00'
           and variation_datetime <= '2021-09-28 00:00:00'
     ) as sub
group by sub.sub_con_contract_no
order by sub.sub_con_contract_no;

--  danh sách các sub con đã variate với rev sau đó (dùng để correct bằng tay). Sau khi chạy correct tự động rồi mới chạy correct = tay
select sub.sub_con_contract_no, sub.revision_no
from (
         select sub_con_contract_no, revision_no
         from pj_sub_con_rev_hdr
         where variation_datetime >= '2021-08-28 00:00:00'
           and variation_datetime <= '2021-09-28 00:00:00'
         union
         select sub_con_contract_no, revision_no
         from pj_sub_con_hdr
         where variation_datetime >= '2021-08-28 00:00:00'
           and variation_datetime <= '2021-09-28 00:00:00'
     ) as sub
where (sub.sub_con_contract_no, sub.revision_no) not in (select sub.sub_con_contract_no, min(sub.revision_no) as revision_no
                                                         from (
                                                                  select sub_con_contract_no, revision_no
                                                                  from pj_sub_con_rev_hdr
                                                                  where variation_datetime >= '2021-08-28 00:00:00'
                                                                    and variation_datetime <= '2021-09-28 00:00:00'
                                                                  union
                                                                  select sub_con_contract_no, revision_no
                                                                  from pj_sub_con_hdr
                                                                  where variation_datetime >= '2021-08-28 00:00:00'
                                                                    and variation_datetime <= '2021-09-28 00:00:00'
                                                              ) as sub
                                                         group by sub.sub_con_contract_no
                                                         order by sub.sub_con_contract_no)
order by sub.sub_con_contract_no;

-- danh sách các trn_det thay đổi (dùng để backup)
select *
from Pj_committed_cost_track_trn_det as trn_det
         inner join (select alloc_seq_no, ref_alloc_seq_no
                     from pj_trn_alloc_cost as cst
                              inner join (select sub.sub_con_contract_no, min(sub.revision_no) as revision_no
                                          from (
                                                   select sub_con_contract_no, revision_no
                                                   from pj_sub_con_rev_hdr
                                                   where variation_datetime >= '2021-08-28 00:00:00'
                                                     and variation_datetime <= '2021-09-28 00:00:00'
                                                   union
                                                   select sub_con_contract_no, revision_no
                                                   from pj_sub_con_hdr
                                                   where variation_datetime >= '2021-08-28 00:00:00'
                                                     and variation_datetime <= '2021-09-28 00:00:00'
                                               ) as sub
                                          group by sub.sub_con_contract_no
                                          order by sub.sub_con_contract_no) as variated_subcon
                                         on cst.voucher_no = variated_subcon.sub_con_contract_no and cst.revision_no = variated_subcon.revision_no
                     where cst.alloc_seq_no not in (select rev_cst.alloc_seq_no
                                                    from pj_trn_alloc_cost as rev_cst
                                                             left outer join pj_trn_alloc_cost as ost_cst on ost_cst.alloc_seq_no = rev_cst.ref_alloc_seq_no
                                                    where rev_cst.voucher_no = variated_subcon.sub_con_contract_no
                                                      and rev_cst.revision_no = variated_subcon.revision_no
                                                      and (rev_cst.alloc_amt_in_bgt_ccy <> ost_cst.alloc_amt_in_bgt_ccy
                                                        or rev_cst.variance_amt_in_bgt_ccy <> ost_cst.variance_amt_in_bgt_ccy or
                                                           rev_cst.ref_alloc_seq_no is null))) as unchanged_cst
                    on trn_det.alloc_seq_no = unchanged_cst.ref_alloc_seq_no;

-- correct tự động sql
update Pj_committed_cost_track_trn_det as trn_det
set alloc_seq_no = unchanged_cst.alloc_seq_no
from (select alloc_seq_no, ref_alloc_seq_no
      from pj_trn_alloc_cost as cst
               inner join (select sub.sub_con_contract_no, min(sub.revision_no) as revision_no
                           from (
                                    select sub_con_contract_no, revision_no
                                    from pj_sub_con_rev_hdr
                                    where variation_datetime >= '2021-08-28 00:00:00'
                                      and variation_datetime <= '2021-09-28 00:00:00'
                                    union
                                    select sub_con_contract_no, revision_no
                                    from pj_sub_con_hdr
                                    where variation_datetime >= '2021-08-28 00:00:00'
                                      and variation_datetime <= '2021-09-28 00:00:00'
                                ) as sub
                           group by sub.sub_con_contract_no
                           order by sub.sub_con_contract_no) as variated_subcon
                          on cst.voucher_no = variated_subcon.sub_con_contract_no and cst.revision_no = variated_subcon.revision_no
      where cst.alloc_seq_no not in (select rev_cst.alloc_seq_no
                                     from pj_trn_alloc_cost as rev_cst
                                              left outer join pj_trn_alloc_cost as ost_cst on ost_cst.alloc_seq_no = rev_cst.ref_alloc_seq_no
                                     where rev_cst.voucher_no = variated_subcon.sub_con_contract_no
                                       and rev_cst.revision_no = variated_subcon.revision_no
                                       and (rev_cst.alloc_amt_in_bgt_ccy <> ost_cst.alloc_amt_in_bgt_ccy
                                         or rev_cst.variance_amt_in_bgt_ccy <> ost_cst.variance_amt_in_bgt_ccy or rev_cst.ref_alloc_seq_no is null))) as unchanged_cst
where trn_det.alloc_seq_no = unchanged_cst.ref_alloc_seq_no;