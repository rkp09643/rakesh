<LINK HREF="../../CSS/DynamicCSS.css" REL="stylesheet" TYPE="text/css">
<CFOUTPUT>	

<script>

function BtnGenerate(val1)
{
	with (ScrOrd)
	{
		
		if (val1 == "")
		{
		  ScrOrd.Generate.disabled = true;	
		}
		else if (ExchangeClearingCode1.value == "" )
		{
			 ScrOrd.Generate.disabled = true;	
		}
		else if (BrokerSebiRegnNo1.value == "" )
		{
			 ScrOrd.Generate.disabled = true;	
		}
		else if (ClientSebiRegNo1.value == "")
		{
			 ScrOrd.Generate.disabled = true;	
		}
		else if (ExchangeMapIns1.value == "")
		{
			ScrOrd.Generate.disabled = true;	
		}
		else
		{
			ScrOrd.Generate.disabled = false;	
		 } 
	}	 
	
/*	<cfif IsDefined("Exchange_Clearing_Code") and Trim(Exchange_Clearing_Code) EQ  "">
			ScrOrd.Generate.disabled = true;
	<cfelseif IsDefined("BrokerSebiRegnNo") and Trim(BrokerSebiRegnNo) EQ  "" >
			ScrOrd.Generate.disabled = true;
	<cfelseif IsDefined("ExchangeMapIns") and Trim(ExchangeMapIns) EQ  "" >
			ScrOrd.Generate.disabled = true;
	<cfelseif IsDefined("ClientSebiRegNo") and Trim(ClientSebiRegNo) EQ  "" >
			ScrOrd.Generate.disabled = true;
	<cfelseif  IsDefined("UniqueClientId") and Trim(UniqueClientId) EQ  "" >
			ScrOrd.Generate.disabled = true;
	</cfif>
*/	
}

</script>

