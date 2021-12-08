INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, description, URL, MODULE_CODE, VERSION_NO,
                         IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_ORDER_FUTAR', 'Project Order', 'Futar', '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, description, URL, MODULE_CODE, VERSION_NO,
                         IMPLEMENTED_STATUS, IS_MOBILE)
VALUES ('TH6_PJ_PROJECT_CLAIM_FUTAR', 'Project Claim', 'Futar', '', 'PJ', 6, 'I', 'N');

UPDATE form_master SET form_name = 'Project Claim' where form_code = 'TH6_PJ_PROJECT_CLAIM_FUTAR';

INSERT INTO FORM_MASTER (FORM_CODE, DESCRIPTION, FORM_NAME, URL, IMPLEMENTED_STATUS, VERSION_NO, MODULE_CODE,TRANSACTION_TYPE_CODE, OBJECT_VERSION, IS_MOBILE, CREATED_BY, FORM_SET_CODE)
VALUES ('TH6_STOCK_ISSUE_PROJECT_MULTI_PMR_FUTAR', 'Futar', 'Project Stock Issue', '', 'I', 6, 'LG', 'STOCKISSUE', 0, 'N', 'Andrey', 'PJ_STOCK_ISSUE');

select * from sys_form_set;

insert into mt_email_alert_config(module_code, transaction_type_code, config_code, email_template,
                                  email_content_include, config_desc, is_active)
values ('PJ', 'BGT', 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL',
        'ALERT: BUDGET_THRESHOLD% BUDGET THRESHOLD HAS REACHED - PROJECT_NO',
        'project_no=true,project_name=true,customer_name=true,customer_job_no=true,budget_schedule_no=false,budget_schedule_desc=true,budget_category=true,budget_cost=true,committed_cost=true,actual_cost=true,total_cost=true,total_cost_usage=true',
        '100.0', 'N');

select *
from mt_email_alert_config where config_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL';

select *
from mt_sys_email_template where email_template_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL';

--delete from mt_sys_email_template where email_template_code = 'AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL';

