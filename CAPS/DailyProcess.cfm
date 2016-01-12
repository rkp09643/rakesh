<cfinclude template="/focaps/help.cfm">

<cfif NOT DirectoryExists("C:\CFUSIONMX7\WWWROOT\REPORTS\Interest")>
<cfdirectory action="create" directory="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest">
</cfif>
<HTML>
<HEAD>
<TITLE>Weekly Process</TITLE>
<LINK href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
<LINK href="../../CSS/style1.css" rel="stylesheet" type="text/css">
</HEAD>
<CFOUTPUT>
<BODY CLASS="StyleBody">
<DIV STYLE="top:64%;LEFT:0%;width:35%;height:36%;position:absolute;overflow:auto" >
<TABLE CLASS="StyleCommonMastersTable">
	<tr>
		<td >
			<U><i>*Weekly Process Description.</i></U>
		</td>
	</tr>
	<tr>
		<td >
			1. For Interest Calculation <FONT COLOR="red"> <U>DailyInterst</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			2. In Interest Calculation Only Debit Interest Consider
		</td>
	</tr>
	<tr>
		<td >
			3. Interest Rate Defien In Client Master(Other Then Zero)
		</td>
	</tr>
	<tr>
		<td >
			4. Must Defiend Interest Rate And Interest Chatre In Branch Master
		</td>
	</tr>
	<tr>
		<td >
			5. Branch Master Interest Or Client Master Interest Depending On System Settings
		</td>
	</tr>
	<tr>
		<td >
			6. For Interest Calculation Daily <FONT COLOR="red"> <U>DailyInterst</U></FONT> Account Required In Fa
		</td>
	</tr>
</TABLE>
</DIV>

