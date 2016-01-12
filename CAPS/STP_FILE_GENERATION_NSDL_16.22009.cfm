<CFINCLUDE TEMPLATE="../../Common/Export_Text_File.cfm">
<CFSET finstyr = "#FinStart#">
<CFSET finendyr = "#FinEnd#">
<CFOUTPUT>	
<CFSET Settlement_No ="#txtSetlId#">
<CFSET Scrip_Symbol ="#txtScrip#">
<CFSET Trade_Date = "#txtOrderDate#">
<!--- 
<CFSET CNNO ="#txtContractNo#">
<CFSET Contract_No ="#txtContractNo#">
<CFSET Client_ID ="#txtClientID#">

<CFSET Trade_Date = "#txtOrderDate#"> --->

	<CFQUERY NAME="GetClient" datasource="#Client.database#">
		SELECT
				Distinct A.CLIENT_ID, A.CONTRACT_NO CONTRACT_NO,
				 CONVERT(CHAR(10), TRADE_DATE,112) Trade_Date_YearFormat
				 , TRADE_DATE TRADE_DATE1
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
		<CFIF Trim(txtContractNo)	NEQ	"">
			And Contract_No	=	'#txtContractNo#'
		</CFIF>
		And a.CLIENT_ID		=	'#txtClientID#'
	</CFQUERY>

	<CFQUERY NAME="GetSetlDate" datasource="#Client.database#">
		SELECT	CONVERT(CHAR(10), FUNDS_PAYIN_DATE,112) FUNDS_PAYIN_DATE
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
		And		A.Client_ID		=	'#txtClientID#'
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
	<Cfset File_Name = ''>
	<CFIF NOT DIRECTORYEXISTS("C:\STPFILES\")>
		<CFDIRECTORY action="create" directory="C:\STPFILES\">
	</CFIF>
	<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#txtScrip#">	
	<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#txtContractNo#">	
	<CFSET	OnlyFileName	=	"#MKT_TYPE#_#SETTLEMENT_NO#_#txtClientID#_#SCRIP_SYMBOL_ORDER_NO#.txt">
	<CFSET	File_Name	=	"C:\STPFILES\#OnlyFileName#">
	<CFFILE ACTION="Write" FILE="#File_Name#" OUTPUT="{}"ADDNEWLINE="Yes">
	<cfset Total_Number_Of_CNs = GetClient.recordcount>
	<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#fileConvertString(BatchNumber, 7, 'R', '0')#11#fileConvertString('', 6, 'L', ' ')##fileConvertString(Broker_Sebi_RegnNo, 12, 'L', ' ')##fileConvertString('', 2, 'R', ' ')##fileConvertString(Total_Number_Of_CNs, 5, 'R', '0')##fileConvertString(DateFormat(NOW(),'YYYYMMDD'), 8, 'R', '0')##fileConvertString(DateFormat(NOW(),'HHMM'), 4, 'R', '0')##fileConvertString('', 2, 'L', ' ')#" ADDNEWLINE="Yes">
	<CFLOOP QUERY="GetClient">
		<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#SCRIP_SYMBOL#">	
		<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#txtContractNo#">	
		<CFSET	OnlyFileName	=	"#MKT_TYPE#_#SETTLEMENT_NO#_#CLIENT_ID#_#SCRIP_SYMBOL_ORDER_NO#.txt">
		<CFSET	TradeDate1	=	"#GetClient.Trade_Date_YearFormat#">
		<CFSET	PayINDate	=	"#GetSetlDate.Funds_Payin_Date#">
		<CFSET CNNO =CONTRACT_NO>
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
		<cfset RecordType = "2">
  		
		
		<!---****************************** Dumy Data *************************--->
		<!--- ***************** --->
		
		<!--- {#Broker_Sebi_RegnNo#}{#Client_Sebi_RegnNo1#} --->
		
		<cfset SetlDate=PayINDate>
		<cfset LineNumber = 0>
		<CFLOOP QUERY="ContData">
			<Cfset INST_GROSS = 0>
			<Cfset INST_NET = 0>
			<cfset LineNumber = LineNumber+1>
			<CFSET	CHANGED_TRADE_NO	=	"#RepeatString("0", (16 - Len(TRADE_NUMBER)))##TRADE_NUMBER#">
			<CFSET	CHANGED_ORDER_NO	=	"#RepeatString("0", (16 - Len(ORDER_NO)))##ORDER_NO#">
			
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
				<CFSET	BOISL_NO					=	100002519>	
			<CFELSE>
				<CFSET TYPEFOREXCHANGE = "23">			
				<CFSET	BOISL_NO					=	100013573>	
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
					<cfset BRKDECIMAL  = 4>
			<cfelse>		
					<cfset	DecimalVal	=	99>
					<cfset BRKDECIMAL  = 2>
			</cfif>
			<cfinclude template="STP_Buy_Sale_Logic.cfm">
			
				<CFSET	CONTRACT_DATA	=	"#CONTRACT_DATA#:16R:GENL#CHR(10)#">
				<Cfset cust_code = ''>				
				
				
				<!---****************************** Dumy Data *************************--->
				
				<cfset CNDate = "#trim(TradeDate1)##TimeFormat(trade_dateTIME,'HHMMSS')#">
				<cfset Client_Exchange_Code = "#Client_Sebi_RegnNo1#">
				<cfset Custodian_Code = GetToken(UNIQUECLCODE,1,',')>
				<cfset Trade_Date7 = TradeDate1> 

				<CFIF "BSE" EQ "BSE">
<!--- 				<CFIF Exchange EQ "BSE">
 --->					<!--- <CFIF	MKT_TYPE IS "N" OR MKT_TYPE IS "T">
						<CFSET	MKT_TYPE_CODE	=	05>
					</CFIF>
					<CFIF	MKT_TYPE IS "A">
						<CFSET	MKT_TYPE_CODE	=	04>
					</CFIF> --->
					<CFIF	Mkt_Type	EQ	"N">
						<CFSET	MKT_TYPE_CODE	=	"DR">
					<CFELSEIF	Mkt_Type	EQ	"T">
						<CFSET	MKT_TYPE_CODE	=	"TT">
					<CFELSEIF	Mkt_Type	EQ	"A">
						<CFSET	MKT_TYPE_CODE	=	"AR">
					</CFIF>
					<CFSET 	Setl_No = #getBseSettlementNo(Settlement_No, FinStart)#>
				<CFELSE>
					<CFIF	MKT_TYPE IS "N">
						<CFSET	MKT_TYPE_CODE	=	13>
					<CFELSEIF MKT_TYPE IS "T">
						<CFSET	MKT_TYPE_CODE	=	22>
					<CFELSEIF	MKT_TYPE IS "A">
						<CFSET	MKT_TYPE_CODE	=	14>
					</CFIF>
					<CFSET 	Setl_No = #Settlement_No#>
				</CFIF>
				<cfset Market_Type = MKT_TYPE_CODE>
				<cfset Trade_Flag = LEFT(BUY_SALE,1)>
				<cfset Settlement_Type = "CH">
				<cfset Settlement_Date =  SetlDate>
				<cfset Avg_Rate = Replace(Numberformat(RATE,0000000000.00000),'.','')>
				<cfset Total_Qty =  Replace(Numberformat(QTY,000000000000.000),'.','')>
				<cfset Brokerage = Replace(Numberformat(TOTBrk,0000000000.00000),'.','')>
				<cfset Service_Tax = 0>
				<cfset Net_Value = Replace(Numberformat(AMT,0000000000.00000),'.','')>
				<cfset No_Of_Trade = 1>
				<CFSET	Client_Sebi_RegnNo1			=	GetClientDetail.Client_SebiRegnNo>
				<cfset Cust_Sebi_Reg_No = GetClientDetail.Client_InstNo>

				<cfset Brokerage_Rate = Replace(Numberformat(BRK,0000000000.00000),'.','')>
				<cfset Broker_Contact_Detail = "">
				<cfset Order_Date = "">
				<cfset Order_Time ="">
				<cfset MAPIN_Id_Exchange = #BOISL_NO#> 
				<cfset STT = Replace(Numberformat(STT,0000000000.00000),'.','')> 
				<!--- ***************** --->
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
			<cfif OptContractInf EQ "SUMMARY">
				<cfset No_Of_Trade = 1>
			<cfelse>
				<cfset No_Of_Trade = CONTRACTDETAILQUERY.RECORDCOUNT>
			</cfif>
			
				
			    <!--- <CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#fileConvertString(BatchNumber, 7, 'R', '0')#15#fileConvertString(' ', 6, 'R', ' ')##fileConvertString(LineNumber, 5, 'R', '0')##fileConvertString(CNNO, 16, 'R', '0')##fileConvertString(CNDate, 14, 'R', '0')##fileConvertString(Broker_Sebi_RegnNo, 12, 'L', ' ')##fileConvertString(' ', 4, 'L', ' ')##fileConvertString(Client_Exchange_Code, 16, 'L', ' ')##fileConvertString(Custodian_Code, 8, 'L', ' ')##fileConvertString(' ', 2, 'L', ' ')##fileConvertString(ISIN, 12, 'L', ' ')##fileConvertString(Trade_Date7, 8, 'R', '0')#" ADDNEWLINE="Yes">  --->
				
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#fileConvertString(BatchNumber, 7, 'R', '0')#15#fileConvertString('', 6, 'L', ' ')##fileConvertString(LineNumber, 5, 'R', '0')##fileConvertString(CNNO, 16, 'L', ' ')##fileConvertString(CNDate, 14, 'R', '0')##fileConvertString(Broker_Sebi_RegnNo, 12, 'L', ' ')##fileConvertString('', 4, 'L', ' ')##fileConvertString(Custodian_Code, 16, 'L', ' ')##fileConvertString(Cust_Sebi_Reg_No, 8, 'L', ' ')##fileConvertString('', 2, 'L', ' ')##fileConvertString(UCase(ISIN), 12, 'L', ' ')##fileConvertString(Trade_Date7, 8, 'R', '0')##fileConvertString(Market_Type, 2, 'L', ' ')##fileConvertString(SetlNO, 7, 'L', ' ')##fileConvertString(Trade_Flag, 1, 'L', ' ')##fileConvertString(Settlement_Type, 2, 'L', ' ')##fileConvertString(Settlement_Date, 8, 'R', '0')##fileConvertString('', 2, 'L', ' ')##fileConvertString(Avg_Rate, 15, 'R', '0')##fileConvertString(Total_Qty, 15, 'R', '0')##fileConvertString(Brokerage, 15, 'R', '0')##
				fileConvertString(Service_Tax, 15, 'R', '0')##fileConvertString(Net_Value, 15, 'R', '0')##fileConvertString(No_Of_Trade, 5, 'R', '0')##fileConvertString(' ', 12, 'L', ' ')##fileConvertString(Brokerage_Rate, 15, 'R', '0')##fileConvertString(Broker_Contact_Detail, 140, 'L', ' ')##fileConvertString(Order_Date, 8, 'R', '0')##fileConvertString(Order_Time, 6, 'R', '0')##fileConvertString(MAPIN_Id_Exchange, 9, 'R', '0')##fileConvertString(STT, 15, 'R', '0')#" ADDNEWLINE="Yes">
			<cfif OptContractInf EQ "SUMMARY">
					<Cfset LineNumber = LineNumber +1>
<!--- 					<Cfset TRADE_NO  = TRADE_Number>
					<Cfset TRADE_TIME  = TimeFormat(TRADE_dateTIME,'hhmmss')>
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#fileConvertString(BatchNumber, 7, 'R', '0')#13#fileConvertString(LineNumber, 5, 'R', '0')##fileConvertString('', 2, 'L', ' ')##fileConvertString(Broker_Sebi_RegnNo, 12, 'L', ' ')##fileConvertString(CNNO, 16, 'L', ' ')##fileConvertString(ORDER_NO, 16, 'R', '0')##fileConvertString(Trade_No, 16, 'R', '0')##fileConvertString(Trade_Time, 6, 'R', '0')##fileConvertString(Total_Qty, 15, 'R', '0')##fileConvertString(AVG_RATE, 15, 'R', '0')#" ADDNEWLINE="Yes">
 ---> 			
 				<cfloop query="CONTRACTDETAILQUERY" startrow="1" endrow="1">
					<Cfset LineNumber = LineNumber +1>
					<cfif BQTY GT 0>
						<CFSET DETAILQTY = Replace(Numberformat(BQTY,000000000000.000),'.','')>
						<CFSET DETAILRATE = Replace(TRIM(NUMBERFORMAT(BRATE,'9999999999.9999')),".",".")>
						<cfset RATE7 =  Replace(Numberformat(brate,0000000000.00000),'.','')>
					<cfelse>
						<CFSET DETAILQTY = Replace(Numberformat(SQTY,000000000000.000),'.','')>
						<CFSET DETAILRATE = Replace(TRIM(NUMBERFORMAT(SRATE,'9999999999.9999')),".",".")>	
						<cfset RATE7 = Replace(Numberformat(srate,0000000000.00000),'.','')>
					</cfif>
					<Cfset TRADE_NO  = TRADE_Number>
					<Cfset TRADE_TIME  = TimeFormat(TRADE_dateTIME,'hhmmss')>
					<!--- ***************** --->
					
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#fileConvertString(BatchNumber, 7, 'R', '0')#13#fileConvertString(LineNumber, 5, 'R', '0')##fileConvertString('', 2, 'L', ' ')##fileConvertString(Broker_Sebi_RegnNo, 12, 'L', ' ')##fileConvertString(CNNO, 16, 'R', '0')##fileConvertString(ORDER_NO, 16, 'R', '0')##fileConvertString(Trade_No, 15, 'R', '0')##fileConvertString(Trade_Time, 6, 'R', '0')##fileConvertString(DETAILQTY, 15, 'R', '0')##fileConvertString(RATE7, 15, 'R', '0')#" ADDNEWLINE="Yes">
 				</cfloop>		
 
 			<cfelse>
				<cfloop query="CONTRACTDETAILQUERY">
					<Cfset LineNumber = LineNumber +1>
					<cfif BQTY GT 0>
						<CFSET DETAILQTY = Replace(Numberformat(BQTY,000000000000.000),'.','')>
						<CFSET DETAILRATE = Replace(TRIM(NUMBERFORMAT(BRATE,'9999999999.9999')),".",".")>
						<cfset RATE7 =  Replace(Numberformat(brate,0000000000.00000),'.','')>
					<cfelse>
						<CFSET DETAILQTY = Replace(Numberformat(SQTY,000000000000.000),'.','')>
						<CFSET DETAILRATE = Replace(TRIM(NUMBERFORMAT(SRATE,'9999999999.9999')),".",".")>	
						<cfset RATE7 = Replace(Numberformat(srate,0000000000.00000),'.','')>
					</cfif>
					<Cfset TRADE_NO  = TRADE_Number>
					<Cfset TRADE_TIME  = TimeFormat(TRADE_dateTIME,'hhmmss')>
					<!--- ***************** --->
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#fileConvertString(BatchNumber, 7, 'R', '0')#13#fileConvertString(LineNumber, 5, 'R', '0')##fileConvertString('', 2, 'L', ' ')##fileConvertString(Broker_Sebi_RegnNo, 12, 'L', ' ')##fileConvertString(CNNO, 16, 'R', '0')##fileConvertString(ORDER_NO, 16, 'R', '0')##fileConvertString(Trade_No, 15, 'R', '0')##fileConvertString(Trade_Time, 6, 'R', '0')##fileConvertString(DETAILQTY, 15, 'R', '0')##fileConvertString(RATE7, 15, 'R', '0')#" ADDNEWLINE="Yes">
 				</cfloop>		
			</cfif>	
		</CFLOOP>
	</CFLOOP>	
		<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#fileConvertString(BatchNumber, 7, 'R', '0')#19#fileConvertString('', 15, 'L', ' ')#" ADDNEWLINE="Yes">
		<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="{}" ADDNEWLINE="Yes">
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