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



<BODY id="ScreenContents" leftmargin="0" rightmargin="0">
<CFIF NOt isdefined("txtOrderDate")>
	<CFABORT>
</CFIF>

<CFQUERY NAME="GetClCode" datasource="#Client.database#">
	Select	Clearing_Member_Code,Exchange_Clearing_Code
	From
			System_Settings
	Where
			Company_Code	=	'#COCD#'
</CFQUERY>

<CFSET	ClearingMemberCode	=	GetClCode.Clearing_Member_Code>
<!--- 
<CFIF IsDefined("cmdUpdate")>
	
	<CFLOOP INDEX="i" FROM="1" TO="#Sr#">
	
		<CFSET	OrderNo		=	Trim(Evaluate("OrderNo#i#"))>
		<CFSET	OldClientID	=	Trim(Evaluate("OldClientID#i#"))>
		<CFSET	Scrip		=	Trim(Evaluate("Scrip#i#"))>
		<CFSET	BuySale		=	Trim(Evaluate("BuySale#i#"))>
		<CFSET	ClientID	=	Trim(Evaluate("ClientID#i#"))>

		<CFIF	Trim(ClientID) is Not "" And Trim(ClientID) NEQ Trim(OldClientID)>
			<CFQUERY NAME="UpdateData" datasource="#Client.database#">
				UPDATE	TRADE1
				SET
						<CFIF optClType EQ "ClientID">
							Client_ID	=	'#ClientID#',
							SYSTEM_IMPORT_IP	=	'Y'
						<CFELSE>
							Client_ID2	=	'#ClientID#'
						</CFIF>
				Where
						Company_Code	=	'#COCD#'
				And		Convert(Datetime, Trade_Date, 103)	=	Convert(Datetime, '#txtOrderDate#', 103)
				And		Order_Number	=	'#OrderNo#'
				And		Scrip_Symbol	=	'#Scrip#'
				And		Buy_Sale		=	'#BuySale#'
				And		Client_ID		=	'#OldClientID#'
			</CFQUERY>
		</CFIF>
	</CFLOOP>
</CFIF> --->
<CFPARAM NAME="txtOrderDate" DEFAULT="">
<CFPARAM NAME="invalidClient" DEFAULT="No">
<CFFORM NAME="ScrOrd" ACTION="Stp_file_View.cfm" METHOD="POST">
<CFOUTPUT>
<CFTRY>
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
	<INPUT TYPE="HIDDEN" NAME="OptFormat" VALUE="#OptFormat#">
	<INPUT TYPE="HIDDEN" NAME="BatchNumber" VALUE="#BatchNumber#">
	<input type="hidden" name="OptContractInf" value="#OptContractInf#">
	
	<input type="hidden" name="ExchangeClearingCode1" value="">
	<input type="hidden" name="BrokerSebiRegnNo1" value="">
	<input type="hidden" name="ExchangeMapIns1" value="">
	<input type="hidden" name="ClientSebiRegNo1" value="">
	<input type="hidden" name="UniqueClientId1" value="">

	<Cfset oldBatchNumber = BatchNumber>
	<cfif trim(BatchNumber) eq "">
		<CFQUERY NAME="GetBatchNo" datasource="#Client.database#">
			select  isnull(Stp_File_BatchNo,1) Stp_Batch
			from  system_settings
			where Company_Code = '#COCD#'
		</CFQUERY>
		<cfset BatchNumber = "#GetBatchNo.Stp_Batch#">
	</cfif>

	<CFCATCH>
			<SCRIPT>
				alert( "No Data found." );
			</SCRIPT>
			<CFABORT>
	</CFCATCH>
