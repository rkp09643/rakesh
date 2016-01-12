<!---- **************************************************************
	BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*************************************************************** ---->


<html>
<head>
	<title> Remeshire Report. </title>
	
   	<link href="/FOCAPS/CSS/FORemeshireScreen.css" rel="stylesheet" type="text/css" media="screen">
  	<link href="/FOCAPS/CSS/FORemeshirePrint.css" rel="stylesheet" type="text/css" media="print">
</head>

<body>
<CFOUTPUT>


<cfstoredproc procedure="CAPS_REPORTS_REMESHIRE" datasource="#Client.database#">
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(Ucase(COCD))#" maxlength="8" null="No"> 
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Trim(Ucase(Mkt_Type))#" maxlength="2" null="No"> 
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROMDATE" value="#Trim(FromDate)#" maxlength="10" null="No"> 
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TODATE" value="#Trim(ToDate)#" maxlength="10" null="No"> 
	<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@GROUP" value="#RemGroup#" maxlength="15" null="No"> 
	
	<cfprocresult name="GetRemeshireDetails">
</cfstoredproc>

<CFIF GetRemeshireDetails.RecordCount EQ 0>
	<script>
		alert( "No Data Found." );
		JavaScript: history.back();
	</script>
</CFIF>

<div align="center" id="Heading">
	<table align="center" border="0" cellpadding="0" cellspacing="0" class="showtable">
		<tr>
			<td align="center">
				<u>Remeshire Report (#RepID#)</u>
			</td>
		</tr>
	</table>
</div>

<div align="center" id="Header">
	<table align="center" border="0" cellpadding="0" cellspacing="0" class="showtable">
		<tr>
			<td align="left" colspan="5">
				&nbsp;Date From:&nbsp;#FromDate# &nbsp; To:&nbsp;#ToDate#
			</td>
		</tr>
		<tr bgcolor="E3F3A3">
			<th align="Right" class="thSlNo"> No </th>
			<th align="Right" class="thClientID"> Client-ID&nbsp; </th>
			<th align="Left" class="thClientName"> &nbsp;Client-Name </th>
			<th align="Center" class="thAmt"> Bill-No </th>
			<th align="Right" class="thAmt"> Brokerage </th>
		</tr>
	</table>
</div>


</CFOUTPUT>


<CFSET RowCount = 0>
<CFSET Page = 0>
<CFSET rc = 0>
<CFSET rec = GetRemeshireDetails.RecordCount>

<div align="center" id="RemBrkData">
	<CFOUTPUT Query="GetRemeshireDetails" Group="REMGROUP">
		<CFSET netRem = 0>
		<CFSET netBrk = 0>
		<CFSET netAppBrk = 0>
		
		<CFIF RowCount LT 2>
			<CFMODULE Template="RemeshireReportHeader.cfm"
						ReportID = "#val(RepID)#"
						FromDate = "#Trim(FromDate)#"
						ToDate = "#Trim(ToDate)#"
						GroupID = "#Trim(REMGROUP)#"
						GroupName = "#trim(REMGROUPNAME)#"
						PrintDate = "#Trim(PrintDate)#"
						RowCount = "#val(RowCount)#"
						Page = "#val(Page)#"
						CurrGroupID = ""
						CurrGroupName = ""
						CurrGroupHead = ""
						CurrDate = ""
			>
			<CFSET RowCount = "#val(Returncode)#">
			<CFSET Page = IncrementValue(Page)>
		</CFIF>
		
		<table align="center" border="0" cellpadding="0" cellspacing="0">
			<tr bgcolor="b3b3b3">
				<td align="Left"> Group : #REMGROUP# </td>
				<td align="Left"> Name : #REMGROUPNAME# </td>
				<td align="Left"> Head : #REMGROUPHEAD# </td>
			</tr>
			<CFSET RowCount = DecrementValue(RowCount)>
		</table>
		
		<CFOUTPUT Group="TRADE_DATE">
			<CFIF RowCount LT 2>
				<CFMODULE Template="RemeshireReportHeader.cfm"
							ReportID = "#val(RepID)#"
							FromDate = "#Trim(FromDate)#"
							ToDate = "#Trim(ToDate)#"
							GroupID = "#Trim(REMGROUP)#"
							GroupName = "#trim(REMGROUPNAME)#"
							PrintDate = "#Trim(PrintDate)#"
							RowCount = "#val(RowCount)#"
							Page = "#val(Page)#"
							CurrGroupID = ""
							CurrGroupName = ""
							CurrGroupHead = ""
							CurrDate = "">
				<CFSET RowCount = "#val(Returncode)#">
				<CFSET Page = IncrementValue(Page)>
			</CFIF>
			
			<table align="center" border="0" cellpadding="0" cellspacing="0">
				<tr bgcolor="b3b3b3">
					<td align="Left"> Date : #DateFormat(TRADE_DATE, "DD/MM/YYYY")# </td>
				</tr>
				<CFSET RowCount = DecrementValue(RowCount)>
			</table>
			
			<CFIF RowCount eq 0>
				<CFMODULE Template="RemeshireReportHeader.cfm"
							ReportID = "#val(RepID)#"
							FromDate = "#Trim(FromDate)#"
							ToDate = "#Trim(ToDate)#"
							GroupID = "#Trim(REMGROUP)#"
							GroupName = "#trim(REMGROUPNAME)#"
							PrintDate = "#Trim(PrintDate)#"
							RowCount = "#val(RowCount)#"
							Page = "#val(Page)#"
							CurrGroupID = ""
							CurrGroupName = ""
							CurrGroupHead = ""
							CurrDate = ""
				>
				<CFSET RowCount = "#val(Returncode)#">
				<CFSET Page = IncrementValue(Page)>
			</CFIF>
			
			<CFSET totBrk = 0>
			<CFSET SlNo = 0>
			<CFOUTPUT>
				<CFIF Trim(TYPE) EQ "BRK">
					<CFSET SlNo = IncrementValue(SlNo)>
					<table align="center" border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td align="Right" class="thSlNo"> #SlNo# </td>
							<td align="Right" class="thClientID"> #CLIENTID#&nbsp; </td>
							<td align="Left" class="thClientName"> &nbsp;#CLIENTNAME# </td>
							<td align="Center" class="thAmt"> 0 </td>
							<td align="Right" class="thAmt"> #NumberFormat(AMT, "999999999.99")# </td>
							<CFSET RowCount = DecrementValue(RowCount)>
						</tr>
						<CFSET rc = IncrementValue(rc)>
						<CFSET totBrk	=	totBrk + AMT>
					</table>
					
					<CFIF RowCount EQ 0>
						<CFMODULE Template="RemeshireReportHeader.cfm"
									ReportID = "#val(RepID)#"
									FromDate = "#Trim(FromDate)#"
									ToDate = "#Trim(ToDate)#"
									GroupID = "#Trim(REMGROUP)#"
									GroupName = "#trim(REMGROUPNAME)#"
									PrintDate = "#Trim(PrintDate)#"
									RowCount = "#val(RowCount)#"
									Page = "#val(Page)#"
									CurrGroupID = ""
									CurrGroupName = ""
									CurrGroupHead = ""
									CurrDate = ""
						>
						<CFSET RowCount = "#val(Returncode)#">
						<CFSET Page = IncrementValue(Page)>
					</CFIF>
				</CFIF>
				
				<CFIF Trim(TYPE) EQ "REM">
					<CFSET ApplicableBrokerage	=	Abs(AMT)>
				<CFELSE>
					<CFSET ApplicableBrokerage	=	0> 	
				</CFIF>
			</CFOUTPUT>
			
			<CFIF RowCount LT 4>
				<CFMODULE Template="RemeshireReportHeader.cfm"
							ReportID = "#val(RepID)#"
							FromDate = "#Trim(FromDate)#"
							ToDate = "#Trim(ToDate)#"
							GroupID = "#Trim(REMGROUP)#"
							GroupName = "#trim(REMGROUPNAME)#"
							PrintDate = "#Trim(PrintDate)#"
							RowCount = "#val(RowCount)#"
							Page = "#val(Page)#"
							CurrGroupID = ""
							CurrGroupName = ""
							CurrGroupHead = ""
							CurrDate = "">
				<CFSET RowCount = "#val(Returncode)#">
				<CFSET Page = IncrementValue(Page)>
			</CFIF>
			
			<table align="center" border="0" cellpadding="0" cellspacing="0">
				<tr bgcolor="DFDFFF">
					<td align="right" colspan="4"> Total Brokerage : </td>
					<td align="right" class="thAmt"> #Numberformat(totBrk, "99999999.99")# </td>
					<CFSET netBrk		=	netBrk + totBrk>
				</tr>
				<tr bgcolor="DFDFFF">
					<td align="right" colspan="4"> Applicable Brokerage : </td>
					<td align="right" class="thAmt"> #Numberformat(ApplicableBrokerage, "99999999.99")# </td>
					<CFSET netAppBrk	=	netAppBrk + Abs(ApplicableBrokerage)>
				</tr>
				<CFSET totBrk			=	val(totBrk) - Abs(ApplicableBrokerage)>
				<tr bgcolor="DFDFFF">
					<td align="right" colspan="4"> Remeshire Amount : </td>
					<td align="right" class="thAmt"> #Numberformat(totBrk, "99999999.99")# </td>
				</tr>
				<CFSET RowCount = RowCount - 4>
			</table>
			<CFSET netRem	=	netRem + totBrk>
		</CFOUTPUT>
		
		<CFIF RowCount EQ 0>
			<CFMODULE Template="RemeshireReportHeader.cfm"
						ReportID = "#val(RepID)#"
						FromDate = "#Trim(FromDate)#"
						ToDate = "#Trim(ToDate)#"
						GroupID = "#Trim(REMGROUP)#"
						GroupName = "#trim(REMGROUPNAME)#"
						PrintDate = "#Trim(PrintDate)#"
						RowCount = "#val(RowCount)#"
						Page = "#val(Page)#"
						CurrGroupID = ""
						CurrGroupName = ""
						CurrGroupHead = ""
						CurrDate = "">
			<CFSET RowCount = "#val(Returncode)#">
			<CFSET Page = IncrementValue(Page)>
		</CFIF>
		
		<table align="center" border="0" cellpadding="0" cellspacing="0">
			<tr bgcolor="F3E3F3">
				<td align="Left"> Net Brokerage : #Numberformat(Abs(netBrk), "99999999.99")# </td>
				<td align="Center"> Net Applicable : #Numberformat(Abs(netAppBrk), "99999999.99")# </td>
				
				<CFIF #netRem# GTE 0>
					<td align="Right">
						Net	Credit : #Numberformat(Abs(netRem), "99999999.99")#
					</td>
				<CFELSE>
					<td align="Right" style="Color: Red;">
						Net	Debit : #Numberformat(Abs(netRem), "99999999.99")#
					</td>
				</CFIF>
			</tr>
		</table>
		
		<CFIF rc LT rec>
			<CFSET RowCount = 0>
		</CFIF>
	</CFOUTPUT>
</div>

<div align="center" id="RemBrkFooter">
	<table align="center" cellpadding="0" cellspacing="0" class="prn1">
		<TR align="center">
			<td ALIGN="right">
				<CFMODULE TEMPLATE="../../Common/Button.cfm"
	       				  Back = "Yes"
					      Print = "Yes">
			</td>
		</tr>
	</table>
</div>


</body>
</html>