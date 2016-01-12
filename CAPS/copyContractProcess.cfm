<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL Market AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> Contract Generation. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	
	<STYLE>
		DIV#Heading
		{
			Position	:	Absolute;
			Top			:	0;
			Width		:	100%;
		}
		DIV#Message
		{
			Position	:	Absolute;
			Top			:	10%;
			Width		:	100%;
		}
		DIV#Forms
		{
			Position	:	Absolute;
			Top			:	20%;
			Width		:	100%;
			Height		:	70%;
			Overflow	:	Auto;
		}
		DIV#RegenCancel
		{
			Position	:	Absolute;
			Top			:	90%;
			Width		:	100%;
		}
	</STYLE>
</head>

<body topmargin="0" leftmargin="0">
<CFOUTPUT>


<CFQUERY name="GetXchngCode" datasource="#Client.database#" dbtype="ODBC">
	Select	RTrim(CLEARING_MEMBER_CODE) XchngCode
	From	SYSTEM_SETTINGS
	Where	COMPANY_CODE	=	'#Trim(COCD)#'
</CFQUERY>

<CFSET XchngCode	=	GetXchngCode.XchngCode>


<CFTRANSACTION>
	<!--- ==========================================================
						CONTRACT NUMBER GENERATION
	=========================================================== --->
	<CFIF IsDefined("Generate")>
		<div align="center" id="Message">
			<table align="center" cellpadding="0" cellspacing="0" width="50%" class="StyleReportParameterTable1">
				<CFTRY>
					<CFSTOREDPROC procedure="CAPS_CONTRACT_NUMBER_GENERATION" datasource="#Client.database#" returncode="Yes">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Trim(Mkt_Type)#" maxlength="2" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Val(Trim(Settlement_No))#" maxlength="9" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trim(Trade_Date)#" maxlength="10" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT" value="#Trim(Client_ID)#" maxlength="20" null="No">
					</CFSTOREDPROC>
					
					<tr>
						<td align="left"> Contract is Generated for :&nbsp;
							<font color="Purple" size="2">
								#Trim(Mkt_Type)# &nbsp;/ &nbsp;#Val(Settlement_No)# 
								<CFIF Len(Trim(Trade_Date)) GT 0>
									&nbsp;/ &nbsp;#Trade_Date#
								</CFIF>
							</font>
						</td>
					</tr>
				<CFCATCH>
					<tr><td align="left" style="Color : Red;">
						Contract is NOT Generated.
					</td></tr>
				</CFCATCH>
				</CFTRY>
			</table>
		</div>
	</CFIF>
	
	<CFIF IsDefined("Cancel")>
		<div align="center" id="Message">
			<table align="center" cellpadding="0" cellspacing="0" width="50%" class="StyleReportParameterTable1">
				<CFTRY>
					<CFSTOREDPROC procedure="CAPS_CONTRACT_NUMBER_CANCELLATION" datasource="#Client.database#" returncode="Yes">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Mkt_Type#" maxlength="2" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@SETTLEMENT_NO" value="#Val(Settlement_No)#" maxlength="9" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ClientId" value="#ClientId#" maxlength="10" null="No">
					</CFSTOREDPROC>
					
					<tr>
						<td align="left"> Contract is Cancelled for :&nbsp;
							<font color="Purple" size="2">
								#Trim(Mkt_Type)# &nbsp;/ &nbsp;#Val(Settlement_No)#
								<CFIF Len(Trim(Trade_Date)) GT 0>
									&nbsp;/ &nbsp;#Trade_Date#
								</CFIF>
							</font>
						</td>
					</tr>
				<CFCATCH>
					<tr><td align="left" style="Color : Red;"> Contract is NOT Cancelled. </td></tr>
				</CFCATCH>
				</CFTRY>
			</table>
		</div>
	</CFIF>
</CFTRANSACTION>

</CFOUTPUT>

<cfif ISDEFINED("cmdView")>
<CFTRY>
<CFQUERY NAME="Del" datasource="#Client.database#">
	DROP TABLE ##T1
</CFQUERY>
<CFCATCH TYPE="DATABASE">
</CFCATCH>
</CFTRY>


