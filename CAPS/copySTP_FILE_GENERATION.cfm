
<CFINCLUDE TEMPLATE="../../Common/Export_Text_File.cfm">
	<CFSET finstyr = "#FinStart#">
	<CFSET finendyr = "#FinEnd#">
<CFOUTPUT>	
<CFSET Client_ID ="#txtClientID#">
<CFSET Settlement_No ="#txtSetlId#">
<CFSET Trade_Date = "#txtOrderDate#">


	
	<CFQUERY NAME="GetClient" datasource="#Client.database#">
		SELECT	
				Distinct A.CLIENT_ID,
				 A.CONTRACT_NO, CONVERT(CHAR(10), TRADE_DATE,112)Trade_Date_YearFormat
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
		SELECT	Sebi_Reg_No, Company_Name, Exchange_Mapin
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
	<cfset Cust_Sebi_Reg_No111 = GetClientDetail.Client_InstNo>
	
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
	<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#txtScrip#">	
	<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#txtContractNo#">	
	<CFSET	OnlyFileName	=	"#MKT_TYPE#_#SETTLEMENT_NO#_#CLIENT_ID#_#SCRIP_SYMBOL_ORDER_NO#.iso">
	<CFSET	File_Name	=	"C:\STPFILES\#OnlyFileName#">
	<CFFILE ACTION="write" FILE="#File_Name#" OUTPUT=""ADDNEWLINE="no">
	<CFLOOP QUERY="GetClient">
			<CFSET	TradeDate1	=	"#GetClient.Trade_Date_YearFormat#">
			<CFSET	PayINDate	=	"#GetSetlDate.Funds_Payin_Date#">
			<!----<cfset	BatchNo		=	"#GetClient.Trade_Date_YearFormat##RepeatString("0", (3 - Len(GenerationNo)))##GenerationNo#">----->
			<CFSET	Broker_Sebi_RegnNo			=	GetCompanyDetail.Sebi_Reg_No>
			<CFSET	Exchange_Mapin				=	GetCompanyDetail.Exchange_Mapin>
			<CFSET	Exchange_Clearing_Code		=	GetSystemDetail.Exchange_Clearing_Code>
			<CFSET	ClientList_STTNotApplied	=	GetSystemDetail.ClientList_STTNotApplied>
			<CFSET	Client_Sebi_RegnNo1			=	GetClientDetail.Client_SebiRegnNo>
			<CFSET	Unique_Cl_ID1				=	GetClientDetail.Unique_Cl_ID>
			
			
			<CFIF	Mkt_Type	EQ	"N">
				<CFSET	Mkt_Type_Text	=	"DR">
			<CFELSEIF	Mkt_Type	EQ	"T">
				<CFSET	Mkt_Type_Text	=	"TT">
			<CFELSEIF	Mkt_Type	EQ	"A">
				<CFSET	Mkt_Type_Text	=	"AR">
			</CFIF>
			
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
		

		<CFSET CONTRACT_DATA = "">
		
		<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="{IFN515}{#Broker_Sebi_RegnNo#}{#Client_Sebi_RegnNo1#}"ADDNEWLINE="Yes">   <!--- {#Unique_Cl_ID1#} Changed for Eureka--->
		<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="{" ADDNEWLINE="Yes">
		<CFLOOP QUERY="ContData">
		
			<Cfset INST_GROSS = 0>
			<Cfset INST_NET = 0>
			<CFSET	CHANGED_TRADE_NO	=	"">
			<CFSET	CHANGED_ORDER_NO	=	"">
			<cftry>
				<CFSET	CHANGED_TRADE_NO	=	"#RepeatString("0", (16 - Len(TRADE_NUMBER)))##TRADE_NUMBER#">
				<CFSET	CHANGED_ORDER_NO	=	"#RepeatString("0", (16 - Len(ORDER_NO)))##ORDER_NO#">
				<cfcatch>
				</cfcatch>
			</cftry>	
			
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
			OR		GetClientBrkDetail.Adjustment_Code	EQ	13 
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	21 
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	23
			OR		GetClientBrkDetail.Adjustment_Code	EQ	14
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	4
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	13
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	14>	
					<cfset	DecimalVal	=	9999>
					<cfset BRKDECIMAL  = 4>
			<cfelse>		
					<cfset	DecimalVal	=	99>
					<cfset BRKDECIMAL  = 2>
			</cfif>
			
			<cfinclude template="STP_Buy_Sale_Logic.cfm">
		<!--- <CFIF	BQTY	GT	0>
				<CFSET Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
				<CFSET QTY		=	BQTY>
				<CFSET BRATE1	=	BRATE>
				<CFSET BBRK1	=	TRIM(NUMBERFORMAT(BBRK,'9999999999999.999999'))>
				<CFSET BNetRATE1	=	BNetRATE>
				<CFSET ACTBUY_SALE = 'B'>
				<CFSET BRATEDecimal	=	Find(".",BRATE)>				
				<CFSET BRATE1	= 	Trim(NumberFormat(BRATE,'9999999.'&RepeatString(9,INST_GROSS))) >				
				<CFSET BACTAMT = TRIM(NUMBERFORMAT(BQTY * BRATE1,'999999999999999.999999'))>
				<CFSET BACTAMTDecimal	=	Find(".",BACTAMT)>
				<CFSET BACTAMT1 = Trim(NumberFormat(Mid(Trim(BACTAMT), 1, BACTAMTDecimal+2),'99999999999999.'&RepeatString(9,2)))>

				<CFSET	BBRK1Decimal	=	Find(".",TRIM(BBRK1))>
				<CFSET	BBRK2			= 	TRIM(Numberformat(Mid(Trim(BBRK1), 1, BBRK1Decimal+BRKDECIMAL),'999999999.'&RepeatString(9,BRKDECIMAL)))>					
				
				<CFSET	BNETRATEDecimal	=	Find(".",BNETRATE)>
				<CFSET	BNETRATE1	= 	Trim(NumberFormat(BNETRATE,'9999999.'&RepeatString(9,INST_NET))) >								

				
				<CFSET	RATE	=	Replace(BRATE1,".",",")>
				<CFSET	BRK		=	Replace(BBRK2,".",",")>
				<CFSET	NetRATE	=	Replace(BNetRATE1,".",",")>
				
				
				<CFSET	TOTBBRK		=	NUMBERFORMAT(BQTY	*	BBRK2,"999999999.999999")>
				<CFSET	BBRKDecimal	=	Find(".",TOTBBRK)>
				<cfif BBRKDecimal	neq 0>
					<CFSET	TOTBBRK1	= 	Trim(NumberFormat(Mid(Trim(TOTBBRK), 1, BBRKDecimal+2),'9999999.99')) >
				<cfelse>
					<CFSET	TOTBBRK1	= 	Trim(NumberFormat(val(Trim(TOTBBRK)),'9999999.99')) >
				</cfif>
	
				<CFSET	TOTBrk	=	Replace(TOTBBRK1,".",",")>
				<CFSET	AMT =		BACTAMT1+TOTBBRK1>
				<!--- <CFSET	AMT		=	Trim(NumberFormat(BQTY * BNetRATE1,"99999999.99"))> --->
				<CFSET	Actual_Amt	=	BACTAMT1>

				<CFSET	BUY_SALE_M	=	"BUYI">
				<CFSET	BUY_SALE2	=	"SELL">
				<CFSET	BUY_SALE3	=	"DEAG">
				<CFSET	RatePlusBrk	=	"+">
				
				<CFIF	APPLY_STT>
					<CFSET	STT	=	((BQTY * BRATE1 * BSTT) / 100)>
				<CFELSE>
					<CFSET	STT	=	0>
				</CFIF>

				<CFSET	AMT1	=	Trim((AMT + NumberFormat(STT, "9999999999")))>
				<CFSET	STT		=	Replace(Trim(NumberFormat(STT, "999999999")),".",",")>
				<CFSET  AMT		=	Replace(NumberFormat(AMT1,"99999999999.99"),".",",")>
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
				<CFSET	SNETRATE1	= 	Trim(NumberFormat(Trim(SNETRATE),'9999999.'&RepeatString(9,INST_NET))) >									
				
				<CFSET	TOTSBRK				=	NUMBERFORMAT(SQTY	*	SBRK2,"999999999.999999")>

				<CFSET	SBRKDecimal	=	Find(".",TOTSBRK)>
				<cfif SBRKDecimal	neq 0>
					<CFSET	TOTSBRK1	= 	Trim(NumberFormat(Mid(Trim(TOTSBRK), 1, SBRKDecimal	+2),'9999999.99')) >				
				<cfelse>
					<CFSET	TOTSBRK1	= 	Trim(NumberFormat(val(Trim(TOTSBRK)),'9999999.99')) >
				</cfif>
				<CFSET	RATE	=	Replace(SRATE1,".",",")>
				<CFSET	BRK		=	Replace(SBRK2,".",",")>
				<CFSET	TOTBrk	=	Replace(TOTSBRK1,".",",")>
				<CFSET	NetRATE	=	Replace(SNETRATE1,".",",")>
				<CFSET	Actual_Amt	=	Replace(SACTAMT1,".",",")>
				<CFSET	AMT =		SACTAMT1-TOTSBRK1>
				<CFSET	BUY_SALE_M	=	"SELL">
				<CFSET	BUY_SALE2	=	"BUYR">
				<CFSET	BUY_SALE3	=	"REAG">
				<CFSET	RatePlusBrk	=	"+">
				<CFIF	APPLY_STT>
					<CFSET	STT	=	((SQTY * SRATE1 * SSTT) / 100)>
				<CFELSE>
					<CFSET	STT	=	0>
				</CFIF>
				<CFSET	AMT1	=	Trim((AMT - NumberFormat(STT, "99999999")))>
				<CFSET	STT		=	Replace(Trim(NumberFormat(STT, "99999999")),".",",")>
				<CFSET  AMT     =   Replace(NumberFormat(AMT1,"99999999999.99"),".",",")>  
			</CFIF> --->
	    	<!---<CFSET	RATE	=	Replace(RATE,".",",")>
				<CFSET	BRK		=	Replace(BRK,".",",")>
				<CFSET	TOTBrk	=	Replace(TOTBrk,".",",")>
				<CFSET	NetRATE	=	Replace(NetRATE,".",",")>
				<CFSET	Actual_Amt	=	Replace(Actual_Amt,".",",")> --->
				
				
				<CFSET	CONTRACT_DATA	=	"#CONTRACT_DATA#:16R:GENL#CHR(10)#">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:GENL" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":20C::SEME//#Contract_Note_Text#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":23G:NEWM" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":98A::PREP//#TradeDate1#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":22F::TRTR//TRAD" ADDNEWLINE="Yes">
				<!--- Start Block A1 --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:LINK" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":20C::PREV//DUMMY" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:LINK" ADDNEWLINE="Yes">
				<!--- End Block A1 --->
					
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:GENL" ADDNEWLINE="Yes">
			<!--- End Block A --->
			
			<!--- Start Mandatory Block C (Confirmation details) --->
				
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:CONFDET" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":98A::TRAD//#TradeDate1#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":98A::SETT//#PAYINDATE#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":90B::DEAL//ACTU/INR#RATE#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":92A::CORA//#Brk#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":94B::TRAD//EXCH/#Exchange_Mapin#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":22H::BUSE//#BUY_SALE_M#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":22H::PAYM//FREE" ADDNEWLINE="Yes">

				<!--- Start Mandatory Sub Block C1 (Confirmation Parties)	 --->
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:CONFPRTY" ADDNEWLINE="Yes">	
					<!--- <CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::INVE//#Client_Sebi_RegnNo1#" ADDNEWLINE="Yes">	 --->
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::INVE//#Cust_Sebi_Reg_No111#" ADDNEWLINE="Yes">	
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":97A::SAFE//#GetToken(UNIQUECLCODE,1,',')#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:CONFPRTY" ADDNEWLINE="Yes">			
				<!--- End Mandatory Sub Block C1 (Confirmation Parties) --->		
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":36B::CONF//UNIT/#QTY#," ADDNEWLINE="Yes">			
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":35B:ISIN #ISIN#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#SCRIP_NAME#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70E::TPRO//#Mkt_Type_Text#/#SetlNo#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":98C::PROC//#TRIM(TRADEDATE1)##REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#" ADDNEWLINE="Yes">					
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:CONFDET" ADDNEWLINE="Yes">
			<!--- End Mandatory Block C (Confirmation details) --->					

			<!--- Start Mandatory Sequence D (Settlement Details) --->
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:SETDET" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":22F::SETR//TRAD" ADDNEWLINE="Yes">
		
				<!--- Start Mandatory Subsequence D1 (Settlement Parties) --->
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:SETPRTY" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::#BUY_SALE2#//#Broker_Sebi_RegnNo#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70C::PACO//#Exchange_Clearing_Code#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:SETPRTY" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:SETPRTY" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::#BUY_SALE3#//#BOISL_NO#" ADDNEWLINE="Yes">	<!--- BOISL_NO --->
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:SETPRTY" ADDNEWLINE="Yes">
				<!--- End Mandatory Subsequence D1 (Settlement Parties) --->
				
				<!--- Start Mandatory Subsequence D3 (Amounts) --->
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:AMT" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::DEAL//INR#ACTUAL_AMT#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:AMT" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:AMT" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::EXEC//INR#TotBrk#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:AMT" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:AMT" ADDNEWLINE="Yes">					
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::TRAX//INR0,0000" ADDNEWLINE="Yes">					
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:AMT" ADDNEWLINE="Yes">					
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:AMT" ADDNEWLINE="Yes">					
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::COUN//INR#STT#," ADDNEWLINE="Yes">					
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:AMT" ADDNEWLINE="Yes">										
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:AMT" ADDNEWLINE="Yes">
					
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::SETT//INR#TRIM(AMT)#" ADDNEWLINE="Yes">										
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:AMT" ADDNEWLINE="Yes">										
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:SETDET" ADDNEWLINE="Yes">										
		
				<!--- End Mandatory Subsequence D3 (Amounts)	 --->		

			<!--- End Sequence D Settlement Details --->			
			
			<!--- Start Optional Sequence E (Other Parties) --->
			<cfif OptContractInf EQ "SUMMARY">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:OTHRPRTY" ADDNEWLINE="Yes">										
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::EXCH//ORDER DETAILS" ADDNEWLINE="Yes">										
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70D::PART//#REPLACE(CHANGED_TRADE_NO,'M','')#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#QTY#," ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#RATE#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":20C::PROC//#CHANGED_ORDER_NO#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:OTHRPRTY" ADDNEWLINE="Yes">
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
				<cfloop query="CONTRACTDETAILQUERY">
					<cfif BQTY GT 0>
						<CFSET DETAILQTY = BQTY>
						<CFSET DETAILRATE = Replace(TRIM(NUMBERFORMAT(BRATE,'9999999999.9999')),".",",")>
					<cfelse>
						<CFSET DETAILQTY = SQTY>
						<CFSET DETAILRATE = Replace(TRIM(NUMBERFORMAT(SRATE,'9999999999.9999')),".",",")>	
					</cfif>
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:OTHRPRTY" ADDNEWLINE="Yes">										
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::EXCH//ORDER DETAILS" ADDNEWLINE="Yes">										
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70D::PART//#REPLACE(TRADE_Number,'M','')#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#DETAILQTY#," ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#DETAILRATE#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":20C::PROC//#ORDER_NO_FULL#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:OTHRPRTY" ADDNEWLINE="Yes">	
				</cfloop>		
			</cfif>	
 				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="-}" ADDNEWLINE="No">
			<!--- End Optional Sequence E (Other Parties)	 --->		
		</CFLOOP>
	</CFLOOP>	
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


