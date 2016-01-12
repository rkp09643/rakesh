<CFINCLUDE TEMPLATE="../../Common/Export_Text_File.cfm">
	<CFSET finstyr = "#FinStart#">
	<CFSET finendyr = "#FinEnd#">
<CFOUTPUT>	

<CFSET Scrip_Symbol ="#txtScrip#">
<CFSET Contract_No ="#txtContractNo#">
<CFSET Client_ID ="#txtClientID#">
<CFSET Settlement_No ="#txtSetlId#">
<CFSET Trade_Date = "#txtOrderDate#">

	<CFIF	Trim(Scrip_Symbol) EQ	""
	AND		Trim(Contract_No) EQ	"">
	
			<FONT COLOR="RED">
				Please enter Order Number.<u><B>OR</B></u><BR>
				Please enter Scrip.
			</FONT>
			
			<CFABORT>
	</CFIF>
	
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
		<CFIF Trim(Scrip_Symbol)	NEQ	"">
		And	A.Scrip_Symbol	=	'#Scrip_Symbol#'
		</CFIF>
		<CFIF Trim(Contract_No)	NEQ	"">
		And Contract_No	=	'#Contract_No#'
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
		SELECT	Client_SebiRegnNo, Unique_Cl_ID
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
	<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#SCRIP_SYMBOL#">	
	<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#Contract_No#">	
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
	
	<CFIF	Mkt_Type	EQ	"N">
		<CFSET	Mkt_Type_Text	=	"DR">
	<CFELSEIF	Mkt_Type	EQ	"T">
		<CFSET	Mkt_Type_Text	=	"TT">
	<CFELSEIF	Mkt_Type	EQ	"A">
		<CFSET	Mkt_Type_Text	=	"AR">
	</CFIF>
	
	<CFFILE ACTION="WRITE" FILE="#File_Name#" OUTPUT="" ADDNEWLINE="NO">
	
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
		
		<CFFILE ACTION="WRITE" FILE="#File_Name#" OUTPUT="{}" ADDNEWLINE="YES">
		
		<CFLOOP QUERY="ContData">

			<CFSET	CHANGED_TRADE_NO	=	"#RepeatString("0", (15 - Len(TRADE_NUMBER)))##TRADE_NUMBER#">
			<CFSET	CHANGED_ORDER_NO	=	"#RepeatString("0", (15 - Len(ORDER_NO)))##ORDER_NO#">
			
			<CFQUERY NAME="GetSttApplied" datasource="#Client.database#">
				Select 
						Client_ID 
				From
						Client_Master
				Where
						Company_Code	=	'#COCD#'
				And		Client_ID		=	'#Client_ID#'
				And		IsNull(FLG_APPLIEDSTT,'N')	=	'N'
			</CFQUERY>
			
			<CFIF	GetSttApplied.RecordCount	GT	0>
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
			<cfelse>		
					<cfset	DecimalVal	=	99>
			</cfif>

			<CFIF	BQTY	GT	0>
					<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
					<CFSET	QTY		=	BQTY>
					<CFSET	BRATE1	=	BRATE>
					<CFSET	BBRK1	=	BBRK>
					<CFSET	BNetRATE1	=	BNetRATE>
					<CFSET ACTBUY_SALE = 'B'>
					
					<CFIF	DelAdjCode	EQ	13 And BRATE GT 0>
						<CFSET	BRATE1Decimal	=	Find(".",BRATE1)>
						<CFSET	BRATE1			= 	Trim(NumberFormat(Mid(Trim(BRATE1), 1, BRATE1Decimal+4),"9999999.9999"))>

						<CFSET	BBRK1Decimal	=	Find(".",BBRK1)>
						<CFSET	BBRK1			= 	Trim(NumberFormat(Mid(Trim(BBRK1), 1, BBRK1Decimal+4),"9999999.9999"))>

						<CFSET	BNetRATE1Decimal	=	Find(".",BNetRATE1)>
						<CFSET	BNetRATE1			= 	Trim(NumberFormat(Mid(Trim(BNetRATE1), 1, BNetRATE1Decimal+4),"9999999.9999"))>
					<CFELSE>
						<CFSET	BRATE1	=	NumberFormat(BRATE,"99999999." & DecimalVal)>
						<CFSET	BBRK1	=	NumberFormat(BBRK,"99999999." & DecimalVal)>
						<CFSET	BNetRATE1	=	NumberFormat(BNetRATE,"99999999." & DecimalVal)>
					</CFIF>
					
					<CFSET	RATE	=	Trim(NumberFormat(BRATE1,"99999999." & DecimalVal))>
					<CFSET	BRK		=	Trim(NumberFormat(BBRK1,"99999999.99"))>
					<CFSET	NetRATE	=	Trim(NumberFormat(BNetRATE1,"99999999." & DecimalVal))>
					
					<CFSET	TOTBrk	=	Trim(NumberFormat(BQTY * BBRK1,"99999999.99"))>
					<CFSET	AMT		=	Trim(NumberFormat(BQTY * BNetRATE1,"99999999.99"))>
					<CFSET	Actual_Amt	=	Trim(NumberFormat(BQTY * BRATE1,"99999999.99"))>

					<CFSET	BUY_SALE	=	"BUYI">
					<CFSET	BUY_SALE2	=	"SELL">
					<CFSET	BUY_SALE3	=	"DEAG">
					<CFSET	RatePlusBrk	=	"+">
					<CFIF	APPLY_STT>
						<CFSET	STT	=	((BQTY * BRATE1 * BSTT) / 100)>
					<CFELSE>
						<CFSET	STT	=	0>
					</CFIF>

					<CFSET	AMT1	=	Trim((AMT + NumberFormat(STT, "99999999")))>
					<CFSET	STT		=	Trim(NumberFormat(STT, "99999999"))>
					<CFSET  AMT		=	NumberFormat(AMT1,"99999999999.99")>
					
				<CFELSE>
					<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
					<CFSET	QTY		=	SQTY>
					<CFSET	SRATE1	=	SRATE>
					<CFSET	SBRK1	=	SBRK>
					<CFSET	SNetRATE1	=	SNetRATE>
					<CFSET ACTBUY_SALE = 'S'>
					
					<CFIF	DelAdjCode	EQ	13 And SRATE GT 0>
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
					</CFIF>
					
					<CFSET	RATE	=	Trim(NumberFormat(SRATE1,"99999999." & DecimalVal))>
					<CFSET	BRK		=	Trim(NumberFormat(SBRK1,"99999999." & DecimalVal))>
					<CFSET	TOTBrk	=	Trim(NumberFormat(SQTY * SBRK1,"99999999.99"))>
					<CFSET	NetRATE	=	Trim(NumberFormat(SNetRATE1,"99999999." & DecimalVal))>
					<CFSET	Actual_Amt	=	Trim(NumberFormat(SQTY * SRATE1,"99999999.99"))>
					<CFSET	AMT		=	Trim(NumberFormat(SQTY * SNetRATE1,"99999999.99"))>
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
				

			<!---Header Record --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|11|1#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|1|#DATEFORMAT(NOW(),'YYYYMMDD')#|#TIMEFORMAT(NOW(),'HHMMSS')#" ADDNEWLINE="YES">
				<CFSET CONTRACT_DATA = "#CONTRACT_DATA##BatchNumber#|11|1#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|1|#DATEFORMAT(NOW(),'YYYYMMDD')#|#TIMEFORMAT(NOW(),'HHMMSS')##CHR(10)#">
			
			<!---CN Detail Record --->
				<!--- ORDER CONFIRMATION TIME : #DATEFORMAT(NOW(),'YYYYMMDD')##TIMEFORMAT(NOW(),'HHMMSS')#	 --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|15|2|515|1|1#LEFT(TRIM(Client_Sebi_RegnNo1),12)#|#Contract_Note_Text#|#TradeDate1#|1||#TradeDate1#||#TradeDate1#|#RATE#|#Brk#|#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#TYPEFOREXCHANGE#|#ACTBUY_SALE#|1|#LEFT(TRIM(Client_Sebi_RegnNo1),12)#|#LEFT(TRIM(Unique_Cl_ID1),10)#|#QTY#|#TRIM(ISIN)#~#TRIM(SCRIP_SYMBOL)#||#Mkt_Type_Text#|#SetlNo#|1#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#LEFT(TRIM(UCASE(COMPANY_ADDRESS1)),140)#|1#BOISL_NO#|#ACTUAL_AMT#|#TotBrk#|0|#STT#|#TRIM(AMT)#|" ADDNEWLINE="YES">
				<CFSET CONTRACT_DATA = "#CONTRACT_DATA##BatchNumber#|15|2|515|1|1#LEFT(TRIM(Client_Sebi_RegnNo1),12)#|#Contract_Note_Text#|#TradeDate1#|1||#TradeDate1#||#TradeDate1#|#RATE#|#Brk#|#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#TYPEFOREXCHANGE#|#ACTBUY_SALE#|1|#LEFT(TRIM(Client_Sebi_RegnNo1),12)#|#LEFT(TRIM(Unique_Cl_ID1),10)#|#QTY#|#TRIM(ISIN)#||#Mkt_Type_Text#|#SetlNo#|1#LEFT(TRIM(Broker_Sebi_RegnNo),12)#|#LEFT(TRIM(UCASE(COMPANY_ADDRESS1)),140)#|1#BOISL_NO#|#ACTUAL_AMT#|#TotBrk#|0|#STT#|#TRIM(AMT)#|#CHR(10)#">
			
			<!---Detail Record  (Trade) --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|13|3|#Contract_Note_Text#|#CHANGED_ORDER_NO#|#REPLACE(TRIM(CHANGED_TRADE_NO),'M','')#|#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#|#QTY#|#RATE#" ADDNEWLINE="YES">
				<CFSET CONTRACT_DATA = "#CONTRACT_DATA##BatchNumber#|13|3|#Contract_Note_Text#|#CHANGED_ORDER_NO#|#REPLACE(TRIM(CHANGED_TRADE_NO),'M','')#|#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#|#QTY#|#RATE##CHR(10)#">	
			
			<!--- Trailer Record --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#BatchNumber#|19" ADDNEWLINE="YES">
				<CFSET CONTRACT_DATA = "#CONTRACT_DATA##BatchNumber#|19#CHR(10)#">
				
			<!--- File End Indicator Record --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="{}" ADDNEWLINE="NO">
				<CFSET CONTRACT_DATA = "#CONTRACT_DATA#{}">
				
				<!--- <CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":98A::TRAD//#TradeDate1#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":98A::SETT//#PAYINDATE#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":90B::DEAL//ACTU/INR#RATE#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":92A::CORA//#RatePlusBrk##Brk#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":94B::TRAD//EXCH/#Exchange_Mapin#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::INVE//#Unique_Cl_ID1#" ADDNEWLINE="Yes">	
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":97A::SAFE//#Client_Sebi_RegnNo1#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":36B::CONF//UNIT/#QTY#," ADDNEWLINE="Yes">			
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":35B:ISIN #ISIN#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#SCRIP_NAME#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70E::TPRO//#Mkt_Type_Text#/#SetlNo#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::#BUY_SALE2#//#Broker_Sebi_RegnNo#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70C::PACO//#Exchange_Clearing_Code#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::#BUY_SALE3#//#BOISL_NO#" ADDNEWLINE="Yes">	<!--- BOISL_NO --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::DEAL//INR#ACTUAL_AMT#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::EXEC//INR#TotBrk#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::TRAX//0,0000" ADDNEWLINE="Yes">					
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::COUN//INR#STT#," ADDNEWLINE="Yes">					
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::SETT//INR#TRIM(AMT)#" ADDNEWLINE="Yes">										
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:AMT" ADDNEWLINE="Yes">										
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:SETDET" ADDNEWLINE="Yes">												
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70D::PART//#REPLACE(CHANGED_TRADE_NO,'M','')#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#QTY#," ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#RATE#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":20C::PROC//#CHANGED_ORDER_NO#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:OTHRPRTY" ADDNEWLINE="Yes"> --->
		</CFLOOP>
	</CFLOOP>	
	
	
	
	<SCRIPT>
		alert("File Has Been Generated On #Replace(File_Name,'\','\\','all')#.");
	</SCRIPT>

	</CFOUTPUT>
