<LINK HREF="../../CSS/DynamicCSS.css" REL="stylesheet" TYPE="text/css">
<CFOUTPUT>	
<CFSET Client_ID ="#txtClientID#">
<CFSET Settlement_No ="#txtSetlId#">
<CFSET Trade_Date = "#txtOrderDate#">
<CFINCLUDE TEMPLATE="../../Common/Export_Text_File.cfm"> 
	<CFQUERY NAME="GetClient" datasource="#Client.database#">
		SELECT	
				distinct A.CLIENT_ID, A.CONTRACT_NO, 
				CONVERT(CHAR(10), TRADE_DATE,112) Trade_Date_YearFormat,
				CONVERT(CHAR(20), TRADE_DATE,106) Trade_Date_YearFormat1
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
		,CONVERT(CHAR(11), FUNDS_PAYIN_DATE,106)FUNDS_PAYIN_DATE1
		FROM
				SETTLEMENT_MASTER
		WHERE
				Company_Code	=	'#Cocd#'
		And 	MKT_TYPE 		= 	'#Mkt_Type#' 
		And 	SETTLEMENT_NO 	= 	 #Settlement_No#
	</CFQUERY>
	
	<CFQUERY NAME="GetCompanyDetail" datasource="#Client.database#">
		SELECT	*
		FROM
				Company_Master
		Where
				Company_Code	=	'#COCD#'		
	</CFQUERY>
	
	<CFQUERY NAME="GetClientDetail" datasource="#Client.database#">
		SELECT	Client_SebiRegnNo, Unique_Cl_ID,Client_Name,b.*,a.pan_name,a.CUSTODIAN_PART_CODE
		FROM
				Client_Master A, Client_Details B
		Where
				Company_Code	=	'#COCD#'
		And		A.Client_ID		=	B.Client_ID
		And		A.Client_ID		=	'#Client_ID#'
	</CFQUERY>
	
	<CFIF Exchange EQ "BSE">
		<CFSET SetlNo =  #changeSetlNo(Trim(Settlement_No), "ForText")#>		
	<CFELSE>
		<CFSET SetlNo =  #Settlement_No#>		
	</CFIF>
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
	
	<cfquery name="GETCMBPID" datasource="#Client.database#">
		SELECT BROKER_CMBP_ID FROM SYSTEM_SETTINGS
		WHERE COMPANY_CODE = '#COCD#'
	</cfquery>
	
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
				<CFSET	CONTRACT_DATA	=	"#CONTRACT_DATA#:16R:GENL#CHR(10)#">
				
				


				
  
 <table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0 width="75%"
 style='width:423.4pt;border-collapse:collapse;border:none;mso-padding-alt:
 0in 5.4pt 0in 5.4pt'>
 <tr style='mso-yfti-irow:0;mso-yfti-firstrow:yes;height:12.25pt'>
  <td align="center" width=565 colspan=6 valign=top style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:12.25pt'>
   <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'><b>#coname#</b><st1:Street w:st="on"><st1:address
   w:st="on"></st1:address></st1:Street> <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:1;height:14.75pt;text-transform:uppercase'>
  <td align="center" width=565 colspan=6 style='width:423.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:14.75pt' >
 <p class=Default ><b>#ucase(GetCompanyDetail.company_address)#</b><o:p></o:p></p>
  </td>
 </tr>
 
 <tr style='mso-yfti-irow:3;height:22.4pt'>
  <td  align="center" width=565 colspan=6 valign=top style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:22.4pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Tel No: #GetCompanyDetail.telno#<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:3;height:22.4pt'>
  <td  align="center" width=565 colspan=6 valign=top style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:22.4pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>   CMBP ID: #GETCMBPID.BROKER_CMBP_ID#<o:p></o:p></span></p>
  </td>
 </tr>

 <tr style='mso-yfti-irow:4;height:20.75pt'>
  <td width=209 valign=bottom style='width:156.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:20.75pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Date <o:p></o:p></span></p>
  </td>
  <td width=86 colspan=3 valign=bottom style='width:64.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:20.75pt'>
  <p class=Default align=right style='text-align:right'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td  align="left" width=270 colspan=2 valign=bottom style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:20.75pt'>
   <p class=Default align=center style='text-align:left'><span
  style='font-size:10.0pt;font-family:GMLBID+Arial;mso-bidi-font-family:GMLBID+Arial'>#GetClient.Trade_Date_YearFormat1#  <o:p></o:p></span></p>
  </td>
 </tr>
 <tr  align="left" style='mso-yfti-irow:5;height:25.4pt'>
  <td width=209 valign=top style='width:156.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:25.4pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Company Name <o:p></o:p></span></p>
  </td>
  <td width=86 colspan=3 valign=top style='width:64.4pt;border:none;padding:
  0in 5.4pt 0in 5.4pt;height:25.4pt'>
  <p class=Default align=right style='text-align:right'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:25.4pt'>
  <p class=Default align=center style='text-align:left'><span
  style='font-size:10.0pt;font-family:GMLBID+Arial;mso-bidi-font-family:GMLBID+Arial'>#CLIENT_NAME# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:6;height:23.9pt'>
  <td width=209 style='width:156.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:23.9pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>TO <o:p></o:p></span></p>
  </td>
  <td width=86 colspan=3 style='width:64.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:23.9pt'>
  <p class=Default align=right style='text-align:right'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 style='width:202.5pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:23.9pt'>
  
    <p class=Default align=center style='text-align:left'><span
  style='font-size:10.0pt;font-family:GMLBID+Arial;mso-bidi-font-family:GMLBID+Arial'>#GetClientDetail.pan_name# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:7;height:14.25pt'>
  <td width=209 style='width:156.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:14.25pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>CC <o:p></o:p></span></p>
  </td>
  <td width=86 colspan=3 valign=top style='width:64.4pt;border:none;padding:
  0in 5.4pt 0in 5.4pt;height:14.25pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:14.25pt'>
  <p class=Default align=center style='text-align:center'><span
  style='mso-bidi-font-family:"Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:8;height:15.9pt'>
  <td width=209 style='width:156.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.9pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>PHONE NO. <o:p></o:p></span></p>
  </td>
  <td width=86 colspan=3 style='width:64.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.9pt'>
  <p class=Default align=right style='text-align:right'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td  align="left" width=270 colspan=2 style='width:202.5pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.9pt'>
  <p class=Default align=center style='text-align:center'><span
  style='font-size:10.0pt;font-family:GMLBID+Arial;mso-bidi-font-family:GMLBID+Arial'> #GetClientDetail.resi_tel_no#
  <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:9;height:23.75pt'>
  <td width=209 valign=top style='width:156.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:23.75pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>FAX NO. <o:p></o:p></span></p>
  </td>
  <td width=86 colspan=3 valign=top style='width:64.4pt;border:none;padding:
  0in 5.4pt 0in 5.4pt;height:23.75pt'>
  <p class=Default align=right style='text-align:right'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td   align="left" width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:23.75pt'>
  <p class=Default align=center style='text-align:center'><span
  style='font-size:10.0pt;font-family:GMLBID+Arial;mso-bidi-font-family:GMLBID+Arial'>#GetClientDetail.resi_fax_no#
  <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:10;height:25.4pt'>
  <td width=565 colspan=6 valign=bottom style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:25.4pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>We are pleased to report your transaction
  of the following security <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:11;height:30.9pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:30.9pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Client Name <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:30.9pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 valign=top style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:30.9pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:30.9pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#CLIENT_NAME#<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:12;height:29.15pt'>
  <td width=241 colspan=2 valign=bottom style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:29.15pt'>
  <p class=Default><b><span style='font-size:10.0pt'>Our Contract No </span></b><span
  style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:29.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 valign=bottom style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:29.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=bottom style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:29.15pt'>
  <p class=Default><b><span style='font-size:10.0pt'>#CONTRACT_NO# </span></b><span
  style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:13;height:15.0pt'>
  <td width=241 colspan=2 style='width:180.65pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.0pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Trade Date <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.0pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.0pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 style='width:202.5pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.0pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#GetClient.Trade_Date_YearFormat1#<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:14;height:15.15pt'>
  <td width=241 colspan=2 style='width:180.65pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Settlement Date <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 style='width:202.5pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#GetSetlDate.Funds_Payin_Date1# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:15;height:16.65pt'>
  <td width=241 colspan=2 style='width:180.65pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:16.65pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Buy/Sell <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:16.65pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:16.65pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 style='width:202.5pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:16.65pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>
		<CFIF TRIM(BUY_SALE) EQ 'SALE'>
			Sell
		<cfelse>
			#BUY_SALE# 
		</CFIF>
				<o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:16;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Scrip Name <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#SCRIP_NAME# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:17;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Security ID (ISIN) <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#ISIN# <o:p></o:p></span></p>
  </td>
 </tr>
 
 
