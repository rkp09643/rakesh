<cfinclude template="/focaps/help.cfm">
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
			1. For Interest Calculation <FONT COLOR="red"> <U>LatePayChrg</U></FONT> Account<br>
			&nbsp;&nbsp;&nbsp;&nbsp; Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			2. Interest Rate Defien In Client<br>
			&nbsp;&nbsp;&nbsp; Master(Other Then Zero)
		</td>
	</tr>
	<tr>
		<td style="color:FF0000" >
			3. This Process Take Huge Resources . <br>
			Make This Process At Night Time<br>
		</td>
	</tr>
	<tr>
		<td style="color:FF0000" >
			4. Blank Posting Date will consider <br>
			System Posting Date<br>
		</td>
	</tr>
</TABLE>
</DIV>
<DIV STYLE="top:0%;LEFT:0;width:100%;height:50%;position:absolute;overflow:auto;z-index:-1;" >
<CFIF IsDefined("Process1") and Process1 eq 1>
	<Cfif not IsDefined("COMPANY_LIST")>
		<script>
			alert('Please Select Atleast One Company');
			history.back();
		</script>
		<cfabort>
	</Cfif>
	<Cfset FileText =''>
	
		<Cfif not IsDefined("From_Date")>
				<cFIF Month1 GTE 4 AND Month1 LTE 12>
						<Cfset Year1 = '#StYr#'>
				<CFELSE>		
						<Cfset Year1 = '#EndYr#'>
				</cFIF>
				<cFSET FROM = CreateDate(YEAR1,MONTH1,1)>
				<cFSET Month1 = NumberFormat(Month1,00)>
				<CFSET FROMDATE = '01/#Month1#/#YEAR1#'>
				<CFSET TODATE = '#DaysInMonth(FROM)#/#Month1#/#YEAR1#'>
		<cfelse>
				<CFSET FROMDATE = GetToken(From_Date,1,'-')>
				<CFSET TODATE = GetToken(From_Date,2,'-')>
		</Cfif>
		<cFSET Interest =''>
		<CFIF  IsDefined("Interest")>
			<Cfif ProcessType eq 'P'>
					<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
						SELECT * FROM COMPANY_MASTER
					</CFQUERY>
					<cfloop query="INSERT">
							<CFQUERY name= "GetAccount" datasource="#Client.database#">
								EXEC [FACLIENT_CREATION] 'CREATE DIRECT ACCOUNT','#COMPANY_CODE#','LatePayChrg','LatePayChrg','#COMPANY_CODE#', #StYr#,#EndYr#
							</CFQUERY>
					</cfloop>
					<CFQUERY name= "GetAccount" datasource="#Client.database#">
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'LatePayChrg'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create (LatePayChrg) Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					<cfparam default="N" name="IncluShortMargin">
					<cfparam default="N" name="CLType">
					<CFSET TOKENVAR = "#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
					<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
						EXEC [FA_INTERESTCAL#type#] '#FROMDATE#','#TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#','N','N','Y','Y',12,'#AssociateAc#','N',0,0,#val(Debit_Day)#,#val(CrEdit_Day)#,1
						,'#IncluShortMargin#',0,#TOKENVAR#
						,'M','','',0,#val(FODebit_Day)#,#val(FOCrEdit_Day)#,'#CLType#','P'
					</CFQUERY>
					
					<!--- <cftry>
						<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
							DROP TABLE ##TEMPFAINST
						</CFQUERY>
					<cfcatch></cfcatch>
					</cftry>
					<cftry>
					<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
						DROP TABLE ##TEMP_MAX_CODE 
					</CFQUERY>				
					<cfcatch></cfcatch>
					</cftry>
					<cftry>
					<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
						DROP TABLE ##TEMPCOCD
					</CFQUERY>
					<cfcatch></cfcatch>
					</cftry>
					<!--- <CFQUERY NAME="Q" datasource="#Client.database#" DBTYPE="ODBC">
						select * from  ####FAINTEREST
						order by ACCOUNTCODE,COCD
					</CFQUERY> ---> --->
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
						<cfdump var="#Q1#">
						<!--- <cfdump var="#Q#"> --->
					</cfsavecontent>
					<cfif IsDefined("FileText")>
						<cfif NOT DirectoryExists("C:\CFUSIONMX7\WWWROOT\REPORTS\Interest")>
							<cfdirectory action="create" directory="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest">
						</cfif>
						<cffile action="write" file="C:\CFUSIONMX7\WWWROOT\REPORTS\Interest\Interest_Globle_Monthly_#dateformat(now(),'DDMMYYYY')#_#timeformat(now(),'HHMM')#.HTML"  output="#FileText#">
					</cfif>
					
					<cftry>
						<CFQUERY NAME="POSTINGJV" datasource="#Client.database#">
							EXEC FA_INTEREST_POSTINGDATA '#TOKENVAR#','#PostingDate#','#FROMDATE#','#TODATE#',#val(MaxAmount)#,#StYr#,'#REMOTE_ADDR#','#Ucase(CLIENT.UserName)#'
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
								GROUP BY ACCOUNTCODE
								having SUM(NETINTEREST) > 0
							  	AND SUM(NETINTEREST) > <CFIF  IsDefined("MaxAmount")>#val(MaxAmount)#<CFELSE>0</CFIF> 	
					</CFQUERY> --->
			<!--- <CFTRANSACTION>
				<CFTRY>
					<FONT COLOR="red">**Process Interest Calculation</FONT>	<BR>
					<!--- <CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
								Delete From FA_TRANSACTIONS
								where 
									VoucherDate = CONVERT(DATETIME,'#TODATE#',103)
								and FinStyr = #StYr#
								and BillNo = 1999
								and Trans_Type = 'J'
					</CFQUERY> --->
					<cfset sr = 1>
					
					<cfif PostingDate neq "">
						<CFQUERY NAME="DT" datasource="#Client.database#" DBTYPE="ODBC">
							IF MONTH(CONVERT(DATETIME,'#TODATE#',103)) != 3
							BEGIN
								select CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#PostingDate#',103)),103) TODATE,CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#TODATE#',103)+1),103) TODATE1
							END
							ELSE
							BEGIN
								select CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#PostingDate#',103)),103) TODATE,CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#TODATE#',103)),103) TODATE1
							END
						</CFQUERY>	
					<CFELSE>
						<CFQUERY NAME="DT" datasource="#Client.database#" DBTYPE="ODBC">
							IF MONTH(CONVERT(DATETIME,'#TODATE#',103)) != 3
							BEGIN
								select CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#TODATE#',103)+1),103) TODATE,CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#TODATE#',103)+1),103) TODATE1
							END
							ELSE
							BEGIN
								select CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#TODATE#',103)),103) TODATE,CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#TODATE#',103)),103) TODATE1
							END 
						</CFQUERY>
					</cfif>
					
							
					<CFLOOP QUERY="CLIENTDATA">
							<cfset AcCode =ACCOUNTCODE>
							<cfset AccountName =AccountName>
							<cfset AMT = DRINTEREST>
							<!--- <CFQUERY NAME="SelectVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
									select IsNull(max(cast(substring(VoucherNo,3,len(VoucherNo)) as numeric(30,0))),0) +1 as Incr 
									from FA_Transactions
									where COcd = '#cocd#'
										and FinStyr = #StYr#
										and FinEndyr = #StYr#+1
										and VoucherNo like 'JV%'
							</CFQUERY> --->
							<!--- <CFQUERY NAME="SelectrefNo" datasource="#Client.database#" DBTYPE="ODBC">
									select max(isNull(REFNo,0))+1 as REFNo1 
									from FA_Transactions
							</CFQUERY> --->
							
							
							<CFQUERY NAME="SelectVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
									select  DBO.[GETLATESTVOUCEHRNO]('#cocd#',#StYr#,'J','','#DT.TODATE#','') TXTVOUCHERNO
							</CFQUERY>	
							<CFSET TXTVOUCHERNO=#SelectVoucherNo.TXTVOUCHERNO#>		
 							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,BILLDATE
									)
									values
									(
											'#cocd#','#AcCode#',#Amt#,0,
											convert(datetime,'#DT.TODATE#',103),'J', '#TXTVOUCHERNO#' 
											,'By Monthly Process From #FromDate# To #Todate# Of Late Payment Chrg #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1999,convert(datetime,'#DT.TODATE1#',103)
									)
							</CFQUERY>		
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,refNo,BillNo,BILLDATE
									)
									values
									(
										'#cocd#','LatePayChrg',0,#AMT#,
										convert(datetime,'#DT.TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# Of Late Payment Chrg #INTERESTRATE#%',
										'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
										1999,convert(datetime,'#DT.TODATE1#',103)
									)
									
							</CFQUERY>		
							#Sr#. JVNo :(#TXTVOUCHERNO#) ,Company Code:#cocd#,Client :(#AcCode#) ,Amount:(#amt#),Date : #DT.TODATE#<BR>
							<cfset sr = sr+1>
					</CFLOOP>
				<CFCATCH>
					#CFCATCH.Message##CFCATCH.Detail#<BR>
					<CFABORT>
				</CFCATCH>
				</CFTRY>
			</CFTRANSACTION>		 --->
			<CFELSE>	
					<CFQUERY NAME="DT" datasource="#Client.database#" DBTYPE="ODBC">
						IF MONTH(CONVERT(DATETIME,'#TODATE#',103)) != 3
						BEGIN
							select CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#TODATE#',103)+1),103) TODATE
						END
						ELSE
						BEGIN
							select CONVERT(VARCHAR(10),(CONVERT(DATETIME,'#TODATE#',103)),103) TODATE
						END 
					</CFQUERY>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
						<!--- Delete From FA_TRANSACTIONS
						where 
							cocd = '#cocd#'
						and VoucherDate = CONVERT(DATETIME,'#TODATE#',103)
						and FinStyr = #StYr#
						and BillNo = 1999
						and Trans_Type = 'J' --->
						EXEC [FA_INTERESTCAL_DELETEJV] '#FROMDATE#','#DT.TODATE#',#StYr#,'#Company_List#','#txtBranch#','#txtFamily#','#ClientCode#'
					</CFQUERY>
					<FONT COLOR="red">**Delete Process Of Interest Calculation</FONT>	<BR>
			</Cfif>
		</CFIF>
		<cfabort>
</CFIF>

</DIV>
	<FORM NAME="MonthlyProcess" ACTION="GlobalMonthProcess.cfm" METHOD="POST">
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
					Global Monthly Process
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
				<cfif SysParamValue("MonthlyProcDate") neq 'E'  >
					<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%">
							<SELECT NAME="Month1" CLASS="StyleLabel2">
								<OPTION VALUE="4" >April</OPTION>
								<OPTION VALUE="5" >May</OPTION>
								<OPTION VALUE="6" >June</OPTION>
								<OPTION VALUE="7" >July</OPTION>
								<OPTION VALUE="8" >August</OPTION>
								<OPTION VALUE="9" >September</OPTION>
								<OPTION VALUE="10" >October</OPTION>
								<OPTION VALUE="11" >November</OPTION>
								<OPTION VALUE="12" >December</OPTION>
								<OPTION VALUE="1" >January</OPTION>
								<OPTION VALUE="2" >Febuary</OPTION>
								<OPTION VALUE="3" >March</OPTION>
						  </SELECT>
					</td>
				<cfelse>
					<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%">
							<CFQUERY NAME="GetD" datasource="#Client.database#" DBTYPE="ODBC">
								SELECT convert(varchar(10),MAX(EXPIRY_DATE),103) FROM_DATE ,convert(varchar(10),MAX(EXPIRY_DATE1),103)TO_DATE ,MTH
								FROM
								(
								SELECT  DISTINCT EXPIRY_DATE+1 EXPIRY_DATE,NULL EXPIRY_DATE1,CASE WHEN MONTH(EXPIRY_DATE)+1 =13 THEN  1 ELSE MONTH(EXPIRY_DATE)+1  END MTH
								FROM TRADE1 A,FINANCIAL_YEAR_MASTER B
								WHERE  A.EXPIRY_DATE  BETWEEN START_DATE AND END_DATE
								AND A.COMPANY_CODE ='NSE_FNO'
								AND FINSTART =#Val(Trim(StYr))#
								UNION ALL
								SELECT  DISTINCT NULL,EXPIRY_DATE,MONTH(EXPIRY_DATE)  MTH
								FROM TRADE1 A,FINANCIAL_YEAR_MASTER B
								WHERE  A.EXPIRY_DATE  BETWEEN START_DATE AND END_DATE
								AND A.COMPANY_CODE ='NSE_FNO'
								AND FINSTART =#Val(Trim(StYr))#
								) V
								GROUP BY MTH
							</CFQUERY>
							<SELECT NAME="From_Date" CLASS="StyleLabel2">
								<cfloop query="GetD">
									<OPTION VALUE="#FROM_DATE#-#TO_DATE#" >#FROM_DATE#-#TO_DATE#</OPTION>
								</cfloop>
						  </SELECT>
					</td>
				</cfif>
				<SCRIPT>
					MonthlyProcess.Month1.value='#Month(now())#'
				</SCRIPT>
				<CFIF IsDefined("Month1")>
						<SCRIPT>
							MonthlyProcess.Month1.value='#VAL(Month1)#'
						</SCRIPT>
				</CFIF>
			</tr>
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Posting Date:</TD>
				<TD ALIGN="left" COLSPAN="1">
					<INPUT TYPE="text" NAME="PostingDate" size="10" VALUE="" CLASS="StyleRightTextBox">
				</TD>
			</TR>
			<TR height="80">
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Company List :&nbsp;</tD>
				<td align="left" height="22">
					<Cfset TXTTEXT  ="Company_List">
					<Cfset fromname  ="MonthlyProcess">
					<cfinclude template="../../FATextCocd.cfm">
					<!--- <Cfset Help = "Select Company_code,Company_Name From Company_master	">
					<TEXTAREA COLS="30" ROWS="3" NAME="Company_List" CLASS="StyleTextBox"></TEXTAREA>
					<INPUT 	TYPE="BUTTON" NAME="BtnHelp" class="StyleSmallButton1" VALUE=" ? " 
							OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=Company_List&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
 --->							
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
					<Cfset Help = "select Distinct client_id,client_name from client_detail_view  where  Company_Code in(#ClHelp#)">
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
	</FORM>
</BODY></CFOUTPUT>

</HTML>
