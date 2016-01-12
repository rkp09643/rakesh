<cfinclude template="/focaps/help.cfm"><HTML>
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
<CFFUNCTION name="JVPost" access="public" returntype="string">
	<CFARGUMENT name="cocd" type="string">
	<CFARGUMENT name="AcCode" type="string">
	<CFARGUMENT name="CN_AcCode" type="string">
	<CFARGUMENT name="Amt" type="string">
	<CFARGUMENT name="TODATE" type="string">
	<CFARGUMENT name="Narration" type="string">
	<CFARGUMENT name="StYr" type="string">
	<CFARGUMENT name="BillNo" type="string">
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
				convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'#Narration#',
				'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(StYr)+1#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
				#BillNo#
			)
	</CFQUERY>
	<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
			INSERT INTO FA_TRANSACTIONS
			(
				COcd, AccountCode,Dr_amt, Cr_amt,
				VoucherDate,  Trans_Type, VoucherNo, Narration,
				IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo
			)
			values
			(
				'#cocd#','#CN_AcCode#',0,#AMT#,
				convert(datetime,'#TODATE#',103),'J','#TXTVOUCHERNO#'   ,'#Narration#',
				'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
				#BillNo#
			)
	</CFQUERY>	
	<CFRETURN true>
</CFFUNCTION>


	


<BODY CLASS="StyleBody">
<DIV STYLE="top:50%;LEFT:50%;width:50%;height:50%;position:absolute;overflow:auto" >
<TABLE CLASS="StyleCommonMastersTable">
	<tr>
		<td >
			<U><i>*Daily Process Description.</i></U>
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
			4. For InterSettlment Process<FONT COLOR="red"> <U>DailyInterSett</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			5. For Ben To Market Process<FONT COLOR="red"> <U>DailyBenMkt</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			6. For Ben To Client Process<FONT COLOR="red"> <U>DailyBenCl</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			7. For Ben Inward Process<FONT COLOR="red"> <U>DailyBenInward</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			8. For Service Tax<FONT COLOR="red"> Def3_Daily </FONT> Account Required In Fa
		</td>
	</tr>

</TABLE>
</DIV>
<Cfif IsDefined("txtDate")>
	<CFQUERY NAME="LastProcess" datasource="#Client.database#">
		SELECT  ISNULL(MAX( SC ), 0) SC
		FROM 	SERVICE_CHARGE
		WHERE	COMPANY_CODE 	=  '#cocd#'
		 AND	CONVERT( DATETIME, FROM_DATE, 103) <=  CONVERT( DATETIME, '#txtDate#', 103)
		 AND	CONVERT( DATETIME, ISNULL( TO_DATE, CONVERT( DATETIME, '#txtDate#', 103) ), 103) >=  CONVERT( DATETIME, '#txtDate#', 103)
	</CFQUERY>
	<Cfset STAX = LastProcess.SC>
	<cFSET STAX_InterSettlement=SysParamValue("STAX_InterSettlement")>		
	<cFSET STAX_BenToMkt=SysParamValue("STAX_BenToMkt")>		
	<cFSET STAX_BenToCl=SysParamValue("STAX_BenToCl")>		
	<cFSET STAX_BenInwardChgs=SysParamValue("STAX_BenInwardChgs")>		
</Cfif>

