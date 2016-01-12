<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>WebX File Generation</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
</HEAD>

<cfif IsDefined("CmdGenerate")>
	<CFIF	Exchange	EQ	"BSE">
		<CFSET	NumRefCode	=	01>
		<CFSET	ExchangeBICCode	=	"XBOM">
	<CFELSE>
		<CFSET	NumRefCode	=	02>
		<CFSET	ExchangeBICCode	=	"XNSE">
	</CFIF>
	
	<CFIF	Mkt_Type	is	"N">
		<CFSET	Setl_Type	=	"DR">
	<CFELSEIF	Mkt_Type	is	"T">
		<CFSET	Setl_Type	=	"TT">
	<CFELSEIF	Mkt_Type	is	"A">
		<CFSET	Setl_Type	=	"AR">
	</CFIF>
	

	<CFIF MKT_TYPE EQ "A" AND GenerationNo  NEQ "003">
		<SCRIPT>
			alert("For Auction Batch Id Should Be 003...");
		</SCRIPT>
	<CFELSEIF MKT_TYPE EQ "N" AND GenerationNo NEQ "001">
		<SCRIPT>
			alert("For Normal Batch Id Should Be 001...");
		</SCRIPT>		
	<CFELSEIF MKT_TYPE EQ "T" AND GenerationNo NEQ "002">
		<SCRIPT>
			alert("For Trade To Trade Batch Id Should Be 002...");
		</SCRIPT>	
	</CFIF>
	<CFQUERY NAME="GetSysSetting" datasource="#Client.database#">
		SELECT	
				IsNull(Custodian_List, 'INST')Custodian_List, BSEWebXBrokerID, BackOfficeBatchID
		FROM
				System_Settings
		WHERE
				Company_Code	=	'#COCD#'
	</CFQUERY>
	
	<cfset	inst_list	=	GetSysSetting.Custodian_List>
	
	<!--- <CFQUERY NAME="GetBatchNo" datasource="#Client.database#">
		SELECT	IsNull(Voucher_No, 0) + 1
		From
				Settlement_Master
		Where
						
	</CFQUERY> --->
	
	<CFQUERY NAME="GetSTChrgs" datasource="#Client.database#">
		SELECT 	ISNULL(MAX( SC ), 0) SC
		FROM 	SERVICE_CHARGE
		WHERE	COMPANY_CODE 	=  '#COCD#'
		 AND	CONVERT( DATETIME, FROM_DATE, 103) <=  CONVERT( DATETIME, '#TRADE_DATE#', 103)
		 AND	CONVERT( DATETIME, ISNULL( TO_DATE, CONVERT( DATETIME, '#TRADE_DATE#', 103) ), 103) >=  CONVERT( DATETIME, '#TRADE_DATE#', 103)
	</CFQUERY>
	
	<CFSET I = 1>
		<CFQUERY NAME="GetTradeData" datasource="#Client.database#">
			SELECT	
					A.COMPANY_CODE, REPLACE(REPLACE(TRADE_NUMBER, 'SP',''), 'B', '')TRADE_NUMBER, A.CLIENT_ID, A.SCRIP_SYMBOL, A.SCRIP_NAME, TRADE_DATE, 
					convert(varchar(10), TRANSACTION_DATE, 112) TRADEDATE,
					convert(varchar(10), TRADE_DATETIME, 112) +''+ Replace(convert(varchar(10), TRADE_DATETIME, 108), ':', '')TRD_DTTIME, BUY_SALE, MKT_TYPE, SETTLEMENT_NO, QUANTITY, 
					RATE as Price_Premium, A.STRIKE_PRICE, ORDER_NUMBER, ORDER_DATETIME, 
					USER_ID, TRADE_BROKERAGE, DELIVERY_BROKERAGE, 
					BILL_NO, BILL_SETTLEMENT_NO, BILL_DATE, CONTRACT_NO, BROKERAGE_TYPE, 
					TRADE_TYPE, CUSTODIAN_CODE, Contract_No,
					B.Client_WebXID, ISNULL(A.ISIN,'')ISIN, RATEPLMSBRK, BUY_AMOUNT, SALE_AMOUNT,
					(QUANTITY * (TRADE_BROKERAGE + DELIVERY_BROKERAGE))TotBrokerage,
					IsNull(C.MARKET_LOT, 1)Market_Lot
			FROM
					CAPSFO_TRANSACTIONS A, Client_Master B, SCRIP_MASTER_TABLE C
			WHERE
					A.COMPANY_CODE	=	'#COCD#'
			AND		A.COMPANY_CODE	=	B.COMPANY_CODE
			AND		A.CLIENT_ID		=	B.CLIENT_ID
			AND		MKT_TYPE		=	'#MKT_TYPE#'
			AND		BILL_SETTLEMENT_NO	=	'#SETTLEMENT_NO#'
			AND		b.CLIENT_NATURE	=	'C'
			AND		LEN(RTRIM(IsNull(b.Client_WebXID,''))) >	0
			AND		ORDER_NUMBER NOT LIKE 'ND%'
			AND		C.EXCHANGE		=	'#EXCHANGE#'
			AND		C.MARKET		=	'#MARKET#'
			AND		A.SCRIP_SYMBOL	=	C.SCRIP_SYMBOL
			ORDER BY
					A.CLIENT_ID, A.Scrip_Symbol, Buy_Sale
		</CFQUERY>

		<CFQUERY NAME="GetValidateISIN" DBTYPE="QUERY">
			SELECT	DISTINCT Scrip_Symbol, Scrip_Name
			FROM
					GetTradeData
			WHERE
					ISIN	=	''
			AND		Market_Lot	<=	1		
		</CFQUERY>
		
		<CFIF	GetValidateISIN.RecordCount GT 0>
			<BR>
			<CFDUMP VAR="#GetValidateISIN#" LABEL="List of Missing Isin in '#MKT_TYPE#-#SETTLEMENT_NO#'">
			<CFABORT>
		</CFIF>
		
		<CFQUERY NAME="SettlementDetail" datasource="#Client.database#">
			SELECT
					Convert(VarChar(10), FROM_DATE, 103)FROM_DATE,
					Convert(VarChar(10), TO_DATE, 103)TO_DATE
			FROM
					SETTLEMENT_MASTER
			WHERE
					COMPANY_CODE	=	'#COCD#'
			AND		MKT_TYPE		=	'#MKT_TYPE#'
			AND		SETTLEMENT_NO	=	#SETTLEMENT_NO#
		</CFQUERY>
	
		<CFSET	IntegerBlankVal		=	"">
		<CFSET	StringBlankVal		=	"">
		<cfset	FileName			=	"ECN_#MKT_TYPE##SETTLEMENT_NO#.txt">

		<cffile action="write" file="C:\CFUSIONMX7\WWWROOT\#FileName#" output="{}" addnewline="yes">
		
		<CFSET	Sender_Address		=	GetSysSetting.BSEWebXBrokerID>
		<CFSET	BackOffice_BatchID	=	GetSysSetting.BackOfficeBatchID>
		<CFSET	ScripSummaryRecord	=	"">
		<CFSET	ScripRecord	=	"">
		<cfset	FILE_DATA		=	"">
		<CFSET	ScripSrNo		=	0>

	<cfoutput query="GetTradeData" group="Client_ID">
		<cfset Contract_No = Contract_No>
		<cfset	Client_WebXID	=	Client_WebXID>
		<cfset	CUSTODIAN_CODE 	=	CUSTODIAN_CODE>
		<cfset	TradeDate	=	TradeDate>
		
		<CFQUERY NAME="GetClDetail" datasource="#Client.database#">
			SELECT	Client_SebiRegnNo, Pan_No
			FROM
					Client_Details
			WHERE
					Client_ID	=	'#Client_ID#'
		</CFQUERY>
		
		<CFSET	Client_SebiRegnNo	=	GetClDetail.Client_SebiRegnNo>
		<CFIF TRIM(GetClDetail.Pan_No) IS NOT "">
			<CFSET	Pan_No				=	GetClDetail.Pan_No>
		<cfelse>
			<cfset	PAN_NO = "APPLIEDFOR">
		</CFIF>
			
			<cfoutput>
				<CFSET	Trade_Number1	=	Replace(Replace(Replace(Replace(Replace(Trade_Number, "M", "", "ALL"), "SP", "", "ALL"), "SPSP", ""), "B", ""), "ND", "")>
				<CFSET	Order_Number1	=	Replace(Replace(Replace(Replace(Replace(Order_Number, "M", "", "ALL"), "SP", "", "ALL"), "SPSP", ""), "B", ""), "ND", "")>
				
				<cfloop index="i" from="65" to="90">
					<CFSET	Trade_Number1	=	Replace(Trade_Number1, "#CHR(i)#", "", "ALL")>
				</cfloop>
				
				<cfloop index="j" from="97" to="122">
					<CFSET	Trade_Number1	=	Replace(Trade_Number1, "#CHR(J)#", "", "ALL")>
				</cfloop>
						 	 
				<cfloop index="k" from="65" to="90">
					<CFSET	Order_Number1	=	Replace(Order_Number1, "#CHR(K)#", "", "ALL")>
				</cfloop>
				
				<cfloop index="l" from="97" to="122">
					<CFSET	Order_Number1	=	Replace(Order_Number1, "#CHR(L)#", "", "ALL")>
				</cfloop>
							 
				<CFQUERY NAME="GetScripCount" DBTYPE="QUERY">
					Select	Distinct	Scrip_Symbol
					From
							GetTradeData
					WHERE
							Client_ID	=	'#Client_ID#'
				</CFQUERY>
				<CFSET	Scrip_Count	=	GetScripCount.RecordCount>
				<cfset	BackOffice_BatchID	=		"#TRADEDATE##GenerationNo#">
		
						<CFSET	ScripSrNo			=	ScripSrNo + 1>
						<CFSET	Record_Type			=	"#fileConvertString(15, 2, 'L', IntegerBlankVal)#">
						<CFSET	Record_Number		=	"#fileConvertString(ScripSrNo, 5, 'R', IntegerBlankVal)#">
						<CFSET	Instrument_Type		=	"#fileConvertString('EQTY', 4, 'L', StringBlankVal)#">
						
						<CFSET	Sender_Reference	=	"A#NumRefCode##fileConvertString(Contract_No, 13, 'R', IntegerBlankVal)#">
						<CFSET	Sender_Reference	=	"#fileConvertString(Sender_Reference, 16, 'L', StringBlankVal)#">
						
						<CFSET	Preparation_DateTime=	"#DateFormat(now(),'YYYYMMDD')##TimeFormat(now(),'HHMMSS')#">
						<CFSET	Preparation_DateTime=	"#fileConvertString(Preparation_DateTime, 14, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Date		=	"#fileConvertString(TradeDate, 8, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Prd		=	"#SettlementDetail.From_Date#to#SettlementDetail.To_Date#">
						<CFSET	Settlement_Prd		=	"#fileConvertString(Settlement_Prd, 35, 'L', StringBlankVal)#">
						
						<CFSET	Trd_Date			=	"#fileConvertString(TradeDate, 8, 'L', StringBlankVal)#">
			
						<CFSET	Exchange_BIC_Code	=	"#fileConvertString(ExchangeBICCode, 4, 'L', StringBlankVal)#">
						<CFSET	Trd_Type			=	"#fileConvertString(Left(Buy_Sale,1), 1, 'L', StringBlankVal)#">
						
						<CFSET	Client_Details		=	"I#Client_WebXID#">
						<CFSET	Client_Details		=	"#fileConvertString(Client_Details, 7, 'L', StringBlankVal)#">
						
						<CFSET	Client_Code			=	"#fileConvertString(Client_ID, 20, 'L', StringBlankVal)#">
			
						<CFSET	Inv_SEBI_Regn_No	=	"#fileConvertString(Client_SebiRegnNo, 15, 'L', StringBlankVal)#"><!---- Investor Sebi Regn No ---->
						<CFSET	Inv_PAN_No			=	"#fileConvertString(Pan_No, 10, 'L', StringBlankVal)#">
						<CFSET	CP_Code				=	"#fileConvertString(CUSTODIAN_CODE, 12, 'L', StringBlankVal)#">
						<CFSET	Isin_Scrip			=	"#fileConvertString(ISIN, 12, 'L', StringBlankVal)#">
						<CFSET	Security_Name		=	"#fileConvertString(Scrip_Name, 30, 'L', StringBlankVal)#">
						<CFSET	Setl_Type			=	"#fileConvertString(Setl_Type, 2, 'L', StringBlankVal)#">
						<CFSET	Setl_No				=	"#fileConvertString(Settlement_No, 20, 'L', StringBlankVal)#">
						<CFSET	CN_Place			=	"#fileConvertString('Mumbai', 35, 'L', StringBlankVal)#">
						<CFSET	Total_Trade_Qty		=	"#fileConvertString(Quantity, 15, 'L', IntegerBlankVal)#">
						
						<cfset	Price				=	"#NumberFormat(Price_Premium, "99999999.9999")#">
						<CFSET	Trade_Rate			=	"#fileConvertString(Price, 15, 'L', IntegerBlankVal)#">
						
						<cfset	TrdAmount			=	"#NumberFormat(Quantity * Price_Premium, "99999999.9999")#">
						<CFSET	Trade_Amount		=	"#fileConvertString(TrdAmount, 15, 'L', IntegerBlankVal)#">
						
						<CFSET	Brokerage			=	"#fileConvertString(TotBrokerage, 15, 'L', IntegerBlankVal)#">
						<CFSET	Service_Tax			=	"#fileConvertString(0, 15, 'L', IntegerBlankVal)#">
						<!--- <CFIF	Buy_Sale	is	"Buy">
							<CFSET	Net_Rate			=	>
						<CFELSE>	
							<CFSET	Net_Rate			=	>
						</CFIF> --->
						<CFSET	Net_Rate			=	"#NumberFormat(RATEPLMSBRK,'9999999.9999')#">
						<CFSET	Net_Rate			=	"#fileConvertString(Net_Rate, 15, 'L', IntegerBlankVal)#">
						<CFSET	Net_Amount			=	NumberFormat((Quantity * RATEPLMSBRK), "999999999.9999")>
						<CFSET	Setl_Amount			=	"#fileConvertString(Net_Amount, 15, 'L', IntegerBlankVal)#">
						<CFSET	Total_Scripwise_Trades	=	"#fileConvertString(1, 5, 'R', IntegerBlankVal)#">
						<CFSET	Line_Number			=	0>
						
						<cfset	FILE_DATA		=	"#FILE_DATA##CHR(10)##Record_Type#|#Record_Number#|#Instrument_Type#|#Sender_Reference#|#Preparation_DateTime#|#Settlement_Date#|#Settlement_Prd#|#Trd_Date#|#Exchange_BIC_Code#|#Trd_Type#|#Client_Details#|#Client_Code#|#Inv_SEBI_Regn_No#|#Inv_PAN_No#|#CP_Code#|#Isin_Scrip#|#Security_Name#|#Setl_Type#|#Setl_No#|#CN_Place#|#Total_Trade_Qty#|#Trade_Rate#|#Trade_Amount#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Setl_Amount#|#Total_Scripwise_Trades#">
		
						<CFSET	Line_Number		=	Line_Number + 1>
						<CFSET	Line_Number		=	1>
						<CFSET	Record_Type		=	"#fileConvertString(13, 2, 'L', IntegerBlankVal)#">
						<CFSET	Line_Number		=	"#fileConvertString(Line_Number, 5, 'L', IntegerBlankVal)#">
						<CFSET	Order_No		=	"#fileConvertString(Order_Number1, 15, 'L', IntegerBlankVal)#">
						<CFSET	Trd_No			=	"#fileConvertString(Trade_Number1, 15, 'L', IntegerBlankVal)#">
						<CFSET	Trd_Qty			=	"#fileConvertString(Quantity, 15, 'L', IntegerBlankVal)#">
						<CFSET	Trd_Rate		=	"#fileConvertString(NumberFormat(Price_Premium, '999999999.9999'), 15, 'L', IntegerBlankVal)#">
						<CFSET	Trd_DateTime	=	"#fileConvertString(TRD_DTTIME, 15, 'L', StringBlankVal)#">
						<CFSET	Brokerage		=	NumberFormat((Trade_Brokerage + Delivery_Brokerage), "9999999999.9999")>
						<CFSET	Brokerage		=	"#fileConvertString(Brokerage, 15, 'L', IntegerBlankVal)#">
						<CFSET	Service_Tax		=	"#fileConvertString( NumberFormat(((Brokerage * GetSTChrgs.SC) / 100), '9999999.9999'), 15, 'L', IntegerBlankVal)#">
						<CFIF	Buy_Sale	EQ	"BUY">
							<CFSET	Net_Rate	=	(Price_Premium + (Trade_Brokerage + Delivery_Brokerage))>
						<CFELSE>
							<CFSET	Net_Rate	=	(Price_Premium - (Trade_Brokerage + Delivery_Brokerage))>
						</CFIF>
						<CFSET	Net_Rate		=	"#NumberFormat(Net_Rate, "999999999.9999")#">
						<CFSET	Net_Rate		=	"#fileConvertString( Net_Rate, 15, 'L', IntegerBlankVal)#">
						<CFSET	Total_Amount	=	((Trd_Qty * Net_Rate))>
						<CFSET	Total_Amount	=	"#fileConvertString(NumberFormat(Total_Amount, "999999999.9999"), 15, 'L', IntegerBlankVal)#">
						<cfset	FILE_DATA		=	"#FILE_DATA##CHR(10)##Record_Type#|#Line_Number#|#Order_No#|#Trd_No#|#Trd_Qty#|#Trd_Rate#|#Trd_DateTime#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Total_Amount#">
				</cfoutput>
		
				<cfquery name="GetDrCrAmt" dbtype="query">
					SELECT	SUM(BUY_AMOUNT)BUY_AMOUNT, SUM(SALE_AMOUNT)SALE_AMOUNT
					FROM
							GetTradeData
					WHERE
							Client_ID	=	'#Client_ID#'
				</cfquery>

				<cfset	TotalDrAmt	=	0>
				<cfset	TotalCrAmt	=	0>
				
				<cfset	TotalDrAmt	=	GetDrCrAmt.BUY_AMOUNT>
				<cfset	TotalCrAmt	=	GetDrCrAmt.SALE_AMOUNT>
				<cfif (TotalDrAmt-TotalCrAmt) GT 0>
					<cfset	TotalNetAmtHeading		=	"Net Debit">
					<cfset	Scrip_Code				=	6666>
					<cfset	TotalNetAmt				=	TotalDrAmt-TotalCrAmt>
					<cfset	BuySaleType				=	"B">
				<cfelseif (TotalCrAmt-TotalDrAmt) GT 0>
					<cfset	TotalNetAmtHeading		=	"Net Credit">
					<cfset	Scrip_Code				=	7777>
					<cfset	TotalNetAmt				=	TotalCrAmt-TotalDrAmt>
					<cfset	BuySaleType				=	"S">
				</cfif>
				
				<cfquery name="GetExp" datasource="#Client.database#">
					SELECT	EXPENSE_TYPE, DEBIT
					FROM
							CLIENT_EXPENSES
					WHERE
							COMPANY_CODE	=	'#COCD#'
					AND		MKT_TYPE		=	'#MKT_TYPE#'
					AND		SETTLEMENT_NO	=	#SETTLEMENT_NO#
					AND		CLIENT_ID		=	'#CLIENT_ID#'
					AND		EXPENSE_TYPE	<>	'BRK'
				</cfquery>

				<cfloop query="GetExp">
						<cfset	TotalDrAmt	=	TotalDrAmt + DEBIT>

						<CFSET	ScripSrNo			=	ScripSrNo + 1>
						<CFSET	Record_Type			=	"#fileConvertString(15, 2, 'L', IntegerBlankVal)#">
						<CFSET	Record_Number		=	"#fileConvertString(ScripSrNo, 5, 'R', IntegerBlankVal)#">
						<CFSET	Instrument_Type		=	"#fileConvertString('EQSM', 4, 'L', StringBlankVal)#">
						
						<CFSET	Sender_Reference	=	"A#NumRefCode##fileConvertString(Contract_No, 13, 'R', IntegerBlankVal)#">
						<CFSET	Sender_Reference	=	"#fileConvertString(Sender_Reference, 16, 'L', StringBlankVal)#">
						
						<CFSET	Preparation_DateTime=	"#DateFormat(now(),'YYYYMMDD')##TimeFormat(now(),'HHMMSS')#">
						<CFSET	Preparation_DateTime=	"#fileConvertString(Preparation_DateTime, 14, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Date		=	"#fileConvertString('', 8, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Prd		=	"">
						<CFSET	Settlement_Prd		=	"#fileConvertString(Settlement_Prd, 35, 'L', StringBlankVal)#">
						
						<CFSET	Trd_Date			=	"#fileConvertString(TradeDate, 8, 'L', StringBlankVal)#">
			
						<CFSET	Exchange_BIC_Code	=	"#fileConvertString(ExchangeBICCode, 4, 'L', StringBlankVal)#">
						<CFSET	Trd_Type			=	"#fileConvertString('B', 1, 'L', StringBlankVal)#">
						
						<CFSET	Client_Details		=	"I#Client_WebXID#">
						<CFSET	Client_Details		=	"#fileConvertString(Client_Details, 7, 'L', StringBlankVal)#">
						
						<CFSET	Client_Code			=	"#fileConvertString(Client_ID, 20, 'L', StringBlankVal)#">
			
						<CFSET	Inv_SEBI_Regn_No	=	"#fileConvertString(Client_SebiRegnNo, 15, 'L', StringBlankVal)#"><!---- Investor Sebi Regn No ---->
						<CFSET	Inv_PAN_No			=	"#fileConvertString(Pan_No, 10, 'L', StringBlankVal)#">
						<CFSET	CP_Code				=	"#fileConvertString(CUSTODIAN_CODE, 12, 'L', StringBlankVal)#">
						<CFSET	Isin_Scrip			=	"#fileConvertString('9999', 12, 'L', StringBlankVal)#">
						<CFSET	Security_Name		=	"#fileConvertString('#EXPENSE_TYPE#', 30, 'L', StringBlankVal)#">
						<CFSET	Setl_Type			=	"#fileConvertString(Setl_Type, 2, 'L', StringBlankVal)#">
						<CFSET	Setl_No				=	"#fileConvertString(Settlement_No, 20, 'L', StringBlankVal)#">
						<CFSET	CN_Place			=	"#fileConvertString('', 35, 'L', StringBlankVal)#">
						<CFSET	Total_Trade_Qty		=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Trade_Rate			=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Trade_Amount		=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Brokerage			=	"#fileConvertString(0, 15, 'L', StringBlankVal)#">
						<CFSET	Service_Tax			=	"#fileConvertString(0, 15, 'L', StringBlankVal)#">
						<!--- <CFIF	Buy_Sale	is	"Buy">
							<CFSET	Net_Rate			=	>
						<CFELSE>	
							<CFSET	Net_Rate			=	>
						</CFIF> --->
						<CFSET	Net_Rate			=	"#fileConvertString(0, 15, 'L', IntegerBlankVal)#">
						<CFSET	Net_Amount			=	NumberFormat(Debit, "999999999.9999")>
						<CFSET	Setl_Amount			=	"#fileConvertString(Net_Amount, 15, 'L', IntegerBlankVal)#">
						<CFSET	Total_Scripwise_Trades	=	"#fileConvertString(1, 5, 'R', IntegerBlankVal)#">
						<CFSET	Line_Number			=	0>
						
						<cfSET FILE_DATA		=	"#FILE_DATA##CHR(10)##Record_Type#|#Record_Number#|#Instrument_Type#|#Sender_Reference#|#Preparation_DateTime#|#Settlement_Date#|#Settlement_Prd#|#Trd_Date#|#Exchange_BIC_Code#|#Trd_Type#|#Client_Details#|#Client_Code#|#Inv_SEBI_Regn_No#|#Inv_PAN_No#|#CP_Code#|#Isin_Scrip#|#Security_Name#|#Setl_Type#|#Setl_No#|#CN_Place#|#Total_Trade_Qty#|#Trade_Rate#|#Trade_Amount#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Setl_Amount#|#Total_Scripwise_Trades#">
		
						<CFSET	Line_Number		=	Line_Number + 1>
						<CFSET	Line_Number		=	1>
						<CFSET	Record_Type		=	"#fileConvertString(13, 2, 'L', IntegerBlankVal)#">
						<CFSET	Line_Number		=	"#fileConvertString(Line_Number, 5, 'L', IntegerBlankVal)#">
						<cfSET FILE_DATA		=	"#FILE_DATA##CHR(10)##Record_Type#|#Line_Number#|#Order_No#|#Trd_No#|#Trd_Qty#|#Trd_Rate#|#Trd_DateTime#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Total_Amount#">
				</cfloop>		

						<CFSET	ScripSrNo			=	ScripSrNo + 1>
						<CFSET	Record_Type			=	"#fileConvertString(15, 2, 'L', IntegerBlankVal)#">
						<CFSET	Record_Number		=	"#fileConvertString(ScripSrNo, 5, 'R', IntegerBlankVal)#">
						<CFSET	Instrument_Type		=	"#fileConvertString('EQSM', 4, 'L', StringBlankVal)#">
						
						<CFSET	Sender_Reference	=	"A#NumRefCode##fileConvertString(Contract_No, 13, 'R', IntegerBlankVal)#">
						<CFSET	Sender_Reference	=	"#fileConvertString(Sender_Reference, 16, 'L', StringBlankVal)#">
						
						<CFSET	Preparation_DateTime=	"#DateFormat(now(),'YYYYMMDD')##TimeFormat(now(),'HHMMSS')#">
						<CFSET	Preparation_DateTime=	"#fileConvertString(Preparation_DateTime, 14, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Date		=	"#fileConvertString('', 8, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Prd		=	"">
						<CFSET	Settlement_Prd		=	"#fileConvertString(Settlement_Prd, 35, 'L', StringBlankVal)#">
						
						<CFSET	Trd_Date			=	"#fileConvertString(TradeDate, 8, 'L', StringBlankVal)#">
			
						<CFSET	Exchange_BIC_Code	=	"#fileConvertString(ExchangeBICCode, 4, 'L', StringBlankVal)#">
						<CFSET	Trd_Type			=	"#fileConvertString('B', 1, 'L', StringBlankVal)#">
						
						<CFSET	Client_Details		=	"I#Client_WebXID#">
						<CFSET	Client_Details		=	"#fileConvertString(Client_Details, 7, 'L', StringBlankVal)#">
						
						<CFSET	Client_Code			=	"#fileConvertString(Client_ID, 20, 'L', StringBlankVal)#">
			
						<CFSET	Inv_SEBI_Regn_No	=	"#fileConvertString(Client_SebiRegnNo, 15, 'L', StringBlankVal)#"><!---- Investor Sebi Regn No ---->
						<CFSET	Inv_PAN_No			=	"#fileConvertString(Pan_No, 10, 'L', StringBlankVal)#">
						<CFSET	CP_Code				=	"#fileConvertString(CUSTODIAN_CODE, 12, 'L', StringBlankVal)#">
						<CFSET	Isin_Scrip			=	"#fileConvertString('8888', 12, 'L', StringBlankVal)#">
						<CFSET	Security_Name		=	"#fileConvertString('Total Debit', 30, 'L', StringBlankVal)#">
						<CFSET	Setl_Type			=	"#fileConvertString(Setl_Type, 2, 'L', StringBlankVal)#">
						<CFSET	Setl_No				=	"#fileConvertString(Settlement_No, 20, 'L', StringBlankVal)#">
						<CFSET	CN_Place			=	"#fileConvertString('', 35, 'L', StringBlankVal)#">
						<CFSET	Total_Trade_Qty		=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Trade_Rate			=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Trade_Amount		=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Brokerage			=	"#fileConvertString(0, 15, 'L', StringBlankVal)#">
						<CFSET	Service_Tax			=	"#fileConvertString(0, 15, 'L', StringBlankVal)#">
						<!--- <CFIF	Buy_Sale	is	"Buy">
							<CFSET	Net_Rate			=	>
						<CFELSE>	
							<CFSET	Net_Rate			=	>
						</CFIF> --->
						<CFSET	Net_Rate			=	"#fileConvertString(0, 15, 'L', IntegerBlankVal)#">
						<CFSET	Net_Amount			=	NumberFormat(TotalDrAmt, "999999999.9999")>
						<CFSET	Setl_Amount			=	"#fileConvertString(Net_Amount, 15, 'L', IntegerBlankVal)#">
						<CFSET	Total_Scripwise_Trades	=	"#fileConvertString(1, 5, 'R', IntegerBlankVal)#">
						<CFSET	Line_Number			=	0>
						
						<cfSET FILE_DATA		=	"#FILE_DATA##CHR(10)##Record_Type#|#Record_Number#|#Instrument_Type#|#Sender_Reference#|#Preparation_DateTime#|#Settlement_Date#|#Settlement_Prd#|#Trd_Date#|#Exchange_BIC_Code#|#Trd_Type#|#Client_Details#|#Client_Code#|#Inv_SEBI_Regn_No#|#Inv_PAN_No#|#CP_Code#|#Isin_Scrip#|#Security_Name#|#Setl_Type#|#Setl_No#|#CN_Place#|#Total_Trade_Qty#|#Trade_Rate#|#Trade_Amount#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Setl_Amount#|#Total_Scripwise_Trades#">
		
						<CFSET	Line_Number		=	Line_Number + 1>
						<CFSET	Line_Number		=	1>
						<CFSET	Record_Type		=	"#fileConvertString(13, 2, 'L', IntegerBlankVal)#">
						<CFSET	Line_Number		=	"#fileConvertString(Line_Number, 5, 'L', IntegerBlankVal)#">
						<cfSET FILE_DATA		=	"#FILE_DATA##CHR(10)##Record_Type#|#Line_Number#|#Order_No#|#Trd_No#|#Trd_Qty#|#Trd_Rate#|#Trd_DateTime#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Total_Amount#">