insert into mt_sys_email_template(email_template_code, module_code, transaction_type_code, subject, body, created_by)
values ('AUTO_SEND_BUDGET_ALERT_THRESHOLD_EMAIL', 'PJ', 'BGT', 'ALERT: $budget_threshold% BUDGET THRESHOLD HAS REACHED - $project_no',
        '<div style="font-family: arial,serif; font-size: 1.1em;">
	<p>Dear $employee_short_name,</p>

	#if($email_additional_contents.contains(''project_no''))<span style="margin-bottom: 3px;"><span style="min-width: 150px; max-width: 150px; width: 150px; display: inline-block;">Project No.</span>: #if($project_no) $project_no #end</span> <br/> #end
	#if($email_additional_contents.contains(''project_name''))<span style="margin-bottom: 3px;"><span style="min-width: 150px; max-width: 150px; width: 150px; display: inline-block;">Project Name</span>: #if($project_name) $project_name #end</span> <br/> #end
	#if($email_additional_contents.contains(''customer_name''))<span style="margin-bottom: 3px;"><span style="min-width: 150px; max-width: 150px; width: 150px; display: inline-block;">Customer Name</span>: #if($customer_name) $customer_name #end</span> <br/> #end
	#if($email_additional_contents.contains(''customer_job_no''))<span style="margin-bottom: 3px;"><span style="min-width: 150px; max-width: 150px; width: 150px; display: inline-block;">Customer Job No.</span>: #if($customer_job_no) $customer_job_no #end</span> <br/> #end
	<br/>
	Cost Allocation from the items below has reached the $budget_threshold% budget alert threshold:
	<br/> <br/>
	<table border="1 solid black;" style="border-collapse: collapse; font-size: 1em;">
		<thead>
		#if($email_additional_contents.contains(''budget_schedule_no''))<th style="text-align: center;">Budget Schedule No.</th> #end
		#if($email_additional_contents.contains(''budget_schedule_desc''))<th style="text-align: left;">Budget Schedule Desc</th> #end
		#if($email_additional_contents.contains(''budget_category''))<th style="text-align: left;">Budget Category</th> #end
		#if($email_additional_contents.contains(''budget_cost''))<th style="text-align: left;">Budget Cost</th> #end
		#if($email_additional_contents.contains(''committed_cost''))<th style="text-align: left;">Committed Cost</th> #end
		#if($email_additional_contents.contains(''actual_cost''))<th style="text-align: left;">Actual Cost</th> #end
		#if($email_additional_contents.contains(''total_cost''))<th style="text-align: left;">Total Cost</th> #end
		#if($email_additional_contents.contains(''total_cost_usage''))<th style="text-align: left;">Total Cost Usage %</th> #end
		</thead>
		<tbody>
		#foreach($row in $ost_sches)
			<tr>
				#if($email_additional_contents.contains(''budget_schedule_no''))<td>#if($row.sch_seq_no) $row.sch_seq_no #end</td> #end
				#if($email_additional_contents.contains(''budget_schedule_desc''))<td>#if($row.sch_desc) $row.sch_desc #end</td> #end
				#if($email_additional_contents.contains(''budget_category''))<td>#if($row.mtBudgetCategory.budget_category_desc) $row.mtBudgetCategory.budget_category_desc #end</td> #end
				#if($email_additional_contents.contains(''budget_cost''))<td>$row.budget_cost_in_home_ccy</td> #end
				#if($email_additional_contents.contains(''committed_cost''))<td>$row.cost_yet_to_receive_in_home_ccy</td> #end
				#if($email_additional_contents.contains(''actual_cost''))<td>$row.actual_cost_in_home_ccy</td> #end
				#if($email_additional_contents.contains(''total_cost''))<td>$row.getTotalCost()</td> #end
				#if($email_additional_contents.contains(''total_cost_usage''))<td>$row.getTotalCostUsage()</td> #end
			</tr>
		#end
		</tbody>
	</table>

	<br/>
	<span style="margin-bottom: 3px;">NOTE: All the amounts are shown in HOME CURRENCY.</span> <br/>
	<span>[This is an automated email. No reply is required.]</span>
</div>', null);


update MT_EMAIL_ALERT_CONFIG set IS_ACTIVE = 'Y' where MODULE_CODE = 'PJ' and TRANSACTION_TYPE_CODE = 'SCL' and  CONFIG_CODE = 'ALERT_SUB_CLAIM_CERTIFIED';

INSERT INTO MT_EMAIL_ALERT_CONFIG (MODULE_CODE, TRANSACTION_TYPE_CODE, CONFIG_CODE, EMAIL_ALERT_JOB_CLASS, CONFIG_DESC, CONFIG_HINT, SEND_OPTIONS, SEND_EMAIL_LIST, SEND_DESC, ALERT_TYPE, ALERT_TIME, ALERT_HOUR, EMAIL_TEMPLATE, GLOBAL_UPDATE_DATETIME, IS_ACTIVE)
 VALUES ('PJ', 'SCL', 'INCLUDE_ATTACHMENT_CERTIFIED_CLAIM', NULL, '', '', 'ACC=true', NULL, 'include_attachment_certified_claim', 'N', NULL, NULL, '', NULL, 'Y');

INSERT INTO MT_EMAIL_ALERT_CONFIG (MODULE_CODE, TRANSACTION_TYPE_CODE, CONFIG_CODE, EMAIL_ALERT_JOB_CLASS, CONFIG_DESC, CONFIG_HINT, SEND_OPTIONS, SEND_EMAIL_LIST, SEND_DESC, ALERT_TYPE, ALERT_TIME, ALERT_HOUR, EMAIL_TEMPLATE, GLOBAL_UPDATE_DATETIME) VALUES ('PJ', 'SCL', 'CLAIM_APPROVAL_TIME_LIMIT', 'emailAlertSubcontractorClaim', 'claim_approval_time_limit', NULL, '', NULL, 'claim_approval_time_limit', 'D', TIME '12:00:00', NULL, '/faces/global_setup/global_config/email_alert_configuration/AlertClaimApprovalTemplate.xhtml', NULL);

-----------------
select *
from sys_dashpane
where dashpane_code = 'TH6_PJ_SALES_AMT_HIT_RATE_BY_SALES_MANAGER';

insert into sys_dashpane(dashpane_code, dashpane_desc, dashpane_title, module_code, prefered_width, prefered_height)
values ('TH6_PJ_SALES_AMT_HIT_RATE_BY_SALES_MANAGER',
        'Display the total amount of quotations that are failed, confirmed and outstanding within the selected financial year & period (by sales manager and in home currency).',
        'proj_sales_amt_hit_rate_by_sales_manager', 'PJ', 1, 1);
-------------------

------------
INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_CONSTRUCTION_TEMPLATE', 'Project Construction Template', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_CONSTRUCTION_DETAILS', 'Project Construction Details', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_SAFETY_TEMPLATE', 'Project Safety Template', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_SAFETY_DETAILS', 'Project Safety Details', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_OVERVIEW_TEMPLATE', 'Project Overview Template', null, '', 'PJ', 6, 'I', 'N');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_OVERVIEW_DETAILS', 'Project Overview Details', null, '', 'PJ', 6, 'I', 'N');
-------------

