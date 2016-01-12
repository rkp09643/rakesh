<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> Bill Cancellation. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
</head>

<body leftmargin="30%" topmargin="30%">
<CFOUTPUT>

<CFQUERY name="IsBillCancelled" datasource="#Client.database#" dbtype="ODBC">
	Select	Count( a.BILL_NO ) BillCnt
	From	TRADE1 a
	Where
				a.COMPANY_CODE			=	'#Trim(COCD)#'
			And	a.MKT_TYPE				=	'#Trim(Mkt_Type)#'
			And	a.BILL_SETTLEMENT_NO	=	#Val(Trim(Settlement_No))#
			<CFIF IsDefined("Client_ID") AND ( Len(Trim(Client_ID)) GT 0 ) AND ( Trim(Client_ID) NEQ "ALL" )>
				And a.Client_ID			=	'#Trim(Client_ID)#'
			</CFIF>
			And a.BILL_NO				<>	0
</CFQUERY>

<CFQUERY name="IsBillCancelled" datasource="#Client.database#" dbtype="ODBC">
	Select	Count(FLG_BILL)BillCnt, 
			Convert(VarChar(10), From_Date, 103)Trade_Date,
			Convert(VarChar(10), getdate(), 103) Current_Date1
	From	SETTLEMENT_MASTER
	Where
				COMPANY_CODE	=	'#Trim(COCD)#'
			And	MKT_TYPE		=	'#Trim(Mkt_Type)#'
			And	SETTLEMENT_NO	=	#Val(Trim(Settlement_No))#
			And FLG_BILL 		= 'Y'

	Group By
			From_Date		
</CFQUERY>

<CFSET	TRANS_DATE		=	IsBillCancelled.Trade_Date>
<CFSET	CURRENT_DATE	=	IsBillCancelled.Current_Date1>

<CFFORM ACTION="BillCancelParameters.cfm" METHOD="POST">
	<input type="Hidden" name="COCD" value="#COCD#">
	<input type="Hidden" name="COName" value="#COName#">
	<input type="Hidden" name="Market" value="#Market#">
	<input type="Hidden" name="Exchange" value="#Exchange#">
	<input type="Hidden" name="Broker" value="#Broker#">
	<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
	<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
	<input type="Hidden" name="Mkt_Type" value="#Trim(Mkt_Type)#">
	<input type="Hidden" name="Settlement_No" value="#Trim(Settlement_No)#">
	<CFINCLUDE TEMPLATE="../../Common/LockingData.cfm">	
</CFFORM>
<cfsavecontent variable="a">
<table align="center" border="0" cellpadding="0" cellspacing="0" class="StyleTable1">
	<tr>
		<th align="center" colspan="2">
			<font color="Fuchsia">
				<CFIF IsBillCancelled.BillCnt GT 0>
					<font color="Green">
						<u>Bill is Cancelled for the following parameters</u>:
					</font>
					<Cfset a = write("Bill Cancelled for the #Trim( UCase( Mkt_Type ) )#-#Val( Trim( Settlement_No) )# #DATEFORMAT(NOW(),'DD/MM/YYYY')# #TIMEFORMAT(NOW(),'HH:MM:SS')#")>
				<CFELSE>
					<font color="Red">
						<br>Bill is already Cancelled for the following parameters. </font>
						<br>&nbsp;&nbsp;
					</font>
				</CFIF>
			</font>
		</th>
	</tr>
	<tr>
		<th align="right"> <br>Market-Type : </th>
		<td align="left"> <br>&nbsp;&nbsp;#Trim( UCase( Mkt_Type ) )# </td>
	</tr>
	<tr>
		<th align="right"> Settlement-No : </th>
		<td align="left"> &nbsp;&nbsp;#Val( Trim( Settlement_No) )# </td>
	</tr>
	<tr>
		<th align="right"> UserName : </th>
		<td align="left"> &nbsp;&nbsp;#Client.username# </td>
	</tr>
	<tr>
		<th align="right"> IPAdd : </th>
		<td align="left"> &nbsp;&nbsp;#cgi.REMOTE_ADDR# </td>
	</tr>
	<CFIF IsDefined("Client_ID") and Client_ID neq ''>
		<tr>
			<th align="right"> Client : </th>
			<td align="left">
				&nbsp;&nbsp;#UCase(Trim(Client_ID))#
			</td>
		</tr>
	</CFIF>
	
	<CFIF IsBillCancelled.BillCnt EQ 0>
		<tr>
			<td align="Center" colspan="2">
				<br><font style="Color : Blue;"> To Cancel another Bill click the link below. </font>
				<br><font style="Cursor : Hand; " 
						onMouseOver="style.color = 'FF0099';" 
						onMouseOut="style.color = 'Navy';" 
						onClick="JavaScript : history.back();"> <b>Back</b> </font>
			</td>
		</tr>
		<CFABORT>
	</CFIF>

	<tr><td colspan="2">&nbsp;  </td></tr>
	<tr>
		<th align="left" colspan="2">
			<font color="Fuchsia">
				<u>Result:</u>
			</font>
		</th>
	</tr>
</table>


<!--- <CFIF Trim( Client_ID ) EQ "ALL">
	<CFSET Client_ID =	"">
</CFIF> --->

<CFSET Client_ID	=	"">
<CFMODULE	Template		=  "BillCancellation.cfm"
			COCD			=	"#Trim(COCD)#" 
			CoName			=	"#Trim(CoName)#" 
			Exchange		=	"#Trim(Exchange)#" 
			Market			=	"#Trim(Market)#" 
			Broker			=	"#Trim(Broker)#" 
			Mkt_Type		=	"#Trim(Mkt_Type)#" 
			Settlement_No	=	"#Val(Trim(Settlement_No))#" 
			Client_ID		=	"#UCase(Trim(Client_ID))#" 
>
<CFSET A = EODProcess("Bill Cancel",'#TRANS_DATE#','#TRANS_DATE#','#cocd#','#mkt_type#','#Val(Trim(Settlement_No))#')>

<table align="center" border="0" cellpadding="0" cellspacing="0" class="StyleTable1">
	<tr>
		<th align="center" colspan="2">
			For Process <a HREF="/FOCAPS/ProcessData/CAPS/CallProcesses.cfm?TemplateName=Trading_CallProcesses&COCD=#COCD#&COName=#COName#&Market=#Market#&Exchange=#Exchange#&Broker=#Broker#&FinStart=#Val(Trim(FinStart))#&FinEnd=#Val(Trim(FinEnd))#&Mkt_Type=#Trim(Mkt_Type)#&Settlement_No=#Trim(Settlement_No)#&BillCancle=1">Click Here</a>
		</th>
	</tr>
</TABLE>	
</cfsavecontent>
#a#
<cfset path = "C:\CFusionMX7\wwwroot\Reports\BillCANCLE\#COCD#_#Mkt_Type#_#Settlement_No#_#TimeFormat(now(),'HHMMSS')#.htm">
<cfset b = FWrite(path,a)>
</CFOUTPUT>
</body>
</html>