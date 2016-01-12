<!--- <!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>Untitled Document</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<STYLE>
Select, Input
{
	font: 9pt Tahoma;
}
Pre
{
	color: Red;
	font: 9pt Tahoma;
}
</STYLE>
	<LINK HREF="../../CSS/DynamicCSS.css" TYPE="text/css" REL="stylesheet">
	<LINK HREF="../../CSS/Bill.css" TYPE="text/css" REL="stylesheet">
</HEAD>

<BODY CLASS="StyleBody1">
<CENTER> --->
<CFINCLUDE TEMPLATE="../../Common/Export_Text_File.cfm">
	<CFSET finstyr = "#FinStart#">
	<CFSET finendyr = "#FinEnd#">
	
<!---<H4>-:&nbsp;<u>STP File Generation</u>&nbsp;:-</H4>
 <CFFORM ACTION="STP_FILE_GENERATION.cfm" METHOD="POST" ENABLECAB="No" PRESERVEDATA="Yes">

<CFOUTPUT>
	<INPUT TYPE="Hidden" NAME="COCD" VALUE="#COCD#">
	<INPUT TYPE="Hidden" NAME="COName" VALUE="#COName#">
	<INPUT TYPE="Hidden" NAME="Market" VALUE="#Market#">
	<INPUT TYPE="Hidden" NAME="Exchange" VALUE="#Exchange#">
	<INPUT TYPE="Hidden" NAME="Broker" VALUE="#Broker#">
	<INPUT TYPE="Hidden" NAME="FinStart" VALUE="#Val(Trim(FinStart))#">
	<INPUT TYPE="Hidden" NAME="FinEnd" VALUE="#Val(Trim(FinEnd))#">


  <CFQUERY NAME="MarketType" datasource="#Client.database#" DBTYPE="ODBC">
  	Select Mkt_Type from Market_Type_Master
	Where Exchange = '#Exchange#'
	and market = '#market#'
	Order By Nature Desc
  </CFQUERY>
  
  <CFQUERY NAME="LastSettlement" datasource="#Client.database#" DBTYPE="ODBC">
	Select 	TOP 1 SETTLEMENT_NO, convert(varchar(10), max(trade_date), 103)trade_date
	From	TRADE1
	Where
		COMPANY_CODE	=  '#Trim(COCD)#'
	And	MKT_TYPE		=  '#MarketType.Mkt_Type#'
	GROUP BY TRADE_DATE, SETTLEMENT_NO
	Having max(trade_date) = TRADE_DATE 	
	Order By SETTLEMENT_NO Desc
  </CFQUERY>

<TABLE STYLE="font:Tahoma;">
	<TR>
		<TH ALIGN="LEFT">Market Type</TH>
		<TH>&nbsp;:&nbsp;</TH>
		<TD>
			<CFSELECT NAME="Mkt_Type" QUERY="MarketType" VALUE="Mkt_Type" DISPLAY="Mkt_Type" REQUIRED="Yes">
			</CFSELECT>
  		</TD>
	</TR>
	<TR>
		<TH ALIGN="LEFT">Settlement No</TH>
		<TH>&nbsp;:&nbsp;</TH>
		<TD>
			  <CFINPUT TYPE="Text" NAME="Settlement_No" VALUE="#LastSettlement.SETTLEMENT_NO#" CLASS="" MESSAGE="Enter valid Settlement No." VALIDATE="integer" REQUIRED="Yes" SIZE="8" MAXLENGTH="10">
  		</TD>
	</TR>
	<TR>
		<TH ALIGN="LEFT">Trade Date</TH>
		<TH>&nbsp;:&nbsp;</TH>
		<TD>
			  <CFINPUT TYPE="Text" NAME="Trade_date" MESSAGE="Enter valid Date." CLASS="" VALUE="#LastSettlement.trade_date#" VALIDATE="eurodate" REQUIRED="Yes" SIZE="11" MAXLENGTH="10">
  		</TD>
	</TR>
	<TR>
		<TH ALIGN="LEFT">Institution Code</TH>
		<TH>&nbsp;:&nbsp;</TH>
		<TD>
			  <CFINPUT TYPE="Text" NAME="Client_ID" MESSAGE="Enter Institution Code." REQUIRED="YES" CLASS="" SIZE="10" MAXLENGTH="20">
  		</TD>
	</TR>
	<TR>
		<TH ALIGN="LEFT">Scrip Code</TH>
		<TH>&nbsp;:&nbsp;</TH>
		<TD>
		    <CFINPUT TYPE="Text" NAME="Scrip_Symbol" MESSAGE="Enter Scrip Code." REQUIRED="No" CLASS="" SIZE="10" MAXLENGTH="20">
  		</TD>
	</TR>
	<TR>
		<TH ALIGN="LEFT">Order No</TH>
		<TH>&nbsp;:&nbsp;</TH>
		<TD>
		    <CFINPUT TYPE="Text" NAME="Contract_No" REQUIRED="No" CLASS="" SIZE="20" MAXLENGTH="30">
  		</TD>
	</TR>
	<TR>
		<TD COLSPAN="3">
	      <INPUT TYPE="submit" NAME="CmdGenerate" VALUE="Generate" CLASS="StyleSmallButton1">
  		</TD>
	</TR>