<!-----tot cr------->
						<CFSET	ScripSrNo			=	ScripSrNo + 1>
						<CFSET	Record_Type			=	"#fileConvertString(15, 2, 'L', IntegerBlankVal)#">
						<CFSET	Record_Number		=	"#fileConvertString(ScripSrNo, 5, 'R', IntegerBlankVal)#">
						<CFSET	Instrument_Type		=	"#fileConvertString('EQSM', 4, 'L', StringBlankVal)#">
						
						<CFSET	Sender_Reference	=	"A#NumRefCode##fileConvertString(Contract_No, 13, 'R', IntegerBlankVal)#">
						<CFSET	Sender_Reference	=	"#fileConvertString(Sender_Reference, 16, 'L', StringBlankVal)#">
						
						<CFSET	Preparation_DateTime=	"#DateFormat(now(),'YYYYMMDD')##TimeFormat(now(),'HHMMSS')#">
						<CFSET	Preparation_DateTime=	"#fileConvertString(Preparation_DateTime, 14, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Date		=	"#fileConvertString('', 8, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Prd		=	"">
						<CFSET	Settlement_Prd		=	"#fileConvertString(Settlement_Prd, 35, 'L', StringBlankVal)#">
						
						<CFSET	Trd_Date			=	"#fileConvertString(TradeDate, 8, 'L', StringBlankVal)#">
			
						<CFSET	Exchange_BIC_Code	=	"#fileConvertString(ExchangeBICCode, 4, 'L', StringBlankVal)#">
						<CFSET	Trd_Type			=	"#fileConvertString('S', 1, 'L', StringBlankVal)#">
						
						<CFSET	Client_Details		=	"I#Client_WebXID#">
						<CFSET	Client_Details		=	"#fileConvertString(Client_Details, 7, 'L', StringBlankVal)#">
						
						<CFSET	Client_Code			=	"#fileConvertString(Client_ID, 20, 'L', StringBlankVal)#">
			
						<CFSET	Inv_SEBI_Regn_No	=	"#fileConvertString(Client_SebiRegnNo, 15, 'L', StringBlankVal)#"><!---- Investor Sebi Regn No ---->
						<CFSET	Inv_PAN_No			=	"#fileConvertString(Pan_No, 10, 'L', StringBlankVal)#">
						<CFSET	CP_Code				=	"#fileConvertString(CUSTODIAN_CODE, 12, 'L', StringBlankVal)#">
						<CFSET	Isin_Scrip			=	"#fileConvertString('8888', 12, 'L', StringBlankVal)#">
						<CFSET	Security_Name		=	"#fileConvertString('Total Credit', 30, 'L', StringBlankVal)#">
						<CFSET	Setl_Type			=	"#fileConvertString(Setl_Type, 2, 'L', StringBlankVal)#">
						<CFSET	Setl_No				=	"#fileConvertString(Settlement_No, 20, 'L', StringBlankVal)#">
						<CFSET	CN_Place			=	"#fileConvertString('', 35, 'L', StringBlankVal)#">
						<CFSET	Total_Trade_Qty		=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Trade_Rate			=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Trade_Amount		=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Brokerage			=	"#fileConvertString(0, 15, 'L', StringBlankVal)#">
						<CFSET	Service_Tax			=	"#fileConvertString(0, 15, 'L', StringBlankVal)#">
						<!--- <CFIF	Buy_Sale	is	"Buy">
							<CFSET	Net_Rate			=	>
						<CFELSE>	
							<CFSET	Net_Rate			=	>
						</CFIF> --->
						<CFSET	Net_Rate			=	"#fileConvertString(0, 15, 'L', IntegerBlankVal)#">
						<CFSET	Net_Amount			=	NumberFormat(TotalCrAmt, "999999999.9999")>
						<CFSET	Setl_Amount			=	"#fileConvertString(Net_Amount, 15, 'L', IntegerBlankVal)#">
						<CFSET	Total_Scripwise_Trades	=	"#fileConvertString(1, 5, 'R', IntegerBlankVal)#">
						<CFSET	Line_Number			=	0>
						
						<cfset	file_data		=	"#FILE_DATA##CHR(10)##Record_Type#|#Record_Number#|#Instrument_Type#|#Sender_Reference#|#Preparation_DateTime#|#Settlement_Date#|#Settlement_Prd#|#Trd_Date#|#Exchange_BIC_Code#|#Trd_Type#|#Client_Details#|#Client_Code#|#Inv_SEBI_Regn_No#|#Inv_PAN_No#|#CP_Code#|#Isin_Scrip#|#Security_Name#|#Setl_Type#|#Setl_No#|#CN_Place#|#Total_Trade_Qty#|#Trade_Rate#|#Trade_Amount#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Setl_Amount#|#Total_Scripwise_Trades#">
		
						<CFSET	Line_Number		=	Line_Number + 1>
						<CFSET	Line_Number		=	1>
						<CFSET	Record_Type		=	"#fileConvertString(13, 2, 'L', IntegerBlankVal)#">
						<CFSET	Line_Number		=	"#fileConvertString(Line_Number, 5, 'L', IntegerBlankVal)#">
						<cfset	file_data		=	"#FILE_DATA##CHR(10)##Record_Type#|#Line_Number#|#Order_No#|#Trd_No#|#Trd_Qty#|#Trd_Rate#|#Trd_DateTime#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Total_Amount#">
