<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>UCC FOR WEBEX</TITLE>
	<LINK HREF="../../CSS/DynamicCSS.css" TYPE="text/css" REL="stylesheet">
	<LINK HREF="../../CSS/Bill.css" TYPE="text/css" REL="stylesheet">	
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
	
</HEAD>
<STYLE>
	DIV#FOOTER
	{
		Position: Absolute;
		Left: 0;
		Top: 56%;
		Bottom: 0;
		Height: 8%;
		Width: 100%;		
	}
</STYLE>
<SCRIPT>

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
	with( UCCFORFILEGENERATION )
	{
		
		HelpWindow = open( "/FOCAPS/HelpSearch/TradingClients.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd +"&Mkt_Type=&Settlement_No=0&HelpFor=Client&title=Client-ID Help","ClientIDHelpWindow", "Top=0, Left=0, Width=700, Height=525, AlwaysRaised=Yes, Resizeable=No" );
	}
}
function OpenWindow1( form, par )
{
	with( UCCFORFILEGENERATION )
	{
		
		HelpWindow = open( "/FOCAPS/HelpSearch/BranchHelp.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd +"&Mkt_Type=&Settlement_No=0&HelpFor=Client&title=Client-ID Help","ClientIDHelpWindow", "Top=0, Left=0, Width=700, Height=525, AlwaysRaised=Yes, Resizeable=No" );
	}
}
</SCRIPT>
<BODY>
<CFOUTPUT>	
<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">
	
		
	<CFFORM NAME="UCCFORFILEGENERATION" METHOD="POST" ACTION="UCCBOTTOMFRAME.CFM" target="reports">
		
		
		<INPUT TYPE="Hidden" NAME="COCD" VALUE="#COCD#">
		<INPUT TYPE="Hidden" NAME="COName" VALUE="#COName#">
		<INPUT TYPE="Hidden" NAME="Market" VALUE="#Market#">
		<INPUT TYPE="Hidden" NAME="Exchange" VALUE="#Exchange#">
		<INPUT TYPE="Hidden" NAME="Broker" VALUE="#Broker#">
		<INPUT TYPE="Hidden" NAME="FinStart" VALUE="#Val(Trim(FinStart))#">
		<INPUT TYPE="Hidden" NAME="FinEnd" VALUE="#Val(Trim(FinEnd))#">		
	
		<TABLE ALIGN="CENTER" WIDTH="100%" BORDER="0">
			<TR ALIGN="Left">
				<TD ALIGN="LEFT">
				Frm Dt :&nbsp;	
				<label FOR="PRINTDATE" CLASS="Hand">
					<SCRIPT LANGUAGE="VBSCRIPT">
						Sub	Reg_date_OnKeyuP()
								DSTR = UCCFORFILEGENERATION.Reg_date.value
								DLEN = LEN(UCCFORFILEGENERATION.Reg_date.value)
								IF DLEN = 2 OR DLEN = 5 THEN
									UCCFORFILEGENERATION.Reg_date.value = DSTR + "/"
								END IF	
						END SUB
						Sub	Reg_date_GotFocus()	
								UCCFORFILEGENERATION.Reg_date.SelStart = 0
								UCCFORFILEGENERATION.Reg_date.SelLength = LEN(UCCFORFILEGENERATION.Reg_date.value)
						END SUB
					</SCRIPT>								
				</LABEL>
					<INPUT TYPE="TEXT" NAME="Reg_date" SIZE="10" MAXLENGTH="10" VALUE="#Dateformat(Now(),"dd/mm/yyyy")#" class="StyleTextBox">					
				</TD>
				
				<TD ALIGN="LEFT">
				To Dt :&nbsp;
				<label FOR="PRINTDATE" CLASS="Hand">
					<SCRIPT LANGUAGE="VBSCRIPT">
						Sub	Reg_date_To_OnKeyuP()
								DSTR = UCCFORFILEGENERATION.Reg_date_To.value
								DLEN = LEN(UCCFORFILEGENERATION.Reg_date_To.value)
								IF DLEN = 2 OR DLEN = 5 THEN
									UCCFORFILEGENERATION.Reg_date_To.value = DSTR + "/"
								END IF	
						END SUB
						Sub	Reg_date_To_GotFocus()	
								UCCFORFILEGENERATION.Reg_date_To.SelStart = 0
								UCCFORFILEGENERATION.Reg_date_To.SelLength = LEN(UCCFORFILEGENERATION.Reg_date_To.value)
						END SUB
					</SCRIPT>								
				</LABEL>
					<INPUT TYPE="TEXT" NAME="Reg_date_To" SIZE="10" MAXLENGTH="10" VALUE="#Dateformat(Now(),"dd/mm/yyyy")#" class="StyleTextBox">					
				</TD>
				<Th ALIGN="RIGHT">
					Format :&nbsp;
				</Th>
				<TD ALIGN="LEFT">					
					<LABEL FOR="EIGHT" CLASS="StyleLabel1">
						<INPUT TYPE="Radio" ID="EIGHT" NAME="Format1" VALUE="Mod" Class="StyleCheckbox">
						Modify
					</LABEL>
					<LABEL FOR="TEN" CLASS="StyleLabel1">
						<INPUT TYPE="Radio" ID="TEN" NAME="Format1" VALUE="New" Class="StyleCheckbox" CHECKED>
						New
					</LABEL>		
					<LABEL FOR="TEN" CLASS="StyleLabel1">
						<INPUT TYPE="Radio" ID="TEN" NAME="Format1" VALUE="AI" Class="StyleCheckbox" CHECKED>
						Active/Inactive
					</LABEL>					
			
				</TD>
				
				<Td ALIGN="CENTER">
					Cl List:<TEXTAREA CLASS="StyleTextBox" NAME="FromClient"></TEXTAREA>
									<INPUT TYPE="Button" NAME="btnHelp" VALUE=" ? " title="Click here to get Help for Client ID." CLASS="StyleSmallButton1" style="Cursor : Help;"
					   ONCLICK="OpenWindow( this.form, 'Client' );">
				</Td>


				<TH nowrap>
					Date Range On Brokerage :
				</TH>
				<TH nowrap>
					<input type="checkbox" value="Y" name="Brokerage">
			   </TH>		
				<Td ALIGN="CENTER">
					<INPUT TYPE="SUBMIT" NAME="CmdView" VALUE="View" SIZE="10"  class="StyleSmallButton1">
				</Td>
			</TR>
			<tr>
			<Td ALIGN="CENTER">
				Branch List:<TEXTAREA CLASS="StyleTextBox" NAME="FromBranch"></TEXTAREA>
								
			</Td>
			</tr>	
	<!--- 		
			<TR ALIGN="CENTER">
				<Th ALIGN="RIGHT">
					Format :&nbsp;
				</Th>
				<TD ALIGN="LEFT">					
					<LABEL FOR="EIGHT" CLASS="StyleLabel1">
						<INPUT TYPE="Radio" ID="EIGHT" NAME="Format" VALUE="Old" Class="StyleCheckbox">
						Old Format
					</LABEL>
					<LABEL FOR="TEN" CLASS="StyleLabel1">
						<INPUT TYPE="Radio" ID="TEN" NAME="Format" VALUE="New" Class="StyleCheckbox" CHECKED>
						New Format
					</LABEL>					
				</TD>
			</TR>
 --->				
			
		</TABLE>			
		
	</CFFORM>
</CFOUTPUT>
</BODY>
</HTML>
