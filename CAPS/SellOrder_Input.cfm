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
					parent.top.HideAndShow.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&txtScrip=" +txtScrip.value +"&FormObject=parent.Display.Inputs.document." +name +"&FormName=" +name +"&VariableName=Settlement&MktType=" +Mkt_Type.value+"&TradeDate=" + txtOrderDate.value+"&Par=" + par+"&SetlNo=" + txtSetlId.value +"&Client123=" + txtClientID.value  ;
				}				
			}
		}
	</SCRIPT>
    <LINK HREF="../../CSS/style1.css" REL="stylesheet" TYPE="text/css">

</HEAD>

<BODY leftmargin="0" rightmargin="0" onFocus="CloseWindow();">


<CFOUTPUT>
	<CFPARAM NAME="TxtDate" 		DEFAULT="">
	<CFPARAM NAME="txtCOCD" 		DEFAULT="">
	<CFPARAM NAME="Branch" 		    DEFAULT="">
	<CFPARAM NAME="txtFamily" 		DEFAULT="">
	<CFPARAM NAME="txtClientID" 	DEFAULT="">
	<CFPARAM NAME="txtUserId" 		DEFAULT="">
	<CFPARAM NAME="txtAgeingDays" 	DEFAULT="">
	<CFPARAM NAME="txtAmount" 		DEFAULT="">
 	<CFPARAM NAME="txtPer" 			DEFAULT="">
	<CFPARAM NAME="txtBen" 			DEFAULT="">
	<CFPARAM NAME="txtPricePer" 	DEFAULT="">
	<CFPARAM NAME="txtScrip" 	    DEFAULT="">
	<CFPARAM NAME="RdoUNCCredit" 	DEFAULT="">
	<CFPARAM NAME="RDOFAC" 			DEFAULT="">
	<CFPARAM NAME="RDOPOA" 			DEFAULT="">
	