</CFTRY>
	
	
<CFIF IsDefined("BrkProcess")>
<CFTRY>
	<CFQUERY NAME="GetTransfer_Cocd_CL2" datasource="#Client.database#" DBTYPE="ODBC">
		SELECT	IsNull(Inst_NewProc,'N')Inst_NewProc
		FROM	
				SYSTEM_SETTINGS
		WHERE
				COMPANY_CODE	=	'#COCD#'
	</CFQUERY>
	<CFSET	Inst_NewProc1	=	Trim(GetTransfer_Cocd_CL2.Inst_NewProc)>
	<CFIF Inst_NewProc1 EQ "Y">
		<CFQUERY NAME="CapsProce"  datasource="#Client.database#">
			exec CAPS_INSTITUTE_NEW_BROKERAGE '#cocd#' ,'#Mkt_Type#','#txtSetlId#',''	
		</CFQUERY>

		<CFQUERY NAME="CapsProce"  datasource="#Client.database#">
			exec CAPS_INSTITUTE_NEW_BROKERAGE_FORMAT1 '#cocd#' ,'#Mkt_Type#','#txtSetlId#',''	
		</CFQUERY>
	<CFELSE>
		<CFQUERY NAME="CapsProce"  datasource="#Client.database#">
			exec CAPS_INSTITUTE_NEW_BROKERAGE '#cocd#' ,'#Mkt_Type#','#txtSetlId#',''	
		</CFQUERY>
	</CFIF>
	<CFQUERY NAME="CapssttProce"  datasource="#Client.database#">
		exec CAPS_INSTITUTE_CONTRACT_NUMBER_GENERATION '#cocd#' ,'#Mkt_Type#','#txtSetlId#','#txtOrderDate#',''	
	</CFQUERY>
	<CFCATCH>
		#cfcatch.Detail#<CFABORT>
	</CFCATCH>
	
</CFTRY>
</CFIF>
<CFIF IsDefined("Generate")>

	<CFIF OptFormat EQ "NSECSV" AND BatchNumber NEQ "">
		<CFINCLUDE TEMPLATE="STP_FILE_GENERATION_NSECSV.cfm">		
	<CFELSEIF OptFormat EQ "NSDL" AND BatchNumber NEQ "">
		<CFINCLUDE TEMPLATE="STP_FILE_GENERATION_NSDL.cfm">		
	<CFELSE>	
		<CFINCLUDE TEMPLATE="STP_FILE_GENERATION.cfm">		
	</CFIF>
	<cfset Batchno = BatchNumber + 1>
	<Cfif oldBatchNumber  eq "">
		<CFQUERY NAME="UpdateBatchNo" datasource="#Client.database#">
			update system_settings
			set Stp_File_BatchNo = '#Batchno#'
			where Company_Code = '#COCD#'
		</CFQUERY>
	</Cfif>
	<cfset BatchNumber = "#Batchno#">
</CFIF>
<CFIF IsDefined("ManualProcess")>
	<CFLOOP FROM="1" TO="#sr#" INDEX="Idx">
			<CFIF IsDefined("ChkBrk#Idx#")>
				<CFSET OrderNo = Evaluate("OrderNo#idx#")>
				<CFSET OldClientID = Evaluate("OldClientID#idx#")>
				<CFSET Scrip = Evaluate("Scrip#idx#")>
				<CFSET BuySale = Evaluate("BuySale#idx#")>
				<CFSET GetBrkData = Evaluate("GetBrkData#idx#")>

				<CFQUERY NAME="UpdateData"  datasource="#Client.database#">
					UPDATE TRADE1
					SET 	
						ONESIDEFLAG				=	1, 
						TRADE_BROKERAGE_PER		=	0, 
						TRADE_BROKERAGE			=	'#Val(GetBrkData)#', 
						DELIVERY_BROKERAGE_PER	=	0, 
						DELIVERY_BROKERAGE		=	0, 
						IS_MANUAL_BROKERAGE		=	'Y', 
						RESET_VALUES_TYPE		=	'M'
					WHERE
						CLIENT_ID = '#OldClientID#'
					AND MKT_TYPE = '#Mkt_Type#'
					AND SCRIP_SYMBOL ='#Scrip#'
					AND BUY_SALE ='#BuySale#'
					AND SETTLEMENT_NO = '#txtSetlId#'
					AND ORDER_NUMBER = '#OrderNo#'
					AND COMPANY_CODE = '#COCD#'
				</CFQUERY>
			</CFIF>	
	</CFLOOP>
</CFIF>

