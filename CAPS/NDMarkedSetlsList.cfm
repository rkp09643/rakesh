<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> List of Settlements Marked in No-Delivery. </title>
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
			Top				:	27%;
			Left			:	0;
			Width			:	100%;
		}
		DIV#LayerData
		{
			Position		:	Absolute;
			Top				:	34%;
			Left			:	0;
			Width			:	100%;
			Height			:	78%;
			Overflow		:	Auto;
		}
	</STYLE>
</head>

<body leftmargin="0" topmargin="0">
<CFOUTPUT>


<CFIF IsDefined("ListNDMarkedSetls") AND ListLen(ListNDMarkedSetls) GT 0>
	<CFSET TabWidth			=	"50%">
	
	<CFSET SlNoWidth		=	"5%">
	<CFSET SetlWidth		=	"15%">
	
	<div align="center" ID="LayerHeading">
		<table align="Center" width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="Center" colspan="2">
					List of Settlements Marked in No-Delivery for the following parameters:
				</td>
			</tr>
			<tr>
				<td align="Right" width="50%">
					Scrip : &nbsp;
				</td>
				<td align="Left" width="50%" style="Color : Magenta;">
					#Scrip#
				</td>
			</tr>
			<tr>
				<td align="Right" width="50%">
					Date : &nbsp;
				</td>
				<td align="Left" width="50%" style="Color : Magenta;">
					#FromDate# - #ToDate#
				</td>
			</tr>
			<tr>
				<td align="Right" width="50%">
					ND-Open-Setl : &nbsp;
				</td>
				<td align="Left" width="50%" style="Color : Magenta;">
					#NDOMktType# - #NDOSetlNo#
				</td>
			</tr>
		</table>
	</div>
	
	<div align="center" ID="LayerHeader">
		<table ID="PageMainHeaderID" align="Center" width="#TabWidth#" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td align="Right" width="#SlNoWidth#"> No&nbsp; </td>
				<td align="Center" width="#SetlWidth#"> Settlement </td>
			</tr>
		</table>
	</div>	


	<div align="center" ID="LayerData">
		<CFSET SlNo				=	0>
		
		<table ID="PageDataID" align="center" width="#TabWidth#" border="0" cellspacing="0" cellpadding="0">
			<CFLOOP index="i" from="1" to="#ListLen(ListNDMarkedSetls)#">
				<CFSET SlNo = IncrementValue(SlNo)>
				
				<tr>
					<td align="Right" width="#SlNoWidth#">
						#SlNo#&nbsp;
					</td>
					<td align="Center" width="#SetlWidth#">
						#ListGetAt( ListNDMarkedSetls, i )#
					</td>
				</tr>
			</CFLOOP>
		</table>
	</div>
</CFIF>


</CFOUTPUT>
</body>
</html>