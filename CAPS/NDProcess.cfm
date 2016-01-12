<cfinclude template="/focaps/help.cfm">

<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> No-Delivery Marking/Unmarking for <CFOUTPUT>"#UCase(Trim(Exchange))#"</CFOUTPUT> Scrips. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">
	
	<STYLE>
		DIV#LayerHeading
		{
			Position		:	Absolute;
			Top				:	0;
			Left			:	0;
			Width			:	100%;
		}
		DIV#LayerUserNotes
		{
			Font			:	Normal 8pt Verdana;
			Position		:	Absolute;
			Top				:	5%;
			Left			:	5%;
			Width			:	90%;
		}
		DIV#LayerForm
		{
			Position		:	Absolute;
			Top				:	18%;
			Left			:	0;
			Width			:	100%;
			Height			:	22%;
			Overflow		:	Auto;
		}
		DIV#LayerNDScripList
		{
			Position		:	Absolute;
			Top				:	36%;
			Left			:	0;
			Width			:	100%;
			Height			:	64%;
		}
	</STYLE>
	
	<SCRIPT>
		function HideAll( form, tradeCnt )
		{
			with( form )
			{
				Mkt_Type.focus();
				
				if( tradeCnt == 0 )
				{
					UserNotes.innerHTML = "* There are no more Trades available to Mark in No-Delivery.";
					UserNotes.style.color = "Red";
				}
			}
		}
		
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
					
					if( ( i > 6 ) && ( i < 10 ) )
					{
						// GENERALIZED VALIDATION FOR ALL THE FORM FIELDS.
						if( ( fieldValue == "" ) || ( fieldValue.charAt ( 0 ) == " " ) )
						{
							if( fieldName == "Mkt_Type" )
							{
								alert( "Please select a value for the field 'Market-Type'." );
							}
							if( fieldName == "Settlement_No" )
							{
								alert( "Please select a value for the field 'Settlement-No'." );
							}
							
							field.value = "";
							field.focus( );
							return false;
						}
					}
				}
			}
		}
		
		function CallDynamic( form, populateFor )
		{
			if( populateFor == "SetNo" )
			{
				with( form )
				{
					if( ( Mkt_Type.value != "" ) && ( Mkt_Type.value.charAt(0) != " " ) )
					{
				 		parent.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Mkt_Type&MktType=" +Mkt_Type.value +"&SettlementNo=";
					}
					else
					{
						UserNotes.innerHTML = "* Please select a Market-Type.";
						UserNotes.style.color = "Red";
					}
				}
			}
		}
	</SCRIPT>
</head>


<CFOUTPUT>


<CFQUERY name="Markets" datasource="#Client.database#" dbtype="ODBC">
	Select	Distinct
			RTrim( a.MKT_TYPE ) MktType, RTrim( b.DESCRIPTION ) MktTypeDesc
	From	Settlement_Master a, MARKET_TYPE_MASTER b
	Where
				a.MKT_TYPE		=	b.MKT_TYPE
			And	b.MARKET		=	'#Market#'
			And	b.EXCHANGE		=	'#Exchange#'
			And	a.COMPANY_CODE	=	'#COCD#'
			And	B.Nature		!=	'A'
	Order By MktType Desc
</CFQUERY>


<body leftmargin="0" topmargin="0" Class="StyleBody1" onLoad="HideAll( NDProcessForm, '#Val(Markets.RecordCount)#' );">


<div align="center" id="LayerHeading">
	<table width="100%" align="Center" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td width="85%" align="Center">
				<font style="Font : Bold 9pt Tahoma;">
					#RepeatString( "&nbsp;", 30 )#<u>No-Delivery Mark/Unmark</u>
				</font>
			</td>
			<td width="15%" align="Center">
				<font face="Tahoma" size="1" 
					style="Cursor : Hand; Color : Magenta;" title="Click to Add New ND-Data."
					onMouseOver="style.color = 'Green';" onMouseOut="style.color = 'Magenta';"
					onClick="UserNotes.innerHTML = ''; JavaScript : NDScripList.location.href( 'NDMaster.cfm?#Query_String#' );">
						<u><b> Add ND-Data </b></u>
				</font>
			</td>
		</tr>
	</table>
</div>


<div align="Center" id="LayerUserNotes">
	<div id="UserNotes" align="Left">
		
	</div>
</div>


<div align="center" id="LayerForm">
	<CFFORM name="NDProcessForm" action="NDScripList.cfm?#Query_String#" method="POST" onSubmit="return chkForEmptyFields( NDProcessForm );" target="NDScripList">
		<input type="Hidden" name="COCD" value="#COCD#">
		<input type="Hidden" name="COName" value="#COName#">
		<input type="Hidden" name="Market" value="#Market#">
		<input type="Hidden" name="Exchange" value="#Exchange#">
		<input type="Hidden" name="Broker" value="#Broker#">
		<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
		<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
		
		<table align="Center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
			<tr id="row0">
				<th align="Right"> Market-Type : &nbsp; </th>
				<th align="Right">
					<select name="Mkt_Type" Class="clsMktType" onChange="CallDynamic( this.form, 'SetNo');">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Market-Type </option>
						<CFIF Markets.RecordCount GT 0>
							<CFLOOP query="Markets">
								<option value="#Trim(MktType)#"> #Trim(MktType)# - #Trim(MktTypeDesc)# </option>
							</CFLOOP>
						</CFIF>
					</select>
				</th>
			</tr>
			<tr id="row1">
				<th align="Right"> Settlement-No : &nbsp; </th>
				<th align="Right">
					<select name="Settlement_No" class="clsSetlNo">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Settlement-No </option>
					</select>
				</th>
			</tr>
			
			<tr>
				<th colspan="2">&nbsp;
					
				</th>
			</tr>
			<tr id="row2">
				<th colspan="2" align="Right">
					<input type="Submit" name="Process" value="PreProcessCheck" Class="StyleSmallButton1">
					<input type="Submit" name="Process" value="Mark" Class="StyleSmallButton1">
					<input type="Submit" name="Process" value="Unmark" Class="StyleSmallButton1">
					<input type="Button" name="Cancel" value="Cancel" Class="StyleSmallButton1" onClick="UserNotes.innerHTML = ''; JavaScript : location.href( 'NDProcess.cfm?#Query_String#' );">
				</th>
			</tr>
		</table>
	</CFFORM>
</div>


<!--- ***********************************************************
		INLINE FRAME TO DISPLAY SCRIP-LIST.
************************************************************ --->
<div align="Center" id="LayerNDScripList">
	<iframe	name		=	"NDScripList" 
			align		=	"middle" 
			frameborder	=	"0" 
			scrolling	=	"No" 
			width		=	"100%" 
			height		=	"100%" 
			src			=	"NDMaster.cfm?#Query_String#">
	</iframe>
</div>


</body></CFOUTPUT>

</html>