<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->

 <CFSAVECONTENT VARIABLE="BillForm">
<html>
<head>
	<title> Process Screen. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">
</head>

<body leftmargin="0%" topmargin="0%">

<CFOUTPUT>


<CFPARAM name="p1" type="numeric" default="0">
<CFPARAM name="p2" type="numeric" default="0">
<CFPARAM name="p3" type="numeric" default="0">
<CFPARAM name="p4" type="numeric" default="0">
<CFPARAM name="p5" type="numeric" default="0">
<CFPARAM name="p6" type="numeric" default="0">
<CFPARAM name="p7" type="numeric" default="0">
<CFPARAM name="p9" type="numeric" default="0">
<CFPARAM name="p8" type="numeric" default="0">
<CFPARAM name="p9" type="numeric" default="0">
<CFPARAM name="p10" type="numeric" default="0">
<CFPARAM name="p11" type="numeric" default="0">
<CFPARAM name="p12" type="numeric" default="0">
<CFPARAM name="p15" type="numeric" default="0">
	<CFQUERY NAME="GetPartialBill" datasource="#Client.database#" dbtype="ODBC">
		SELECT	IsNull(FLG_PARTIALBILLCANCEL,'N')FLG_PARTIALBILLCANCEL
		FROM
				SETTLEMENT_MASTER
		WHERE
				COMPANY_CODE	=	'#Trim(COCD)#'
			And	MKT_TYPE		=	'#Trim(Mkt_Type)#'
			And	SETTLEMENT_NO	=	#Val(Trim(Settlement_No))#
	</CFQUERY>
	
	<CFSET	PartialBill =	GetPartialBill.FLG_PARTIALBILLCANCEL>

	<CFQUERY name="IsBilled" datasource="#Client.database#" dbtype="ODBC">
		Select	Count( a.BILL_NO ) BillCnt
		From	TRADE1 a --( INDEX = IDX_CAPSBILL_TRADE1 )
		Where
					a.COMPANY_CODE			=	'#Trim(COCD)#'
				And	a.MKT_TYPE				=	'#Trim(Mkt_Type)#'
				And	a.BILL_SETTLEMENT_NO	=	#Val(Trim(Settlement_No))#
				<CFIF IsDefined("Client_ID") AND ( Len(Trim(Client_ID)) GT 0 ) AND ( Trim(Client_ID) NEQ "ALL" )>
					And a.Client_ID			=	'#Trim(Client_ID)#'
				</CFIF>
				And	a.BILL_NO				<>	0
	</CFQUERY>
	

	
	
	<div align="Center" id="LayerParameters">
		<table align="Center" width="100%" border="0" cellpadding="0" cellspacing="0" class="StyleTable1">
			<tr>
				<th align="center" colspan="2">
					<CFIF IsBilled.BillCnt EQ 0>
						<font color="Green">
							<u>Processing for the following parameters</u>:
						</font>
						
	<!--- 					<div align="right">
							<CFFORM name="TimeElapsedForm" action="ProcessParameters.cfm" method="POST">
								<font color="Black" size="1">
									<u>Process Time</u>:
								</font>
								<input type="Text" name="ProcessTime" size="10" ReadOnly style="Border : 1pt Solid; Font : Normal 8pt Arial; Color : 0A246A; Height : 11pt;">
							</CFFORM>
						</div> --->
					<CFELSE>
						<cfif PartialBill EQ "N">
							<font color="Red">
								<br>Bill is already Generated for the following parameters, 
								<br><font style="Color : Blue;"> please Cancel the Bill before you Re-generate it . </font>
								<br>&nbsp;&nbsp;
							</font>
						</cfif>
					</CFIF>
				</th>
			</tr>
			
			<tr>
				<th align="right"> Company : </th>
				<td align="left"> &nbsp;&nbsp;#UCase(Trim(COCD))#-#UCase(Trim(CoName))# </td>
			<th align="right"> Settlement-No : </th>
				<td align="left"> &nbsp;&nbsp;#UCase(Trim(Mkt_Type))#&nbsp;&nbsp;#Val(Trim(Settlement_No))# </td>
				
			</td>
			</tr>
			
			<tr>
				<th align="right"> UserID : </th>
				<td align="left"> &nbsp;&nbsp;#UCase(Trim(Client.UserName))# - #CGI.REMOTE_ADDR#
				<th align="right"> Date : </th>
				<td align="left"> &nbsp;&nbsp;#Trim(Trade_Date)# </td>
			</tr>
			 
			<cfif PartialBill EQ "N">
				<CFIF IsBilled.BillCnt GT 0>
					<tr>
						<td align="Center" colspan="2">
							<br><font style="Color : Blue;"> To Generate another Bill click the link below. </font>
							<br><font style="Cursor : Hand;" 
									onMouseOver="style.color = 'FF0099';" 
									onMouseOut="style.color = 'Navy';" 
									onClick="JavaScript : history.back();"> <b>Back</b> </font>
						</td>
					</tr>
					<CFABORT>
				</CFIF>
			</cfif>
		</table>
	</div>

<div align="Center" id="LayerProcessList">
	<table align="center" width="96%" border="0" cellpadding="0" cellspacing="0" class="StyleTable">
		<CFFORM name="TimeElapsedForm#Mkt_Type#" action="ProcessParameters.cfm" method="POST">
			<tr>
				<th align="left">
					&nbsp;
					<!--- <font color="Fuchsia">
						<u>Process List</u>:
					</font> --->
				</th>
				<th align="right" height="18">
					<font color="Black" size="1">
						<u>Process Time</u>:
					</font>
					<input type="Text" name="ProcessTime" size="10" ReadOnly style="Border : 1pt Solid; Font : Normal 8pt Arial; Color : 0A246A; Height : 11pt;">
				</th>
			</tr>
		</CFFORM>
		
		<CFIF ( p1 EQ 0 ) AND ( p2 EQ 0 ) AND ( p3 EQ 0 ) AND ( p4 EQ 0 ) AND ( p5 EQ 0 ) AND ( p6 EQ 0 ) AND ( p7 EQ 0 ) AND ( p9 EQ 0 ) AND ( p8 EQ 0 ) AND ( p10 EQ 0 )>
			<tr>
				<th align="left" colspan="2">
					<font color="Red"> No Process is selected. </font>
				</th>
			</tr>
		</CFIF>
		<!--- <CFIF p1 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Position Shifting
				</th>
			</tr>
		</CFIF>
		<CFIF p10 EQ 1>
			<tr>
				<th align="left" colspan="2">
					STT Generation
				</th>
			</tr>
		</CFIF>
		<CFIF p2 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Trade Brokerage / Service Charge Calculation
				</th>
			</tr>
		</CFIF>
		<CFIF p3 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Stamp Duty/Turnover Tax Calculation
				</th>
			</tr>
		</CFIF>
		<CFIF p4 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Other Expenses Calculation
				</th>
			</tr>
		</CFIF>
		<CFIF p11 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Pre No-Delivery Marking
				</th>
			</tr>
		</CFIF>
		<CFIF p5 EQ 1>
			<tr>
				<th align="left" colspan="2">
					No-Delivery Marking
				</th>
			</tr>
		</CFIF>
		<CFIF p6 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Delivery Brokerage Marking / Calculation
				</th>
			</tr>
		</CFIF>
		<CFIF p7 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Remeshiree Brokerage Calculation
				</th>
			</tr>
		</CFIF>
		<CFIF p9 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Contract Geneartion
				</th>
			</tr>
		</CFIF>
		<CFIF p8 EQ 1>
			<tr>
				<th align="left" colspan="2">
					Billing
				</th>
			</tr>
		</CFIF> --->
	</table>