<CFFORM name="StpFileGen" action="SellOrderView.cfm" method="POST" target="reports">
				
	<INPUT type="Hidden" name="FinStart" 	value="#FinStart#">
	<INPUT type="Hidden" name="FinEnd" 		value="#FinStart+1#">
	<INPUT type="Hidden" name="TxtDate" 	value="#txtDate#">
	<INPUT type="Hidden" name="COCD" 		value="#Trim(COCD)#">
	<INPUT type="Hidden" name="COName" 		value="#COName#">
	<INPUT type="Hidden" name="Market" 		value="#Market#">
	<INPUT type="Hidden" name="Exchange" 	value="#Exchange#">
	<INPUT type="Hidden" name="Broker" 		value="#Broker#">
	<INPUT type="Hidden" name="txtUserId" 	value="#txtUserId#">
	<INPUT type="Hidden" name="txtAgeingDays" value="#txtAgeingDays#">
	<INPUT type="Hidden" name="txtAmount" 	value="#txtAmount#">
	<INPUT type="Hidden" name="txtPer" 		value="#txtPer#">
	<INPUT type="Hidden" name="txtPricePer" value="#txtPricePer#">
	<INPUT type="Hidden" name="txtScrip" value="#txtScrip#">
	<INPUT type="Hidden" name="BENLIST" 	value="#txtBen#">
	<INPUT type="Hidden" name="ANUTOCREDIT" value="#RdoUNCCredit#">
	<INPUT type="Hidden" name="ACCESSFUTURECASH" value="#RDOFAC#">
	<INPUT type="Hidden" name="RDOPOA" value="#RDOPOA#">

	<TABLE WIDTH="100%" border="1" cellpadding="0" cellspacing="0" class="StyleReportParameterTable1" STYLE="background-color:PINK">
	    <TR>
			<CFSET Help="Select distinct Company_Code,Company_name From Company_Master Order by Company_Code" >
			<TH ALIGN="RIGHT" WIDTH="8%">Company&nbsp;:</TH>			
			<TD ALIGN="left" WIDTH="14%" >
				<INPUT TYPE="text" NAME="txtCOCD" CLASS="StyleTextBox" cols="10" SIZE="8">
				<INPUT TYPE="Button" NAME="cmdCOCD" VALUE=" ? " CLASS="StyleSmallButton1" style="Cursor : Help;" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtCOCD&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
			</TD>	
			<TH WIDTH="8%" ALIGN="RIGHT">Client&nbsp:</TH>
			<CFSET Help="Select distinct Client_id,client_name From client_master Order by Client_id" >
			<TD WIDTH="16%" ALIGN="left" ><INPUT TYPE="text" NAME="txtClientID" CLASS="StyleTextBox" cols="10" SIZE="12">
                <INPUT TYPE="Button" NAME="cmdClientHelp" VALUE=" ? " CLASS="StyleSmallButton1" style="Cursor : Help;" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtClientID&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
            </TD>
			<TH COLSPAN="1" ALIGN="RIGHT" nowrap>From Amt&nbsp;:</TH>
			<TD COLSPAN="1" CLASS="bold"><CFINPUT TYPE="text" NAME="txtAmount"  VALUE="0" MAXLENGTH="10" SIZE="10" class="StyleTextBox">
            </TD>
			<TH ALIGN="RIGHT" COLSPAN="1" WIDTH="10%">ODIN FILE &nbsp;:</TH>
			<TD ALIGN="left" COLSPAN="1" WIDTH="12%">
				<INPUT TYPE="radio"  CLASS="bold" name="RDOODIN" value="Y" STYLE="Border: 0pt Solid Black;"    > 
				Yes
				<INPUT TYPE="radio"  CLASS="bold" name="RDOODIN" value="N" STYLE="Border: 0pt Solid Black;"   CHECKED >  
				No</TD>
			<TH ALIGN="RIGHT">Leg. Date&nbsp;:</TH>
			<TD ALIGN="left"><label FOR="PRINTDATE" CLASS="Hand">
              <SCRIPT LANGUAGE="VBSCRIPT">0
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
                <CFINPUT TYPE="text" NAME="txtDate" VALIDATE="EURODATE" MESSAGE="Please enter Proper Date." VALUE="#DateFormat(now(),"DD/MM/YYYY")#" MAXLENGTH="10" SIZE="10" class="StyleTextBox">
            </TD>
			<CFSET Help="Select Distinct client_id,client_name from client_master" >
			
			
	</TR>
		<TR>
			<CFSET Help="Select Branch_code,Branch_Name,MAIN_BRANCH_CODE From Branch_Master" >
		  <TH ALIGN="RIGHT">Branch&nbsp:</TH>
		  <TD ALIGN="left" ><INPUT TYPE="text" NAME="txtBranch" CLASS="StyleTextBox" cols="10" SIZE="12">
              <INPUT TYPE="Button" NAME="cmdBranchHelp" VALUE=" ? " CLASS="StyleSmallButton1" style="Cursor : Help;" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtBranch&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
          </TD>
		  	<Cfset Help = "select distinct client_id A_CLCODE,client_dp_name from io_dp_master where Client_nature = ~B~">
			<TH ALIGN="RIGHT">Beneficiary&nbsp;: </TH>
			<TD ALIGN="left" ><textarea NAME="txtBen" rows="1" class="" cols="8"></textarea>
			<INPUT TYPE="Button" NAME="cmdBen" VALUE=" ? " CLASS="StyleSmallButton1" style="Cursor : Help;" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtBen&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
            </TD>
			<TH  COLSPAN="1" ALIGN="RIGHT"> <div align="right">To Amt&nbsp;:</div></TH>
			<TD COLSPAN="1"  CLASS="bold"><cfinput type="text" name="txtAmount1"  value="0" maxlength="10" size="10" class="StyleTextBox">
            </TD>
			<TH ALIGN="right" COLSPAN="1" WIDTH="10%">&nbsp;UNC Cr&nbsp;:</TH>
			<TD ALIGN="left"  COLSPAN="1" WIDTH="12%">
				<INPUT TYPE="radio"  CLASS="bold" name="RdoUNCCredit" value="Y" STYLE="Border: 0pt Solid Black;"   > Yes
				<INPUT TYPE="radio"  CLASS="bold" name="RdoUNCCredit" value="N" STYLE="Border: 0pt Solid Black;"  CHECKED   >  No
			</TD>

			<TH WIDTH="8%" COLSPAN="1" ALIGN="RIGHT">&nbsp;Per %&nbsp;:</TH>
			<TD ALIGN="LEFT"  COLSPAN="1" CLASS="bold"><INPUT TYPE="TEXT" NAME="txtPer" SIZE="5" VALUE="0" MAXLENGTH="5" class="StyleTextBox">
            </TD>
			
			
		</TR>		
		<TR>
			<CFSET Help="Select Groupcode,GroupName From FA_GROUPMASTER" >
		  <TH ALIGN="RIGHT">Family&nbsp:</TH>
		  <TD ALIGN="left" ><INPUT TYPE="text" NAME="txtFamily" CLASS="StyleTextBox" cols="10" SIZE="12">
              <INPUT TYPE="Button" NAME="cmdFamilyHelp" VALUE=" ? " CLASS="StyleSmallButton1" style="Cursor : Help;" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtFamily&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
          </TD>
			<TH width="10%" COLSPAN="1" ALIGN="RIGHT">Scrip Not Inc&nbsp;:</TH>
			<TD width="8%"  COLSPAN="1" CLASS="bold"><CFINPUT TYPE="text" NAME="txtScrip"  VALUE="" MAXLENGTH="500" SIZE="10" class="StyleTextBox">
            </TD>
			<th colspan="1" align="right">Days&nbsp;:</th>
			<td  colspan="1" class="bold" align="left"><cfinput type="text" name="txtAgeingDays" value="0" maxlength="10" size="5" class="StyleTextBox">
            </td>
			<TH ALIGN="RIGHT" COLSPAN="1" WIDTH="10%">POA&nbsp;:</TH>
			<TD ALIGN="left" COLSPAN="1" WIDTH="12%">
				<INPUT TYPE="radio"  CLASS="bold" name="RDOPOA" value="Y" STYLE="Border: 0pt Solid Black;"    > Yes
				<INPUT TYPE="radio"  CLASS="bold" name="RDOPOA" value="N" STYLE="Border: 0pt Solid Black;" CHECKED   >  No
			</TD>
			 <TH  COLSPAN="1" ALIGN="left"><div align="right">Price%&nbsp;:</div></TH>
			 <TD  COLSPAN="1" CLASS="bold"><CFINPUT TYPE="text" NAME="txtPricePer"  VALUE="+0" MAXLENGTH="10" SIZE="10" class="StyleTextBox">
             </TD>
			</TR> 
		  <TR>
			<TH ALIGN="RIGHT" COLSPAN="1" >&nbsp;Fut. Acces Cash&nbsp;:</TH>
			<TD ALIGN="left" COLSPAN="1" WIDTH="12%"><INPUT TYPE="radio"  CLASS="bold" name="RDOFAC" value="Y" STYLE="Border: 0pt Solid Black;" CHECKED   >
			  Yes
				<INPUT TYPE="radio"  CLASS="bold" name="RDOFAC" value="N" STYLE="Border: 0pt Solid Black;"    >
			  No </TD>
			  
		    <TH ALIGN="RIGHT" COLSPAN="1" WIDTH="8%">Add.To Sms&nbsp;:</TH>			
			<TD ALIGN="left" COLSPAN="1" WIDTH="12%">
				<INPUT TYPE="radio"  CLASS="bold" name="Sms" value="Y" STYLE="Border: 0pt Solid Black;" > Yes
				<INPUT TYPE="radio"  CLASS="bold" name="Sms" value="N" STYLE="Border: 0pt Solid Black;"   CHECKED    > No 
			</TD>
		    <TH ALIGN="RIGHT" COLSPAN="1" WIDTH="8%">Omnisys File Gen.&nbsp;:</TH>	
			<TD ALIGN="left">
				<SELECT name="OMNISYSFILE" style="font:'Times New Roman', Times, serif; font-size:10px; width:80%;">
					<OPTION value="N" selected>No</OPTION>
					<OPTION value="Y">Yes</OPTION>
				</SELECT>
				<!--- <INPUT TYPE="radio"  CLASS="bold" name="OMNISYSFILE" value="Y" STYLE="Border: 0pt Solid Black;" > Yes
				<INPUT TYPE="radio"  CLASS="bold" name="OMNISYSFILE" value="N" STYLE="Border: 0pt Solid Black;"   CHECKED    > No  --->
			</TD> 
			<TH ALIGN="RIGHT" COLSPAN="1" WIDTH="8%">Incl. Cash Asso.&nbsp;:</TH>	
			<TD ALIGN="left">
				<SELECT name="INCCASHASS" style="font:'Times New Roman', Times, serif; font-size:10px; width:50%;">
					<OPTION value="N" selected>No</OPTION>
					<OPTION value="Y">Yes</OPTION>
				</SELECT>
				<!--- <INPUT TYPE="radio"  CLASS="bold" name="OMNISYSFILE" value="Y" STYLE="Border: 0pt Solid Black;" > Yes
				<INPUT TYPE="radio"  CLASS="bold" name="OMNISYSFILE" value="N" STYLE="Border: 0pt Solid Black;"   CHECKED    > No  --->
			</TD> 
			<TH ALIGN="Right" COLSPAN="1" WIDTH="8%">POA %&nbsp;:</TH>	
			<TD ALIGN="left">
				<INPUT TYPE="TEXT" NAME="POApercentage" SIZE="5" VALUE="0" MAXLENGTH="5" class="StyleTextBox">
			</TD> 
			<TH align="RIGHT"  colspan="2" width="4%" >
				<INPUT accesskey="O" type="Submit" name="Ok" value="View" class="StyleSmallButton1">&nbsp;				
			</TH >
		  </TR>
		
	</TABLE>

</CFFORM>
<TABLE WIDTH="100%" border="1" cellpadding="0" cellspacing="0" class="StyleReportParameterTable1" STYLE="background-color:PINK">
  
</TABLE>
</CFOUTPUT>
</BODY>
</HTML>