<CFIF IsDefined("ResetContract")>
	<CFLOOP FROM="1" TO="#sr#" INDEX="Idx">
			<CFIF IsDefined("ChkBrk#Idx#")>
				<CFSET OrderNo = Evaluate("OrderNo#idx#")>
				<CFSET OldClientID = Evaluate("OldClientID#idx#")>
				<CFSET Scrip = Evaluate("Scrip#idx#")>
				<CFSET BuySale = Evaluate("BuySale#idx#")>
				<CFSET GetBrkData = Evaluate("GetBrkData#idx#")>

				<CFQUERY NAME="UpdateData"  datasource="#Client.database#">
					UPDATE TRADE1
					SET 	
						Contract_No		=	0
					WHERE
						CLIENT_ID = '#OldClientID#'
					AND MKT_TYPE = '#Mkt_Type#'
					AND SCRIP_SYMBOL ='#Scrip#'
					AND BUY_SALE ='#BuySale#'
					AND SETTLEMENT_NO = '#txtSetlId#'
					AND ORDER_NUMBER = '#OrderNo#'
					AND COMPANY_CODE = '#COCD#'
				</CFQUERY>
				
			</CFIF>
	</CFLOOP>
</CFIF>

<CFIF IsDefined("UpdateContract")>
	<CFLOOP FROM="1" TO="#sr#" INDEX="Idx">
			<CFIF IsDefined("ChkBrk#Idx#")>
				<CFSET OrderNo = Evaluate("OrderNo#idx#")>
				<CFSET OldClientID = Evaluate("OldClientID#idx#")>
				<CFSET Scrip = Evaluate("Scrip#idx#")>
				<CFSET BuySale = Evaluate("BuySale#idx#")>
				<CFSET GetBrkData = Evaluate("GetBrkData#idx#")>
				<CFQUERY NAME="UpdateData"  datasource="#Client.database#">
					UPDATE TRADE1
					SET 	
						Contract_No		=	#cmbNewContractNo#
					WHERE
						CLIENT_ID = '#OldClientID#'
					AND MKT_TYPE = '#Mkt_Type#'
					AND SCRIP_SYMBOL ='#Scrip#'
					AND BUY_SALE ='#BuySale#'
					AND SETTLEMENT_NO = '#txtSetlId#'
					AND ORDER_NUMBER = '#OrderNo#'
					AND COMPANY_CODE = '#COCD#'
				</CFQUERY>
				
			</CFIF>
	</CFLOOP>
</CFIF>

<CFTRY>
	<CFQUERY NAME="GetOrderTrades" datasource="#Client.database#">
		SELECT	
				RTRIM(A.CLIENT_ID) CLIENT_ID, Max(IsNull(SYSTEM_IMPORT_IP,'N'))SYSTEM_IMPORT_IP,
				IsNull(Client_Name,'')Client_Name,
				ORDER_NUMBER, MIN(USER_ID)USER_ID,
				Convert(VarChar(10), MIN(ORDER_DATETIME), 108)ORDER_TIME, SCRIP_SYMBOL, BUY_SALE, 
				ISNULL(SUM( QUANTITY ), 0) Quantity,
				cast(SUM( QUANTITY * PRICE_PREMIUM ) / SUM(QUANTITY) as NUMERIC(30,4)) Price_Premium,
				Count(Trade_Number)No_Of_Trades, Max(ISNULL(Bill_No,0))Bill_No,
				CAST(AVG(TRADE_BROKERAGE + DELIVERY_BROKERAGE) AS NUMERIC(10,4)) DELIVERY_BROKRAGE,
				case when IS_MANUAL_BROKERAGE = 'N' then 'S' else 'M' END AS IS_MANUAL_BROKERAGE,
				Contract_No,
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
		<CFIF IsDefined("txtClientID") And Trim(txtClientID) is not "">
			<CFIF txtClientID neq 'ALL'>
				AND		A.Client_ID			=	'#txtClientID#'
			</CFIF>
		</CFIF>
		<CFIF IsDefined("txtScrip") And Trim(txtScrip) is not "">
			<CFIF txtScrip neq 'ALL'>
				AND		Scrip_Symbol		Like	'#txtScrip#%'
			</CFIF>
		</CFIF>
		<CFIF IsDefined("txtContractNo") And Trim(txtContractNo) is not "" And Trim(txtContractNo) neq "None">
			<CFIF txtContractNo neq 'ALL'>
				AND		IsNull(Contract_No,'')		= '#Trim(txtContractNo)#'
			</CFIF>
		</CFIF>

		Group By
			A.CLIENT_ID, ORDER_NUMBER, SCRIP_SYMBOL, BUY_SALE, Client_Name,IS_MANUAL_BROKERAGE,Contract_No			
		Order By
			User_ID, SCRIP_SYMBOL,ORDER_NUMBER, BUY_SALE, A.CLIENT_ID
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

