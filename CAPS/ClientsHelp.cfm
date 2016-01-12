<html>
<head>
	<CFOUTPUT>
		<title> #HelpFor# Help </title>
<!--- 		<link href="/FOCAPS/IO_FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet"> --->

	<!--- *************************************************************************************
		INCLUDE JAVASCRIPT FILE FOR POPULATING MARKET-TYPE AND SETTLEMENT NO VALUES IN I/O.
	************************************************************************************** --->
<!--- 	<SCRIPT Src="/FOCAPS/IO_FOCAPS/Scripts/PopulateFieldValues.js" language="JavaScript"></SCRIPT>
 --->		
		<!--- ************************************************
			INCLUDE JAVASCRIPT FILE FOR HELP POPUP WINDOW.
		************************************************* --->
		<!--- <SCRIPT Src="/FOCAPS/IO_FOCAPS/Scripts/HelpValidates.js" language="JavaScript"></SCRIPT> --->
	</CFOUTPUT>
	
	<STYLE>
		DIV#ClientHelpHeading
		{
			Font		:	Bold X-Small Tahoma;
			Color		:	Brown;
			Position	:	Absolute;
			Top			:	0;
			Left		:	0;
			Width		:	100%;
			Height		:	8%;
		}
		DIV#ClientHelpTabHeading
		{
			Position	:	Absolute;
			Top			:	8%;
			Left		:	0;
			Width		:	75%;
			Height		:	7%;
		}
		DIV#ClientHelpData
		{
			Position	:	Absolute;
			Top			:	15.5%;
			Left		:	0;
			Width		:	75%;
			Height		:	84.5%;
			Overflow	:	Auto; 
		}
		DIV#DPIDHelpData
		{
			Position	:	Absolute;
			Top			:	63.5%;
			Left		:	0;
			Width		:	0%;
			Height		:	45.5%;
			Overflow	:	Auto; 
		}
		DIV#ClientHelpSelectedData
		{
			Position	:	Absolute;
			Top			:	11.5%;
			Left		:	76%;
			Width		:	25%;
			Height		:	88.5%;
			Overflow	:	Auto; 
		}
	</STYLE>

<!--- <cfoutput>
<SCRIPT>
	function showDPID( form, Client)
	{
		with( form )
		{
			<CFIF IsDefined("VoucherHelp")>
				ClientHelpData.style.height = "45%";
				ClientHelpSelectedData.style.height = "45%";
				DPIDHelpData.style.width = "97.5%";
<!--- 				parent.DPIDHelp.location.href = "ClientDPHelp.cfm?COCD=" +COCD.value +"&CoName=" +CoName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStYr=" +FinStYr.value +"&FinEndYr=" +FinEndYr.value +"&Client_ID=" +Client +"&Object=ClientDPCode&ObjectName=ClientDPCode&FormName=NewOutwardEntry&Mode=Internal&VoucherHelp=false&HelpFor=DP ID"; --->
			</CFIF>	
		}
	}			
	
	function setData()
	{
		var HelpObject = window.opener.document.forms[ "#FormName#" ].ClientDPCode;
		
		<CFIF IsDefined("VoucherHelp")>
			if( HelpObject.length > 0 )
			{
				ReturnValues( DPIDHelp.DPHelpForm, 'ClientDPCode', '', '#FormName#', 'Radio', 'Replace' );
				ReturnValues( DPIDHelp.DPHelpForm, 'Client_DPCode', '', '#FormName#', 'Radio', 'Replace' );
			}	
		</CFIF>
	}
</script>	
</cfoutput>
 ---></head>

<body bgcolor="Silver" leftmargin="0" rightmargin="0">
<CFOUTPUT>


<CFFORM name="HelpForm" action="ClientsHelp.cfm" method="POST">
	<div align="center" id="ClientHelpHeading">
		<u> #HelpFor# Help </u><p>
		
		<CFPARAM NAME="Frm" DEFAULT="">
		<INPUT TYPE="Hidden" NAME="Frm" VALUE="#Frm#">
		<input type="Hidden" name="COCD" value="#COCD#">
			<CFIF IsDefined("SettNo") AND Trim(SettNo) NEQ "">
				<input type="Hidden" name="SettNo" value="#SettNo#">
			</CFIF>

