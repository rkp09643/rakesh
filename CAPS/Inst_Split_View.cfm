<!---- **************************************************************
	BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*************************************************************** ---->
<HTML>
<HEAD>
	<TITLE> Client Overview Contents Screen. </TITLE>
	<LINK href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<LINK HREF="../../CSS/DynamicCSS.css" REL="stylesheet" TYPE="text/css">

	<STYLE>
		DIV#TableHeader
		{
			Position		:	Absolute;
			Top				:	0;
			Width			:	100%;
			Background		:	DDFFFF;
		}
		DIV#TableData
		{
			Position		:	Absolute;
			Top				:	10%;
			Width			:	100%;
			Height			:	80%;
			Overflow		:	Auto;
			Background		:	FFEEEE;
		}
	</STYLE>
	
	<SCRIPT>
		function validateClient( form, clientID, clIDObj, optClType )
		{
			with( form )
			{
				if( clientID != "" && clientID.charAt(0) != " " )
				{
					top.fraPaneBar.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&CoName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FormName=TradeModification&DocFormObject=top.document." +name +"&ClientID=" +clientID +"&CurrClientID=" +clientID +"&ClientIDObject=" +clIDObj +"&ClientNameObject=" +clIDObj;
					return true;
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
		function modifySettlement( form, CLIENT_ID, Qty, Rate, CustCode,ROWNO1)
		{
			AddRow.style.display = "None";
			ModifyRow.style.display = "";
			with( form )
			{
				inp_Client.value = CLIENT_ID
				inp_Qty.value = Qty;
				inp_Cust.value = CustCode;
				inp_Rate.value =Rate
				ROWNO.value=ROWNO1
			}			
		}			
		function OpenWindow( form, clid )
		{
			with (form)
			{
				HelpWindow	=	open( "/FOCAPS/HelpSearch/SingleChoice.cfm?COCD="+ COCD.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd.value +"&FormObj=" +name +"&ClObj="+clid+"&Title=Clients Help&helpfor=Client", "HelpWindow", "width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no" );
			}	
		}	
	</SCRIPT>
    <LINK HREF="../../CSS/DynamicCSS.css" REL="stylesheet" TYPE="text/css">
</HEAD>



<BODY id="ScreenContents" leftmargin="0" rightmargin="0"  ONLOAD="AddRow.style.display = ''; ModifyRow.style.display = 'None'; ">

<CFIF NOt isdefined("txtOrderDate")>
	<CFABORT>
</CFIF>
<cfoutput>
<cfif IsDefined("Process") and Process eq 'Yes'>
	<cftransaction>
		<cFSET Price_Premium1 = Price_Premium>
		<cftry>
				<CFSTOREDPROC PROCEDURE="Inst_Split_Trade" datasource="#Client.database#">
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Company_Code" VALUE="#cocd#" NULL="no">
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@trade_date" VALUE="#txtOrderDate#" NULL="No">
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Mkt_type" VALUE="#Mkt_type#" NULL="NO">
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Settlement_no" VALUE="#txtSetlId#" null="no">
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Client_id" VALUE="#txtClientID#">
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Scrip_symbol" VALUE="#txtScrip#">
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@BUY_SALE" VALUE="#BuySale#">
						<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TOKENNO" VALUE="#TOKENNO#" NULL="No">
<cfif IsDefined("RateChang")>
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@RateChang" VALUE="#RateChang#">
<cfelse>
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@RateChang" VALUE="">
</cfif>
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@RateDigit" VALUE="">
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@ContractProcess" VALUE="">
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Price_Premium" VALUE="#val(Price_Premium1)#">
<cfif IsDefined("MktRateChang")>
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@MktRateChang" VALUE="#MktRateChang#">
<cfelse>
						<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@MktRateChang" VALUE="">
</cfif>
						<CFPROCRESULT NAME="query1" resultset="1">
				</CFSTOREDPROC>	
			<cfcatch>
			#cfcatch.Message#<cfabort>
			</cfcatch>		
		</cftry>
	</cftransaction>
</cfif>
</cfoutput>
<CFQUERY NAME="GetClCode" datasource="#Client.database#">
	Select	Clearing_Member_Code,Exchange_Clearing_Code
	From
			System_Settings
	Where
			Company_Code	=	'#COCD#'
</CFQUERY>

<CFSET	ClearingMemberCode	=	GetClCode.Clearing_Member_Code>
<CFPARAM NAME="txtOrderDate" DEFAULT="">
<CFPARAM NAME="invalidClient" DEFAULT="No">
<FORM NAME="ScrOrd" ACTION="Inst_Split_View.cfm" METHOD="POST">
<CFOUTPUT>
	<INPUT type="Hidden" name="COCD" value="#Trim(COCD)#">
	<INPUT type="Hidden" name="COName" value="#COName#">
	<INPUT type="Hidden" name="Market" value="#Market#">
	<INPUT type="Hidden" name="Exchange" value="#Exchange#">
	<INPUT type="Hidden" name="Broker" value="#Broker#">
	<INPUT type="Hidden" name="FinStart" value="#FinStart#">
	<INPUT type="Hidden" name="FinEnd" value="#FinEnd#">
	<INPUT type="Hidden" name="txtOrderDate" value="#txtOrderDate#">	
	<INPUT TYPE="Hidden" NAME="txtContractNo" VALUE="#txtContractNo#">
	<INPUT TYPE="Hidden" NAME="txtClientID" VALUE="#txtClientID#">
	<INPUT TYPE="Hidden" NAME="txtScrip" VALUE="#txtScrip#">	
	<INPUT TYPE="HIDDEN" NAME="txtSetlId" VALUE="#txtSetlId#">
	<INPUT TYPE="HIDDEN" NAME="Mkt_Type" VALUE="#Mkt_Type#">
	<input type="hidden" name="ExchangeClearingCode1" value="">
	<input type="hidden" name="BrokerSebiRegnNo1" value="">
	<input type="hidden" name="ExchangeMapIns1" value="">
	<input type="hidden" name="ClientSebiRegNo1" value="">
	<input type="hidden" name="UniqueClientId1" value="">
	<input type="hidden" name="TokenNo" value="#TokenNo#">
<CFTRY>
	<CFQUERY NAME="GetOrderTrades" datasource="#Client.database#">
		SELECT	
				RTRIM(A.CLIENT_ID) CLIENT_ID, Max(IsNull(SYSTEM_IMPORT_IP,'N'))SYSTEM_IMPORT_IP,
				IsNull(Client_Name,'')Client_Name,
				count(distinct ORDER_NUMBER) NO_ORDER, MIN(USER_ID)USER_ID,
				Convert(VarChar(10), MIN(ORDER_DATETIME), 108)ORDER_TIME, SCRIP_SYMBOL, BUY_SALE, 
				ISNULL(SUM( QUANTITY ), 0) Quantity,
				SUM( QUANTITY * PRICE_PREMIUM ) Amt,
				CASE WHEN BUY_SALE ='BUY' THEN
					SUM( QUANTITY * (PRICE_PREMIUM +TRADE_BROKERAGE + DELIVERY_BROKERAGE)) 
				ELSE
					SUM( QUANTITY * (PRICE_PREMIUM -(TRADE_BROKERAGE + DELIVERY_BROKERAGE))) 
				END AS Net_Amt,
				CASE WHEN BUY_SALE ='BUY' THEN
					cast(SUM( QUANTITY * (PRICE_PREMIUM +TRADE_BROKERAGE + DELIVERY_BROKERAGE)) / SUM(QUANTITY) as NUMERIC(30,4))
				ELSE
					cast(SUM( QUANTITY * (PRICE_PREMIUM -(TRADE_BROKERAGE + DELIVERY_BROKERAGE))) / SUM(QUANTITY) as NUMERIC(30,4))
				END AS Net_Rate,
				cast(SUM( QUANTITY * PRICE_PREMIUM ) / SUM(QUANTITY) as NUMERIC(30,12)) Price_Premium,
				Count(Trade_Number)No_Of_Trades, Max(ISNULL(Bill_No,0))Bill_No,
				CAST(AVG(TRADE_BROKERAGE + DELIVERY_BROKERAGE) AS NUMERIC(10,4)) DELIVERY_BROKRAGE,
				CAST( ISNULL(SUM( QUANTITY ), 0) * (AVG(TRADE_BROKERAGE + DELIVERY_BROKERAGE)) AS NUMERIC(10,4)) Total_Brk
		FROM	
				TRADE1 A LEFT OUTER JOIN Client_Master B
		ON
				A.Client_ID		=	B.Client_ID
		And		A.Company_Code	=	B.Company_Code
		WHERE	    
				A.COMPANY_CODE		=  '#COCD#'
		AND		Convert(DateTime, Trade_Date, 103)	=	Convert(DateTime, '#txtOrderDate#', 103)
		AND		A.Client_ID			!=	'#ClearingMemberCode#'
		AND		IsNull(ORDER_NUMBER,'')		Not Like 'ND%'
		AND		Mkt_Type			In	('N','T')
		AND		Client_Nature		= 'I'
		AND		A.Mkt_Type			= '#Mkt_Type#'
		AND		A.SETTLEMENT_NO		= '#txtSetlId#'	
		AND		A.Client_ID			=	'#txtClientID#'
		AND		Scrip_Symbol		=	'#txtScrip#'
		Group By
			A.CLIENT_ID,SCRIP_SYMBOL,BUY_SALE, Client_Name	
		Order By
			 SCRIP_SYMBOL, BUY_SALE, A.CLIENT_ID
	</CFQUERY>
<CFCATCH type="Any">
	#cfcatch.detail#
	<CFABORT>
</CFCATCH>
</CFTRY>
<CFIF GetOrderTrades.RecordCount eq 0>
	<SCRIPT>
		alert( "No Data found." );
	</SCRIPT>
	<CFABORT>
</CFIF>


</CFOUTPUT>
<DIV align="left" id="TableHeader">

	<TABLE width="100%"  border="1" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1" style="Color : Green;">
		<TR >
			<TH align="CENTER" width="10%" TITLE=""> Client Code&nbsp; </TH>
			<TH align="CENTER" width="10%"> Scrip </TH>
			<TH align="CENTER" width="3%" TITLE="Buy or Sale"> B/S </TH>
			<TH align="CENTER" width="8%" TITLE="Quantity"> Qty </TH>
			<TH align="CENTER" width="9%" TITLE="Average Rate"> Avg Rate </TH>
			<TH align="CENTER" width="9%" TITLE="Average Rate"> Market Amt</TH>
			<TH align="CENTER" width="9%" TITLE="Average Rate"> Net Avg Rate </TH>
			<TH align="CENTER" width="9%" TITLE="Average Rate"> Net Amt</TH>
			<TH align="CENTER" width="4%" TITLE="Total Trade Of The Order"> Trd </TH>
			<TH align="CENTER" width="4%" TITLE="Total Trade Of The Order"> Ord </TH>
		</TR>
		<CFSET Sr				=	0>
		<CFOUTPUT query="GetOrderTrades">
				<CFIF Len(Trim(CLIENT_NAME)) GT 0>
					<CFSET CName = "#CLIENT_ID#-#Left(Client_Name,15)#">
					<CFSET BoldType = "Normal">
				<CFELSE>
					<CFSET CName = "#CLIENT_ID#(** UNREGISTERED **)">
					<CFSET BoldType = "Normal">
				</CFIF>
				<CFSET Sr			=	IncrementValue(Sr)>
				<CFIF SYSTEM_IMPORT_IP eq "Y">
					<CFSET backcolor = "LightGoldenrodYellow">
				<CFELSE>
					<CFSET backcolor = "E6EFBE">
				</CFIF>
					<TR STYLE=" background:#backcolor#; font-weight:#BoldType#; color:#iif(Left(Buy_Sale,1) EQ 'B',DE("Blue"),DE("Red"))#">
						<TD align="right" width="10%"> #Trim(Client_Id)#&nbsp; </TD>
						<TD align="Left" width="10%">&nbsp;#Scrip_Symbol#</TD>
						<TD align="CENTER" width="3%">&nbsp;#Left(Buy_Sale,1)# </TD>
						<TD align="right" width="8%"> #Quantity# </TD>
						<TD align="right" width="9%"> #Price_Premium# </TD>
						<TD align="right" width="9%" > #Amt#</TH>
						<TD align="right" width="9%" > #Net_Rate#</TH>
						<TD align="right" width="9%" > #Net_Amt#</TH>
						<TD align="right" width="4%"> #No_Of_Trades# </TD>
						<TH align="CENTER" width="8%"> #NO_order#</TH>
					</TR>
				<INPUT type="Hidden" name="OldClientID#Sr#" value="#CLIENT_ID#">
				<INPUT type="Hidden" name="Scrip#Sr#" value="#Scrip_Symbol#">
				<INPUT type="Hidden" name="Price_Premium" value="#Price_Premium#">
				<INPUT type="Hidden" name="Price_Premium4" value="#NumberFormat(Price_Premium,'99999999.9999')#">
				<INPUT type="Hidden" name="Price_Premium2" value="#NumberFormat(Price_Premium,'99999999.99')#">
				<INPUT type="Hidden" name="BuySale" value="#Buy_Sale#">
				<INPUT type="Hidden" name="RowID#Sr#" value="#Buy_Sale#">
	</CFOUTPUT>
	</TABLE>
</DIV>


<DIV align="left" style="top:8%;width:50%;height:92%;left:0;position:absolute;overflow:auto;"> 

<DIV align="left" style="top:0%;width:100%;height:10%;left:0;position:absolute;overflow:auto;">
	<TABLE WIDTH="100%" BORDER="1" cellspacing="0" cellpadding="0" class="StyleReportParameterTable1">
		<TR>
			<TH WIDTH="25%">
				&nbsp;Client
			</TH>
			<TH WIDTH="10%">
				&nbsp;Qty
			</TH>
			<TH WIDTH="10%">
				&nbsp;NetRate			
			</TH> 
			<TH WIDTH="20%">
				&nbsp;Cust.
			</TH>
		<TR>
	</table>
</DIV>
<DIV align="left" style="top:6%;width:100%;height:66%;left:0;position:absolute;overflow:auto;">
<cfoutput>
		<cfif IsDefined("Add") AND VAL(INP_QTY) NEQ 0>
				<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
						insert into Inst_Contract_Table  
						(CLIENT_ID, Qty, BrkRate,CustCode, Scrip, Token)
						VALUES
						(
							'#inp_Client#','#INP_QTY#',#VAL(inp_Rate)#,
							'#inp_Cust#','#txtScrip#','#TokenNo#'
						)
				</CFQUERY>
			</cfif>

		<cfif IsDefined("Update") >
				<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
						delete Inst_Contract_Table   where ROWNO ='#ROWNO#'
						insert into Inst_Contract_Table  
						(CLIENT_ID, Qty, BrkRate,CustCode, Scrip, Token)
						VALUES
						(
							'#inp_Client#','#INP_QTY#',#VAL(inp_Rate)#,
							'#inp_Cust#','#txtScrip#','#TokenNo#'
						)
				</CFQUERY>
			</cfif>
			<cfif IsDefined("dELETE") >
				<CFQUERY NAME="INSERT" datasource="#Client.database#" DBTYPE="ODBC">
						delete Inst_Contract_Table   where ROWNO ='#ROWNO#'
				</CFQUERY>
			</cfif>
			<CFQUERY NAME="Q" datasource="#Client.database#" DBTYPE="ODBC">
				select * from Inst_Contract_Table
				where Token ='#TokenNo#'
			</CFQUERY>
	</cfoutput>
	<Cfset TotalQty=0>
	<Cfset TotalAmt=0>
	<cfoutput query="Q">
		<Cfset TotalQty=TotalQty+Qty>
			<TABLE WIDTH="100%" BORDER="1" cellspacing="0" cellpadding="0" class="StyleReportParameterTable1">
				<TR onMouseOver="bgColor = 'Pink';" onMouseOut="bgColor = 'White';" style="cursor:HAND;" onclick="modifySettlement(ScrOrd, '#UCase(Trim(CLIENT_ID))#', '#Trim(Qty)#','#BRKRATE#','#CustCode#','#ROWNO#')")>
					<TD WIDTH="25%">
						#CLIENT_ID#
					</TD>
					<TD WIDTH="10%" align="right">
						#Qty#&nbsp;
					</TD>
					 <TD WIDTH="10%" align="right">
						#BrkRate#&nbsp;
					</TD>
					<TD WIDTH="20%">
						#CustCode#&nbsp;
					</TD>
				<TR>
			</table>
			</cfoutput>
	<cfoutput>
</DIV>
<DIV align="left" style="top:72%;width:100%;height:26%;left:0;position:absolute;overflow:auto;">
<input type="hidden" value="" name="ROWNO">
	<TABLE WIDTH="100%" BORDER="1" cellspacing="0" cellpadding="0" class="StyleReportParameterTable1">
		<TR>
			<Th WIDTH="10%" colspan="6">
				Total Qty :#TotalQty#
			</Th >
		</TR>
		<TR>
			<TH>
				Client :&nbsp;
			</TH>
			<TD align="left">
			<CFSET hELP ="select Client_id ,client_name from inst_Client">
				<input type="text" value="#txtClientID#"  name="inp_Client" size="5" class="StyleTextBox">
				<INPUT TYPE="Button" NAME="cmdFamilyHelp" VALUE=" ? " CLASS="StyleSmallButton1" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=inp_Client&Sql=#Help#&HELP_RETURN_INPUT_TYPE=Radio', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
			</TD>
	</TR>
	<TR>		
			<TH align="left">
				&nbsp;Qty : &nbsp;
			</TH>
			<TH align="left" >
				<input type="text" value="" name="inp_Qty" size="5" class="StyleTextBox">
			</TH>
			<TH align="left" >
				&nbsp;Net Rate : &nbsp;
			</TH> 
			<TH  align="left">
				<input type="text" value="" name="inp_Rate" size="5" class="StyleTextBox">
			</TH>
			<TH>
				&nbsp;Cust : &nbsp;
			</TH>
			<TH align="left" >
				<input type="text" value="" name="inp_Cust" size="5" class="StyleTextBox">
			</TH>
		</TR>
	<TR>		
<tr>
			<script language="vbscript">
					sub inp_Client_OnBlur()											
						Intcode = ScrOrd.inp_Client.value								
						if trim(Intcode) <> "" then
							parent.parent.fraPaneBar.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?UrlEncodedFormat(&cocd=" + cocd + "&coname=" + coname + "&styr=" + styr + "&endyr=" + endyr + "&ClientCode=" + Intcode + "&DocFormObject=parent.Display.Reports.ScrOrd.inp_ClientnAME&GetClientName=&)"
						end if
					end sub 
					sub inp_Client_OnChange()											
						Intcode = ScrOrd.inp_Client.value								
						if trim(Intcode) <> "" then
							parent.parent.fraPaneBar.location.href = "/FOCAPS/DynamicFrame/Fra_Hide.cfm?UrlEncodedFormat(&cocd=" + cocd + "&coname=" + coname + "&styr=" + styr + "&endyr=" + endyr + "&ClientCode=" + Intcode + "&DocFormObject=parent.Display.Reports.ScrOrd.inp_ClientnAME&GetClientName=&)"
						end if
					end sub 
				</script>
			<TD align="left" colspan="4">
				<input type="text" value=""  name="inp_ClientnAME" disabled size="80" class="StyleTextBox">
			</TD>

</tr>
			<TR id="AddRow">
				<TD align="right" colspan="4">
					<INPUT type="Submit" accesskey="A" name="Add" value="Add" class="StyleButton">
				</TD>
			</TR>
			<TR id="ModifyRow">
				<TD align="right" colspan="4">
					<INPUT type="Submit" accesskey="U" name="Update" value="Update" class="StyleButton">
					<INPUT type="Submit" accesskey="D" name="Delete" value="Delete" class="StyleButton">
					<INPUT type="Button" accesskey="C" name="Cancel" value="Cancel" class="StyleButton"  onClick="AddRow.style.display = ''; ModifyRow.style.display = 'None'; ">
				</TD>
			</TR>
		<TR>
	</table>
</DIV>
	</cfoutput>
</DIV>

<DIV align="left" style="top:8%;width:50%;height:92%;left:50%;position:absolute;overflow:auto;">
	<TABLE WIDTH="100%" BORDER="1" cellspacing="0" cellpadding="0" class="StyleReportParameterTable1">
		<cfif GetOrderTrades.Quantity eq TotalQty>
			<TR>
				<Th WIDTH="50%" colspan="3" align="left">
						<input type="checkbox"  value="Yes" name="RateChang">
						Change Market Rate
				</Th>
				<!--- <Th WIDTH="50%" colspan="3" align="left">
						<input type="radio" checked   value="4" name="RateDigit">4 Digit<br>
						<input type="radio"   value="2" name="RateDigit">2 Digit<br>
				</Th> --->
			</tr>
			<TR>
				<Th WIDTH="50%" colspan="3" align="left">
						<input type="checkbox"  value="Yes" name="MktRateChang">
						Change Net Rate 
				</Th>
				<!--- <Th WIDTH="50%" colspan="3" align="left">
						<input type="radio" checked   value="4" name="MktRateDigit">4 Digit<br>
						<input type="radio"   value="2" name="MktRateDigit">2 Digit<br>
				</Th> --->
			</tr>
<!--- 			<TR>	
				<Th WIDTH="50%" colspan="3" align="left">
						<input type="checkbox"  checked value="Yes" name="ContractProcess">
						Asign Contract No
				</Th>
				<Th WIDTH="50%" colspan="3" align="left">
						<input type="radio"   value="C" name="ContractType">Client Wise<br>
						<input type="radio"  checked value="CS" name="ContractType">Client Scrip Wise<br>
						<input type="radio"   value="CCU" name="ContractType">Client Custodial Wise<br>

				</Th>
			</tr> --->
			<TR>
				<Th WIDTH="10%" colspan="6">
						<INPUT TYPE="HIDDEN" NAME="Process" VALUE="">	
						<INPUT TYPE="button" NAME="Process1" VALUE="Process" CLASS="StyleButton" onClick="this.form.Process1.disabled=true;this.disabled=true;this.form.Process.value='Yes';this.form.submit();">
						
				</Th>
			</TR>
		<cfelse>
			
		</cfif>
	</table>
</DIV>

	<CFOUTPUT>
</CFOUTPUT>
</FORM>
</BODY>
</HTML>