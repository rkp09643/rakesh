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
			1. For Interest Calculation <FONT COLOR="red"> <U>WeeklyInterst</U></FONT> Account Required In Fa
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
		<cFIF Month1 GTE 4 AND Month1 LTE 12>
				<Cfset Year1 = '#StYr#'>
		<CFELSE>		
				<Cfset Year1 = '#EndYr#'>
		</cFIF>
		<CFSET FROMDATE =  GetToken(Month1,1,'-')>
		<CFSET TODATE =  GetToken(Month1,2,'-')>

		<Cfif ProcessType eq 'P'>
				<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
					SELECT * FROM COMPANY_MASTER
				</CFQUERY>
				<cfloop query="INSERT">
				<CFQUERY name= "GetAccount" datasource="#Client.database#">
					EXEC [FACLIENT_CREATION] 'CREATE DIRECT ACCOUNT','#COMPANY_CODE#','WeeklyInterst','WeeklyInterst','#COMPANY_CODE#', #StYr#,#EndYr#
				</CFQUERY>
				</cfloop>
					<CFQUERY name= "GetAccount" datasource="#Client.database#">
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'WeeklyInterst'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create (WeeklyInterst) Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					<cfparam default="N" name="IncluShortMargin">
					<cfparam default="N" name="CLType">
					<CFSET TOKENVAR = "#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
					<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
						EXEC [FA_INTERESTCAL#type#] '#FROMDATE#','#TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#','N','N','Y','Y',12,'#AssociateAc#','N',0,0,#val(Debit_Day)#,#val(CrEdit_Day)#,1
						,'#IncluShortMargin#',0,#TOKENVAR#
						,'W','','',0,#val(FODebit_Day)#,#val(FOCrEdit_Day)#,'#CLType#','P'
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
						<cffile action="write" file="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest\Interest_Globle_Weekly_#dateformat(now(),'DDMMYYYY')#_#timeformat(now(),'HHMM')#.HTML"  output="#FileText#">
					</cfif>
					
					<cftry>
					
					<CFQUERY NAME="POSTINGJV" datasource="#Client.database#">
						EXEC FA_INTEREST_POSTINGDATA '#TOKENVAR#','','#FROMDATE#','#TODATE#',#val(MaxAmount)#,#StYr#,'#REMOTE_ADDR#','#Ucase(CLIENT.UserName)#','W'
					</CFQUERY>
					
					<cfcatch>
						Error: Error While Processing #Cfcatch.Message#-#cfcatch.Detail#
					</cfcatch>
					</cftry>
					Process Completed............
					<!--- <CFQUERY NAME="CLIENTDATA" datasource="#Client.database#">
								SELECT COCD,ACCOUNTCODE,MAX(AccountName) AccountName,
								SUM(DRINTEREST) DRINTEREST,SUM(CRINTEREST) CRINTEREST,
								SUM(DRINTEREST-CRINTEREST) NETINTEREST,
								max(INTERESTRATE) INTERESTRATE,
								CAST('' AS VARCHAR(100)) AS POSTCOCD
								INTO ##TEMPFAINST
								FROM ####FAINTEREST
								GROUP BY COCD,ACCOUNTCODE
								
								
								SELECT ACCOUNTCODE ,MAX(NETINTEREST)  NETINTEREST
								INTO ##TEMP_MAX_CODE
								FROM ##TEMPFAINST
								WHERE ISNULL(COCD,'') !=''
								GROUP BY ACCOUNTCODE 
								
								SELECT A.ACCOUNTCODE,B.COCD
								INTO ##TEMPCOCD
								FROM ##TEMP_MAX_CODE A,##TEMPFAINST B
								WHERE A.NETINTEREST = B.NETINTEREST
								AND A.ACCOUNTCODE = B.ACCOUNTCODE
								
								UPDATE ##TEMPFAINST
								SET POSTCOCD=A.COCD
								FROM ##TEMPCOCD A,##TEMPFAINST B
								WHERE A.ACCOUNTCODE = B.ACCOUNTCODE
								
								SELECT MAX(POSTCOCD) COCD ,ACCOUNTCODE,MAX(AccountName) AccountName,SUM(NETINTEREST) DRINTEREST
									,MAX(INTERESTRATE) INTERESTRATE
								FROM ##TEMPFAINST
								GROUP BY ACCOUNTCODE,AccountName
								having SUM(NETINTEREST) > 0
							  	AND SUM(NETINTEREST) > <CFIF  IsDefined("MaxAmount")>#val(MaxAmount)#<CFELSE>0</CFIF> 	
					</CFQUERY>
			<CFTRANSACTION>
				<CFTRY>
					<FONT COLOR="red">**Process Interest Calculation</FONT>	<BR>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
								Delete From FA_TRANSACTIONS
								where 
									cocd = '#cocd#'
								and VoucherDate = CONVERT(DATETIME,'#TODATE#',103)
								and FinStyr = #StYr#
								and BillNo = 1337
								and Trans_Type = 'J'
					</CFQUERY>
					<cfset sr = 1>
					<CFLOOP QUERY="CLIENTDATA">
							<cfset AcCode =ACCOUNTCODE>
							<cfset AccountName =AccountName>
							<cfset AMT = DRINTEREST>
							<CFQUERY NAME="SelectVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
									select  DBO.[GETLATESTVOUCEHRNO]('#cocd#',#StYr#,'J','','#TODATE#','') TXTVOUCHERNO
							</CFQUERY>	
							<CFSET TXTVOUCHERNO=#SelectVoucherNo.TXTVOUCHERNO#>		
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
										BILLDATE	
									)
									values
									(
											'#cocd#','#AcCode#',#Amt#,0,
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'By Weekly Process Late Payin Charges For Period of #FromDate# To #Todate#',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1337,convert(datetime,'#TODATE#',103)
									)
							</CFQUERY>		
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,refNo,BillNo,
										BILLDATE
									)
									values
									(
											'#cocd#','WeeklyInterst',0,#AMT#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Weekly Process Late Payin Charges For Period of #FromDate# To #Todate#',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1337,convert(datetime,'#TODATE#',103)
									)
									
							</CFQUERY>		
							#Sr#. JVNo :(#TXTVOUCHERNO#) ,Company Code:#cocd#,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
							<cfset sr = sr+1>
							<cfquery datasource="#Client.database#" name="getVoucherTotal">
								SELECT SUM(CR_AMT) CR_AMT,SUM(DR_AMT) DR_AMT
								FROM FA_TRANSACTIONS
								WHERE COCD = '#COCD#'
								AND FINSTYR = '#styr#'
								AND VOUCHERNO = '#TxtVoucherNo#'
							</cfquery>
							<cfif VAL(getVoucherTotal.CR_AMT) NEQ VAL(getVoucherTotal.DR_AMT)>
								<cftransaction action="rollback"/>
								<script>
									alert('Voucher Total Not Match ');
									history.back();
								</script>
								<cfabort>
							</cfif>
					</CFLOOP>
				<CFCATCH>
					#CFCATCH.Message##CFCATCH.Detail#<BR>
					<CFABORT>
				</CFCATCH>
				</CFTRY>
			</CFTRANSACTION>		 --->
			<CFELSE>	
					<cFSET FileText ="Process Cancle For '#FROMDATE#','#TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#','1337'
								User:#CLIENT.USERNAME#-#CLIENT.CLIENTIPADD#">
					
					<cfif IsDefined("FileText")>
						<cfif NOT DirectoryExists("C:\CFUSIONMX7\WWWROOT\REPORTS\Interest")>
							<cfdirectory action="create" directory="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest">
						</cfif>
						<cffile action="write" file="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest\Can_Interest_Globle_Monthly_#dateformat(now(),'DDMMYYYY')#_#timeformat(now(),'HHMM')#.HTML"  output="#FileText#">
					</cfif>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
						<!--- 						Delete From FA_TRANSACTIONS
						where 
						cocd = '#cocd#'
						and VoucherDate = CONVERT(DATETIME,'#TODATE#',103)
						and FinStyr = #StYr#
						and BillNo = 1337
						and Trans_Type = 'J'--->
 						EXEC [FA_INTERESTCAL_DELETEJV] '#FROMDATE#','#TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#','1337'
					</CFQUERY>
		</CFIF>
		<cfabort>
