<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> List of Scrips available in No-Delivery. </title>
	<link href="/FOCAPS/IO_FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/IO_FOCAPS/CSS/InwardVoucher.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/IO_FOCAPS/CSS/ScreenSettings.css" type="Text/CSS" rel="StyleSheet" media="Screen">
	
	<STYLE>
		DIV#LayerHeading
		{
			Position		:	Absolute;
			Top				:	0;
			Left			:	0;
			Width			:	100%;
		}
		DIV#LayerHeader
		{
			Position		:	Absolute;
			Top				:	7%;
			Left			:	0;
			Width			:	100%;
		}
		DIV#LayerData
		{
			Position		:	Absolute;
			Top				:	13.5%;
			Left			:	0;
			Width			:	100%;
			Height			:	81%;
			Overflow		:	Auto;
		}
		DIV#LayerFooter
		{
			Position		:	Absolute;
			Top				:	94.5%;
			Left			:	0;
			Width			:	100%;
		}
	</STYLE>
</head>

<body leftmargin="0" topmargin="0">
<CFOUTPUT>


<CFIF IsDefined("Process")>
	<CFTRANSACTION>
		<CFTRY>
			<CFIF	Exchange is "BSE">
				<CFSET	PROC_NAME	=	"BSE_ND_MARKING">
			<CFELSE>
				<CFSET	PROC_NAME	=	"NSE_ND_MARKING">	
			</CFIF>
			
			<CFSTOREDPROC procedure="#trim(PROC_NAME)#" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#UCase(Trim(COCD))#" maxlength="8" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#UCase(Trim(Mkt_Type))#" maxlength="4" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SETL_NO" value="#Val(Trim(Settlement_No))#" maxlength="7" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@PROCESS_TYPE" value="#UCase(Trim(Process))#" maxlength="20" null="No">
				<CFPROCPARAM type="Out" cfsqltype="CF_SQL_CHAR" dbvarname="@PROCESS_MSG" variable="ProcessMsg" null="No">
				
				<CFIF Trim(Process) EQ "PreProcessCheck">
					<CFPROCRESULT Name="GetNDScrips">
				</CFIF>
			</CFSTOREDPROC>
			
			<SCRIPT>
				var strUserNotes	=	"";
				
				<CFIF Trim(Process) NEQ "PreProcessCheck">
					<CFIF Trim(ProcessMsg) EQ "0">
						strUserNotes	=	strUserNotes +"<font style='Color : Blue;'> &raquo; Scrips successfully ";
						<CFIF Trim(Process) EQ "Mark">
							strUserNotes	=	strUserNotes +"Marked in ";
						<CFELSEIF Trim(Process) EQ "Unmark">
							strUserNotes	=	strUserNotes +"Unmarked from ";
						</CFIF>
						strUserNotes	=	strUserNotes +"No-Delivery for the Settlement #Trim(Mkt_Type)# / #Trim(Settlement_No)#. </font><br>";
					<CFELSEIF Trim(ProcessMsg) EQ "1">
						strUserNotes	=	strUserNotes +"<font style='Color : Red;'> &raquo; This Settlement ( #Trim(Mkt_Type)# / #Trim(Settlement_No)# ) already Billed.<br>Please cancel the Bill to proceed further. </font><br>";
					<CFELSEIF Trim(ProcessMsg) EQ "2">
						strUserNotes	=	strUserNotes +"<font style='Color : Red;'> &raquo; Scrips NOT available in ND-Database for the Settlement '#Trim(Mkt_Type)# / #Trim(Settlement_No)#'. </font><br>";
					</CFIF>
				</CFIF>
				
				parent.UserNotes.innerHTML	=	strUserNotes;
			</SCRIPT>
		<CFCATCH>
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; #CFCATCH.Detail#<br>Scrips are NOT #Trim(Process)#ed in No-Delivery for the Settlement #Trim(Mkt_Type)# / #Trim(Settlement_No)#. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
			</SCRIPT>
		</CFCATCH>
		</CFTRY>
	</CFTRANSACTION>