<div STYLE="top:5%;LEFT:0%;width:50%;height:45%;position:absolute;overflow:auto">
		<CFQUERY NAME="LastProcess" datasource="#Client.database#">
			Select CONVERT(VARCHAR(10),Max(voucherdate),103) voucherdate , 'Interest Charges :' TYPE
			from FA_TRANSACTIONS 
			where 
				Trans_Type='J'
				AND FINSTYR = '#StYr#' 
				AND COCD	= '#COCD#'
				AND BillNo IN('1312')
				
			union all
			
			Select CONVERT(VARCHAR(10),Max(voucherdate),103) voucherdate , 'Intersettlement Charges :' TYPE
			from FA_TRANSACTIONS 
			where 
				Trans_Type='J'
				AND FINSTYR = '#StYr#' 
				AND COCD	= '#COCD#'
				AND BillNo IN('1313')	
			
			union all
			
			Select CONVERT(VARCHAR(10),Max(voucherdate),103) voucherdate , 'Ben. To Market Charges :' TYPE
			from FA_TRANSACTIONS 
			where 
				Trans_Type='J'
				AND FINSTYR = '#StYr#' 
				AND COCD	= '#COCD#'
				AND BillNo IN('1315')	
				
			union all
			
			Select CONVERT(VARCHAR(10),Max(voucherdate),103) voucherdate , 'Ben to Client Charges :' TYPE
			from FA_TRANSACTIONS 
			where 
				Trans_Type='J'
				AND FINSTYR = '#StYr#' 
				AND COCD	= '#COCD#'
				AND BillNo IN('1316')
				
			union all
			
			Select CONVERT(VARCHAR(10),Max(voucherdate),103) voucherdate , 'Ben Inward Charges :' TYPE
			from FA_TRANSACTIONS 
			where 
				Trans_Type='J'
				AND FINSTYR = '#StYr#' 
				AND COCD	= '#COCD#'
				AND BillNo IN('13115')	
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
						#TYPE#
					</td>
					<td align="right">
						#Trim(voucherdate)#
					</td>
				</tr>
			</cfloop>
		</table>	
		


</div>
<DIV STYLE="top:50%;LEFT:0;width:50%;height:50%;position:absolute;overflow:auto" >