<CFTRY>
<!--- <CFQUERY name="ProcessDate" datasource="CAPSFO" dbtype="ODBC">
	Select 	Distinct MKT_TYPE, SETTLEMENT_NO, TRADE_DATE
	From 	TRADE1 a(INDEX=IDX_MULTIDATE_TRADE1), FINANCIAL_YEAR_MASTER b
	Where
				A.COMPANY_CODE	=	B.COMPANY_CODE
			And	B.FINSTART		=	#Val(FinStart)#
			And	A.COMPANY_CODE	=	'#Trim(COCD)#'
			And	Convert( DateTime, TRADE_DATE, 103 ) >= Convert( DateTime, START_DATE, 103 )
			And	Convert( DateTime, TRADE_DATE, 103 ) <= Convert( DateTime, END_DATE, 103 )
			And CONTRACT_NO		=	0
	ORDER BY TRADE_DATE
</CFQUERY>
 --->
 
<CFQUERY NAME="GetFaDates" datasource="#Client.database#">
	SELECT	START_DATE, END_DATE
	FROM
			FINANCIAL_YEAR_MASTER
	WHERE	
			FINSTART		=	#Val(FinStart)#
	And		COMPANY_CODE	=	'#Trim(COCD)#'		
</CFQUERY>

<CFQUERY NAME="ProcessDate1" datasource="#Client.database#">
	Select 	Distinct MKT_TYPE, SETTLEMENT_NO, TRADE_DATE, 
	         case when contract_no = 0 then Client_ID else '0' end as cnt1,
	         case when contract_no != 0 then Client_ID else '0' end as cnt2
	InTo ##T1
	From 	TRADE1
		<cfif	Isdefined("Settlement_No") And Settlement_No is not  "">
			(INDEX=IDX_CONTRACTNO_TRADE1)
		<cfelse>
			(INDEX=IDX_MULTIDATE_TRADE1)
		</cfif>
	Where
		COMPANY_CODE	=	'#Trim(COCD)#'
	<cfif	Isdefined("Settlement_No") And Settlement_No is not  "">
	And	Mkt_Type		=	'#Mkt_Type#'
	And	Settlement_No	=	'#Settlement_No#'
	<cfelse>
	And	Convert( DateTime, TRADE_DATE, 103 ) >= '#GetFaDates.START_DATE#'
	And	Convert( DateTime, TRADE_DATE, 103 ) <= '#GetFaDates.END_DATE#'
	</cfif>
	AND CLIENT_ID		<>	'#XchngCode#'
</CFQUERY>

<CFQUERY NAME="ProcessDate" datasource="#Client.database#">
	Select mkt_type, settlement_no, trade_date, COUNT(distinct cnt1)PendingContract, COUNT(distinct cnt2)GenContract
	From ##t1
	Group by mkt_type,settlement_no,trade_date
	ORDER BY TRADE_DATE
	
</CFQUERY>

<CFCATCH TYPE="DATABASE">

</CFCATCH>
</CFTRY>

<div align="center" id="Heading">
	<table align="center" cellpadding="0" cellspacing="0" width="50%" class="StyleTable1">
		<tr>
			<th align="center">
				<u>Pending Contracts</u>
			</th>
		</tr>
	</table>
</div>


