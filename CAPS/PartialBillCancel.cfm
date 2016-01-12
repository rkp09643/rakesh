<cfinclude template="/focaps/help.cfm">
<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->

<HTML>
<HEAD>
	<TITLE> Bill Cancellation. </TITLE>
	<LINK href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<LINK href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">
	
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
					ClientList.innerHTML="";
					if( ( Settlement_No.value != "" ) && ( Settlement_No.value.charAt(0) != " " ) )
					{
						Msg.value	=	"";
				 		parent.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObject=parent.Display.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value +"&SettlementNo=" +Settlement_No.value;
					}
					else
					{
						MsgRow.style.display = "";
						Msg.value = "* Please select a Settlement-No.";
						Msg.style.color = "Red";
					}
				}
				
				if( populateFor == "ValidateSettlement" )
				{
					if( ( Settlement_No.value != "" ) && ( Settlement_No.value.charAt(0) != " " ) )
					{
						Msg.value	=	"";
					}
					else
					{
						MsgRow.style.display = "";
						Msg.value = "* Please select a Settlement-No.";
						Msg.style.color = "Red";
					}
				}
			}
		}
		
				function CloseWindow()
		{
			try
			{
				if( typeof( HelpWindow ) == "object" && !HelpWindow.closed )
				{
					HelpWindow.close();
					throw "e";
				}
			}
			catch( e )
			{
				return( e );
			}
		}
		
		function OpenWindow( form, par )
		{
			with( BillCancelForm )
			{
				HelpWindow = open( "/FOCAPS/HelpSearch/TradingClients.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&Mkt_Type=" +Mkt_Type.value +"&Settlement_No=" +Settlement_No.value +"&HelpFor=" +par +"&title=Client-Overview - Client-ID Help","ClientIDHelpWindow", "Top=0, Left=0, Width=700, Height=525, AlwaysRaised=Yes, Resizeable=No" );
			}
		}

	</SCRIPT>
	<STYLE>
	DIV#UserNotes
		{
			Font		:	Bold 9pt Verdana;
			Position	:	Absolute;
			Top			:	90%;
			Left		:	0;
			Width		:	100%;
			Height		:	20%;
		}
	DIV#Results
		{
			Font		:	Bold 9pt Verdana;
			Position	:	Absolute;
			Top			:	30%;
			Left		:	0;
			Width		:	100%;
			Height		:	10%;
		}
	DIV#ClientList
		{
			Font		:	Bold 9pt Verdana;
			Position	:	Absolute;
			Top			:	31%;
			Left		:	0%;
			Width		:	100%;
			Height		:	10%;
		}
	</STYLE>
</HEAD>


<CFOUTPUT>

<CFIF IsDefined("Ok1")>
	<DIV ID="Results">
		<CFTRY>
			<CFSTOREDPROC procedure="PARTIAL_BILLCANCELLATION" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#mkt_type#" maxlength="2" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#settlement_no#" maxlength="9" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENT_LIST" value="#Trim(FromClient)#" maxlength="2000" null="No">
			</CFSTOREDPROC>

			<FIELDSET style="Border : 1pt Solid Gray;">
				<LEGEND ID="UserHelp">  </LEGEND>
				
				<TABLE width="96%" align="Center" border="0" cellpadding="0" cellspacing="0" Class="StyleMastersTable1" style="Color : Blue; Font : Normal 8pt Verdana;">	
					<TR>
						<TD NOWRAP>
							&raquo; Partial Bill Cancel for '#Mkt_Type#'-'#Settlement_No#' for following clients.<BR>
							&raquo; <B><u>Clients:</u></B>&nbsp;#Trim(FromClient)#.<BR>
						</TD>
					</TR>
					<TR><TD>&nbsp;</TD></TR>
				</TABLE>
			</FIELDSET>
		<CFCATCH TYPE="DATABASE">
			#cfcatch.Detail#
		</CFCATCH>		
		</CFTRY>
	</DIV>
</CFIF>
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


<BODY leftmargin="0" rightmargin="0" Class="StyleBody1" onFocus="CloseWindow();" onLoad="HideAll( BillCancelForm, '#Val(Markets.RecordCount)#' );">

