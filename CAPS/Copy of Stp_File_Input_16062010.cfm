<!---- **************************************************************
	BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*************************************************************** ---->


<HTML>
<HEAD>
	<TITLE> Client Overview Input Screen. </TITLE>
	<LINK href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<LINK href="/FOCAPS/CSS/style1.css" type="text/css" rel="stylesheet">
	
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
			with( ScreenInputs )
			{
				var FinEnd	= parseInt( FinStart.value ) + 1;
				
				if( par == "Settlement" )
				{
					HelpWindow	=	open( "/FOCAPS/HelpSearch/TradingClients.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd +"&Mkt_Type="+ Mkt_Type.value +"&HelpFor=" +par +"&title=Client-Overview - Client-ID Help", "ClientIDHelpWindow", "Top=0, Left=0, Width=700, Height=525, AlwaysRaised=Yes, Resizeable=No" );
				}
				if( par == "Client" )
				{
					HelpWindow = open( "/FOCAPS/HelpSearch/TradingClients.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd +"&Mkt_Type=" +Mkt_Type.value +"&Settlement_No=" +Settlement_No.value +"&HelpFor=" +par +"&title=Client-Overview - Client-ID Help","ClientIDHelpWindow", "Top=0, Left=0, Width=700, Height=525, AlwaysRaised=Yes, Resizeable=No" );
				}
			}
		}
		
		function CallDynamic( form, par)
		{
			with (StpFileGen)
			{
				if(par == 'Mkt')
				{
					parent.top.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FormObject=parent.Display.Inputs.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value+"&TradeDate=" + txtOrderDate.value+"&Par=" + par ;
				}
				if(par == 'Client')
				{
					parent.top.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FormObject=parent.Display.Inputs.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value+"&TradeDate=" + txtOrderDate.value+"&Par=" + par+"&SetlNo=" + txtSetlId.value ;
				}
				if(par == 'OrderNo')
				{
					parent.top.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FormObject=parent.Display.Inputs.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value+"&TradeDate=" + txtOrderDate.value+"&Par=" + par+"&SetlNo=" + txtSetlId.value +"&Client123=" + txtClientID.value+"&Scrip=" + txtScrip.value.replace('&','|');
				}
				if(par == 'Scrip')
				{
					parent.top.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FormObject=parent.Display.Inputs.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value+"&TradeDate=" + txtOrderDate.value+"&Par=" + par+"&SetlNo=" + txtSetlId.value +"&Client123=" + txtClientID.value  ;
				}				
			}
		}
		
		function setBatchNo()
		{
			batchNo = prompt( "Enter BatchNo.", "01", "Batch" );
			ScreenInputs.batchNo.value = batchNo;
		}
	</SCRIPT>
    <LINK HREF="../../CSS/style1.css" REL="stylesheet" TYPE="text/css">
</HEAD>

<BODY leftmargin="0" rightmargin="0" onFocus="CloseWindow();">
<CFOUTPUT>


<CFFORM name="StpFileGen" action="Stp_File_View.cfm" method="POST" target="reports">
	<INPUT type="Hidden" name="COCD" value="#Trim(COCD)#">
	<INPUT type="Hidden" name="COName" value="#COName#">
	<INPUT type="Hidden" name="Market" value="#Market#">
	<INPUT type="Hidden" name="Exchange" value="#Exchange#">
	<INPUT type="Hidden" name="Broker" value="#Broker#">
	<INPUT type="Hidden" name="FinStart" value="#FinStart#">
	<INPUT type="Hidden" name="FinEnd" value="#FinStart+1#">
	<INPUT type="Hidden" name="batchNo" value="01">

	<TABLE WIDTH="100%" border="0" cellpadding="0" cellspacing="0" class="StyleReportParameterTable1">
	    <TR>
		  	<TD width="2%" CLASS="bold" ALIGN="left">
				Date :&nbsp;
		  </TD>
		  	<TD width="6%" CLASS="bold" ALIGN="left">
				<label FOR="PRINTDATE" CLASS="Hand">
					<SCRIPT LANGUAGE="VBSCRIPT">
						Sub	txtOrderDate_OnKeyuP()
								DSTR = StpFileGen.txtOrderDate.value
								DLEN = LEN(StpFileGen.txtOrderDate.value)
								IF DLEN = 2 OR DLEN = 5 THEN
									StpFileGen.txtOrderDate.value = DSTR + "/"
								END IF	
						END SUB
						Sub	txtOrderDate_GotFocus()	
								StpFileGen.txtOrderDate.SelStart = 0
								StpFileGen.txtOrderDate.SelLength = LEN(StpFileGen.txtOrderDate.value)
						END SUB
					</SCRIPT>								
				</LABEL>
						
				<CFINPUT TYPE="text" NAME="txtOrderDate" VALIDATE="EURODATE" MESSAGE="Please enter Proper Date." VALUE="#DateFormat(now(),"DD/MM/YYYY")#" MAXLENGTH="10" SIZE="10" class="StyleTextBox">
		  </TD>
			<TD align="center" width="2%"  CLASS="bold"  ALIGN="left">
				&nbsp;Mkt&nbsp; :
			</TD>
			<TD align="center" width="3%"  CLASS="bold"  ALIGN="left">
				<SELECT name="Mkt_Type" style="font:'Times New Roman', Times, serif; font-size:11px;" onBlur="CallDynamic('ScreenInputs','Mkt');">
					<OPTION VALUE="N">N</OPTION>
					<OPTION VALUE="T">T</OPTION>
				</SELECT>
			</TD>
      		<TD width="2%"  CLASS="bold">
				&nbsp;Setl.&nbsp;:
			</TD>
      		<TD width="14%"  CLASS="bold">
				<SELECT NAME="txtSetlId" onBlur="CallDynamic('ScreenInputs','Client');" style="font:'Times New Roman', Times, serif; font-size:10px; width:100%;">
					
				</SELECT>
			</TD>
      		<TD width="8%"  CLASS="bold">
				&nbsp;Client&nbsp;:
			</TD>			
      		<TD width="16%"  CLASS="bold">
				<SELECT NAME="txtClientID" onBlur="CallDynamic('ScreenInputs','Scrip');" style="font:'Times New Roman', Times, serif; font-size:10px; width:100%;">
						<OPTION VALUE="ALL" >ALL</OPTION>
				</SELECT>
			</TD>	
			<TD width="2%" align="left"  CLASS="bold" COLSPAN="2">
				&nbsp;Scrip&nbsp;:
			</TD>
			<TD width="16%" align="left"  CLASS="bold" COLSPAN="2">
				<SELECT NAME="txtScrip" onBlur="CallDynamic('ScreenInputs','OrderNo');" style="font:'Times New Roman', Times, serif; font-size:10px; width:100%;" >
						<OPTION VALUE="" >ALL</OPTION>
				</SELECT>				
			</TD>		
		  	<TD width="7%" align="left"  CLASS="bold">
				&nbsp;Cont.No&nbsp;:
			</TD>			
<!--- 		  	<TD width="10%" align="left"  CLASS="bold">
				<SELECT NAME="txtOrderNo" style="font:'Times New Roman', Times, serif; font-size:10px; width:100%;">
						<OPTION VALUE="ALL" >ALL</OPTION>
				</SELECT>
			</TD> --->
		  	<TD width="10%" align="left"  CLASS="bold">
				<SELECT NAME="txtContractNo" style="font:'Times New Roman', Times, serif; font-size:10px; width:100%;">
						<OPTION VALUE="" >ALL</OPTION>
				</SELECT>
			</TD>

			
	    </TR>
		<TR>
			<TH ALIGN="LEFT"  COLSPAN="5" CLASS="bold" NOWRAP>
			Option&nbsp;:&nbsp;
				<INPUT TYPE="RADIO" NAME="OptFormat" VALUE="P">Process
				<INPUT TYPE="RADIO" NAME="OptFormat" VALUE="NSECSV">Nse It CSV
				<INPUT TYPE="RADIO" NAME="OptFormat" VALUE="STP" checked>STP
				<INPUT TYPE="RADIO" NAME="OptFormat" VALUE="NSDL" >NSDL STP
			</TH>
			
			<TH ALIGN="LEFT"  COLSPAN="1" CLASS="bold" NOWRAP>
				Batch Number&nbsp;:&nbsp;
				<INPUT TYPE="TEXT" NAME="BatchNumber"  SIZE="5" MAXLENGTH="5" class="StyleTextBox">
			</TH>
			
			<TH ALIGN="LEFT"  COLSPAN="7" CLASS="bold" NOWRAP>
				Contract Information&nbsp;:&nbsp;
				<INPUT TYPE="RADIO" NAME="OptContractInf" VALUE="Summary">Summary
				<INPUT TYPE="RADIO" NAME="OptContractInf" VALUE="Details" checked>Detail
			</TH>
			
			<TH align="RIGHT" width="4%" >
				<INPUT accesskey="O" type="Submit" name="Ok" value="View" class="StyleSmallButton1">&nbsp;				
			</TH >
			
		</TR>		
		</TR>
		</TABLE>
</CFFORM>

</CFOUTPUT>
</BODY>
</HTML>