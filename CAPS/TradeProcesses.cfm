 <!---- **********************************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************************** ---->


<CFOUTPUT>
<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED
</CFQUERY>

<CFSET COCD				=	Trim(ATTRIBUTES.COCD)>
<CFSET COName			=	Trim(ATTRIBUTES.COName)>
<CFSET Exchange			=	Trim(ATTRIBUTES.Exchange)>
<CFSET Market			=	Trim(ATTRIBUTES.Market)>
<CFSET Broker			=	Trim(ATTRIBUTES.Broker)>
<CFSET Mkt_Type			=	Trim(ATTRIBUTES.Mkt_Type)>
<CFSET Settlement_No	=	Val(Trim(ATTRIBUTES.Settlement_No))>
<CFSET Trade_Date		=	Trim(ATTRIBUTES.Trade_Date)>
<CFSET Client_ID		=	Trim(ATTRIBUTES.Client_ID)>
<CFSET Scrip_Symbol		=	Trim(ATTRIBUTES.Scrip_Symbol)>
<CFSET p1				=	Val(ATTRIBUTES.p1)>
<CFSET p2				=	Val(ATTRIBUTES.p2)>
<CFSET p3				=	Val(ATTRIBUTES.p3)>
<CFSET p4				=	Val(ATTRIBUTES.p4)>
<CFSET p5				=	Val(ATTRIBUTES.p5)>
<CFSET p6				=	Val(ATTRIBUTES.p6)>
<CFSET p7				=	Val(ATTRIBUTES.p7)>
<CFSET p9				=	Val(ATTRIBUTES.p9)>
<CFSET p8				=	Val(ATTRIBUTES.p8)>
<CFSET p10				=	Val(ATTRIBUTES.p10)>
<CFSET p11				=	Val(ATTRIBUTES.p11)>
<CFSET p12				=	Val(ATTRIBUTES.p12)>

<CFSET p15				=	Val(ATTRIBUTES.p15)>
<cfparam  default="" name="BillCancle">
<CFFLUSH INTERVAL="1">


<CFQUERY datasource="#Client.database#" NAME="getSYS">
	Select max(isnull(PROCESSFLOW,'O')) PROCESSFLOW from SYSTEM_SETTINGS
</CFQUERY>
<CFSET PROCESSFLOW = getSYS.PROCESSFLOW>
<cftry>
<cfinclude template="/focaps/userlog.cfm">
<cfcatch></cfcatch>
</cftry>
<Cfif mkt_type eq 'N' or mkt_type eq 'T'>
	<CFSET ReportLogCount = Reportlog('BILLPROC','Bill Process Company:#cocd#,MKt Type:#mkt_type#,SetlNo:#settlement_no#,Trade Date:#Trade_Date#','Y')>
<cfelse>
	<CFSET ReportLogCount = Reportlog('BILLPROC','Bill Process Company:#cocd#,MKt Type:#mkt_type#,SetlNo:#settlement_no#,Trade Date:#Trade_Date#')>
</Cfif>
<CFQUERY NAME="GetTransfer_Cocd_CL2" datasource="#Client.database#" DBTYPE="ODBC">
	SELECT	ISNULL(TRANSFERING_COCD_FOR_CL2, '')TRANSFERING_COCD_FOR_CL2,
			IsNull(Inst_NewProc,'N')Inst_NewProc,
			IsNull(SCRIP_LIST_FOR_FIXEDBRK_APPLIED,'')SCRIP_LIST_FOR_FIXEDBRK_APPLIED,
			isnull(NRIPROCESS,'Y')  NRIPROCESS
			,IsNull(FLG_PositionShift, 'Y')FLG_PositionShift,
			SOFT,CASHLEDGERMTM
	FROM	
			SYSTEM_SETTINGS
	WHERE
			COMPANY_CODE	=	'#COCD#'
</CFQUERY>


<cFSET FLG_POSITIONSHIFT = GetTransfer_Cocd_CL2.FLG_POSITIONSHIFT>
<cFSET NRIPROCESS = GetTransfer_Cocd_CL2.NRIPROCESS>


<CFSET	Inst_NewProc1	=	Trim(GetTransfer_Cocd_CL2.Inst_NewProc)>
<CFSET	SCRIP_LIST_FOR_FIXEDBRK_APPLIED	=	Trim(GetTransfer_Cocd_CL2.SCRIP_LIST_FOR_FIXEDBRK_APPLIED)>

<TABLE width="96%" border="0" cellspacing="0" cellpadding="0" align="Center" class="StyleTable1">
	<TR>
		<TH align="left">
			<FONT color="Fuchsia">
				<u>Results:</u>
			</FONT>
		</TH>
	</TR>
	<CFSET Summery = "">
<CFFLUSH INTERVAL="1">
	<!--- **********************************************************
							INVALID CLIENT CHECK
	*********************************************************** --->
	<CFIF ( p1 EQ 1 ) OR ( p2 EQ 1 ) OR ( p3 EQ 1 ) OR ( p4 EQ 1 ) OR ( p5 EQ 1 ) OR ( p6 EQ 1 ) OR ( p7 EQ 1 ) OR ( p8 EQ 1 )>
		
		
		
		<CFIF Val(p8) EQ 1>
				<cfquery datasource="#Client.database#" name="gETsCRIP">
						select DISTINCT SCRIP_SYMBOL from SCRIP_MASTER_TABLE
						where SCRIP_SYMBOL in (select scrip_symbol from trade1
												where BILL_SETTLEMENT_NO= '#settlement_no#'
												AND MKT_TYPE = '#mkt_type#'
												AND COMPANY_CODE  = '#cocd#'
						)
						AND ISNULL(ISIN,'') = ''
						AND MARKET = 'CASH'
				</cfquery>
				<cfif gETsCRIP.RECORDCOUNT NEQ 0>
					<TR><TH align="left" style="Color : Red;">ISIN Missing IN Folloving Scrip </TH> </TR>
					<CFLOOP query="gETsCRIP">
						<TR><TD align="left" >#SCRIP_SYMBOL#</TD> </TR>
					</CFLOOP>
					<TR><TH align="left" style="Color : Red;"> Billing ABORTED </TH> </TR>
					<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<cfabort>
				</cfif>
		</cfif>
	<Cfif BillCancle neq 1>
		<Cftry>
			<CFSTOREDPROC procedure="CAPS_BILLCANCELLATION" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#mkt_type#" maxlength="2" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#settlement_no#" maxlength="9" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
			</CFSTOREDPROC>
			<cfcatch></cfcatch>
		</Cftry>
	</Cfif>

		<CFSET Summery = "#Summery#INVALID_CLIENT_CHECK START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
		<cfif NRIPROCESS eq 'Y'>
				<CFTRY>
					<CFSTOREDPROC procedure="CAPS_NRI_CLIENT_PROCESS" datasource="#Client.database#" returncode="Yes">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="10" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FINSTART" value="#FINSTART#" maxlength="10" null="No">
					</CFSTOREDPROC>
					<TR><TH align="left" style=""> NRI Process Done</TH> </TR>
					<cfcatch>
					<TR><TH align="left" style="Color : Red;" title="#cfcatch.Detail#"> NRI Process Not Done</TH> </TR>
					</cfcatch>
				</CFTRY>
		</cfif>
		<CFTRY>
			<CFSTOREDPROC procedure="INVALID_CLIENT_CHECK" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
				<CFPROCPARAM type="Out" cfsqltype="CF_SQL_NUMERIC" variable="InvalidClientNumber" dbvarname="@COUNT" null="No">
				<CFPROCRESULT name="InvalidClientList">
			</CFSTOREDPROC>
			<CFSET Summery = "#Summery#INVALID_CLIENT_CHECK STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
			<CFIF InvalidClientNumber GT 0>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT allowed </TH> </TR>
				</CFIF>
				<TR><TH align="left" style="Color : Fuchsia;"> <u>Invalid Client List</u> </TH> </TR>
				<CFLOOP query="InvalidClientList">
					<TR>
						<TH align="left" style="Color : Red;"> #Trim(Client_ID)# </TH>
					</TR>
				</CFLOOP>
				<CFSET p8 = 0>
				<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFIF>
		<CFCATCH type="Any">
			<TR><TH align="left" style="Color : Red;"> Invalid Client Check NOT completed </TH> </TR>
			<CFSET p1 = 0>
			<CFSET p2 = 0>
			<CFSET p3 = 0>
			<CFSET p4 = 0>
			<CFSET p5 = 0>
			<CFSET p6 = 0>
			<CFSET p7 = 0>
			<CFSET p9 = 0>
			<CFSET p8 = 0>
			<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
			<CFABORT>
		</CFCATCH>
		</CFTRY>
	</CFIF>
	<!--- **********************************************************
							PREVIOUS TRADE DELETION
	*********************************************************** --->