<CFQUERY NAME="GetContracts" datasource="#Client.database#">
	SELECT	Distinct Contract_No
	FROM
			Trade1
	WHERE	    
			COMPANY_CODE		=  '#COCD#'
	AND		Convert(DateTime, Trade_Date, 103)	=	Convert(DateTime, '#txtOrderDate#', 103)
	AND		Client_ID			!=	'#ClearingMemberCode#'
	AND		IsNull(ORDER_NUMBER,'')		Not Like 'ND%'
	AND		Mkt_Type			In	('N','T')
	AND		Mkt_Type			= 	'#Mkt_Type#'
	AND		SETTLEMENT_NO		= 	'#txtSetlId#'	
	AND		Client_ID			=	'#txtClientID#'
	AND		Scrip_Symbol		Like	'#txtScrip#%'
	AND		Contract_No			<>	0
</CFQUERY>
</CFOUTPUT>
<CFIF OptFormat EQ 'P' AND txtClientID EQ 'ALL'>
	<Cfset DataProcess = true>
<cfelse>
	<Cfset DataProcess = FALSE>
</CFIF>

<DIV align="center" id="TableHeader">
	
	<TABLE width="100%"  border="1" cellspacing="0" cellpadding="0" align="center" class="StyleReportParameterTable1" style="Color : Green;">
		<CFIF DataProcess>
		<TR>
				<TH align="CENTER" width="*" COLSPAN="9">&nbsp;</TH>
				<TH align="CENTER" width="13%" COLSPAN="3">&nbsp;Brokerage</TH>
				<TH ALIGN="CENTER" WIDTH="*">&nbsp;
				</TH>
			</TR>
		<CFELSE>
		<TR>
				<TH ALIGN="CENTER" WIDTH="*" COLSPAN="20">&nbsp;
				</TH>
		</TR>
		</CFIF>
		<TR >
			<CFIF DataProcess>
			<TH align="CENTER" width="4%" TITLE="Serial No"> No&nbsp; </TH>
			<TH align="CENTER" width="10%" TITLE=""> Client Code&nbsp; </TH>
			<TH align="CENTER" width="10%" TITLE="Order No Form Trade"> Order No&nbsp; </TH>
			<TH align="CENTER" width="8%" TITLE="Fisrt Order Time For Order"> OrdTime&nbsp; </TH>
			<TH align="CENTER" width="10%"> Scrip </TH>
			<TH align="CENTER" width="3%" TITLE="Buy or Sale"> B/S </TH>
			<TH align="CENTER" width="8%" TITLE="Quantity"> Qty </TH>
			<TH align="CENTER" width="9%" TITLE="Average Rate"> AvgRate </TH>
			<TH align="CENTER" width="4%" TITLE="Total Trade Of The Order"> Trd </TH>
			<TH align="RIGHT" width="10%" TITLE="Contract No">Cont.No</TH>
			<TH align="CENTER" width="8%" TITLE="Insert Brokerage Type">(M/S)</TH>
			<TH align="CENTER" width="10%">Unit Brk</TH>
			<!---<TH align="CENTER" width="10%">Total Brk</TH>----->
			<TH align="CENTER" width="10%">Update</TH>
			<TH ALIGN="CENTER" WIDTH="*">&nbsp;</TH>
			<CFELSEIF DataProcess eq false>
				<TH ALIGN="RIGHT" WIDTH="*">
					<INPUT TYPE="Submit" NAME="Print1" VALUE="Report" CLASS="StyleTextBox">
					<INPUT TYPE="Submit" NAME="Print" VALUE="Print" CLASS="StyleTextBox">
					<INPUT TYPE="Submit" NAME="Generate" VALUE="Generate" CLASS="StyleTextBox">
				</TH>				
			<CFELSE>
				<TH ALIGN="CENTER" WIDTH="*">&nbsp;
				</TH>
			</CFIF>
		</TR>
	</TABLE>
</DIV>
	
