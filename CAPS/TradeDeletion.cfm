<cfinclude template="/focaps/help.cfm">
<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> Trade Deletion. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">
	
	<SCRIPT>
		function HideAll( form, tradeCnt )
		{
			with( form )
			{
				Mkt_Type.focus();
				
				if( tradeCnt > 0 )
				{
					MsgRow.style.display	=	"None";
				}
				else
				{
					MsgRow.style.display	=	"";
					Msg.style.color			=	"Red";
					Msg.value				=	"* There are no more Trades available to Delete.";
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
							
							field.value	=	"";
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
						Msg.value							=	"";
				 		parent.HideAndShow.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Mkt_Type&MktType=" +Mkt_Type.value +"&SettlementNo=";
					}
					else
					{
						MsgRow.style.display	=	"";
						Msg.value				=	"* Please select a Market-Type.";
						Msg.style.color			=	"Red";
						
						Settlement_No.options.length = 0;
						Settlement_No.options[ Settlement_No.options.length ] = new Option( "Select a Settlement-No", "" );
						Settlement_No.options[ Settlement_No.options.length - 1 ].style.background = "LightYellow";
						Settlement_No.options[ Settlement_No.options.length - 1 ].style.color = "Green";
					}
				}

				if( populateFor == "TradeDate" )
				{
					if( ( Settlement_No.value != "" ) && ( Settlement_No.value.charAt(0) != " " ) )
					{
						Msg.value							=	"";
				 		parent.HideAndShow.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=TradeDate&MktType=" +Mkt_Type.value +"&SettlementNo=" +Settlement_No.value;
					}
					else
					{
						MsgRow.style.display	=	"";
						Msg.value				=	"* Please select a Settlement No.";
						Msg.style.color			=	"Red";
						
						Trade_Date.options.length = 0;
						Trade_Date.options[ Trade_Date.options.length ] = new Option( "Select a Trade-Date.", "" );
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
					if( ( Settlement_No.value != "" ) && ( Settlement_No.value.charAt(0) != " " ) )
					{
						Msg.value							=	"";
				 		parent.HideAndShow.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value +"&SettlementNo=" +Settlement_No.value +"&Trade_Date=" + Trade_Date.value +"&ClientID=";
					}
					else
					{
						MsgRow.style.display	=	"";
						Msg.value				=	"* Please select a Settlement-No.";
						Msg.style.color			=	"Red";
						
						Client_ID.options.length						=	0;
						Client_ID.options[ Client_ID.options.length ]	=	new Option( "Select a Client-ID", "" );
						Client_ID.options[ Client_ID.options.length - 1 ].style.background = "LightYellow";
						Client_ID.options[ Client_ID.options.length - 1 ].style.color = "Green";
					}
				}
				if( populateFor == "Nothing" )
				{
					if( ( Client_ID.value != "" ) && ( Client_ID.value.charAt(0) != " " ) )
					{
						Msg.value							=	"";
				 		//parent.HideAndShow.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value +"&SettlementNo=" +Settlement_No.value +"&ClientID=";
					}
					else
					{
						MsgRow.style.display	=	"";
						Msg.value				=	"* Please select a Client-ID.";
						Msg.style.color			=	"Red";
					}
				}
				if( populateFor == "None" )
				{
					if( ( Settlement_No.value != "" ) && ( Settlement_No.value.charAt(0) != " " ) )
					{
						Msg.value				=	"";
					}
					else
					{
						MsgRow.style.display	=	"";
						Msg.value				=	"* Please select a Settlement-No.";
						Msg.style.color			=	"Red";
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
				a.MARKET		=	b.MARKET
			And	a.EXCHANGE		=	b.EXCHANGE
			And	a.MKT_TYPE		=	b.MKT_TYPE
			And	a.COMPANY_CODE	=	'#Trim(COCD)#'
			And	a.MARKET		=	'#Trim(Market)#'
			And	a.EXCHANGE		=	'#Trim(Exchange)#'
			And a.FLG_BILL		=	'N'
	Order By MktType Desc
</CFQUERY>


<CFQUERY name="GetSystemSettings" datasource="#Client.database#" dbtype="ODBC">
	Select	RTrim( CLEARING_MEMBER_CODE ) ReverseClientCode, 
			IsNull( Rtrim(FLG_TRADE_DELETION), 'N' ) FlgDelTrade,
			IsNull( Rtrim(FLG_TRADE_DELETION_User), 'N' ) FlgDelTradeUser	
	From	SYSTEM_SETTINGS
	Where	COMPANY_CODE	=	'#Trim(COCD)#'
</CFQUERY>

<CFSET ReverseClientCode	=	GetSystemSettings.ReverseClientCode>
<CFSET FlgDelTrade			=	GetSystemSettings.FlgDelTrade>
<CFSET FlgDelTradeUser			=	GetSystemSettings.FlgDelTradeUser>

<body leftmargin="0" rightmargin="0" Class="StyleBody1" onLoad="HideAll( TradeDeleteForm, '#Val(Markets.RecordCount)#' );">


<div align="center" id="Heading">
	<u>Trade Deletion Parameters</u>
</div>


<div align="center" id="Forms">

	<table align="Center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
		<CFIF IsDefined("DeleteTrades")>
			<CFTRANSACTION action="BEGIN">
				<CFTRY>
					<CFQUERY name="DeleteTradeToAccounts" datasource="#Client.database#" dbtype="ODBC">
						Delete	TRADE_TO_ACCOUNTS
						Where
									COMPANY_CODE	=	'#Trim(COCD)#'
								And	MKT_TYPE		=	'#Trim(Mkt_Type)#'
								And	SETTLEMENT_NO	=	#Trim(Settlement_No)#
								<CFIF IsDefined("Client_ID") AND Len(Trim(Client_ID)) GT 0 AND Trim(Client_ID) NEQ "ALL">
									And CLIENT_ID	=	'#Trim(Client_ID)#'
								</CFIF>
					</CFQUERY>
				   	
					<CFQUERY name="DeleteClientExpenses" datasource="#Client.database#" dbtype="ODBC">
						Delete	CLIENT_EXPENSES
						Where
									COMPANY_CODE	=	'#Trim(COCD)#'
								And	MKT_TYPE		=	'#Trim(Mkt_Type)#'
								And	SETTLEMENT_NO	=	#Trim(Settlement_No)#
								<CFIF IsDefined("Client_ID") AND Len(Trim(Client_ID)) GT 0 AND Trim(Client_ID) NEQ "ALL">
									And CLIENT_ID	=	'#Trim(Client_ID)#'
								</CFIF>
					</CFQUERY>
					
					<CFQUERY name="DeleteMiddleTradeDB" datasource="#Client.database#" dbtype="ODBC">
						Delete	#UCase(Trim(Exchange))#_TRADE1
						Where
									COMPANY_CODE	=	'#Trim(COCD)#'
								And	MKT_TYPE		=	'#Trim(Mkt_Type)#'
								And	SETTLEMENT_NO	=	#Trim(Settlement_No)#
								<CFIF IsDefined("Trade_Date") AND Len(Trim(Trade_Date)) GT 0>
									And convert(datetime, Trade_Date, 103)	=	convert(datetime, '#Trim(Trade_Date)#', 103)
								</CFIF>
								<CFIF IsDefined("Client_ID") AND Len(Trim(Client_ID)) GT 0 AND Trim(Client_ID) NEQ "ALL">
									And CLIENT_ID	=	'#Trim(Client_ID)#'
								</CFIF>
					</CFQUERY>
					
					<CFSET X = 1>
					<CFQUERY name="DeleteTrade1DB" datasource="#Client.database#" dbtype="ODBC">
						Delete	TRADE1
						From	TRADE1 ( INDEX = IDX_CONTRACTNO_TRADE1 )
						Where
									COMPANY_CODE	=	'#Trim(COCD)#'
								And	MKT_TYPE		=	'#Trim(Mkt_Type)#'
								And	SETTLEMENT_NO	=	#Trim(Settlement_No)#
								<CFIF IsDefined("Trade_Date") AND Len(Trim(Trade_Date)) GT 0>
									And convert(datetime, Trade_Date, 103)	=	convert(datetime, '#Trim(Trade_Date)#', 103)
								</CFIF>
								<CFIF IsDefined("Client_ID") AND Len(Trim(Client_ID)) GT 0 AND Trim(Client_ID) NEQ "ALL">
									And  CLIENT_ID = '#Trim(Client_ID)#'
									<!--- (
										(  
										 --->
										<!--- And REVERSE_CLIENT_ID = '#Trim(ReverseClientCode)#' ) OR
										( CLIENT_ID = '#Trim(ReverseClientCode)#' And REVERSE_CLIENT_ID = '#Trim(Client_ID)#' )
									) --->
								</CFIF>
								
								<CFIF IsDefined("FromUser") AND Len(Trim(FromUser)) GT 0 >
									And USER_ID IN 
									(
										<cfloop index="Frombranch1" list="#FromUser#" delimiters=",">
											<cfif X GTE 2>,</cfif>
												'#Frombranch1#'
												<CFSET X = IncrementValue(X)>
										</cfloop>
										<CFSET X = 0>
									)	
								</CFIF>
								And BILL_NO 		=	0
								AND ORDER_NUMBER NOT LIKE 'ND-BF'
					</CFQUERY>
					
					<CFTRANSACTION action="COMMIT"/>
					<CFSET A = EODProcess("Trade Delete",'#Trade_Date#','#Trade_Date#','#COCD#','#Mkt_Type#','#Settlement_No#')>	
					<tr>
						<td align="Center" style="Color : Blue;">
							&raquo;&nbsp; Trades Deleted for the Settlement : 
							&nbsp;#Trim(Mkt_Type)# / #Trim(Settlement_No)# 
							<CFif LEN(Trim(Trade_Date)) GT 0>
								- #trade_date#
							</CFIF>	.
						</td>
					</tr>
					<Cfset a = Repl_Trade('#Trim(COCD)#','#Trim(Mkt_Type)#',#Trim(Settlement_No)#,'CAPS','')>
				<CFCATCH>
					<CFTRANSACTION action="ROLLBACK"/>
					<tr>
						<td align="Center" style="Color : Red;">
							&raquo;&nbsp; #CFCATCH.Detail#<BR>#CFCATCH.Message#
							&raquo;&nbsp; Error in Trade Deletion.<br>
							&raquo;&nbsp; Trades are NOT Deleted for the Settlement : &nbsp;#Trim(Mkt_Type)# / #Trim(Settlement_No)#.
						</td>
					</tr>
				</CFCATCH>
				</CFTRY>
			</CFTRANSACTION>
		<CFELSE>
			<tr>
				<td align="Center">
					&nbsp;<br>
				</td>
			</tr>
		</CFIF>
	</table>
	
	<CFFORM name="TradeDeleteForm" action="TradeDeletion.cfm?#Query_String#" method="POST" onSubmit="return chkForEmptyFields( TradeDeleteForm );">
		<input type="Hidden" name="COCD" value="#Trim(COCD)#">
		<input type="Hidden" name="COName" value="#Trim(COName)#">
		<input type="Hidden" name="Market" value="#Trim(Market)#">
		<input type="Hidden" name="Exchange" value="#Trim(Exchange)#">
		<input type="Hidden" name="Broker" value="#Trim(Broker)#">
		<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
		<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">

		<CFIF IsDefined("DeleteTrades")>
			<cfset path = "C:\CFusionMX7\wwwroot\Reports\TradeDelete\#COCD#_#Mkt_Type#_#Settlement_No#_#TimeFormat(now(),'HHMMSS')#.htm">
		</CFIF>
		<cfparam default="" name="StoreFileText">
		<cfparam default="" name="path">
		#StoreHTMLFile('TradeDeleteForm','TradeDelete',StoreFileText,'#path#','DeleteTrades')#
		<table align="Center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable" id="TradeDelete">
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
					<select name="Settlement_No" class="clsSetlNo" onChange="CallDynamic( this.form, 'TradeDate');">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Settlement-No </option>
					</select>
				</th>
			</tr>
			<tr id="row2">
				<th align="Right"> Date : &nbsp; </th>
				<th align="Left">
					<select name="Trade_Date" Class="clsTrdDate" onChange="<CFIF IsDefined("GetSystemSettings") AND FlgDelTrade EQ "Y"> CallDynamic( this.form, 'ClID'); <CFELSE> CallDynamic( this.form, 'None'); </CFIF>">
						<option value="" style="Background : LightYellow; Color : Green;"> Select a Trade-Date </option>
					</select>
				</th>
			</tr>
			<CFIF IsDefined("GetSystemSettings") AND FlgDelTrade EQ "Y">
				<tr id="row2">
					<th align="Right"> Client-ID : &nbsp; </th>
					<th align="Left">
						<select name="Client_ID" Class="clsCltID" onChange="CallDynamic( this.form, 'Nothing');">
							<option value="" style="Background : LightYellow; Color : Green;"> Select a Client-ID </option>
						</select>
					</th>
				</tr>
			</CFIF>
			<CFIF IsDefined("GetSystemSettings") AND FlgDelTradeUser EQ "Y">
				<TR id="row2">
					<!--- <Cfset Help = "select RTrim(Ltrim(GroupCode)) GroupCode,Groupname from familymaster order by GroupCode"> --->
					<TH align="right"> User ID : &nbsp; </TH>
					<TH align="left">
						<TEXTAREA NAME="FromUser" cols="19"></TEXTAREA>
						<!--- <INPUT TYPE="Button" NAME="cmdClientHelp" VALUE=" ? " CLASS="StyleSmallButton1"
						OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=FromUser&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );"> --->
				</TR>
			</CFIF>
			
			<tr>
				<th colspan="2">&nbsp;
					
				</th>
			</tr>
			<tr id="row3">
				<th colspan="2" align="Right">
					<input type="Submit" name="DeleteTrades" value="Delete Trades" class="StyleSmallButton1" accesskey="D" onClick="Msg.value = '';">
<!--- 					<input type="Button" name="Cancel" value="Cancel" class="StyleSmallButton1" accesskey="C" onClick="JavaScript : location.href( 'TradeDeletion.cfm?#Query_String#' );"> --->
				</th>
			</tr>
		</table>
		
		<table id="MsgRow" align="Center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
			<tr>
				<td>
					<br><br><br><br>
					<input type="Text" name="Msg" value="Deleting Trades, please wait ...." size="100" ReadOnly style="Background : Transparent; Border : None; Font : Normal 9pt Tahoma; Text-Align : Center; Color: Green;">
				</td>
			</tr>
		</table>
	</CFFORM>

</div>


</body>


</CFOUTPUT>
</html>