<!--- 	#SettNo#	<input type="Hidden" name="SettNo" value="#SettNo#"> --->
<!--- 		<input type="Hidden" name="CoName" value="#CoName#">
		<input type="Hidden" name="Market" value="#Market#">
		<input type="Hidden" name="Exchange" value="#Exchange#">
		<input type="Hidden" name="Broker" value="#Broker#">
		<input type="Hidden" name="FinStYr" value="#FinStYr#">
		<input type="Hidden" name="FinEndYr" value="#FinEndYr#"> --->
		<CFIF IsDefined("MktType") AND Trim(MktType) NEQ "">
			<input type="Hidden" name="MktType" value="#MktType#">
		</CFIF>
		<CFIF IsDefined("SetlNo") AND Trim(SetlNo) NEQ "">
			<input type="Hidden" name="SetlNo" value="#SetlNo#">
		</CFIF>
		
		<input type="Hidden" name="HelpFor" value="#HelpFor#">
		<input type="Hidden" name="Object" value="#Object#">
		
		<CFIF IsDefined("ObjectName") AND Trim(ObjectName) NEQ "">
			<input type="Hidden" name="ObjectName" value="#ObjectName#">
		</CFIF>
		<CFIF IsDefined("FormName") AND Trim(FormName) NEQ "">
			<input type="Hidden" name="FormName" value="#FormName#">
		</CFIF>
<!--- 		<CFIF IsDefined("MissingType") AND Trim(MissingType) NEQ "">
			<input type="Hidden" name="MissingType" value="#MissingType#">
		</CFIF>
 --->		<CFIF IsDefined("RecNo") AND Trim(RecNo) NEQ "">
			<input type="Hidden" name="RecNo" value="#RecNo#">
		</CFIF>
<!--- 		<CFIF IsDefined("MissingDPClientCode") AND Trim(MissingDPClientCode) NEQ "">
			<input type="Hidden" name="MissingDPClientCode" value="#MissingDPClientCode#">
		</CFIF>
		<CFIF IsDefined("MissingDPID") AND Trim(MissingDPID) NEQ "">
			<input type="Hidden" name="MissingType" value="#MissingDPID#">
		</CFIF>
		<CFIF IsDefined("VoucherHelp") AND Trim(VoucherHelp) NEQ "">
			<input type="Hidden" name="VoucherHelp" value="#VoucherHelp#">
		</CFIF>
 --->		
		<input type="Hidden" name="Field">
		<input type="Hidden" name="OrderType">
	</div>
	
<!--- 	<CFIF	Not	IsDefined("VoucherHelp")> --->
		<CFQUERY name="GetClientIDs" datasource="#Client.database#" dbtype="ODBC">
				SELECT DISTINCT A.CLIENT_ID ClientID,B.CLIENT_NAME CLIENTNAME FROM TRADE1 A,CLIENT_MASTER B
						WHERE A.CLIENT_ID=B.CLIENT_ID AND A.COMPANY_CODE='#cocd#'
						<!--- AND A.SETTLEMENT_NO=#SettNo# --->
								</CFQUERY>
<!--- 	<cfelse>
		<CFQUERY name="GetClientIDs" datasource="#Client.database#" dbtype="ODBC">
			Select	Distinct
					RTrim(A.CLIENT_ID) ClientID, RTrim(B.CLIENT_NAME) ClientName
			From	IO_DP_MASTER A, CLIENT_MASTER B
			Where	
					B.COMPANY_CODE	=	'#UCase(Trim(COCD))#'
				And A.CLIENT_ID		=	B.CLIENT_ID
			Order By
					<CFIF IsDefined("Field")>
						#Field# #OrderType#
					<CFELSE>
						A.ClientID
					</CFIF>
		</CFQUERY>
	</CFIF>
	<CFIF IsDefined("OrderType") And OrderType EQ "Desc">
		<CFSET OrderType = "Asc">
	<CFELSE>
		<CFSET OrderType = "Desc">
	</CFIF>
 --->	
	
	<div align="Left" id="NotifyUser">
		<CFIF GetClientIDs.RecordCount EQ 0>
			<font style="Color: Green; Font-Weight: Normal;">
				&raquo; There is no Client Data available.
			</font>
		</CFIF>
	</div>
	
	
	<CFIF GetClientIDs.RecordCount GT 0>