<DIV STYLE="top:0%;LEFT:0;width:80%;height:50%;position:absolute;overflow:auto;z-index:-1" >
<CFIF IsDefined("Process1") and Process1 eq 1>
		<Cfif not IsDefined("COMPANY_LIST")>
				<script>
					alert('Please Select Atleast One Company');
					history.back();
				</script>
				<cfabort>
		</Cfif>
		<CFSET FROMDATE =  txtDate>
		<CFSET TODATE =  txtDate>
		<Cfif ProcessType eq 'P'>
				<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
					SELECT * FROM COMPANY_MASTER
				</CFQUERY>
				<cfloop query="INSERT">
				<CFQUERY name= "GetAccount" datasource="#Client.database#">
					EXEC [FACLIENT_CREATION] 'CREATE DIRECT ACCOUNT','#COMPANY_CODE#','DailyInterst','DailyInterst','#COMPANY_CODE#', #StYr#,#EndYr#
				</CFQUERY>
				</cfloop>
					<CFQUERY name= "GetAccount" datasource="#Client.database#">
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'DailyInterst'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create (DailyInterst) Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					<cfparam default="N" name="IncluShortMargin">
					<cfparam default="N" name="CLType">
					<CFSET TOKENVAR = "#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
					<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
						EXEC [FA_INTERESTCAL#type#] '#FROMDATE#','#TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#','N','N','Y','Y',12,'#AssociateAc#','N',0,0,#val(Debit_Day)#,#val(CrEdit_Day)#,1
						,'#IncluShortMargin#',0,#TOKENVAR#
						,'D','','',0,#val(FODebit_Day)#,#val(FOCrEdit_Day)#,'#CLType#','P'
					</CFQUERY>
					<CFQUERY NAME="Q1" datasource="#Client.database#" DBTYPE="ODBC">
						SELECT COCD,ACCOUNTCODE,MAX(AccountName) AccountName,
						SUM(DRINTEREST) DRINTEREST,SUM(CRINTEREST) CRINTEREST,
						SUM(DRINTEREST-CRINTEREST) NETINTEREST,
						max(INTERESTRATE) INTERESTRATE,
						CAST('' AS VARCHAR(100)) AS POSTCOCD
						FROM ####FAINTEREST
						GROUP BY COCD,ACCOUNTCODE
						ORDER BY ACCOUNTCODE
					</CFQUERY>
					<cfsavecontent variable="FileText">
						User:#CLIENT.USERNAME#-#CLIENT.CLIENTIPADD#
						EXEC [FA_INTERESTCAL] '#FROMDATE#','#TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#','N','N','Y','Y',12,'N','N',0,0,#val(Debit_Day)#,#val(CrEdit_Day)#,1
						,'#IncluShortMargin#',0,#TOKENVAR#
						,'W'
							<cfdump var="#Q1#">
					</cfsavecontent>
					<cfif IsDefined("FileText")>
						<cfif NOT DirectoryExists("C:\CFUSIONMX7\WWWROOT\REPORTS\Interest")>
							<cfdirectory action="create" directory="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest">
						</cfif>
						<cffile action="write" file="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest\Interest_Globle_Daily_#dateformat(now(),'DDMMYYYY')#_#timeformat(now(),'HHMM')#.HTML"  output="#FileText#">
					</cfif>
					
					<cftry>
					
					<CFQUERY NAME="POSTINGJV" datasource="#Client.database#">
						EXEC FA_INTEREST_POSTINGDATA '#TOKENVAR#','','#FROMDATE#','#TODATE#',#val(MaxAmount)#,#StYr#,'#REMOTE_ADDR#','#Ucase(CLIENT.UserName)#','D'
					</CFQUERY>
					
					<cfcatch>
						Error: Error While Processing #Cfcatch.Message#-#cfcatch.Detail#
					</cfcatch>
					</cftry>
					Process Completed............
			<CFELSE>	
					<cFSET FileText ="Process Cancle For '#FROMDATE#','#TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#','1312'
								User:#CLIENT.USERNAME#-#CLIENT.CLIENTIPADD#">
					<cfif IsDefined("FileText")>
						<cfif NOT DirectoryExists("C:\CFUSIONMX7\WWWROOT\REPORTS\Interest")>
							<cfdirectory action="create" directory="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest">
						</cfif>
						<cffile action="write" file="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest\Can_Interest_Globle_Monthly_#dateformat(now(),'DDMMYYYY')#_#timeformat(now(),'HHMM')#.HTML"  output="#FileText#">
					</cfif>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
 						EXEC [FA_INTERESTCAL_DELETEJV] '#FROMDATE#','#TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#','1312'
					</CFQUERY>
		</CFIF>
		<cfabort>
</CFIF>
</DIV>
	<FORM NAME="WeeklyProcess" ACTION="DailyProcess.cfm" METHOD="POST">
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
					Daily Process
				</td>
			</tr>
			<tr>
				<td  ALIGN="CENTER" CLASS="blue-head" COLSPAN="2" WIDTH="100%">&nbsp;
						
				</td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">
						Process Type :
				</td>
				<td  ALIGN="LEFT" COLSPAN="1" WIDTH="50%">
						<SELECT NAME="ProcessType"  CLASS="StyleLabel2">
							<OPTION VALUE="P" >Process</OPTION>
							<OPTION VALUE="C" >Cancle Process</OPTION>
						</SELECT>
				</td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">
						Month :
				</td>
				<td  ALIGN="LEFT" COLSPAN="1" WIDTH="50%">
					<input type="text" value="#DateFormat(now(),'dd/mm/yyyy')#" name="txtDate">
				</td>
				
			</tr>
			<TR height="80">
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Company List :&nbsp;</tD>
				<td align="left" height="22">
						<Cfset TXTTEXT  ="Company_List">
					<Cfset fromname  ="MonthlyProcess">
					<cfinclude template="../../FATextCocd.cfm">
				</td>
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
					<Cfset ClHelp =PreserveSingleQuotes(GetUserGroupAccessibleMenuList.TRD_CMP_CODES)>	
					<Cfset ClHelp = Replace(ClHelp,"'",'~','all')>
					<Cfset Help = "select Distinct client_id,client_name from client_detail_view  where Company_Code in(#ClHelp#)">
					<TEXTAREA COLS="30" ROWS="3" NAME="ClientCode" CLASS="StyleTextBox"></TEXTAREA>
					<INPUT TYPE="Button" NAME="cmdClientHelp" VALUE=" ? " CLASS="StyleSmallButton1"
						OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=ClientCode&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">				
				</TD>
			</TR> 
			<tr>
				<td  ALIGN="RIGHT"  COLSPAN="1" WIDTH="50%" CLASS="clsLabel">
				<FONT CLASS="clsLabel">&nbsp;Amount Above:&nbsp;:</FONT>	
				</td>
				<td  ALIGN="left" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">
				<INPUT TYPE="text" NAME="MaxAmount" class="StyleTextBox" SIZE="5" VALUE="0" >
				<CFIF IsDefined("MaxAmount")>
						<SCRIPT>
							MonthlyProcess.MaxAmount.value=#val(MaxAmount)#;
						</SCRIPT>
				</CFIF>
				</td>
			</tr>
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Cash Gress Period:</TD>
				<TD ALIGN="left" COLSPAN="1">
					Debit:<INPUT TYPE="text" NAME="Debit_Day" size="3" VALUE="0" CLASS="StyleRightTextBox">/				
					Credit:<INPUT TYPE="text" NAME="Credit_Day"  size="3" VALUE="0" CLASS="StyleRightTextBox">(In Days) 				
				</TD>
			</TR> 
			
			 
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;FO Gress Period:</TD>
				<TD ALIGN="left" COLSPAN="1">
					Debit:<INPUT TYPE="text" NAME="FODebit_Day" size="3" VALUE="0" CLASS="StyleRightTextBox">/				
					Credit:<INPUT TYPE="text" NAME="FOCredit_Day"  size="3" VALUE="0" CLASS="StyleRightTextBox">(In Days) 				
				</TD>
			</TR> 
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Include Short Margin.:</TD>
				<TD ALIGN="left" COLSPAN="1">
					<INPUT TYPE="checkbox" NAME="IncluShortMargin" size="3" VALUE="Y" CLASS="StyleLabel1">				
				</TD>
			</TR> 
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;FO Gress Period:</TD>
				<TD ALIGN="left" COLSPAN="1">
					<INPUT TYPE="radio" NAME="type" size="3" VALUE="_RECONCIALATION" CLASS="StylePlainTextBox">  
					Reconcile Date				
					<INPUT TYPE="radio" NAME="type"  checked size="3" VALUE="" CLASS="StylePlainTextBox">    Voucher Date 
				</TD>
			</TR> 
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Include Associate A/c:</TD>
				<TD ALIGN="left" COLSPAN="1">
					<INPUT TYPE="radio" NAME="AssociateAc" size="3" VALUE="Y" CLASS="StylePlainTextBox">Yes
					<INPUT TYPE="radio" NAME="AssociateAc" size="3" VALUE="N" CLASS="StylePlainTextBox" checked>No
				</TD>
			</TR>
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Only Active Client.:</TD>
				<TD ALIGN="left" COLSPAN="1">
					<INPUT TYPE="checkbox" NAME="CLType" size="3" VALUE="A" CLASS="StyleLabel1">				
				</TD>
			</TR> 
			<tr>
				<td  ALIGN="CENTER" COLSPAN="10" WIDTH="100%" CLASS="clsLabel">
					<INPUT TYPE="BUTTON" VALUE="Process" NAME="Process" CLASS="StyleSmallButton1" onClick="this.disabled=true;this.form.Process1.value=1;this.form.submit();">
				</td>
			</tr>
		</TABLE>
		</TABLE>
	</FORM>
</BODY></CFOUTPUT>

</HTML>