<CFFLUSH INTERVAL="1">

	<CFIF ( p1 EQ 1 ) OR ( p2 EQ 1 ) OR ( p3 EQ 1 ) OR ( p4 EQ 1 ) OR ( p5 EQ 1 ) OR ( p6 EQ 1 ) OR ( p7 EQ 1 ) OR ( p8 EQ 1 )>
		<CFTRY>
			<CFSET Summery = "#Summery#CAPSFO_DELETE_TEMPTRADE START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
			<CFSTOREDPROC procedure="CAPSFO_DELETE_TEMPTRADE" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Exchange" value="#Exchange#" maxlength="10" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Market" value="#Market#" maxlength="10" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="10" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Trade_Date" value="#Trade_Date#" maxlength="10" null="No">
			</CFSTOREDPROC>
			<CFSET Summery = "#Summery#CAPSFO_DELETE_TEMPTRADE STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
			
		<CFCATCH type="Any">
			<TR><TH align="left" style="Color : Red;" title="#cfcatch.Detail#"> Deletion Of Temp Data not completed. </TH> </TR>
			<CFSET p1 = 0>
			<CFSET p2 = 0>
			<CFSET p3 = 0>
			<CFSET p4 = 0>
			<CFSET p5 = 0>
			<CFSET p6 = 0>
			<CFSET p7 = 0>
			<CFSET p9 = 0>
			<CFSET p8 = 0>
			<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
			<CFABORT>
		</CFCATCH>
		</CFTRY>
	</CFIF>


	<!--- **********************************************************
							POSITION SHIFTING
	*********************************************************** --->
	
	
		

		<!--- **********************************************************
								NO-DELIVERY MARKING
		*********************************************************** --->
<!---		<CFIF ( Val(p5) EQ 1 ) AND ( Val(p8) EQ 1 )>
			<CFTRY>
				<CFSTOREDPROC procedure="PRE_BSE_ND_MARKING_CHECK" datasource="CAPSFO" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#UCase(Trim(COCD))#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#UCase(Trim(Mkt_Type))#" maxlength="4" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SETL_NO" value="#Val(Trim(Settlement_No))#" maxlength="7" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trim(Trade_Date)#" maxlength="7" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@PROCESS_TYPE" value="MARK" maxlength="20" null="No">
					<CFPROCPARAM type="Out" cfsqltype="CF_SQL_CHAR" dbvarname="@PROCESS_MSG" variable="ProcessMsg" maxlength="1" null="No">
				</CFSTOREDPROC>
				
			   		<tr><th align="left"> Pre No-Delivery Marking completed </th> </tr>
					
			<CFCATCH type="Any">
				<tr><th align="left" style="Color : Red;"> Pre No-Delivery Marking NOT completed </th> </tr>
				<CFIF Val(p8) EQ 1>
					<tr><th align="left" style="Color : Red;"> Billing NOT done </th> </tr>
				</CFIF>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>------->
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>
----->

		<!--- **********************************************************
								Pre ND-DELIVERY MARKING
		*********************************************************** --->
<CFFLUSH INTERVAL="1">
		<CFIF ( Val(p11) EQ 1 ) AND ( EXCHANGE IS "BSE" )>
			<CFIF	MKT_TYPE	IS	"N" OR MKT_TYPE	IS	"T">
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_PRE_BSE_ND_CHECK START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<CFSTOREDPROC procedure="CAPS_PRE_BSE_ND_CHECK" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#UCase(Trim(COCD))#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#UCase(Trim(Mkt_Type))#" maxlength="4" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Settlement_No" value="#Val(Trim(Settlement_No))#" maxlength="7" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Trade_Date" value="#Trim(Trade_Date)#" maxlength="10" null="No">
					<CFPROCPARAM type="Out" cfsqltype="CF_SQL_NUMERIC"  dbvarname="@Process_Msg" variable="ProcessMsg" null="No">
					
					<CFPROCRESULT Name="MissingPriceData" resultset="1">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_PRE_BSE_ND_CHECK STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<CFIF Trim(ProcessMsg) EQ "0">
			   		<TR><TH align="left"> Pre No-Delivery Marking completed </TH> </TR>
				<CFELSEIF Trim(ProcessMsg) EQ "1">
					<TH align="Left" style="Color : Red;">
						&nbsp;&nbsp; Carry Forward Settlement not created, <BR>
						&nbsp;&nbsp; Please create Carry Forward Settlement.
						Or Please Check Holiday Master
					</TH>
					<CFIF Val(p8) EQ 1>
						<TR><TH align="left" style="Color : Red;"> Billing NOT Done </TH> </TR>
					</CFIF>
					<CFSET p8 = 0>
					<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				<CFELSEIF Trim(ProcessMsg) EQ "2">
					<TH align="Left" style="Color : Red;">
						&nbsp;&nbsp; Price file not imported, <BR>
						&nbsp;&nbsp; Please Import Price File.
					</TH>	
					<CFIF Val(p8) EQ 1>
						<TR><TH align="left" style="Color : Red;"> Billing NOT Done </TH> </TR>
					</CFIF>
					<CFSET p8 = 0>
					<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				<CFELSEIF Trim(ProcessMsg) EQ "3">
					<TR>
						<TH align="Left" style="Color : Red;">
							&nbsp;&nbsp; Price is missing for following ND Scrips.
						</TH>
					</TR>	
						<CFLOOP query="MissingPriceData">
							<TR>
								<TD align="left">
									#Scrip_Code#&nbsp;
								</TD>
							</TR>
						</CFLOOP>
						<CFIF Val(p8) EQ 1>
							<TR><TH align="left" style="Color : Red;"> Billing NOT Done </TH> </TR>
						</CFIF>
					<CFSET p8 = 0>
					<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				</CFIF>
				<CFCATCH TYPE="DATABASE">
					<CFIF CFCATCH.NativeErrorCode NEQ 2627>
						<TR><TH align="left" style="Color : Red;"> Pre BSE ND Check not completed. </TH> </TR>
						<TR><TH align="left" style="Color : Red;"> #cfcatch.Detail# </TH> </TR>
						<CFIF Val(p8) EQ 1>
							<TR><TH align="left" style="Color : Red;"> Billing NOT Done. </TH> </TR>
						</CFIF>
						<CFSET p8 = 0>
											<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>

						<CFABORT>
					</CFIF>
				</CFCATCH>
				</CFTRY>	
			</CFIF>
		</CFIF>
