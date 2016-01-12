<cfinclude template="/focaps/help.cfm">
<HTML>
<HEAD>
<TITLE>Monthly Process</TITLE>
<LINK href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
<LINK href="../../CSS/style1.css" rel="stylesheet" type="text/css">


	<SCRIPT LANGUAGE="VBSCRIPT">
		Sub	txtDate_OnKeyuP()
				DSTR = MonthlyProcess.txtDate.value
				DLEN = LEN(MonthlyProcess.txtDate.value)
				IF DLEN = 2 OR DLEN = 5 THEN
					MonthlyProcess.txtDate.value = DSTR + "/"
				END IF	
		END SUB
		Sub	txtDate_GotFocus()	
				MonthlyProcess.txtDate.SelStart = 0
				MonthlyProcess.txtDate.SelLength = LEN(MonthlyProcess.txtDate.value)
		END SUB
	</SCRIPT>								


</HEAD>
<CFOUTPUT>
<BODY CLASS="StyleBody">
<cfif cocd neq 'NBFC'>
Select NBFC Company
<cfabort>
</cfif>
 

<div STYLE="top:5%;LEFT:0%;width:50%;height:45%;position:absolute;overflow:auto">
		<CFQUERY NAME="LastProcess" datasource="#Client.database#">
			Select CONVERT(VARCHAR(10),Max(voucherdate),103) voucherdate , 'Interest Charges :' TYPE
			from FA_TRANSACTIONS 
			where 
				Trans_Type='J'
				AND FINSTYR = '#StYr#' 
				AND COCD	= '#COCD#'
				AND BillNo IN('1450')
		</CFQUERY>	
		<TABLE CLASS="StyleCommonMastersTable">
			<tr align="left">
				<th>
					Last Process On :
				</th>
			</tr>
			<cfloop query="LastProcess">
				<tr>
					<td align="left">
						#TYPE#-#Trim(voucherdate)#
					</td>
				</tr>
			</cfloop>
			<tr>
		<Th >
			<U><i>*Daily Process Description.</i></U>
		</Th>
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
		</table>	
		


</div>
<DIV STYLE="top:50%;LEFT:60%;width:40%;height:50%;position:absolute;overflow:auto" >
	<cfquery datasource="#Client.database#" name="gETdATE">
			SELECT * from dbo.DATELIST('01/04/#StYr#','31/03/#val(StYr+1)#') 
			where trade_date not in (SELECT DISTINCT VOUCHERDATE FROM FA_TRANSACTIONS
			WHERE  COCD = 'NBFC' AND  BillNo = 1450		and Trans_Type = 'J')
			AND trade_date >=  (SELECT DISTINCT MIN(VOUCHERDATE) FROM FA_TRANSACTIONS WHERE  COCD = 'NBFC')
			AND trade_date <=  (SELECT DISTINCT MAX(VOUCHERDATE) FROM FA_TRANSACTIONS WHERE  COCD = 'NBFC')
	</cfquery>
	<table  CLASS="StyleCommonMastersTable">
		<TR>
				<Th>
						<U>**List Of Dates Which Interest Process Not Done</U>
				</Th>
			</TR>
		<cfloop query="gETdATE">
			<TR>
				<TD>
						#DateFormat(trade_date,'DD/MM/YYYY')#
				</TD>
			</TR>
		</cfloop>
	</table>
</DIV>

<DIV STYLE="top:50%;LEFT:0;width:60%;height:50%;position:absolute;overflow:auto" >

<CFIF IsDefined("Process1") and Process1 eq 1>

		<CFSET FROMDATE = '#txtDate#'>
		<CFSET TODATE   = '#txtDate#'>
		
		<CFIF  IsDefined("Interest")>

			<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
				SELECT DISTINCT A.CLIENT_ID 
				FROM CLIENT_DETAIL_VIEW A,CLIENT_DETAILS B
				WHERE ISNULL(A.DR_INTEREST,0) <> 0
					AND A.CLIENT_ID    = B.CLIENT_ID
					AND ISNULL(B.INTEREST_CALC,'')='D'	
					AND A.COMPANY_CODE = '#COCD#'

			</CFQUERY>
			<CFSET CLIENTlIST = ''>
			
			<CFLOOP QUERY="gETCLIENT">
				<cFIF CLIENTLIST EQ ''>
					<CFSET CLIENTlIST = '#CLIENT_ID#'>
				<CFELSE>
					<CFSET CLIENTlIST = '#CLIENTlIST#,#CLIENT_ID#'>
				</cFIF>
			</CFLOOP>
			<cFSET CLIENTlIST = LEFT(CLIENTlIST,8000)>
			<cFSET CLIENTlIST = TRIM(CLIENTlIST)>

			<Cfif ProcessType eq 'P'>
					<CFTRY>
						<CFQUERY name= "GetAccount" datasource="#Client.database#">
								INSERT INTO FA_ACCOUNTSUBTYPE
								(
								COCD, ACCOUNTCODE, BOOKTYPECODE, 
								ACCOUNT_CLIENT_CODE, ACCOUNTNAME, FINSTYR, FINENDYR
								)
								VALUES
								(
								'NBFC','1',3,'DailyInterst','DailyInterst','#StYr#','#VAL(StYr+1)#'
								)	
						</CFQUERY>
					<cfcatch>
					</cfcatch>
					</CFTRY>
					<CFQUERY NAME="GETCLIENT" datasource="#Client.database#">
						EXEC [NBFC_FA_INTERESTCAL] '#FROMDATE#','#TODATE#',#StYr#,'#COCD#','','','#CLIENTlIST#','N','N','Y','Y',12,'N','N',0,0,0,0,1
						,'#AssociateAc#',0
					</CFQUERY>
					
					<CFQUERY NAME="CLIENTDATA" datasource="#Client.database#">
						SELECT ACCOUNTCODE,MAX(AccountName) AccountName,SUM(DRINTEREST) DRINTEREST,max(INTERESTRATE) INTERESTRATE
						 FROM ####FAINTEREST
						GROUP BY ACCOUNTCODE
						having SUM(DRINTEREST) <> 0
					</CFQUERY>
			<CFTRANSACTION>
				<CFTRY>
					<FONT COLOR="red">**Process Interest Calculation</FONT>	<BR>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
								Delete From FA_TRANSACTIONS
								where 
									cocd = '#cocd#'
								and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
								and FinStyr = #StYr#
								and BillNo = 1450
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
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo
									)
									values
									(
											'#cocd#','#AcCode#',#Amt#,0,
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'By Daily Process  Interest Rate Of #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1450
									)
							</CFQUERY>		
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,refNo,BillNo
									)
									values
									(
											'#cocd#','DailyInterst',0,#AMT#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Daily Process  Interest Rate Of #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1450
									)
									
							</CFQUERY>		
							#Sr#. JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#)<BR>
							<cfset sr = sr+1>
					</CFLOOP>
				<CFCATCH>
					#CFCATCH.Message##CFCATCH.Detail#<BR>
					<CFABORT>
				</CFCATCH>
				</CFTRY>
			</CFTRANSACTION>
			<CFELSE>	
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
						Delete From FA_TRANSACTIONS
						where 
							cocd = '#cocd#'
						and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
						and FinStyr = #StYr#
						and BillNo = 1450
						and Trans_Type = 'J'
					</CFQUERY>
			</Cfif>
		</CFIF>
