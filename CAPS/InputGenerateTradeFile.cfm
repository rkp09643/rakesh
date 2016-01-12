<cfinclude template="/focaps/help.cfm">
<cfinclude template="/focaps/help.cfm">
<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->


<html>
<head>
	<title> Expiry Process. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	
	<STYLE>
		DIV#Heading
		{
			Font		:	Bold 10pt Tahoma;
			Color		:	Navy;
			Position	:	Absolute;
			Top			:	0;
			Width		:	100%;
		}
		DIV#Header
		{
			Position	:	Absolute;
			Top			:	6%;
			Width		:	100%;
		}
		DIV#Datas
		{
			Position	:	Absolute;
			Top			:	80%;
			Width		:	100%;
			Height		: 	20%;
			Overflow	:	Auto;
		}
	</STYLE>
</head>

<SCRIPT LANGUAGE="VBSCRIPT">
	sub setValue()
		with GenTrd
			<CFIF Not IsDefined("Client.GroupID")>
				.Exchange.value = Left(.COCD.value,3)
			</CFIF>
			if .Exchange.value  = "BSE" then
				BSERadio.style.display=""
				NSERadio.style.display="none"
				.optFileType(2).checked = true
			else
				BSERadio.style.display="none"
				NSERadio.style.display=""
				.optFileType(0).checked = true
			end if	
		end with
	end sub
</SCRIPT>

<body leftmargin="0" rightmargin="0" Class="StyleBody1" onLoad="document.GenTrd.from_date.focus();">
<CFOUTPUT>
<div align="center" id="Heading">
	<u>Generate Trade File</u>
</div>