<CFSET Client_ID ="#txtClientID#">
<CFSET Settlement_No ="#txtSetlId#">
<CFSET Trade_Date = "#txtOrderDate#">


	<CFQUERY NAME="GetClient" datasource="#Client.database#">
		SELECT	
				distinct A.CLIENT_ID, A.CONTRACT_NO, 
				CONVERT(CHAR(10), TRADE_DATE,112) Trade_Date_YearFormat
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
		SELECT	Client_SebiRegnNo, Unique_Cl_ID,Client_Name
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
	
	<!---<CFQUERY NAME="GetSTTDetail" datasource="#Client.database#">
		SELECT	CASE WHEN CAPS_BUY_SALE	=	'B' Then STT Else 0 End As BSTT,
				CASE WHEN CAPS_BUY_SALE	=	'S' Then STT Else 0 End As SSTT
		FROM
				STT_DETAILS
		WHERE
				COMPANY_CODE = '#COCD#'
		AND  	CONVERT(DATETIME, FROM_DATE, 103) <= CONVERT(DATETIME, '#TRADE_DATE#', 103)
		AND  	CONVERT(DATETIME, ISNULL(TO_DATE, CONVERT(DATETIME, '#TRADE_DATE#', 103)), 103) >= CONVERT(DATETIME, '#TRADE_DATE#', 103)
		AND		CAPS_TRADE_TYPE	=	'D'
	</CFQUERY>---->
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

	<CFIF NOT DIRECTORYEXISTS("C:\STPFILES\")>
		<CFDIRECTORY action="create" directory="C:\STPFILES\">
	</CFIF>
	
	<CFLOOP QUERY="GetClient">
			<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#txtScrip#">	
			<CFSET	SCRIP_SYMBOL_ORDER_NO	=	"#txtContractNo#">	
			<CFSET	OnlyFileName	=	"#MKT_TYPE#_#SETTLEMENT_NO#_#CLIENT_ID#_#SCRIP_SYMBOL_ORDER_NO#.txt">

			<CFSET	File_Name	=	"C:\STPFILES\#OnlyFileName#">
			<CFSET	TradeDate1	=	"#GetClient.Trade_Date_YearFormat#">
			<CFSET	PayINDate	=	"#GetSetlDate.Funds_Payin_Date#">
			<!----<cfset	BatchNo		=	"#GetClient.Trade_Date_YearFormat##RepeatString("0", (3 - Len(GenerationNo)))##GenerationNo#">----->
			<CFSET	Broker_Sebi_RegnNo			=	GetCompanyDetail.Sebi_Reg_No>
			<CFSET	Exchange_Mapin				=	GetCompanyDetail.Exchange_Mapin>
			<CFSET	Exchange_Clearing_Code		=	GetSystemDetail.Exchange_Clearing_Code>
			<CFSET	ClientList_STTNotApplied	=	GetSystemDetail.ClientList_STTNotApplied>
			<CFSET	Client_Sebi_RegnNo1			=	GetClientDetail.Client_SebiRegnNo>
			<CFSET	Unique_Cl_ID1				=	GetClientDetail.Unique_Cl_ID>
			<CFSET	BOISL_NO					=	100002303>
			
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
			<CFPROCPARAM TYPE="in" CFSQLTYPE="cf_sql_varchar" DBVARNAME="@Contra" VALUE="SINGLE" NULL="no">
			<CFPROCRESULT NAME="ContData">
		</CFSTOREDPROC>
		<CFSET CONTRACT_DATA = "">
		
		<cfset i = 1>
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
			<CFELSE>
				<CFSET TYPEFOREXCHANGE = "23">				
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
					<cfset	BRKDECIMAL	=	4>
			<cfelse>		
					<cfset	DecimalVal	=	99>
					<cfset	BRKDECIMAL	=	2>
			</cfif>
			
			<cfinclude template="STP_Buy_Sale_Logic.cfm">
			<!--- <CFIF	BQTY	GT	0>
					<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
					<CFSET	QTY		=	BQTY>
					<CFSET	RATE	=	Replace(Trim(NumberFormat(BRATE,"99999999.9999")),".",".")>
					<CFSET	BRK		=	Replace(Trim(NumberFormat(BBRK,"99999999.9999")),".",".")>
					<CFSET	TOTBrk	=	Replace(Trim(NumberFormat(BQTY * BBRK,"99999999.9999")),".",".")>
					<CFSET	NetRATE	=	Replace(Trim(NumberFormat(BNetRATE,"99999999.9999")),".",".")>
					<CFSET	AMT		=	Trim(NumberFormat(BAMT,"99999999.9999"))>
					<CFSET	Actual_Amt	=	Replace(Trim(NumberFormat(BQTY * BRATE,"99999999.9999")),".",".")>
					<CFSET	BUY_SALE	=	"BUYI">
					<CFSET	BUY_SALE2	=	"SELL">
					<CFSET	BUY_SALE3	=	"DEAG">
					<CFSET	RatePlusBrk	=	"+">
					<CFIF	APPLY_STT>
						<CFSET	STT	=	((BQTY * BRATE * BSTT) / 100)>
					<CFELSE>
						<CFSET	STT	=	0>
					</CFIF>
					<CFSET	AMT1		=	Trim((BAMT + NumberFormat(STT, "99999999")))>
					<CFSET	STT		=	Replace(Trim(NumberFormat(STT, "99999999")),".",".")>
					<CFSET  AMT		=	REPLACE(NumberFormat(AMT1,"99999999999.9999"),".",".")>
				<CFELSE>
					<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
					<CFSET	QTY		=	SQTY>
					<CFSET	RATE	=	Replace(Trim(NumberFormat(SRATE,"99999999.9999")),".",".")>
					<CFSET	BRK		=	Replace(Trim(NumberFormat(SBRK,"99999999.9999")),".",".")>
					<CFSET	TOTBrk	=	Replace(Trim(NumberFormat(SQTY * SBRK,"99999999.9999")),".",".")>
					<CFSET	NetRATE	=	Replace(Trim(NumberFormat(SNetRATE,"99999999.9999")),".",".")>
					<CFSET	Actual_Amt	=	Replace(Trim(NumberFormat(SQTY * SRATE,"99999999.9999")),".",".")>
					<CFSET	BUY_SALE	=	"SELL">
					<CFSET	BUY_SALE2	=	"BUYR">
					<CFSET	BUY_SALE3	=	"REAG">
					<CFSET	RatePlusBrk	=	"+">
					<CFIF	APPLY_STT>
						<CFSET	STT	=	((SQTY * SRATE * SSTT) / 100)>
					<CFELSE>
						<CFSET	STT	=	0>
					</CFIF>
					<CFSET	AMT1	=	Trim((SAMT - NumberFormat(STT, "99999999")))>
					<CFSET	STT		=	Replace(Trim(NumberFormat(STT, "99999999")),".",".")>
					<CFSET  AMT     =   REPLACE(NumberFormat(AMT1,"99999999999.9999"),".",".")>  
		  </CFIF> --->
				<CFSET	CONTRACT_DATA	=	"#CONTRACT_DATA#:16R:GENL#CHR(10)#">

				<tr>
						<td WIDTH="17%"  CLASS="StyleTable">Client Code :</td>
						<td WIDTH="*" ALIGN="LEFT">&nbsp;#Client_Id#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Client Name :</td>
						<td WIDTH="*" ALIGN="LEFT" >&nbsp;#Client_Name#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Order No :</td>
						<td WIDTH="*" ALIGN="LEFT" COLSPAN="3">&nbsp;#Order_No#</td>
				<tr>
						<td WIDTH="17%"  CLASS="StyleTable">Scrip Code :</td>
						<td WIDTH="*" ALIGN="LEFT">&nbsp;#txtScrip#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Scrip Name :</td>
						<td WIDTH="*" ALIGN="LEFT">&nbsp;#left(SCRIP_NAME,20)#</td>
						<td WIDTH="17%"  CLASS="StyleTable">ISIN :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#ISIN#</td>
				</tr>
				<tr>
						<td WIDTH="17%"  CLASS="StyleTable">Contract Notes :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#Contract_Note_Text#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Trade Date :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#TradeDate1#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Pay In Date :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#PAYINDATE#</td>
				</tr>
				<tr>
						<td WIDTH="17%"  CLASS="StyleTable">Settlement No :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#Right(Settlement_No,3)#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Year :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#FinStart#</td>
						<td WIDTH="17%"  CLASS="StyleTable"  <cfif Trim(Exchange_Clearing_Code) EQ "">style="color:red"</cfif>>Exchange_Clearing_Code :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#Exchange_Clearing_Code#</td>

				</tr>
				
				
				<tr>
						<td WIDTH="17%"  CLASS="StyleTable">Buy/Sale :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#BUY_SALE#</td>
						<td WIDTH="17%"  CLASS="StyleTable">QTY :</td>
						<td WIDTH="*" ALIGN="LEFT">&nbsp;#QTY#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Rate :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#RATE#</td>
				</tr>
				<tr>
						<td WIDTH="17%"  CLASS="StyleTable">Brokerage :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#RatePlusBrk##Brk#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Total Brk :</td>
						<td WIDTH="*" ALIGN="LEFT">&nbsp;#TotBrk#</td>
						<td WIDTH="17%"  CLASS="StyleTable">STT :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#STT#</td>
				</tr>
				
				
				<tr>
						<td WIDTH="17%"  CLASS="StyleTable">Actual Amount :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#ACTUAL_AMT#</td>
						<td WIDTH="17%"  CLASS="StyleTable">Total AMT :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#AMT#</td>
						<td WIDTH="17%"  CLASS="StyleTable"  <cfif Trim(Broker_Sebi_RegnNo) EQ "">style="color:red"</cfif>>Broker Sebi RegnNo :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#Broker_Sebi_RegnNo#</td>
						<cfset BrokerSebiRegnNo = #Broker_Sebi_RegnNo# >
						
				</tr>
				<tr>
						<td WIDTH="17%"  CLASS="StyleTable">BoISL NO :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#BOISL_NO#</td>
						<td WIDTH="17%"  CLASS="StyleTable"  <cfif Trim(Exchange_Mapin) EQ "">style="color:red"</cfif>>Exchange MapIns :</td>
						<td WIDTH="*" ALIGN="LEFT">&nbsp;#Exchange_Mapin#</td>
						<td WIDTH="17%"  CLASS="StyleTable">CHANGED TRADENO :</td>
						<td WIDTH="*" ALIGN="LEFT">&nbsp;#REPLACE(CHANGED_TRADE_NO,'M','')#</td>
						
						<cfset ExchangeMapIns = #Exchange_Mapin# >
						
				</tr>
				<tr>
					    <INPUT TYPE="HIDDEN" NAME="DummyCol" VALUE="">
						<cfset Help = "Select CustodianCode,CustodianName from CustodianMaster">
						<td WIDTH="17%"  CLASS="StyleTable" <cfif Trim(Unique_Cl_ID1) EQ "">style="color:red"</cfif> style="cursor:help " 
		     			onDblClick = "HelpWindow = open( '../../HelpSearch/Client_Help.cfm?Object_Name=UNIQUECLCODE&Sql=UniqueClientId&HELP_RETURN_INPUT_TYPE=RADIO&COL2=DummyCol&ClientId=#Client_Id#','HelpWindow', 'width=600, height=500, scrollbar=no,top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=yes, resizeable=no' );">
						Unique Client Id :</td>
						<td WIDTH="17%" ALIGN="LEFT" >&nbsp;
							<input type="text" name="UNIQUECLCODE" value="#Unique_Cl_ID1#" size="15" maxlength="10" class="StyleTextBox" onBlur="BtnGenerate(this.value)">
						</td>
						<cfset i = i + 1>
						<td WIDTH="17%"  CLASS="StyleTable" <cfif Trim(Client_Sebi_RegnNo1) EQ "">style="color:red"</cfif>>Client Sebi Reg No :</td>
						<td WIDTH="*" ALIGN="LEFT">&nbsp;#Client_Sebi_RegnNo1#</td>
						<cfset ClientSebiRegNo = #Client_Sebi_RegnNo1# >
						<cfset UniqueClientId = #Unique_Cl_ID1#>
						<td WIDTH="17%"  CLASS="StyleTable">BATCH NO :</td>
						<td WIDTH="17%" ALIGN="LEFT">&nbsp;#BATCHNUMBER#</td>
				</tr>
	
	
				<CFQUERY NAME="GetOrderTradesDetail" datasource="#Client.database#">
					SELECT	
							RTRIM(A.CLIENT_ID) CLIENT_ID, IsNull(SYSTEM_IMPORT_IP,'N') SYSTEM_IMPORT_IP,
							IsNull(Client_Name,'')Client_Name,
							ORDER_NUMBER, USER_ID USER_ID,
							Convert(VarChar(10), ORDER_DATETIME, 108) ORDER_TIME, SCRIP_SYMBOL, BUY_SALE, 
							ISNULL( QUANTITY , 0) Quantity,
							ISNULL( TRADE_NUMBER , 0) TRADE_NUMBER,
							TRADE_DATETIME,
							Price_Premium,
							CASE WHEN BUY_SALE = 'BUY' THEN 
									cast(DELIVERY_BROKERAGE AS NUMERIC(10,4))
							ELSE 
										-cast(DELIVERY_BROKERAGE AS NUMERIC(10,4))
							END AS DELIVERY_BROKRAGE,
							CASE WHEN BUY_SALE = 'BUY' THEN 
									cast( QUANTITY*(ISNULL(DELIVERY_BROKERAGE,0)+ISNULL(Price_Premium,0)) AS NUMERIC(30,4)) 
							ELSE 
										cast( QUANTITY*(ISNULL(Price_Premium,0)-ISNULL(DELIVERY_BROKERAGE,0)) AS NUMERIC(30,4)) 
							END AS AMOUNT
			
					FROM	
							TRADE1 A LEFT OUTER JOIN Client_Master B
					ON
							A.Client_ID		=	B.Client_ID
					And		A.Company_Code	=	B.Company_Code
					WHERE	    
							A.COMPANY_CODE		=  '#COCD#'
					AND		Convert(DateTime, Trade_Date, 103)	=	Convert(DateTime, '#txtOrderDate#', 103)
					AND		A.Client_ID			!=	'#ClearingMemberCode#'
					AND		IsNull(ORDER_NUMBER,'')		Not Like 'ND%'
					AND		Mkt_Type			In	('N','T','H','H2')
					AND		Client_Nature		= 'I'		
					<CFIF IsDefined("txtClientID") And Trim(txtClientID) is not "">
						<CFIF txtClientID neq 'ALL'>
							AND		A.Client_ID			=	'#txtClientID#'
						</CFIF>
					</CFIF>
					<CFIF IsDefined("txtScrip") And Trim(txtScrip) is not "">
						<CFIF txtScrip neq 'ALL'>
							AND		Scrip_Symbol		Like	'#txtScrip#%'
						</CFIF>
					</CFIF>
					<cfif isdefined("CONTRACT_NO") and Trim(CONTRACT_NO) is not "">
						AND CONTRACT_NO = '#CONTRACT_NO#'
					</cfif>
					<!---<CFIF IsDefined("txtContractNo") And Trim(txtContractNo) is not "" And Trim(txtContractNo) neq "None">
						<CFIF txtContractNo neq 'ALL'>
							AND		IsNull(ORDER_NUMBER,'')		= '#Trim(Order_No)#'
						</CFIF>
					</CFIF>--->
					Order By
						User_ID, SCRIP_SYMBOL,ORDER_NUMBER, BUY_SALE, A.CLIENT_ID
				</CFQUERY>
				<tr HEIGHT="22" >
					<TD WIDTH="*" COLSPAN="6" ALIGN="CENTER" CLASS="StyleBody11">Trade Detail</td>
				</tr>
				<tr CLASS="StyleTable">
					<td WIDTH="17%">Trade No</td>
					<td WIDTH="17%">Trade Time</td>
					<td WIDTH="17%"  ALIGN="RIGHT">Quantity</td>
					<td WIDTH="17%"  ALIGN="RIGHT">Rate</td>
					<td WIDTH="17%"  ALIGN="RIGHT">Brokerage</td>
					<td WIDTH="17%"  ALIGN="RIGHT">Amount</td>
				</tr>


				<CFLOOP QUERY="GetOrderTradesDetail">
					<tr>
						<td WIDTH="17%">#TRADE_NUMBER#</td>
						<td WIDTH="17%">#TIMEFORMAT(TRADE_DATETIME,'HH:MM:SS')#</td>
						<td WIDTH="17%" ALIGN="RIGHT">#Quantity#</td>
						<td WIDTH="17%" ALIGN="RIGHT">#Price_Premium#</td>
						<td WIDTH="17%" ALIGN="RIGHT">#DELIVERY_BROKRAGE#</td>
						<td WIDTH="17%" ALIGN="RIGHT">#AMOUNT#</td>
					</tr>
				</CFLOOP>
				<tr>
					<td WIDTH="100%" COLSPAN="6">&nbsp;</td>
				</tr>
	</CFLOOP>	
</CFLOOP>


<script>

	<cfif IsDefined("Exchange_Clearing_Code") and Trim(Exchange_Clearing_Code) EQ  "">
			ScrOrd.Generate.disabled = true;
			ScrOrd.ExchangeClearingCode1.value = "";
	<cfelse>
			ScrOrd.ExchangeClearingCode1.value = '#Exchange_Clearing_Code#';
	</cfif>
			
	<cfif IsDefined("BrokerSebiRegnNo") and Trim(BrokerSebiRegnNo) EQ  "" >
			ScrOrd.Generate.disabled = true;
			ScrOrd.BrokerSebiRegnNo1.value	   = "";
	<cfelse>		
			ScrOrd.BrokerSebiRegnNo1.value	   = '#BrokerSebiRegnNo#';
	</cfif>		
			
	<cfif IsDefined("ExchangeMapIns") and Trim(ExchangeMapIns) EQ  "" >
			ScrOrd.Generate.disabled = true;
			ScrOrd.ExchangeMapIns1.value	   = "";
	<cfelse>
			ScrOrd.ExchangeMapIns1.value	   = '#ExchangeMapIns#';
	</cfif>		
	
	<cfif IsDefined("ClientSebiRegNo") and Trim(ClientSebiRegNo) EQ  "" >
			ScrOrd.Generate.disabled = true;
			ScrOrd.ClientSebiRegNo1.value	   = "";
	<cfelse>
			ScrOrd.ClientSebiRegNo1.value	   = '#ClientSebiRegNo#';
	</cfif>		
	
	<cfif  IsDefined("UniqueClientId") and Trim(UniqueClientId) EQ  "" >
			ScrOrd.Generate.disabled = true;
			ScrOrd.UniqueClientId1.value	   = "";
	<cfelse>
			ScrOrd.UniqueClientId1.value	   = '#UniqueClientId#';
	</cfif>		
	
</script>	
	
</CFOUTPUT>