</CFIF>
	


<CFIF IsDefined("GetNDScrips") AND GetNDScrips.RecordCount GT 0>
	<CFSET TabWidth			=	"100%">
	
	<CFSET SlNoWidth		=	"5%">
	<CFSET ScripWidth		=	"15%">
	<CFSET ScripNameWidth	=	"40%">
	<CFSET TradeCntWidth	=	"10%">
	<CFSET MarkedFlgWidth	=	"8%">
	<CFSET SetlWidth		=	"15%">
	<CFSET BilledFlgWidth	=	"7%">


	<div align="center" ID="LayerHeading">
		List of Scrips available in No-Delivery:
	</div>
	
	<div align="center" ID="LayerHeader">
		<table ID="PageMainHeaderID" align="Center" width="#TabWidth#" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="Right" width="#SlNoWidth#"> No&nbsp; </td>
				<td align="Left" width="#ScripWidth#"> &nbsp;Scrip </td>
				<td align="Left" width="#ScripNameWidth#"> Scrip-Name </td>
				<td align="Right" width="#TradeCntWidth#"> No-of-Trades </td>
				<td align="Center" width="#MarkedFlgWidth#"> Marked </td>
				<td align="Center" width="#SetlWidth#"> ND-Open-Setl </td>
				<td align="Center" width="#BilledFlgWidth#"> Billed </td>
			</tr>
		</table>
	</div>	


	<div align="center" ID="LayerData">
		<CFSET SlNo				=	0>
		<CFSET TotalTradesCnt	=	0>
		
		<table ID="PageDataID" align="center" width="#TabWidth#" border="0" cellspacing="0" cellpadding="0">
			<CFLOOP Query="GetNDScrips">
				<CFSET SlNo = IncrementValue(SlNo)>
				
				<tr <CFIF UCase(Trim(BILLED)) EQ "Y"> style="Background : LightYellow; Color : Red;" </CFIF> >
					<td align="Right" width="#SlNoWidth#">
						#SlNo#&nbsp;
					</td>
					<td align="Left" width="#ScripWidth#">
						&nbsp;#UCase(Trim(SCRIP))#
					</td>
					<td align="Left" width="#ScripNameWidth#">
						<CFMODULE	Template			=	"/FOCAPS/IO_FOCAPS/Common/ReturnScripNameISIN.cfm" 
									ScripCode			=	"#UCase(Trim(SCRIP))#" 
									GetScripNameAndISIN	=	"No" 
									GetScripName		=	"Yes" 
									GetISIN				=	"No">
						
						#UCase(Trim(ScrName))#
					</td>
					<td align="Right" width="#TradeCntWidth#">
						#Val(Trim(NOOFTRADES))#
						<CFSET TotalTradesCnt	=	TotalTradesCnt	+	Val(Trim(NOOFTRADES))>
					</td>
					<td align="Center" width="#MarkedFlgWidth#">
						#UCase(Trim(MARKED))#
					</td>
					<td align="Center" width="#SetlWidth#">
						#UCase(Trim(NDMKTTYPE))# - #Val(Trim(NDSETLNO))#
					</td>
					<td align="Center" width="#BilledFlgWidth#">
						#UCase(Trim(BILLED))#
					</td>
				</tr>
			</CFLOOP>
		</table>
	</div>


	<div align="center" ID="LayerFooter">
		<table ID="PageMainFooterID" align="center" width="#TabWidth#" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="Right" width="60%"> Total Trades :&nbsp; </td>
				<td align="Right" width="#TradeCntWidth#">
					#Val(TotalTradesCnt)#
				</td>
				<td align="Center" width="#MarkedFlgWidth#">&nbsp;
					
				</td>
				<td align="Center" width="#SetlWidth#">&nbsp;
					
				</td>
				<td align="Center" width="#BilledFlgWidth#">&nbsp;
					
				</td>
			</tr>
		</table>
	</div>
</CFIF>


</CFOUTPUT>
</body>
</html>