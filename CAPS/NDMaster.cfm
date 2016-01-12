<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> No-Delivery Mark/Unmark Data-Entry Screen. </title>
	<link href="/FOCAPS/IO_FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/IO_FOCAPS/CSS/InwardVoucher.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/IO_FOCAPS/CSS/ScreenSettings.css" type="Text/CSS" rel="StyleSheet" media="Screen">
	<link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">
	
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
			Height			:	50%;
			Overflow		:	Auto;
		}
		DIV#AddNDMaster
		{
			Position		:	Absolute;
			Top				:	65%;
			Left			:	0;
			Width			:	100%;
			Height			:	35%;
			Background		:	ECECFF;
		}
	</STYLE>
	
	<SCRIPT>
		function chkForEmptyFields( form )
		{
			var field, fieldName, fieldValue, fieldsCount;
			
			with( form )
			{
				fieldsCount = elements.length;
				
				for( i = 0; i < fieldsCount; i++ )
				{
					field = elements[ i ];
					fieldName = field.name;
					fieldValue = field.value;
					
					if( ( i > 8 ) && ( i < 14 ) )
					{
						// GENERALIZED VALIDATION FOR ALL THE FORM FIELDS.
						if( ( fieldValue == "" ) || ( fieldValue.charAt( 0 ) == " " ) )
						{
							if( fieldName == "ScripSymbol" )
							{
								alert( "Please enter a value for the field 'Scrip-Symbol'." );
							}
							
							if( Exchange.value == "NSE"  )
							{
								if( fieldName == "FromDate" )
								{
									alert( "Please enter a value for the field 'From-Date'." );
								}
								if( fieldName == "ToDate" )
								{
									alert( "Please enter a value for the field 'To-Date'." );
								}
							}
							
							if( fieldName == "NDMktType" )
							{
								if( Exchange.value == "NSE"  )
								{
									alert( "Please select a value for the field 'ND-Open Market-Type'." );
								}
								else if( Exchange.value == "BSE"  )
								{
									alert( "Please select a value for the field 'From Market-Type'." );
								}
							}
							if( fieldName == "NDSetlNo" )
							{
								if( Exchange.value == "NSE"  )
								{
									alert( "Please enter a value for the field 'ND-Open Settlement-No'." );
								}
								else if( Exchange.value == "BSE"  )
								{
									alert( "Please enter a value for the field 'From Settlement-No'." );
								}
							}
							
							if( Exchange.value == "BSE"  )
							{
								if( fieldName == "ClosingPrice" )
								{
									alert( "Please enter a value for the field 'Closing-Price'." );
								}
								if( fieldName == "CFSetlNo" )
								{
									alert( "Please enter a value for the field 'Carry-Forward Settlement-No'." );
								}
							}
							
							field.value = "";
							field.focus( );
							return false;
						}
					}
				}
			}
		}
		
		//	FUNCTION FOR MODIFYING ND-DATA RECORDS.
		function modifyNDScrips( form, xchng, recNo, scrip, frDate, toDate, ndORFromMktType, ndORFromSetlNo, clsgPrice, cfSetlNo )
		{
			AddNDDataRow.style.display		=	"None";
			ModifyNDDataRow.style.display	=	"";
			
			with( form )
			{
				RecordNo.value			=	recNo;
				
				ScripSymbol.value		=	scrip;
				ScripSymbol.readOnly	=	true;
				
				if( xchng == "NSE"  )
				{
					FromDate.value		=	frDate;
					FromDate.readOnly	=	true;
					OldToDate.value		=	toDate
					ToDate.value		=	toDate;
				}
				
				OldNDMktType.value		=	ndORFromMktType;
				NDMktType.value			=	ndORFromMktType;
				OldNDSetlNo.value		=	ndORFromSetlNo;
				NDSetlNo.value			=	ndORFromSetlNo;
				
				if( xchng == "BSE"  )
				{
					ClosingPrice.value	=	clsgPrice;
					CFSetlNo.value		=	cfSetlNo;
				}
			}
		}
	</SCRIPT>
	
	<!--- ***********************************************************
			INCLUDE JAVASCRIPT FILE FOR CHECKING NUMERIC VALUES.
	************************************************************ --->
	<SCRIPT src="/FOCAPS/Common/Scripts/CheckForNumbers.js" language="JavaScript"></SCRIPT>
</head>

<!--- ***********************************************************
		INCLUDE VBSCRIPT FILE FOR CHECKING DATE VALUES.
************************************************************ --->
<SCRIPT src="/FOCAPS/Common/Scripts/CheckForDates.vbs" language="VBScript"></SCRIPT>