<CFIF IsDefined("Process1") and Process1 eq 1>

		<CFSET FROMDATE = '#txtDate#'>
		<CFSET TODATE   = '#txtDate#'>
		
		<CFIF  IsDefined("BenToCl")>
				<Cfif ProcessType eq 'P'>
						<CFQUERY name= "GetAccount" datasource="#Client.database#">
								SELECT * 
								FROM 
									fa_accountList
									where  
										ACCOUNTCODE = 'DailyBenCl'	
									and COcd = '#cocd#'
									and FinStyr = #StYr#
									and FinEndyr = #EndYr#
							</CFQUERY>
							<CFIF GetAccount.recordcount eq 0>
								<SCRIPT>
									alert('Please Create (DailyBenCl) Account IN #cocd#'); 
								</SCRIPT>
								<CFABORT>
							</CFIF>
						<CFQUERY NAME="CMC" datasource="#Client.database#">
							SELECT CLEARING_MEMBER_CODE,ISNULL(Ben_To_Cl_Chrgs,0) BentoClChrgs,
								   ISNULL(Chags_Ben_List,'')Ben_List
							FROM SYSTEM_SETTINGS
							WHERE COMPANY_CODE = '#COCD#'
						</CFQUERY>
						<!--- <CFTRY>
							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								DROP TABLE ##MONTHLYDATA
							</CFQUERY>
							<CFCATCH>
							</CFCATCH>
						</CFTRY> --->
						<CFIF CMC.BentoClChrgs NEQ 0 And Trim(CMC.Ben_List) NEQ "">
									<CFSTOREDPROC PROCEDURE="BENIFICIARY_CHARGES" datasource="#Client.database#">
										<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROMDATE" value="#FROMDATE#" null="No">
										<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TODATE" VALUE="#FROMDATE#" NULL="No">
										<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@RECORDTYPE" VALUE="1" NULL="No">
										<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COCD" null="No" VALUE="#COCD#">
										
										<CFPROCRESULT NAME="GetData" RESULTSET="1">
									</CFSTOREDPROC>
									<CFTRANSACTION>
										<CFTRY>
											<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
												Delete From FA_TRANSACTIONS
												where 
													cocd = '#cocd#'
												and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
												and FinStyr = #StYr#
												and BillNo = 1316
												and Trans_Type = 'J'
											</CFQUERY>
											<cfset sr = 1>
											<FONT COLOR="red">**Process Ben To Client Start(Per Instruction Charges:#CMC.BentoClChrgs#)</FONT>	<BR>
											<CFQUERY NAME="ConDate" datasource="#Client.database#">
												Select DateName(MM,Month(Convert(Datetime, '#FromDate#', 103)))Month, Year(Convert(Datetime, '#FromDate#', 103))Year
											</CFQUERY>
											<CFLOOP QUERY="GETDATA">
												<cfset AcCode =CLIENT_CODE>
												<cfset AMT = CHARGESTODEBIT>	
												<!--- <cfset AMT = TOTALTRANS*CMC.BentoClChrgs> --->
												<cfif AMT  GT #MaxAmount#>
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
																	convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'Ben To Client Charge. No. of Inst. #TOTALTRANS#',
																	'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
																	1316
																)
														</CFQUERY>
														<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
																INSERT INTO FA_TRANSACTIONS
																(
																	COcd, AccountCode,Dr_amt, Cr_amt,
																	VoucherDate,  Trans_Type, VoucherNo, Narration,
																	IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo
																)
																values
																(
																	'#cocd#','DailyBenCl',0,#AMT#,
																	convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'Ben To Client Charge. No. of Inst. #TOTALTRANS#',
																	'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
																	1316
																)
														</CFQUERY>
														<cFIF STAX_BenToCl EQ 'Y' >
															<cfset amt1 =amt*Stax/100>
															<Cfset JVPost('#cocd#','#AcCode#','Def3_Daily','#amt1#','#TODATE#','S.Tax For Ben To Client Charge. No. of Inst. #TOTALTRANS#(#AcCode#)','#StYr#',1316)>
														</cFIF>
														#Sr#.  JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
													<cfset sr = SR+1>
												</cfif>
											</CFLOOP>
											<CFCATCH>
												#CFCATCH.Message##CFCATCH.Detail#<BR>
												<CFABORT>
											</CFCATCH>
											</CFTRY>
										</CFTRANSACTION>		
									<CFELSE>
										<FONT COLOR="FF0000">**No Charges Found In System Settings</FONT><BR>
									</CFIF>
						<CFELSE>
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
										Delete From FA_TRANSACTIONS
										where 
											cocd = '#cocd#'
										and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
										and FinStyr = #StYr#
										and BillNo = 1316
										and Trans_Type = 'J'
								</CFQUERY>
						</CFIF>
					</CFIF>
														
		<CFIF  IsDefined("BenToMkt")>
				<Cfif ProcessType eq 'P'>
						<CFQUERY name= "GetAccount" datasource="#Client.database#">
								SELECT * 
								FROM 
									fa_accountList
									where  ACCOUNTCODE = 'DailyBenMkt'	
									and    COcd = '#cocd#'
									and FinStyr = #StYr#
									and FinEndyr = #EndYr#
							</CFQUERY>
							<CFIF GetAccount.recordcount eq 0>
								<SCRIPT>
									alert('Please Create (DailyInterSett) Account IN #cocd#'); 
								</SCRIPT>
								<CFABORT>
							</CFIF>
						<CFQUERY NAME="CMC" datasource="#Client.database#">
							SELECT CLEARING_MEMBER_CODE,ISNULL(Ben_To_Mkt_Chgs,0) BentoMktChgs,
								   IsNull(Chags_Ben_List,'')Ben_List
							FROM SYSTEM_SETTINGS
							WHERE COMPANY_CODE = '#COCD#'
						</CFQUERY>
						<!--- <CFTRY>
							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								DROP TABLE ##MONTHLYDATA
							</CFQUERY>
							<CFCATCH>
							</CFCATCH>
						</CFTRY> --->
						<CFIF CMC.BentoMktChgs NEQ 0 AND Trim(CMC.Ben_List) NEQ "">
