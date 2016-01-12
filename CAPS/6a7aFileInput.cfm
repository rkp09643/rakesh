<!---- **************************************************************
	BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*************************************************************** ---->


<HTML>
<HEAD>
	<TITLE> Client Overview Input Screen. </TITLE>
	<LINK href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	
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
					parent.top.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FormObject=parent.Display.Inputs.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value+"&TradeDate=" + txtOrderDate.value+"&Par=" + par+"&SetlNo=" + txtSetlId.value +"&Client123=" + txtClientID.value ;
				}
				if(par == 'Scrip')
				{
					parent.top.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FormObject=parent.Display.Inputs.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value+"&TradeDate=" + txtOrderDate.value+"&Par=" + par+"&SetlNo=" + txtSetlId.value +"&Client123=" + txtClientID.value +"&OrderNo=" + txtOrderNo.value  ;
				}				
			}
		}
		
		function setBatchNo()
		{
			batchNo = prompt( "Enter BatchNo.", "01", "Batch" );
			ScreenInputs.batchNo.value = batchNo;
		}
	</SCRIPT>
</HEAD>

<BODY leftmargin="0" rightmargin="0" onFocus="CloseWindow();">
<CFOUTPUT>


<CFFORM name="StpFileGen" action="6a7aFileView.cfm" method="POST" target="reports">
	<INPUT type="Hidden" name="COCD" value="#Trim(COCD)#">
	<INPUT type="Hidden" name="COName" value="#COName#">
	<INPUT type="Hidden" name="Market" value="#Market#">
	<INPUT type="Hidden" name="Exchange" value="#Exchange#">
	<INPUT type="Hidden" name="Broker" value="#Broker#">
	<INPUT type="Hidden" name="FinStart" value="#FinStart#">
	<INPUT type="Hidden" name="FinEnd" value="#FinStart+1#">
	<INPUT type="Hidden" name="batchNo" value="01">

	<TABLE WIDTH="100%" align="CENTER" border="0" cellpadding="0" cellspacing="0" class="StyleReportParameterTable1">
	    <TR>
		  	<TD width="10%">
				Order Date&nbsp;:&nbsp;
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
			
			<TD align="center" width="10%">
				Mkt&nbsp;:&nbsp;
				<SELECT name="Mkt_Type" style="font:'Times New Roman', Times, serif; font-size:11px;" onBlur="CallDynamic('ScreenInputs','Mkt');">
					<OPTION VALUE="N">N</OPTION>
					<OPTION VALUE="T">T</OPTION>
				</SELECT>&nbsp;
			</TD>
      		<TD width="10%">
				Setl.&nbsp;:&nbsp;
				<SELECT NAME="txtSetlId" style="font:'Times New Roman', Times, serif; font-size:10px; width:60%;">
					
				</SELECT>
				
				
<!--- 				<CFINPUT TYPE="text" NAME="" MAXLENGTH="20" SIZE="10" class="StyleTextBox" onBlur="CallDynamic('ScreenInputs','Client');"> --->
			</TD>
			<TH align="center" width="10%">&nbsp;
				<INPUT accesskey="O" type="Submit" name="Ok" value="View" class="StyleSmallButton1">&nbsp;				
			</TH >
      		<!--- <TD width="10%">
				Client&nbsp;:&nbsp;
				<SELECT NAME="txtClientID" onBlur="CallDynamic('ScreenInputs','OrderNo');" style="font:'Times New Roman', Times, serif; font-size:10px; width:60%;">
					
				</SELECT>
			</TD>		 --->	
	    </TR>
		<!--- <tr>
		  	<TD width="10%" colspan="3">
				Order No.&nbsp;:&nbsp;
				<SELECT NAME="txtOrderNo" onBlur="CallDynamic('ScreenInputs','Scrip');" style="font:'Times New Roman', Times, serif; font-size:10px; width:40%;">
					
				</SELECT>
			</TD>
			<TD width="10%">
				Scrip&nbsp;:&nbsp;
				<SELECT NAME="txtScrip" style="font:'Times New Roman', Times, serif; font-size:10px; width:100%;" >
					
				</SELECT>				
			</TD>			
			<TH align="center" width="10%">&nbsp;
				<INPUT accesskey="O" type="Submit" name="Ok" value="View" class="StyleSmallButton1">&nbsp;				
			</TH >
		</tr> --->
  </TABLE>
</CFFORM>

</CFOUTPUT>
</BODY>
</HTML>