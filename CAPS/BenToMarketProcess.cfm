<cfoutput>
						<CFQUERY NAME="CMC" datasource="#Client.database#">	
							SELECT CLEARING_MEMBER_CODE,ISNULL(Ben_To_Mkt_Chgs,0) BentoMktChgs,
								   IsNull(Chags_Ben_List,'')Ben_List
								   ,BENTOMARKET_ACUCTION
							FROM SYSTEM_SETTINGS
							WHERE COMPANY_CODE = '#COCD#'
						</CFQUERY>
						<CFIF CMC.BentoMktChgs NEQ 0 AND Trim(CMC.Ben_List) NEQ "" AND CMC.BENTOMARKET_ACUCTION EQ 'Y'>
									<CFSTOREDPROC PROCEDURE="BENIFICIARY_CHARGES" datasource="#Client.database#">
										<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROMDATE" value="#Trade_date#" null="No">
										<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TODATE" VALUE="#Trade_date#" NULL="No">
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
												</cfif>
											</CFLOOP>
											<CFCATCH>
												#CFCATCH.Message##CFCATCH.Detail#<BR>
												<CFABORT>
											</CFCATCH>
											</CFTRY>
										</CFTRANSACTION>		
								</CFIF>
</cfoutput>