<!--- 							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								SELECT CLIENT_CODE,COUNT(*)TOTALTRANS
								INTO ##MONTHLYDATA
								FROM IO_TRANSACTIONS
								WHERE COCD = '#cocd#'
								AND TR_TYPE IN('BENTOPOOL')
								AND convert(datetime,VOUCHER_DATE,103) = convert(datetime,'#fromdate#',103)
								AND CLIENT_CODE NOT IN ('POOLIS','#CMC.CLEARING_MEMBER_CODE#')
								AND CLIENT_CODE  IN (SELECT DISTINCT CLIENT_ID FROM CLIENT_DETAILS  WHERE ISNULL(BenToMarket_Charge,'N') = 'Y' )
								AND DP_CLIENT_CODE NOT IN (SELECT DISTINCT CLIENT_DP_CODE
															FROM IO_DP_MASTER
															WHERE CLIENT_ID IN ('#Replace(CMC.Ben_List,",","','","All")#'))
								GROUP BY CLIENT_CODE
							</CFQUERY>

							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								SELECT CLIENT_CODE,SUM(TOTALTRANS) TOTALTRANS
								FROM ##MONTHLYDATA
								GROUP BY CLIENT_CODE
							</CFQUERY>
 --->						<CFSTOREDPROC PROCEDURE="BENIFICIARY_CHARGES" datasource="#Client.database#">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROMDATE" value="#FROMDATE#" null="No">
								<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TODATE" VALUE="#FROMDATE#" NULL="No">
								<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@RECORDTYPE" VALUE="2" NULL="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COCD" null="No" VALUE="#COCD#">
								
								<CFPROCRESULT NAME="GetData" RESULTSET="1">
							</CFSTOREDPROC>			
 									<CFTRANSACTION>
										<CFTRY>
											<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
												Delete From FA_TRANSACTIONS
												where 
													cocd = '#cocd#'
												and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
												and FinStyr = #StYr#
												and BillNo = 1315
												and Trans_Type = 'J'
											</CFQUERY>
											<cfset sr = 1>
											<FONT COLOR="red">**Process Ben To Market Start(Per Instruction Charges:#CMC.BentoMktChgs#)</FONT>	<BR>
											
											<CFQUERY NAME="ConDate" datasource="#Client.database#">
												Select DateName(MM,Month(Convert(Datetime, '#FromDate#', 103)))Month, Year(Convert(Datetime, '#FromDate#', 103))Year
											</CFQUERY>
											
											<CFLOOP QUERY="GETDATA">
												<cfset AcCode =CLIENT_CODE>
												<cfset AMT = CHARGESTODEBIT>	
												<!--- <cfset AMT = TOTALTRANS*CMC.BentoMktChgs> --->
																
												<cfif AMT  GT #MaxAmount#>
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
																convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'Ben To Market Charge. No. of Inst. #TOTALTRANS#',
																'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
																1315
															)
													</CFQUERY>
													
													<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
															INSERT INTO FA_TRANSACTIONS
															(
																COcd, AccountCode,Dr_amt, Cr_amt,
																VoucherDate,  Trans_Type, VoucherNo, Narration,
																IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo
															)
															values
															(
																'#cocd#','DailyBenMkt',0,#AMT#,
																convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'Ben To Market Charge. No. of Inst. #TOTALTRANS#',
																'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
																1315
															)
													</CFQUERY>		
													<cFIF BenToMkt EQ 'Y' >
														<cfset amt1 =amt*Stax/100>
														<Cfset JVPost('#cocd#','#AcCode#','Def3_Daily','#amt1#','#TODATE#','S.Tax For Ben To Market Charge. No. of Inst. #TOTALTRANS#(#AcCode#)','#StYr#',1315)>
													</cFIF>
													#Sr#.  JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
													<cfset sr = SR+1>
												</cfif>
											</CFLOOP>
											<CFCATCH>
												#CFCATCH.Message##CFCATCH.Detail#<BR>
												<CFABORT>
											</CFCATCH>
											</CFTRY>
										</CFTRANSACTION>		
								<CFELSE>
									<FONT COLOR="FF0000">**No Charges Found In System Settings		</FONT><BR>
								</CFIF>
						<CFELSE>
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
										Delete From FA_TRANSACTIONS
										where 
											cocd = '#cocd#'
										and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
										and FinStyr = #StYr#
										and BillNo = 1315
										and Trans_Type = 'J'
								</CFQUERY>
						</CFIF>
					</CFIF>

		<CFIF  IsDefined("BenInwardChgs")>
			<Cfif ProcessType eq 'P'>
				<CFQUERY name= "GetAccount" datasource="#Client.database#">
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'DailyBenInward'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create (DailyBenInward) Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					<CFQUERY NAME="CMC" datasource="#Client.database#">
						SELECT CLEARING_MEMBER_CODE,ISNULL(BenInward_Chgs_Fixed,0) BentoMktChgs,
							   IsNull(BenInward_Chgs_Ben,'')Ben_List
						FROM SYSTEM_SETTINGS
						WHERE COMPANY_CODE = '#COCD#'
					</CFQUERY>
					<CFIF CMC.BentoMktChgs NEQ 0 AND Trim(CMC.Ben_List) NEQ "">
					<CFSTOREDPROC PROCEDURE="BENIFICIARY_CHARGES" datasource="#Client.database#">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROMDATE" value="#FROMDATE#" null="No">
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TODATE" VALUE="#FROMDATE#" NULL="No">
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@RECORDTYPE" VALUE="3" NULL="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COCD" null="No" VALUE="#COCD#">
						
						<CFPROCRESULT NAME="GetData" RESULTSET="1">
					</CFSTOREDPROC>			
					<CFTRANSACTION>
						<CFTRY>
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
								Delete From FA_TRANSACTIONS
								where 
									cocd = '#cocd#'
								and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
								and FinStyr = #StYr#
								and BillNo = 13115
								and Trans_Type = 'J'
							</CFQUERY>
							<cfset sr = 1>
							<FONT COLOR="red">**Process Ben To Market Start(Per Instruction Charges:#CMC.BentoMktChgs#)</FONT>	<BR>
							
							<CFQUERY NAME="ConDate" datasource="#Client.database#">
								Select DateName(MM,Month(Convert(Datetime, '#FromDate#', 103)))Month, Year(Convert(Datetime, '#FromDate#', 103))Year
							</CFQUERY>

							<CFLOOP QUERY="GETDATA">
								<cfset AcCode =CLIENT_CODE>
								<cfset AMT = CHARGESTODEBIT>	
									<cfif AMT  GT #MaxAmount#>
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
													convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'Ben Inward Charge. No. of Inst. #TOTALTRANS#',
													'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
													13115
												)
										</CFQUERY>
										
										<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
												INSERT INTO FA_TRANSACTIONS
												(
													COcd, AccountCode,Dr_amt, Cr_amt,
													VoucherDate,  Trans_Type, VoucherNo, Narration,
													IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo
												)
												values
												(
													'#cocd#','DailyBenInward',0,#AMT#,
													convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'Ben Inward Charge. No. of Inst. #TOTALTRANS#',
													'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
													13115
												)
										</CFQUERY>		
										<cFIF BenInwardChgs EQ 'Y' >
											<cfset amt1 =amt*Stax/100>
											<Cfset JVPost('#cocd#','#AcCode#','Def3_Daily','#amt1#','#TODATE#','S.Tax For Ben Inward Charge. No. of Inst. #TOTALTRANS#(#AcCode#)','#StYr#',13115)>
										</cFIF>
										#Sr#.  JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
										<cfset sr = SR+1>
									</cfif>
								</CFLOOP>
								<CFCATCH>
									#CFCATCH.Message##CFCATCH.Detail#<BR>
									<CFABORT>
								</CFCATCH>
								</CFTRY>
							</CFTRANSACTION>		
					<CFELSE>
						<FONT COLOR="FF0000">**No Charges Found In System Settings		</FONT><BR>
					</CFIF>
				<CFELSE>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
							Delete From FA_TRANSACTIONS
							where 
								cocd = '#cocd#'
							and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
							and FinStyr = #StYr#
							and BillNo = 13115
							and Trans_Type = 'J'
					</CFQUERY>
				</CFIF>
			</CFIF>
		
		
		<CFIF  IsDefined("InterSettlement")>
				<Cfif ProcessType eq 'P'>
						<CFQUERY name= "GetAccount" datasource="#Client.database#">
								SELECT * 
								FROM 
									fa_accountList
									where  ACCOUNTCODE = 'DailyInterSett'	
									and    COcd = '#cocd#'
									and FinStyr = #StYr#
									and FinEndyr = #EndYr#
							</CFQUERY>
							<CFIF GetAccount.recordcount eq 0>
								<SCRIPT>
									alert('Please Create (DailyInterSett) Account IN #cocd#'); 
								</SCRIPT>
								<CFABORT>
							</CFIF>
						<CFQUERY NAME="CMC" datasource="#Client.database#">
							SELECT CLEARING_MEMBER_CODE,ISNULL(iNTER_sETL_cHGS,0) iNTER_sETL_cHGS,ISNULL(IntersettlementPer,'0')  IntersettlementPer
							 FROM SYSTEM_SETTINGS
							WHERE COMPANY_CODE = '#COCD#'
							
						</CFQUERY>
						<!--- <CFTRY>
							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								DROP TABLE ##MONTHLYDATA
							</CFQUERY>
							<CFCATCH>
							</CFCATCH>
						</CFTRY> --->
						<CFIF CMC.iNTER_sETL_cHGS NEQ 0>
							<!--- <CFQUERY NAME="GETDATA" datasource="#Client.database#">
										SELECT CLIENT_CODE,COUNT(*) TOTALTRANS
										INTO ##MONTHLYDATA
										FROM IO_TRANSACTIONS
										WHERE COCD = '#COCD#'
										AND TR_TYPE IN('INTERSETL')
										AND CLIENT_CODE NOT IN ('POOLIS','#CMC.CLEARING_MEMBER_CODE#')
										AND CLIENT_CODE  IN (SELECT DISTINCT CLIENT_ID FROM CLIENT_DETAIL_VIEW  WHERE ISNULL(INTER_SETTLEMENT_CHARGE,'N') = 'Y' AND COMPANY_CODE = '#COCD#')
										AND DEBIT_QTY > 0 
										AND convert(datetime,VOUCHER_DATE,103) = convert(datetime,'#fromdate#',103)
										GROUP BY CLIENT_CODE
							</CFQUERY>
									
							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								SELECT CLIENT_CODE,SUM(TOTALTRANS) TOTALTRANS
								FROM ##MONTHLYDATA
								GROUP BY CLIENT_CODE
							</CFQUERY> --->
							
							<CFSTOREDPROC PROCEDURE="IO_INTERSETTLE_CHARGES" datasource="#Client.database#">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROMDATE" value="#FROMDATE#" null="No">
								<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TODATE" VALUE="#FROMDATE#" NULL="No">
								<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@RECORDTYPE" VALUE="1" NULL="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COCD" null="No" VALUE="#COCD#">
								
								<CFPROCRESULT NAME="GetData" RESULTSET="1">
							</CFSTOREDPROC>
							<CFTRANSACTION>
								<CFTRY>
									<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
										Delete From FA_TRANSACTIONS
										where 
											cocd = '#cocd#'
										and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
										and FinStyr = #StYr#
										and BillNo = 1313
										and Trans_Type = 'J'
									</CFQUERY>
									<cfset sr = 1>
									<FONT COLOR="red">**Process InterSettlement Start(Per Instruction Charges:#CMC.iNTER_sETL_cHGS# / #CMC.IntersettlementPer#)</FONT>	<BR>
									
									<CFQUERY NAME="ConDate" datasource="#Client.database#">
										Select DateName(MM,Month(Convert(Datetime, '#FromDate#', 103)))Month, Year(Convert(Datetime, '#FromDate#', 103))Year
									</CFQUERY>
									
									<CFLOOP QUERY="GETDATA">
										<cfset AcCode =CLIENT_CODE>
										<!--- <cfset AMT = TOTALTRANS*CMC.iNTER_sETL_cHGS> --->
										<cfset AMT = CHARGESTODEBIT>
													
										<cfif AMT  GT #MaxAmount#>
														
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
														convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'Intersettl Charge. No. of Inst. #TOTALTRANS#',
														'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
														1313
												)
										</CFQUERY>		
										<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
												INSERT INTO FA_TRANSACTIONS
												(
													COcd, AccountCode,Dr_amt, Cr_amt,
													VoucherDate,  Trans_Type, VoucherNo, Narration,
													IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo
												)
												values
												(
														'#cocd#','DailyInterSett',0,#AMT#,
														convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'Intersettl Charge. No. of Inst. #TOTALTRANS#',
														'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
														1313
												)
												
										</CFQUERY>		
										<cFIF InterSettlement EQ 'Y' >	
											<cfset amt1 =amt*Stax/100>
											<Cfset JVPost('#cocd#','#AcCode#','Def3_Daily','#amt1#','#TODATE#','S.Tax For Intersettl Charge. No. of Inst. #TOTALTRANS#(#AcCode#)','#StYr#',1313)>
										</cFIF>
										#Sr#.  JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
										<cfset sr = SR+1>
										</cfif>
									</CFLOOP>
										
									<CFCATCH>
										#CFCATCH.Message##CFCATCH.Detail#<BR>
										<CFABORT>
									</CFCATCH>
								</CFTRY>
							</CFTRANSACTION>		
								<CFELSE>
									<FONT COLOR="FF0000">**No Charges Found In System Settings		</FONT><BR>
								</CFIF>
						<CFELSE>
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
										Delete From FA_TRANSACTIONS
										where 
											cocd = '#cocd#'
										and VoucherDate = Convert(DATETIME,'#FROMDATE#',103)
										and FinStyr = #StYr#
										and BillNo = 1313
										and Trans_Type = 'J'
								</CFQUERY>
						</CFIF>
					</CFIF>
		
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
					
					<CFQUERY NAME="GETCLIENT" datasource="#Client.database#">
						EXEC [FA_INTERESTCAL] '#FROMDATE#','#TODATE#',#StYr#,'#COCD#','','','#CLIENTlIST#','N','N','Y','Y',12,'N','N',0,0,0,0,1,'N',0,#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#
					</CFQUERY>
					
					<CFQUERY NAME="CLIENTDATA" datasource="#Client.database#">
						SELECT ACCOUNTCODE,MAX(AccountName) AccountName,SUM(DRINTEREST) DRINTEREST,max(INTERESTRATE) INTERESTRATE
						 FROM ####FAINTEREST
						GROUP BY ACCOUNTCODE
						having SUM(DRINTEREST) <> 0
							   AND SUM(DRINTEREST) > <CFIF  IsDefined("MaxAmount")>#val(MaxAmount)#<CFELSE>0</CFIF> 	
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
								and BillNo = 1312
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
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'By Daily Process From #FromDate# To #Todate# Of Interest Rate #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1312
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
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Daily Process From #FromDate# To #Todate# Of Interest Rate #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1312
									)
									
							</CFQUERY>		
							#Sr#. JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
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
						and BillNo = 1312
						and Trans_Type = 'J'
					</CFQUERY>
			</Cfif>
		</CFIF>
		
		