<DIV align="center" id="Heading">
	<u>Partial Bill Cancellation Parameters</u>
</DIV>

<DIV align="center" id="Forms">

	<CFFORM name="BillCancelForm" action="PartialBillCancel.cfm?#Query_String#" method="POST">
		<INPUT type="Hidden" name="COCD" value="#COCD#">
		<INPUT type="Hidden" name="COName" value="#COName#">
		<INPUT type="Hidden" name="Market" value="#Market#">
		<INPUT type="Hidden" name="Exchange" value="#Exchange#">
		<INPUT type="Hidden" name="Broker" value="#Broker#">
		<INPUT type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
		<INPUT type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
		<INPUT type="Hidden" name="Ok1" value="">
		
		<TABLE align="center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
			<TR id="row0">
				<TH align="Right"> Market-Type : &nbsp; </TH>
				<TH align="Left">
					<SELECT name="Mkt_Type" Class="clsMktType" onChange="CallDynamic( this.form, 'SetNo');">
						<OPTION value="" style="Background : LightYellow; Color : Green;"> Select a Market-Type </OPTION>
						<CFIF Markets.RecordCount GT 0>
							<CFLOOP query="Markets">
								<OPTION value="#Trim(MktType)#"> #Trim(MktType)# - #Trim(MktTypeDesc)# </OPTION>
							</CFLOOP>
						</CFIF>
					</SELECT>
				</TH>
			</TR>
			<TR id="row1">
				<TH align="Right"> Settlement-No : &nbsp; </TH>
				<TH align="Left">
					<SELECT name="Settlement_No" class="clsSetlNo" onBlur="CallDynamic( this.form, 'ClID' );">
						<OPTION value="" style="Background : LightYellow; Color : Green;"> Select a Settlement-No </OPTION>
					</SELECT>
				</TH>
			</TR>
			<TR id="row2">
				<TH align="right"> Client-ID : &nbsp; </TH>
				<TH align="left">
					<TEXTAREA NAME="FromClient"></TEXTAREA>
					<INPUT TYPE="Button" NAME="btnHelp" VALUE=" ? " title="Click here to get Help for Client ID." CLASS="StyleSmallButton1" style="Cursor : Help;"
					   ONCLICK="OpenWindow( this.form, 'Client' );">

				</TH>
			</TR>
	
			<TR>
				<TH colspan="2">&nbsp;
					
				</TH>
			</TR>
			<TR id="row3">
				<TH colspan="2" align="Right">
					<INPUT type="Submit" name="Ok" value="Cancel Bill" class="StyleSmallButton1" accesskey="C" onClick="this.disabled=true; MsgRow.style.display=''; this.form.submit();">&nbsp;
<!--- 					<input type="Button" name="Cancel" value="Clear" class="StyleSmallButton1" accesskey="R" onClick="JavaScript : location.href( 'BillCancel.cfm?#Query_String#' );"> --->
				</TH>
			</TR>
		</TABLE>
		
		<TABLE id="MsgRow" align="center" border="0" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
			<TR>
				<TD>
					<BR><BR><BR><BR>
					<INPUT type="Text" name="Msg" value="Cancelling Bill, please wait ...." size="100" ReadOnly style="Background : Transparent; Border : None; Font : Normal 9pt Tahoma; Text-Align : Center; Color: Green;">
				</TD>
			</TR>
		</TABLE>
	</CFFORM>
</DIV>

<DIV id="ClientList">

</DIV>

<DIV align="left" id="UserNotes">
	<FIELDSET style="Border : 1pt Solid Orange;">
		<LEGEND ID="UserHelp">  </LEGEND>
		
		<TABLE width="96%" align="Center" border="0" cellpadding="0" cellspacing="0" Class="StyleMastersTable1" style="Color : Maroon; Font : Normal 8pt Verdana;">	
			<TR>
				<TD>
					&raquo; This Process will not revert Bill Posting from Accounts.<BR>
					&raquo; This Process will not revert Demat Posting.<BR>
				</TD>
			</TR>
		</TABLE>
	</FIELDSET>
</DIV>

</BODY>
</CFOUTPUT>
</HTML>