<CFQUERY name="Markets" datasource="#Client.database#" dbtype="ODBC">
	Select	Distinct
			RTrim( a.MKT_TYPE ) MktType, RTrim( b.DESCRIPTION ) MktTypeDesc
	From	Settlement_Master a, MARKET_TYPE_MASTER b
	Where
			a.COMPANY_CODE		=	'#COCD#'
			And	b.MARKET		=	'#Market#'
			And	b.EXCHANGE		=	'#Exchange#'
			And	a.MKT_TYPE		=	b.MKT_TYPE
	Order By MktType Desc
</CFQUERY>


<body leftmargin="0" topmargin="0" onLoad="NDMasterForm.ScripSymbol.focus(); AddNDDataRow.style.display = ''; ModifyNDDataRow.style.display = 'None';">
<CFOUTPUT>


<CFSET TabWidth			=	"100%">

<CFSET SlNoWidth		=	"5%">
<CFSET ScripWidth		=	"15%">
<CFIF Trim(Exchange) EQ "NSE">
	<CFSET ScripNameWidth	=	"8%">
<CFELSE>
	<CFSET ScripNameWidth	=	"41%">
</CFIF>
<CFSET FromDateWidth	=	"20%">
<CFSET ToDateWidth		=	"20%">
<CFSET SetlWidth		=	"20%">

<CFSET FromSetlWidth	=	"15%">
<CFSET ClsgPriceWidth	=	"12%">
<CFSET CFSetlNoWidth	=	"12%">


<div id="LayerHeading" align="center">
	<TABLE WIDTH="100%">
		<TR ALIGN="CENTER">
			<TH ALIGN="CENTER">
				No-Delivery Mark/Unmark Data-Entry Screen.
			</TH>
			<TH ALIGN="RIGHT">
				<A HREF="ImportNDMaster.cfm?#QUERY_STRING#" TARGET="Display">Import ND</A>
			</TH>	
		</TR>
	</TABLE>
</div>

<!--- *********************************************************
				SHOW ALL ND-SCRIP LIST.
********************************************************** --->
<cfquery name="NDScripList" datasource="#Client.database#" dbtype="ODBC">
	Select	*
	From	#UCase(Trim(Exchange))#_ND_MASTER
	Where	COMPANY_CODE	=	'#Trim(COCD)#'
	Order By
			<CFIF Trim(Exchange) EQ "NSE">
				FROM_DATE Desc
			<CFELSEIF Trim(Exchange) EQ "BSE">
				SETL_NO Desc
			</CFIF>
</cfquery>

<CFIF NDScripList.RecordCount GT 0>
	<div id="LayerHeader">
		<table ID="PageMainHeaderID" width="#TabWidth#" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td align="Right" width="#SlNoWidth#"> No&nbsp; </th>
				<td align="Left" width="#ScripWidth#"> &nbsp;Scrip </th>
				<td align="Left" width="#ScripNameWidth#"> Scrip-Name </td>
				<CFIF Trim(Exchange) EQ "NSE">
					<td align="Center" width="#FromDateWidth#"> From-Date </th>
					<td align="Center" width="#ToDateWidth#"> To-Date </th>
					<td align="Center" width="#SetlWidth#"> ND-Close-Setl </th>
				<CFELSEIF Trim(Exchange) EQ "BSE">
					<td align="Center" width="#FromSetlWidth#"> From-Setl </th>
					<td align="Right" width="#ClsgPriceWidth#"> Closing-Price </th>
					<td align="Center" width="#CFSetlNoWidth#"> CF-Setl-No </th>
				</CFIF>
			</tr>
		</table>
	</div>
<CFELSE>
	<SCRIPT>
		var strUserNotes	=	"";
		strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; There is no ND-Data available to View. </font><br>";
		
		parent.UserNotes.innerHTML	=	strUserNotes;
	</SCRIPT>
</CFIF>


