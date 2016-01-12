<cfoutput>

<CFIF  IsDefined("SMS")>
			
			<Cfif ProcessType eq 'P'>
					<CFQUERY name= "GetAccount" datasource="#Client.database#">
						SELECT * 
						FROM 
							fa_accountList
							where  ACCOUNTCODE = 'SMSCharges'	
							and    COcd = '#cocd#'
							and FinStyr = #StYr#
							and FinEndyr = #EndYr#
					</CFQUERY>
					<CFIF GetAccount.recordcount eq 0>
						<SCRIPT>
							alert('Please Create (SMSCharges) Account IN #cocd#'); 
						</SCRIPT>
						<CFABORT>
					</CFIF>
					<cftry>
						<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
							DROP TABLE ##Data_SMS 
						</CFQUERY>
					<cfcatch></cfcatch>
					</cftry>
					<Cfset INTERESTRATE=SysParamValue("SMSCHARGES")>
					<CFQUERY NAME="gETCLIENT" datasource="#Client.database#">
						SELECT CLIENTID ACCOUNTCODE,COUNT(*) TOTALSMS,CAST('' AS VARCHAR(100)) REM,CAST('' AS VARCHAR(100)) POSTCOCD
						INTO ##Data_SMS 
						FROM CAPSFO_TRADEDATA.DBO.SMS_TRANS
						WHERE SMSCHARGE ='Y'
						AND CLIENTID IS NOT NULL
						AND CONVERT(DATETIME,CONVERT(VARCHAR(10),ENTRYTIME,103),103) BETWEEN CONVERT(DATETIME,'#FROMDATE#',103) AND CONVERT(DATETIME,'#TODATE#',103)
						GROUP BY CLIENTID
						
						UPDATE ##Data_SMS
						SET REM = B.REMESHIRE_GROUP,
							POSTCOCD =COMPANY_CODE
						FROM ##Data_SMS A,CLIENT_MASTER B
						WHERE ACCOUNTCODE = CLIENT_ID
						and COMPANY_CODE in('bse_cash','nse_cash','nse_fno')
						
						UPDATE ##Data_SMS
						SET POSTCOCD =COMPANY_CODE
						FROM ##Data_SMS A,CLIENT_MASTER B
						WHERE ACCOUNTCODE = CLIENT_ID
						AND isnull(REM,'') =''
						and COMPANY_CODE in('bse_cash','nse_cash','nse_fno')

						UPDATE ##Data_SMS
						SET REM = B.REMESHIRE_GROUP,
							POSTCOCD =COMPANY_CODE
						FROM ##Data_SMS A,CLIENT_MASTER B
						WHERE ACCOUNTCODE = CLIENT_ID
						and COMPANY_CODE not in('bse_cash','nse_cash','nse_fno')
						and isnull(POSTCOCD,'') =''
						UPDATE ##Data_SMS
						SET POSTCOCD =COMPANY_CODE
						FROM ##Data_SMS A,CLIENT_MASTER B
						WHERE ACCOUNTCODE = CLIENT_ID
						AND isnull(REM,'') =''
						and COMPANY_CODE not in('bse_cash','nse_cash','nse_fno')
						and isnull(POSTCOCD,'') =''

						
						SELECT ACCOUNTCODE,SUM(TOTALSMS) TOTALSMS,POSTCOCD
						FROM ##Data_SMS
						WHERE  isnull(REM,'') =''
						GROUP BY ACCOUNTCODE,POSTCOCD
						UNION ALL
						SELECT REM,SUM(TOTALSMS),POSTCOCD
						FROM ##Data_SMS
						WHERE  isnull(REM,'') !=''
						GROUP BY REM,POSTCOCD
					</CFQUERY>
			<CFTRANSACTION>
				<CFTRY>
					<FONT COLOR="red">**Process SMS Posting</FONT>	<BR>
					<CFQUERY NAME="insertTransactions" datasource="#Client.database#" DBTYPE="ODBC">
								Delete From FA_TRANSACTIONS
								where 
									cocd = '#cocd#'
								and month(VoucherDate) = #month1#
								and FinStyr = #StYr#
								and BillNo = 13088
								and Trans_Type = 'J'
					</CFQUERY>
					<cfset sr = 1>
					<CFLOOP QUERY="gETCLIENT">
							<cfset AcCode =ACCOUNTCODE>
							<Cfset cocd =POSTCOCD>	
							<cfset AMT = TOTALSMS*INTERESTRATE>
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
											convert(datetime,'#TODATE#',103),'J', '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# For SMS Charges @ #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'1',
											13088
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
											'#cocd#','SMSCharges',0,#AMT#,
											convert(datetime,'#TODATE#',103),'J',  '#TXTVOUCHERNO#'   ,'By Monthly Process From #FromDate# To #Todate# For SMS Charges @ #INTERESTRATE#%',
											'#REMOTE_ADDR#',Null,#Trim(StYr)#,#Trim(EndYr)#,'#Ucase(CLIENT.UserName)#', getdate(),'2',
											13088
									)
									
							</CFQUERY>		
							#Sr#. Company :#POSTCOCD# ,JVNo :(#TXTVOUCHERNO#) ,Client :(#AcCode#) ,Amount:(#amt#),Date : #TODATE#<BR>
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
						and BillNo = 13088
						and Trans_Type = 'J'
					</CFQUERY>
			</Cfif>
		</CFIF>
		
</cfoutput>
		