<DIV align="center" id="TableData">

	<CFSET Sr				=	0>
	<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="center" class="StyleReportParameterTable1">
	<CFIF DataProcess>

	<CFOUTPUT query="GetOrderTrades" GROUP="ORDER_NUMBER">
		<CFOUTPUT>
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
						<TD align="right" width="4%"> #Sr#&nbsp; </TD>
						<TD align="right" width="10%"> #Trim(Client_Id)#&nbsp; </TD>
						<TD align="right" width="10%"> #Trim(ORDER_NUMBER)#&nbsp; </TD>
						<TD align="right" width="8%"> #ORDER_TIME#&nbsp; </TD>
						<TD align="Left" width="10%">&nbsp;#Scrip_Symbol#</TD>
						<TD align="CENTER" width="3%">&nbsp;#Left(Buy_Sale,1)# </TD>
						<TD align="right" width="8%"> #Quantity# </TD>
						<TD align="right" width="9%"> #NumberFormat(Price_Premium,"99999999.9999")# </TD>
						<TD align="right" width="4%"> #No_Of_Trades# </TD>
						<TD align="RIGHT" width="10%"> #Contract_No#</TD>
						<TH align="CENTER" width="8%"> #is_Manual_brokerage#</TH>
						<TH align="CENTER" width="10%">
							<INPUT TYPE="TEXT" VALUE="#DELIVERY_BROKRAGE#" NAME="GetBrkData#sr#" CLASS="StylePlainTextBox" STYLE="width:100%;text-align:right" >
						</TH>
						<!---<TH align="CENTER" width="8%"> #Total_Brk#</TH>--->
						<TH align="CENTER" width="10%">
							<INPUT TYPE="CHECKBOX" VALUE="" NAME="ChkBrk#sr#" CLASS="StyleLabel1">
						</TH>
						<TD ALIGN="CENTER" WIDTH="*">&nbsp;					
						</TD>
					</TR>
				<INPUT type="Hidden" name="OrderNo#Sr#" value="#ORDER_NUMBER#">
				<INPUT type="Hidden" name="OldClientID#Sr#" value="#CLIENT_ID#">
				<INPUT type="Hidden" name="Scrip#Sr#" value="#Scrip_Symbol#">
				<INPUT type="Hidden" name="BuySale#Sr#" value="#Buy_Sale#">
				<INPUT type="Hidden" name="RowID#Sr#" value="#Buy_Sale#">
	</CFOUTPUT>
	</CFOUTPUT>
	</TABLE>
<CFELSE>
	<CFOUTPUT>

	<CFDIRECTORY ACTION="LIST" DIRECTORY="C:\stpFiles" NAME="Getdir" FILTER="#MKT_TYPE#_#txtSetlId#_#txtClientID#_#txtContractNo#.txt">
		<CFIF Getdir.recordcount neq 0>
			<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="center" class="StyleReportParameterTable1">
				<TD ALIGN="left" WIDTH="*">&nbsp;					
					File Has Been Genereted On C:\STPFILES.Date : #DateFormat(Getdir.DATELASTMODIFIED,'DD/MM/YYYY')#,Time:#TimeFormat(Getdir.DATELASTMODIFIED,'HH:MM:SS')#&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<B> Batch No : #BatchNumber#</B>
				</TD>
			</TABLE>
		</CFIF>
	</CFOUTPUT>

	</CFIF>

<CFOUTPUT>
	<INPUT type="Hidden" name="Sr" value="#Sr#">
</CFOUTPUT>
	<cfIF DataProcess eq false>