<tr style='mso-yfti-irow:18;height:13.5pt'>
  <td width=241 colspan=2 style='width:180.65pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:13.5pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>CUSIP Code <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:13.5pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:13.5pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:13.5pt'>
  <p class=Default><span style='mso-bidi-font-family:"Times New Roman";
  color:windowtext'> 
  <o:p>&nbsp;#ucase(GetClientDetail.CUSTODIAN_PART_CODE)#</o:p></span></p>
  </td>
 </tr>
  
 <tr style='mso-yfti-irow:19;height:16.5pt'>
  <td width=241 colspan=2 style='width:180.65pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:16.5pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Quantity <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:16.5pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:16.5pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 style='width:202.5pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:16.5pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#QTY# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:20;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Market Rate (Per Share) (INR) <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#RATE# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:21;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Brokerage Amount (INR) <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#TOTBrk#  <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:21;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Brokerage Amount (Per Share) (INR) <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#BRK#  <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:22;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Net Rate (Per Share) (INR) <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=32 valign=top style='width:24.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default><span class=SpellE><b><span style='font-size:10.0pt'>Rs</span></b></span><b><span
  style='font-size:10.0pt'> </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=238 valign=top style='width:178.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#NETRATE# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:23;height:15.4pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.4pt'>
  <p class=Default><b><span style='font-size:10.0pt'>Net Settlement Amount
  (INR) </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.4pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.4pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=32 valign=top style='width:24.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.4pt'>
  <p class=Default><span class=SpellE><b><span style='font-size:10.0pt'>Rs</span></b></span><b><span
  style='font-size:10.0pt'> </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=238 valign=top style='width:178.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.4pt'>
  <p class=Default><b><span style='font-size:10.0pt'>
  <Cfif buy_sale eq 'BUY'>
	  #ACTUAL_AMT+val(TOTBrk)# 
	<CFELSE>
  		#ACTUAL_AMT-val(TOTBrk)# 
  </Cfif>
  
  </span></b><span
  style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:24;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><b><span style='font-size:10.0pt'>S.T.T </span></b><span
  style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><b><span
  style='font-size:10.0pt'><Cfif buy_sale eq 'BUY'>
	  (+)
	<CFELSE>
		(-)
  </Cfif> 
  </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=32 valign=top style='width:24.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default><span class=SpellE><b><span style='font-size:10.0pt'>Rs</span></b></span><b><span
  style='font-size:10.0pt'> </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=238 valign=top style='width:178.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default><b><span style='font-size:10.0pt'>#STT# </span></b><span
  style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:25;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><b><span style='font-size:10.0pt'>Net Value (INR) </span></b><span
  style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=32 valign=top style='width:24.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default><span class=SpellE><b><span style='font-size:10.0pt'>Rs</span></b></span><b><span
  style='font-size:10.0pt'> </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=238 valign=top style='width:178.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default><b><span style='font-size:10.0pt'>#AMT# </span></b><span
  style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:26;height:14.9pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:14.9pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Mode of Settlement <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:14.9pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:14.9pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:14.9pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Through Clearing House <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:27;height:15.15pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Exchange &amp; Segment ## <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:15.15pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#Exchange#/<Cfif Exchange eq 'bse'>Rolling <cfelse>Normal </Cfif> (#Exchange#) <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:28;height:13.5pt'>
  <td width=241 colspan=2 style='width:180.65pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:13.5pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Settlement No. <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:13.5pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:13.5pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 style='width:202.5pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:13.5pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#SetlNo# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:29;height:28.5pt'>
  <td width=241 colspan=2 valign=top style='width:180.65pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:28.5pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Our Settlement Instruction <o:p></o:p></span></p>
  </td>
  <td width=38 valign=top style='width:28.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:28.5pt'>
  <p class=Default align=right style='text-align:right'><span style='mso-bidi-font-family:
  "Times New Roman";color:windowtext'><o:p>&nbsp;</o:p></span></p>
  </td>
  <td width=16 valign=top style='width:12.15pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:28.5pt'>
  <p class=Default align=center style='text-align:center'><b><span
  style='font-size:10.0pt'>: </span></b><span style='font-size:10.0pt'><o:p></o:p></span></p>
  </td>
  <td width=270 colspan=2 valign=top style='width:202.5pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:28.5pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#CONAME# <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:30;height:30.25pt'>
  <td width=565 colspan=6 valign=bottom style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:30.25pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>#Exchange#/<Cfif Exchange eq 'bse'>Rolling <cfelse>Normal </Cfif>denotes trade is executed in
  ROLLING SEGMENT (T + 2) <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:31;height:15.0pt'>
  <td width=565 colspan=6 valign=top style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.0pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Please send the settlement instructions
  for the above trade immediately <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:32;height:15.15pt'>
  <td width=565 colspan=6 valign=top style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Please respond within 24 hours if any
  discrepancies. <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:33;height:15.15pt'>
  <td width=565 colspan=6 valign=top style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>The information above reflects price and
  quantity data currently available. <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:34;height:15.15pt'>
  <td width=565 colspan=6 valign=top style='width:423.4pt;border:none;
  padding:0in 5.4pt 0in 5.4pt;height:15.15pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>However this report is for information
  purposes only. <o:p></o:p></span></p>
  </td>
 </tr>
 <tr style='mso-yfti-irow:35;mso-yfti-lastrow:yes;height:12.9pt'>
  <td width=565 colspan=6 style='width:423.4pt;border:none;padding:0in 5.4pt 0in 5.4pt;
  height:12.9pt'>
  <p class=Default><span style='font-size:10.0pt;font-family:GMLBID+Arial;
  mso-bidi-font-family:GMLBID+Arial'>Final transaction details appear only on
  the firm's Contract Note. <o:p></o:p></span></p>
  </td>
 </tr>
 <![if !supportMisalignedColumns]>
 <tr height=0>
  <td width=208 style='border:none'></td>
  <td width=32 style='border:none'></td>
  <td width=37 style='border:none'></td>
  <td width=18 style='border:none'></td>
  <td width=32 style='border:none'></td>
  <td width=237 style='border:none'></td>
 </tr>
 <![endif]>
</table> 
	</CFLOOP>	
</CFLOOP>
 
</CFOUTPUT>


