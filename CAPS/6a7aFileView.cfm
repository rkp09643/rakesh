<!---- **************************************************************
	BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*************************************************************** ---->
<HTML>
<HEAD>
	<TITLE> Client Overview Contents Screen. </TITLE>
	<LINK href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	
	<STYLE>
		DIV#TableHeader
		{
			Position		:	Absolute;
			Top				:	0;
			Width			:	100%;
			left			:	0%;
			Background		:	DDFFFF;
		}
		DIV#TableData
		{
			Position		:	Absolute;
			Top				:	6%;
			Width			:	100%;
			Height			:	82%;
			left			:	0%;
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
		
		function CallEnable(form,val,sr)
		{
			with(form)
			{
				if(val == "" || val.length == 0 || val == " ")
				{
					eval("GenerateChb"+sr).disabled = true;	
				}
				else
				{
					var val1;
					val1 = sr+1; 
					eval("GenerateChb"+sr).disabled = false;	
					eval("GenerateChb"+sr).checked = true;
					if (val1 <= TotalRecord.value)
					{
						eval("CustPartId"+val1).focus();
					}	
				}
			}
			
		}

	function AllSelect(frm)
	{
		with(frm)
		{

			var totalbranch,i,j,k;
			totalbranch = Sr.value;
			for(i=1;i<50;i++)
			{
				if(eval("GenerateChb"+i).checked == false)
				{
					eval("GenerateChb"+i).checked = true;
				}
				else
				{
					eval("GenerateChb"+i).checked = false;
				}
			}
		}
	}	

	</SCRIPT>
</HEAD>



<BODY id="ScreenContents" leftmargin="0" rightmargin="0">
<CFIF NOt isdefined("txtOrderDate")>
	<CFABORT>
</CFIF>

<CFOUTPUT>
<cfparam name="INST_NET" default="0">
<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">

<CFQUERY NAME="GetClCode" DATASOURCE="#Client.Database#">
	Select	Clearing_Member_Code,Exchange_Clearing_Code
	From
			System_Settings
	Where
			Company_Code	=	'#COCD#'
</CFQUERY>

<CFSET	ClearingMemberCode	=	GetClCode.Clearing_Member_Code>
<CFSET FileDate = "">
<CFIF IsDefined("Print")>
		<CFSET UpdateRow	=		0>
 <CFDOCUMENT format="PDF"    pagetype="A4"    marginleft = "0.5"   marginright = "0.5" orientation = "landscape">
<CFDOCUMENTITEM type="footer">
		<CFOUTPUT>
			<TABLE width="800" border="0" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1">
				 <TR>
					<TD CLASS="StyleTable"  WIDTH="600" STYLE="border-top-width:thin;border-top-style:solid;"><FONT SIZE="-1">Print Date:#DateFormat(now(),'DDD,MMMM YY')#,&nbsp;&nbsp;&nbsp;#TimeFormat(now(),'HH:MM:SS tt')#</FONT> </TD>
					<TD CLASS="StyleTable" WIDTH="200" ALIGN="RIGHT" STYLE="border-top-width:thin;border-top-style:solid;"><FONT SIZE="-1"> Tech Excel[Page :#cfdocument.currentpagenumber#/#cfdocument.totalpagecount#]</FONT></TD>
				</TR>
			</TABLE>
		</CFOUTPUT>
</CFDOCUMENTITEM> 
 <CFDOCUMENTITEM type="Header">
		<CFOUTPUT>
			<TABLE width="800" border="0" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1">
				 <TR >
					<TD CLASS="StyleTable"  WIDTH="600" ALIGN="CENTER" ><FONT SIZE="-1">#coname#(#Exchange#)</FONT> </TD>
				</TR>
			</TABLE>
		</CFOUTPUT>
</CFDOCUMENTITEM> 
<CFDOCUMENTSECTION > 
<TABLE BORDER="1" CELLPADDING="0" CELLSPACING="0" WIDTH="100%">
	<CFLOOP INDEX="i" FROM="1" TO="#Sr#">
		<CFIF IsDefined("GenerateChb#i#")>			
			<CFSET	ClientID	=	Trim(Evaluate("ClientID#i#"))>
			<CFSET	Scrip		=	Trim(Evaluate("Scrip#i#"))>		
			<CFSET	BuySale		=	Trim(Evaluate("Buy_Sale#i#"))>
			<CFSET	Quantity	=	Trim(Evaluate("Quantity#i#"))>
			<CFSET	Amount		=	Trim(Evaluate("Amount#i#"))>
			<CFSET 	CustId		=  	Trim(Evaluate("CustodianId#i#"))>
			<CFSET  Generate1	= 	Trim(Evaluate("GenerateChb#i#"))>
			<CFSET 	ContractNo	=	Trim(Evaluate("Contract#I#"))>
			<CFSET  Option1		=	Trim(Evaluate("Option1#I#"))>
			<CFSET  Option2		=	Trim(Evaluate("Option2#I#"))>
			<CFSET	Custpartcode	=	Trim(Evaluate("CustPartId#i#"))>
			<CFSET FinalAmt		=		Amount*100>		
				<TR>
					<TH ALIGN="LEFT" WIDTH="16%">Client ID &nbsp;</TH>
					<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
					<TD  WIDTH="16%">#ClientID#</TD>
					<TH ALIGN="LEFT" WIDTH="16%">Cusodian ID &nbsp;</TH>
					<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
					<TD  WIDTH="16%">#CustId#</TD>
					<TH ALIGN="LEFT" WIDTH="16%">Buy/Sale</TH>
					<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
					<TD>#BuySale#</TD>
				</TR>
				<TR>
						<TH ALIGN="LEFT">Scrip</TH>
						<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
						<TD>#Scrip#</TD>
						<TH ALIGN="LEFT">Amount</TH>
						<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
						<TD>#NumberFormat(Trim(FinalAmt),'999999999999999999')#</TD>
						<TH ALIGN="LEFT">Date</TH>
						<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
						<TD>#DateFormat(txtOrderDate,"DD/MM/YYYY")#</TD>
				</TR>
				<TR>
						<TH ALIGN="LEFT">Delivery Type</TH>
						<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
						<TD>
							<CFIF 	Option1 eq "B">
								Bank
							<CFELSE>
								Hand	
							</CFIF>
						</TD>
						<TH ALIGN="LEFT">Settlement No</TH>
						<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
						<TD>#txtSetlId#</TD>
						<TH ALIGN="LEFT">Custodian Participant Code</TH>
						<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
						<TD>#Custpartcode#</TD>
				</TR>
				<TR>
						<TH ALIGN="LEFT">Contract No</TH>
						<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
						<TD>#ContractNo#</TD>
						<TH ALIGN="LEFT">Deal Type</TH>
						<TD WIDTH="1%">&nbsp;:&nbsp;</TD>
						<TD>
							<CFIF Option2 eq "1">
								Block
							<CFELSE>
								Other
							</CFIF>
						</TD>
						<TH ALIGN="LEFT" COLSPAN="3">&nbsp;</TH>
						
				</TR>
			<CFSET UpdateRow	=	IncrementValue(UpdateRow)>
			<TR>
				<TD COLSPAN="9">&nbsp;
					
				</TD>
			</TR>
				<TR>
					<TD COLSPAN="9">&nbsp;
					</TD>
				</TR>
		</CFIF>
	</CFLOOP>			
	</TABLE>

 </CFDOCUMENTSECTION>		
</CFDOCUMENT>
 <CFABORT>
</CFIF>

<CFIF IsDefined("Generate")>

	<CFSET UpdateRow	=		0>
	<CFQUERY NAME="GETDATE" DATASOURCE="#CLIENT.DATABASE#">
		SELECT CONVERT(DATETIME,'#txtOrderDate#',103) DATE
	</CFQUERY>
	<CFSET ORDERDATE = "#LEFT(TRIM(GETDATE.DATE),10)#">
	<CFLOOP INDEX="i" FROM="1" TO="#Sr#">
		<CFIF IsDefined("GenerateChb#i#")>			
			<CFSET	ClientID	=	Trim(Evaluate("ClientID#i#"))>
			<CFSET	Scrip		=	Trim(Evaluate("Scrip#i#"))>		
			<CFSET	BuySale		=	Trim(Evaluate("Buy_Sale#i#"))>
			<CFSET	Quantity	=	Trim(Evaluate("Quantity#i#"))>
			<CFSET	Amount		=	Trim(Evaluate("Amount#i#"))>
			<CFSET 	CustId		=  	Trim(Evaluate("CustodianId#i#"))>
			<CFSET  Generate1	= 	Trim(Evaluate("GenerateChb#i#"))>
			<CFSET 	ContractNo	=	Trim(Evaluate("Contract#I#"))>
			<CFSET  Option1		=	Trim(Evaluate("Option1#I#"))>
			<CFSET  Option2		=	Trim(Evaluate("Option2#I#"))>
			<CFSET	Custpartcode	=	Trim(Evaluate("CustPartId#i#"))>
			
			<CFSET FinalAmt		=	Amount*100>		
			<cfset FinalAmt		=	"#NumberFormat(Trim(FinalAmt),'999999999999999999')#">
			
			<CFIF	IsDefined("Generate1") And Generate1 Eq "Yes">
				<CFSET FileDate = "#FileDate##CustId#|#Left(BuySale,1)#|#Quantity#|#Scrip#|#Trim(FinalAmt)#|#ORDERDATE#|#Option1#|#RIGHT(TRIM(txtSetlId),3)#|#Custpartcode#|#ContractNo#|0|#CHR(10)#">
			</CFIF>
			<CFSET UpdateRow	=	IncrementValue(UpdateRow)>
		</CFIF>
	</CFLOOP>

	<CFIF UpdateRow	EQ 0>
		<SCRIPT>
			alert("Please Select Select Atleast One Institution")
		</SCRIPT>
	<CFELSE>

		<CFIF not directoryexists("C:\CFusionMX7\wwwroot\Reports\6A7AFILES")>
			<CFDIRECTORY ACTION="CREATE" DIRECTORY="C:\CFusionMX7\wwwroot\Reports\6A7AFILES\">
		</CFIF>
			
		<CFSET FILENAME = "C:\CFusionMX7\wwwroot\Reports\6A7AFILES\#ORDERDATE#_#TimeFormat(Now(),"HHMMSS")#.B67">
		<CFFILE action="write" output="#FileDate#" file="#fILEnAME#" addnewline="no">
		
		<SCRIPT>
			alert("File Has been Generated On Server At #Replace(FILENAME,'\','\\')#");
		</SCRIPT>
		
		<CFSET ClientFileName  = "C:\Reports\6A7A_#ORDERDATE#_#TimeFormat(Now(),"HHMMSS")#.B67">
		<CFSET	ClientFileGenerated	=	CopyFile("#FILENAME#","#ClientFileName#")>
		
		<CFIF  ClientFileGenerated>
			<SCRIPT>
				alert("File Generated On Client Machine #Replace(ClientFileName,'\','\\')#");
			</SCRIPT>
		</CFIF>
		
	</CFIF>	
	
</CFIF>



<CFPARAM NAME="txtOrderDate" DEFAULT="">
<CFPARAM NAME="invalidClient" DEFAULT="No">

<!--- <CFTRY> --->
	<CFQUERY NAME="GetOrderTrades" DATASOURCE="#Client.Database#">
		SELECT	
				RTRIM(A.CLIENT_ID) CLIENT_ID, 
				IsNull(Client_Name,'')Client_Name,RTRIM(LTRIM(A.CLIENT_ID)) +'-'+ IsNull(Rtrim(Ltrim(Left(Client_Name,18))),'') Client,
				Max(Custodian_Id) Custodian_ID1,SCRIP_SYMBOL, BUY_SALE, 
				ISNULL(SUM( QUANTITY ), 0) Quantity,Contract_No,
				CASE WHEN A.BUY_SALE = 'SALE' THEN 
					SUM(QUANTITY) * MAX(NET_PRICE)
				Else 
					SUM(QUANTITY) * MAX(NET_PRICE)
				END Amount,
				SUM((TRADE_BROKERAGE + DELIVERY_BROKERAGE) * QUANTITY) / SUM(QUANTITY) BRK,
				Max(ISNULL(Bill_No,0))Bill_No,MAX(Custodian_Part_Code) CustPartCode,
				MAX(MKT_PRICE) Rate,
				MAX(NET_PRICE) NetRate
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
		AND		Mkt_Type			=	'#Mkt_Type#'
		AND		Client_Nature		= 'I'
		And 	isnull(Cusi_Client,'n')			=	'n'
		Group By
			A.CLIENT_ID, SCRIP_SYMBOL, BUY_SALE, Client_Name,Contract_No
		Order By
			A.CLIENT_ID,SCRIP_SYMBOL, BUY_SALE
	</CFQUERY>

	<input type="hidden" value="#GetOrderTrades.recordcount#" name="Total">
<!--- <CFCATCH type="Any">
	#cfcatch.detail#
</CFCATCH>
</CFTRY> --->

<CFIF GetOrderTrades.RecordCount eq 0>
	<SCRIPT>
		alert( "No Data found." );
	</SCRIPT>
	<CFABORT>
</CFIF>


<CFFORM NAME="ScrOrd" ACTION="6A7AFILEVIEW.cfm" METHOD="POST">

	<INPUT type="Hidden" name="COCD" value="#Trim(COCD)#">
	<INPUT type="Hidden" name="COName" value="#COName#">
	<INPUT type="Hidden" name="Market" value="#Market#">
	<INPUT type="Hidden" name="Exchange" value="#Exchange#">
	<INPUT type="Hidden" name="Broker" value="#Broker#">
	<INPUT type="Hidden" name="FinStart" value="#FinStart#">
	<INPUT type="Hidden" name="FinEnd" value="#FinEnd#">

	<INPUT type="Hidden" name="txtOrderDate" value="#txtOrderDate#">		
	<INPUT TYPE="HIDDEN" NAME="txtSetlId" VALUE="#txtSetlId#">
	<INPUT TYPE="HIDDEN" NAME="Mkt_Type" VALUE="#Mkt_Type#">
	<INPUT type="hidden" name="TotalRecord" value="#GetOrderTrades.RecordCount#">
<DIV align="center" id="TableHeader">
	
	<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="LEFT" class="StyleReportParameterTable1" style="Color : Green;">
		<TR STYLE="background:LightSteelBlue; ">
			<TH align="CENTER" width="3%"> No&nbsp; </TH>
			<TH align="CENTER" width="10%"> Client &nbsp; </TH>			
			<TH align="CENTER" width="6%"> Scrip </TH>
			<TH align="CENTER" width="2%"> B/S </TH>
			<TH align="CENTER" width="5%"> Qty </TH>
			<TH align="CENTER" width="6%"> A.Rate </TH>
			<TH align="center" width="6%"> Brk.</TH>
			<TH align="center" width="6%"> Exp.</TH>
			<TH align="center" width="9%"> Contract Amount </TH>
			<TH align="CENTER" width="5%"> Del. Type </TH>
			<TH align="center" width="5%">Deal Type</TH>
			<TH align="center" width="5%">Cust Part. Code</TH>
			<TH ALIGN="CENTER" WIDTH="10%" rowspan="2">
				Custodian Id
			</TH>
			 <TH ALIGN="center" WIDTH="2%">&nbsp;
		 		<INPUT type="Checkbox"  name="All" value="All" Class="StylePlainTextBox" onClick="AllSelect(ScrOrd);"> 
			</TH>
		</TR>
	</TABLE>
</DIV>
	
<DIV align="center" id="TableData" style="top:11%; ">

	<CFSET Sr				=	0>
		
	<CFLOOP query="GetOrderTrades">
	
	
		<CFQUERY NAME="Service" DATASOURCE="#Client.DataBase#" DBTYPE="ODBC">
			Select 	round( ( a.Debit - a.Credit ) , 2) Amt , b.ControlName 
			from  	Client_Expenses a , Control_Master b, Brokerage_Apply C
			Where	a.COMPANY_CODE		=  b.COMPANY_CODE
				and a.COMPANY_CODE		=  C.COMPANY_CODE
				and a.Client_ID			=  C.Client_ID
				and	a.ExpenseAccount 	=  b.ControlAccount
				and a.COMPANY_CODE		=  '#Trim(Ucase(cocd))#'
				and	mkt_type			=  '#Trim(Ucase(mkt_type))#'
				and settlement_no		=  #Val(txtSetlId)#
				
				and a.Client_ID 		=  '#client_id#'
				and a.Expense_Type 		=  'SCH'
				and b.SHOWINCONTRACT	=  'Y'
				AND	CONVERT(DATETIME, '#txtOrderDate#', 103) 	BETWEEN	CONVERT(DATETIME, START_DATE, 103)
				AND		IsNull( CONVERT(DATETIME, END_Date, 103), CONVERT(DATETIME, '#txtOrderDate#', 103))
				AND	ST					=	'Y'
				AND ISNULL(client_CONTRACT_NO,0) = 			#Trim(CONTRACT_NO)#
		</CFQUERY>

		<CFQUERY NAME="Turnover" DATASOURCE="#Client.DataBase#" DBTYPE="ODBC">
			Select 	round( ( a.Debit - a.Credit ) , 2) Amt , b.ControlName 
			from  	Client_Expenses a , Control_Master b, Brokerage_Apply C
			Where	a.COMPANY_CODE		=  b.COMPANY_CODE
				and a.COMPANY_CODE		=  C.COMPANY_CODE
				and a.Client_ID			=  C.Client_ID
				and a.COMPANY_CODE		=  C.COMPANY_CODE
				and a.Client_ID			=  C.Client_ID
				and	a.ExpenseAccount 	=  b.ControlAccount
				and a.COMPANY_CODE		=  '#Trim(Ucase(cocd))#'
				and	mkt_type			=  '#Trim(Ucase(mkt_type))#'
				and settlement_no		=  #Val(txtSetlId)#
				
					AND ISNULL(CLIENT_CONTRACT_NO,0) = 			#Trim(CONTRACT_NO)#
				
				
				and a.Client_ID 		=  '#client_id#'
				and a.Expense_Type 		=  'TOC'
				and b.SHOWINCONTRACT	=  'Y'
				AND	CONVERT(DATETIME, '#txtOrderDate#', 103) 	BETWEEN	CONVERT(DATETIME, START_DATE, 103)
															AND		IsNull( CONVERT(DATETIME, END_Date, 103), CONVERT(DATETIME, '#txtOrderDate#', 103))
				AND	TOC					=	'Y'
		</CFQUERY>
	
		<CFQUERY NAME="Stamp" DATASOURCE="#Client.DataBase#" DBTYPE="ODBC">
			Select 	round( ( a.Debit - a.Credit ) , 2) Amt , b.ControlName 
			from  	Client_Expenses a , Control_Master b, Brokerage_Apply C
			Where	a.COMPANY_CODE		=  b.COMPANY_CODE
				and a.COMPANY_CODE		=  C.COMPANY_CODE
				and a.Client_ID			=  C.Client_ID
				and	a.ExpenseAccount 	=  b.ControlAccount
				and a.COMPANY_CODE		=  '#Trim(Ucase(cocd))#'
				and	mkt_type			=  '#Trim(Ucase(mkt_type))#'
				and settlement_no		=  #Val(txtSetlId)#
				
				
					AND ISNULL(CLIENT_CONTRACT_NO,0) = 			#Trim(CONTRACT_NO)#
				
				and a.Client_ID 		=  '#client_id#'
				and a.Expense_Type 		=  'STD'
				and b.SHOWINCONTRACT	=  'Y'
				AND	CONVERT(DATETIME, '#txtOrderDate#', 103) 	BETWEEN	CONVERT(DATETIME, START_DATE, 103)
															AND		IsNull( CONVERT(DATETIME, END_Date, 103), CONVERT(DATETIME, '#txtOrderDate#', 103))
				AND	STD					=	'Y'
		</CFQUERY>
		<CFQUERY NAME="Others" DATASOURCE="#Client.DataBase#" DBTYPE="ODBC">
			Select 	round( SUM( a.Debit - a.Credit ) , 2) Amt, b.ControlName 
			from  	Client_Expenses a , Control_Master b
			Where	a.COMPANY_CODE		=  b.COMPANY_CODE
				and	a.ExpenseAccount 	=  b.ControlAccount
				and a.COMPANY_CODE		=  '#Trim(Ucase(cocd))#'
				and	mkt_type			=  '#Trim(Ucase(mkt_type))#'
				and settlement_no		=  #Val(txtSetlId)#
				AND ISNULL(CLIENT_CONTRACT_NO,0) = 			#Trim(CONTRACT_NO)#
				and a.Client_ID 		=  '#client_id#'
				and a.Expense_Type 		=  'OTH'
				and b.SHOWINCONTRACT	=  'Y'
			Group By
				b.ControlName 	
		</CFQUERY>
		<Cfset Exp1 = 0>
		<cfloop query="Service">
			<CFSET Exp1 =Exp1 - Amt>
		</cfloop>
		<cfloop query="Turnover">
			<CFSET Exp1 =Exp1-Amt>	
		</cfloop>
		<cfloop query="Stamp">
			<CFSET Exp1 =Exp1-Amt>	
		</cfloop>
		<cfloop query="Others">
			<CFSET Exp1 =Exp1-Amt>	
		</cfloop>
		
			<CFQUERY NAME="GetSttApplied" DATASOURCE="#Client.Database#">
				Select 
						Client_ID,INST_PRINTSTT,ISNULL(INST_GROSS_ROUNDING,0) INST_GROSS_ROUNDING,
											ISNULL(INST_NET_ROUNDING,0)  INST_NET_ROUNDING
				From
						Client_Master
				Where
						Company_Code	=	'#COCD#'
				And		Client_ID		=	'#Client_ID#'
			</CFQUERY>
			
			
			<CFQUERY NAME="GetDBSTTDetail" DATASOURCE="#Client.Database#">
				SELECT	STT As BSTT
				FROM
						STT_DETAILS
				WHERE
						COMPANY_CODE = '#COCD#'
				AND  	CONVERT(DATETIME, FROM_DATE, 103) <= CONVERT(DATETIME, '#txtOrderDate#', 103)
				AND  	CONVERT(DATETIME, ISNULL(TO_DATE, CONVERT(DATETIME, '#txtOrderDate#', 103)), 103) >= CONVERT(DATETIME, '#txtOrderDate#', 103)
				AND		CAPS_TRADE_TYPE	=	'D'
				AND		CAPS_BUY_SALE	=	'B'
			</CFQUERY>
		
			<CFQUERY NAME="GetDSSTTDetail" DATASOURCE="#Client.Database#">
				SELECT	STT As SSTT
				FROM
						STT_DETAILS
				WHERE
						COMPANY_CODE = '#COCD#'
				AND  	CONVERT(DATETIME, FROM_DATE, 103) <= CONVERT(DATETIME, '#txtOrderDate#', 103)
				AND  	CONVERT(DATETIME, ISNULL(TO_DATE, CONVERT(DATETIME, '#txtOrderDate#', 103)), 103) >= CONVERT(DATETIME, '#txtOrderDate#', 103)
				AND		CAPS_TRADE_TYPE	=	'D'
				AND		CAPS_BUY_SALE	=	'S'
			</CFQUERY>
		
			<CFSET	BSTT	=	GetDBSTTDetail.BSTT>
			<CFSET	SSTT	=	GetDSSTTDetail.SSTT>

			<CFIF	val(GetSttApplied.INST_GROSS_ROUNDING)	neq	0>
				<Cfset INST_GROSS =  GetSttApplied.INST_GROSS_ROUNDING>
			</CFIF>
			<CFIF	val(GetSttApplied.INST_NET_ROUNDING)	neq	0>
				<Cfset INST_NET =  GetSttApplied.INST_NET_ROUNDING>
			</CFIF>
		
			<CFIF	GetSttApplied.INST_PRINTSTT	eq	'N'>
				<CFSET	APPLY_STT	=	FALSE>
			<CFELSE>
				<CFSET	APPLY_STT	=	TRUE>	
			</CFIF>

			<CFQUERY NAME="GetClientBrkDetail" DATASOURCE="#Client.DataBase#">
				Select	Adjustment_Code, Del_Adjustment_Code
				From	Brokerage_Apply
				Where	
						Company_Code	=	'#COCD#'
				AND		CLIENT_ID		=	'#Trim(CLIENT_ID)#'
				AND		CONVERT(DATETIME, '#txtOrderDate#', 103) 	BETWEEN	CONVERT(DATETIME, START_DATE, 103)
																AND		IsNull( CONVERT(DATETIME, END_Date, 103), CONVERT(DATETIME, '#txtOrderDate#', 103))
			</CFQUERY>
		
			<CFSET	DelAdjCode	=	GetClientBrkDetail.Del_Adjustment_Code>
						
			<cfif	GetClientBrkDetail.Adjustment_Code	EQ	4
			OR		GetClientBrkDetail.Adjustment_Code	EQ	13
			OR		GetClientBrkDetail.Adjustment_Code	EQ	14
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	21
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	23
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	4
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	13
			OR		GetClientBrkDetail.Del_Adjustment_Code	EQ	14>	
					<cfset	DecimalVal	=	9999>
					<cfset BRKDECIMAL  = 4>
			<cfelse>		
					<cfset BRKDECIMAL  = 2>
					<cfset	DecimalVal	=	99>
			</cfif>

			<CFSET	QTY		=	Quantity>
			
			
			<!--- <CFIF	FOURDECIACTIVE	And RATE GT 0>
				<CFSET	RATEDecimal	=	Find(".",RATE)>
				<CFSET	RATE1			= 	Trim(NumberFormat(Mid(Trim(RATE), 1, RATEDecimal+4),"9999999.9999"))>

				<CFSET	BRKDecimal		=	Find(".",BRK)>
				<CFSET	BRK1			= 	Trim(NumberFormat(Mid(Trim(BRK), 1, BRKDecimal+4),"9999999.9999"))>

				<CFSET	NetRATEDecimal	=	Find(".",NetRATE)>
				<CFSET	NetRATE1		= 	Trim(NumberFormat(Mid(Trim(NetRATE), 1, NetRATEDecimal+4),"9999999.9999"))>
				 --->
				
				
				<CFSET	BRK1	=	TRIM(NUMBERFORMAT(BRK,'9999999999999.999999'))>
				<CFSET	NetRATE1	=	NetRATE>
				
				<CFSET	RATEDecimal	=	Find(".",RATE)>
				
				<CFIF GetClientBrkDetail.Del_Adjustment_Code	EQ	24 OR GetClientBrkDetail.Del_Adjustment_Code	EQ	22>
					<CFSET	RATE1	= 	Trim(NumberFormat(Mid(Trim(RATE), 1, RATEDecimal+4),'9999999.'&RepeatString(9,2))) >				
				<cfelse>
					<CFSET	RATE1	= 	Trim(NumberFormat(Mid(Trim(RATE), 1, RATEDecimal+INST_GROSS),'9999999.'&RepeatString(9,INST_GROSS))) >					
				</CFIF>
				
				
				<CFSET ACTAMT = TRIM(NUMBERFORMAT(QTY * RATE1,'999999999999999.999999'))>
				<CFSET ACTAMTDecimal	=	Find(".",ACTAMT)>
				<CFSET ACTAMT1 = Trim(NumberFormat(Mid(Trim(ACTAMT), 1, ACTAMTDecimal+2),'99999999999999.'&RepeatString(9,2)))>
				<CFSET	BRK1Decimal	=	Find(".",TRIM(BRK1))>
				<CFSET	BRK2			= 	TRIM(Numberformat(Mid(Trim(BRK1), 1, BRK1Decimal+BRKDECIMAL),'999999999.'&RepeatString(9,BRKDECIMAL)))>					
				
				<CFSET	NETRATEDecimal	=	Find(".",NETRATE)>
				<CFSET	NETRATE1	= 	Trim(NumberFormat(Mid(Trim(NETRATE), 1, NETRATEDecimal+INST_NET),'9999999.'&RepeatString(9,INST_NET))) >				
	
				<CFSET	RATE	=	RATE1>
				<CFSET	BRK		=	BRK2>
				<CFSET	NetRATE	=	NetRATE1>
				<CFSET	TOTBRK		=	TRIM(NUMBERFORMAT(QTY	*	BRK2,"999999999.999999"))>
				<CFSET	BRKDecimal	=	Find(".",TOTBRK)>
				
				<CFIF GetClientBrkDetail.Del_Adjustment_Code	EQ	24 OR GetClientBrkDetail.Del_Adjustment_Code	EQ	22
				OR GetClientBrkDetail.Del_Adjustment_Code	EQ	23 OR GetClientBrkDetail.Del_Adjustment_Code	EQ	21
				>
					<CFSET	TOTBRK1	= 	Trim(NumberFormat(Mid(Trim(TOTBRK), 1, BRKDecimal+4),'9999999.99')) >
				<cfelse>
					<CFSET	TOTBRK1	= 	Trim(NumberFormat(Mid(Trim(TOTBRK), 1, BRKDecimal+2),'9999999.99')) >	
				</CFIF>
				
				<CFSET	TOTBrk	=	TOTBRK1>
				<CFIF	BUY_SALE EQ "BUY">
					<CFSET	AMT =		ACTAMT1+TOTBRK1>
				<cfelse>
					<CFSET	AMT =		ACTAMT1-TOTBRK1>
				</cfif>	

				<!--- <CFSET	AMT		=	Trim(NumberFormat(BQTY * BNetRATE1,"99999999.99"))> --->
				<CFSET	Actual_Amt	=	ACTAMT1>
				

				
<!--- 			<CFELSE>
				<CFSET	RATE1			=	NumberFormat(RATE,"99999999." & DecimalVal)>
				<CFSET	BRK1			=	NumberFormat(BRK,"99999999." & DecimalVal)>
				<CFSET	NetRATE1		=	NumberFormat(NetRATE,"99999999." & DecimalVal)>
			</CFIF>
 --->			
			<!--- <CFSET	RATE1		=	Trim(NumberFormat(RATE1,"99999999." & DecimalVal))>
			<CFSET	BRK1		=	Trim(NumberFormat(BRK1,"99999999.99"))>
			<CFSET	NetRATE1	=	Trim(NumberFormat(NetRATE1,"99999999." & DecimalVal))>
			 
			<CFSET	TOTBrk	=	Trim(NumberFormat(QTY * BRK1,"99999999.99"))>
			<CFSET	AMT		=	Trim(NumberFormat(QTY * NetRATE1,"99999999.99"))>
			--->
			
			<CFIF	BUY_SALE EQ "BUY">
				<CFIF	APPLY_STT>
					<CFSET	STT	=	((QTY * RATE1 * BSTT) / 100)>
				<CFELSE>
					<CFSET	STT	=	0>
				</CFIF>
								<CFSET	STT	=	trim(STT)>

				<CFSET	AMT1		=	Trim((AMT + NumberFormat(STT, "99999999")))>
			<CFELSE>
				<CFIF	APPLY_STT>
					<CFSET	STT	=	((QTY * RATE1 * SSTT) / 100)>
				<CFELSE>
					<CFSET	STT	=	0>
				</CFIF>
								<CFSET	STT	=	trim(STT)>

				<CFSET	AMT1		=	Trim((AMT - NumberFormat(STT, "99999999")))>
			</CFIF>
			
			<cfif Buy_Sale eq 'Buy'>
				<Cfset AMT1 = AMT1 + Exp1>
			<cfelse>	
				<Cfset AMT1 = AMT1-Exp1>
			</cfif>
			<CFSET	STT			=	Trim(NumberFormat(STT, "99999999"))>
			<CFSET  AMOUNT1		=	NumberFormat(AMT1,"99999999999.99")>

	<!------------------------------------------------->
	
		<CFIF Len(Trim(CLIENT_NAME)) GT 0>
			<CFSET CName = "#CLIENT_ID#-#Left(Client_Name,15)#">
			<CFSET BoldType = "Normal">
		<CFELSE>
			<CFSET CName = "#CLIENT_ID#(** UNREGISTERED **)">
			<CFSET BoldType = "Normal">
		</CFIF>
		<CFSET Sr			=	IncrementValue(Sr)>
	
		<CFSET backcolor = "LightGoldenrodYellow">
		
		<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="center" class="StyleReportParameterTable1">
			<TR STYLE=" background:#backcolor#; font-weight:#BoldType#; color:#iif(Left(Buy_Sale,1) EQ 'B',DE("Blue"),DE("Red"))#">
				<TD align="right" width="3%"> #Sr#&nbsp; </TD>
				<TD align="Left" width="10%"> #Trim(left(Client,20))#&nbsp; </TD>
				<TD align="Left" width="6%">#Left(Scrip_Symbol,8)#</TD>
				<TD align="CENTER" width="2%">&nbsp;#Left(Buy_Sale,1)# </TD>
				<TD align="right" width="5%"> #Quantity# </TD>
				<TD align="right" width="6%"> #Rate1# </TD>
				<TD align="right" width="6%"> #TotBrk# </TD>
				<TD align="right" width="6%"> #Exp1# </TD>
				<TD align="right" width="9%"> #Trim(Amount1)# </TD>
				<TD align="right" width="5%"> 
					<SELECT name="Option1#Sr#" style="font:'Times New Roman', Times, serif; font-size:10px;">
						<OPTION value="B" title="Bank Delivery">Bank</OPTION>
						<OPTION value="H" title="Hand Delivery">Hand</OPTION>
					</SELECT>
				</TD>
				
				<TD align="center" width="5%">
					<SELECT name="Option2#Sr#" style="font:'Times New Roman', Times, serif; font-size:10px;">
						<OPTION value="1" title="Bank Delivery">Block</OPTION>
						<OPTION value="0" title="Hand Delivery">Oth.</OPTION>
					</SELECT>
				</TD>
				<TD align="center" width="5%">
					<INPUT type="text" name="CustPartId#Sr#" value="#CustPartCode#" size="5" maxlength="30" CLASS="StyleTextBox">
				</TD>
				<TD align="center" width="8%">
					<INPUT type="text" name="CustodianId#Sr#" value="#Custodian_ID1#" size="10" maxlength="30" CLASS="StyleTextBox" onBlur="CallEnable(ScrOrd,this.value,#Sr#);">
				</TD>

				<TD align="center" width="2%">
					<INPUT type="checkbox" name="GenerateChb#Sr#" value="Yes">
				</TD>
				
				<CFIF Custodian_ID1 eq "" Or CustPartCode eq "">
					<SCRIPT>
						ScrOrd.GenerateChb#Sr#.disabled = true;						
					</SCRIPT>			
				</CFIF>
				<!--- <td align="right" width="15%"> 
					<CFINPUT TYPE="TEXT" NAME="ClientID2#Sr#" VALUE="" CLASS="StyleTextBox" MAXLENGTH="20" SIZE="10">
				</td> --->
			</TR>
		</TABLE>
		
		<INPUT type="Hidden" name="ClientID#Sr#" value="#CLIENT_ID#">
		<INPUT type="Hidden" name="Scrip#Sr#" value="#Scrip_Symbol#">
		<INPUT type="Hidden" name="Buy_Sale#Sr#" value="#Buy_Sale#">
		<INPUT type="Hidden" name="Quantity#Sr#" value="#Quantity#">
		<INPUT type="Hidden" name="Amount#Sr#" value="#Trim(Amount1)#">
		<INPUT type="hidden" name="Contract#Sr#" value="#Contract_No#">
		
	</CFLOOP>
	<INPUT type="Hidden" name="Sr" value="#Sr#">	
</DIV>

<DIV align="right" style="top:94%;position:absolute;">
	<TABLE align="right" width="100%" border="0">
		<TR>
			<TD colspan="4" align="right">
				<INPUT TYPE="Submit" NAME="Print" VALUE="Print" CLASS="StyleTextBox">
				&nbsp;
				<INPUT TYPE="Submit" NAME="Generate" VALUE="Generate" CLASS="StyleTextBox">
			</TD>
		</TR>
	</TABLE>
</DIV>
</CFFORM>
</CFOUTPUT>
</BODY>
</HTML>