</CFIF>
</DIV>

	<CFFORM NAME="MonthlyProcess" ACTION="FrmDailyProcess.cfm" METHOD="POST">
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
			<tr>
				<td  ALIGN="RIGHT"  WIDTH="50%" CLASS="clsLabel">
				<FONT CLASS="clsLabel">&nbsp;Amount Above:&nbsp;</FONT>	
				</td>
				<td  ALIGN="left" WIDTH="50%" CLASS="clsLabel">
				<INPUT TYPE="text" NAME="MaxAmount" class="StyleTextBox" SIZE="5" VALUE="0" >
				<CFIF IsDefined("MaxAmount")>
						<SCRIPT>
							MonthlyProcess.MaxAmount.value=#val(MaxAmount)#;
						</SCRIPT>
				</CFIF>
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
			<tr>
				<td  ALIGN="RIGHT"  WIDTH="50%" CLASS="clsLabel">&nbsp;
					
			 	</td>
				<td  ALIGN="LEFT" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="InterSettlement" CLASS="StyleCheckBox"<cfif IsDefined("InterSettlement")>checked</cfif> >InterSettlement
			  	</td>
			<tr>
				<td  ALIGN="RIGHT"  WIDTH="50%" CLASS="clsLabel">&nbsp;
					
			 	</td>
				<td  ALIGN="LEFT" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="BenToMkt" CLASS="StyleCheckBox"<cfif IsDefined("BenToMkt")>checked</cfif> >Ben To Mkt
			  	</td>
			</tr>
			<Tr>
				<td  ALIGN="RIGHT"  WIDTH="50%" CLASS="clsLabel">&nbsp;
					
			 	</td>
				<td  ALIGN="LEFT" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="BenToCl" CLASS="StyleCheckBox"<cfif IsDefined("BenToCl")>checked</cfif> >Ben To Client
			  	</td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" WIDTH="50%" CLASS="clsLabel">&nbsp;</td>
				<td  ALIGN="LEFT" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="BenInwardChgs" CLASS="StyleCheckBox">Ben Inward Charges
			  </td>
			</tr>
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
