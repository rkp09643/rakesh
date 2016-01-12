<CFINCLUDE TEMPLATE="../../Common/Export_Text_File.cfm">
	<CFSET finstyr = "#FinStart#">
	<CFSET finendyr = "#FinEnd#">
<CFOUTPUT>	


<CFSET Client_ID ="#txtClientID#">
<CFSET Settlement_No ="#txtSetlId#">
<CFSET Trade_Date = "#txtOrderDate#">
	<CFQUERY NAME="GetClient" datasource="#Client.database#">
		SELECT	
				Distinct A.CLIENT_ID, A.CONTRACT_NO, CONVERT(CHAR(10), TRADE_DATE,112)Trade_Date_YearFormat
		FROM	TRADE1 A (INDEX = IDX_CONTRACTNO_TRADE1)
		WHERE
			A.COMPANY_CODE 	= 	'#COCD#'
		And MKT_TYPE 		= 	'#Mkt_Type#' 
		And SETTLEMENT_NO 	= 	 #Settlement_No#
		AND	CONTRACT_NO		>	0
		And	Left(Order_Number, 4)	!=	'NDIR'
		<CFIF Trim(txtScrip)	NEQ	"">
		And	A.Scrip_Symbol	=	'#txtScrip#'
		</CFIF>
		<CFIF Trim(txtContractNo)	NEQ	"">
		And Contract_No	=	'#txtContractNo#'
		</CFIF>
		And a.CLIENT_ID		=	'#Client_ID#'
	</CFQUERY>


	<CFQUERY NAME="GetSetlDate" datasource="#Client.database#">
		SELECT	CONVERT(CHAR(10), FUNDS_PAYIN_DATE,112)FUNDS_PAYIN_DATE
		FROM
				SETTLEMENT_MASTER
		WHERE
				Company_Code	=	'#Cocd#'
		And 	MKT_TYPE 		= 	'#Mkt_Type#' 
		And 	SETTLEMENT_NO 	= 	 #Settlement_No#
	</CFQUERY>
	
	<CFQUERY NAME="GetCompanyDetail" datasource="#Client.database#">
		SELECT	Sebi_Reg_No, Company_Name, Exchange_Mapin,COMPANY_ADDRESS
		FROM
				Company_Master
		Where
				Company_Code	=	'#COCD#'		
	</CFQUERY>
	
	<CFQUERY NAME="GetClientDetail" datasource="#Client.database#">
		SELECT	Client_SebiRegnNo, Unique_Cl_ID,Client_InstNo
		FROM
				Client_Master A, Client_Details B
		Where
				Company_Code	=	'#COCD#'
		And		A.Client_ID		=	B.Client_ID
		And		A.Client_ID		=	'#Client_ID#'
	</CFQUERY>
	
	<CFQUERY NAME="GetSystemDetail" datasource="#Client.database#">
		SELECT	
				CLEARING_MEMBER_CODE, Exchange_Clearing_Code,
				IsNull(ClientList_STTNotApplied, '~')ClientList_STTNotApplied
		FROM
				System_Settings
		Where
				Company_Code	=	'#COCD#'		
	</CFQUERY>
		
	<CFQUERY NAME="GetDBSTTDetail" datasource="#Client.database#">
		SELECT	STT As BSTT
		FROM
				STT_DETAILS
		WHERE
				COMPANY_CODE = '#COCD#'
		AND  	CONVERT(DATETIME, FROM_DATE, 103) <= CONVERT(DATETIME, '#TRADE_DATE#', 103)
		AND  	CONVERT(DATETIME, ISNULL(TO_DATE, CONVERT(DATETIME, '#TRADE_DATE#', 103)), 103) >= CONVERT(DATETIME, '#TRADE_DATE#', 103)
		AND		CAPS_TRADE_TYPE	=	'D'
		AND		CAPS_BUY_SALE	=	'B'
	</CFQUERY>

	<CFQUERY NAME="GetDSSTTDetail" datasource="#Client.database#">
		SELECT	STT As SSTT
		FROM
				STT_DETAILS
		WHERE
				COMPANY_CODE = '#COCD#'
		AND  	CONVERT(DATETIME, FROM_DATE, 103) <= CONVERT(DATETIME, '#TRADE_DATE#', 103)
		AND  	CONVERT(DATETIME, ISNULL(TO_DATE, CONVERT(DATETIME, '#TRADE_DATE#', 103)), 103) >= CONVERT(DATETIME, '#TRADE_DATE#', 103)
		AND		CAPS_TRADE_TYPE	=	'D'
		AND		CAPS_BUY_SALE	=	'S'
	</CFQUERY>

	<CFSET	BSTT	=	GetDBSTTDetail.BSTT>
	<CFSET	SSTT	=	GetDSSTTDetail.SSTT>
	
	<CFIF Exchange EQ "BSE">
		<CFSET SetlNo =  #changeSetlNo(Trim(Settlement_No), "ForText")#>		
	<CFELSE>
		<CFSET SetlNo =  #Settlement_No#>		
	</CFIF>
				
	<CFIF NOT DIRECTORYEXISTS("C:\STPFILES\")>
		<CFDIRECTORY action="create" directory="C:\STPFILES\">
	</CFIF>
	<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#txtContractNo#">	
	<CFSET	OnlyFileName	=	"#MKT_TYPE#_#SETTLEMENT_NO#_#CLIENT_ID#_#SCRIP_SYMBOL_ORDER_NO#.csv">
	<CFSET	File_Name	=	"C:\STPFILES\#OnlyFileName#">
	<CFSET	TradeDate1	=	"#GetClient.Trade_Date_YearFormat#">
	<CFSET	TradeDate1	=	"#TRIM(TradeDate1)#">
	<CFSET	PayINDate	=	"#GetSetlDate.Funds_Payin_Date#">
	<!----<cfset	BatchNo		=	"#GetClient.Trade_Date_YearFormat##RepeatString("0", (3 - Len(GenerationNo)))##GenerationNo#">----->
	<CFSET	Broker_Sebi_RegnNo			=	GetCompanyDetail.Sebi_Reg_No>
	<CFSET	Exchange_Mapin				=	GetCompanyDetail.Exchange_Mapin>
	<CFSET	Exchange_Clearing_Code		=	GetSystemDetail.Exchange_Clearing_Code>
	<CFSET	ClientList_STTNotApplied	=	GetSystemDetail.ClientList_STTNotApplied>
	<CFSET	Client_Sebi_RegnNo1			=	GetClientDetail.Client_SebiRegnNo>
	<CFSET	Unique_Cl_ID1				=	GetClientDetail.Unique_Cl_ID>
	<CFSET	COMPANY_ADDRESS1			=	GetCompanyDetail.COMPANY_ADDRESS>
	<CFSET	CUST_SEBI_REG_NO			=	GetClientDetail.Client_InstNo>
	
	<CFIF	Mkt_Type	EQ	"N">
		<CFSET	Mkt_Type_Text	=	"DR">
	<CFELSEIF	Mkt_Type	EQ	"T">
		<CFSET	Mkt_Type_Text	=	"TT">
	<CFELSEIF	Mkt_Type	EQ	"A">
		<CFSET	Mkt_Type_Text	=	"AR">
	<CFELSEIF	Mkt_Type	EQ	"H">
		<CFSET	Mkt_Type_Text	=	"OT">	
	<CFELSEIF	Mkt_Type	EQ	"H2">
		<CFSET	Mkt_Type_Text	=	"OT">			
	</CFIF>
	
	<CFFILE ACTION="WRITE" FILE="#File_Name#" OUTPUT="" ADDNEWLINE="NO">
	<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="{}" ADDNEWLINE="YES">
	<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|11|1#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#GetClient.recordcount#|#DATEFORMAT(NOW(),'YYYYMMDD')#|#TIMEFORMAT(NOW(),'HHMMSS')#" ADDNEWLINE="YES">
	<Cfset Sr=0>	
	
	<CFLOOP QUERY="GetClient">
		<CFSTOREDPROC PROCEDURE="CAPS_REPORTS_CONTRACT" datasource="#Client.database#">
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@COMPANY_CODE" VALUE="#Trim(Ucase(COCD))#" MAXLENGTH="8" NULL="No"> 
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@MKT_TYPE" VALUE="#Trim(Ucase(Mkt_type))#" MAXLENGTH="2" NULL="No"> 
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_NUMERIC" DBVARNAME="@SETTLEMENT_NO" VALUE="#Trim(Val(settlement_no))#" MAXLENGTH="7" NULL="No"> 
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TRADE_DATE" VALUE="#Trim(TRADE_DATE)#" NULL="No"> 
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@CLIENTLIST" VALUE="'#Trim(Ucase(CLIENT_ID))#'" MAXLENGTH="1000" NULL="No"> 
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@CONTRACTNO" VALUE="#CONTRACT_NO#" MAXLENGTH="10" NULL="No">
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_CHAR" DBVARNAME="@REPORT_TYPE" VALUE="D" MAXLENGTH="5" NULL="No"> 
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_CHAR" DBVARNAME="@PAPER_TYPE" VALUE="1" MAXLENGTH="1" NULL="No">
			<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@ORDER" VALUE="Groupwise" NULL="No">
			<CFPROCPARAM TYPE="in" CFSQLTYPE="cf_sql_varchar" DBVARNAME="@Contra" VALUE="Single" NULL="no">
			<CFPROCRESULT NAME="ContData">
		</CFSTOREDPROC>
		<CFSET CONTRACT_DATA = "{}#CHR(10)#">
		<CFSET CONTRACT_DATA = "#CONTRACT_DATA##BatchNumber#|11|1#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|1|#DATEFORMAT(NOW(),'YYYYMMDD')#|#TIMEFORMAT(NOW(),'HHMMSS')##CHR(10)#">
		<Cfset Sr=currentrow>
		<CFLOOP QUERY="ContData">
			<CFSET	CHANGED_TRADE_NO	=	"#RepeatString("0", (16 - Len(TRADE_NUMBER)))##TRADE_NUMBER#">
			<CFSET	CHANGED_ORDER_NO	=	"#RepeatString("0", (16 - Len(ORDER_NO)))##ORDER_NO#">
			
			<Cfset INST_GROSS = 0>
			<Cfset INST_NET = 0>
			
			<CFQUERY NAME="GetSttApplied" datasource="#Client.database#">
				Select 
						Client_ID ,INST_PRINTSTT,ISNULL(INST_GROSS_ROUNDING,0) INST_GROSS_ROUNDING,
											ISNULL(INST_NET_ROUNDING,0)  INST_NET_ROUNDING
				From
						Client_Master
				Where
						Company_Code	=	'#COCD#'
				And		Client_ID		=	'#Client_ID#'				
			</CFQUERY>
			
			<CFIF	val(GetSttApplied.INST_GROSS_ROUNDING)	neq	0>
				<Cfset INST_GROSS =  GetSttApplied.INST_GROSS_ROUNDING>
			</CFIF>
			<CFIF	val(GetSttApplied.INST_NET_ROUNDING)	neq	0>
				<Cfset INST_NET =  GetSttApplied.INST_NET_ROUNDING>
			</CFIF>
		
			<CFIF	GetSttApplied.INST_PRINTSTT	eq	'N'>
				<CFSET	APPLY_STT	=	FALSE>
			<CFELSE>
				<CFSET	APPLY_STT	=	TRUE>	
			</CFIF>
			
			<CFIF Exchange eq "BSE">
				<CFSET TYPEFOREXCHANGE = "01">			
				<CFSET	BOISL_NO					=	100002303>	
			<CFELSE>
				<CFSET TYPEFOREXCHANGE = "23">			
				<CFSET	BOISL_NO					=	100013581>	
			</CFIF>
			
			<CFQUERY NAME="GetClientBrkDetail" datasource="#Client.database#">
				Select	Adjustment_Code, Del_Adjustment_Code
				From	Brokerage_Apply
				Where	
						Company_Code	=	'#COCD#'
				AND		CLIENT_ID		=	'#Trim(CLIENT_ID)#'
				AND		CONVERT(DATETIME, '#TRADE_DATE#', 103) 	BETWEEN	CONVERT(DATETIME, START_DATE, 103)
																AND		IsNull( CONVERT(DATETIME, END_Date, 103), CONVERT(DATETIME, '#TRADE_DATE#', 103))
			</CFQUERY>
		
			<CFSET	DelAdjCode	=	GetClientBrkDetail.Del_Adjustment_Code>
						
			<cfif	GetClientBrkDetail.Adjustment_Code	EQ	4
			OR		GetClientBrkDetail.Adjustment_Code	EQ	13 OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	21 OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	23
			OR		GetClientBrkDetail.Adjustment_Code	EQ	14
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	4
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	13
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	14>	
					<cfset	DecimalVal	=	9999>
					<cfset	BRKDECIMAL	=	4>
			<cfelse>		
					<cfset	DecimalVal	=	99>
					<cfset	BRKDECIMAL	=	2>
			</cfif>
			
			<cfinclude template="STP_Buy_Sale_Logic.cfm">
<!--- 			<CFIF	BQTY	GT	0>
				<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
				<CFSET	QTY		=	BQTY>
				<CFSET	BRATE1	=	BRATE>
				<CFSET	BBRK1	=	TRIM(NUMBERFORMAT(BBRK,'9999999999999.999999'))>
				<CFSET	BNetRATE1	=	BNetRATE>
				<CFSET ACTBUY_SALE = 'B'>
				
				<CFSET	BRATEDecimal	=	Find(".",BRATE)>				
				<!--- <CFSET	BRATE1	= 	Trim(NumberFormat(Trim(BRATE),'9999999.'&RepeatString(9,INST_GROSS))) >				 --->
				<CFSET	BRATE1	= 	Trim(NumberFormat(Mid(Trim(BRATE), 1, BRATEDecimal+INST_GROSS),'9999999.'&RepeatString(9,INST_GROSS))) >				
				
				<CFSET BACTAMT = TRIM(NUMBERFORMAT(BQTY * BRATE1,'999999999999999.999999'))>
				<CFSET BACTAMTDecimal	=	Find(".",BACTAMT)>
				<CFSET BACTAMT1 = Trim(NumberFormat(Mid(Trim(BACTAMT), 1, BACTAMTDecimal+2),'99999999999999.'&RepeatString(9,2)))>
				
				<CFSET	BBRK1Decimal	=	Find(".",TRIM(BBRK1))>
				<CFSET	BBRK2			= 	TRIM(Numberformat(Mid(Trim(BBRK1), 1, BBRK1Decimal+BRKDECIMAL),'999999999.'&RepeatString(9,BRKDECIMAL)))>					
				
				<CFSET	BNETRATEDecimal	=	Find(".",BNETRATE)>
				<!--- <CFSET	BNETRATE1	= 	Trim(NumberFormat(BNETRATE,'9999999.'&RepeatString(9,INST_NET))) >								 --->
				<CFSET	BNETRATE1	= 	Trim(NumberFormat(Mid(Trim(BNETRATE), 1, BNETRATEDecimal+INST_NET),'9999999.'&RepeatString(9,INST_NET))) >				
				<CFSET	RATE	=	BRATE1>
				<CFSET	BRK		=	BBRK2>
				<CFSET	NetRATE	=	BNetRATE1>
				
				
				<CFSET	TOTBBRK		=	TRIM(NUMBERFORMAT(BQTY	*	BBRK2,"999999999.999999"))>
				<CFSET	BBRKDecimal	=	Find(".",TOTBBRK)>
				<CFSET	TOTBBRK1	= 	Trim(NumberFormat(Mid(Trim(TOTBBRK), 1, BBRKDecimal+2),'9999999.99')) >
				
				<CFSET	TOTBrk	=	TOTBBRK1>
				<CFSET	AMT =		BACTAMT1+TOTBBRK1>
				<!--- <CFSET	AMT		=	Trim(NumberFormat(BQTY * BNetRATE1,"99999999.99"))> --->
				<CFSET	Actual_Amt	=	BACTAMT1>

				<CFSET	BUY_SALE	=	"BUYI">
				<CFSET	BUY_SALE2	=	"SELL">
				<CFSET	BUY_SALE3	=	"DEAG">
				<CFSET	RatePlusBrk	=	"+">
				
				<CFIF	APPLY_STT>
					<CFSET	STT	=	((BQTY * BRATE1 * BSTT) / 100)>
				<CFELSE>
					<CFSET	STT	=	0>
				</CFIF>

				<CFSET	AMT1	=	Trim((AMT + NumberFormat(STT, "9999999999")))>
				<CFSET	STT		=	Trim(NumberFormat(STT, "999999999"))>
				<CFSET  AMT		=	NumberFormat(AMT1,"99999999999.99")>
					
			<CFELSE>
				<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
				<CFSET	QTY		=	SQTY>
				<CFSET	SRATE1	=	SRATE>
				<CFSET	SBRK1	=	SBRK>
				<CFSET	SNetRATE1	=	SNetRATE>
				<CFSET ACTBUY_SALE = 'S'>
				
				<CFSET	SRATEDecimal	=	Find(".",SRATE)>
				<CFSET	SRATE1	= 	Trim(NumberFormat(Trim(SRATE),'9999999.'&RepeatString(9,INST_GROSS))) >								

				<CFSET SACTAMT1 = TRIM(NUMBERFORMAT(SQTY * SRATE1,'999999999999999.99'))>
				
				<CFSET	SBRK1Decimal	=	Find(".",TRIM(SBRK1))>
				<CFSET	SBRK2			= 	TRIM(Numberformat(Mid(Trim(SBRK1), 1, SBRK1Decimal+BRKDECIMAL),'999999999.'&RepeatString(9,BRKDECIMAL)))>					
				
				<CFSET	SNETRATEDecimal	=	Find(".",SNETRATE)>
				<CFSET	SNETRATE1	= 	Trim(NumberFormat(SNETRATE,'9999999.'&RepeatString(9,INST_NET))) >									
				
				<CFSET	TOTSBRK				=	TRIM(NUMBERFORMAT(SQTY	*	SBRK2,"999999999.999999"))>
				<CFSET	SBRKDecimal	=	Find(".",TOTSBRK)>
				<CFSET	TOTSBRK1	= 	Trim(NumberFormat(Mid(Trim(TOTSBRK), 1, SBRKDecimal	+2),'9999999.99')) >				
				<!--- <CFIF	DelAdjCode	EQ	13 And SRATE GT 0>
					<CFSET	SRATE1Decimal	=	Find(".",SRATE1)>
					<CFSET	SRATE1			= 	Trim(NumberFormat(Mid(Trim(SRATE1), 1, SRATE1Decimal+4),"9999999.9999"))>

					<CFSET	SBRK1Decimal	=	Find(".",SBRK1)>
					<CFSET	SBRK1			= 	Trim(NumberFormat(Mid(Trim(SBRK1), 1, SBRK1Decimal+4),"9999999.9999"))>
					
					<CFSET	SNetRATE1Decimal	=	Find(".",SNetRATE1)>
					<CFSET	SNetRATE1			= 	Trim(NumberFormat(Mid(Trim(SNetRATE1), 1, SNetRATE1Decimal+4),"9999999.9999"))>
				<CFELSE>
					<CFSET	SRATE1	=	NumberFormat(SRATE,"99999999." & DecimalVal)>
					<CFSET	SBRK1	=	NumberFormat(SBRK,"99999999." & DecimalVal)>
					<CFSET	SNetRATE1	=	NumberFormat(SNetRATE,"99999999." & DecimalVal)>
				</CFIF> --->
				
				<CFSET	RATE	=	SRATE1>
				<CFSET	BRK		=	SBRK2>
				<CFSET	TOTBrk	=	TOTSBRK1>
				<CFSET	NetRATE	=	SNETRATE1>
				<CFSET	Actual_Amt	=	SACTAMT1>
				<CFSET	AMT =		SACTAMT1-TOTSBRK1>
				<CFSET	BUY_SALE	=	"SELL">
				<CFSET	BUY_SALE2	=	"BUYR">
				<CFSET	BUY_SALE3	=	"REAG">
				<CFSET	RatePlusBrk	=	"+">
				<CFIF	APPLY_STT>
					<CFSET	STT	=	((SQTY * SRATE1 * SSTT) / 100)>
				<CFELSE>
					<CFSET	STT	=	0>
				</CFIF>
				<CFSET	AMT1	=	Trim((AMT - NumberFormat(STT, "99999999")))>
				<CFSET	STT		=	Trim(NumberFormat(STT, "99999999"))>
				<CFSET  AMT     =   NumberFormat(AMT1,"99999999999.99")>  
			</CFIF>
 --->				

			
			<!---CN Detail Record --->
				<!--- ORDER CONFIRMATION TIME : #DATEFORMAT(NOW(),'YYYYMMDD')##TIMEFORMAT(NOW(),'HHMMSS')#	 --->																			<!--- #TRIM(TRADEDATE1)##REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")# --->																		
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|15|#Sr#|515|1|1#LEFT(UCASE(TRIM(CUST_SEBI_REG_NO)),12)#|#Contract_Note_Text#|#TradeDate1#|1||#TRIM(PayINDate)#||#TradeDate1#|#RATE#|#Brk#|#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#TYPEFOREXCHANGE#|#ACTBUY_SALE#|1|#LEFT(TRIM(Client_Sebi_RegnNo1),12)#|#LEFT(TRIM(UNIQUECLCODE),10)#|#QTY#|#TRIM(ISIN)#~#TRIM(SCRIP_NAME)#||#Mkt_Type_Text#|#SetlNo#|1#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#LEFT(TRIM(UCASE(COMPANY_ADDRESS1)),140)#|1#BOISL_NO#|#ACTUAL_AMT#|#TotBrk#|0|#STT#|#TRIM(AMT)#|" ADDNEWLINE="YES">
				<CFSET CONTRACT_DATA = "#CONTRACT_DATA##BatchNumber#|15|#Sr#|515|1|1#LEFT(TRIM(Client_Sebi_RegnNo1),12)#|#Contract_Note_Text#|#TradeDate1#|1||#PayINDate#||#TradeDate1#|#RATE#|#Brk#|#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#TYPEFOREXCHANGE#|#ACTBUY_SALE#|1|#LEFT(TRIM(Client_Sebi_RegnNo1),12)#|#LEFT(TRIM(UNIQUECLCODE),10)#|#QTY#|#TRIM(ISIN)#||#Mkt_Type_Text#|#SetlNo#|1#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#LEFT(TRIM(UCASE(COMPANY_ADDRESS1)),140)#|1#BOISL_NO#|#ACTUAL_AMT#|#TotBrk#|0|#STT#|#TRIM(AMT)#|#CHR(10)#">
			
			<!---Detail Record  (Trade) --->
				<cfif OptContractInf EQ "SUMMARY">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|13|3|#Contract_Note_Text#|#CHANGED_ORDER_NO#|#REPLACE(TRIM(CHANGED_TRADE_NO),'M','')#|#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#|#QTY#|#RATE#" ADDNEWLINE="YES">
					<CFSET CONTRACT_DATA = "#CONTRACT_DATA##BatchNumber#|13|1|#Contract_Note_Text#|#CHANGED_ORDER_NO#|#REPLACE(TRIM(CHANGED_TRADE_NO),'M','')#|#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#|#QTY#|#RATE##CHR(10)#">	
				<cfelse>
					<CFSTOREDPROC PROCEDURE="CAPS_REPORTS_CONTRACT" datasource="#Client.database#">
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@COMPANY_CODE" VALUE="#Trim(Ucase(COCD))#" MAXLENGTH="8" NULL="No"> 
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@MKT_TYPE" VALUE="#Trim(Ucase(Mkt_type))#" MAXLENGTH="2" NULL="No"> 
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_NUMERIC" DBVARNAME="@SETTLEMENT_NO" VALUE="#Trim(Val(settlement_no))#" MAXLENGTH="7" NULL="No"> 
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TRADE_DATE" VALUE="#Trim(TRADE_DATE)#" NULL="No"> 
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@CLIENTLIST" VALUE="'#Trim(Ucase(CLIENT_ID))#'" MAXLENGTH="1000" NULL="No"> 
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@CONTRACTNO" VALUE="#CONTRACT_NO#" MAXLENGTH="10" NULL="No">
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_CHAR" DBVARNAME="@REPORT_TYPE" VALUE="D" MAXLENGTH="5" NULL="No"> 
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_CHAR" DBVARNAME="@PAPER_TYPE" VALUE="1" MAXLENGTH="1" NULL="No">
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@ORDER" VALUE="Groupwise" NULL="No">
						<CFPROCPARAM TYPE="in" CFSQLTYPE="cf_sql_varchar" DBVARNAME="@Contra" VALUE="Detail" NULL="no">
						
						<CFPROCRESULT NAME="CONTRACTDETAILQUERY">
					</CFSTOREDPROC>
					<CFSET SR = 1>
					
					<cfloop query="CONTRACTDETAILQUERY">
						<cfif BQTY GT 0>
							<CFSET DETAILQTY = BQTY>
							<CFSET DETAILRATE = BRATE>
						<cfelse>
							<CFSET DETAILQTY = SQTY>
							<CFSET DETAILRATE = SRATE>	
						</cfif>
							<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|13|#SR#|#Contract_Note_Text#|#ORDER_NO_FULL#|#REPLACE(TRIM(TRADE_NUMBER),'M','')#|#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#|#DETAILQTY#|#DETAILRATE#" ADDNEWLINE="YES">
						<CFSET SR = SR + 1>
					</cfloop>
				</cfif>
				
		</CFLOOP>
	</CFLOOP>	
	
			<!--- Trailer Record --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|19" ADDNEWLINE="YES">
				<CFSET CONTRACT_DATA = "#CONTRACT_DATA##BatchNumber#|19#CHR(10)#">
				
			<!--- File End Indicator Record --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="{}" ADDNEWLINE="NO">
				<CFSET CONTRACT_DATA = "#CONTRACT_DATA#{}">

	<SCRIPT LANGUAGE="VBScript">
		On Error Resume Next	
		newfolderpath = "c:\STPFILES" 
		Set FileSys = CreateObject("Scripting.FileSystemObject")
		If Not filesys.FolderExists(newfolderpath) Then 
			 Set newfolder = filesys.CreateFolder(newfolderpath) 
		End If
	</script>
	<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">
	<CFSET	ClientFileGenerated	=	CopyFile("#File_Name#","#File_Name#")>
	<SCRIPT>
		alert("File Has Been Generated On #Replace(File_Name,'\','\\','all')#.");
	</SCRIPT>

	</CFOUTPUT>
