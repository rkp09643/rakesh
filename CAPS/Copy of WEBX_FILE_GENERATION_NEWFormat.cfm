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
				IsNull(Custodian_List, 'INST')Custodian_List, BSEWebXBrokerID, BackOfficeBatchID,
				CONVERT(CHAR(10),GETDATE(),112)CurrentDateInYearFormat,Broker_CMBP_ID
		FROM
				System_Settings
		WHERE
				Company_Code	=	'#COCD#'
	</CFQUERY>
	<CFSET Broker_CMBP_ID = "#GetSysSetting.Broker_CMBP_ID#">
	<cfset	inst_list	=	GetSysSetting.Custodian_List>
	<cfset 	DateInYYMMDD	=	GetSysSetting.CurrentDateInYearFormat>
	
	<CFQUERY NAME="GetSTChrgs" datasource="#Client.database#">
		SELECT 	ISNULL(MAX( SC ), 0) SC
		FROM 	SERVICE_CHARGE
		WHERE	COMPANY_CODE 	=  '#COCD#'
		 AND	CONVERT( DATETIME, FROM_DATE, 103) <=  CONVERT( DATETIME, '#TRADE_DATE#', 103)
		 AND	CONVERT( DATETIME, ISNULL( TO_DATE, CONVERT( DATETIME, '#TRADE_DATE#', 103) ), 103) >=  CONVERT( DATETIME, '#TRADE_DATE#', 103)
	</CFQUERY>
	<CFSET TRADE_DATE123 = "#TRADE_DATE#"> 
	<CFQUERY NAME="SettlementDetail" datasource="#Client.database#">
		SELECT
				Convert(VarChar(10), FROM_DATE, 103)FROM_DATE,
				Convert(VarChar(10), TO_DATE, 103)TO_DATE,
				Convert(VarChar(10), Funds_PayIn_Date, 103)Funds_PayIn_Date,
				Convert(VarChar(10), Funds_PayOut_Date, 103)Funds_PayOut_Date
		FROM
				SETTLEMENT_MASTER
		WHERE
				COMPANY_CODE	=	'#COCD#'
		AND		MKT_TYPE		=	'#MKT_TYPE#'
		AND		SETTLEMENT_NO	=	#SETTLEMENT_NO#
	</CFQUERY>
	
	<CFQUERY NAME="GetClientRecord" datasource="#Client.database#">
			SELECT	
					A.COMPANY_CODE,A.CLIENT_ID,a.Client_WebXID
			FROM
					CAPSFO_TRANSACTIONS A, ClientDetailView B
			WHERE
					A.COMPANY_CODE	=	'#COCD#'
			AND		A.COMPANY_CODE	=	B.COMPANY_CODE
			AND		A.CLIENT_ID		=	B.CLIENT_ID
			AND		MKT_TYPE		=	'#MKT_TYPE#'
			AND		BILL_SETTLEMENT_NO	=	'#SETTLEMENT_NO#'
			AND		b.CLIENT_NATURE	=	'C'
			AND		LEN(RTRIM(IsNull(b.Client_WebXID,''))) >	0
			AND		ORDER_NUMBER NOT LIKE 'ND%'
			AND		a.EXCHANGE		=	'#EXCHANGE#'
			AND		a.MARKET		=	'#MARKET#'
			ORDER BY
					A.CLIENT_ID, A.Scrip_Symbol, Buy_Sale
		</CFQUERY>
		
	<CFSET I = 1>
		
		<CFQUERY NAME="GetTradeData" datasource="#Client.database#">
			SELECT	
					A.COMPANY_CODE, REPLACE(REPLACE(TRADE_NUMBER, 'SP',''), 'B', '')TRADE_NUMBER, A.CLIENT_ID, A.SCRIP_SYMBOL, A.SCRIP_NAME, TRADE_DATE, 
					convert(varchar(10), TRANSACTION_DATE, 112) TRADEDATE,
					convert(varchar(10), TRADE_DATETIME, 112) +''+ Replace(convert(varchar(10), TRADE_DATETIME, 108), ':', '')TRD_DTTIME, BUY_SALE, MKT_TYPE, SETTLEMENT_NO, QUANTITY, 
					Cast(RATE As Numeric(30,2)) as Price_Premium, A.STRIKE_PRICE, ORDER_NUMBER, ORDER_DATETIME, 
					USER_ID, TRADE_BROKERAGE, DELIVERY_BROKERAGE, 
					BILL_NO, BILL_SETTLEMENT_NO, BILL_DATE, CONTRACT_NO, BROKERAGE_TYPE, 
					TRADE_TYPE, CUSTODIAN_CODE, Contract_No,
					B.Client_WebXID, ISNULL(A.ISIN,'')ISIN, 
					Cast(RATEPLMSBRK As Numeric(30,2))RATEPLMSBRK, 
					Cast(BUY_AMOUNT As Numeric(30,2))BUY_AMOUNT, 
					Cast(SALE_AMOUNT As Numeric(30,2))SALE_AMOUNT,
					Cast((QUANTITY * (TRADE_BROKERAGE + DELIVERY_BROKERAGE))As Numeric(30,2))TotBrokerage,
					IsNull(C.MARKET_LOT, 1)Market_Lot,DP_ID,Client_SebiRegnNo,Pan_No,
					Buy_Quantity,Sale_Quantity,
					CONVERT(VARCHAR(5),TRADE_DATETIME,108)Trade_Time,
					CONVERT(VARCHAR(5),Order_DATETIME,108)Order_Time
			FROM
					CAPSFO_TRANSACTIONS A, ClientDetailView B, SCRIP_MASTER_TABLE C
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
			<cfif MARKET EQ "FO">
				AND		RTRIM(LTRIM(A.ORG_SCRIP_SYMBOL))	=	RTRIM(LTRIM(UPPER(C.SCRIP_SYMBOL)))
				AND		TRADE_TYPE LIKE '%T%'
			<cfelse>
				AND		A.SCRIP_SYMBOL	=	C.SCRIP_SYMBOL
			</cfif>
			
			ORDER BY
					A.CLIENT_ID, A.Scrip_Symbol, Buy_Sale
		</CFQUERY> 
	
		<CFSET	IntegerBlankVal		=	"">
		<CFSET	StringBlankVal		=	"">
		<cfset	FileName			=	"ECN_#MKT_TYPE##SETTLEMENT_NO#.txt">
			
		<CFSET	Sender_Address		=	GetSysSetting.BSEWebXBrokerID>
		<CFSET	BackOffice_BatchID	=	GetSysSetting.BackOfficeBatchID>
		<CFSET	ScripSummaryRecord	=	"">
		<CFSET	ScripRecord		=	"">
		
		<CFSET 	ClientSrNo		=	0>
		<CFSET	CH_DATA	=	"">
		<CFSET	SH_DATA	=	"">
		<CFSET	TH_DATA	=	"">
		<CFSET	FILE_DATA	=	"">

	<cfoutput query="GetTradeData" group="Client_ID">
		<CFSET	ScripSrNo		=	0>
			<CFOUTPUT GROUP="Scrip_Symbol">
				<CFSET	TradeCount		=	0>
				<CFSET	TH_DATA		=	"">
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
								 
					<cfset	Buy_Sale1		=	"#fileConvertString(Left(Buy_Sale,1), 1, 'L', IntegerBlankVal)#">
					<CFSET	Order_No		=	"#fileConvertString(Order_Number1, 15, 'L', IntegerBlankVal)#">
					<CFSET	Ord_DateTime	=	"#fileConvertString(Order_Time, 15, 'L', StringBlankVal)#">
					<CFSET	Trd_No			=	"#fileConvertString(Trade_Number1, 15, 'L', IntegerBlankVal)#">
					<CFSET	Trd_DateTime	=	"#fileConvertString(Trade_Time, 15, 'L', StringBlankVal)#">
					<CFSET	Trade_Qty		=	"#fileConvertString(Quantity, 15, 'L', IntegerBlankVal)#">
					<cfset	Price			=	"#NumberFormat(Price_Premium, "99999999.99")#">
					<CFSET	Trade_Rate		=	"#fileConvertString(Price, 15, 'L', IntegerBlankVal)#">
					<CFSET	Brokerage		=	"#fileConvertString(NumberFormat(TotBrokerage,'9999999.99'), 15, 'L', IntegerBlankVal)#">
					<CFSET	Net_Rate		=	"#NumberFormat(RATEPLMSBRK,'9999999.99')#">
					<CFSET	Net_Rate		=	"#fileConvertString(Net_Rate, 15, 'L', IntegerBlankVal)#">
					<CFSET	Net_Amount		=	NumberFormat((Quantity * RATEPLMSBRK), "999999999.99")>
					<CFSET	Setl_Amount		=	"#fileConvertString(Net_Amount, 15, 'L', IntegerBlankVal)#">
					<CFIF Brokerage_Type EQ "A">
						<CFSET	Brokerage_Type	=	"#fileConvertString('S', 1, 'R', StringBlankVal)#">
					<CFELSE>
						<CFSET	Brokerage_Type	=	"#fileConvertString('D', 1, 'R', StringBlankVal)#">
					</CFIF>
					<CFSET	TradeCount		=	IncrementValue(TradeCount)>
					<CFSET	TH_DATA		=	"#TH_DATA#TH|#Buy_Sale1#|#Order_No#|#Ord_DateTime#|#Trd_No#|#Trd_DateTime#|#Trade_Qty#|#Trade_Rate#|#Brokerage#|#Net_Rate#|#Setl_Amount#||#Brokerage_Type##CHR(10)#">
				</cfoutput>

				<CFSET ScripSrNo	=	IncrementValue(ScripSrNo)>
				<CFQUERY NAME="GetScripQty" DBTYPE="QUERY">
					Select	
							Sum(Buy_Quantity)Buy_Quantity, 
							Sum(Buy_Amount)Buy_Amount,
							Sum(Sale_Quantity)Sale_Quantity, Sum(Sale_Amount)Sale_Amount,
							Sum(Buy_Quantity-Sale_Quantity)Net_Quantity, Sum(Buy_Amount-Sale_Amount)Net_Amount
					From
							GetTradeData
					WHERE
							Client_ID		=	'#Client_ID#'
					And		Scrip_Symbol	=	'#Scrip_Symbol#'
				</CFQUERY>

				<CFQUERY NAME="GetScripSTT" datasource="#Client.database#">
					Select	
							Sum(Del_BSTT)Del_BSTT, Sum(Del_SSTT)Del_SSTT, Sum(Trd_STT)Trd_STT, Sum(Total_STT)Total_STT
					From
							CAPS_STT_DATA
					WHERE
							Company_Code	=	'#cocd#'
					And		Mkt_Type		=	'#Mkt_Type#'
					And		Settlement_No	=	'#Settlement_No#'
					And		Client_ID		=	'#Client_ID#'
					And		Scrip_Symbol	=	'#Scrip_Symbol#'
					And		Record_Type		=	30
				</CFQUERY>

				<CFSET Scrip_Symbol1	=	"SH|#fileConvertString(Scrip_Symbol, 20, 'L', StringBlankVal)#">
				<CFLOOP QUERY="GetScripQty">
					<CFIF Buy_Quantity GT 0>
						<CFSET Scrip_Buy_Quantity	=	"#fileConvertString(Buy_Quantity, 20, 'L', IntegerBlankVal)#">
						<CFSET Scrip_Buy_Amount		=	"#fileConvertString(Buy_Amount, 20, 'L', IntegerBlankVal)#">
					<CFELSE>
						<CFSET Scrip_Buy_Quantity	=	"#fileConvertString('', 20, 'L', IntegerBlankVal)#">					
						<CFSET Scrip_Buy_Amount		=	"#fileConvertString('', 20, 'L', IntegerBlankVal)#">
					</CFIF>
					<CFIF Sale_Quantity GT 0>
						<CFSET Scrip_Sale_Quantity	=	"#fileConvertString(Sale_Quantity, 20, 'L', IntegerBlankVal)#">
						<CFSET Scrip_Sale_Amount	=	"#fileConvertString(Sale_Amount, 20, 'L', IntegerBlankVal)#">
					<CFELSE>
						<CFSET Scrip_Sale_Quantity	=	"#fileConvertString('', 20, 'L', IntegerBlankVal)#">
						<CFSET Scrip_Sale_Amount	=	"#fileConvertString('', 20, 'L', IntegerBlankVal)#">
					</CFIF>
					
					<CFIF	Net_Quantity neq 0>
						<CFSET Scrip_Net_Quantity	=	"#fileConvertString(Abs(Net_Quantity), 20, 'L', IntegerBlankVal)#">
					<CFELSE>
						<CFSET Scrip_Net_Quantity	=	"#fileConvertString('', 20, 'L', IntegerBlankVal)#">	
					</CFIF>	
					<CFIF 	Net_Quantity	LT	0>
						<CFSET	Scrip_NetQty_Type	=	"#fileConvertString("C", 1, 'L', StringBlankVal)#">
					<CFELSE>
						<CFSET	Scrip_NetQty_Type	=	"#fileConvertString("D", 1, 'L', StringBlankVal)#">
					</CFIF>
					<CFSET Scrip_Net_Amount		=	"#fileConvertString(Abs(Net_Amount), 20, 'L', IntegerBlankVal)#">
					<CFIF 	Net_Amount	LT	0>
						<CFSET	Scrip_NetAmt_Type	=	"#fileConvertString("C", 1, 'L', StringBlankVal)#">
					<CFELSE>
						<CFSET	Scrip_NetAmt_Type	=	"#fileConvertString("D", 1, 'L', StringBlankVal)#">
					</CFIF>
				</CFLOOP>
				<CFLOOP QUERY="GetScripSTT">
					<CFIF Total_STT NEQ "0">
						<CFSET	Total_STT1	=	Total_STT>
					<CFELSE> 
						<CFSET	Total_STT1	=	"">
					</CFIF>
					<CFIF Del_BSTT NEQ "0">
						<CFSET	Del_BSTT1	=	Del_BSTT>
					<CFELSE> 
						<CFSET	Del_BSTT1	=	"">
					</CFIF>
					<CFIF Del_SSTT NEQ "0">
						<CFSET	Del_SSTT1	=	Del_SSTT>
					<CFELSE> 
						<CFSET	Del_SSTT1	=	"">
					</CFIF>
					<CFIF Trim(Trd_STT) NEQ "0">
						<CFSET	Trd_STT1	=	Trd_STT>
					<CFELSE> 
						<CFSET	Trd_STT1	=	"">
					</CFIF>
					<CFSET Scrip_TotSTT		=	"#fileConvertString(Total_STT1, 20, 'L', IntegerBlankVal)#">
					<CFSET Scrip_DelBSTT	=	"#fileConvertString(Del_BSTT1, 20, 'L', IntegerBlankVal)#">
					<CFSET Scrip_DelSSTT	=	"#fileConvertString(Del_SSTT1, 20, 'L', IntegerBlankVal)#">
					<CFSET Scrip_TrdSTT		=	"#fileConvertString(Trd_STT1, 20, 'L', IntegerBlankVal)#">
				</CFLOOP>
				<CFSET	TradeCount	=	"#fileConvertString(TradeCount, 5, 'R', IntegerBlankVal)#">
				<CFSET	SH_DATA		=	"#SH_DATA##Scrip_Symbol1#|#Scrip_Buy_Quantity#|#Scrip_Buy_Amount#|#Scrip_Sale_Quantity#|#Scrip_Sale_Amount#|#Scrip_Net_Quantity#|#Scrip_NetQty_Type#|#Scrip_Net_Amount#|#Scrip_NetAmt_Type#|#Scrip_TotSTT#|#Scrip_DelBSTT#|#Scrip_DelSSTT#|#Scrip_TrdSTT#|#TradeCount##CHR(10)##TH_DATA#">
		</cfoutput>
			<cfquery name="GetDrCrAmt" dbtype="query">
				SELECT	SUM(BUY_AMOUNT)BUY_AMOUNT, SUM(SALE_AMOUNT)SALE_AMOUNT
				FROM
						GetTradeData
				WHERE
						Client_ID	=	'#Client_ID#'
			</cfquery>
			
			<cfquery name="GetExp" datasource="#Client.database#">
				SELECT	CAST(ST AS NUMERIC(30,2))ST, 
						CAST(STT AS NUMERIC(30,2))STT, 
						CAST(TOC AS NUMERIC(30,2))TOC, 
						CAST(FUTURES_EXP AS NUMERIC(30,2))FUTURES_EXP, 
						CAST(OPTIONS_EXP AS NUMERIC(30,2))OPTIONS_EXP, 
						CAST(STAMP_DUTY AS NUMERIC(30,2))STAMP_DUTY
				FROM
						TRADE_TO_ACCOUNTS
				WHERE
						COMPANY_CODE	=	'#COCD#'
				AND		MKT_TYPE		=	'#MKT_TYPE#'
				AND		SETTLEMENT_NO	=	#SETTLEMENT_NO#
				AND		CLIENT_ID		=	'#CLIENT_ID#'
			</cfquery>

			<CFSET ClientSrNo		=	IncrementValue(ClientSrNo)>
			<CFSET Client_ID1		=	"CH|#fileConvertString(Client_ID, 11, 'L', StringBlankVal)#">
			<CFSET Contract_No1		=	"#fileConvertString(Contract_No, 20, 'L', IntegerBlankVal)#">			
			<cfif MARKET EQ "FO">
				<CFSET Segment			=	"#fileConvertString("DR", 2, 'L', StringBlankVal)#">
				<CFSET SETTLEMENT_NO1	=	"#SETTLEMENT_NO#">
				<CFSET SETTLEMENT_NO1	=	"#fileConvertString(SETTLEMENT_NO1, 20, 'L', IntegerBlankVal)#">
				<CFSET TRADE_DATE1		=	"#fileConvertString(TRADE_DATE123, 10, 'L', StringBlankVal)#|#fileConvertString(TRADE_DATE123, 10, 'L', StringBlankVal)#">
				<CFSET TO_DATE1			=	"#fileConvertString(TRADE_DATE123, 10, 'L', StringBlankVal)#">
				<CFSET Funds_PayIn_Date1	=	"#fileConvertString(DATEFORMAT(BILL_DATE,'DD/MM/YYYY'), 10, 'L', StringBlankVal)#">
				<CFSET Funds_PayOut_Date1	=	"#fileConvertString(DATEFORMAT(BILL_DATE,'DD/MM/YYYY'), 10, 'L', StringBlankVal)#">
			<cfelse>
				<CFSET Segment			=	"#fileConvertString("EQ", 2, 'L', StringBlankVal)#">	
				<CFSET SETTLEMENT_NO1	=	"#Right(SETTLEMENT_NO,3)#/#FinStart##FinEnd#">
				<CFSET SETTLEMENT_NO1	=	"#fileConvertString(SETTLEMENT_NO1, 20, 'L', IntegerBlankVal)#">
				<CFSET TRADE_DATE1		=	"#fileConvertString(SettlementDetail.From_Date, 10, 'L', StringBlankVal)#|#fileConvertString(SettlementDetail.From_Date, 10, 'L', StringBlankVal)#">
				<CFSET TO_DATE1			=	"#fileConvertString(SettlementDetail.To_Date, 10, 'L', StringBlankVal)#">
				<CFSET Funds_PayIn_Date1	=	"#fileConvertString(SettlementDetail.Funds_PayIn_Date, 10, 'L', StringBlankVal)#">
				<CFSET Funds_PayOut_Date1	=	"#fileConvertString(SettlementDetail.Funds_PayOut_Date, 10, 'L', StringBlankVal)#">
			</cfif>
			<CFSET Exchange1		=	"#fileConvertString(Exchange, 3, 'L', StringBlankVal)#">
			<CFSET Broker_CMBP_ID1	=	"#fileConvertString(Broker_CMBP_ID, 18, 'L', StringBlankVal)#">
			<CFSET DP_ID1			=	"#fileConvertString(DP_ID, 20, 'L', StringBlankVal)#">

			<cfset	TotalDrAmt	=	0>
			<cfset	TotalCrAmt	=	0>
			<CFSET  GrossDrAmt  =	0> 
			<CFSET 	GrossCrAmt	=	0>
			<cfset	TotalDrAmt	=	GetDrCrAmt.BUY_AMOUNT>
			<cfset	TotalCrAmt	=	GetDrCrAmt.SALE_AMOUNT>
	
			<CFSET 	STT1		=	"#fileConvertString(GetExp.STT, 20, 'L', IntegerBlankVal)#">
			<CFSET 	ST1			=	"#fileConvertString(GetExp.ST, 20, 'L', IntegerBlankVal)#">
			<CFSET 	CHARGES		=	"STAMP DUTY=#fileConvertString(GetExp.STAMP_DUTY, 20, 'L', IntegerBlankVal)###TURNOVER TAX=#fileConvertString(GetExp.TOC, 20, 'L', IntegerBlankVal)###">
			<CFIF GetExp.FUTURES_EXP NEQ 0 OR GetExp.OPTIONS_EXP NEQ 0>
				<CFSET 	CHARGES	=	"#CHARGES#OTHER CHRGES=#fileConvertString((Val(GetExp.FUTURES_EXP)-Val(GetExp.OPTIONS_EXP)), 20, 'L', IntegerBlankVal)#">
			</CFIF>	
			
			<CFSET	GrossDrAmt1	=	"#fileConvertString(TotalDrAmt, 20, 'L', IntegerBlankVal)#">
			<CFSET	GrossCrAmt1	=	"#fileConvertString(TotalCrAmt, 20, 'L', IntegerBlankVal)#">
			<CFSET	GrossNetAmt	=	 TotalDrAmt - TotalCrAmt>
			<CFSET	GrossNetAmt1=	"#fileConvertString(Abs(GrossNetAmt), 20, 'L', IntegerBlankVal)#">
			<CFIF 	GrossNetAmt	LT	0>
				<CFSET	GrossNetAmtType	=	"#fileConvertString("C", 1, 'L', StringBlankVal)#">
			<CFELSE>
				<CFSET	GrossNetAmtType	=	"#fileConvertString("D", 1, 'L', StringBlankVal)#">
			</CFIF>

			<cfset	TotalDrAmt	=	TotalDrAmt + GetExp.ST + GetExp.STT + GetExp.STAMP_DUTY + GetExp.TOC + GetExp.FUTURES_EXP>
			<CFSET	TotalNetAmt	=	TotalDrAmt - TotalCrAmt>
			<CFSET	TotalDrAmt1	=	"#fileConvertString(TotalDrAmt, 20, 'L', IntegerBlankVal)#">
			<CFSET	TotalCrAmt1	=	"#fileConvertString(TotalCrAmt, 20, 'L', IntegerBlankVal)#">
			
			<CFSET	TotalNetAmt1=	"#fileConvertString(Abs(TotalNetAmt), 20, 'L', IntegerBlankVal)#">
			<CFIF 	TotalNetAmt	LT	0>
				<CFSET	TotalNetAmtType	=	"#fileConvertString("C", 1, 'L', IntegerBlankVal)#">
			<CFELSE>
				<CFSET	TotalNetAmtType	=	"#fileConvertString("D", 1, 'L', IntegerBlankVal)#">
			</CFIF>

			<CFSET	Scrip_Count	=	ScripSrNo>  
			<!--- "#fileConvertString(GetScripCount.RecordCount, 1, 'L', StringBlankVal)#" --->
			<CFSET	CH_DATA	=	"#CH_DATA##Client_ID1#|#Contract_No1#|#SETTLEMENT_NO1#|#TRADE_DATE1#|#TO_DATE1#|#Funds_PayIn_Date1#|#Funds_PayOut_Date1#|#Segment#|#Exchange1#|#Broker_CMBP_ID1#|#DP_ID1#|#STT1#|#ST1#|#CHARGES#|#GrossDrAmt1#|#GrossCrAmt1#|#GrossNetAmt1#|#GrossNetAmtType#|#TotalDrAmt1#|#TotalCrAmt1#|#TotalNetAmt1#|#TotalNetAmtType#|#Scrip_Count##CHR(10)#">
			<CFSET	FILE_DATA	=	"#FILE_DATA##CH_DATA##SH_DATA#">
			<CFSET	CH_DATA	=	"">
			<CFSET	SH_DATA	=	"">
			<CFSET	TH_DATA	=	"">
			<!--- <CFSET	ClientSrNo	=	IncrementValue(ClientSrNo)> --->
	</CFOUTPUT>		


		<cfset	BHDATA	=	"BECN#CHR(10)#BH|#fileConvertString( Register_Id, 4, 'L', IntegerBlankVal)#|#fileConvertString( DateInYYMMDD, 5, 'R', IntegerBlankVal)##Trim(GenerationNo)#|#fileConvertString( ClientSrNo, 5, 'R', IntegerBlankVal)#">
		
		<cffile action="write" file="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#BHDATA#" addnewline="yes">
		<!--- <cfset	FILE_DATA	=	"#FILE_HEADER_DATA##FILE_DATA##CHR(10)#19#CHR(10)#{}"> --->
		<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#EECN" addnewline="yes">

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