</div>


<CFIF ( p1 EQ 1 ) OR ( p2 EQ 1 ) OR ( p3 EQ 1 ) OR ( p4 EQ 1 ) OR ( p5 EQ 1 ) OR ( p6 EQ 1 ) OR ( p7 EQ 1 ) OR ( p9 EQ 1 ) OR ( p8 EQ 1 ) OR ( p10 EQ 1 ) OR ( p15 EQ 1 )>

<!--- 	<CFIF Trim(Client_ID) EQ "ALL">
		<CFSET Client_ID	=	"">
	</CFIF> --->
	
	<CFSET StartTime		=	Now()>
	<CFSET Client_ID		=	"">
	<CFSET Scrip_Symbol		=	"">
	<div align="Center" id="LayerResults1">
		<!---- **********************************************************************************
				CALL THE CUSTOM-TAG "TradeProcesses.cfm" TO PROCESS BROKERAGE, BILL, ETC.
		*********************************************************************************** ---->
		<CFMODULE	Template		=	"/FOCAPS/ProcessData/CAPS/TradeProcesses.cfm" 
					COCD			=	"#Trim(COCD)#" 
					CoName			=	"#Trim(CoName)#" 
					Exchange		=	"#Trim(Exchange)#" 
					Market			=	"#Trim(Market)#" 
					Broker			=	"#Trim(Broker)#" 
					Mkt_Type		=	"#Trim(Mkt_Type)#" 
					Settlement_No	=	"#Val(Trim(Settlement_No))#" 
					Trade_Date		=	"#Trim(Trade_Date)#" 
					Client_ID		=	"#UCase(Trim(Client_ID))#" 
					Scrip_Symbol	=	"#UCase(Trim(Scrip_Symbol))#" 
					p1				=	"#val(p1)#" 
					p2				=	"#val(p2)#" 
					p3				=	"#val(p3)#" 
					p4				=	"#val(p4)#" 
					p5				=	"#val(p5)#" 
					p6				=	"#val(p6)#" 
					p7				=	"#val(p7)#" 
					p9				=	"#val(p9)#" 
					p8				=	"#val(p8)#" 
					p10				=	"#val(p10)#" 
					p12				=	"#val(p12)#" 
					p11				=	"#val(p11)#" 
					p15				=	"#val(p15)#" 
		>
		
		<CFSET EndTime				=	Now()>
		
		<CFMODULE	Template		=	"/FOCAPS/Common/TimeElements.cfm" 
					StartDateTime	=	#StartTime#
					EndDateTime		=	#EndTime#
		>
		
		<script>
			document.TimeElapsedForm#Mkt_Type#.ProcessTime.value	=	"#TimeInMins# min. #TimeInSecs# sec.";
		</script>
	<!--- </div> --->