<div id="LayerData">
	<table ID="PageDataID" width="#TabWidth#" align="Center" border="0" cellpadding="0" cellspacing="0">
		<CFSET SlNo = 0>
		
		<CFLOOP query="NDScripList">
			<CFSET SlNo = IncrementValue(SlNo)>	
			
			<tr	style="Cursor : Hand;" title="Click to Modify No-Delivery Data." 
				<CFIF Trim(Exchange) EQ "NSE">
					onclick="modifyNDScrips( NDMasterForm, '#UCase(Trim(Exchange))#', '#Val(Trim(REC_NO))#', '#UCase(Trim(SCRIP_SYMBOL))#', '#DateFormat(FROM_DATE, "DD/MM/YYYY")#', '#DateFormat(TO_DATE, "DD/MM/YYYY")#', '#UCase(Trim(NDOPEN_MKT_TYPE))#', '#Val(Trim(NDOPEN_SETL_NO))#', '', '' );" onMouseOver="bgColor = 'Pink';" onMouseOut="bgColor = 'White';"
				<CFELSEIF Trim(Exchange) EQ "BSE">
					onclick="modifyNDScrips( NDMasterForm, '#UCase(Trim(Exchange))#', '#Val(Trim(REC_NO))#', '#UCase(Trim(SCRIP_SYMBOL))#', '', '', '#UCase(Trim(MKT_TYPE))#', '#Val(Trim(SETL_NO))#', '#Val(Trim(CLOSING_PRICE))#', '#Val(Trim(CF_SETL_NO))#' );" onMouseOver="bgColor = 'Pink';" onMouseOut="bgColor = 'White';"
				</CFIF>
			>
				<td align="Right" width="#SlNoWidth#">
					#SlNo#&nbsp;
				</td>
				<td align="Left" width="#ScripWidth#">
					&nbsp;#UCase(Trim(SCRIP_SYMBOL))#
				</td>
				<td align="Left" width="#ScripNameWidth#">
					<CFMODULE	Template			=	"/FOCAPS/IO_FOCAPS/Common/ReturnScripNameISIN.cfm" 
								ScripCode			=	"#UCase(Trim(SCRIP_SYMBOL))#" 
								GetScripNameAndISIN	=	"No" 
								GetScripName		=	"Yes" 
								GetISIN				=	"No">
					<CFIF Trim(ScrName) EQ "">
						<b>INVALID SCRIP</b>
					<CFELSEIF  Trim(Exchange) EQ "NSE">
						#LEFT(UCase(Trim(ScrName)),10)#
					<CFELSEIF  Trim(Exchange) EQ "BSE">
						#UCase(Trim(ScrName))#
					</CFIF>
				</td>
				<CFIF Trim(Exchange) EQ "NSE">
					<CFQUERY NAME="GetFromSettlement" datasource="#Client.database#">
						Select Settlement_No
						From
								Settlement_Master
						Where
								Company_Code	=	'#Trim(COCD)#'
						And		Convert(Datetime, From_Date, 103)	=	'#From_Date#'
						AND MKT_TYPE IN ('N','T')
					</CFQUERY>
					<td align="LEFT" width="#FromDateWidth#">
						#DateFormat(FROM_DATE, "DD/MM/YYYY")#(#GetFromSettlement.Settlement_No#)
					</td>
					<CFQUERY NAME="GetToSettlement" datasource="#Client.database#">
						Select Settlement_No
						From
								Settlement_Master
						Where
								Company_Code	=	'#Trim(COCD)#'
						And		Convert(Datetime, From_Date, 103)	=	'#To_Date#'
												AND MKT_TYPE IN ('N','T')
					</CFQUERY>
					<td align="LEFT" width="#ToDateWidth#">
						#DateFormat(TO_DATE, "DD/MM/YYYY")#(#GetToSettlement.Settlement_No#)
					</td>
					<CFQUERY NAME="GetToSettlementDate" datasource="#Client.database#">
						Select 	Convert(VarChar(10), From_Date, 103)From_Date
						From
								Settlement_Master
						Where
								Company_Code	=	'#Trim(COCD)#'
						And		Mkt_Type		=	'#UCase(Trim(NDOPEN_MKT_TYPE))#'
						And		Settlement_No	=	#Val(Trim(NDOPEN_SETL_NO))#
					</CFQUERY>
					<td align="LEFT" width="#SetlWidth#">
						#UCase(Trim(NDOPEN_MKT_TYPE))# - #Val(Trim(NDOPEN_SETL_NO))#(#GetToSettlementDate.From_Date#)
					</td>
				<CFELSEIF Trim(Exchange) EQ "BSE">
					<td align="Center" width="#FromSetlWidth#">
						#UCase(Trim(MKT_TYPE))# - #Val(Trim(SETL_NO))#
					</td>
					<td align="Right" width="#ClsgPriceWidth#">
						#Val(Trim(CLOSING_PRICE))#
					</td>
					<td align="Center" width="#CFSetlNoWidth#">
						#Val(Trim(CF_SETL_NO))#
					</td>
				</CFIF>
			</tr>
		</CFLOOP>
	</table>
</div>