</CFIF>
</DIV>
	<FORM NAME="WeeklyProcess" ACTION="WeeklyProcess.cfm" METHOD="POST">
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
					Weekly Process
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
					<SELECT NAME="Month1" CLASS="StyleLabel2">
						<cfquery datasource="#Client.database#" name="GeDate1">
							SELECT * FROM
							FINANCIAL_YEAR_MASTER
							where FINSTART =#StYr#
						</cfquery>
					
					<cfloop index="i" from="0" to="53">
						<cfquery datasource="#Client.database#" name="GeDate">
							SELECT 
							convert(VARCHAR(10),DATEADD(d, #i#*7, '#GeDate1.START_DATE#'),103) Fist,
							 CASE WHEN '#GeDate1.END_DATE#' > DATEADD(d, #i#*7, '#GeDate1.START_DATE#')+6 THEN
									convert(VARCHAR(10),DATEADD(d, #i#*7, '#GeDate1.START_DATE#')+6,103)
							 ELSE
							 		convert(VARCHAR(10),convert(DATETIME,'#GeDate1.END_DATE#',110),103)
							 END AS 	 Last,
							 CASE WHEN '#GeDate1.END_DATE#' <= DATEADD(d, #i#*7, '#GeDate1.START_DATE#')+6 THEN
									1
							 ELSE 	0
							 END AS 	 LastdATE,
							 CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),103) ,103) BETWEEN
								DATEADD(d, #i#*7, '#GeDate1.START_DATE#')	AND  DATEADD(d, #i#*7, '#GeDate1.START_DATE#')+6
							 THEN
									'selected'
							 ELSE 	''
							 END AS 	 SELECT1
						</cfquery>
							<OPTION #GeDate.SELECT1# VALUE="#GeDate.Fist#-#GeDate.last#" >#GeDate.Fist#-#GeDate.last#</OPTION>
							<cfif GeDate.LastdATE EQ 1>
								<cfbreak>
							</cfif>
						</cfloop>
				  </SELECT>
				</td>
				<CFIF IsDefined("Month1")>
						<SCRIPT>
							WeeklyProcess.Month1.value='#Month1#'
						</SCRIPT>
				</CFIF>
			</tr>
			<TR height="80">
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Company List :&nbsp;</tD>
				<td align="left" height="22">
						<Cfset TXTTEXT  ="Company_List">
					<Cfset fromname  ="MonthlyProcess">
					<cfinclude template="../../FATextCocd.cfm">
<!--- 					<Cfset Help = "Select Company_code,Company_Name From Company_master	">
					<TEXTAREA COLS="30" ROWS="3" NAME="Company_List" CLASS="StyleTextBox"></TEXTAREA>
					<INPUT 	TYPE="BUTTON" NAME="BtnHelp" class="StyleSmallButton1" VALUE=" ? " 
							OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=Company_List&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
 --->				</td>
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