</CFIF>
</DIV>

	<CFFORM NAME="MonthlyProcess" ACTION="FrmNBFCDailyProcess.cfm" METHOD="POST">
		<INPUT type="Hidden" name="COCD" value="#COCD#">
		<INPUT type="Hidden" name="Process1" value="">
		<INPUT type="Hidden" name="COName" value="#COName#">
		<INPUT type="Hidden" name="Market" value="#Market#">
		<INPUT type="Hidden" name="Exchange" value="#Exchange#">
		<INPUT type="Hidden" name="StYr" value="#Val(Trim(StYr))#">
		<INPUT type="Hidden" name="EndYr" value="#Val(Trim(EndYr))#">
		
		<DIV STYLE="top:0%;LEFT:50%;width:50%;height:50%;position:absolute;overflow:auto" >		
		<TABLE WIDTH="100%" BORDER="0">
			<tr>
				<td  ALIGN="LEFT" CLASS="blue-head" COLSPAN="5" WIDTH="50%">
					Daily Process
				</td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" WIDTH="50%" CLASS="clsLabel">
						Process Type :
				</td>
				<td  ALIGN="LEFT" WIDTH="50%">
						<SELECT NAME="ProcessType"  CLASS="StyleLabel2">
							<OPTION VALUE="P" >Process</OPTION>
							<OPTION VALUE="C" >Revert Process</OPTION>
						</SELECT>				
				</td>				
			</tr>
			<tr ID="lblDaily">
				<td  ALIGN="RIGHT" WIDTH="50%" CLASS="clsLabel">
						Date :
				</td>
				<td  ALIGN="LEFT" WIDTH="50%">
				<CFINPUT TYPE="text" NAME="txtDate" VALIDATE="EURODATE" MESSAGE="Please enter Proper Date." VALUE="#DateFormat(now(),"DD/MM/YYYY")#" MAXLENGTH="10" SIZE="10" class="StyleTextBox">
				<CFIF IsDefined("txtDate")>
						<SCRIPT>
							MonthlyProcess.txtDate.value='#txtDate#';
						</SCRIPT>
				</CFIF>
				</td>
			</tr>

			<tr>
				<td  ALIGN="RIGHT"  WIDTH="50%" CLASS="clsLabel">
					Process Type :
				</td>
				<td  ALIGN="LEFT" WIDTH="50%"  CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="Interest" CLASS="StyleCheckBox" <CFIF IsDefined("Interest")>checked</CFIF> >Interest Calculation
				</td>
			</tr>
			<TR>
				<td  ALIGN="RIGHT" COLSPAN="1" WIDTH="50%" CLASS="clsLabel">&nbsp;Include Associate A/c:</TD>
				<TD ALIGN="left" COLSPAN="1">
					<INPUT TYPE="radio" NAME="AssociateAc" size="3" VALUE="Y" CLASS="StylePlainTextBox" checked>Yes
					<INPUT TYPE="radio" NAME="AssociateAc" size="3" VALUE="N" CLASS="StylePlainTextBox">No
				</TD>
			</TR>
			
			<tr>
				<td  ALIGN="CENTER" COLSPAN="10" WIDTH="100%" CLASS="clsLabel">
					<INPUT TYPE="BUTTON" VALUE="Process" NAME="Process" CLASS="StyleSmallButton1" onClick="this.disabled=true;this.form.Process1.value=1;this.form.submit();">
				</td>
			</tr>
		</TABLE>
		</div>			
	</CFFORM>

</BODY></CFOUTPUT>

</HTML>