<div align="center" id="AddNDMaster">
	<CFFORM name="NDMasterForm" action="Manipulate#Exchange#NDMaster.cfm?#Query_String#" method="POST" onSubmit="return chkForEmptyFields( NDMasterForm );">
		<table align="center" border="0" cellpadding="0" cellspacing="0" Class="StyleTable1">
			<input type="Hidden" name="COCD" value="#Trim(UCase(COCD))#">
			<input type="Hidden" name="CoName" value="#Trim(UCase(CoName))#">
			<input type="Hidden" name="Market" value="#Trim(UCase(Market))#">
			<input type="Hidden" name="Exchange" value="#Trim(UCase(Exchange))#">
			<input type="Hidden" name="Broker" value="#Trim(UCase(Broker))#">
			
			<input type="Hidden" name="RecordNo">
			<input type="Hidden" name="OldToDate">
			<input type="Hidden" name="OldNDMktType">
			<input type="Hidden" name="OldNDSetlNo">
			
			<tr ID="ScripRow">
				<td align="Right">
					Scrip-Symbol :&nbsp;
				</td>
				<td align="Right" colspan="3">
					<input type="Text" name="ScripSymbol" message="Please enter a valid 'Scrip-Symbol'." required="Yes" size="15" maxlength="15" class="StyleUCaseTextBox">
				</td>
			</tr>
			<CFIF Trim(Exchange) EQ "NSE">
				<tr ID="DateRow">
					<td align="Right">
						From-Date :&nbsp;
					</td>
					<td align="Left">
						<input type="Text" name="FromDate" value="#DateFormat(Now(), 'DD/MM/YYYY')#" message="Please enter a valid 'From-Date'." validate="eurodate" required="Yes" size="15" maxlength="10" class="StyleTextBox" onBlur="chkForDates( this, this.form );">
					</td>
			
					<td align="Right">
						To-Date :&nbsp;
					</td>
					<td align="Left">
						<input type="Text" name="ToDate" message="Please enter a valid 'To-Date'" validate="eurodate" required="Yes" size="15" maxlength="10" class="StyleTextBox" onBlur="chkForDates( this, this.form );">
					</td>
				</tr>
			</CFIF>
			<tr ID="MktSetlRow">
				<td align="Right">
					<CFIF Trim(Exchange) EQ "NSE">
						ND-Open-Settlement :&nbsp;
					<CFELSEIF Trim(Exchange) EQ "BSE">
						From-Settlement :&nbsp;
					</CFIF>
				</td>
				<td align="Left" colspan="2">
					<select name="NDMktType" Class="clsMktType">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Market-Type </option>
						<CFIF Markets.RecordCount GT 0>
							<CFLOOP query="Markets">
								<option value="#UCase(Trim(MktType))#"> #UCase(Trim(MktType))# - #UCase(Trim(MktTypeDesc))# </option>
							</CFLOOP>
						</CFIF>
					</select>
				</td>
				
				<td align="Right">
					<input type="Text" name="NDSetlNo" message="Please enter a valid 'ND-Open-Setl-No'." required="Yes" size="15" maxlength="7" class="StyleTextBox">
				</td>
			</tr>
			<CFIF Trim(Exchange) EQ "BSE">
				<tr ID="DateRow">
					<td align="Right">
						Closing-Price :&nbsp;
					</td>
					<td align="Left">
						<input type="Text" name="ClosingPrice" message="Please enter a valid 'Closing-Price'." required="Yes" size="15" maxlength="15" class="StyleTextBox">
					</td>
					
					<td align="Right">
						CF-Setl :&nbsp;
					</td>
					<td align="Right">
						<input type="Text" name="CFSetlNo" message="Please enter a valid 'Carry-Forward-Setl-No'." required="Yes" size="15" maxlength="7" class="StyleTextBox">
					</td>
				</tr>
			</CFIF>
			
			<tr>
				<td colspan="4">&nbsp;
					
				</td>
			</tr>
			<tr id="AddNDDataRow">
				<td align="right" colspan="4">
					<input type="Submit" accesskey="S" name="Save" value="Save" class="StyleButton">
					<input type="Button" accesskey="C" name="Cancel" value="Cancel" class="StyleButton" onClick="parent.UserNotes.innerHTML = ''; JavaScript : location.href( 'NDMaster.cfm?#Query_String#' );">
				</td>
			</tr>
			<tr id="ModifyNDDataRow">
				<td align="right" colspan="4">
					<input type="Submit" accesskey="U" name="Update" value="Update" class="StyleButton">
					<input type="Submit" accesskey="D" name="Delete" value="Delete" class="StyleButton">
					<input type="Button" accesskey="C" name="Cancel" value="Cancel" class="StyleButton" onClick="parent.UserNotes.innerHTML = ''; JavaScript : location.href( 'NDMaster.cfm?#Query_String#' );">
				</td>
			</tr>
		</table>
	</CFFORM>
</div>


</CFOUTPUT>
</body>
</html>