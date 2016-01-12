

<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<CFOUTPUT>


<CFSET COCD				=	Trim(ATTRIBUTES.COCD)>
<CFSET COName			=	Trim(ATTRIBUTES.COName)>
<CFSET Exchange			=	Trim(ATTRIBUTES.Exchange)>
<CFSET Market			=	Trim(ATTRIBUTES.Market)>
<CFSET Broker			=	Trim(ATTRIBUTES.Broker)>
<CFSET Mkt_Type			=	Trim(ATTRIBUTES.Mkt_Type)>
<CFSET Settlement_No	=	Val(Trim(ATTRIBUTES.Settlement_No))>
<CFSET Client_ID		=	Trim(ATTRIBUTES.Client_ID)>


<table align="center" width="50%" border="0" cellpadding="0" cellspacing="0" class="StyleTable">
	<CFTRANSACTION>
		<CFTRY>
			<CFQUERY name="GetFACOCD" datasource="#Client.database#" dbtype="ODBC">
				Select	RTrim(FA_POSTING) FACoCode
				From	COMPANY_MASTER
				Where	COMPANY_CODE	=	'#Trim(COCD)#'
			</CFQUERY>
			
			<CFQUERY name="Log" datasource="#Client.database#" dbtype="ODBC">
				Select	COCD, FINSTYR, VOUCHERNO, VOUCHERDATE, ACCOUNTCODE, DR_AMT, CR_AMT, MKT_TYPE, SETTLEMENT_NO
				From	FA_TRANSACTIONS
				Where		COCD			=	'#Trim( GetFACOCD.FACoCode )#'
						AND	MKT_TYPE		=	'#Trim( Ucase( mkt_type ))#'
						AND	SETTLEMENT_NO	=	#Val(Trim( settlement_no))#
						<CFIF IsDefined("Client_ID") AND Len(Trim(Client_ID)) gt 0>
							AND	ACCOUNTCODE	=	'#Trim(Ucase( Client_ID ))#'
						</CFIF>
			</CFQUERY>
			
			<CFSET PROCESS_DESCRIPTION = "">
			
			<CFLOOP query="Log">
				<CFSET PROCESS_DESCRIPTION = "#PROCESS_DESCRIPTION# #ACCOUNTCODE#| Dr:#DR_AMT# | Cr:#CR_AMT#,">
			</CFLOOP>
			
			<CFSET PROCESS_DESCRIPTION = "<U><B>VOUCHERNO :  #Log.VOUCHERNO# MARKET TYPE :  #Log.MKT_TYPE# SETTLEMENT NO :  #Log.SETTLEMENT_NO#</B></U><br>#PROCESS_DESCRIPTION#">		
			
			<CFSET Log_Id = 7>
			
			<CFMODULE Template				=	"/FOCAPS/FA_FOCAPS/Common/Log.cfm" 
					  LOG_ID				=	"#Log_Id#" 
					  SEGMENT				=	"T" 
					  COMPANY_CODE			=	"#Trim(GetFACOCD.FACoCode)#" 
					  FINSTYR				=	"#Log.FINSTYR#" 
					  PROCESS_DESCRIPTION	=	"#PROCESS_DESCRIPTION#">
		<CFCATCH type="Any">
		</CFCATCH>
		</CFTRY>
		
		<CFTRY>
			<CFSTOREDPROC procedure="CAPS_BILLCANCELLATION" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#mkt_type#" maxlength="2" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#settlement_no#" maxlength="9" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@USERID" value="#ClIENT.USERNAME#" maxlength="20" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@IPADD" value="#CLIENT.ClientIPAdd#" maxlength="20" null="No">
			</CFSTOREDPROC>

			<!--- <cfquery name="validateFaEntry" datasource="capsfo" dbtype="ODBC">
				SELECT	Count(VoucherNo)
				From
						Fa_Transactions
				Where	
						COCD		=	dbo.GetSystemValue('#Trim(COCD)#', '', 'FA_POSTING_CODE')
				AND		MKT_TYPE	=	'#Mkt_Type#'	
			</cfquery> --->
			
			<CFQUERY NAME="GetFACocd" datasource="#Client.database#" DBTYPE="ODBC">
				SELECT	RTRIM(FA_POSTING) FACOCD
				FROM	COMPANY_MASTER
				WHERE	COMPANY_CODE	=	'#Trim(COCD)#'
			</CFQUERY>
			
			<CFSET	FACOCD	=	"#GetFACocd.FACOCD#">

			<CFQUERY NAME="GetVoucherNo" datasource="#Client.database#" DBTYPE="ODBC">
				SELECT	
						VoucherNo
				From
						FA_TRANSACTIONS
				Where
						COCD			=	'#Trim(FACOCD)#'
				AND		TRADING_COCD	=	'#Trim(COCD)#'
				AND		MKT_TYPE		=	'#mkt_type#'
				AND		SETTLEMENT_NO	=	#val(Trim(settlement_no))#
				AND		FINSTYR			=	#VAL(trim(FinStart))#
				AND		TRANS_TYPE		=	'SJ'
				
			</CFQUERY>
	
			<CFTRY>
				<CFQUERY NAME="DelTrade1Sum" datasource="#Client.database#">
					DELETE	TRADE1SUMMARY
					WHERE
							COMPANY_CODE	=	'#Trim(COCD)#'
					AND		MKT_TYPE		=	'#mkt_type#'
					AND		SETTLEMENT_NO	=	#val(Trim(settlement_no))#
				</CFQUERY>			
			<CFCATCH TYPE="DATABASE">
			</CFCATCH>
			</CFTRY>
				<CFIF UCase(Mkt_Type) EQ 'T' OR UCase(Mkt_Type) EQ 'N'>
				
				<cfelse>
							<CFTRY>
								<CFQUERY NAME="DelTrade1Sum" datasource="#Client.database#">
									DELETE	FA_TRANSACTIONS
									WHERE
											COCD			=	'#Trim(FACOCD)#'
									AND		BILLNO			=	22222
									AND		SETTLEMENT_NO	=	#val(Trim(settlement_no))#
									AND		MKT_TYPE		=	'#mkt_type#'
									AND		TRANS_TYPE		=	'J'
								</CFQUERY>			
							<CFCATCH TYPE="DATABASE">
							</CFCATCH>
							</CFTRY>
				</CFIF>


			<CFIF GetVoucherNo.RecordCount GT 0>
				<tr><th align="left" style="color: Red ;"> <U>Voucher No</U> #GetVoucherNo.VoucherNo# </th> </tr>
				<tr><th align="left" style="color: Red ;"> Bill Cancellation NOT completed </th> </tr>
				<CFTRANSACTION action="ROLLBACK"/>
			<CFELSE>
				<tr><th align="left"> Bill Cancellation completed </th> </tr>
			</CFIF>	
		<CFCATCH type="Any">
			<tr><th align="left" style="color: Red ;"> Bill Cancellation NOT completed<br>#cfcatch.Detail# </th> </tr>
		</CFCATCH>
		</CFTRY>
	</CFTRANSACTION>
 <CFTRY>
		<CFQUERY NAME="GetEMailIDs" datasource="#Client.database#">
				SELECT
						From_EMail_ID, CC_Email_ID,isnull(SendMes_UserList,'') SendMes_UserList
				FROM
						SYSTEM_SETTINGS
				WHERE
				Company_Code	=	'#COCD#'
		</CFQUERY>
		<cfinclude template="../../messenging system/SendMes.cfc">
	<cfif GetEMailIDs.SendMes_UserList neq ''>
	
		<cfloop index="i" list="#GetEMailIDs.SendMes_UserList#" delimiters=",">
			<Cfset a = SendMes("Company:#cocd#,Bill Cancle For Settlement :#Mkt_Type#-#Settlement_NO#",'IPADD:#CLIENT.CLIENTIPADD#',"#i#")>
		</cfloop>
	</cfif>
	<CFCATCH>
	<FONT COLOR="FF0000" TITLE="#cfcatch.Detail#//#cfcatch.Message#"><BR>***</FONT>
	</CFCATCH>
	</CFTRY> 


	<CFQUERY NAME="GetTransfer_Cocd_CL2" datasource="#Client.database#" DBTYPE="ODBC">
		SELECT	ISNULL(TRANSFERING_COCD_FOR_CL2, '')TRANSFERING_COCD_FOR_CL2
		FROM	
				SYSTEM_SETTINGS
		WHERE
				COMPANY_CODE	=	'#COCD#'
	</CFQUERY>
		
	<CFIF GetTransfer_Cocd_CL2.TRANSFERING_COCD_FOR_CL2 NEQ "">
	
		<CFTRANSACTION>
			<CFTRY>
				<CFSTOREDPROC procedure="DELETE_DATA_FOR_CL2" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
				</CFSTOREDPROC>
				
				<tr><th align="Center" style="Color : Green;"> ** </th> </tr>
			<CFCATCH type="Any">
				<tr><th align="left" style="Color : Red;"> Bill Cancellation For CL2 NOT completed </th> </tr>
				<CFSET p8 = 0>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFTRANSACTION>
		
	</CFIF>
</table>


</CFOUTPUT>