<div align="center" id="Forms">
	<table align="center" cellpadding="0" cellspacing="0" width="85%" class="StyleReportParameterTable1">
		<CFSET SlNo	=	0>
		
		<CFOUTPUT Query="ProcessDate" Group="TRADE_DATE">
			
			<CFOUTPUT>
				<CFIF PendingContract GT 1>
					<form name="ContractForm" action="ContractProcess.cfm" method="POST">
						<input type="Hidden" name="COCD" value="#Trim(COCD)#">
						<input type="Hidden" name="COName" value="#COName#">
						<input type="Hidden" name="Market" value="#Market#">
						<input type="Hidden" name="Exchange" value="#Exchange#">
						<input type="Hidden" name="Broker" value="#Broker#">
						<input type="Hidden" name="FinStart" value="#FinStart#">
						
						<input type="Hidden" name="Mkt_Type" value="#Trim(MKT_TYPE)#">
						<input type="Hidden" name="Settlement_No" value="#Val(Trim(SETTLEMENT_NO))#">
						<input type="Hidden" name="Trade_Date" value="#DateFormat(TRADE_DATE, 'DD/MM/YYYY')#">
						<input type="Hidden" name="Client_ID" value="">
						
						<tr bgcolor="DAF7FC">
							<td align="left" width="10%"> #Trim(MKT_TYPE)# </td>
							<td align="left" width="10%"> #Trim(SETTLEMENT_NO)# </td>
							<td align="left" width="10%"> #DateFormat(TRADE_DATE, "DD/MM/YYYY")# </td>
							<td align="center" width="10%">
								<input accesskey="G" type="Submit" name="Generate" value="Generate" class="StyleSmallButton1">
							</td>
							
							<td align="left" width="15%"> 
								<!--- <CFQUERY name="GenContracts" datasource="CAPSFO" dbtype="ODBC">
									Select	Count(Distinct Client_ID) CNT_VALID
									From	TRADE1 ( INDEX= IDX_CONTRACTNO_TRADE1 )
									Where
												COMPANY_CODE	=	'#Trim(COCD)#'
											AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
											AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
											AND	Convert( DateTime, TRADE_DATE, 103 ) = Convert( DateTime, '#DateFormat(TRADE_DATE, "DD/MM/YYYY")#', 103 )
											AND CLIENT_ID		<>	'#XchngCode#'
											AND	CONTRACT_NO		>	0
								</CFQUERY> --->
								
								<font color="Blue">
									<b><u>Contracts</u></b>
								</font>
								Done :&nbsp;#GenContract# <!--- #GenContracts.CNT_VALID# --->&nbsp;
							</td>
							
							<td align="left" width="10%">
								<!--- <CFQUERY name="PendContracts" datasource="CAPSFO" dbtype="ODBC">
									Select	Count( Distinct CLIENT_ID ) CNT_VALID
									From	TRADE1 ( INDEX = IDX_CONTRACTNO_TRADE1 )
									Where
												COMPANY_CODE	=	'#Trim(COCD)#'
											AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
											AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
											AND	Convert( DateTime, TRADE_DATE, 103 ) = Convert( DateTime, '#DateFormat(TRADE_DATE, "DD/MM/YYYY")#', 103 )
											AND CLIENT_ID		<>	'#XchngCode#'
											AND	CONTRACT_NO		=	0
								</CFQUERY> --->
								
								Pending :&nbsp;#PendingContract#<!--- #PendContracts.CNT_VALID# --->
							</td>
							
							<!---<td align="left" width="15%"> 
								<CFQUERY name="InvalidContracts" datasource="CAPSFO" dbtype="ODBC">
									Select	Count( Distinct CLIENT_ID ) CNT_VALID
									From	TRADE1 ( INDEX= IDX_CONTRACTNO_TRADE1 )
									Where
												COMPANY_CODE	=	'#Trim(COCD)#'
											AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
											AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
											AND	CONVERT(DATETIME, TRADE_DATE, 103)	= CONVERT(DATETIME, '#DateFormat(TRADE_DATE, "DD/MM/YYYY")#', 103)
											AND	CONTRACT_NO		=	0
											AND	VALIDITY_FLAG	=	'N'
								</CFQUERY>
								
								<font color="Blue">
									<b><u>Clients</u></b>
								</font>
								Invalid :&nbsp;#InvalidContracts.CNT_VALID#
							</td>
							
							<td align="left" width="10%">
								<CFQUERY name="ProContracts" datasource="CAPSFO" dbtype="ODBC">
									Select	Count( Distinct CLIENT_ID ) CNT_VALID
									From	TRADE1 ( INDEX= IDX_CONTRACTNO_TRADE1 )
									Where
												COMPANY_CODE	=	'#Trim(COCD)#'
											AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
											AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
											AND	Convert( DateTime, TRADE_DATE, 103 ) = Convert( DateTime, '#DateFormat(TRADE_DATE, "DD/MM/YYYY")#', 103 )
											AND	CLIENT_ID		IN
											(
												Select	Distinct Client_ID
												From	CLIENT_MASTER
												Where
															COMPANY_CODE	=	'#Trim(COCD)#'
														AND CLIENT_ID		<>	'#XchngCode#'
														AND	CLIENT_NATURE	IN	( 'P', 'J' )
											)
								</CFQUERY>
								
								<CFQUERY name="Billed" datasource="CAPSFO" dbtype="ODBC">
									Select	FLG_BILL
									From	SETTLEMENT_MASTER
									Where
												COMPANY_CODE	=	'#Trim(COCD)#'
											AND	MARKET			=	'#Trim(Market)#'
											AND	EXCHANGE		=	'#Trim(Exchange)#'
											AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
											AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
								</CFQUERY>
								
								PRO :&nbsp;#ProContracts.CNT_VALID#
								<CFIF Billed.FLG_BILL EQ "Y">
									&nbsp;&nbsp;<font color="Brown"><b>B</b></font>
								</CFIF>
							</td>---->
						</tr>
					</form>
				<CFELSE>
					<tr>
						<td align="left" width="10%"> #Trim(MKT_TYPE)# </td>
						<td align="left" width="10%"> #Trim(SETTLEMENT_NO)# </td>
						<td align="left" width="10%"> #DateFormat(TRADE_DATE, "DD/MM/YYYY")# </td>
						<td align="center" width="10%">&nbsp;  </td>
						<td align="left" width="15%"> 
							<!--- <CFQUERY name="GenContracts" datasource="CAPSFO" dbtype="ODBC">
								Select	Count( Distinct Client_ID ) CNT_VALID
								From	TRADE1 ( INDEX = IDX_CONTRACTNO_TRADE1 )
								Where
											COMPANY_CODE	=	'#Trim(COCD)#'
										AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
										AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
										AND	Convert( DateTime, TRADE_DATE, 103 ) = Convert( DateTime, '#DateFormat(TRADE_DATE, "DD/MM/YYYY")#', 103 )
										AND	CONTRACT_NO		>	0
							</CFQUERY> --->
							
							<font color="Blue">
								<b><u>Contracts</u></b>
							</font>
							Done :&nbsp;#GenContract#<!--- #GenContracts.CNT_VALID# --->&nbsp;
						</td>
						<td align="left" width="10%">
							<!--- <CFQUERY name="PendContracts" datasource="CAPSFO" dbtype="ODBC">
								Select	Count( Distinct Client_ID ) CNT_VALID
								From	TRADE1 ( INDEX = IDX_CONTRACTNO_TRADE1 )
								Where
											COMPANY_CODE	=	'#Trim(COCD)#'
										AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
										AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
										AND	Convert( DateTime, TRADE_DATE, 103 ) = Convert( DateTime, '#DateFormat(TRADE_DATE, "DD/MM/YYYY")#', 103 )
										AND Client_ID		<>	'#XchngCode#'
										AND	CONTRACT_NO		=	0
							</CFQUERY> --->
							
							Pending :&nbsp;#PendingContract#<!--- #PendContracts.CNT_VALID# --->
						</td>
						<!---<td align="left" width="15%"> 
							<CFQUERY name="InvalidContracts" datasource="CAPSFO" dbtype="ODBC">
								Select	Count( Distinct Client_ID ) CNT_VALID
								From	TRADE1 ( INDEX = IDX_CONTRACTNO_TRADE1 )
								Where
											COMPANY_CODE	=	'#Trim(COCD)#'
										AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
										AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
										AND	Convert( DateTime, TRADE_DATE, 103 ) = Convert( DateTime, '#DateFormat( TRADE_DATE, "DD/MM/YYYY")#', 103 )
										AND	CONTRACT_NO		=	0
										AND	VALIDITY_FLAG	=	'N'
							</CFQUERY>
							
							<font color="Blue">
								<b><u>Clients</u></b>
							</font>
							Invalid :&nbsp;#InvalidContracts.CNT_VALID#
						</td>
						<td align="left" width="10%"> 
							<CFQUERY name="ProContracts" datasource="CAPSFO" dbtype="ODBC">
								Select	Count( Distinct Client_ID ) CNT_VALID
								From	TRADE1 ( INDEX = IDX_CONTRACTNO_TRADE1 )
								Where
											COMPANY_CODE	=	'#Trim(COCD)#'
										AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
										AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
										AND	Convert( DateTime, TRADE_DATE, 103 ) = Convert( DateTime, '#DateFormat(TRADE_DATE, "DD/MM/YYYY")#', 103 )
										AND	Client_ID		IN	
										(
											Select	Distinct Client_ID
											From	CLIENT_MASTER
											Where
														COMPANY_CODE	=	'#Trim(COCD)#'
													AND Client_ID		<>	'#XchngCode#'
													AND	CLIENT_NATURE	IN	( 'P', 'J' )
										)
							</CFQUERY>
							
							<CFQUERY name="Billed" datasource="CAPSFO" dbtype="ODBC">
								Select	FLG_BILL
								From	SETTLEMENT_MASTER
								Where
											COMPANY_CODE	=	'#Trim(COCD)#'
										AND	MARKET			=	'#Trim(Market)#'
										AND	EXCHANGE		=	'#Trim(Exchange)#'
										AND	MKT_TYPE		=	'#Trim(MKT_TYPE)#'
										AND	SETTLEMENT_NO	=	'#Trim(SETTLEMENT_NO)#'
							</CFQUERY>
							
							PRO :&nbsp;#ProContracts.CNT_VALID#
							<CFIF Billed.FLG_BILL EQ "Y">
								&nbsp;&nbsp;<font color="Brown"><b>B</b></font>
							</CFIF>
						</td>----->
					</tr>
				</CFIF>
			</CFOUTPUT>
		</CFOUTPUT>
	</table>