<!--- 		<div align="center" id="ClientHelpTabHeading">
			<CFIF IsDefined("Object") AND Object EQ "ClientList">
				<table align="center" width="100%" border="0" cellpadding="0" cellspacing="0" Class="StyleHelpTable" style="Font : Normal 8pt; Color : Purple;">
					<tr>
						<td align="left"> 
							Company : #COCD# - #COName#
						</td>
						<td align="Right" width="24%"> 
							Fin Year : #FinStYr#-#FinEndYr#
						</td>
					</tr>
				</table>
			<CFELSE>
				<br>
			</CFIF>
 --->			
			<table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr bgcolor="Navy" style="Color: White;">
					<CFIF IsDefined("Object") AND Object EQ "ClientList">
						<th align="Center" width="8%" 
							title=" Click to Select All Client-IDs" style="Cursor: Hand;" 
							onMouseOver="style.fontWeight = 'Bold'; style.color = 'Yellow';" 
							onMouseOut="style.fontWeight = 'Normal'; style.color = 'White';" 
							onMouseOut="style.fontWeight = 'Normal'; style.color = 'White';">
							
							<label for="SelectAll">
								<input type="Checkbox" id="SelectAll" name="SelectAll" value="Y" Class="StyleCheckBox" onClick="CheckOneByOne( HelpForm, 'All', 'CheckBox', 'ClientID' );">
								All
							</label>
						</th>
					<CFELSE>
						<th align="Center" width="8%">&nbsp;
							
						</th>
					</CFIF>
					<th align="Right" width="8%"> <u>No</u>&nbsp; </th>
					<th align="Right" width="20%" style="Cursor : Hand;" 
<!--- 						title="Click to Sort Client-ID by <CFIF OrderType EQ 'Asc'> Ascending <CFELSE> Descending </CFIF> Order." 
 --->						onMouseOver="style.fontWeight = 'Bold'; style.color = 'Yellow';" 
						onMouseOut="style.fontWeight = 'Normal'; style.color = 'White';" 
<!--- 						onClick="HelpForm.Field.value = 'ClientID'; HelpForm.OrderType.value = '#OrderType#'; HelpForm.submit();" --->
							onClick="HelpForm.Field.value = 'ClientID'; HelpForm.submit();"
					>
						<u>Client-ID </u>&nbsp;
					</th>
					<th align="Left" style="Cursor : Hand;" 
<!--- 						title="Click to Sort Client-Name by <CFIF OrderType EQ 'Asc'> Ascending <CFELSE> Descending </CFIF> Order." 
 --->						title="Click to Sort Client-Name by Order." 
						onMouseOver="style.fontWeight = 'Bold'; style.color = 'Yellow';" 
						onMouseOut="style.fontWeight = 'Normal'; style.color = 'White';" 