<CFIF IsDefined("Print")>
 	<CFDOCUMENT format="PDF"    pagetype="A4"    marginleft = "0.5"   marginright = "0.5" orientation = "landscape">
		 <CFDOCUMENTITEM type="footer">
					<cfoutput>
						<TABLE width="800" border="0" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1">
							 <TR>
								<TD CLASS="StyleTable"  WIDTH="600" STYLE="border-top-width:thin;border-top-style:solid;"><FONT SIZE="-1">Print Date:#DateFormat(now(),'DDD,MMMM YY')#,&nbsp;&nbsp;&nbsp;#TimeFormat(now(),'HH:MM:SS tt')#</FONT> </TD>
								<TD CLASS="StyleTable" WIDTH="200" ALIGN="RIGHT" STYLE="border-top-width:thin;border-top-style:solid;"><FONT SIZE="-1"> Tech Excel[Page :#cfdocument.currentpagenumber#/#cfdocument.totalpagecount#]</FONT></TD>
							</TR>
						</TABLE>
					</cfoutput>
			</CFDOCUMENTITEM> 
			 <CFDOCUMENTITEM type="Header">
					<cfoutput>
						<TABLE width="800" border="0" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1">
							 <TR >
								<TD CLASS="StyleTable"  WIDTH="600" ALIGN="CENTER" ><FONT SIZE="-1">#coname#(#Exchange#)</FONT> </TD>
							</TR>
						</TABLE>
					</cfoutput>
			</CFDOCUMENTITEM> 

			 <CFDOCUMENTSECTION >
					<TABLE width="800" border="1" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1">
							<CFOUTPUT>
									<CFDIRECTORY ACTION="LIST" DIRECTORY="C:\stpFiles" NAME="Getdir" FILTER="#MKT_TYPE#_#txtSetlId#_#txtClientID#_#txtContractNo#.txt">
							
							<tr>
									<td  colspan="3" >  
										STP Report						
									</td>
									<td  colspan="3">  
										Software User ID:&nbsp;#Client.UserName#					
									</td>
							</tr>
									<CFIF Getdir.recordcount neq 0>
									<tr>
										<TD COLSPAN="6" ALIGN="left" WIDTH="*">			
											File Has Been Genereted On C:\STPFILES.Date : #DateFormat(Getdir.DATELASTMODIFIED,'DD/MM/YYYY')#,Time:#TimeFormat(Getdir.DATELASTMODIFIED,'HH:MM:SS')#
										</TD>
									</tr>
									</CFIF>
							</CFOUTPUT>
							<CFINCLUDE TEMPLATE="STP_FILE_Query.cfm">					
					</TABLE>	
			 </CFDOCUMENTSECTION>		
 	</CFDOCUMENT>
</CFIF>
<CFIF IsDefined("Print1")>
 	<CFDOCUMENT format="PDF"    pagetype="A4"    marginleft = "1"   marginright = "1" >
			 <CFDOCUMENTSECTION >
							<CFINCLUDE TEMPLATE="STP_FILE_PDF.cfm">					
			 </CFDOCUMENTSECTION>		
 	</CFDOCUMENT>
</CFIF>
		<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="center" class="StyleReportParameterTable1">
			<CFINCLUDE TEMPLATE="STP_FILE_Query.cfm">					
		</TABLE>	
</cfIF>


</DIV>
	<CFOUTPUT>
			
			<CFIF DataProcess>
					<DIV align="center" STYLE="position:absolute;top:90%;height:10%;width:100%">
						<TABLE WIDTH="100%" BORDER="1">
							<TR>
								<TD WIDTH="30%">
									<INPUT TYPE="SUBMIT" NAME="ManualProcess" VALUE="Update" CLASS="StyleButton">
								&nbsp;
									<CFIF txtClientID eq 'ALL' and txtScrip eq 'ALL' and  txtContractNo eq 'ALL'>
										<INPUT TYPE="SUBMIT" NAME="BrkProcess" VALUE="Brokerage Process" CLASS="StyleButton">
									</CFIF>
									<CFIF txtClientID neq 'ALL' and txtScrip neq 'ALL' and  txtContractNo eq 'ALL'>
										<INPUT TYPE="SUBMIT" NAME="ResetContract" VALUE="Reset Contract" CLASS="StyleButton">
									</CFIF>	
										&nbsp;		
								</TD>
								<CFIF GetContracts.RecordCount GT 0>
									<TD>
										Contract No&nbsp;:
										<SELECT NAME="cmbNewContractNo" CLASS="StyleListBox">
											<CFLOOP QUERY="GetContracts">
												<OPTION VALUE="#Contract_No#">#Contract_No#</OPTION>
											</CFLOOP>
										</SELECT>&nbsp;
										<INPUT TYPE="SUBMIT" NAME="UpdateContract" VALUE="Change Contract" CLASS="StyleButton">
									</TD>
								</CFIF>	
							</TR>
						</TABLE>
					</DIV>
				</CFIF>
</CFOUTPUT>
</CFFORM>
</BODY>
</HTML>