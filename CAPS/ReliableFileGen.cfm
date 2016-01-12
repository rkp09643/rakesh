<!---- **************************************************************
	BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*************************************************************** ---->

<cfinclude template="/focaps/help.cfm">
<HTML>
<HEAD>
	<TITLE> Reliable File Generation </TITLE>
	<LINK href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<LINK href="/FOCAPS/CSS/style1.css" type="text/css" rel="stylesheet">
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
			Top				:	16px;
			Width			:	100%;
			Height			:	89%;
			Overflow		:	Auto;
			Background		:	FFEEEE;
		}

		DIV#Tablefoot
		{
			Position		:	Absolute;
			Top				:	94%;
			Width			:	100%;
			Height			:	6%;
			Overflow		:	Auto;
			
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
		
	</SCRIPT>
    <LINK HREF="../../CSS/style1.css" REL="stylesheet" TYPE="text/css">

</HEAD>

 <BODY leftmargin="0" rightmargin="0" onFocus="CloseWindow();"> 

<CFOUTPUT>
<CFFORM name="ReliableFile" action="ReliableFileGen.cfm">
				
	<CFIF IsDefined("FileGenerate")>
		<CFOUTPUT>
			<CFIF not IsDefined("TOKEN")>
					<CFSET TOKEN ="#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
			</CFIF>

			<CFSTOREDPROC procedure="RELIABLEFILE_PROC_FINAL" datasource="#Client.database#">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COCD" 				value="#COCD#" 			null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_int" 		dbvarname="@STARTYEAR" 			value="#FinStart#" 		null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FROM_DATE" 			value="#txtDate#" 		null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@BRANCHID" 			value="#txtBranch#" 	null="NO">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FAMILYGROUP"		value="#txtFamily#" 	null="NO">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CLIENT_ID" 			value="#txtClientID#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CLIENTTYPE" 		value="M" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@DATAVIEW" 			value="1" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COLLETRALDETAIL" 	value="Y" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CASHDETAILS" 		value="#RdoCashReqd#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FDDETAILS" 			value="#RdoFDReqd#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CPCODE" 			value="#txtCpCode#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@PARAMETER" 			value="COLLATRAL" 		null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COLLATRALDEF" 		value="#cmbColleteralType#" null="NO">  
				<CFPROCRESULT  NAME="SubCollat" resultset="4">
			</CFSTOREDPROC>

			<CFIF SubCollat.RecordCount EQ 0 or SubCollat.CPCode eq "XYZ">
				<SCRIPT>
					alert("No Data Found For COLLATRAL File");
				</SCRIPT>		
			<CFELSE>
				<CFSET	FileName	=	"COLLATARAL_#TOKEN#.CSV">
				<CFSET	FILE_DATA	=	"">
				<CFSET	CPCode 		= 	"CPCode" >
				<CFSET	AccountCode	=	"AccountCode">	
				<CFSET	TraderType	=	"TraderType">
				<CFSET	Cash		=	"Cash">
				<CFSET	FD			=	"FD">
				<CFSET	FILE_DATA	=	"#FILE_DATA#AccountCode,#CPCode#,Account Name,Amount,Collatral"> 
				<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes">
				<CFSET	FILE_DATA	=	"">
				<CFLOOP QUERY="SubCollat">
					<CFSET	CPCode 		= 	"#CPCode#" >
					<CFSET	AccountCode	=	"#AccountCode#">	
					<CFSET	TraderType	=	"#TraderType#">
					<CFSET	Deposite	=	"#balance#">
					<CFSET	Cash		=	"#Cash#">
					<CFSET	FD			=	"#FD#">
					<CFSET	FILE_DATA	=	"#FILE_DATA##AccountCode#,#CPCode#,#Accountname#,#Deposite#,#COLLATRAL##chr(10)#"> 
				</CFLOOP>
					<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes"> 


				<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">
				<CFSET	ClientFileGenerated	=	CopyFile_UNIX("C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#","C:\Reports\#FileName#")>
					<CFSET	FILE_DATA	=	"">

				<SCRIPT>
						alert("File Generated in C:\\CFUSIONMX7\\WWWROOT\\REPORTS\\COLLATARAL.CSV");
				</SCRIPT>		
				<CFIF ClientFileGenerated>
					<SCRIPT>
						alert("File Generated On your C:\\Reports\\#FileName#");
					</SCRIPT>
				</CFIF>
			</CFIF>	
		</CFOUTPUT>	
		
<!--- 		<cfabort><CFOUTPUT>
			<CFIF not IsDefined("TOKEN")>
					<CFSET TOKEN ="#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
			</CFIF>

			<CFSTOREDPROC procedure="RELIABLEFILE_PROC" datasource="#Client.database#">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COCD" 				value="#COCD#" 			null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_int" 		dbvarname="@STARTYEAR" 			value="#FinStart#" 		null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FROM_DATE" 			value="#txtDate#" 		null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@BRANCHID" 			value="#txtBranch#" 	null="NO">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FAMILYGROUP"		value="#txtFamily#" 	null="NO">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CLIENT_ID" 			value="#txtClientID#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CLIENTTYPE" 		value="M" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@DATAVIEW" 			value="1" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COLLETRALDETAIL" 	value="Y" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CASHDETAILS" 		value="#RdoCashReqd#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FDDETAILS" 			value="#RdoFDReqd#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CPCODE" 			value="#txtCpCode#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@PARAMETER" 			value="LEDGER" 			null="NO">  

				<CFPROCRESULT  NAME="SubLedger" resultset="1">
			</CFSTOREDPROC>

			<CFIF SubLedger.RecordCount EQ 0 or SubLedger.CPCode EQ "XYZ">
				<SCRIPT>
					alert("No Data Found for LEDGER File");
				</SCRIPT>		
			<CFELSE>
				<CFSET	FileName	=	"LEDGER.CSV">
				<CFSET	FILE_DATA	=	"">
					
				<CFSET	CPCode 		= 	"CPCode" >
				<CFSET	AccountCode =	"AccountCode">	
				<CFSET	TraderType	=	"TraderType">
				<CFSET	Balance		=	"Balance">
				<CFSET	FILE_DATA	=	"#FILE_DATA##CPCode#,#AccountCode#,#TraderType#,#Balance#"> 
				<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes">
				<CFSET	FILE_DATA	=	"">

				<CFLOOP QUERY="SubLedger">
					<CFSET	CPCode 		= 	"#CPCode#" >
					<CFSET	AccountCode	=	"#AccountCode#">	
					<CFSET	TraderType	=	"#TraderType#">
					<CFSET	Balance		=	"#Balance#">
					<CFSET	FILE_DATA	=	"#FILE_DATA##CPCode#,#AccountCode#,#TraderType#,#Balance#"> 
	
					<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes"> 
					<CFSET	FILE_DATA	=	"">
				</CFLOOP>
					<SCRIPT>
						alert("File Generated in c:\\CFUSIONMX7\\WWWROOT\\REPORTS\\LEDGER.CSV");
					</SCRIPT>		
			</CFIF>	
		</CFOUTPUT>	


		<CFOUTPUT>
			<CFIF not IsDefined("TOKEN")>
					<CFSET TOKEN ="#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
			</CFIF>

			<CFSTOREDPROC procedure="RELIABLEFILE_PROC" datasource="#Client.database#">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COCD" 				value="#COCD#" 			null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_int" 		dbvarname="@STARTYEAR" 			value="#FinStart#" 		null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FROM_DATE" 			value="#txtDate#" 		null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@BRANCHID" 			value="#txtBranch#" 	null="NO">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FAMILYGROUP"		value="#txtFamily#" 	null="NO">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CLIENT_ID" 			value="#txtClientID#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CLIENTTYPE" 		value="M" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@DATAVIEW" 			value="1" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COLLETRALDETAIL" 	value="Y" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CASHDETAILS" 		value="#RdoCashReqd#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FDDETAILS" 			value="#RdoFDReqd#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CPCODE" 			value="#txtCpCode#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@PARAMETER" 			value="CASHHOLDING" 	null="NO">  

				<CFPROCRESULT  NAME="CASHHOLDING" resultset="1">
			</CFSTOREDPROC>

			<CFIF CASHHOLDING.RecordCount EQ 0 or CASHHOLDING.CPCode EQ "XYZ">
				<SCRIPT>
					alert("No Data Found for CASHHOLDING file");
				</SCRIPT>		
			<CFELSE>
				<CFSET	FileName	=	"CASHHOLDING.CSV">
				<CFSET	FILE_DATA	=	"">

				<CFSET	TraderType	=	"Trader Type">	
				<CFSET	CPCode	 	= 	"CPCode" >
				<CFSET	AccountCode	=	"Accountcode">	
				<CFSET	Exch		=	"Exch">	
				<CFSET	Symbol		=	"Symbol">
				<CFSET	Series		=	"Series">
				<CFSET	Netqty		=	"Netqty">
				<CFSET	NetValue	=	"NetValue">

				<CFSET	FILE_DATA	=	"#FILE_DATA##TraderType#,#CPCode#,#AccountCode#,#Exch#,#Symbol#,#Series#,#Netqty#,#NetValue#"> 
				<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes">
				<CFSET	FILE_DATA	=	"">

				<CFLOOP QUERY="CASHHOLDING">
					<CFSET	TraderType	=	"#TraderType#">	
					<CFSET	CPCode	 	= 	"#CPCode#" >
					<CFSET	AccountCode	=	"#Client_ID#">	
					<CFSET	Exch		=	"BSE">	
					<CFSET	Symbol		=	"#Scrip_Symbol#">
					<CFSET	Series		=	"EQ">
					<CFSET	Netqty		=	"#NETQTY#">
					<CFSET	NetValue	=	"#BENAMT#">
					<CFSET	FILE_DATA	=	"#FILE_DATA##TraderType#,#CPCode#,#AccountCode#,#Exch#,#Symbol#,#Series#,#Netqty#,#NetValue#"> 
	
					<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes"> 
					<CFSET	FILE_DATA	=	"">
				</CFLOOP>
					<SCRIPT>
						alert("File Generated in c:\\CFUSIONMX7\\WWWROOT\\REPORTS\\CASHHOLDING.CSV");
					</SCRIPT>		
			</CFIF>	
		</CFOUTPUT>	


		<CFOUTPUT>
			<CFIF not IsDefined("TOKEN")>
					<CFSET TOKEN ="#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
			</CFIF>

			<CFSTOREDPROC procedure="RELIABLEFILE_PROC" datasource="#Client.database#">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COCD" 				value="#COCD#" 			null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_int" 		dbvarname="@STARTYEAR" 			value="#FinStart#" 		null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FROM_DATE" 			value="#txtDate#" 		null="no">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@BRANCHID" 			value="#txtBranch#" 	null="NO">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FAMILYGROUP"		value="#txtFamily#" 	null="NO">
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CLIENT_ID" 			value="#txtClientID#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CLIENTTYPE" 		value="M" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@DATAVIEW" 			value="1" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@COLLETRALDETAIL" 	value="Y" 				null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CASHDETAILS" 		value="#RdoCashReqd#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@FDDETAILS" 			value="#RdoFDReqd#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@CPCODE" 			value="#txtCpCode#" 	null="NO">  
				<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" 	dbvarname="@PARAMETER" 			value="CLIENTMASTER" 	null="NO">  

				<CFPROCRESULT  NAME="CLIENTMASTER" resultset="1">
			</CFSTOREDPROC>

			<CFIF CLIENTMASTER.RecordCount EQ 0 or CLIENTMASTER.CPCode eq "XYZ">
				<SCRIPT>
					alert("No Data Found for CLIENTMASTER File");
				</SCRIPT>		
			<CFELSE>
				<CFSET	FileName	=	"RISKCLIENTMASTER.CSV">
				<CFSET	FILE_DATA	=	"">

				<CFSET	AccountCode	=	"Accountcode">
				<CFSET	CPCode	 	= 	"CPCode" >
				<CFSET	TraderType	=	"Trader Type">	
				<CFSET	AccountName	=	"Accountname">	
				<CFSET	BranchCode	=	"branchcode">	
				<CFSET	FamilyName	=	"familyname">	

				<CFSET	FILE_DATA	=	"#FILE_DATA##AccountCode#,#CPCode#,#TraderType#,#AccountName#,#BranchCode#,#FamilyName#"> 
				<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes">
				<CFSET	FILE_DATA	=	"">

				<CFLOOP QUERY="CLIENTMASTER">
					<CFSET	AccountCode	=	"#CLIENT_ID#">
					<CFSET	CPCode	 	= 	"#CPCode#">
					<CFSET	TraderType	=	"#TraderType#">	
					<CFSET	AccountName	=	"#CLIENT_NAME#">	
					<CFSET	BranchCode	=	"#BRANCH_CODE#">	
					<CFSET	FamilyName	=	"#GROUPNAME#">	
					<CFSET	FILE_DATA	=	"#FILE_DATA##AccountCode#,#CPCode#,#TraderType#,#AccountName#,#BranchCode#,#FamilyName#"> 
	
					<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes"> 
					<CFSET	FILE_DATA	=	"">
				</CFLOOP>
					<SCRIPT>
						alert("File Generated in c:\\CFUSIONMX7\\WWWROOT\\REPORTS\\RISKCLIENTMASTER.CSV");
					</SCRIPT>		
			</CFIF>	
		</CFOUTPUT>	 --->

	</CFIF>


<INPUT type="Hidden" name="COCD" 		value="#Trim(COCD)#">
<INPUT type="Hidden" name="FinStart" 	value="#FinStart#">

	<TABLE WIDTH="100%" border="0" cellpadding="0" cellspacing="0" class="StyleReportParameterTable1" STYLE="background-color:PINK">
	    <TR>
			<TH ALIGN="left" WIDTH="6%">Date :</TH>			
			 
		 	<TD ALIGN="left" WIDTH="10%" >
 				<CFINPUT TYPE="text" NAME="txtDate" VALIDATE="EURODATE" MESSAGE="Please enter Proper Date." VALUE="#DateFormat(now(),"DD/MM/YYYY")#" MAXLENGTH="10" SIZE="10" class="StyleTextBox">
		 	</TD>

			<CFSET Help="Select Branch_code,Branch_Name From Branch_Master" >
			<TH ALIGN="left" WIDTH="8%">Branch:</TH>			
			<TD ALIGN="left" WIDTH="14%" >
				<INPUT TYPE="text" NAME="txtBranch" CLASS="StyleTextBox" cols="10" SIZE="12">
					<INPUT TYPE="Button" NAME="cmdBranchHelp" VALUE=" ? " CLASS="StyleSmallButton1" style="Cursor : Help;" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtBranch&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
			</TD>
			
			 <CFSET Help="Select Groupcode,GroupName From FA_GROUPMASTER" >
			<TH ALIGN="left" WIDTH="8%">Family:</TH>			
			<TD ALIGN="left" WIDTH="14%" >
					<INPUT TYPE="text" NAME="txtFamily" CLASS="StyleTextBox" cols="10" SIZE="12">
					<INPUT TYPE="Button" NAME="cmdFamilyHelp" VALUE=" ? " CLASS="StyleSmallButton1" style="Cursor : Help;" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtFamily&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
			</TD>	

			<CFSET Help="Select Distinct client_id,client_name,introducer_code from client_master" >
			<TH ALIGN="left" WIDTH="8%">Client:</TH>			
			<TD ALIGN="left" WIDTH="14%" >
				<INPUT TYPE="text" NAME="txtClientID" CLASS="StyleTextBox" cols="10" SIZE="12">
				<INPUT TYPE="Button" NAME="cmdClientHelp" VALUE=" ? " CLASS="StyleSmallButton1" style="Cursor : Help;" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=txtClientID&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
			</TD>

			<TH ALIGN="left" WIDTH="8%">Cp Code:</TH>			
			<TD ALIGN="left" WIDTH="16%" >
				<INPUT TYPE="TEXT" NAME="txtCpCode" VALUE=" " SIZE="5" MAXLENGTH="5" class="StyleTextBox"> 
			</TD>	
		</TR>

		<TR>  
			<TH ALIGN="right" COLSPAN="1" WIDTH="10%">&nbsp;Cash Reqd In Collatral&nbsp;:</TH>
			<TD ALIGN="left"  COLSPAN="1" WIDTH="12%">
				<INPUT TYPE="radio"  CLASS="bold" name="RdoCashReqd" value="Y" STYLE="Border: 0pt Solid Black;" CHECKED   > Yes
				<INPUT TYPE="radio"  CLASS="bold" name="RdoCashReqd" value="N" STYLE="Border: 0pt Solid Black;"    >  No
			</TD>


			<TH ALIGN="right" COLSPAN="2" WIDTH="10%">&nbsp;Consider Colletral&nbsp;:</TH>
			<TD ALIGN="left"  COLSPAN="2" WIDTH="12%">
				<SELECT  Class="StyleRadioLabelBlack"NAME="cmbColleteralType" style="font:'Times New Roman', Times, serif; font-size:10px; width:88%">
				<OPTION VALUE="F">Full(With Haircut)			</OPTION>
				<OPTION VALUE="C">Consider Ledger				</OPTION>
				<OPTION VALUE="L">Consider Last Debit Margin	</OPTION>
			</TD>

			<TH ALIGN="right" COLSPAN="2" WIDTH="10%">&nbsp;FD Reqd In Collatral&nbsp;:</TH>
			<TD ALIGN="left"  COLSPAN="2" WIDTH="12%">
				<INPUT TYPE="radio"  CLASS="bold" name="RdoFDReqd" value="Y" STYLE="Border: 0pt Solid Black;" CHECKED   > Yes
				<INPUT TYPE="radio"  CLASS="bold" name="RdoFDReqd" value="N" STYLE="Border: 0pt Solid Black;"    >  No
			</TD>

		</TR>
		</TABLE>
		
		<DIV align="center" id="Tablefoot">
			<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center" color="NAVY" class="StyleReportParameterTable1">
				<input type="submit" name="FileGenerate" class="StyleButton" value="Generate Reliable Files">
			</TABLE>
		</DIV> 
</CFFORM>

</CFOUTPUT>
</BODY>
</HTML>