select * from mt_employee_glbl where lower(employee_short_name) like '%zhao%';

select * from MT_SYS_EMAIL_TEMPLATE where EMAIL_TEMPLATE_CODE = 'SUBCON_CLAIM_CERTIFIED_EMAIL';

delete from MT_SYS_EMAIL_TEMPLATE where EMAIL_TEMPLATE_CODE = 'SUBCON_CLAIM_CERTIFIED_EMAIL';

INSERT INTO MT_SYS_EMAIL_TEMPLATE (EMAIL_TEMPLATE_CODE, MODULE_CODE, TRANSACTION_TYPE_CODE, SUBJECT, BODY) VALUES ('SUBCON_CLAIM_CERTIFIED_EMAIL', 'PJ', 'SCL', 'Your Claim has been certified by ${companyName}',
'#if ($companyLogo)
<img src="data:image/${mimetype};base64, ${companyLogo}" alt="logo" border="no"
				width="200px" height="60px" />
#end
<div style="font-family: Arial, Helvetica Neue, Helvetica, sans-serif; font-size: 14px;">
	Dear Sir/Madam, <br/>
	Your Claim No. ${claimSeqNo} for Contract ${letterOfAwardNo}${subConContractNo} has been certified.<br/>
	Please find attached our Payment Response for invoicing.<br/>
	Please quote our Certificate Number in your tax invoice.<br/><br/><br/>


	Thank you<br/>
	${signOff} <br/>
	[This is an automated email. No reply is required]
</div>');

INSERT INTO FORM_MASTER (FORM_CODE, FORM_NAME, DESCRIPTION, URL, MODULE_CODE, VERSION_NO, IMPLEMENTED_STATUS, IS_MOBILE) VALUES ('TH6_PJ_PROJECT_RECOGNITION_OBAYASHI', 'Project Recognition', 'Obayashi', '', 'PJ', 6, 'I', 'N');

select * from sys_config where properties_name = 'enableSubcontractorinProjectBudget';

select * from sys_config where properties_name = 'defaultMaxLengthOfCode';

select * from global_config where property_name = 'defaultMaxLengthOfCode';

select * from sys_config where properties_name = 'synergixCustomer';


--------------------- AO SHEET SUMMARY REPORT--------------------------------
select * from form_master where form_code = 'TH5R_PJ_700906';
select * from rpt_main where rpt_key = 'TH5R_PJ_700906';
select * from jrpt_parameter where rpt_code = 'TH5R_PJ_700906';

INSERT INTO form_master(form_code,form_name,url,implemented_status,remarks,is_customized,module_code,transaction_type_code,version_no,is_mobile,created_by) VALUES ('TH5R_PJ_700906','AO Sheet Summary Report (Obayashi)','RPT_KEY=TH5R_PJ_700906','I',NULL,NULL,'PJ',NULL,5,'N','Larry');

INSERT INTO MT_MENU_MASTER(MENU_CODE, MENU_DESC, MENU_TYPE, PARENT_MENU_CODE, MENU_LEVEL, FORM_CODE, EVENT_TYPE, MENU_ACTION_TYPE, CREATED_BY) VALUES ('TH5R_PJ_700906', 'AO Sheet Summary Report (Obayashi)', 'C', '0910102', 3, 'TH5R_PJ_700906', 'S', 'O', 'Larry');
INSERT INTO rpt_main(rpt_key,rpt_title,rpt_type,rpt_category,rpt_module,rpt_provider,rpt_version,rpt_release_date,rpt_desc,rpt_url,rpt_6_url,rpt_workspace,rpt_datasource,rpt_user_filter_field,rpt_user_filter,rpt_user_filter_desc,rpt_count,rpt_location,rpt_order_by_exist,data_column_support,data_filtering_support,data_sorting_support,data_grouping_support,is_main_db,dynamic_crosstab_row,dynamic_crosstab_column,reposition_after_hide_column,default_max_result_size,jasper_jdbc_fetch_size,excel_white_page_background,ignore_cell_background,remove_blank_rows_excel,sbu_column_name,created_by_column_name,default_export_format,supported_format) VALUES('TH5R_PJ_700906','AO Sheet Summary Report (Obayashi)','C','R','PJ','JR','1',TIMESTAMP '2021-03-09 00:00:00.000','AO Sheet Summary Report (Excel) (Obayashi)','AO Sheet Summary Report','','','','','','',1,'Report\Obayashi\PJ\AO_REPORT\AO_Sheet_Summary_Report.jrxml','Y','N','N','N','N','Y','N','N','Y',0,0,'N','N','N','SBU_CODE','CREATED_BY','XLSX','EXCEL,XLSX');
INSERT INTO JRPT_PARAMETER(rpt_code,parameter_name,parameter_desc,data_type,lookup_code,lookup_type,is_required,is_primary,value_domain,parameter_order,is_composite_key,is_primary_key,parent_paramater,entity_constraint,entity_field_name,is_read_only,auto_default_employee,is_hidden,default_value,data_constraint,input_field_width) VALUES ('TH5R_PJ_700906','PROJECT_NO','Project No','STRING','PjSearchServiceFactory.ProjectOstHstSearch','S','N','N','',1,'N','Y',NULL,'main.pj.Pj_est_ost_hdr',NULL,'N','N','N',NULL,NULL,120);
INSERT INTO JRPT_PARAMETER (RPT_CODE, PARAMETER_NAME, PARAMETER_DESC, DATA_TYPE, LOOKUP_CODE, LOOKUP_TYPE, IS_REQUIRED, IS_PRIMARY, VALUE_DOMAIN, PARAMETER_ORDER, IS_COMPOSITE_KEY, IS_PRIMARY_KEY, ENTITY_CONSTRAINT, IS_READ_ONLY, AUTO_DEFAULT_EMPLOYEE, IS_HIDDEN, INPUT_FIELD_WIDTH, OBJECT_VERSION) VALUES ('TH5R_PJ_700906', 'FINANCIAL_YEAR', 'Financial Year', 'INTEGER', 'main.mt.Mt_financial_year', 'S', 'Y', 'N', '', 2, 'N', 'Y', 'main.mt.Mt_financial_year', 'N', 'N', 'N', 120, 0);
INSERT INTO JRPT_PARAMETER (RPT_CODE, PARAMETER_NAME, PARAMETER_DESC, DATA_TYPE, LOOKUP_CODE, LOOKUP_TYPE, IS_REQUIRED, IS_PRIMARY, PARAMETER_ORDER, IS_COMPOSITE_KEY, IS_PRIMARY_KEY, ENTITY_CONSTRAINT, IS_READ_ONLY, AUTO_DEFAULT_EMPLOYEE, IS_HIDDEN, INPUT_FIELD_WIDTH, OBJECT_VERSION) VALUES ('TH5R_PJ_700906', 'FINANCIAL_PERIOD', 'Financial Period', 'INTEGER', 'main.mt.Mt_financial_period', 'S', 'Y', 'N', 3, 'N', 'Y', '', 'N', 'N', 'N', 120, 0);

---------------------END AO SHEET SUMMARY REPORT--------------------------------

select * from Mt_email_alert_config;

