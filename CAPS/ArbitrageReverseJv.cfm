<cfinclude template="/focaps/help.cfm">
<HTML>
<HEAD>
<TITLE>ARBITRAGE REVERSE JV</TITLE>
<LINK href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
<LINK href="../../CSS/style1.css" rel="stylesheet" type="text/css">
</HEAD>
<CFOUTPUT>
<SCRIPT SRC="../../DatePicker.js"  TYPE="text/javascript"></SCRIPT>
#DateFunctionList('MonthlyProcess','txtDate')#
<BODY CLASS="StyleBody">

<DIV STYLE="top:0%;LEFT:0;width:100%;height:50%;position:absolute;overflow:auto;z-index:-1;" >
<CFIF IsDefined("Process1")>
	<CFTRY>
		<CFSTOREDPROC PROCEDURE="FO_EXPIRYPROCESS_ARB" DATASOURCE="#Client.Database#">
				<CFPROCPARAM TYPE="in" CFSQLTYPE="cf_sql_varchar" DBVARNAME="@COMPANY_CODE" VALUE="#Trim(COCD)#" NULL="NO">
				<CFPROCPARAM TYPE="in" CFSQLTYPE="cf_sql_varchar" DBVARNAME="@TRADE_DATE" VALUE="#txtDate#" NULL="NO">
				<CFPROCPARAM TYPE="in" CFSQLTYPE="cf_sql_varchar" DBVARNAME="@BRANCH_CODE" VALUE="#txtBranch#" NULL="NO">
				<CFPROCPARAM TYPE="in" CFSQLTYPE="cf_sql_varchar" DBVARNAME="@FAMILY_GROUP_LIST" VALUE="#txtBranch#" NULL="NO">
				<CFPROCPARAM TYPE="in" CFSQLTYPE="cf_sql_varchar" DBVARNAME="@LEDGER_LIST" VALUE="#ClientCode#" NULL="NO">
				<CFPROCRESULT NAME="ContData">
		</CFSTOREDPROC>
		<Cfif IsDefined("ContData")>
				<DIV STYLE="top:50%;LEFT:0;width:100%;height:50%;position:absolute;overflow:auto;z-index:-1;" >
					<TABLE CLASS="StyleCommonMastersTable" BORDER="1">
						<TR>
							<TD WIDTH="25%">
								Client Id
							</TD>
							<TD WIDTH="25%">
								Dr Amt
							</TD>
							<TD WIDTH="25%">
								Cr Amt
							</TD>
							<TD WIDTH="25%">
								Voucher
							</TD>
						</TR>
						<CFLOOP QUERY="ContData">
							<TR>
								<TD>
									#CLIENT_ID#
								</TD>
								<TD>
									#DEBIT_AMT#
								</TD>
								<TD>
									#CREDIT_AMT#
								</TD>
								<TD>
									#VNO#
								</TD>
							</TR>
						</CFLOOP>
					</TABLE>
				</DIV>
		</Cfif>
		
	<CFCATCH type="database">
		<script>alert("\nError:\n#cfcatch.detail#")</script>
	</CFCATCH>
	</CFTRY>
</CFIF>

</DIV>
	<FORM NAME="MonthlyProcess" ACTION="ArbitrageReverseJv.cfm" METHOD="POST">
		<INPUT type="Hidden" name="COCD" value="#COCD#">
		<INPUT type="Hidden" name="Process1" value="">
		<INPUT type="Hidden" name="COName" value="#COName#">
		<INPUT type="Hidden" name="Market" value="#Market#">
		<INPUT type="Hidden" name="Exchange" value="#Exchange#">
		<INPUT type="Hidden" name="StYr" value="#Val(Trim(StYr))#">
		<INPUT type="Hidden" name="EndYr" value="#Val(Trim(EndYr))#">
		<TABLE WIDTH="100%" BORDER="0">
			<tr>
				<td  ALIGN="CENTER" CLASS="blue-head" COLSPAN="10" WIDTH="100%">
					<u>Arbitrage Reverse JV</u>
				</td>
			</tr>
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Date:</TD>
				<TD ALIGN="left" COLSPAN="1">
					<INPUT type="Text" name="txtDate" VALUE="#DateFormat(now(),"DD/MM/YYYY")#"  message="Date is required in the format: DD/MM/YYYY" validate="eurodate" required="Yes" size="10" maxlength="10" tabindex="3" class="StyleTextBox">
				&nbsp;<INPUT TYPE="button" VALUE="V" CLASS="StyleButton1" onClick="fPopCalendar(this.form.txtDate, this.form.txtDate);return false">

				</TD>
			</TR>
		<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Branch Code:</TD>			
				
				<TD ALIGN="left" WIDTH="*" COLSPAN="1">
					<Cfset Help = "Select Branch_code,Branch_Name,MAIN_BRANCH_CODE From Branch_master	">
					<TEXTAREA COLS="30" ROWS="3" NAME="txtBranch" CLASS="StyleTextBox"></TEXTAREA>
					<INPUT TYPE="Button" NAME="cmdFamilyHelp" VALUE=" ? " CLASS="StyleSmallButton1" 
							OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtBranch&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
				</TD>
			</TR>
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Family Group:</TD>
				
				<TD ALIGN="left">
					<Cfset Help = "select RTrim(Ltrim(GroupCode)) GroupCode,Groupname from familymaster order by GroupCode">
					<TEXTAREA COLS="30" ROWS="3" NAME="txtFamily" CLASS="StyleTextBox"></TEXTAREA>
					<INPUT TYPE="Button" NAME="cmdClientHelp" VALUE=" ? " CLASS="StyleSmallButton1"
						OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtFamily&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">				
				</TD>
			</TR> 
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Client List:</TD>
				
				<TD ALIGN="left" COLSPAN="1">
					<Cfset Help = "select Distinct client_id,client_name from client_detail_view  where mobile_no is not null">
					<TEXTAREA COLS="30" ROWS="3" NAME="ClientCode" CLASS="StyleTextBox"></TEXTAREA>
					<INPUT TYPE="Button" NAME="cmdClientHelp" VALUE=" ? " CLASS="StyleSmallButton1"
						OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=ClientCode&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">				
				</TD>
			</TR> 
			<tr>
				<td  ALIGN="CENTER" COLSPAN="10" WIDTH="100%" CLASS="clsLabel">
					<INPUT TYPE="BUTTON" VALUE="Process" NAME="Process" CLASS="StyleSmallButton1" onClick="this.disabled=true;this.form.Process1.value=1;this.form.submit();">
				</td>
			</tr>
		</TABLE>
	</FORM>
</BODY>
</CFOUTPUT>

</HTML>