<!--- 	<CFIF ( p1 EQ 1 ) OR ( p2 EQ 1 ) OR ( p3 EQ 1 ) OR ( p4 EQ 1 ) OR ( p5 EQ 1 ) OR ( p6 EQ 0 ) OR ( p7 EQ 0 ) AND ( p9 EQ 0 ) OR ( p8 EQ 0 )> --->
		<!--- <div align="Center" ID="LayerAlerts"> --->
			<CFSTOREDPROC procedure="CAPS_PROCESS_ALERTS" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#Trim(COCD)#" maxlength="8" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@MKT_TYPE" value="#Trim(Mkt_Type)#" maxlength="2" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_NUMERIC" dbvarname="@BILL_SETTLEMENT_NO" value="#Val(Trim(Settlement_No))#" maxlength="7" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TRADE_DATE" value="#Trade_Date#" maxlength="10" null="No">
				<cfprocparam type="in" cfsqltype="cf_sql_varchar" dbvarname="@Market" value="#Market#" null="no" maxlength="15">
				
				<CFPROCRESULT name="WithoutBrokerageModule" resultset="1">
				<CFPROCRESULT name="ZeroTBrokerageList" resultset="2">
				<CFPROCRESULT name="ClientsMarkedInDelyList" resultset="3">
				<CFPROCRESULT name="ZeroDBrokerageList" resultset="4">
				<CFPROCRESULT name="ZeroJBrokerageList" resultset="5">
				<CFPROCRESULT name="BrokerageListForSEBI" resultset="6">
				<CFPROCRESULT name="JobberWithDelivery" resultset="7">
				<CFPROCRESULT name="BlankISIN" resultset="8">
				<cfprocresult name="MISSISNGBoId" resultset="9">
				<CFPROCRESULT NAME="MissingPanNO" RESULTSET="10">
				<CFPROCRESULT NAME="ManualBrokerage" RESULTSET="11">
				<CFPROCRESULT NAME="DebitMoreThanLack" RESULTSET="12">	
				<CFPROCRESULT NAME="MISSINGBRANCHWITHOUTTERMINAL" RESULTSET="13">	
				<CFPROCRESULT NAME="TransactionFromWrongTerminal" RESULTSET="14">
				<cfprocresult name="ChangeOfCliend" resultset="15">	
				<CFPROCRESULT NAME="ExpiryOfTerminal" RESULTSET="16">
				<CFPROCRESULT NAME="FamilyInternalTrade" RESULTSET="17">
				<CFPROCRESULT NAME="CustodianTrans" RESULTSET="18">
				<CFPROCRESULT NAME="InstitureTrans" RESULTSET="19">
				<CFPROCRESULT NAME="ProTrans" RESULTSET="20">
				<CFPROCRESULT NAME="ClientRist" RESULTSET="21">
				<CFPROCRESULT NAME="INSTMISMATCH" RESULTSET="22">
				<CFPROCRESULT NAME="TOCNotCharged" RESULTSET="23">
				<CFPROCRESULT NAME="STDNotCharged" RESULTSET="24">
				<CFPROCRESULT NAME="STTNotCharged" RESULTSET="25">
				<CFPROCRESULT NAME="STNotCharged" RESULTSET="26">
				<CFPROCRESULT NAME="DefaultSlab" RESULTSET="27">
				<CFPROCRESULT NAME="InActiveClientList" RESULTSET="28">
				<CFPROCRESULT NAME="TradeLossCLientList" RESULTSET="29">
				<CFPROCRESULT NAME="DeliveryBuyCLientList" RESULTSET="30">
				<CFPROCRESULT NAME="DeliverySaleCLientList" RESULTSET="31">
				<CFPROCRESULT NAME="ILEGALLIST" RESULTSET="32">
				<CFPROCRESULT NAME="BlckPanClntDet" RESULTSET="33">
				<CFPROCRESULT NAME="FRESHTRADEDCLIENT" RESULTSET="34">
				<CFPROCRESULT NAME="C_DB_TO" RESULTSET="35">
				<CFPROCRESULT NAME="C_DS_TO" RESULTSET="36">
				<CFPROCRESULT NAME="C_G_TO" RESULTSET="37">
				<CFPROCRESULT NAME="C_T_TO" RESULTSET="38">
				<CFPROCRESULT NAME="C_T_TO1" RESULTSET="39">
				<CFPROCRESULT NAME="C_T_TO2" RESULTSET="40">
				<CFPROCRESULT NAME="Phaysical" RESULTSET="41">
				<CFPROCRESULT NAME="NRI" RESULTSET="42">
				<CFPROCRESULT NAME="MIBT" RESULTSET="43">
			</CFSTOREDPROC>
			
			<table align="center" width="96%" border="1" cellpadding="0" cellspacing="0" class="StyleTable2">
				<tr><td>&nbsp;  </td></tr>
				
				<tr style="Color : Red;">
					<th align="left" colspan="5"> <u>Alerts!!!</u> </th>
				</tr>

					<tr style="Color : Black;">
						<th align="left" colspan="5"> 1] &nbsp; <u>Client Whoes Pan Detail Are Blocked</u> ( #BlckPanClntDet.RecordCount# ) </th>
					</tr>
					<CFIF BlckPanClntDet.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%"> Client Name</th>
							<th align="left" width="6%"> Pan No </th>
							<th align="left" width="6%"> Scrip </th>						
						</tr>
						<cfloop query="BlckPanClntDet">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" width="8%"> #Client_name# </td>
								<td align="left" width="6%"> #PANNO# </td>
								<tD align="left" width="6%"> #Scrip# </tD>							
							</tr>	
						</cfloop>
					</cfif>																

				<CFIF Trim( Broker ) EQ "MB">
					<CFQUERY name="ClearingMemberAlert" datasource="#Client.database#" dbtype="ODBC">
						SELECT	IsNull( SUM( QUANTITY * ( TRADE_BROKERAGE + DELIVERY_BROKERAGE ) ), 0 ) BROKERAGE
						FROM	TRADE1 ( INDEX = IDX_CAPSBILL_TRADE1 )
						WHERE
									COMPANY_CODE		=	'#Trim(COCD)#'
								And	MKT_TYPE			=	'#Trim(Mkt_Type)#'
								And	BILL_SETTLEMENT_NO	=	#Val(Trim(Settlement_No))#
								And	CLIENT_ID			=	(
																SELECT	RTrim( CLEARING_MEMBER_CODE )
																FROM	SYSTEM_SETTINGS
																WHERE	COMPANY_CODE	=	'#Trim(COCD)#'
															)
					</CFQUERY>
					
					<CFIF ClearingMemberAlert.BROKERAGE NEQ 0>
						<tr style="Color : Red;">
							<th align="left" colspan="5"> BROKERAGE GENERATED FOR CLEARING MEMBER ( #Numberformat(ClearingMemberAlert.BROKERAGE, "9999999.9999")# ) </th>
						</tr>
						<tr style="Color : Red;">
							<th align="left" colspan="5"> CHECK FOR BROKERAGE MODULE ASSIGNED TO CLEARING MEMBER </th>
						</tr>
					</CFIF>
				</CFIF>
				
				<tr style="Color : Black;">
					<th align="left" colspan="5"> A] &nbsp; <u>Clients Without Brokerage-Module</u> ( #WithoutBrokerageModule.RecordCount# ) </th>
				</tr>
				
				<CFIF WithoutBrokerageModule.RecordCount GT 0>
					<CFSET SlNo = 0>
					<tr style="background-color: F0F8FF;">
						<!--- <th width="12%" align="LEFT"> Sr.&nbsp; </th> --->
						<th width="27%" align="Left"> &nbsp;Client-ID </th>
						<th width="60%" align="Left"> Client-Name </th>
						<th width="15%" align="Left"> &nbsp;</th>
						<th width="15%" align="Left"> &nbsp;</th>
					</tr>
					
					<CFLOOP query="WithoutBrokerageModule">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo#&nbsp; </td> --->
							<td align="Left"> &nbsp;#Trim(CLIENTID)#	</td>
							<td align="Left"> #Trim(LEFT(CLIENTNAME,12))# </td>
							<TD ALIGN="LEFT"> &nbsp; </TD>
							<TD ALIGN="LEFT"> &nbsp; </TD>
						</tr>
					</CFLOOP>
				</CFIF>
				
				<tr style="Color : Black;">
					<th align="left" colspan="5"> B] &nbsp; <u>Zero Trading One-Side Brokerage for Clients</u> ( #ZeroTBrokerageList.RecordCount# ) </th>
				</tr>
				
				<CFIF ZeroTBrokerageList.RecordCount GT 0>
					<CFSET SlNo = 0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client-ID </th>
						<th align="center"> Trade </th>
						<th align="center"> Date </th>
						<th align="center"> Type </th>
					</tr>
					
					<CFLOOP query="ZeroTBrokerageList">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #CLIENT_ID#	</td>
							<td align="center"> #TRADE_NUMBER# </td>
							<td align="center"> #Dateformat( TRADE_DATE, "DD/MM/YY")# </td>
							<td align="center"> #BROKERAGE_TYPE# </td>
						</tr>
					</CFLOOP>
				</CFIF>
				
				<tr style="Color : Black;">
					<th align="left" colspan="5"> C] &nbsp; <u>No. of Clients Marked in Delivery</u> ( #ClientsMarkedInDelyList.CLIENTCNT# ) </th>
				</tr>
				
				<tr style="Color : Black;">
					<th align="left" colspan="5"> D] &nbsp; <u>Zero Delivery Brokerage for Clients</u> ( #ZeroDBrokerageList.RecordCount# ) </th>
				</tr>
				
				<CFIF ZeroDBrokerageList.RecordCount GT 0>
					<CFSET SlNo = 0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client-ID </th>
						<th align="center"> Trade </th>
						<th align="center"> Date </th>
						<th align="Left"> &nbsp;</th>
					</tr>
					<CFLOOP query="ZeroDBrokerageList">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #CLIENT_ID#	</td>
							<td align="center"> #TRADE_NUMBER# </td>
							<td align="center"> #Dateformat( TRADE_DATE, "DD/MM/YY")# </td>
							<TD ALIGN="LEFT"> &nbsp; </TD>
						</tr>
					</CFLOOP>
				</CFIF>
				
				<tr style="Color : Black;">
					<th align="Left" colspan="5"> E] &nbsp; <u>Jobbers with Brokerage</u> ( #ZeroJBrokerageList.RecordCount# ) </th>
				</tr>
				
				<CFIF ZeroJBrokerageList.RecordCount GT 0>
					<CFSET SlNo = 0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client-ID </th>
						<th align="Center"> Trade </th>
						<th align="Center"> Date </th>
						<th align="Center"> Type </th>
					</tr>
					<CFLOOP query="ZeroJBrokerageList">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #CLIENT_ID#	</td>
							<td align="Center"> #TRADE_NUMBER# </td>
							<td align="Center"> #Dateformat( TRADE_DATE, "DD/MM/YY")# </td>
							<td align="Center"> #BROKERAGE_TYPE# </td>
						</tr>
					</CFLOOP>
				</CFIF>
				
				<tr style="Color : Black;">
					<th align="left" colspan="5"> F] &nbsp; <u>Clients with Brokerage > 2.5%</u> ( #BrokerageListForSEBI.RecordCount# ) </th>
				</tr>
				
				<CFIF BrokerageListForSEBI.RecordCount GT 0>
					<CFSET SlNo = 0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client-ID </th>
						<th align="Center"> Trade </th>
						<th align="Center"> Date </th>
						<th align="Center"> Type </th>
					</tr>
					
					<CFLOOP query="BrokerageListForSEBI">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #CLIENT_ID#	</td>
							<td align="Center"> #TRADE_NUMBER# </td>
							<td align="Center"> #Dateformat( TRADE_DATE, "DD/MM/YY")# </td>
							<td align="Center"> #BROKERAGE_TYPE# </td>
						</tr>
					</CFLOOP>
				</CFIF>
				
				<tr style="Color : Black;">
					<th align="left" colspan="5"> G] &nbsp; <u>Jobbers With Delivery</u> ( #JobberWithDelivery.RecordCount# ) </th>
				</tr>
				
				<CFIF JobberWithDelivery.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client-ID </th>
						<th align="Left"> Scrip </th>
						<th align="Right"> Quantity </th>
						<th align="Center"> Buy/Sale </th>
					</tr>
					
					<CFLOOP query="JobberWithDelivery">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #CLIENT_ID#	</td>
							<td align="Left"> #SCRIP_SYMBOL# </td>
							<td align="Right"> #QTY# </td>
							<td align="Center"> #Left( BUY_SALE, 1 )# </td>
						</tr>
					</CFLOOP>
				</CFIF>
				<tr style="Color : Black;">
					<th align="left" colspan="5"> H] &nbsp; <u>Client With Manual Brokerage</u> ( #ManualBrokerage.RecordCount# ) </th>
				</tr>
				
				<CFIF ManualBrokerage.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;"> 
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client-ID </th>
						<th align="Left"> Client Name </th>
						<th align="Right"> Trade No. </th>
						<th align="Left"> &nbsp;</th>					
					</tr>
					<CFLOOP query="ManualBrokerage">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #CLIENT_ID#	</td>
							<td align="Left"> #TRIM(LEFT(CLIENT_NAME,12))# </td>
							<td align="Right"> #Trade_Number# </td>	
							<TD ALIGN="LEFT"> &nbsp; </TD>				
						</tr>
					</CFLOOP>
				</CFIF>
				<tr style="Color : Black;">
					<th align="left" colspan="5"> I] &nbsp; <u>Client With Bill Amt More Than 100000</u> ( #DebitMoreThanLack.RecordCount# ) </th>
				</tr>
				
				<CFIF DebitMoreThanLack.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client-ID </th>
						<th align="Left"> Client Name </th>
						<th align="Right"> Bill No </th>
						<th align="Left"> &nbsp;</th>				
					</tr>
					<CFLOOP query="DebitMoreThanLack">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #CLIENT_ID#	</td>
							<td align="Left"> #TRIM(LEFT(CLIENT_NAME,12))# </td>
							<td align="Right"> #BILL_NO# </td>
							<TD ALIGN="LEFT"> &nbsp; </TD>							
						</tr>
					</CFLOOP>
				</CFIF>
				<tr style="Color : Black;">
					<th align="left" colspan="5"> J] &nbsp; <u>Missing ISIN</u> ( #BlankISIN.RecordCount# ) </th>
				</tr>
				<CFIF BlankISIN.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Scrip Symbol </th>
						<th align="Left"> Scrip Name </th>
						<th align="Left"> &nbsp;</th>
						<th align="Left"> &nbsp;</th>
					</tr>
					<cfloop query="BlankISIN">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #SCRIP_SYMBOL#	</td>
							<td align="Left"> #TRIM(LEFT(SCRIP_NAME,12))# </td>
							<TD ALIGN="LEFT"> &nbsp; </TD>
							<TD ALIGN="LEFT"> &nbsp; </TD>
						</tr>	
					</cfloop>
				</cfif>
				<tr style="Color : Black;">
					<th align="left" colspan="5"> K] &nbsp; <u>Missing DP Detail</u> ( #MISSISNGBoId.RecordCount# ) </th>
				</tr>
				<CFIF MISSISNGBoId.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client Id </th>
						<th align="Left"> Client Name </th>
						<th align="Left"> &nbsp;</th>
						<th align="Left"> &nbsp;</th>
					</tr>
					<cfloop query="MISSISNGBoId">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #Client_Id#	</td>
							<td align="Left"> #LEFT(CLIENT_NAME,11)# </td>
							<TD ALIGN="LEFT"> &nbsp; </TD>
							<TD ALIGN="LEFT"> &nbsp; </TD>
						</tr>	
					</cfloop>
				</cfif>
				<tr style="Color : Black;">
					<th align="left" colspan="5"> L] &nbsp; <u>Missing Pan No</u> ( #MissingPanNO.RecordCount# ) </th>
				</tr>
				<CFIF MissingPanNO.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client Id </th>
						<th align="Left"> Client Name </th>
						<th align="Left"> &nbsp;</th>
						<th align="Left"> &nbsp;</th>
					</tr>
					<cfloop query="MissingPanNO">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #Client_Id#	</td>
							<td align="Left"> #LEFT(CLIENT_NAME,11)# </td>
							<TD ALIGN="LEFT"> &nbsp; </TD>
							<TD ALIGN="LEFT"> &nbsp; </TD>
						</tr>	
					</cfloop>
				</cfif>		
				<tr style="Color : Black;">
					<th align="left" colspan="5"> M] &nbsp; <u>Branch Without Terminal ID</u> ( #MISSINGBRANCHWITHOUTTERMINAL.RecordCount# ) </th>
				</tr>
				<CFIF MISSINGBRANCHWITHOUTTERMINAL.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;"> 
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Branch Id </th>
						<th align="Left"> Branch Name </th>
						<th align="Left"> &nbsp;</th>
						<th align="Left"> &nbsp;</th>
					</tr>
					<cfloop query="MISSINGBRANCHWITHOUTTERMINAL">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #BRANCH_CODE#	</td>
							<td align="Left"> #LEFT(BRANCH_NAME,9)# </td>
							<TD ALIGN="LEFT"> &nbsp; </TD>
							<TD ALIGN="LEFT"> &nbsp; </TD>
						</tr>	
					</cfloop>
				</cfif>		
				
				
				<tr style="Color : Black;">
					<th align="left" colspan="5"> N] &nbsp; <u>Transaction From Wrong Terminal</u> ( #TransactionFromWrongTerminal.RecordCount# ) </th>
				</tr>
				<CFIF TransactionFromWrongTerminal.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT"> Sr. </th> --->
						<th align="Left"> Client Id </th>
						<TH ALIGN="LEFT"> Branch Code </TH>
						<th align="Left"> User Id </th>
						<th align="Left"> &nbsp;</th>						
					</tr>
					<cfloop query="TransactionFromWrongTerminal">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT"> #SlNo# &nbsp;</td> --->
							<td align="Left"> #client_id# </td>
							<TD ALIGN="LEFT"> #LEFT(branch_code,11)# </TD> 
							<td align="Left">  #user_Id# </td>
							<TD ALIGN="LEFT"> &nbsp; </TD>
						</tr>	
					</cfloop>
				</cfif>		
				<CFSTOREDPROC PROCEDURE="CAPS_REPORT_BULK_DEAL" datasource="#Client.database#">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Company_Code" VALUE="#Trim(COCD)#" NULL="NO">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@from_date" VALUE="#Trade_Date#" NULL="NO">
					<CFPROCPARAM TYPE="IN" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@to_date" VALUE="#Trade_Date#" NULL="NO">
					<CFPROCPARAM  TYPE="IN" CFSQLTYPE="CF_SQL_NUMERIC" DBVARNAME="@Exposure" VALUE="0.5" scale="2" NULL="NO">
					<CFPROCRESULT NAME="BulkDeal1">
				</CFSTOREDPROC>	
				<cfquery name="BulkDeal" dbtype="query">
					select * from BulkDeal1 where Exposure_quantity <> 0 
				</cfquery>
				<tr style="Color : Black;">
					<th align="left" colspan="5"> O] &nbsp; <u>Bulk Deal Reporting</u> ( #BulkDeal.Recordcount# ) </th>
				</tr>
				<CFIF BulkDeal.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="Left"> Sr. </th> --->
						<th align="Left"> Client Id </th>
						<th align="Left"> Scrip_Symbol </th>
						<th align="Left"> Trade Qty </th>
						<th align="Left"> Exp. Qty </th>
					</tr>
					<cfloop query="BulkDeal">
						<CFSET SlNo = IncrementValue(SlNo)>	
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <TD ALIGN="LEFT"> #SlNo# </TD> --->
							<td align="Right"> #Client_ID# &nbsp;</td>
							<td align="Left"> #Scrip_Symbol#&nbsp;	</td>
							<td align="Left"> #Quantity#(#Left(Buy_sale,1)#) </td>
							<TD ALIGN="LEFT"> #Exposure_Quantity# </TD>
						</tr>	
					</cfloop>
				</cfif>		
				<tr style="Color : Black;">
					<th align="left" colspan="5"> P] &nbsp; <u>Change Of Client Id</u> ( #ChangeOfCliend.RecordCount# ) </th>
				</tr>
				<CFIF ChangeOfCliend.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT" width="3%"> Sr. </th> --->
						<th align="Left" width="8%"> Org. Cl. Id </th>
						<th align="Left" width="8%"> Chngd Cl. Id </th>
						<th align="left" width="6%"> Ord. No.</th>
						<th align="left" width="6%"> Scrip </th>
						<th align="left" width="3%"> B/S </th>
					</tr>
					<cfloop query="ChangeOfCliend">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
							<td align="Left" width="8%"> #ORG_CL# </td>
							<td align="Left" width="8%">  #CHNGD_CL# </td>
							<td align="left" width="6%"> #ORDER_NUMBER# </td>
							<tD align="left" width="6%"> #SCRIP_NAME# </tD>
							<td align="left" width="3%"> #BUY_SALE# </td>
						</tr>	
					</cfloop>
				</cfif>
				<tr style="Color : Black;">
					<th align="left" colspan="5"> Q] &nbsp; <u>Expiry Of Terminal</u> ( #ExpiryOfTerminal.RecordCount# ) </th>
				</tr>
				<CFIF ExpiryOfTerminal.RecordCount GT 0>
					<CFSET SlNo	=	0>
					<tr style="background-color: F0F8FF;">
						<!--- <th align="LEFT" width="3%"> Sr. </th> --->
						<th align="Left" width="8%"> Terminal </th>
						<th align="Left" width="8%">  User Name </th>
						<th align="left" width="6%">  Branch </th>
						<th align="left" width="6%"> Exp. Date </th>						
					</tr>
					<cfloop query="ExpiryOfTerminal">
						<CFSET SlNo = IncrementValue(SlNo)>
						<tr style="Color : Red; background-color: FAEBD7;">
							<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
							<td align="Left" width="8%"> #TERMINALID# </td>
							<td align="Left" width="8%">  #USERNAME# </td>
							<td align="left" width="6%"> #BRANCHCODE# </td>
							<tD align="left" width="6%"> #DATEFORMAT(EXPIRYDATE,"DD/MM/YY")# </tD>							
						</tr>	
					</cfloop>
				</cfif>				
				<CFIF Mkt_type eq "N">
					<tr style="Color : Black;">
						<th align="left" colspan="5"> R] &nbsp; <u>Family Internal Trade Qty</u> ( #FamilyInternalTrade.RecordCount# ) </th>
					</tr>
					<CFIF FamilyInternalTrade.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Family </th>
							<th align="Left" width="8%">  Scrip Code </th>
							<th align="left" width="6%">  Buy Qty </th>
							<th align="left" width="6%">  Sale Qty </th>						
						</tr>
						<cfloop query="FamilyInternalTrade">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #FAMILY_GROUP# </td>
								<td align="Left" width="8%">  #SCRIP_CODE# </td>
								<td align="left" width="6%"> #CREDIT_QTY# </td>
								<tD align="left" width="6%"> #DEBIT_QTY# </tD>							
							</tr>	
						</cfloop>
					</cfif>																
				</CFIF>	
					<tr style="Color : Black;">
						<th align="left" colspan="5"> S] &nbsp; <u>Custodian Transactions</u> ( #CustodianTrans.RecordCount# ) </th>
					</tr>
					<CFIF CustodianTrans.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Cust. Id </th>
							<th align="left" width="6%">&nbsp; </th>
							<th align="left" width="6%">  &nbsp; </th>						
						</tr>
						<cfloop query="CustodianTrans">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" width="8%">  #CUSTODIAN_CODE# </td>
								<td align="left" width="6%"> &nbsp; </td>
								<tD align="left" width="6%"> &nbsp; </tD>							
							</tr>	
						</cfloop>
					</cfif>																
					<tr style="Color : Black;">
						<th align="left" colspan="5"> T] &nbsp; <u>Pro Transactions</u> ( #ProTrans.RecordCount# ) </th>
					</tr>
					<CFIF ProTrans.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Client Name </th>
							<th align="left" width="6%">&nbsp; </th>
							<th align="left" width="6%">  &nbsp; </th>						
						</tr>
						<cfloop query="ProTrans">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" width="8%">  #TRIM(LEFT(CLIENT_NAME,12))# </td>
								<td align="left" width="6%"> &nbsp; </td>
								<tD align="left" width="6%"> &nbsp; </tD>							
							</tr>	
						</cfloop>
					</cfif>	
					
					<tr style="Color : Black;">
						<th align="left" colspan="5"> U] &nbsp; <u>Institution Transactions</u> ( #InstitureTrans.RecordCount# ) </th>
					</tr>
					<CFIF InstitureTrans.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Client Name </th>
							<th align="left" width="6%">&nbsp; </th>
							<th align="left" width="6%">  &nbsp; </th>						
						</tr>
						<cfloop query="InstitureTrans">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" width="8%">  #TRIM(LEFT(CLIENT_NAME,12))# </td>
								<td align="left" width="6%"> &nbsp; </td>
								<tD align="left" width="6%"> &nbsp; </tD>							
							</tr>	
						</cfloop>
					</cfif>																

					<tr style="Color : Black;">
						<th align="left" colspan="5"> V] &nbsp; <u>Client Risk > 90% </u> ( #ClientRist.RecordCount# ) </th>
					</tr>
					<CFIF ClientRist.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Dr. Amt  </th>
							<th align="left" width="6%"> Risk % </th>
							<th align="left" width="6%">  &nbsp; </th>						
						</tr>
						<cfloop query="ClientRist">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #AccountCode# </td>
								<td align="Left" width="8%">  #Debit_Amt# </td>
								<td align="left" width="6%"> #RiskP# </td>
								<tD align="left" width="6%"> &nbsp; </tD>							
							</tr>	
						</cfloop>
					</cfif>	
					<tr style="Color : Black;">
						<th align="left" colspan="5"> W] &nbsp; <u>Custodian Mismatch</u> ( #INSTMISMATCH.RecordCount# ) </th>
					</tr>
					<CFIF INSTMISMATCH.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Name  </th>
							<th align="left" width="6%"> Order </th>
							<th align="left" width="6%">  Custodian </th>						
						</tr>
						<cfloop query="INSTMISMATCH">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" width="8%">  #Left(CLIENT_NAME,9)# </td>
								<td align="left" width="6%"> #ORDER_NUMBER# </td>
								<tD align="left" width="6%"> #CUSTODIAN_CODE# </tD>							
							</tr>	
						</cfloop>
					</cfif>	

					<tr style="Color : Black;">
						<th align="left" colspan="5"> X] &nbsp; <u>TurnOver Charges Not Charged</u> ( #TOCNotCharged.RecordCount# ) </th>
					</tr>
					<CFIF TOCNotCharged.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="30%" COLSPAN="3">  Name  </th>
						</tr>
						<cfloop query="TOCNotCharged">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="3">  #Left(CLIENT_NAME,20)# </td>
							</tr>	
						</cfloop>
					</cfif>	

					<tr style="Color : Black;">
						<th align="left" colspan="5"> Y] &nbsp; <u>Stamp Duty Not Charged</u> ( #STDNotCharged.RecordCount# ) </th>
					</tr>
					<CFIF STDNotCharged.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" COLSPAN="3">  Name  </th>
						</tr>
						<cfloop query="STDNotCharged">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="3">  #Left(CLIENT_NAME,20)# </td>
							</tr>	
						</cfloop>
					</cfif>	

					<tr style="Color : Black;">
						<th align="left" colspan="5"> Z] &nbsp; <u>STT Not Charged</u> ( #STTNotCharged.RecordCount# ) </th>
					</tr>
					<CFIF STTNotCharged.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" COLSPAN="3">  Name  </th>
						</tr>
						<cfloop query="STTNotCharged">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="3">  #Left(CLIENT_NAME,20)# </td>
							</tr>	
						</cfloop>
					</cfif>	

					<tr style="Color : Black;">
						<th align="left" colspan="5"> A1] &nbsp; <u>Service Tax Not Charged</u> ( #STNotCharged.RecordCount# ) </th>
					</tr>
					<CFIF STNotCharged.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<!--- <th align="LEFT" width="3%"> Sr. </th> --->
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Name  </th>
						</tr>
						<cfloop query="STNotCharged">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<!--- <td align="LEFT" width="3%"> #SlNo# &nbsp;</td> --->
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="3">  #Left(CLIENT_NAME,20)# </td>
							</tr>	
						</cfloop>
					</cfif>	
					 <tr style="Color : Black;">
						<th align="left" colspan="5"> A2] &nbsp; <u>Client List With Defualt Slab</u> ( #DefaultSlab.RecordCount# ) </th>
					  </tr>
					<CFIF DefaultSlab.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Name  </th>
						</tr>
						<cfloop query="DefaultSlab">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="3">  #Left(CLIENT_NAME,20)# </td>
							</tr>	
						</cfloop>
					</cfif>
					 <tr style="Color : Black;">
						<th align="left" colspan="5"> A3] &nbsp; <u>InActive Client List </u> ( #InActiveClientList.RecordCount# ) </th>
					  </tr>
					<CFIF InActiveClientList.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Name  </th>
						</tr>
						<cfloop query="InActiveClientList">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="3">  #Left(CLIENT_NAME,20)# </td>
							</tr>	
						</cfloop>
					</cfif>
					
					 <tr style="Color : Black;">
						<th align="left" colspan="5"> A4] &nbsp; <u>Trading Loss > 10000 Client List </u> ( #InActiveClientList.RecordCount# ) </th>
					  </tr>
					<CFIF TradeLossCLientList.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="2">  Name  </th>
							<th align="right" width="8%">  Trading Loss  </th>
						</tr>
						<cfloop query="TradeLossCLientList">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="2">  #Left(CLIENT_NAME,20)# </td>
								<td align="right" COLSPAN="1">  #abs(AMOUNT)# </td>
							</tr>	
						</cfloop>
					</cfif>
					
					
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A4] &nbsp; <u> Client List Delivery Buy Loss > 10000</u> ( #InActiveClientList.RecordCount# ) </th>
					  </tr>
					<CFIF DeliveryBuyCLientList.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="2">  Name  </th>
							<th align="right" width="8%">  Del. Buy Loss  </th>
						</tr>
						<cfloop query="DeliveryBuyCLientList">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="2">  #Left(CLIENT_NAME,20)# </td>
								<td align="right" COLSPAN="1">  #abs(NumberFormat(AMOUNT,9999999))# </td>
							</tr>	
						</cfloop>
					</cfif>
					
					
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A5] &nbsp; <u> Client List Delivery Sale Loss > 10000.</u> ( #InActiveClientList.RecordCount# ) </th>
					  </tr>
					<CFIF DeliverySaleCLientList.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="2">  Name  </th>
							<th align="right" width="8%">  Del. Sale Loss  </th>
						</tr>
						<cfloop query="DeliverySaleCLientList">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="2">  #Left(CLIENT_NAME,20)# </td>
								<td align="RIGHT" COLSPAN="1">  #abs(NumberFormat(AMOUNT,9999999))#</td>
							</tr>	
						</cfloop>
					</cfif>
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A6] &nbsp; <u> Client With illequide Scrip.</u> </th>
					  </tr>
					<CFIF ILEGALLIST.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="1">  Scrip  </th>
							<th align="Left" width="8%" colspan="1">  Buy/Sale</th>
							<th align="Left" width="8%" colspan="1">  Qty</th>
						</tr>
						<cfloop query="ILEGALLIST">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="1">  #SCRIP_SYMBOL# </td>
								<td align="Left" COLSPAN="1">  #BUY_SALE# </td>
								<td align="Left" COLSPAN="1">  #QUANTITY# </td>
							</tr>	
						</cfloop>
					</cfif>
					
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A7] &nbsp; <u> Freshly Traded Client Within #FRESHTRADEDCLIENT.NOOFDAYS# Days  </u> </th>
				  	</tr>
					<CFIF FRESHTRADEDCLIENT.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="2">  Client Name  </th>
							<th align="Left" width="8%" colspan="1">  Branch </th>
							<th align="Left" width="8%" colspan="1">  Family </th>
							<th align="Left" width="8%" colspan="1">  Agreement </th>
						</tr>
						<cfloop query="FRESHTRADEDCLIENT">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="2">  #CLIENT_NAME# </td>
								<td align="Left" COLSPAN="1">  #BRANCH_CODE# </td>
								<td align="Left" COLSPAN="1">  #FAMILY_GROUP# </td>
								<td align="Left" COLSPAN="1">  #AGREEMENT_DATE# </td>
								
							</tr>	
						</cfloop>
					</cfif>
					
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A8] &nbsp; <u>Client Cross Trading TurnOver Limit(#C_T_TO.RecordCount#)</u> </th>
				  	</tr>
					<CFIF C_T_TO.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="2">  Client Name  </th>
						</tr>
						<cfloop query="C_T_TO">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="2">  #CLIENT_NAME# </td>
							</tr>	
						</cfloop>
					</cfif>
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A9] &nbsp; <u>Client Cross Delivery Buy TurnOver Limit(#C_DB_TO.RecordCount#)</u> </th>
				  	</tr>
					
					<CFIF C_DB_TO.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="2">  Client Name  </th>
						</tr>
						<cfloop query="C_DB_TO">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="2">  #CLIENT_NAME# </td>
							</tr>	
						</cfloop>
					</cfif>
					
					
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A10] &nbsp; <u>Client Cross Delivery Sale TurnOver Limit(#C_DS_TO.RecordCount#)</u> </th>
				  	</tr>
					
					<CFIF C_DS_TO.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="2">  Client Name  </th>
						</tr>
						<cfloop query="C_DS_TO">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="2">  #CLIENT_NAME# </td>
							</tr>	
						</cfloop>
					</cfif>
					
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A11] &nbsp; <u>Client Cross Gross TurnOver Limit(#C_G_TO.RecordCount#)</u> </th>
				  	</tr>
					
					<CFIF C_G_TO.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%" colspan="2">  Client Name  </th>
						</tr>
						<cfloop query="C_G_TO">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
								<td align="Left" COLSPAN="2">  #CLIENT_NAME# </td>
							</tr>	
						</cfloop>
					</cfif>
					

					<tr style="Color : Black;">
						<th align="left" colspan="5"> A12] &nbsp; <u>InterSettlement Require Client List </u> </th>
				  	</tr>
					<CFIF C_T_TO1.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  ISIN  </th>
							<th align="Left" width="8%">  Scrip Name  </th>
							<th align="Left" width="8%">  Qty  </th>
						</tr>
						<cfloop query="C_T_TO1">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_CODE# </td>
							<th align="Left" width="8%">  #ISIN#  </th>
							<th align="Left" width="8%">  #Scrip_Name#  </th>
							<th align="Left" width="8%">  #QTY#  </th>
							</tr>	
						</cfloop>
					</cfif>

					<tr style="Color : Black;">
						<th align="left" colspan="5"> A13] &nbsp; <u>Client Sale W/o Stock</u> </th>
				  	</tr>
					<CFIF C_T_TO2.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  ISIN  </th>
							<th align="Left" width="8%">  Scrip Name  </th>
							<th align="Left" width="8%">  Short  </th>
						</tr>
						<cfloop query="C_T_TO2">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_CODE# </td>
							<th align="Left" width="8%">  #ISIN#  </th>
							<th align="Left" width="8%">  #Scrip_Name#  </th>
							<th align="Left" width="8%">  #Short#  </th>
							</tr>	
						</cfloop>
					</cfif>
					
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A13] &nbsp; <u>Client With Physical Scrip</u> </th>
				  	</tr>
					<CFIF Phaysical.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Scrip Code</th>
							<th align="Left" width="8%">  Scrip Name  </th>
						</tr>
						<cfloop query="Phaysical">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_CODE# </td>
							<th align="Left" width="8%">  #SCRIP_SYMBOL#  </th>
							<th align="Left" width="8%">  #Scrip_Name#  </th>
							</tr>	
						</cfloop>
					</cfif>
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A14] &nbsp; <u>List Of NRI Client Trade</u> </th>
				  	</tr>
					<CFIF NRI.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Client Name  </th>
						</tr>
						<cfloop query="NRI">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_ID# </td>
							<th align="Left" width="8%">  #Client_Name#  </th>
							</tr>	
						</cfloop>
					</cfif>
					<tr style="Color : Black;">
						<th align="left" colspan="5"> A14] &nbsp; <u>Month IBT JV Not Post</u> </th>
				  	</tr>
					<CFIF MIBT.RecordCount GT 0>
						<CFSET SlNo	=	0>
						<tr style="background-color: F	0F8FF;">
							<th align="Left" width="8%"> Client ID </th>
							<th align="Left" width="8%">  Join Date  </th>
							<th align="Left" width="8%">  Ledger </th>
						</tr>
						<cfloop query="MIBT">
							<CFSET SlNo = IncrementValue(SlNo)>
							<tr style="Color : Red; background-color: FAEBD7;">
								<td align="Left" width="8%"> #CLIENT_CODE# </td>
							<th align="Left" width="8%">  #START_DATE#  </th>
							<th align="Left" width="8%">  #LEDGER#  </th>
							</tr>	
						</cfloop>
					</cfif>
					
					
			</table>
		</div>