<CFFLUSH INTERVAL="1">

		<!--- **********************************************************
								NO-DELIVERY MARKING
		*********************************************************** --->
		<CFIF ( Val(p5) EQ 1 ) AND ( Val(p8) EQ 1 )>
			<CFTRY>
				<CFSET Summery = "#Summery##Trim(Exchange)#_ND_MARKING START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<CFSTOREDPROC procedure="#Trim(Exchange)#_ND_MARKING" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#UCase(Trim(COCD))#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#UCase(Trim(Mkt_Type))#" maxlength="4" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SETL_NO" value="#Val(Trim(Settlement_No))#" maxlength="7" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@PROCESS_TYPE" value="MARK" maxlength="20" null="No">
					<CFPROCPARAM type="Out" cfsqltype="CF_SQL_CHAR" dbvarname="@PROCESS_MSG" variable="ProcessMsg" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery##Trim(Exchange)#_ND_MARKING STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				
				<CFIF Trim(ProcessMsg) EQ "0">
			   		<TR><TH align="left"> No-Delivery Marking completed </TH> </TR>
					 
				<CFELSEIF Trim(ProcessMsg) EQ "2">
					<TR>
						<TH align="Left" style="Color : Green;">
							&nbsp;&nbsp; Scrips NOT available in ND-Database for this Settlement.
						</TH>
					</TR>
				<CFELSEIF Trim(ProcessMsg) EQ "4">
					<TR>
						<TH align="Left" style="Color : Red;">
							&nbsp;&nbsp; ND Settlement is already Billed, <BR>
							&nbsp;&nbsp; check the ND-Data and cancel the Bill for ND-Settlement to proceed further.
						</TH>
					</TR>
					<CFIF Val(p8) EQ 1>
						<TR><TH align="left" style="Color : Red;"> Billing NOT Done </TH> </TR>
					</CFIF>
					<CFSET p8 = 0>
					<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>

					<!-----<CFTRANSACTION action="ROLLBACK"/>------->
					<CFABORT>
				</CFIF>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> No-Delivery Marking NOT completed </TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
				</CFIF>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>
			<CFTRY>
				<CFSET Summery = "#Summery#COMPRESS_REVERSE_TRASACTIONS START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<CFQUERY NAME="Compression" datasource="#Client.database#">
					EXEC	COMPRESS_REVERSE_TRASACTIONS	'#COCD#', '#Mkt_Type#', #val(Settlement_No)#, '#Trade_Date#'
				</CFQUERY>
				<CFSET Summery = "#Summery#COMPRESS_REVERSE_TRASACTIONS END : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<TR><TH align="left" style="Color : Green;"> ** </TH> </TR>
			<!---  --->
			<CFCATCH TYPE="Any">
				<TR><TH align="left" style="Color : Red;" title="#CFCATCH.Detail##CFCATCH.Message#"> Compress Transaction NOT completed </TH> </TR>
				<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFSET p8 = 0><cfabort>
				<!---<!-----<CFTRANSACTION action="ROLLBACK"/>------->--->
			</CFCATCH>		
			</CFTRY>
<CFFLUSH INTERVAL="1">

		


		<!--- **********************************************************
							TRADING BROKERAGE PROCESS
		*********************************************************** --->
		<CFIF Val(p2) EQ 1>
			<!--- **********************************************************
				RE-INITIALIZE TRADING-BROKERAGE PRIOR TO BROKERAGE PROCESSING.
			*********************************************************** --->
			<CFTRY>
				<CFSET Summery = "#Summery#RESET_TRADE_BROKERAGE_VALUES START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<CFSTOREDPROC procedure="RESET_TRADE_BROKERAGE_VALUES" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@MARKET" value="#Trim(Market)#" maxlength="5" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@MKT_TYPE" value="#Trim(Mkt_Type)#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" 	dbvarname="@SETTLEMENT_NO" value="#Trim(Settlement_No)#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@TRADE_DATE" value="#Trim(Trade_Date)#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@CLIENT_ID" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#RESET_TRADE_BROKERAGE_VALUES STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Trade Brokerage Re-Initialization NOT completed </TH> </TR>
				<CFSET p2 = 0>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>

	<CFTRY>
		<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
		<CFSTOREDPROC procedure="CAPS_NEW_BROKERAGE_1" datasource="#Client.database#" returncode="Yes">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT_ID" value="#Trim(Client_ID)#" maxlength="20" null="No">
		</CFSTOREDPROC>
		<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
	<CFCATCH type="Any">
		<TR><TH align="left" style="Color : Red;">#cfcatch.detail# New  Delivery Brokerage Apply NOT completed </TH> </TR>
		<CFSET p6 = 0>
		<CFSET p8 = 0>
		<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
		<CFABORT>
	</CFCATCH>
	</CFTRY>
	
	<TR><TH align="left"> Delivery Brokerage calculation completed </TH> </TR>
			
		<Cfif FLG_PositionShift eq 'Y'>
					<CFTRY>
					
						<CFQUERY name="PositionData" datasource="#Client.database#" dbtype="ODBC">
							Select	Count( TRADE_NUMBER ) CNT, b.Client_ID, b.DELIVERY_CLIENT_ID
							From	TRADE1 a ( INDEX = CLUSTERED_IDX_TRADE1 ), CLIENT_MASTER b
							Where
										a.COMPANY_CODE	=	b.COMPANY_CODE
									AND	a.CLIENT_ID		=	b.Client_ID
									AND	a.COMPANY_CODE  =	'#COCD#'
									AND	MKT_TYPE		=	'#Mkt_Type#'
									AND	BILL_SETTLEMENT_NO	=	#Settlement_No#
									--AND	Convert( DateTime, TRADE_DATE, 103 ) = Convert( DateTime, '#Trade_Date#', 103 )
									AND	TRADE_type	Like 'T%'
									AND	ISNULL(B.DELIVERY_CLIENT_ID,'')	!=''
									AND B.DELIVERY_CLIENT_ID  IN(SELECT ISNULL(CLIENT_ID,'') FROM CLIENT_MASTER WHERE CLIENT_NATURE = 'P' AND COMPANY_CODE = '#COCD#')
									AND B.CLIENT_NATURE = 'P'
									AND A.BROKERAGE_TYPE ='D'
							Group By b.CLIENT_ID, b.DELIVERY_CLIENT_ID
						</CFQUERY>
						<cfif PositionData.RECORDCOUNT NEQ 0>
							<CFSTOREDPROC procedure="CAPS_POSITION_SHIFT" datasource="#Client.database#" returncode="Yes">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SYMBOL" value="" maxlength="25" null="No">
							</CFSTOREDPROC>
							<tr><th align="left"> Position Shifting completed </th> </tr>
							<CFLOOP query="PositionData">
								<tr><th align="left" style="Color : Green;"> &nbsp;&nbsp; #Trim(Client_ID)# to #DELIVERY_CLIENT_ID# &nbsp; #cnt# nos. </th> </tr>
							</CFLOOP>
						</cfif>
					<CFCATCH type="Any">
						<tr><th align="left" style="Color : Red;"> Position Shifting NOT completed  #cfcatch.Detail#</th> </tr>
						<CFSET p8 = 0>
						<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
						<CFABORT>
					</CFCATCH>
					</CFTRY>
		</Cfif>

