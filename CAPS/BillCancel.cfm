<cfinclude template="/focaps/help.cfm">
<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->

<html>
<head>
	<title> Bill Cancellation. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">
	
	<SCRIPT>
		function HideAll( form, billCnt )
		{
			with( form )
			{
				Mkt_Type.focus();
				
				if( billCnt > 0 )
				{
					MsgRow.style.display = "None";
				}
				else
				{
					MsgRow.style.display = "";
					Msg.style.color = "Red";
					Msg.value = "* There are no more Bills available to Cancel.";
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
							if( fieldName == "Client_ID" )
							{
								alert( "Please select a value for the field 'Client-ID'." );
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
			with( form )
			{
				if( populateFor == "SetNo" )
				{
					if( ( Mkt_Type.value != "" ) && ( Mkt_Type.value.charAt(0) != " " ) )
					{
						Msg.value = "";
				 		parent.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Mkt_Type&MktType=" +Mkt_Type.value +"&SettlementNo=";
					}
					else
					{
						MsgRow.style.display = "";
						Msg.value = "* Please select a Market-Type.";
						Msg.style.color = "Red";
						
						Settlement_No.options.length = 0;
						Settlement_No.options[ Settlement_No.options.length ] = new Option( "Select a Settlement-No", "" );
						Settlement_No.options[ Settlement_No.options.length - 1 ].style.background = "LightYellow";
						Settlement_No.options[ Settlement_No.options.length - 1 ].style.color = "Green";
						
/*
						Client_ID.options.length = 0;
						Client_ID.options[ Client_ID.options.length ] = new Option( "Select a Client-ID", "" );
						Client_ID.options[ Client_ID.options.length - 1 ].style.background = "LightYellow";
						Client_ID.options[ Client_ID.options.length - 1 ].style.color = "Green";
*/
					}
				}
				if( populateFor == "ClID" )
				{
					if( ( Settlement_No.value != "" ) && ( Settlement_No.value.charAt(0) != " " ) )
					{
						Msg.value	=	"";
				 		//parent.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value +"&SettlementNo=" +Settlement_No.value;
					}
					else
					{
						MsgRow.style.display = "";
						Msg.value = "* Please select a Settlement-No.";
						Msg.style.color = "Red";
						
/*
						Client_ID.options.length = 0;
						Client_ID.options[ Client_ID.options.length ] = new Option( "Select a Client-ID", "" );
						Client_ID.options[ Client_ID.options.length - 1 ].style.background = "LightYellow";
						Client_ID.options[ Client_ID.options.length - 1 ].style.color = "Green";
*/
					}
				}
				
				if( populateFor == "ValidateSettlement" )
				{
					if( ( Settlement_No.value != "" ) && ( Settlement_No.value.charAt(0) != " " ) )
					{
						Msg.value	=	"";
				 		//parent.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value +"&SettlementNo=" +Settlement_No.value;
					}
					else
					{
						MsgRow.style.display = "";
						Msg.value = "* Please select a Settlement-No.";
						Msg.style.color = "Red";
						
/*
						Client_ID.options.length = 0;
						Client_ID.options[ Client_ID.options.length ] = new Option( "Select a Client-ID", "" );
						Client_ID.options[ Client_ID.options.length - 1 ].style.background = "LightYellow";
						Client_ID.options[ Client_ID.options.length - 1 ].style.color = "Green";
*/
					}
				}
				
				if( populateFor == "None" )
				{
					if( ( Client_ID.value != "" ) && ( Client_ID.value.charAt(0) != " " ) )
					{
						Msg.value = "";
					}
					else
					{
						MsgRow.style.display = "";
						Msg.value = "* Please select a Client-ID.";
						Msg.style.color = "Red";
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
	From	SETTLEMENT_MASTER a, MARKET_TYPE_MASTER b
	Where
			a.COMPANY_CODE		=	'#Trim(COCD)#'
			And	a.MARKET		=	b.MARKET
			And	a.EXCHANGE		=	b.EXCHANGE
			And	a.MKT_TYPE		=	b.MKT_TYPE
			And	a.MARKET		=	'#Trim(Market)#'
			And	a.EXCHANGE		=	'#Trim(Exchange)#'
			And a.FLG_BILL		=	'Y'
	Order By MktType Desc
</CFQUERY>


<body id="BillCan" leftmargin="0" rightmargin="0" Class="StyleBody1" onLoad="HideAll( BillCancelForm, '#Val(Markets.RecordCount)#' );">


<div align="center" id="Heading">
	<u>Bill Cancellation Parameters</u>
</div>

<div align="center" id="Forms">

	<CFFORM name="BillCancelForm" action="BillCancelParameters.cfm?#Query_String#" method="POST" onSubmit="return chkForEmptyFields( BillCancelForm );">
		<input type="Hidden" name="COCD" value="#COCD#">
		<input type="Hidden" name="COName" value="#COName#">
		<input type="Hidden" name="Market" value="#Market#">
		<input type="Hidden" name="Exchange" value="#Exchange#">
		<input type="Hidden" name="Broker" value="#Broker#">
		<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
		<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
		<input type="Hidden" name="Ok1" value="">
		<table align="center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
			<tr id="row0">
				<th align="Right"> Market-Type : &nbsp; </th>
				<th align="Left">
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
				<th align="Left">
					<select name="Settlement_No" class="clsSetlNo" onChange="CallDynamic( this.form, 'ClID' );">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Settlement-No </option>
					</select>
				</th>
			</tr>
<!--- 			<tr id="row2">
				<th align="right"> Client-ID : &nbsp; </th>
				<th align="left">
					<select name="Client_ID" class="clsCltID" onChange="CallDynamic( this.form, 'None' );">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Client-ID </option>
					</select>
				</th>
			</tr> --->
	
			<tr>
				<th colspan="2">&nbsp;
					
				</th>
			</tr>
			<tr id="row3">
				<th colspan="2" align="Right">
					<input type="Submit" name="Ok" value="Cancel Bill" class="StyleSmallButton1" accesskey="C" onClick="this.disabled=true; MsgRow.style.display=''; this.form.submit();">
<!--- 					<input type="Button" name="Cancel" value="Clear" class="StyleSmallButton1" accesskey="R" onClick="JavaScript : location.href( 'BillCancel.cfm?#Query_String#' );"> --->
				</th>
			</tr>
		</table>
		
		<table id="MsgRow" align="center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
			<tr>
				<td>
					<br><br><br><br>
					<input type="Text" name="Msg" value="Cancelling Bill, please wait ...." size="100" ReadOnly style="Background : Transparent; Border : None; Font : Normal 9pt Tahoma; Text-Align : Center; Color: Green;">
				</td>
			</tr>
		</table>
	</CFFORM>

</div>


</body>
</CFOUTPUT>
</html>