<!--- 	</CFIF> --->
</CFIF>
</CFOUTPUT>
</body>
</html>

</CFSAVECONTENT>

<CFSET	File_Name	=	"#Mkt_Type#-#Settlement_NO#_#TimeFormat(now(),'HHMMSS')#.htm">
<CFIF	NOT DirectoryExists("#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports")>
	<CFDIRECTORY ACTION="CREATE" DIRECTORY="#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports">
</CFIF>
<CFIF	NOT DirectoryExists("#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\#cocd#_Alert")>
	<CFDIRECTORY ACTION="CREATE" DIRECTORY="#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\#cocd#_Alert">
</CFIF>
	
<CFFILE ACTION="WRITE" FILE="#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\#cocd#_Alert\#File_Name#" OUTPUT="#BillForm#">
<CFQUERY NAME="GetEMailIDs" datasource="#Client.database#">
	SELECT
			From_EMail_ID, CC_Email_ID,isnull(SendMes_UserList,'') SendMes_UserList
	FROM
			SYSTEM_SETTINGS
	WHERE
			Company_Code	=	'#COCD#'
</CFQUERY>
<CFSET	FromMailID	=	GetEMailIDs.From_EMail_ID>
<CFSET	CCMail		=	GetEMailIDs.CC_Email_ID>
<CFIF p8 eq 1>
	<CFSET a = write("Bill Processed For #cocd# #Mkt_Type# #Settlement_NO# #DATEFORMAT(NOW(),'DD/MM/YYYY')# #TIMEFORMAT(NOW(),'HH:MM:SS')#")>