</div>
</cfif>

<div align="center" id="RegenCancel">
	<CFOUTPUT>
		<CFQUERY name="Markets" datasource="#Client.database#" dbtype="ODBC">
			Select	Distinct RTrim(MKT_TYPE) MktType
			From	MARKET_TYPE_MASTER
			Where
						Market		= '#Trim(Market)#'
					And	Exchange	= '#Trim(Exchange)#'
			Order By MktType Desc
		</CFQUERY>
		
		<CFFORM name="ContractRegen" action="ContractProcess.cfm" method="POST">
			<input type="Hidden" name="COCD" value="#Trim(COCD)#">
			<input type="Hidden" name="COName" value="#COName#">
			<input type="Hidden" name="Market" value="#Market#">
			<input type="Hidden" name="Exchange" value="#Exchange#">
			<input type="Hidden" name="Broker" value="#Broker#">
			<input type="Hidden" name="FinStart" value="#FinStart#">
			<input type="Hidden" name="Client_ID" value="">
			
			<table align="center" border="0" cellpadding="0" cellspacing="0" class="StyleReportParameterTable1">
				<tr>
					<th align="right"> Market-Type :&nbsp; </th>
					<th align="left">
						<select name="Mkt_Type" class="StyleListBox">
							<CFLOOP query="Markets">
								<option value="#Trim(MktType)#"> #Trim(MktType)# </option>
							</CFLOOP>
						</select>
					</th>
					<th align="right"> &nbsp;Settlement-No :&nbsp; </th>
					<th align="left">
						<cfinput type="Text" name="Settlement_No" range="1, 9999999" message="Enter valid Settlement-No." validate="integer" required="no" size="10" maxlength="7" class="StyleTextBox">
					</th>
			</tr>
			<tr>
					<th align="right"> &nbsp;Trade-Date :&nbsp; </th>
					<th align="left">
						<cfinput type="Text" name="Trade_Date" message="Enter valid Trade-Date in the Format: 'DD/MM/YYYY'." validate="eurodate" required="no" size="10" maxlength="10" class="StyleUcaseTextBox">
					</th>
					<th align="right"> &nbsp;Client Id :&nbsp; </th>
					<th align="left">
						<cfinput type="Text" name="ClientId" size="10" maxlength="10" class="StyleUcaseTextBox">
					</th>
					
					<td align="right">
						&nbsp;
						<input accesskey="R" type="Submit" name="Generate" value="Regenerate" class="StyleSmallButton1">
						<input accesskey="V" type="Submit" name="cmdView" value="View" class="StyleSmallButton1">
						<input accesskey="C" type="Submit" name="Cancel" value="Cancel Contract" class="StyleSmallButton1">
					</td>
				</tr>
			</table>
		</CFFORM>
	</CFOUTPUT>
</div>


</body>
</html>