<!--- 	
	<CFTRY>
		<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE 2 START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
		<CFSTOREDPROC procedure="CAPS_NEW_BROKERAGE_2" datasource="#Client.database#" returncode="Yes">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT_ID" value="#Trim(Client_ID)#" maxlength="20" null="No">
		</CFSTOREDPROC>
		<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE 2 STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
	<CFCATCH type="Any">
		<TR><TH align="left" style="Color : Red;">#cfcatch.detail# Turnover Brokerage Apply NOT completed </TH> </TR>
		<CFSET p6 = 0>
		<CFSET p8 = 0>
		<CFABORT>
	</CFCATCH>
	</CFTRY> 
--->

<CFFLUSH INTERVAL="1">

		<!--- **********************************************************
							CONTRACT GENERATION PROCESS
		*********************************************************** --->
		<CFIF Val(p9) EQ 1>
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_CONTRACT_NUMBER_GENERATION START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_CONTRACT_NUMBER_GENERATION" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Trim(Mkt_Type)#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Val(Trim(Settlement_No))#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trim(Trade_Date)#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_CONTRACT_NUMBER_GENERATION STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
				<CFIF CFSTOREDPROC.StatusCode EQ 0>
					<TR><TH align="left"> Contract Generation completed </TH> </TR>
					
				<CFELSE>
					<TR><TH align="left" style="Color : Red;"> Contract Generation NOT completed. </TH> </TR>
					<CFSET p9 = 0>
					<!-----<CFTRANSACTION action="ROLLBACK"/>------->
					<!--- <CFABORT> --->
				</CFIF>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;">#cfcatch.Detail#<BR>Error in Contract Generation. </TH> </TR>
				<CFSET p9 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>------->
				<!--- <CFABORT> --->
			</CFCATCH>
			</CFTRY>
		</CFIF>
		<CFTRY>
		<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE Daywise START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
		<CFSTOREDPROC procedure="CAPS_NEW_BROKERAGE_DAYWISE" datasource="#Client.database#" returncode="Yes">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT_ID" value="#Trim(Client_ID)#" maxlength="20" null="No">
		</CFSTOREDPROC>
		<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE Daywise STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
	<CFCATCH type="Any">
		<TR><TH align="left" style="Color : Red;">#cfcatch.detail# Day Wise Turnover Brokerage Apply NOT completed </TH> </TR>
		<CFSET p6 = 0>
		<CFSET p8 = 0><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
		<CFABORT>
	</CFCATCH>
	</CFTRY>
	
	<TR><TH align="left">Day Wise Turnover Brokerage calculation completed </TH> </TR>

	<CFTRY>
		<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE Month START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
		<CFSTOREDPROC procedure="CAPS_NEW_BROKERAGE_MONTHWISE" datasource="#Client.database#" returncode="Yes">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT_ID" value="#Trim(Client_ID)#" maxlength="20" null="No">
		</CFSTOREDPROC>
		<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE Month STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
	<CFCATCH type="Any">
		<TR><TH align="left" style="Color : Red;">#cfcatch.detail# Month Wise Turnover Brokerage Apply NOT completed </TH> </TR>
		<CFSET p6 = 0>
		<CFSET p8 = 0><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
		<CFABORT>
	</CFCATCH>
	</CFTRY>
	
	<TR><TH align="left">Month Wise Turnover Brokerage calculation completed </TH> </TR>


	<CFIF	Trim(SCRIP_LIST_FOR_FIXEDBRK_APPLIED)	is not "">
		<CFTRY>
			<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE_OnFixedScrip START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
			<CFSTOREDPROC procedure="CAPS_NEW_BROKERAGE_OnFixedScrip" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT_ID" value="#Trim(Client_ID)#" maxlength="20" null="No">
			</CFSTOREDPROC>
			<CFSET Summery = "#Summery#CAPS_NEW_BROKERAGE_OnFixedScrip STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
		<CFCATCH type="Any">
			<TR><TH align="left" style="Color : Red;">#cfcatch.detail# Fixed Brokerage Apply NOT completed </TH> </TR>
			<CFSET p6 = 0>
			<CFSET p8 = 0>
			<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
			<CFABORT>
		</CFCATCH>
		</CFTRY>
	</CFIF>
	
	<TR><TH align="left"> Fixed Brokerage calculation completed </TH> </TR>
	
	
	
	
		<CFIF Inst_NewProc1 EQ "Y">
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_INST_BROKERAGE START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<CFSTOREDPROC procedure="CAPS_INSTITUTE_NEW_BROKERAGE_FORMAT1" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT_ID" value="" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_INST_BROKERAGE STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;">#cfcatch.detail# Institution Brokerage NOT completed </TH> </TR>
				<CFSET p6 = 0>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
	   		<TR><TH align="left"> Institution Brokerage calculation completed </TH> </TR>
			
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_INST_BROKERAGE START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<CFSTOREDPROC procedure="CAPS_INSTITUTE_NEW_BROKERAGE_FORMAT1_DAYWISE" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT_ID" value="" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_INST_BROKERAGE STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;">#cfcatch.detail# Institution Brokerage NOT completed </TH> </TR>
				<CFSET p6 = 0>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
	   		<TR><TH align="left"> Institution Turn Over Base Brokerage calculation completed </TH> </TR>
			
		</CFIF>
		
		
		<!--- **********************************************************
								CLIENT EXPENSES CALCULATION
		*********************************************************** --->
		<!--- **********************************************************
								TURN-OVER TAX
		*********************************************************** --->
		<CFIF Val(p3) EQ 1>
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_TURNOVER_TAX START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_TURNOVER_TAX" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_TURNOVER_TAX STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
				<CFIF CFSTOREDPROC.StatusCode EQ -1>
					<TR><TH align="left" style="Color : Red;"> Turnover Tax Control Account NOT specified </TH> </TR>
					<CFIF Val(p8) EQ 1>
						<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
					</CFIF>
					<CFSET p8 = 0>
					<!-----<CFTRANSACTION action="ROLLBACK"/>------->
					<CFABORT>
				<CFELSE>
				   <TR><TH align="left"> Turnover Tax Calculation completed </TH> </TR>
					
				</CFIF>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Turnover Tax Calculation NOT completed </TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
				</CFIF>
				<CFSET p3 = 0>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>------->
				<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>

			<!--- **********************************************************
									TRADING STAMP DUTY.
			*********************************************************** --->
			<!--- <CFTRY>
				<CFSTOREDPROC procedure="CAPS_STAMP_DUTY" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				
				<CFIF CFSTOREDPROC.StatusCode EQ -1>
					<tr><th align="left" style="Color : Green;"> &nbsp;&nbsp; Stamp Duty Control Account NOT specified </th> </tr>
					<CFIF Val(p8) EQ 1>
						<tr><th align="left" style="Color : Red;"> Billing NOT done </th> </tr>
					</CFIF>
					<CFSET p8 = 0>
					<!-----<CFTRANSACTION action="ROLLBACK"/>------->
					<CFABORT>
				<CFELSE>
			   		<TR><TH align="left"> Stamp Duty Calculation completed </TH> </TR>
					
				</CFIF>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Stamp Duty Calculation NOT completed </TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
				</CFIF>
				<CFSET p3 = 0>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>------->
				<CFABORT>
			</CFCATCH>
			</CFTRY>--->
		</CFIF> 
		
		<!--- **********************************************************
									OTHER EXPENSES
		*********************************************************** --->
		<CFIF Val(p4) EQ 1>
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_OTHER_EXPENSES START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_OTHER_EXPENSES" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_OTHER_EXPENSES STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
				<CFIF CFSTOREDPROC.StatusCode EQ -1>
					<TR><TH align="left" style="Color : Green;"> &nbsp;&nbsp; Other Expenses Control Accounts NOT specified </TH> </TR>
				<CFELSE>
			   		<TR><TH align="left"> Other Expenses Calculation completed </TH> </TR>
					
				</CFIF>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Other Expenses Calculation NOT completed (#Cfcatch.Detail#)</TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
				</CFIF>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>

		<CFIF Val(p4) EQ 1>
			<CFTRY>	
				<CFSET Summery = "#Summery#CAPS_DELIVERY_EXPENSE START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_DELIVERY_EXPENSE" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_DELIVERY_EXPENSE STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
		   		<TR><TH align="left"> Delivery Expense Calculation completed </TH> </TR>
				
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Delivery Expense Calculation NOT completed </TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
				</CFIF>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>
		
		<CFIF Val(p4) EQ 1>
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_CONTRACT_MINIMUM_EXPENSE START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_CONTRACT_MINIMUM_EXPENSE" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_CONTRACT_MINIMUM_EXPENSE STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
		   		<TR><TH align="left"> Contract Minimum Calculation completed </TH> </TR>
				
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Contract Minimum Expense Calculation NOT completed(#CFCATCH.Detail# </TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
				</CFIF>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>
		<!--- **********************************************************
							BROKERAGE / SERVICE TAX
		*********************************************************** --->
		<!--- **********************************************************
								DELIVERY STAMP DUTY
		*********************************************************** --->
		<CFIF ( Val(p6) EQ 1 ) OR ( Val(p8) EQ 1 )>
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_STAMP_DUTY START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_STAMP_DUTY" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_STAMP_DUTY STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
				<CFIF CFSTOREDPROC.StatusCode EQ -1>
					<TR><TH align="left" style="Color : Green;"> &nbsp;&nbsp; Stamp Duty Control Account NOT specified </TH> </TR>
					<CFIF Val(p8) EQ 1>
						<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
					</CFIF>
					<CFSET p6 = 0>
					<CFSET p8 = 0>
					<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				</CFIF>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Stamp Duty Calculation NOT completed (#CFCATCH.DETAIL#)</TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
				</CFIF>
				<CFSET p6 = 0>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>
		
		<CFIF ( Val(p2) EQ 1 ) OR ( Val(p8) EQ 1 )>
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_SUM_OF_BROKERAGE START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_SUM_OF_BROKERAGE" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_SUM_OF_BROKERAGE STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFIF CFSTOREDPROC.StatusCode EQ -1>
					<TR><TH align="left" style="Color : Red;"> Brokerage Control Account NOT specified </TH> </TR>
					<CFIF Val(p8) EQ 1>
						<TR><TH align="left" style="Color : Red;"> Billing ABORTED </TH> </TR>
					</CFIF>
					<CFSET p8 = 0>
					<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				</CFIF>
				
				<CFIF CFSTOREDPROC.StatusCode EQ -2>
					<TR><TH align="left" style="Color : Red;"> Service Charge Control Account NOT specified </TH> </TR>
					<CFIF Val(p8) EQ 1>
						<TR><TH align="left" style="Color : Red;"> Billing ABORTED </TH> </TR>
					</CFIF>
					<CFSET p8 = 0>
					<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				</CFIF>
				
				<CFIF CFSTOREDPROC.StatusCode EQ 0 AND Val(p8) EQ 0>
					
				</CFIF>
			<CFCATCH type="Any">
				<TR> <TH align="left" style="Color : Red;"> Brokerage Summation NOT completed </TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR> <TH align="left" style="Color : Red;"> Billing ABORTED </TH> </TR>
				</CFIF>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>

		

		<!--- **********************************************************
				Generate STT File
		*********************************************************** --->
		<CFIF p10 EQ 1>
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_STT_CALCULATION START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_STT_CALCULATION" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MARKET_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETL_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@STT_DATE" value="#Trim(Trade_Date)#" maxlength="10" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_STT_CALCULATION STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;">#CFCATCH.DETAIL# STT Generation NOT completed </TH> </TR>
				<CFSET p10 = 0>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>

		<!--- **********************************************************
								TURN-OVER TAX
		*********************************************************** --->
		<CFIF ( Val(p6) EQ 1 ) OR ( Val(p8) EQ 1 )>
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_SECTRAN_TAX START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_SECTRAN_TAX" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_SECTRAN_TAX STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
				<CFIF CFSTOREDPROC.StatusCode EQ -1>
					<TR><TH align="left" style="Color : Red;"> Security Transaction Tax Control Account NOT specified </TH> </TR>
					<CFIF Val(p8) EQ 1>
						<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
					</CFIF>
					<CFSET p8 = 0>
					<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				<CFELSE>
				   <TR><TH align="left"> Security Transaction Tax Calculation completed </TH> </TR>
					
				</CFIF>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Security Transaction Tax Calculation NOT completed(#CFCATCH.Detail#) </TH> </TR>
				<CFIF Val(p8) EQ 1>
					<TR><TH align="left" style="Color : Red;"> Billing NOT done </TH> </TR>
				</CFIF>
				<CFSET p3 = 0>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
		</CFIF>	


		<!--- **********************************************************
								BILLING PROCESS
		*********************************************************** --->
		<CFIF Val(p8) EQ 1>
<!--- **********************************************************
					RE-INITIALIZE BILL VALUES PRIOR TO BILL PROCESSING.
			*********************************************************** --->
			<CFTRY>
				<CFSET Summery = "#Summery#RESET_BILL_VALUES START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="RESET_BILL_VALUES" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@MARKET" value="#Trim(Market)#" maxlength="5" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@MKT_TYPE" value="#Trim(Mkt_Type)#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" 	dbvarname="@BILL_SETTLEMENT_NO" value="#Trim(Settlement_No)#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@TRADE_DATE" value="" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" 	dbvarname="@CLIENT_ID" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#RESET_BILL_VALUES STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Billing Re-Initialization NOT completed </TH> </TR>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>

			<!--- **********************************************************
									BILL NUMBER GENERATION
			*********************************************************** --->
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_BILL_NUMBER_GENERATION START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_BILL_NUMBER_GENERATION" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_BILL_NUMBER_GENERATION STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Bill Number Generation NOT completed </TH> </TR>
				<TR><TH align="left" style="Color : Red;"> Billing ABORTED </TH> </TR>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>

			<!--- **********************************************************
										TRADING MIS MATCH
			*********************************************************** --->
			<!--- <CFTRY>
				<CFQUERY NAME="DropTB" datasource="#Client.database#">
					DROP TABLE ##TRADING_DATA
				</CFQUERY>
				<CFCATCH TYPE="DATABASE">
				</CFCATCH>				
			</CFTRY>
			
			<CFQUERY NAME="SelData" datasource="#Client.database#">
				SELECT	CLIENT_ID, SCRIP_SYMBOL, 
						Case When Buy_Sale = 'BUY' Then Sum(Quantity) Else 0 End As BUY_QTY,
						Case When Buy_Sale = 'SALE' Then Sum(Quantity) Else 0 End As SALE_QTY
				INTO	##TRADING_DATA
				FROM
						TRADE1
				WHERE
						COMPANY_CODE	=	'#COCD#'
				And		Mkt_Type		=	'#Mkt_Type#'
				And		BILL_SETTLEMENT_NO	=	#Settlement_No#
				And		BROKERAGE_TYPE	=	'A'
				AND		OneSideFlag		In	(1,2)
				AND		CLIENT_ID		<>	dbo.getsystemvalue('#COCD#','','CLEARING_MEMBER_CODE')
				AND		ORDER_NUMBER	NOT	LIKE 'NDIR%'
				GROUP BY
						CLIENT_ID, SCRIP_SYMBOL, Buy_Sale
			</CFQUERY>
			
			<CFQUERY NAME="GetData" datasource="#Client.database#">
				SELECT	CLIENT_ID, SCRIP_SYMBOL, SUM(BUY_QTY)BUY_QTY, SUM(SALE_QTY)SALE_QTY
				FROM
						##TRADING_DATA
				GROUP BY
						CLIENT_ID, SCRIP_SYMBOL
				HAVING
						SUM(BUY_QTY - SALE_QTY)	<>	0
			</CFQUERY>
			<CFIF GetData.RECORDCOUNT GT 0>
			<tr><th align="left" style="Color : Red;"> Delivery Calculation not completed</th> </tr>
			<tr><th align="left" style="Color : Red;"> Billing ABORTED </th> </tr>
			<CFSET p8 = 0>
			<!-----<CFTRANSACTION action="ROLLBACK"/>------->
			<CFABORT>
			</CFIF> --->
			<!--- **********************************************************
										DATA FOR JV
			*********************************************************** --->
			
			
			<CFTRY>
				<CFSET Summery = "#Summery#CAPS_JVFILLING START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_JVFILLING" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
					<CFPROCPARAM type="Out" cfsqltype="CF_SQL_VARCHAR" value="#RepeatString('1',2000)#" variable="MESSAGE" dbvarname="@MSG" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_JVFILLING STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
				<CFQUERY NAME="DematJV" datasource="#Client.database#">
					SELECT 
							Scrip_Code, Sum(Debit_Qty)Debit, Sum(Credit_Qty)Credit
					FROM 
							IO_TRANSACTIONS
					WHERE 
							COCD			=	'#COCD#'
					AND		MKT_TYPE		=	'#MKT_TYPE#'
					AND		SETTLEMENT_NO	=	#Settlement_No#
					AND		TRANS_TYPE		=	'SJ'
					GROUP BY 
							Scrip_Code
					Having
							Sum(Debit_Qty - Credit_Qty)	<>	0
				</CFQUERY>

				<CFIF DematJV.RecordCount GT 0>
					<TR><TH align="Center" style="Color : Red;"> Demat JV Not Tallied </TH> </TR>
					<TR>
						<TH align="Left" style="Color : Red;"> 
							<CFLOOP QUERY="DematJV">
								#Scrip_Code#,
							</CFLOOP>
						</TH> 
					</TR>
					<TR><TH align="Center" style="Color : Red;"> Demat JV Not Tallied </TH> </TR>
					<Cftry>
							<CFSTOREDPROC procedure="CAPS_BILLCANCELLATION" datasource="#Client.database#" returncode="Yes">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#mkt_type#" maxlength="2" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#settlement_no#" maxlength="9" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
							</CFSTOREDPROC>
					<cfcatch></cfcatch>
					</Cftry>
					<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
					
				</CFIF>
				<CFIF ( Trim(MESSAGE) EQ "Debit EQUALS Credit" ) OR 
				  		( Trim(MESSAGE) EQ "Some Clients are NOT Billed" )>
					<TR><TH align="Center" style="Color : Blue;"> #Trim(MESSAGE)# </TH> </TR>
				<CFELSEIF Message EQ "CONTROL ACCOUNTS NOT CREATED">
					<CFQUERY NAME="GetControlListNotCreated" datasource="#Client.database#">
						Select Client_ID from Trade_To_Accounts
						WHERE	COMPANY_CODE	=  '#COCD#' 		 
						AND		MKT_TYPE		=  '#Mkt_Type#'
						AND		SETTLEMENT_NO	=  #SETTLEMENT_NO#
						AND		Client_Nature	Is Null
						AND		Client_ID		Not In(Select ControlAccount From Control_Master WHERE	COMPANY_CODE	=  '#COCD#' )
					</CFQUERY>
					<TR><TH align="Center" style="Color : Red;"> #Trim(MESSAGE)# </TH> </TR>
					<CFLOOP QUERY="GetControlListNotCreated">
					<TR><TH align="LEFT" style="Color : Red;"> #Trim(Client_ID)# </TH> </TR>
					</CFLOOP>
				<CFELSE>
					<TR><TH align="Center" style="Color : Red;"> #Trim(MESSAGE)# </TH> </TR>
					<Cftry>
							<CFSTOREDPROC procedure="CHECK_BILL" datasource="#Client.database#" returncode="Yes">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#mkt_type#" maxlength="2" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#settlement_no#" maxlength="9" null="No">
								<cfprocresult resultset="1" name="Res1">
								<cfprocresult resultset="2" name="Res2">
								<cfprocresult resultset="3" name="Res3">
								<cfprocresult resultset="4" name="Res4">
							</CFSTOREDPROC>
							<Cfset FileVar ="Net Amt :#Res1.NET_AMT##chr(10)##chr(10)#">
							<Cfset FileVar ="#FileVar#TRADE_TO_ACCOUNTS#chr(10)#">
							<cfloop query="Res2">
								<Cfset FileVar ="#FileVar##CLIENT_ID# :#NET_AMT##chr(10)#">
							</cfloop>
							<Cfset FileVar ="#FileVar#CLIENT_EXPENSES#chr(10)##chr(10)#">
							<cfloop query="Res3">
								<Cfset FileVar ="#FileVar##EXPENSEACCOUNT# :#NET_AMT##chr(10)#">
							</cfloop>
							<Cfset FileVar ="#FileVar#TRADE_TO_ACCOUNTS#chr(10)##chr(10)#">
							<cfloop query="Res4">
								<Cfset FileVar ="#FileVar#BROKERAGE :#BROKERAGE##chr(10)#">
								<Cfset FileVar ="#FileVar#TOC	:#TOC##chr(10)#">
								<Cfset FileVar ="#FileVar#ST 	:#ST##chr(10)#">
								<Cfset FileVar ="#FileVar#STT	:#STT##chr(10)#">
								<Cfset FileVar ="#FileVar#STAMP	:#STAMP##chr(10)#">
								<Cfset FileVar ="#FileVar#OTH 	:#OTH##chr(10)#">
							</cfloop>
							<cffile  action="write" file="C:\CFUSIONMX7\WWWROOT\REPORTS\BillMisMatch.txt" output="#FileVar#" >
							<cfcatch></cfcatch>
					</Cftry>	
					<Cftry>
							<CFSTOREDPROC procedure="CAPS_BILLCANCELLATION" datasource="#Client.database#" returncode="Yes">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#mkt_type#" maxlength="2" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#settlement_no#" maxlength="9" null="No">
								<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
							</CFSTOREDPROC>
					<cfcatch></cfcatch>
					</Cftry>	
					<!-----<CFTRANSACTION action="ROLLBACK"/>-------><cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				</CFIF>
			<CFCATCH type="Any">
				<Cftry>
						<CFSTOREDPROC procedure="CAPS_BILLCANCELLATION" datasource="#Client.database#" returncode="Yes">
							<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
							<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#mkt_type#" maxlength="2" null="No">
							<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#settlement_no#" maxlength="9" null="No">
							<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
						</CFSTOREDPROC>
				<cfcatch></cfcatch>
				</Cftry>	
				<TR><TH align="left" style="Color : Red;">#CFCATCH.DETAIL# JV Records Filling NOT completed </TH> </TR>
				<TR><TH align="left" style="Color : Red;"> Billing ABORTED </TH> </TR>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>------->
				<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>

			<!--- **********************************************************
									PRE JV POSTING CHECKS
			*********************************************************** --->
			<!---<CFTRY>---->
				<CFSET Summery = "#Summery#CAPS_PRE_JVPOSTING_CHECKS START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="CAPS_PRE_JVPOSTING_CHECKS" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="Out" cfsqltype="CF_SQL_VARCHAR" value="#RepeatString('1',2000)#" variable="MESSAGE" dbvarname="@MESSAGE" null="No">
					
					<CFPROCRESULT name="InvalidAccounts">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#CAPS_PRE_JVPOSTING_CHECKS STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
				<CFIF InvalidAccounts.RecordCount GT 0>
					<TR><TH align="left" style="Color : Fuchsia;"> <u>List of Accounts NOT Created in FA</u> </TH> </TR>
					<CFLOOP query="InvalidAccounts">
						<TR>
							<TH align="left" style="Color : Red;"> #Trim(Client_ID)# </TH> 
						</TR>
					</CFLOOP>
					<TR><TH align="left" style="Color : Red;"> JV NOT Posted </TH> </TR>
					<TR><TH align="left" style="Color : Red;"> Billing ABORTED </TH> </TR>
					<CFSET p8 = 0>
					<!-----<CFTRANSACTION action="ROLLBACK"/>------->
					
					<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
					<CFABORT>
				<CFELSE>
					<TR><TH align="Center" style="Color : Green;"> JV POSTED </TH> </TR>
				</CFIF>
			<!---<CFCATCH type="Any">
				<tr><th align="left" style="Color : Red;"> JV Pre-Posting Checks NOT completed </th> </tr>
				<tr><th align="left" style="Color : Red;"> Billing NOT Done </th> </tr>
				<CFSET p8 = 0>
				<!-----<CFTRANSACTION action="ROLLBACK"/>------->
				<CFABORT>
			</CFCATCH>
			</CFTRY>----->
		</CFIF>
	
		<CFIF Val(p8) EQ 1 AND GetTransfer_Cocd_CL2.TRANSFERING_COCD_FOR_CL2 NEQ "">
			<CFTRY>
				<CFSET Summery = "#Summery#GENERATE_DATA_FOR_CL2 START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="GENERATE_DATA_FOR_CL2" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="8" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trim(Trade_Date)#" maxlength="10" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#GENERATE_DATA_FOR_CL2 STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				
				<TR><TH align="Center" style="Color : Green;"> ** </TH> </TR>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Billing For CL2 NOT Done(#cfcatch.Detail#) </TH> </TR>
<!--- 				<CFSET p8 = 0>
				<CFABORT>	 --->
			</CFCATCH>
			</CFTRY>
		</CFIF>
	<CFIF	P12 EQ 1 AND P8 EQ 1
		AND (Mkt_Type	Is	"N"	OR Mkt_Type	Is	"T" OR Mkt_Type	Is	"A" OR Mkt_Type	Is	"C" OR Mkt_Type	Is	"H" OR Mkt_Type	Is	"H2"
		)>
			<CFTRY>
				<CFSET Summery = "#Summery#REMESHIRE_PROCESS STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC datasource="#Client.database#" PROCEDURE="REMESHIRE_PROCESS">
					<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@COMPANY_CODE" VALUE="#COCD#" NULL="No">
					<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@MktType" VALUE="#Mkt_Type#" NULL="No">
					<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@SetlNo" VALUE="#Settlement_No#" NULL="No">
					<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@From_Date" VALUE="#Trade_Date#" NULL="No">
					<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@To_Date" VALUE="#Trade_Date#" NULL="No">
					<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FinStart" VALUE="#FinStart#" NULL="No">
					<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Remeshire_Code" VALUE="" NULL="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#REMESHIRE_PROCESS START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<TR><TH align="Center" style="Color : Green;"> *** </TH> </TR>
			<CFCATCH type="Any">
				<TR><TH align="left" style="Color : Red;"> Remeshire Process not completed </TH> </TR>
				<CFSET p8 = 0>
				<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>
				<CFABORT>
			</CFCATCH>
			</CFTRY>
	</CFIF>
	
	<CFIF  Val(p8) EQ 1>
<!--- 		<cfquery datasource="#Client.database#" name="Up">
				UPDATE CLIENT_EXPENSES
				SET CLIENT_CONTRACT_NO = CONTRACT_NO
				FROM TRADE1 A,CLIENT_EXPENSES B
				WHERE A.COMPANY_CODE = B.COMPANY_CODE
				AND A.CLIENT_ID= B.CLIENT_ID
				AND A.MKT_TYPE = B.MKT_TYPE
				AND ISNULL(B.CLIENT_CONTRACT_NO,0) = 0  
				AND A.SETTLEMENT_NO = B.SETTLEMENT_NO
				AND A.COMPANY_CODE 	= '#COCD#' 
				AND A.MKT_TYPE		= '#mkt_type#'
				AND A.SETTLEMENT_NO	='#Settlement_No#'
		</cfquery> --->
				<cfquery datasource="#Client.database#" name="Up">
						INSERT INTO REPLICATED_TRADE
						(
							MKT_TYPE,SETTLEMENT_NO,COMPANY_CODE,REPLICATED,MARKET 
						)
						VALUES
						(
								'#mkt_type#','#Settlement_No#','#COCD#','N','CAPS'
						)
				</cfquery>
		<CFTRY>
			<CFSET Summery = "#Summery#GENERATE jv tRF SUMMARY START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
			<CFSTOREDPROC procedure="CAPS_JVPROTRF" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="20" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="" maxlength="10" null="No">
			</CFSTOREDPROC>
			<CFSET Summery = "#Summery#GENERATE jv tRF SUMMARY STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
		<CFCATCH TYPE="DATABASE">
			TRD : #CFCATCH.Detail#
		</CFCATCH>
		</CFTRY>
		

		<CFIF UCase(Mkt_Type) EQ 'T' OR UCase(Mkt_Type) EQ 'N'>
		<cfelse>
				<CFTRY>
					<CFSET Summery = "#Summery#GENERATE TRADE1 SUMMARY START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
					<cfquery datasource="#Client.database#" name="gETDATA">
							EXEC [FA_POST_IOSHORTAGE_REVERSE] '#COCD#',#FINSTART#,#Settlement_No#,'#Mkt_Type#'
					</cfquery>
					<CFSET Summery = "#Summery#GENERATE TRADE1 SUMMARY STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
				<CFCATCH TYPE="DATABASE">
					FA_POST_IOSHORTAGE_REVERSE : #CFCATCH.Detail#
				</CFCATCH>
				</CFTRY>
		</cfif>
		
	</CFIF>
	
	<CFIF  COCD EQ 'NSE_CASH' AND MKT_TYPE EQ 'N' AND GetTransfer_Cocd_CL2.SOFT EQ "ARB" AND GetTransfer_Cocd_CL2.CASHLEDGERMTM EQ "Y">
		<cftry>
			<cfquery datasource="#Client.database#" name="Up">
					EXEC FA_SUDA_PL_POST  '#Trade_Date#','#Trim(COCD)#','#FINSTART#'
			</cfquery>
		<cfcatch></cfcatch>
		</cftry>	
	</CFIF>
		
	<CFIF p15 EQ 1>
			<CFTRY>
				<!--- <CFTRY>
				<CFSET Summery = "#Summery#GENERATE TRADE1 SUMMARY START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
				<CFSTOREDPROC procedure="TRADE1_SUMMARY_DATA" datasource="#Client.database#" returncode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#COCD#" maxlength="20" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Settlement_No#" maxlength="9" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="" maxlength="10" null="No">
				</CFSTOREDPROC>
				<CFSET Summery = "#Summery#GENERATE TRADE1 SUMMARY STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
			<CFCATCH TYPE="DATABASE">
				TRD : #CFCATCH.Detail#
			</CFCATCH>
			</CFTRY>	 --->
		
			<CFSET Summery = "#Summery#GENERATE TRADE1 SUMMARY START : #TimeFormat(now(),'mm:ss:l')##chr(10)#">				
			<CFSTOREDPROC procedure="PMS_ACCOUNTS_POSTING_PROCESS" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TRADE_DATE" VALUE="#Trade_Date#" NULL="No">
				<CFIF VAL(p8) EQ 1>
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Bill" value="Y" maxlength="9" null="No">
				<CFELSE>
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@Bill" value="N" maxlength="9" null="No">
				</CFIF>
			</CFSTOREDPROC>
			<CFSET Summery = "#Summery#GENERATE PMS SUMMARY STOP : #TimeFormat(now(),'mm:ss:l')##chr(10)#">
			<TR><TH align="Center" style="Color : Green;"> PMS Process Completer </TH> </TR>
		<CFCATCH TYPE="DATABASE">
					PMS : #CFCATCH.Detail#- #CFCATCH.Message#
		</CFCATCH>
		</CFTRY>
	</CFIF>
		<CFSET CALLER.ReturnCode	=	0>
			<TR style="display:none"><TH align="left" > <PRE>#Summery#</PRE> </TH> </TR>
</TABLE>


<cFSET  A= ReportlogUpdate('#ReportLogCount#','')>

</CFOUTPUT>