</CFIF>
<CFOUTPUT>
#BillForm#
</CFOUTPUT> 
<cfoutput>
<Cfset File_Name1 = File_Name>
<CFSET File_Name = "#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\#cocd##cocd#_Alert\#File_Name#">
<CFTRY>
	<CFMAIL FROM="#FromMailID#" TO="#CCMail#" MIMEATTACH="#File_Name#" SUBJECT="Bill Process Results for #Mkt_Type#-#Settlement_No# for the date - #Trade_Date#">
	</CFMAIL> 
	<CFCATCH>
	<FONT COLOR="FF0000" TITLE="Mail Server Is Not Defined #cfcatch.Message##cfcatch.Detail#"><BR>***</FONT>
	</CFCATCH>
</CFTRY>
<CFTRY>
	<cfif GetEMailIDs.SendMes_UserList neq ''>
		<cfloop index="i" list="#GetEMailIDs.SendMes_UserList#" delimiters=",">
			<Cfset a = SendMes("Company:#cocd#,Settlement :#Mkt_Type#-#Settlement_NO#",'<a href="http://#cgi.SERVER_NAME#:8500/Reports/#cocd#_Alert/#File_Name1#">#File_Name1#</a>',"#i#")>
		</cfloop>
	</cfif>
	<CFCATCH>
	<FONT COLOR="FF0000" TITLE="#cfcatch.Detail#//#cfcatch.Message#"><BR>***</FONT>
	</CFCATCH>
</CFTRY>
<Cftry>
		<CFSET A = EODProcess("Bill Process",'#Trade_Date#','#Trade_Date#','#cocd#','#mkt_type#','#Val(Trim(Settlement_No))#')>
<cfcatch>
</cfcatch>
</Cftry>

</cfoutput>


