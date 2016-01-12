<cfinclude template="/focaps/help.cfm">
<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> Expiry Process. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	
	<STYLE>
		DIV#Heading
		{
			Font		:	Bold 10pt Tahoma;
			Color		:	Navy;
			Position	:	Absolute;
			Top			:	0;
			Width		:	100%;
		}
		DIV#Header
		{
			Position	:	Absolute;
			Top			:	6%;
			Width		:	100%;
		}
		DIV#Datas
		{
			Position	:	Absolute;
			Top			:	12%;
			Width		:	100%;
			Height		: 	88%;
			Overflow	:	Auto;
		}
	</STYLE>
</head>

<body leftmargin="0" rightmargin="0" Class="StyleBody1" onLoad="document.EXPForm.trade_date.focus();">
<CFOUTPUT>


<div align="center" id="Heading">
	<u>Expiry Day Process</u>
</div>


<div align="center" id="Header">
	<CFPARAM name="trade_date" type="string" default="">
	
	<CFFORM action="Expiry.cfm" method="POST" name="EXPForm">
		<input type="Hidden" name="cocd" value="#Trim(COCD)#">
		<input type="Hidden" name="coname" value="#coname#">
		<input type="Hidden" name="market" value="#market#">
		<input type="Hidden" name="exchange" value="#exchange#">
		<input type="Hidden" name="FinStart" value="#FinStart#">
		<input type="Hidden" name="broker" value="#broker#">
		
		<table width="650" align="center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
			<tr>
				<th align="right" width="100" height="22"> Expiry Date :&nbsp; </th>
				<th align="left" width="100" height="22">
					<cfinput type="Text" name="trade_date" value="#trade_date#" message="DATE FORMAT: DD/MM/YYYY" validate="eurodate" required="Yes" size="8" maxlength="10" tabindex="1" class="StyleTextBox">
				</th>
				
				<th width="50" height="22">
					<input type="Submit" name="Ok" value="Process" tabindex="3" class="StyleSmallButton1">
				</th>
				
				<th id="dummy" width="280" height="22">&nbsp;  </th>
				<th id="timeBox" width="280" align="right" height="22">
					<font color="Black" size="1">
						<u>Process Time</u> :
					</font>
					<input type="Text" name="processtime" readonly size="10" style="Border : 1pt Solid; Color : 0A246A; Font : Normal 8pt Arial; Height : 11pt;">
				</th>
			</tr>
		</table>
	</CFFORM>
</div>


<div align="center" id="Datas">
	<CFIF IsDefined("Add")>
		<CFQUERY name="AddNewPrice" datasource="#Client.database#" dbtype="ODBC">
			Insert	CAPSFO_TRADEDATA.DBO.SCRIP_CLOSINGPRICE
			(
				SCRIP_SYMBOL, Scrip_Name, Isin, Scrip_Value, EXCHANGE, FileDate
			)
			Values
			(
				'#Trim(SCRIP_cODE)#','#Trim(SCRIP_NAME)#',
				'#ISIN#',#Val(MTMPrice)#, '#EXCHANGE#',
				CONVERT(DATETIME,'#MktDate#',103)
			)
		</CFQUERY>
	</CFIF>
	<CFIF IsDefined("Ok")>
		<CFSET StartTime = "#Now()#">
		<CFSTOREDPROC procedure="CAPS_EXPIRYPROCESS" datasource="#Client.database#" returncode="Yes">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No"> 
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@START_YEAR" value="#Trim(FinStart)#" maxlength="10" null="No"> 
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trim(trade_date)#" maxlength="10" null="No"> 
			<CFPROCRESULT name="Mes" resultset="1">
			<CFPROCRESULT name="MissingScripPrices" resultset="2">
		</CFSTOREDPROC>
		
			<CFIF Mes.ERRO EQ 1>
						<P align="center" style="Color: Red;">
							Please Create Settlement For  #trade_date#
						</P>
							<cfabort>
			</cfif>
			<CFIF Mes.ERRO EQ 2>
					<P align="center" style="Color: Red;">
						Bill Alredy Process For  #trade_date#
					</P><cfabort>
			</cfif>
			<CFIF Mes.ERRO EQ 3>
					<P align="center" style="Color: Red;">
						Bill Alredy Process For  #Mes.todate#
					</P><cfabort>
			</cfif>
			<CFIF MissingScripPrices.RecordCount gt 0>
				<table width="450" align="center" border="0" cellpadding="0" cellspacing="0" class="StyleReportParameterTable1">
					<tr>
						<th align="left" style="Color: Red;">
							&nbsp;<u>Prices Missing for following Scrips.</u>
						</th>
						<th align="center" style="Color: Red;">
							<u>MTM Price</u>
						</th>
					</tr>
					<CFLOOP query="MissingScripPrices">
						<form action="Expiry.cfm" method="POST">
							<input type="Hidden" 	name="cocd" 			value="#Trim(COCD)#">
							<input type="Hidden" 	name="coname" 			value="#coname#">
							<input type="Hidden" 	name="market" 			value="#market#">
							<input type="Hidden" 	name="exchange" 		value="#exchange#">
							<input type="Hidden" 	name="broker" 			value="#broker#">
							<input type="Hidden" 	name="trade_date" 		value="#trade_date#">
							<input type="Hidden" 	name="Ok" 				value="Yes">
							<input type="Hidden" 	name="SCRIP_cODE" 	value="#SCRIP_cODE#">
							<input type="Hidden" 	name="SCRIP_NAME" 	value="#SCRIP_NAME#">
							<input type="Hidden" 	name="ISIN" 	value="#ISIN#">
							<input type="Hidden" name="FinStart" value="#FinStart#">
							<input type="Hidden" name="MktDate" value="#Mes.PRICEDATE#">
							<tr>
								<th align="left" height="14"> #SCRIP_cODE# </th>
								<th align="left" height="14"> #Mes.PRICEDATE# </th>
								<th align="center" height="14">
									<input type="Text" name="MTMPrice" value="0" range="0, 9999999" message="Price must be greater than zero." validate="float" required="Yes" size="10" class="StyleTextBox">
								</th>
								<th align="center" height="14">
									<input type="Submit" name="Add" value="Add" class="StyleSmallButton1">
								</th>
							</tr>
						</form>
					</CFLOOP>
				</table>
			<CFELSE>
					<CFIF Mes.ERRO EQ 100>
							Process Completed For #trade_date#<br>
							From Settlement : #Mes.FROMSETL#	<br>
							To Settlement : #Mes.TOSETL#	<br>
							Closing Price Date : #Mes.PRICEDATE#	<br>
					</CFIF>
			</CFIF>
		<CFSET EndTime		=	Now()>
		<CFSET ProcessMin	=	DateDiff( "n", "#StartTime#", "#EndTime#" )>
		<CFSET ProcessSec	=	DateDiff( "s", "#StartTime#", "#EndTime#" )>
		
		<SCRIPT>
			timeBox.style.display				=	"";
			dummy.style.display					=	"None";
			document.EXPForm.processtime.value	=	"#ProcessMin# min. #ProcessSec# sec.";
		</SCRIPT>
	<CFELSE>
		<SCRIPT>
			timeBox.style.display				=	"None";
			dummy.style.display					=	"";
		</SCRIPT>
	</CFIF>
</div>


</CFOUTPUT>
</body>
</html>