</TABLE>
</CFOUTPUT>

<CFIF IsDefined("CmdGenerate")> --->
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
		SELECT	Sebi_Reg_No, Company_Name, Exchange_Mapin
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

	
	<!--- <CFQUERY NAME="GetBatchNo" datasource="#Client.database#">
		Select	IsNull(Batch_No, 1) BatchNo
		FROM	
				ECN_ClientData
		WHERE
				COMPANY_CODE	=	'#COCD#'
		AND		MKT_TYPE		=	'#MKT_TYPE#'
		AND		SETTLEMENT_NO	=	#SETTLEMENT_NO#
		AND		CLIENT_ID		=	'#CLIENT_ID#'
	</CFQUERY>
	
	<cfset	GenerationNo	=	"1">
	
	<CFIF	GetBatchNo.RecordCount	EQ	0>
		<CFQUERY NAME="GetBatchNo" datasource="#Client.database#">
			Select	(IsNull(Batch_No, 1) + 1) BatchNo
			FROM	
					ECN_ClientData
			WHERE
					COMPANY_CODE	=	'#COCD#'
			AND		MKT_TYPE		=	'#MKT_TYPE#'
			AND		SETTLEMENT_NO	=	#SETTLEMENT_NO#
		</CFQUERY>

		<CFIF	GetBatchNo.RecordCount	EQ	0>
			<cfset	GenerationNo	=	"1">
		<CFELSE>
			<cfset	GenerationNo	=	GetBatchNo.BatchNo>
		</CFIF>

		<CFQUERY NAME="InsertBatch" datasource="#Client.database#">
			Insert into ECN_ClientData
			(
				Company_Code, Mkt_Type, Settlement_No, Client_ID, Batch_No
			)
			Values
			(
				'#COCD#', '#MKT_TYPE#', #SETTLEMENT_NO#, '#CLIENT_ID#', #Val(GenerationNo)#
			)
		</CFQUERY>
	</CFIF> --->
	
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
	
	
	<CFIF	Mkt_Type	EQ	"N">
		<CFSET	Mkt_Type_Text	=	"DR">
	<CFELSEIF	Mkt_Type	EQ	"T">
		<CFSET	Mkt_Type_Text	=	"TT">
	<CFELSEIF	Mkt_Type	EQ	"A">
		<CFSET	Mkt_Type_Text	=	"AR">
	</CFIF>
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
		

		<CFSET CONTRACT_DATA = "">
		
		<CFFILE ACTION="Write" FILE="#File_Name#" OUTPUT="{IFN515}{#Broker_Sebi_RegnNo#}{#Unique_Cl_ID1#}"ADDNEWLINE="Yes">   <!--- {#Unique_Cl_ID1#} Changed for Eureka--->
		<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="{" ADDNEWLINE="Yes">
		<CFLOOP QUERY="ContData">

			<CFSET	CHANGED_TRADE_NO	=	"#RepeatString("0", (16 - Len(TRADE_NUMBER)))##TRADE_NUMBER#">
			<CFSET	CHANGED_ORDER_NO	=	"#RepeatString("0", (16 - Len(ORDER_NO)))##ORDER_NO#">
			
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
					
					<CFSET	RATE	=	Replace(Trim(NumberFormat(BRATE1,"99999999." & DecimalVal)),".",",")>
					<CFSET	BRK		=	Replace(Trim(NumberFormat(BBRK1,"99999999.99")),".",",")>
					<CFSET	NetRATE	=	Replace(Trim(NumberFormat(BNetRATE1,"99999999." & DecimalVal)),".",",")>
					
					<CFSET	TOTBrk	=	Replace(Trim(NumberFormat(BQTY * BBRK1,"99999999.99")),".",",")>
					<CFSET	AMT		=	Trim(NumberFormat(BQTY * BNetRATE1,"99999999.99"))>
					<CFSET	Actual_Amt	=	Replace(Trim(NumberFormat(BQTY * BRATE1,"99999999.99")),".",",")>

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
					<CFSET	STT		=	Replace(Trim(NumberFormat(STT, "99999999")),".",",")>
					<CFSET  AMT		=	REPLACE(NumberFormat(AMT1,"99999999999.99"),".",",")>
					
				<CFELSE>
					<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
					<CFSET	QTY		=	SQTY>
					<CFSET	SRATE1	=	SRATE>
					<CFSET	SBRK1	=	SBRK>
					<CFSET	SNetRATE1	=	SNetRATE>
					
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
					
					<CFSET	RATE	=	Replace(Trim(NumberFormat(SRATE1,"99999999." & DecimalVal)),".",",")>
					<CFSET	BRK		=	Replace(Trim(NumberFormat(SBRK1,"99999999." & DecimalVal)),".",",")>
					<CFSET	TOTBrk	=	Replace(Trim(NumberFormat(SQTY * SBRK1,"99999999.99")),".",",")>
					<CFSET	NetRATE	=	Replace(Trim(NumberFormat(SNetRATE1,"99999999." & DecimalVal)),".",",")>
					<CFSET	Actual_Amt	=	Replace(Trim(NumberFormat(SQTY * SRATE1,"99999999.99")),".",",")>
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
					<CFSET	STT		=	Replace(Trim(NumberFormat(STT, "99999999")),".",",")>
					<CFSET  AMT     =   REPLACE(NumberFormat(AMT1,"99999999999.99"),".",",")>  
				</CFIF>
				

			<!--- Start Block A --->
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
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":92A::CORA//#RatePlusBrk##Brk#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":94B::TRAD//EXCH/#Exchange_Mapin#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":22H::BUSE//#BUY_SALE#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":22H::PAYM//FREE" ADDNEWLINE="Yes">

				<!--- Start Mandatory Sub Block C1 (Confirmation Parties)	 --->
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:CONFPRTY" ADDNEWLINE="Yes">	
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::INVE//#Unique_Cl_ID1#" ADDNEWLINE="Yes">	
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":97A::SAFE//#Client_Sebi_RegnNo1#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:CONFPRTY" ADDNEWLINE="Yes">			
				<!--- End Mandatory Sub Block C1 (Confirmation Parties) --->		

					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":36B::CONF//UNIT/#QTY#," ADDNEWLINE="Yes">			
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":35B:ISIN #ISIN#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#SCRIP_NAME#" ADDNEWLINE="Yes">
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70E::TPRO//#Mkt_Type_Text#/#SetlNo#" ADDNEWLINE="Yes">
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
					<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":19A::TRAX//0,0000" ADDNEWLINE="Yes">					
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
			
			<!--- <!--- Start Optional Sequence E (Other Parties) --->

				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16R:OTHRPRTY" ADDNEWLINE="Yes">										
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":95Q::EXCH//ORDER DETAILS" ADDNEWLINE="Yes">										
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":70D::PART//#REPLACE(CHANGED_TRADE_NO,'M','')#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#QTY#," ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#RATE#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="#TRIM(TRADEDATE1)# #REPLACE(TIMEFORMAT(TRADE_DATETIME,"HH:MM:SS"),':','',"ALL")#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":20C::PROC//#CHANGED_ORDER_NO#" ADDNEWLINE="Yes">
				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT=":16S:OTHRPRTY" ADDNEWLINE="Yes"> --->

 				<CFFILE ACTION="APPEND" FILE="#File_Name#" OUTPUT="-}" ADDNEWLINE="No">
			<!--- End Optional Sequence E (Other Parties)	 --->		
		</CFLOOP>
	</CFLOOP>	
	
	<SCRIPT>
		alert("File Has Been Generated On #Replace(File_Name,'\','\\','all')#.");
	</SCRIPT>

	</CFOUTPUT>