<div align="center" id="Header">
	<CFFORM NAME="GenTrd" action="GenerateTradeFile.cfm" method="post" PRESERVEDATA="YES">

		<CFIF IsDefined("Client.GroupID")>
			<input type="Hidden" name="COCD" value="#Trim(UCase(COCD))#">
			<input type="Hidden" name="CoName" value="#Trim(UCase(CoName))#"> 
			<input type="Hidden" name="Broker" value="#Trim(UCase(Broker))#">
			<input type="Hidden" name="Market" value="#Trim(UCase(Market))#">
			<input type="Hidden" name="Exchange" value="#Trim(UCase(Exchange))#">	
			<input type="Hidden" Name="FinStart" value="#Val(Trim(FinStart))#">
			<input type="Hidden" Name="FinEnd" value="#Val(Trim(FinEnd))#">
			<input type="Hidden" Name="CoGroup" value="#Trim(CoGroup)#">
		</CFIF>
			<INPUT TYPE="HIDDEN" NAME="Generate" VALUE="No">
		
		<CFQUERY NAME="GetCompanyList" datasource="#Client.database#" DBTYPE="ODBC">
			Select	COMPANY_CODE, COMPANY_NAME, MARKET, EXCHANGE
			From
				Company_Master
			Where
					Market		=	'CAPS'	
		</CFQUERY>

		<table width="70%" align="center" border="1" cellpadding="0" cellspacing="0" class="StyleCommonMastersTable">
			<CFIF Not IsDefined("Client.GroupID")>
			<TR>
				<th align="right" width="10%" style="Color: Purple;" NOWRAP>
					Com. Name :&nbsp;
				</th>
				<td align="left" WIDTH="30%" VALIGN="top">
					<select name="COCD" ONCHANGE="setValue();" style="border: thin none Navy; color: Orange; font-family: Arial; font-size: 8pt; font-weight: bold;">
						<CFLOOP QUERY="GetCompanyList">
							<OPTION VALUE="#EXCHANGE#~#COMPANY_CODE#">#COMPANY_CODE# &nbsp;-&nbsp;#COMPANY_NAME#&nbsp;-&nbsp;#MARKET#&nbsp;-&nbsp;#EXCHANGE# 
						</CFLOOP>
					</select>
				</td>
			</TR>
			<input type="Hidden" name="CoName" value=""> 
			<input type="Hidden" name="Broker" value="">
			<input type="Hidden" name="Market" value="">
			<input type="Hidden" name="Exchange" value="">	
			</CFIF>
			<tr>
				<th align="right" width="10%"> From Date :&nbsp; </th>
				<th align="left" width="30%">
					<label FOR="From_Date" CLASS="Hand">
						<SCRIPT LANGUAGE="VBSCRIPT">
							Sub	From_Date_OnKeyuP()
									DSTR = GenTrd.From_Date.value
									DLEN = LEN(GenTrd.From_Date.value)
									IF DLEN = 2 OR DLEN = 5 THEN
										GenTrd.From_Date.value = DSTR + "/"
									END IF	
							END SUB
							Sub	From_Date_GotFocus()	
									GenTrd.From_Date.SelStart = 0
									GenTrd.From_Date.SelLength = LEN(GenTrd.From_Date.value)
							END SUB
						</SCRIPT>	
						<cfinput type="Text" name="from_date" value="#DateFormat(now(),"DD/MM/YYYY")#" message="DATE FORMAT: DD/MM/YYYY" validate="eurodate" required="Yes" size="8" maxlength="10" tabindex="1" class="StyleTextBox">	
					</LABEL>
					
				</th>
			</TR>
			<tr>
				<th align="right" width="10%"> To Date :&nbsp; </th>
				<th align="left" width="30%">
				<label FOR="From_Date" CLASS="Hand">
						<SCRIPT LANGUAGE="VBSCRIPT">
							Sub	to_date_OnKeyuP()
									DSTR = GenTrd.to_date.value
									DLEN = LEN(GenTrd.to_date.value)
									IF DLEN = 2 OR DLEN = 5 THEN
										GenTrd.to_date.value = DSTR + "/"
									END IF	
							END SUB
							Sub	to_date_GotFocus()	
									GenTrd.to_date.SelStart = 0
									GenTrd.to_date.SelLength = LEN(GenTrd.to_date.value)
							END SUB
						</SCRIPT>	
						<cfinput type="Text" name="to_date" value="#DateFormat(now(),"DD/MM/YYYY")#" message="DATE FORMAT: DD/MM/YYYY" validate="eurodate" required="Yes" size="8" maxlength="10" tabindex="1" class="StyleTextBox">
					</LABEL>
					
				</th>
			</TR>
			<tr>
				<th align="right" width="10%" height="22"> File Type :&nbsp; </th>
					<th align="left" width="10%" height="22" ID="NSERadio">
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Online" ID="OnLine" CHECKED>
						<LABEL FOR="Online">Online</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Terminal" ID="Terminal">
						<LABEL FOR="Terminal">Terminal</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="MONEY" ID="MN">
						<LABEL FOR="MN">Money Ware</LABEL>
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Royal" ID="MN">
						<LABEL FOR="MN">Royal CM</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Rel" ID="Rel">
						<LABEL FOR="MN">Rel Trade</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Abn" ID="Rel">
						<LABEL FOR="MN">Abn</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Inst" ID="Rel">
						<LABEL FOR="MN">INST File</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="FT_RM" ID="Rel">
						<LABEL FOR="MN">FT_RM File</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Deals" ID="Rel">
						<LABEL FOR="MN">Deals</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Royal_NEW" ID="MN">
						<LABEL FOR="MN">Royal CM1</LABEL>	<br>
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="PanVery" ID="PanVery">
						<LABEL FOR="PanVery">PanVery xml fILE</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="TradeFile" ID="TradeFile">
						<LABEL FOR="PanVery">Trade File</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Sony" ID="Sony" CHECKED>
						<LABEL FOR="Online">Sony</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Adlwise" ID="Adlwise" CHECKED>
						<LABEL FOR="Online">Adlwise(Institure)</LABEL>	
 					</TH>
 					<th align="left" width="10%" height="22" ID="BSERadio">
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="BR" ID="BR" CHECKED>
						<LABEL FOR="BR">BR File</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="TR" ID="TR">
						<LABEL FOR="TR">TR File</LABEL>
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="MONEY" ID="MN">
						<LABEL FOR="MN">Money Ware</LABEL>
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Royal" ID="MN">
						<LABEL FOR="MN">Royal CM</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Rel" ID="Rel">
						<LABEL FOR="MN">Rel Trade</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Abn" ID="Rel">
						<LABEL FOR="MN">Abn</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Inst" ID="Rel">
						<LABEL FOR="MN">INST File</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="FT_RM" ID="Rel">
						<LABEL FOR="MN">FT_RM File</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Deals" ID="Rel">
						<LABEL FOR="MN">Deals</LABEL>	
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Royal_New" ID="MN">
						<LABEL FOR="MN">Royal CM1</LABEL>	<br>

						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="PanVery" ID="PanVery">
						<LABEL FOR="PanVery">PanVery xml fILE</LABEL>	

						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="TradeFile" ID="TradeFile">
						<LABEL FOR="PanVery">Trade File</LABEL>	

						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="Sony" ID="Sony" CHECKED>
						<LABEL FOR="Online">Sony</LABEL>	
						<BR>
						<INPUT TYPE="RADIO" NAME="optFileType" VALUE="PanTin" ID="PanTin" CHECKED>
						<LABEL FOR="Online">Pan Verification (NSDL)</LABEL>	
					</TH>
				</th>
			</TR>
			<tr>
				<th align="right" width="20%" height="22"> Rate :&nbsp; </th>
				<th align="left" width="10%" height="22">
						<INPUT TYPE="RADIO" NAME="optRateType" VALUE="Rate" ID="Rate" CHECKED>
						<LABEL FOR="Rate">Rate</LABEL>	
						<INPUT TYPE="RADIO" NAME="optRateType" VALUE="RateWithBrk" ID="RateBrk">
						<LABEL FOR="RateBrk">Rate with Brokerage</LABEL>
				</th>
			</TR>
			<tr>
									<TH  ALIGN="RIGHT">Category :&nbsp;</TH>
												<TD ALIGN="LEFT">
													<SELECT  NAME="cmbCategory" CLASS="clsOccupation" STYLE="width:130; " onChange="hideshow3(this.form,this.value);">
														<OPTION VALUE="">[Select Category]</OPTION>		
														<CFIF IsDefined("ModifyDetails") AND ModifyDetails EQ "Yes">
														<OPTION VALUE="I" <CFIF Trim(GetClientDetails.CATEGORY) eq 'I'>SELECTED</CFIF>>Individual</OPTION>
														<OPTION VALUE="HUF" <CFIF Trim(GetClientDetails.CATEGORY) eq 'HUF'>SELECTED</CFIF>>HUF</OPTION>
														<OPTION VALUE="CO" <CFIF Trim(GetClientDetails.CATEGORY) eq 'CO'>SELECTED</CFIF>>Body Corporate</OPTION>
														<OPTION VALUE="OCB" <CFIF Trim(GetClientDetails.CATEGORY) eq 'OCB'>SELECTED</CFIF>>Overseas Corporate Body</OPTION>
														<OPTION VALUE="PF" <CFIF Trim(GetClientDetails.CATEGORY) eq 'PF'>SELECTED</CFIF>>Partnership Firm</OPTION>
														<OPTION VALUE="NT" <CFIF Trim(GetClientDetails.CATEGORY) eq 'NT'>SELECTED</CFIF>>Non-Tax</OPTION>
														<OPTION VALUE="MF" <CFIF Trim(GetClientDetails.CATEGORY) eq 'MF'>SELECTED</CFIF>>Mutual Fund</OPTION>
														<OPTION VALUE="MB" <CFIF Trim(GetClientDetails.CATEGORY) eq 'MB'>SELECTED</CFIF>>Merchant Banker</OPTION>
														<OPTION VALUE="FII" <CFIF Trim(GetClientDetails.CATEGORY) eq 'FII'>SELECTED</CFIF>>Foreign Institutional Investor</OPTION>
														<OPTION VALUE="IFI" <CFIF Trim(GetClientDetails.CATEGORY) eq 'IFI'>SELECTED</CFIF>>Indian Financial Institutions</OPTION>
														<OPTION VALUE="B" <CFIF Trim(GetClientDetails.CATEGORY) eq 'B'>SELECTED</CFIF>>Bank</OPTION>
														<OPTION VALUE="SP" <CFIF Trim(GetClientDetails.CATEGORY) eq 'SP'>SELECTED</CFIF>>Sole Proprietorship</OPTION>
														<OPTION VALUE="TS" <CFIF Trim(GetClientDetails.CATEGORY) eq 'TS'>SELECTED</CFIF>>Trust/Society</OPTION>
														<OPTION VALUE="LIC" <CFIF Trim(GetClientDetails.CATEGORY) eq 'LIC'>SELECTED</CFIF>>Insurance</OPTION>
														<OPTION VALUE="NRI" <CFIF Trim(GetClientDetails.CATEGORY) eq 'NRI'>SELECTED</CFIF>>NRI</OPTION>
														<OPTION VALUE="SB" <CFIF Trim(GetClientDetails.CATEGORY) eq 'SB'>SELECTED</CFIF>>Saturity Bodies</OPTION>
														<OPTION VALUE="O" <CFIF Trim(GetClientDetails.CATEGORY) eq 'O'>SELECTED</CFIF>>Others</OPTION>
														<OPTION VALUE="FVCF" <CFIF Trim(GetClientDetails.CATEGORY) eq 'FVCF'>SELECTED</CFIF>>Foreign Venture Cap. Fund</OPTION>
														<OPTION VALUE="PMS" <CFIF Trim(GetClientDetails.CATEGORY) eq 'PMS'>SELECTED</CFIF>>PMS</OPTION>
														<OPTION VALUE="PVTLTD" <CFIF Trim(GetClientDetails.CATEGORY) eq 'PVTLTD'>SELECTED</CFIF>> Private Limited Company </OPTION>
														<OPTION VALUE="LTDCO" <CFIF Trim(GetClientDetails.CATEGORY) eq 'LTDCO'>SELECTED</CFIF>> Limited Company </OPTION>
														<OPTION VALUE="COOP" <CFIF Trim(GetClientDetails.CATEGORY) eq 'COOP'>SELECTED</CFIF>> Co-Operatives </OPTION>
														
														<!--- <input type="Text" name="Occupation" value="#Trim(GetClientDetails.OCCUPATION)#" maxlength="100" Class="clsOccupation"> --->
														<CFELSE>
														<OPTION VALUE="I" SELECTED >Individual</OPTION>
														<OPTION VALUE="HUF" >HUF</OPTION>
														<OPTION VALUE="CO" >Body Corporate</OPTION>
														<OPTION VALUE="OCB" >Overseas Corporate Body</OPTION>
														<OPTION VALUE="PF" >Partnership Firm</OPTION>
														<OPTION VALUE="NT" >Non-Tax</OPTION>
														<OPTION VALUE="MF" >Mutual Fund</OPTION>
														<OPTION VALUE="MB" >Merchant Banker</OPTION>
														<OPTION VALUE="FII" >Foreign Institutional Investor</OPTION>
														<OPTION VALUE="IFI" >Indian Financial Institutions</OPTION>
														<OPTION VALUE="B" >Bank</OPTION>
														<OPTION VALUE="SP" >Sole Proprietorship</OPTION>
														<OPTION VALUE="TS" >Trust/Society</OPTION>
														<OPTION VALUE="LIC" >Insurance</OPTION>
														<OPTION VALUE="NRI" >NRI</OPTION>
														<OPTION VALUE="SB" >Saturity Bodies</OPTION>
														<OPTION VALUE="FVCF" >Foreign Venture Cap. Fund</OPTION>
														<OPTION VALUE="PMS"SELECTED>PMS</OPTION>
														<OPTION VALUE="O" >Others</OPTION>
														
														</CFIF>
													</SELECT>
												</TD>
												</tr>
			<tr>
				<th align="right" width="20%" height="22"> Gen. Type :&nbsp; </th>
				<th align="left" width="10%" height="22">
						<INPUT TYPE="RADIO" NAME="OptGenType" VALUE="S" ID="Summery" CHECKED>
						<LABEL FOR="Summery">Summary</LABEL>	
						<INPUT TYPE="RADIO" NAME="OptGenType" VALUE="D" ID="Detail">
						<LABEL FOR="Detail">Detail</LABEL>
				</th>
			</TR>
			
			
			<tr>
			<Cfset Help = "Select Branch_code,Branch_Name From Branch_master	">
				<th align="right" width="20%" height="22" style="cursor:help"
				OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=BranchList&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );"
				> Branch :&nbsp; </th>
				<th align="left" width="10%" height="22">&nbsp;
					<CFIF IsDefined("ReportType") And ReportType EQ "Branch">
						#Client.BranchCode#
						<INPUT TYPE="HIDDEN" NAME="BranchList" VALUE="#Trim(Client.BranchCode)#">
					<CFELSEIF IsDefined("CLIENT.GroupID")>
						<TEXTAREA NAME="BranchList" COLS="20" ROWS="3"></TEXTAREA>
					<CFELSE>
						None
						<INPUT TYPE="HIDDEN" NAME="BranchList" VALUE="">
					</CFIF>
				</th>
			</TR>
			<tr>
				<Cfset Help = "select RTrim(Ltrim(GroupCode)) GroupCode,Groupname from familymaster order by GroupCode">
				<th align="right" width="20%" height="22" style="cursor:help"
				OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=FamilyList&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );"
				> Family:&nbsp; </th>
				<th align="left" width="10%" height="22">&nbsp;
					<CFIF IsDefined("ReportType") And ReportType EQ "Branch">
						<TEXTAREA NAME="FamilyList" COLS="20" ROWS="3"></TEXTAREA>
					<CFELSEIF IsDefined("CLIENT.GroupID")>
						<TEXTAREA NAME="FamilyList" COLS="20" ROWS="3"></TEXTAREA>
					<CFELSE>
						None
						<INPUT TYPE="HIDDEN" NAME="FamilyList" VALUE="">
					</CFIF>
				</th>
			</TR>
			<tr>
				<Cfset Help = "select Distinct client_id,client_name,INTRODUCER_CODE from client_detail_view">
				<th align="right" width="20%" height="22"
				style="cursor:help"
				OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=ClientList&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );"
				> Client :&nbsp; </th>
				<th align="left" width="10%" height="22">&nbsp;
					<CFIF IsDefined("ReportType") And ReportType EQ "Client">
						#Trim(CLIENT.CLIENT_ID)#
						<INPUT TYPE="HIDDEN" NAME="ClientList" VALUE="#Trim(CLIENT.CLIENT_ID)#">
					<CFELSEIF IsDefined("CLIENT.GroupID") OR ReportType EQ "Branch">
						<TEXTAREA NAME="ClientList" COLS="20" ROWS="3"></TEXTAREA>
					<CFELSE>
						None
						<INPUT TYPE="HIDDEN" NAME="ClientList" VALUE="">
					</CFIF>
					
				</th>
				
												
			
			<tr>
				<th align="right" width="20%" height="22"> TerminalID List :&nbsp; </th>
				<th align="left" width="10%" height="22">
					&nbsp;&nbsp;<TEXTAREA NAME="TerminalList" COLS="20" ROWS="3"></TEXTAREA>
				</th>
			</TR>
			<TR>
				<th width="20%" height="22" COLSPAN="2">
					<input type="Submit" name="cmdGenerate" value="Generate" tabindex="3" class="StyleSmallButton1" onClick="this.form.Generate.value='Yes';this.disabled=true;this.form.submit();">
				</th>
			</tr>
			<TR>
				<TH ID="Result" COLSPAN="2">
				</TH>
			</TR>
		</table>
	</CFFORM>

	<SCRIPT LANGUAGE="VBSCRIPT">
		setValue()
	</SCRIPT>

</div>
</CFOUTPUT>
</body>
</html>