<!-----net amt----------->
						<cfquery name="GetBill" datasource="#Client.database#">
							SELECT (DEBIT_AMT - CREDIT_AMT) NET_AMT
							FROM
									TRADE_TO_ACCOUNTS
							WHERE
									COMPANY_CODE	=	'#COCD#'
							AND		MKT_TYPE		=	'#MKT_TYPE#'
							AND		SETTLEMENT_NO	=	#SETTLEMENT_NO#
							AND		CLIENT_ID		=	'#CLIENT_ID#'
						</cfquery>
				<cfif (GetBill.NET_AMT) GT 0>
					<cfset	TotalNetAmtHeading		=	"Net Debit">
					<cfset	Scrip_Code				=	6666>
					<cfset	TotalNetAmt				=	GetBill.NET_AMT>
					<cfset	BuySaleType				=	"B">
				<cfelseif (GetBill.NET_AMT) LT 0>
					<cfset	TotalNetAmtHeading		=	"Net Credit">
					<cfset	Scrip_Code				=	7777>
					<cfset	TotalNetAmt				=	ABS(GetBill.NET_AMT)>
					<cfset	BuySaleType				=	"S">
				</cfif>
				
						<CFSET	ScripSrNo			=	ScripSrNo + 1>
						<CFSET	Record_Type			=	"#fileConvertString(15, 2, 'L', IntegerBlankVal)#">
						<CFSET	Record_Number		=	"#fileConvertString(ScripSrNo, 5, 'R', IntegerBlankVal)#">
						<CFSET	Instrument_Type		=	"#fileConvertString('EQSM', 4, 'L', StringBlankVal)#">
						
						<CFSET	Sender_Reference	=	"A#NumRefCode##fileConvertString(Contract_No, 13, 'R', IntegerBlankVal)#">
						<CFSET	Sender_Reference	=	"#fileConvertString(Sender_Reference, 16, 'L', StringBlankVal)#">
						
						<CFSET	Preparation_DateTime=	"#DateFormat(now(),'YYYYMMDD')##TimeFormat(now(),'HHMMSS')#">
						<CFSET	Preparation_DateTime=	"#fileConvertString(Preparation_DateTime, 14, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Date		=	"#fileConvertString('', 8, 'L', StringBlankVal)#">
						
						<CFSET	Settlement_Prd		=	"">
						<CFSET	Settlement_Prd		=	"#fileConvertString(Settlement_Prd, 35, 'L', StringBlankVal)#">
						
						<CFSET	Trd_Date			=	"#fileConvertString(TradeDate, 8, 'L', StringBlankVal)#">
			
						<CFSET	Exchange_BIC_Code	=	"#fileConvertString(ExchangeBICCode, 4, 'L', StringBlankVal)#">
						<CFSET	Trd_Type			=	"#fileConvertString('#BuySaleType#', 1, 'L', StringBlankVal)#">
						
						<CFSET	Client_Details		=	"I#Client_WebXID#">
						<CFSET	Client_Details		=	"#fileConvertString(Client_Details, 7, 'L', StringBlankVal)#">
						
						<CFSET	Client_Code			=	"#fileConvertString(Client_ID, 20, 'L', StringBlankVal)#">
			
						<CFSET	Inv_SEBI_Regn_No	=	"#fileConvertString(Client_SebiRegnNo, 15, 'L', StringBlankVal)#"><!---- Investor Sebi Regn No ---->
						<CFSET	Inv_PAN_No			=	"#fileConvertString(Pan_No, 10, 'L', StringBlankVal)#">
						<CFSET	CP_Code				=	"#fileConvertString(CUSTODIAN_CODE, 12, 'L', StringBlankVal)#">
						<CFSET	Isin_Scrip			=	"#fileConvertString('#Scrip_Code#', 12, 'L', StringBlankVal)#">
						<CFSET	Security_Name		=	"#fileConvertString('#TotalNetAmtHeading#', 30, 'L', StringBlankVal)#">
						<CFSET	Setl_Type			=	"#fileConvertString(Setl_Type, 2, 'L', StringBlankVal)#">
						<CFSET	Setl_No				=	"#fileConvertString(Settlement_No, 20, 'L', StringBlankVal)#">
						<CFSET	CN_Place			=	"#fileConvertString('', 35, 'L', StringBlankVal)#">
						<CFSET	Total_Trade_Qty		=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Trade_Rate			=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Trade_Amount		=	"#fileConvertString('', 15, 'L', StringBlankVal)#">
						<CFSET	Brokerage			=	"#fileConvertString(0, 15, 'L', StringBlankVal)#">
						<CFSET	Service_Tax			=	"#fileConvertString(0, 15, 'L', StringBlankVal)#">
						<CFSET	Net_Rate			=	"#fileConvertString(0, 15, 'L', IntegerBlankVal)#">
						<CFSET	Net_Amount			=	NumberFormat(TotalNetAmt, "999999999.9999")>
						<CFSET	Setl_Amount			=	"#fileConvertString(Net_Amount, 15, 'L', IntegerBlankVal)#">
						<CFSET	Total_Scripwise_Trades	=	"#fileConvertString(1, 5, 'R', IntegerBlankVal)#">
						<CFSET	Line_Number			=	1>
						
						<cfset FILE_DATA	=	"#FILE_DATA##CHR(10)##Record_Type#|#Record_Number#|#Instrument_Type#|#Sender_Reference#|#Preparation_DateTime#|#Settlement_Date#|#Settlement_Prd#|#Trd_Date#|#Exchange_BIC_Code#|#Trd_Type#|#Client_Details#|#Client_Code#|#Inv_SEBI_Regn_No#|#Inv_PAN_No#|#CP_Code#|#Isin_Scrip#|#Security_Name#|#Setl_Type#|#Setl_No#|#CN_Place#|#Total_Trade_Qty#|#Trade_Rate#|#Trade_Amount#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Setl_Amount#|#Total_Scripwise_Trades#">
		
						<CFSET	Record_Type		=	"#fileConvertString(13, 2, 'L', IntegerBlankVal)#">
						<CFSET	Line_Number		=	"#fileConvertString(Line_Number, 5, 'L', IntegerBlankVal)#">
						<cfset FILE_DATA	=	"#FILE_DATA##CHR(10)##Record_Type#|#Line_Number#|#Order_No#|#Trd_No#|#Trd_Qty#|#Trd_Rate#|#Trd_DateTime#|#Brokerage#|#Service_Tax#|#Net_Rate#|#Total_Amount#">
	</CFOUTPUT>		
		<cfset	FILE_HEADER_DATA	=	"#fileConvertString( 11, 2, 'L', IntegerBlankVal)#|#fileConvertString( Register_Id, 4, 'L', IntegerBlankVal)#|#fileConvertString( BackOffice_BatchID, 11, 'L', IntegerBlankVal)#|#fileConvertString( ScripSrNo, 5, 'R', IntegerBlankVal)#">
		<cfset	FILE_DATA	=	"#FILE_HEADER_DATA##FILE_DATA##CHR(10)#19#CHR(10)#{}">
		<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes">

		<br>
		<cfoutput>
		<br><br>FILE GENERATED IN SERVER <A target="blank" HREF="FILE:\\#Server_NAme#\C\CFUSIONMX7\WWWROOT\#FileName#">C\CFUSIONMX7\WWWROOT\#FileName#.</a>
		</cfoutput>
	
		<CFSET	Changed_FileName	=	FileName>

		<CFOUTPUT>
			<CFTRY>

				<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">
				
				<CFSET	ClientFileGenerated	=	CopyFile("C:\CFUSIONMX7\WWWROOT\#FileName#","C:\#FileName#")>

				<CFIF Not ClientFileGenerated>
					<CENTER>
						<FONT COLOR="Green">
							<B>Warning	:</B><BR>
							File Generated on Server Location.<BR>
							File not Generated On Client Machine.<BR>
						</FONT>
					</CENTER>
				<CFELSE>
					<BR>File Generated On Client Machine on "C:\#Changed_FileName#".<BR>
				</CFIF>
			<CFCATCH TYPE="Any">
				<CENTER>
					<FONT COLOR="Green">
						<B><U>Warning</U>:</B><BR>
						File Generated on Server Location.<BR>
						File not Generated On Client Machine.<BR>
					</FONT>
					<FONT COLOR="RED">
						(#CFCATCH.Detail#)
					</FONT>
				</CENTER>
			</CFCATCH>
			</CFTRY>
		</CFOUTPUT>
</cfif>

</BODY>
</HTML>