<!--- 						onClick="HelpForm.Field.value = 'ClientName'; HelpForm.OrderType.value = '#OrderType#'; HelpForm.submit()" --->
						onClick="HelpForm.Field.value = 'ClientName'; HelpForm.submit()"
					>
						&nbsp;<u>Client-Name </u>
					</th>
				</tr>
			</table>
		</div>
		
		<div align="center" id="ClientHelpData">
			<table align="center" width="100%" border="0" cellpadding="0" cellspacing="0" Class="StyleHelpTable">
				<CFLOOP Query="GetClientIDs">
					<tr style="Cursor : Hand;" 
						OnClick="showDPID( HelpForm, '#ClientID#' );"
						onMouseOver="bgColor = 'FFEEFF'; style.fontWeight = 'Bold'; style.color = 'Magenta';" 
						onMouseOut="bgColor = 'Transparent'; style.fontWeight = 'Normal'; style.color = 'Blue';"
					>
						<label for="#ClientID#">
							<th align="Center" width="8%">
								<CFIF IsDefined("Object") AND Object EQ "ClientList">
									<input type="Checkbox" id="#ClientID#" name="ClientID" value="#ClientID#" Class="StyleCheckBox" onClick="CheckOneByOne( this.form, this.value, 'CheckBox' );">
									<CFSET ObjectType = "CheckBox">
								<CFELSEIF IsDefined("Object") AND Object EQ "ClientID">
									<input type="Radio" id="#ClientID#" name="ClientID" value="#ClientID#" Class="StyleRadio" onClick="CheckOneByOne( this.form, this.value, 'Radio' );">
									<CFSET ObjectType = "Radio">
								</CFIF>
							</th>
							<td align="Right" width="8%"> #CurrentRow#&nbsp; </td>
							<td align="Right" width="20%"> #ClientID#&nbsp; </td>
							<td align="Left"> &nbsp;#ClientName# </td>
						</label>
					</tr>
				</CFLOOP>
			</table>
		</div>
		
<!--- 		<div id="DPIDHelpData">
			<iframe name="DPIDHelp" width="700" height="180" frameborder="0"></iframe>
		</div>
		
		<div align="center" id="ClientHelpSelectedData">
			<table align="center" width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<th align="center">
						<CFIF ObjectType EQ "Radio">							
							<CFIF IsDefined("MissingType") AND Trim(MissingType) NEQ "">
								<CFSET Object1		=	"#Object##RecNo#">
								<CFSET ObjectName	=	"#ObjectName##RecNo#">
								<input type="Button" name="Replace" value="Done" Class="StyleButton" onClick="ReturnValues( this.form, '#Object1#', '#ObjectName#', '#FormName#', '#ObjectType#', 'Replace' );">
							<CFELSEIF Frm EQ "VoucherView">
								<input type="Button" name="Replace" value="Done" Class="StyleButton" onClick="ReturnValues( VoucherView, '#Object1#', '#ObjectName#', '#FormName#', '#ObjectType#', 'Replace' );">
							<CFELSE>
								<input type="Button" name="Replace" value="Done" Class="StyleButton" onclick="ReturnValues( this.form, '#Object#', '', '#FormName#', '#ObjectType#', 'Replace' ); setData();">
							</CFIF>
						<CFELSE>
							<input type="Button" name="Append" value="Append" Class="StyleButton" onClick="ReturnValues( this.form, '#Object#', '', '#FormName#', '#ObjectType#', 'Append' );">
							<input type="Button" name="Replace" value="Replace" Class="StyleButton" onClick="ReturnValues( this.form, '#Object#', '', '#FormName#', '#ObjectType#', 'Replace' );">
						</CFIF>
					</th>
				</tr>
				<tr>
					<th align="center"> <u style="Color : Teal;"> Selected Items: </u> </th>
				</tr>
				<tr>
					<th align="center">
						<CFIF Trim(ObjectType) EQ "Radio">
							<CFSET SelectedObjHeight = "30">
						<CFELSE>
							<CFSET SelectedObjHeight = "350">
						</CFIF>
						
						<CFIF IsDefined("SelectedValues")>
							<select name="SelectedValues" value="#SelectedValues#" Multiple style="Border: 1px Solid Maroon; Width: 150; Height: #SelectedObjHeight#; Font-Family: Arial; Font-Size: 9pt; Font-Weight: Bold; Color: Green;">
							</select>
						<CFELSE>
							<select name="SelectedValues" Multiple style="Border: 1px Solid Maroon; Width: 150; Height: #SelectedObjHeight#; Font-Family: Arial; Font-Size: 9pt; Font-Weight: Bold; Color: Green;">
						    </select>
						</CFIF>
					</th>
				</tr>
			</table>
		</div>
 --->	</CFIF>
</CFFORM>


</CFOUTPUT>
</body>
</html>