<cfinclude template="/focaps/help.cfm">
<HTML>
<HEAD>
<TITLE>Monthly Process</TITLE>
<LINK href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
<LINK href="../../CSS/style1.css" rel="stylesheet" type="text/css">
</HEAD>
<CFOUTPUT>
<BODY CLASS="StyleBody">
<DIV STYLE="top:64%;LEFT:50%;width:50%;height:36%;position:absolute;overflow:auto" >
<TABLE CLASS="StyleCommonMastersTable">
	<tr>
		<td >
			<U><i>*Monthly Process Description.</i></U>
		</td>
	</tr>
	<tr>
		<td >
			1. For Late Payment Charges <FONT COLOR="red"> <U>Monthly Late Payment Chrg</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			2. In Late Payment Charges  Calculation Only Debit Interest Consider
		</td>
	</tr>
	<tr>
		<td >
			3. Interest Rate Defien In Client Master(Other Then Zero)
		</td>
	</tr>
	<tr>
		<td >
			4. For InterSettlment Process<FONT COLOR="red"> <U>MonthlyInterSett</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			5. For Ben To Market Process<FONT COLOR="red"> <U>MonthlyBenMkt</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			6. For Ben To Client Process<FONT COLOR="red"> <U>MonthlyBenCl</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			7. Per Instruction Charges Of InterSettlment Defien In System Settings
		</td>
	</tr>
	<tr>
		<td >
			8. Which Client Apply Instruction Charges, That Defiend In Client Master
		</td>
	</tr>
	<tr>
		<td >
			9. For IBT Charges <FONT COLOR="red"> <U>MonthlyBrkChgs,MonthlyIBTSoftChgs,MonthlyIBTSubChgs</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			10. For IBT Charges <FONT COLOR="red"> <U>MonthlyBrBrkChgs,MonthlyBrIBTSoftChgs,MonthlyBRIBTSubChgs</U></FONT> Account Required In Fa
		</td>
	</tr>
	<tr>
		<td >
			11. For SMS Charges <FONT COLOR="red"> <U>SMSCharges</U></FONT> Account Required In Fa
		</td>
	</tr>
</TABLE>
</DIV>

