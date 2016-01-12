<cfinclude template="/focaps/help.cfm">

<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> Process Parameter Screen. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">

	<cfparam name="PartialBill" default="No">

<cfoutput>
	<script>
		// THIS FUNCTION USED FOR GIVING MSG. IF NO MORE SETTLEMENTS AVAILABLE.
		function HideAll( form, setlCnt )
		{
			with( form )
			{
				Mkt_Type.focus();
				
				if( setlCnt > 0 )
				{
					MsgRow.style.display = "None";
				}
				else
				{
					MsgRow.style.display = "";
					Msg.style.color = "Red";
					Msg.value = "* There are no more Settlements available to Process further.";
				}
				rowRemPro.disabled = true;
			}
		}
		
		function checkForValidity( form )
		{
			with( form )
			{
				if( chkForEmptyFields( form ) )
				{
					btnProcess.disabled	=	true;
					btnCancel.disabled	=	true;
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		// ****************NOT UNDERSTAND****************
		function chkForEmptyFields( form )
		{
			var field, fieldName, fieldValue, fieldsCount;
			var flgReturn	=	false;
			
			with( form )
			{
				fieldsCount = elements.length;
				
				for( i = 0; i < fieldsCount; i++ )
				{
					field = elements[ i ];
					fieldName = field.name;
					fieldValue = field.value;
					
					if( ( i > 6 ) && ( i < 12 ) )
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
							if( fieldName == "Trade_Date" )
							{
								alert( "Please select a value for the field 'Trade-Date'." );
							}
							if( fieldName == "Client_ID" )
							{
								alert( "Please select a value for the field 'Client-ID'." );
							}
							
							field.value = "";
							field.focus( );
							
							return false;
						}
						else
						{
							flgReturn	=	true;
						}
					}
				}
			}
			
			return flgReturn;
		}
		
		//USED FOR FILL SETTLEMENT IF MKT_TYPE IS AVAILABLE.
		function CallDynamic( form, populateFor )
		{
			with( form )
			{
				if( populateFor == "SetNo" )
				{
					if( ( Mkt_Type.value != "" ) && ( Mkt_Type.value.charAt(0) != " " ) )
					{
						Msg.value = "";
				 		//parent.HideAndShow.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Mkt_Type&MktType=" +Mkt_Type.value +"&SettlementNo=&TradeDate=&ClientID=";
				 		parent.HideAndShow.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Mkt_Type&MktType=" +Mkt_Type.value +"&SettlementNo=&TradeDate=&ClientID=&PartialBill=#PartialBill#";
												
						if ( Mkt_Type.value == "A" )
						{
							p5.checked = false;
							p5.disabled = true;
						}
						else
						{
							p5.checked = true;
							p5.disabled = false;
						}
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
						
						Trade_Date.options.length = 0;
						Trade_Date.options[ Trade_Date.options.length ] = new Option( "Select a Trade-Date", "" );
						Trade_Date.options[ Trade_Date.options.length - 1 ].style.background = "LightYellow";
						Trade_Date.options[ Trade_Date.options.length - 1 ].style.color = "Green";
						
						if( typeof( Client_ID ) != "undefined")
						{
							Client_ID.options.length						=	0;
							Client_ID.options[ Client_ID.options.length ]	=	new Option( "Select a Client-ID", "" );
							Client_ID.options[ Client_ID.options.length - 1 ].style.background = "LightYellow";
							Client_ID.options[ Client_ID.options.length - 1 ].style.color = "Green";
						}
					}
				}
				if( populateFor == "TrDt" )
				{
					if( ( Settlement_No.value != "" ) && ( Settlement_No.value.charAt(0) != " " ) )
					{			   
						Msg.value = "";
				 		parent.HideAndShow.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value +"&SettlementNo=" +Settlement_No.value +"&TradeDate=&ClientID=N";
					}
					else
					{
						MsgRow.style.display = "";
						Msg.value = "* Please select a Settlement-No.";
						Msg.style.color = "Red";
						
						Trade_Date.options.length = 0;
						Trade_Date.options[ Trade_Date.options.length ] = new Option( "Select a Trade-Date", "" );
						Trade_Date.options[ Trade_Date.options.length - 1 ].style.background = "LightYellow";
						Trade_Date.options[ Trade_Date.options.length - 1 ].style.color = "Green";
						
						if( typeof( Client_ID ) != "undefined")
						{
							Client_ID.options.length						=	0;
							Client_ID.options[ Client_ID.options.length ]	=	new Option( "Select a Client-ID", "" );
							Client_ID.options[ Client_ID.options.length - 1 ].style.background = "LightYellow";
							Client_ID.options[ Client_ID.options.length - 1 ].style.color = "Green";
						}
					}
				}
				
				if( populateFor == "ClID" )
				{
					if( ( Trade_Date.value != "" ) && ( Trade_Date.value.charAt(0) != " " ) )
					{
						Msg.value				=	"";
				 		parent.HideAndShow.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=TradeDate&MktType=" +Mkt_Type.value +"&SettlementNo=" +Settlement_No.value +"&TradeDate=" +Trade_Date.value +"&ClientID=";
					}
					else
					{
						PrBill.checked			=	false;
						PrBill.disabled			=	false;
						MsgRow.style.display	=	"";
						Msg.value				=	"* Please select a Trade-Date.";
						Msg.style.color			=	"Red";
						
						if( typeof( Client_ID ) != "undefined")
						{
							Client_ID.options.length						=	0;
							Client_ID.options[ Client_ID.options.length ]	=	new Option( "Select a Client-ID", "" );
							Client_ID.options[ Client_ID.options.length - 1 ].style.background = "LightYellow";
							Client_ID.options[ Client_ID.options.length - 1 ].style.color = "Green";
						}
					}
				}
				if( populateFor == "None" )
				{
					if( ( Client_ID.value != "" ) && ( Client_ID.value.charAt(0) != " " ) )
					{
						Msg.value				=	"";
					}
					else
					{
						MsgRow.style.display	=	"";
						Msg.value				=	"* Please select a Client-ID.";
						Msg.style.color			=	"Red";
					}
				}
			}
		}
		function showPayIn(form,obj)
		{
			with ( form )
			{
				if ( obj.checked )
				{
				 	FundsDate.style.display="";
					rowRemPro.disabled = false;
					if ( hidBtn.value == "true" )
					{
						Ok.disabled		=	true;
					}
				}
				else
				{
					rowRemPro.disabled = true;
					p12.checked = false;
				 	FundsDate.style.display="none";
					Ok.disabled		=	false;
				}				
			}			
		}
	</script>
</cfoutput>	
<link href="../../CSS/style1.css" rel="stylesheet" type="text/css">
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
			<cfif PartialBill EQ "YES">
			And	IsNull(FLG_PartialBillCancel,'N') =	'Y' 
			<CFELSE>
			And a.FLG_BILL		=	'N'
			</cfif>
	Order By MktType Desc
</CFQUERY>


<body leftmargin="0" rightmargin="0" Class="StyleBody1" onLoad="HideAll( CallForm, '#Val(Markets.RecordCount)#' );">


<div align="center" id="Heading">
	<caption align="top">
		<u><CFIF PartialBill EQ "YES">Partial</cfif> Bill Process Parameters</u>
	</caption>
<!--- 	
	<CFIF ( Trim(Market) EQ "CAPS" ) AND ( Trim(Broker) EQ "SB" )>
		<br>
		<div align="right" id="linkStkExport">
			<a href="/FOCAPS/IO_FOCAPS/Transactions/ExportClientOutwardParameters.cfm?#Query_String#">
				Click to Stock Export
			</a>
		</div>
	</CFIF> --->
</div>

<cfset Style="width:50%;bottom:15%;height:15%">
<cfinclude template="/focaps/ProcessList.cfm">

<div align="center" id="Forms">
	<CFFORM name="CallForm" action="ProcessParameters_head.cfm?#Query_String#" method="POST" onSubmit="return checkForValidity( CallForm );">
		<input type="Hidden" name="COCD" value="#COCD#">
		<input type="Hidden" name="COName" value="#COName#">
		<input type="Hidden" name="Market" value="#Market#">
		<input type="Hidden" name="Exchange" value="#Exchange#">
		<input type="Hidden" name="Broker" value="#Broker#">
		<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
		<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
		<input type="Hidden" name="hidBtn" value="false">
		<input type="hidden" name="PartialBill" value="#PartialBill#">
		<cfparam  default="" name="BillCancle">
		<input type="hidden" name="BillCancle" value="#BillCancle#">

		
		<CFQUERY NAME="GetSysParam" datasource="#Client.database#" DBTYPE="ODBC">
			Select	
					IsNull(FLG_PositionShift, 'Y')FLG_PositionShift,
					IsNull(FLG_STTCalculation, 'I')FLG_STTCalculation,
					IsNull(JV_PostingDate, 'ToDate')JV_PostingDate,
					BILL_SEQ 
			From
					SYSTEM_SETTINGS
			Where
					Company_Code	=	'#COCD#'		
		</CFQUERY>
		
		<CFSET	PositionShift	=	GetSysParam.FLG_PositionShift>
		<CFSET	STTMethod		=	GetSysParam.FLG_STTCalculation>
		<CFSET	JV_PostingDate	=	GetSysParam.JV_PostingDate>
		<Cfif GetSysParam.BILL_SEQ neq 'Y'>
			<CFSET P_Done="">
		</Cfif>
<!--- 		<CFQUERY NAME="GetPayInDate" DATASOURCE="capsfo" DBTYPE="ODBC">
			SELECT	FUNDS_PAYIN_DATE
			FROM
					SETTLEMENT_MASTER
			WHERE
					COMPANY_CODE	=	'#COCD#'
		</CFQUERY>
		
 --->		<table align="center" border="0" cellpadding="0" cellspacing="0" class="StyleTable1">
			<tr id="row0">
				<th align="Right"> Market-Type : &nbsp; </th>
				<th align="Left">
				<CFIF not IsDefined("Mkt_type")>
					<select name="Mkt_Type" Class="clsMktType" onChange="CallDynamic( this.form, 'SetNo' ) ;">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Market-Type </option>
						<CFIF Markets.RecordCount GT 0>
							<option value="N,T"> N & T -Normal & TradeToTrade  </option>
							<CFLOOP query="Markets">
								<option value="#Trim(MktType)#"> #Trim(MktType)# - #Trim(MktTypeDesc)# </option>
							</CFLOOP>
						</CFIF>
					</select>
				<CFELSE>	
					<select name="Mkt_Type" Class="clsMktType" >
								<option value="#Trim(Mkt_Type )#"> #Trim(Mkt_Type)# </option>
					</select>
				</CFIF>
				</th>
			</tr>
			<tr id="row1">
				<th align="Right"> Settlement-No : &nbsp; </th>
				<th align="Left">
			<CFIF  IsDefined("Settlement_No")>
					<select name="Settlement_No" Class="clsSetlNo" onBlur="CallDynamic( this.form, 'TrDt' );">
						<option value="#Settlement_No#" > #Settlement_No#</option>
					</select>
					
			<CFELSE>		
					<select name="Settlement_No" Class="clsSetlNo" onChange="CallDynamic( this.form, 'TrDt' );">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Settlement-No </option>
					</select>
			</CFIF>					
				</th>
			</tr>
			<tr id="row2">
				<th align="Right"> Date : &nbsp; </th>
				<th align="Left">
					<select name="Trade_Date" Class="clsTrdDate" onBlur="CallDynamic( this.form, 'ClID' );">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Trade-Date </option>
					</select>
				</th>
			</tr>
<!--- 			<tr id="row3">
				<th align="Right"> Client-ID : &nbsp; </th>
				<th align="Left">
					<select name="Client_ID" Class="clsCltID" onChange="CallDynamic( this.form, 'None' );">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Client-ID </option>
					</select>
				</th>
			</tr> 
			
			
			<label for="PrPOSSHT" STYLE="display:none ">
				<tr id="rowPrPOSSHT" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">--->
						<input type="HIDDEN" name="p1" value="1" checked id="PrPOSSHT">
						<!--- Position Shifting
					</th>
				</tr>
			</label> --->
			<CFIF PositionShift is "N">
				<SCRIPT>
					CallForm.p1.checked = false;
					CallForm.p1.disabled = true;
				</SCRIPT>
			</CFIF>
			
			<CFIF	STTMethod is "S">
				<label for="PrSTT">
					<tr id="rowPrSTT" style="Cursor : Default;">
						<th colspan="2" align="left" Class="StyleLabel2">
							<input type="Checkbox" name="p10" value="1" checked id="PrSTT">
							STT Generation
						</th>
					</tr>
				</label>
			</CFIF>

			<tr id="rowPrBRKST" style="Cursor : Default;">
				<th colspan="2" align="left" Class="StyleLabel2">
					<label for="PrBRKST">
						<input type="Checkbox" name="p2" value="1" checked id="PrBRKST">
						Trade Brokerage / Service Tax Calculation
					</label><br>
					</th>
				</tr>
			</label>
			<label for="PrSTDTOC">
				<tr id="rowPrSTDTOC" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p3" value="1" checked id="PrSTDTOC">
						Stamp Duty / Turn-over Tax Calculation / STT Calculation 
					</th>
				</tr>
			</label>
			<label for="PrOTHEXP">
				<tr id="rowPrOTHEXP" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p4" value="1" checked id="PrOTHEXP">
						Other Expenses Calculation
					</th>
				</tr>
			</label>
			<label for="PrPreNODELY">
				<tr id="rowPrPreNODELY" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p11" value="1" checked id="PrPreNODELY">
						Pre No-Delivery Marking
					</th>
				</tr>
			</label>
			<label for="PrNODELY">
				<tr id="rowPrNODELY" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p5" value="1" checked id="PrNODELY">
						No-Delivery Marking
					</th>
				</tr>
			</label>
			<label for="PrDELYBRK">
				<tr id="rowPrDELYBRK" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p6" value="1" checked id="PrDELYBRK">
						Delivery Brokerage Marking / Calculation
					</th>
				</tr>
			</label>
<!--- 			<label for="PRReme">
				<tr id="rowPRReme" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p7" value="1" checked id="PRReme">
						Remeshiree Brokerage Calculation
					</th>
				</tr>
			</label> --->
			<label for="PRCont">
				<tr id="rowPRCont" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p9" value="1" checked id="PRCont">
						Contract
					</th>
				</tr>
			</label>
			<label for="PRBill">
				<tr id="rowPRBill" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p8" value="1" id="PrBill" ONCLICK="showPayIn(form, this);">
						Billing
					</th>
				</tr>
			</label>
			<label for="remPro">
				<tr id="rowRemPro" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="p12" value="1" id="remPro">
						Remeshire Process
					</th>
				</tr>
			</label>
			
			<CFQUERY datasource="#Client.database#" name="GETDATAOFSYS1">
						Select MAX(PMS_SYSTEM) PMS_SYSTEM from System_Settings
			</CFQUERY>									
			<cfif GETDATAOFSYS1.PMS_SYSTEM EQ 'Y'>
					<label for="pmsPro" >
						<tr id="pmsPro" style="Cursor : Default;" style="display:none">
							<th colspan="2" align="left" Class="StyleLabel2">
								<input type="Checkbox" name="p15" value="1" id="pmsPro">
								PMS Process
							</th>
						</tr>
					</label>
			</cfif>
			<tr>
			
				<th colspan="2">
					<input type="Text" name="FundsDate" size="50" TABINDEX="500" ReadOnly style="Background : Transparent; Border : None; Font : Bold 9pt Tahoma; Text-Align : Center; Color: Red;">&nbsp;
				</th>
			</tr>
			<tr>
				<th colspan="2">
					<input type="Text" name="ContractStatusText" size="100" TABINDEX="500" ReadOnly style="Background : Transparent; Border : None; Font : Bold 9pt Tahoma; Text-Align : Center; Color: Red;">&nbsp;
				</th>
			</tr>
			
			<tr id="row6">
				<th colspan="2" align="Right">
					<input type="Button" name="Ok" #P_Done# value="Process" class="StyleSmallButton1" id="btnProcess" accesskey="P" onClick="this.disabled =	true;Msg.value = '';this.form.submit()">
					<input type="Button" name="Cancel" value="Reset" class="StyleSmallButton1" id="btnCancel" accesskey="C" onClick="JavaScript : location.href( 'CallProcesses.cfm?#Query_String#' );">
				</th>	
			</tr>
			
		</table>
		
		<table id="MsgRow" align="center" border="0" cellpadding="0" cellspacing="0" class="StyleTable1">
			<tr>
				<th>
					<br><br>
					<input type="Text" name="Msg" value="Processing Bill, please wait ...." size="100" ReadOnly style="Background : Transparent; Border : None; Font : Normal 9pt Tahoma; Text-Align : Center; Color: Green;">
				</th>
			</tr>
		</table>
		<CFIF  IsDefined("Settlement_No")>
					<SCRIPT>
						CallDynamic( CallForm, 'TrDt' );
					</SCRIPT>
			</CFIF>					
	</CFFORM>
</div>

</body>
</CFOUTPUT>

</html>