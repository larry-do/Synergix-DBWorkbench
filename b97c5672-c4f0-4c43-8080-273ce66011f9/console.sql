select back_charge_claimed_qty, back_charge_claimed_amt, back_charge_claimed_home_amt, *
from Pj_sub_con_back_charge
where sub_con_contract_no = 'SCC0000027';

select qty, total_amt, total_home_amt, * from pj_sub_clm_back_charge where sub_con_clm_voucher_no = 'SCL0000042' and source_seq_no = '304';

select * from pj_ap_inv_ost_hdr;