<DIV STYLE="top:50%;LEFT:0;width:50%;height:50%;position:absolute;overflow:auto" >
<CFIF IsDefined("Process1") and Process1 eq 1>
		<cfquery name="GETSYSTEMSETINGS" datasource="#CLIENT.DATABASE#"	>
			SELECT ISNULL(CostCenterInProcess,'') CostCenterInProcess,ISNULL(SubCostCenterInProcess,'N') SubCostCenterInProcess
			FROM SYSTEM_SETTINGS
		</cfquery>
		<CFSET CostCenterInProcess123 = "#GETSYSTEMSETINGS.CostCenterInProcess#">
		<CFSET SubCostCenterInProcess123 = "#GETSYSTEMSETINGS.SubCostCenterInProcess#">		
		<CFIF SubCostCenterInProcess123 EQ "Y">
			<CFSET SUBCATEGORY = "HOLDCHG">
		<cfelse>
			<CFSET SUBCATEGORY = "">
		</CFIF>
			
		<cFIF Month1 GTE 4 AND Month1 LTE 12>
				<Cfset Year1 = '#StYr#'>
		<CFELSE>		
				<Cfset Year1 = '#EndYr#'>
		</cFIF>
		<cFSET FROM = CreateDate(YEAR1,MONTH1,1)>
		<cFSET Month1 = NumberFormat(Month1,00)>
		<CFSET FROMDATE = '01/#Month1#/#YEAR1#'>
		<CFSET TODATE = '#DaysInMonth(FROM)#/#Month1#/#YEAR1#'>

		<CFIF  IsDefined("BenToCl")>
				<Cfif ProcessType eq 'P'>
						<CFQUERY name= "GetAccount" datasource="#Client.database#">
								SELECT * 
								FROM 
									fa_accountList
									where  ACCOUNTCODE = 'MonthlyBenCl'	
									and    COcd = '#cocd#'
									and FinStyr = #StYr#
									and FinEndyr = #EndYr#
							</CFQUERY>
							<CFIF GetAccount.recordcount eq 0>
								<SCRIPT>
									alert('Please Create (MonthlyBenCl) Account IN #cocd#'); 
								</SCRIPT>
								<CFABORT>
							</CFIF>
						<CFQUERY NAME="CMC" datasource="#Client.database#">
							SELECT CLEARING_MEMBER_CODE,ISNULL(Ben_To_Cl_Chrgs,0) BentoClChrgs,
								    ISNULL(Chags_Ben_List,'')Ben_List,ISNULL(BenOutWard_Chgs_Per,'') BenOutWard_Chgs_Per,
									ISNULL(BenOutward_Chgs_Opt,'') BenOutward_Chgs_Opt
							FROM SYSTEM_SETTINGS
							WHERE COMPANY_CODE = '#COCD#'
						</CFQUERY>
						<CFTRY>
							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								DROP TABLE ##MONTHLYDATA
							</CFQUERY>
							<CFCATCH>
							</CFCATCH>
						</CFTRY>
						
						<CFIF CMC.BentoClChrgs NEQ 0 AND Trim(CMC.Ben_List) NEQ "">
									<CFQUERY NAME="GETDATA" datasource="#Client.database#">
										SELECT CLIENT_ID AS CLIENT_CODE, COUNT(*)TOTALTRANS
										INTO ##MONTHLYDATA
										FROM BEN_TRANSACTIONS
										WHERE CONVERT(DATETIME,VOUCHER_DATE,103) >= CONVERT(DATETIME,'#FROMDATE#',103)
										AND CONVERT(DATETIME,VOUCHER_DATE,103)<= CONVERT(DATETIME,'#TODATE#',103)
										AND RECEIPT_QTY > 0
										AND ISNULL(MKT_TYPE,'') = ''
										AND ISNULL(SETTLEMENT_NO,0) = 0
										AND CLIENT_ID NOT IN (SELECT DISTINCT CLIENT_ID FROM
															  IO_DP_MASTER WHERE CLIENT_NATURE = 'B'
															  AND ISNULL(ASS_CLIENT_ID,'') = CLIENT_ID)
										AND CLIENT_ID  IN (SELECT DISTINCT CLIENT_ID FROM CLIENT_DETAILS  WHERE ISNULL(BenToClient_Charge,'N') = 'Y' )
										AND COUNTER_CLIENT_ID IN ('#Replace(CMC.Ben_List,",","','","All")#')
										GROUP BY CLIENT_ID
									</CFQUERY>
	
									<CFQUERY NAME="GETDATA" datasource="#Client.database#">
										SELECT CLIENT_CODE,SUM(TOTALTRANS) TOTALTRANS
										FROM ##MONTHLYDATA
										GROUP BY CLIENT_CODE
									</CFQUERY>
									
									<!--- <CFTRANSACTION>
										<CFTRY> --->
											<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
												Delete From FA_TRANSACTIONS
												where 
													cocd = '#cocd#'
												and month(VoucherDate) = #month1#
												and FinStyr = #StYr#
												and BillNo = 1401
												and Trans_Type = 'J'
											</CFQUERY>
												<cfset sr = 1>
												<FONT COLOR="red">**Process Ben To Client Start(Per Instruction Charges:#CMC.BentoClChrgs#)</FONT>	<BR>
												
												<CFQUERY NAME="ConDate" datasource="#Client.database#">
													Select DateName(Month,Convert(Datetime, '#FromDate#', 103))Month, Year(Convert(Datetime, '#FromDate#', 103))Year
												</CFQUERY>
												
												<CFLOOP QUERY="GETDATA">
												
													<cfset AcCode =CLIENT_CODE>
													<Cfset Clcode ='MonthlyBenCl'>
													<cfquery datasource="#Client.database#" name="GetBrCode">
														SELECT B.*
														FROM CLIENTDETAILVIEW A,BRANCH_MASTER B
														WHERE A.BRANCH_CODE = B.BRANCH_CODE
														AND A.COMPANY_CODE ='#COCD#'
														AND B.BENTOMARKETCR ='Y'
														AND ISNULL(BRANCHCLIENTID,'') != ''
													</cfquery>
													<cfquery datasource="#Client.database#" name="GetBrCode1">
														SELECT <CFIF CostCenterInProcess123 EQ "MainBrCode">
															ISNULL(MAIN_BRANCH_CODE,BRANCH_CODE)
														<cfelseif CostCenterInProcess123 EQ "MasterBrCode">
															ISNULL(MASTER_BRANCH_CODE,BRANCH_CODE)
														<cfelseif CostCenterInProcess123 EQ "RegionBrCode">	
															ISNULL(REGION_BRANCH_CODE,BRANCH_CODE)
														<cfelse>	
															''
														</CFIF>COSTCENTER
														FROM CLIENTDETAILVIEW 
														WHERE
															COMPANY_CODE ='#COCD#'
														AND CLIENT_ID = '#CLIENT_CODE#'
													</cfquery>
													<CFSET COSTCENTER =  "#GetBrCode1.COSTCENTER#">
													<Cfif GetBrCode.recordcount gt 0>
														<Cfset Clcode= GetBrCode.branchclientid>
													</Cfif>
													<cfset AMT = TOTALTRANS*CMC.BentoClChrgs>
													
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
																					convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'Ben To Client Charge for #Left(ConDate.Month,3)#-#Right(ConDate.Year,2)# No. of Inst. #TOTALTRANS# @ #CMC.BentoClChrgs#',
																					'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
																					1401
																			)
																	</CFQUERY>		
																	<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
																			INSERT INTO FA_TRANSACTIONS
																			(
																				COcd, AccountCode,Dr_amt, Cr_amt,
																				VoucherDate,  Trans_Type, VoucherNo, Narration,
																				IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
																				BRANCH_ID,TRANSACTION_TYPE
																			)
																			values
																			(
																				'#cocd#','#Clcode#',0,#AMT#,
																				convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'Ben To Client for #Left(ConDate.Month,3)#-#Right(ConDate.Year,2)# No. of Inst. #TOTALTRANS# @ #CMC.BentoClChrgs#',
																				'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
																				1401,'#COSTCENTER#','#SUBCATEGORY#'
																			)
																	</CFQUERY>		
																	#Sr#.  JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
													<cfset sr = SR+1>
												</CFLOOP>
												<!--- <CFCATCH>
													#CFCATCH.Message##CFCATCH.Detail#<BR>
													<CFABORT>
												</CFCATCH>
										</CFTRY>
									</CFTRANSACTION>		 --->
						<CFELSE>
							<FONT COLOR="FF0000">**No Charges Found In System Settings		</FONT><BR>
						</CFIF>
			<CFELSE>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
							Delete From FA_TRANSACTIONS
							where 
								cocd = '#cocd#'
							and month(VoucherDate) = #month1#
							and FinStyr = #StYr#
							and BillNo = 1401
							and Trans_Type = 'J'
					</CFQUERY>
			</CFIF>
		</CFIF>
		
		<cfinclude template="smspOST.CFM">
		
		<CFIF  IsDefined("BenToMkt")>
				<Cfif ProcessType eq 'P'>
						<CFQUERY name= "GetAccount" datasource="#Client.database#">
								SELECT * 
								FROM 
									fa_accountList
									where  ACCOUNTCODE = 'MonthlyBenMkt'	
									and    COcd = '#cocd#'
									and FinStyr = #StYr#
									and FinEndyr = #EndYr#
							</CFQUERY>
							<CFIF GetAccount.recordcount eq 0>
								<SCRIPT>
									alert('Please Create (MonthlyBenMkt) Account IN #cocd#'); 
								</SCRIPT>
								<CFABORT>
							</CFIF>
						<CFQUERY NAME="CMC" datasource="#Client.database#">
							SELECT CLEARING_MEMBER_CODE,ISNULL(Ben_To_Mkt_Chgs,0) BentoMktChgs,
								   ISNULL(Chags_Ben_List,'')Ben_List
							FROM SYSTEM_SETTINGS
							WHERE COMPANY_CODE = '#COCD#'
						</CFQUERY>
						<CFTRY>
							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								DROP TABLE ##MONTHLYDATA
							</CFQUERY>
							<CFCATCH>
							</CFCATCH>
						</CFTRY>
						
						<CFIF CMC.BentoMktChgs NEQ 0 AND Trim(CMC.Ben_List) NEQ "">
									<CFQUERY NAME="GETDATA" datasource="#Client.database#">
										SELECT CLIENT_CODE,COUNT(*)TOTALTRANS
										INTO ##MONTHLYDATA
										FROM IO_TRANSACTIONS
										WHERE COCD = '#COCD#'
										AND TR_TYPE IN('BENTOPOOL')
										AND convert(datetime,VOUCHER_DATE,103) >= convert(datetime,'#fromdate#',103)
										AND convert(datetime,VOUCHER_DATE,103)<= convert(datetime,'#TODATE#',103)
										AND CLIENT_CODE NOT IN ('POOLIS','#CMC.CLEARING_MEMBER_CODE#')
										AND CLIENT_CODE  IN (SELECT DISTINCT CLIENT_ID FROM CLIENT_DETAILS  WHERE ISNULL(BenToMarket_Charge,'N') = 'Y' )
										AND DP_CLIENT_CODE  IN (SELECT DISTINCT CLIENT_DP_CODE
																	FROM IO_DP_MASTER
																	WHERE CLIENT_ID IN ('#Replace(CMC.Ben_List,",","','","All")#'))
										GROUP BY CLIENT_CODE
									</CFQUERY>
	
									<CFQUERY NAME="GETDATA" datasource="#Client.database#">
												SELECT CLIENT_CODE,SUM(TOTALTRANS) TOTALTRANS
												FROM ##MONTHLYDATA
												GROUP BY CLIENT_CODE
									</CFQUERY>
									
									<CFTRANSACTION>
										<CFTRY>
												<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
																Delete From FA_TRANSACTIONS
																where 
																	cocd = '#cocd#'
																and month(VoucherDate) = #month1#
																and FinStyr = #StYr#
																and BillNo = 1400
																and Trans_Type = 'J'
												</CFQUERY>
												<cfset sr = 1>
												<FONT COLOR="red">**Process Ben To Market Start(Per Instruction Charges:#CMC.BentoMktChgs#)</FONT>	<BR>
												
												<CFQUERY NAME="ConDate" datasource="#Client.database#">
													Select DateName(Month,Convert(Datetime, '#FromDate#', 103))Month, Year(Convert(Datetime, '#FromDate#', 103))Year
												</CFQUERY>
												
												<CFLOOP QUERY="GETDATA">
													<cfquery datasource="#Client.database#" name="GetBrCode1">
														SELECT <CFIF CostCenterInProcess123 EQ "MainBrCode">
															ISNULL(MAIN_BRANCH_CODE,BRANCH_CODE)
														<cfelseif CostCenterInProcess123 EQ "MasterBrCode">
															ISNULL(MASTER_BRANCH_CODE,BRANCH_CODE)
														<cfelseif CostCenterInProcess123 EQ "RegionBrCode">	
															ISNULL(REGION_BRANCH_CODE,BRANCH_CODE)
														<cfelse>	
															''
														</CFIF>COSTCENTER
														FROM CLIENTDETAILVIEW 
														WHERE
															COMPANY_CODE ='#COCD#'
														AND CLIENT_ID = '#CLIENT_CODE#'
													</cfquery>
													<CFSET COSTCENTER =  "#GetBrCode1.COSTCENTER#">
															
													<cfset AcCode =CLIENT_CODE>
													<cfset AMT = TOTALTRANS*CMC.BentoMktChgs>
													
													<CFQUERY NAME="SelectVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
																select  DBO.[GETLATESTVOUCEHRNO]('#cocd#',#StYr#,'J','','#TODATE#','') TXTVOUCHERNO
													</CFQUERY>	
																	<CFSET TXTVOUCHERNO=#SelectVoucherNo.TXTVOUCHERNO#>		
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
																					convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'Ben To Market Charge for #Left(ConDate.Month,3)#-#Right(ConDate.Year,2)# No. of Inst. #TOTALTRANS# @ #CMC.BentoMktChgs#',
																					'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
																					1400
																			)
																	</CFQUERY>		
																	<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
																			INSERT INTO FA_TRANSACTIONS
																			(
																				COcd, AccountCode,Dr_amt, Cr_amt,
																				VoucherDate,  Trans_Type, VoucherNo, Narration,
																				IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
																				BRANCH_ID,TRANSACTION_TYPE
																			)
																			values
																			(
																				'#cocd#','MonthlyBenMkt',0,#AMT#,
																				convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'Ben To Market for #Left(ConDate.Month,3)#-#Right(ConDate.Year,2)# No. of Inst. #TOTALTRANS# @ #CMC.BentoMktChgs#',
																				'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
																				1400,'#COSTCENTER#','#SUBCATEGORY#'
																			)
																	</CFQUERY>		
																	#Sr#.  JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
													<cfset sr = SR+1>
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
							and month(VoucherDate) = #month1#
							and FinStyr = #StYr#
							and BillNo = 1400
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
									where  ACCOUNTCODE = 'MonthlyInterSett'	
									and    COcd = '#cocd#'
									and FinStyr = #StYr#
									and FinEndyr = #EndYr#
							</CFQUERY>
							<CFIF GetAccount.recordcount eq 0>
								<SCRIPT>
									alert('Please Create (MonthlyInterSett) Account IN #cocd#'); 
								</SCRIPT>
								<CFABORT>
							</CFIF>
						<CFQUERY NAME="CMC" datasource="#Client.database#">
							SELECT CLEARING_MEMBER_CODE,ISNULL(iNTER_sETL_cHGS,0) iNTER_sETL_cHGS
							 FROM SYSTEM_SETTINGS
							WHERE COMPANY_CODE = '#COCD#'
						</CFQUERY>
						<CFTRY>
							<CFQUERY NAME="GETDATA" datasource="#Client.database#">
								DROP TABLE ##MONTHLYDATA
							</CFQUERY>
							<CFCATCH>
							</CFCATCH>
						</CFTRY>
						
						<CFIF CMC.iNTER_sETL_cHGS NEQ 0>
									<CFQUERY NAME="GETDATA" datasource="#Client.database#">
												SELECT CLIENT_CODE,COUNT(*) TOTALTRANS
												INTO ##MONTHLYDATA
												FROM IO_TRANSACTIONS
												WHERE COCD = '#COCD#'
												AND TR_TYPE IN('INTERSETL')
												AND CLIENT_CODE NOT IN ('POOLIS','#CMC.CLEARING_MEMBER_CODE#')
												AND CLIENT_CODE  IN (SELECT DISTINCT CLIENT_ID FROM CLIENT_DETAIL_VIEW  WHERE ISNULL(INTER_SETTLEMENT_CHARGE,'N') = 'Y' AND COMPANY_CODE = '#COCD#')
												AND DEBIT_QTY > 0 
												AND convert(datetime,VOUCHER_DATE,103) >= convert(datetime,'#fromdate#',103)
												AND convert(datetime,VOUCHER_DATE,103)<= convert(datetime,'#TODATE#',103)
												GROUP BY CLIENT_CODE
									</CFQUERY>
	
									<CFQUERY NAME="GETDATA" datasource="#Client.database#">
												SELECT CLIENT_CODE,SUM(TOTALTRANS) TOTALTRANS
												FROM ##MONTHLYDATA
												GROUP BY CLIENT_CODE
									</CFQUERY>
									
									<CFTRANSACTION>
										<CFTRY>
												<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
																Delete From FA_TRANSACTIONS
																where 
																	cocd = '#cocd#'
																and month(VoucherDate) = #month1#
																and FinStyr = #StYr#
																and BillNo = 1307
																and Trans_Type = 'J'
												</CFQUERY>
												<cfset sr = 1>
												<FONT COLOR="red">**Process InterSettlement Start(Per Instruction Charges:#CMC.iNTER_sETL_cHGS#)</FONT>	<BR>
												
												<CFQUERY NAME="ConDate" datasource="#Client.database#">
													Select DateName(Month,Convert(Datetime, '#FromDate#', 103))Month, Year(Convert(Datetime, '#FromDate#', 103))Year
												</CFQUERY>
												
												<CFLOOP QUERY="GETDATA">
												
																	<cfset AcCode =CLIENT_CODE>
																	<cfset AMT = TOTALTRANS*CMC.iNTER_sETL_cHGS>
																	
																	<CFQUERY NAME="SelectVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
																				select  DBO.[GETLATESTVOUCEHRNO]('#cocd#',#StYr#,'J','','#TODATE#','') TXTVOUCHERNO
																	</CFQUERY>	
																	<CFSET TXTVOUCHERNO=#SelectVoucherNo.TXTVOUCHERNO#>		
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
																					convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'Intersettl Charge for #Left(ConDate.Month,3)#-#Right(ConDate.Year,2)# No. of Inst. #TOTALTRANS# @ #CMC.iNTER_sETL_cHGS#',
																					'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
																					1307
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
																					'#cocd#','MonthlyInterSett',0,#AMT#,
																					convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'Intersettl Charge for #Left(ConDate.Month,3)#-#Right(ConDate.Year,2)# No. of Inst. #TOTALTRANS# @ #CMC.iNTER_sETL_cHGS#',
																					'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
																					1307
																			)
																			
																	</CFQUERY>		
																	#Sr#.  JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
													<cfset sr = SR+1>
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
							and month(VoucherDate) = #month1#
							and FinStyr = #StYr#
							and BillNo = 1307
							and Trans_Type = 'J'
					</CFQUERY>
			</CFIF>
		</CFIF>
		
		<CFIF  IsDefined("Interest")>
			<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
				SELECT DISTINCT CLIENT_ID FROM CLIENT_DETAIL_VIEW
				WHERE ISNULL(DR_INTEREST,0) <> 0
				AND COMPANY_CODE = '#COCD#'
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
							where  ACCOUNTCODE = 'MonthlyInterst'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create (MonthlyInterst) Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					
					<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
						EXEC [FA_INTERESTCAL] '#FROMDATE#','#TODATE#',#StYr#,'#COCD#','','','#CLIENTlIST#','N','N','Y','Y',12,'N','N',0,0,0,0,1
						,'N',0,#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#
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
								and month(VoucherDate) = #month1#
								and FinStyr = #StYr#
								and BillNo = 1308
								and Trans_Type = 'J'
					</CFQUERY>
					<cfset sr = 1>
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
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# For Late Payment Charges @ #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1308
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
											'#cocd#','MonthlyInterst',0,#AMT#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# For Late Payment Charges @ #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1308
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
						and month(VoucherDate) = #month1#
						and FinStyr = #StYr#
						and BillNo = 1308
						and Trans_Type = 'J'
					</CFQUERY>
			</Cfif>
		</CFIF>

		<CFIF  IsDefined("BranchMnthlyProcess")>
			<Cfif ProcessType eq 'P'>
					<cfquery name="GetBranchMnthlyProcess" datasource="#Client.database#">
						EXEC BRANCHEXPENSECHARGE '#FROMDATE#','#TODATE#',#StYr#,'#COCD#','#PostingDate#'
					</cfquery>
			<cfelse>
				<cfquery name="TODELETEDATA" datasource="#CLIENT.DATABASE#">
					DELETE FA_TRANSACTIONS
					WHERE BILLNO = '987654'
					AND VOUCHERDATE = CONVERT(DATETIME,'#PostingDate#',103)
					AND FINSTYR = #StYr#
				</cfquery>
			</Cfif>
		</CFIF>
		
		
		
		
		
		<CFIF  IsDefined("IBTMonthlyExp")>
			<Cfif ProcessType eq 'P'>
				<cfquery name="GetTradingCocd" datasource="#Client.database#">
					Select DISTINCT COMPANY_CODE Trd_CompCode
					From Company_master
					Where
						Fa_Posting = '#COCD#'
				</cfquery>
				<cfloop query="GetTradingCocd">
					<cfquery name="GetServiceTaxtAmt" datasource="#Client.database#">
						Select cast(SC as numeric(9,2)) Sc
						From SERVICE_CHARGE 
						Where	
								CONVERT(DATETIME,FROM_DATE,103)	<= CONVERT(DATETIME,GETDATE(),103)
							AND ISNULL(CONVERT(DATETIME,TO_DATE,103),CONVERT(DATETIME,GETDATE(),103)) >= CONVERT(DATETIME,GETDATE(),103)
							and	COMPANY_CODE	=  '#Trd_CompCode#'							
					</cfquery>
					<CFSET SERVICETAX = VAL(GetServiceTaxtAmt.SC)>
					<CFQUERY name= "GetAccount" datasource="#Client.database#">
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'MonthlyIBTSoftChgs'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
							
						UNION ALL
						
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'MonthlyBrIBTSoftChgs'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#	
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create "MonthlyIBTSoftChgs" or "MonthlyBrIBTSoftChgs" Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					
			<CFTRANSACTION>
				<CFTRY>
					<FONT COLOR="red">**Process Software Charges For IBT </FONT>	<BR>

					<CFQUERY NAME="GETFINSTART" datasource="#Client.database#">
						SELECT END_DATE FROM FINANCIAL_YEAR_MASTER
						WHERE COMPANY_CODE = '#cocd#'
						AND FINSTART = #StYr#
					</CFQUERY>

					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
								Delete From FA_TRANSACTIONS
								where 
									cocd = '#cocd#'
								and month(VoucherDate) = #month1#
								and FinStyr = #StYr#
								and BillNo = 1309
								and Trans_Type = 'J'
								AND TRADING_COCD = '#Trd_CompCode#'
					</CFQUERY>
					<cfset sr = 1>


					<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
						SELECT DISTINCT CLIENT_ID,IBT_CHARGE,CLIENT_NAME,ISNULL(IBT_CHGSDROption,'Client') IBT_CHGSDROption,BRANCH_CODE
						FROM CLIENT_MASTER
						WHERE 	
							COMPANY_CODE = '#TRIM(Trd_CompCode)#'
						AND ISNULL(IBT_FLAG,'N') = 'Y'
						AND ISNULL(IBT_CHARGE,0) <> 0
						AND REGISTRATION_DATE <= CONVERT(DATETIME,'#GETFINSTART.END_DATE#',103)
					</CFQUERY>	
					<cfset Trading_cocd = "#Trd_CompCode#">
					<CFLOOP QUERY="gETCLIENT">
							<cfset AcCode =CLIENT_ID>
							<cfset AccountName =CLIENT_NAME>
							<cfset OrgAMT = IBT_CHARGE>
							<cfset AmtWithServTax = ((IBT_CHARGE*SERVICETAX)/100) + IBT_CHARGE>
							<cfset AmtServTax = ((IBT_CHARGE*SERVICETAX)/100)>
	
							<CFQUERY NAME="SelectVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
									select  DBO.[GETLATESTVOUCEHRNO]('#cocd#',#StYr#,'J','','#TODATE#','') TXTVOUCHERNO
							</CFQUERY>	
							
							<CFSET TXTVOUCHERNO=#SelectVoucherNo.TXTVOUCHERNO#>		
																	
							<cfif IBT_CHGSDROption eq "Client">
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
										TRADING_COCD
									)
									values
									(
											'#cocd#','#AcCode#',#Numberformat(AmtWithServTax,'9999999999.99')#,0,
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#' ,'By Monthly Process From #FromDate# To #Todate# Of IBT Software Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1309,'#Trading_cocd#'
									)
								</CFQUERY>		
							<cfelse>
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
										TRADING_COCD,Branch_ID
									)
									values
									(
											'#cocd#','MonthlyBrIBTSoftChgs',#Numberformat(AmtWithServTax,'9999999999.99')#,0,
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#' ,'By Monthly Process From #FromDate# To #Todate# Of IBT Software Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1309,'#Trading_cocd#','#BRANCH_CODE#'
									)
								</CFQUERY>			
							</cfif>
							
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,TRADING_COCD
									)
									values
									(
											'#cocd#','MonthlyIBTSoftChgs',0,#Numberformat(OrgAMT,'999999999.99')#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# Of IBT Software Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1309,'#Trading_cocd#'
									)									
							</CFQUERY>		
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,TRADING_COCD
									)
									values
									(
											'#cocd#','Def3',0,#Numberformat(AmtServTax,'9999999999.99')#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# Of IBT Software Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1309,'#Trading_cocd#'
									)									
							</CFQUERY>		
							#Sr#. JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#Numberformat(AmtWithServTax,'9999999999.99')#), V.Date : #TODATE#<BR>
							<cfset sr = sr+1>
					</CFLOOP>
					<CFCATCH>
						#CFCATCH.Message##CFCATCH.Detail#<BR>
						<CFABORT>
					</CFCATCH>
					</CFTRY>
				</CFTRANSACTION>
				
				<!---- For SubscirpTion Charges ---->
				
				<CFQUERY name= "GetAccount" datasource="#Client.database#">
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'MonthlyIBTSubChgs'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
						UNION ALL
						
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'MonthlyBrIBTSubChgs'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create "MonthlyIBTSubChgs" or "MonthlyBrIBTSubChgs" Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					
			<CFTRANSACTION>
				<CFTRY>
					<FONT COLOR="red">**Process Subscription Charges For IBT </FONT>	<BR>


					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
								Delete From FA_TRANSACTIONS
								where 
									cocd = '#cocd#'
								and month(VoucherDate) = #month1#
								and FinStyr = #StYr#
								and BillNo = 1310
								and Trans_Type = 'J'
								AND TRADING_COCD = '#Trd_CompCode#'
					</CFQUERY>
					<cfset sr = 1>
					<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
						SELECT DISTINCT CLIENT_ID,IBT_Sub_Chgs,CLIENT_NAME,ISNULL(IBT_CHGSDROption,'Client') IBT_CHGSDROption,BRANCH_CODE
						FROM CLIENT_MASTER
						WHERE 	
							COMPANY_CODE = '#TRIM(Trd_CompCode)#'
						AND ISNULL(IBT_FLAG,'N') = 'Y'
						AND ISNULL(IBT_Sub_Chgs,0) <> 0
						AND REGISTRATION_DATE <= '#GETFINSTART.END_DATE#'
					</CFQUERY>	
					<cfset Trading_cocd = "#Trd_CompCode#">
					<CFLOOP QUERY="gETCLIENT">
							<cfset AcCode =CLIENT_ID>
							<cfset AccountName =CLIENT_NAME>
							<cfset OrgAMT = IBT_Sub_Chgs>
							<cfset AmtWithServTax = ((IBT_Sub_Chgs*SERVICETAX)/100) + IBT_Sub_Chgs>
							<cfset AmtServTax = ((IBT_Sub_Chgs*SERVICETAX)/100)>
	
							<CFQUERY NAME="SelectVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
									select  DBO.[GETLATESTVOUCEHRNO]('#cocd#',#StYr#,'J','','#TODATE#','') TXTVOUCHERNO
							</CFQUERY>	
							
							<CFSET TXTVOUCHERNO=#SelectVoucherNo.TXTVOUCHERNO#>		
																	
							<cfif IBT_CHGSDROption eq "Client">
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
										INSERT INTO FA_TRANSACTIONS
										(
											COcd, AccountCode,Dr_amt, Cr_amt,
											VoucherDate,  Trans_Type, VoucherNo, Narration,
											IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
											TRADING_COCD
										)
										values
										(
												'#cocd#','#AcCode#',#Numberformat(AmtWithServTax,'9999999999.99')#,0,
												convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#' ,'By Monthly Process From #FromDate# To #Todate# Of IBT Subscription Charges',
												'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
												1310,'#Trading_cocd#'
										)
								</CFQUERY>
							<cfelse>
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
										INSERT INTO FA_TRANSACTIONS
										(
											COcd, AccountCode,Dr_amt, Cr_amt,
											VoucherDate,  Trans_Type, VoucherNo, Narration,
											IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
											TRADING_COCD,Branch_Id
										)
										values
										(
												'#cocd#','MonthlyBrIBTSubChgs',#Numberformat(AmtWithServTax,'9999999999.99')#,0,
												convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#' ,'By Monthly Process From #FromDate# To #Todate# Of IBT Subscription Charges',
												'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
												1310,'#Trading_cocd#','#Branch_Code#'
										)
								</CFQUERY>	
							</cfif>	
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,TRADING_COCD
									)
									values
									(
											'#cocd#','MonthlyIBTSubChgs',0,#Numberformat(OrgAMT,'999999999.99')#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# Of IBT Subscription Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1310,'#Trading_cocd#'
									)									
							</CFQUERY>		
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,TRADING_COCD
									)
									values
									(
											'#cocd#','Def3',0,#Numberformat(AmtServTax,'9999999999.99')#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# Of IBT Subscription Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1310,'#Trading_cocd#'
									)									
							</CFQUERY>		
							#Sr#. JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#Numberformat(AmtWithServTax,'9999999999.99')#), V.Date : #TODATE#<BR>
							<cfset sr = sr+1>
					</CFLOOP>
					<CFCATCH>
						#CFCATCH.Message##CFCATCH.Detail#<BR>
						<CFABORT>
					</CFCATCH>
					</CFTRY>
				</CFTRANSACTION>
				<!---- For Brokerage Charges ---->
				
				<CFQUERY name= "GetAccount" datasource="#Client.database#">
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'MonthlyBrkChgs'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
						UNION ALL
						
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'MonthlyBrBrkChgs'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#	
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create "MonthlyBrkChgs" or "MonthlyBrBrkChgs" Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					
			<CFTRANSACTION>
				<CFTRY>
					<FONT COLOR="red">**Process Brokerage Charges For IBT </FONT>	<BR>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
								Delete From FA_TRANSACTIONS
								where 
									cocd = '#cocd#'
								and month(VoucherDate) = #month1#
								and FinStyr = #StYr#
								and BillNo = 1311
								and Trans_Type = 'J'
								AND TRADING_COCD = '#Trd_CompCode#'
					</CFQUERY>
					<cfset sr = 1>
					<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
						SELECT DISTINCT CLIENT_ID,IBT_Brk_Chgs,CLIENT_NAME,ISNULL(IBT_CHGSDROption,'Client') IBT_CHGSDROption,BRANCH_CODE
						FROM CLIENT_MASTER
						WHERE 	
							COMPANY_CODE = '#TRIM(Trd_CompCode)#'
						AND ISNULL(IBT_FLAG,'N') = 'Y'
						AND ISNULL(IBT_Brk_Chgs,0) <> 0
						AND REGISTRATION_DATE <= '#GETFINSTART.END_DATE#'
					</CFQUERY>	
					<cfset Trading_cocd = "#Trd_CompCode#">
					<CFLOOP QUERY="gETCLIENT">
							<cfset AcCode =CLIENT_ID>
							<cfset AccountName =CLIENT_NAME>
							<cfset OrgAMT = IBT_Brk_Chgs>
							<cfset AmtWithServTax = ((IBT_Brk_Chgs*SERVICETAX)/100) + IBT_Brk_Chgs>
							<cfset AmtServTax = ((IBT_Brk_Chgs*SERVICETAX)/100)>
	
							<CFQUERY NAME="SelectVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
									select  DBO.[GETLATESTVOUCEHRNO]('#cocd#',#StYr#,'J','','#TODATE#','') TXTVOUCHERNO
							</CFQUERY>	
							
							<CFSET TXTVOUCHERNO=#SelectVoucherNo.TXTVOUCHERNO#>		
																	
							<cfif IBT_CHGSDROption eq "Client">
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
										TRADING_COCD
									)
									values
									(
											'#cocd#','#AcCode#',#Numberformat(AmtWithServTax,'9999999999.99')#,0,
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#' ,'By Monthly Process From #FromDate# To #Todate# Of IBT Brokerage Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1311,'#Trading_cocd#'
									)
								</CFQUERY>		
							<cfelse>
								<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,
										TRADING_COCD,Branch_Id
									)
									values
									(
											'#cocd#','MonthlyBrBrkChgs',#Numberformat(AmtWithServTax,'9999999999.99')#,0,
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#' ,'By Monthly Process From #FromDate# To #Todate# Of IBT Brokerage Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											1311,'#Trading_cocd#','#Branch_Code#'
									)
								</CFQUERY>			
							</cfif>
							
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,TRADING_COCD
									)
									values
									(
											'#cocd#','MonthlyBrkChgs',0,#Numberformat(OrgAMT,'999999999.99')#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# Of IBT Brokerage Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1311,'#Trading_cocd#'
									)									
							</CFQUERY>		
							<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
									INSERT INTO FA_TRANSACTIONS
									(
										COcd, AccountCode,Dr_amt, Cr_amt,
										VoucherDate,  Trans_Type, VoucherNo, Narration,
										IPAdd,ManualVno, FinStyr, FinEndyr,User_Id,Punch_Time,TRREFNO,BillNo,TRADING_COCD
									)
									values
									(
											'#cocd#','Def3',0,#Numberformat(AmtServTax,'9999999999.99')#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# Of IBT Brokerage Charges',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											1311,'#Trading_cocd#'
									)									
							</CFQUERY>		
							#Sr#. JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#Numberformat(AmtWithServTax,'9999999999.99')#), V.Date : #TODATE#<BR>
							<cfset sr = sr+1>
					</CFLOOP>
					<CFCATCH>
						#CFCATCH.Message##CFCATCH.Detail#<BR>
						<CFABORT>
					</CFCATCH>
					</CFTRY>
				</CFTRANSACTION>
			</cfloop>
			<CFELSE>	
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
						Delete From FA_TRANSACTIONS
						where 
							cocd = '#cocd#'
						and month(VoucherDate) = #month1#
						and FinStyr = #StYr#
						and BillNo IN (1309,1310,1311)
						and Trans_Type = 'J'
					</CFQUERY>
			</Cfif>
		</CFIF>
		
</CFIF>
</DIV>

	<FORM NAME="MonthlyProcess" ACTION="MonthlyProcess.cfm" METHOD="POST">
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
					Monthly Process
				</td>
			</tr>
			<tr>
				<td  ALIGN="CENTER" CLASS="blue-head" COLSPAN="10" WIDTH="100%">&nbsp;
						
				</td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">
						Process Type :
				</td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%">
						<SELECT NAME="ProcessType"  CLASS="StyleLabel2">
							<OPTION VALUE="P" >Process</OPTION>
							<OPTION VALUE="C" >Cancle Process</OPTION>
						</SELECT>
				</td>
			</tr>

			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">
						Month :
				</td>
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
				<SCRIPT>
					MonthlyProcess.Month1.value='#Month(now())#'
				</SCRIPT>
				<CFIF IsDefined("Month1")>
						<SCRIPT>
							MonthlyProcess.Month1.value='#VAL(Month1)#'
						</SCRIPT>
				</CFIF>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;
					
				</td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%"  CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="Interest" CLASS="StyleCheckBox" >Late Payment Charges 
				</td>
			</tr>
			<tr>
			  <td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;
					
			  </td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="InterSettlement" CLASS="StyleCheckBox">InterSettlement
			  </td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;
					
			  </td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="BenToMkt" CLASS="StyleCheckBox">Ben To Mkt
			  </td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;
					
			  </td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="BenToCl" CLASS="StyleCheckBox">Ben To Client
			  </td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;
			  </td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="IBTMonthlyExp" CLASS="StyleCheckBox">IBT Monthly Exp.
			  </td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;
			  </td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="BenInwardChgs" CLASS="StyleCheckBox">Ben Inward Charges
			  </td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;
			  </td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="BranchMnthlyProcess" CLASS="StyleCheckBox">Branch Monthly Expense Process
			  </td>
			</tr>
			<tr>
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;
			  </td>
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="CHECKBOX" NAME="SMS" CLASS="StyleCheckBox">SMS Charges(Remeshire/Client)
			  </td>
			</tr>
			<TR>
				<SCRIPT LANGUAGE="VBSCRIPT">
					Sub	PostingDate_OnKeyuP()
							DSTR = MonthlyProcess.PostingDate.value
							DLEN = LEN(MonthlyProcess.PostingDate.value)
							IF DLEN = 2 OR DLEN = 5 THEN
								MonthlyProcess.PostingDate.value = DSTR + "/"
							END IF	
					END SUB
					Sub	PostingDate_GotFocus()	
							MonthlyProcess.PostingDate.SelStart = 0
							MonthlyProcess.PostingDate.SelLength = LEN(MonthlyProcess.PostingDate.value)
					END SUB
				</SCRIPT>		
				<td  ALIGN="RIGHT" COLSPAN="5" WIDTH="50%" CLASS="clsLabel">&nbsp;Posting Date(For Branch Month Exp Only.):</TD>				
				<td  ALIGN="LEFT" COLSPAN="5" WIDTH="50%" CLASS="bold">
					<INPUT TYPE="Text" NAME="PostingDate" VALIDATE="eurodate" REQUIRED="No" SIZE="10" MAXLENGTH="10" CLASS="StyleTextBox">	
				</TD>
			</TR>
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

