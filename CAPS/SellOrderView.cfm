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
	Top				:	18px;
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
		DIV#TableSclo
		{
			Position		:	Absolute;
			Top				:	50%;
			Width			:	100%;
			Height			:	50%;
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

<!--- <CFQUERY NAME="GetClCode" datasource="#Client.database#">
	Select	Clearing_Member_Code,Exchange_Clearing_Code
	From
			System_Settings
	Where
			Company_Code	=	'#txtCOCD#'
</CFQUERY>

<CFSET	ClearingMemberCode	=	GetClCode.Clearing_Member_Code> --->
<CFPARAM NAME="txtOrderDate" 	DEFAULT="">
<CFPARAM NAME="invalidClient" 	DEFAULT="No">
<!--- <CFPARAM NAME="FrstRow" 		DEFAULT="Yes"> --->
<CFPARAM NAME="ClientCode" 		DEFAULT="">
<CFPARAM NAME="ScriptName" 		DEFAULT="">
<CFPARAM NAME="TotBalance" 		DEFAULT="999999999.99">
<CFPARAM NAME="Totamt" 			DEFAULT="999999999.99">
<CFPARAM NAME="Sellamt" 		DEFAULT="999999999.99">
<CFPARAM NAME="TotPer" 			DEFAULT="999999999.99">

<CFFORM NAME="ScrOrd" ACTION="SellOrderView.cfm" METHOD="POST">

	<cfif IsDefined("FileGenerat")>
		<cfoutput>
			<cfif left(#txtdate#,1) eq ','>
				<cfset 	#txtdate#= mid(#txtdate#,2,11)>
			</cfif>

			<Cfif not IsDefined("tOKEN")>
					<CFSET tOKEN ="#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
			</cfif>
		<!--- If No Client Is Selected Display Message--->
			<CFIF #LEN(ClientCode)# EQ 0> 
				<SCRIPT>
					alert("No Data To Generate");
				</SCRIPT>		
				<cfabort>
			</CFIF>	
				<cftry>
					<cfquery datasource="#Client.database#" name="">
						DROP TABLE ####TEMPSELLBEN
					</cfquery>
				<cfcatch>
				</cfcatch>	
				</cftry>
				<cftry>
					<cfquery datasource="#Client.database#" name="">
						CREATE TABLE ####TEMPSELLBEN
						(
							CLCODE VARCHAR(100)
						)
					</cfquery>
				<cfcatch>
				</cfcatch>	
				</cftry>
				<cfloop index="I" list="#ClientCode#" delimiters=",">
					<cfquery datasource="#Client.database#" name="">
						INSERT INTO ####TEMPSELLBEN
						VALUES('#I#')
					</cfquery>
				</cfloop>
				<CFSTOREDPROC procedure="SELLBEN_REPORT_AGEING" datasource="#Client.database#">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@START_YEAR" 		value="#FinStart#" 		null="no">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@TDATE" 			value="#txtDate#" 		null="no">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@COMPANY_CODE" 	value="#txtCOCD#" 		null="no">
 					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@BRANCH_CODE" 		value="#txtBranch#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@FAMILY_GROUP_LIST" value="#txtFamily#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@LEDGER_LIST" 		value="" 	null="NO">  
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@TOKENNO" 			value="#TOKEN#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@DAY" 				value="#Val(txtAgeingDays)#" null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@AMOUNT" 			value="#Val(txtAmount)#" null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@LEDGERPER" 		value="#txtPer#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@BENLIST" 			value="#txtBen#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@ANUTOCREDIT" 		value="#RdoUNCCredit#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@ACCESSFUTURECASH" value="#RDOFAC#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@POASTOCK" 		value="#RDOPOA#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@AMOUNT1" 		value="#Val(txtAmount1)#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@STORETABLE" 		value="Y" 		null="NO">
					<CFPROCRESULT  NAME="SubMain" resultset="4">
				</CFSTOREDPROC>
			<CFSET VarFileVal = "">
			<CFSET I = 0>
			<CFSET J = 1>
			<CFSET K = 0>
			<CFSET L = 1>
			<CFSET M = 1>
			<CFSET	FILE_DATA	=	"">
			<CFSET	CLRATE 		= 	"">

			<CFSET	FileName	=	"SELLBEN#J#.dot">

			<CFIF SubMain.RecordCount EQ 0>
				<SCRIPT>
					alert("No Data Found");
				</SCRIPT>		
				<cfabort>
			</CFIF>	

			<CFIF SubMain.RecordCount GT 0>
				<CFLOOP QUERY="SubMain">
					<CFIF SELL EQ "Y">
						<CFIF ISNUMERIC(#SCRIPCODE#)>
							<CFSET 	I = I + 1>
							<cfif J EQ 1>
								<cfset	FileName	=	"SELLBENBSE#J#.dot">
							</CFIF>
									
							<CFSET	CLRATE 		= 	VAL(#CLOSINGRATE#)* 100 >
							<CFSET	QTY			=	"#TOSTRING(QTY)#">	
							<CFSET	MINQTY		=	"#TOSTRING(QTY)#">
							<CFSET	SCRIPCODE	=	"#TOSTRING(SCRIPCODE)#">
							<CFSET	RATE		=	"#TOSTRING(CLRATE)#">
							<CFSET	CLCODE		=	"#ACCOUNTCODE#">
	<!--- 						<CFSET	EOS			=	"EOSESS"> --->
							<CFSET	EOS			=	"EOTODY">
							<CFSET	CLICODE		=	"CLIENT">
							<CFSET	LAST		=	"L">
	<!--- 						<CFSET  ERRCODE		= 	"$"> --->
	<!--- 						<cfset	FILE_DATA	=	"#FILE_DATA#S|#QTY#|#MINQTY#|#SCRIPCODE#|#RATE#|#CLCODE#|#EOS#|#CLICODE#|#LAST#|#ERRCODE#|"> --->
 							<cfset	FILE_DATA	=	"#FILE_DATA#S|#QTY#|#MINQTY#|#SCRIPCODE#|#RATE#|#CLCODE#|#EOS#|#CLICODE#|#LAST#|"> 
	
							<CFIF I EQ 1>
								<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes">
							<CFELSE>
								<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes"> 
							</CFIF>
	
							<CFIF I EQ 450>
								<CFSET 	J = J + 1>
								<cfset	FileName	=	"SELLBENBSE#J#.dot">
								<CFSET I = 0>
							</CFIF>	
	
							<CFSET	FILE_DATA		=	"">
	
						<CFELSE>
						<CFIF UCASE(#SCRIPCODE#) EQ "NULL" OR UCASE(#SCRIPCODE#) EQ ''>
						<CFELSE>
						<CFIF NOT ISNUMERIC(#SCRIPCODE#)>
							<CFSET 	K = K + 1>
	
							<CFIF L EQ 1>
								<CFSET	FileName	=	"SELLBENNSE#L#.dot">
							</CFIF>	
	
								<CFSET	BT 			= 	"1 ">
								<CFSET	BS 			= 	"2 ">
								<CFSET	SCRIP		= 	TRIM(#SCRIPCODE#)&RepeatString(" ",10-LEN(TRIM(LEFT(#SCRIPCODE#,10))))>
								<CFSET	SERIES		=	"EQ">	
								<CFSET	INS			=	"1 ">	
								<CFSET 	GTD			= 	RepeatString(" ",11)>
								<CFSET 	ST			= 	RepeatString(" ",2)>
								<CFSET 	MFQTY		= 	RepeatString(" ",9)>
<!---								<CFSET	RATE		=	NumberFormat(VAL(#CLOSINGRATE#),"999999.00")>
 								<CFSET	RATE1		=	#TRIM(TOSTRING(RATE))#>--->
 								<CFSET	RATE		=	#TRIM(TOSTRING(CLOSINGRATE))#&RepeatString(" ",9-len(TOSTRING(#CLOSINGRATE#)))>
 								<CFSET	CLCODE		= 	TRIM(#ACCOUNTCODE#)&RepeatString(" ",10-LEN(TRIM(LEFT(#ACCOUNTCODE#,10))))>
								<CFSET 	TRGPR		= 	RepeatString(" ",9)>
								<CFSET	QUANTITY	=	"#RIGHT(TOSTRING(QTY),9)#">
								<CFSET	DQ			=	RepeatString(" ",9)>
								<CFSET	PARTCODE	=	RepeatString(" ",12)>
								<CFSET	CL			=	"2 ">
								<CFSET  REMARK		= 	RepeatString(" ",25)>
								<CFSET  ORDNO		= 	RepeatString(" ",16)>
<!--- 								<CFSET  ERRCODE		= 	"$         "> --->
								<CFSET  ERRCODE		= 	RepeatString(" ",11)>
							<CFIF #QUANTITY# NEQ "">
								<CFSET	QUANTITY 	=	"#TOSTRING(QUANTITY)#"&RepeatString(" ", 9-LEN(#QUANTITY#))>
							</CFIF>	
								<CFSET K1			= 	TOSTRING(K)&RepeatString(" ", 13-LEN(#K#))>
<!--- 							<CFSET	FILE_DATA	=	"#FILE_DATA##K#|#BT#|#BS#|#SCRIP#|#SERIES#|#INS#|#GTD#|#ST#|#MFQTY#|#RATE#|#TRGPR#|#QUANTITY#|#DQ#|#PARTCODE#|#CL#|#CLCODE#|#REMARK#|#ORDNO#|#ERRCODE#|">
 --->							<CFSET	FILE_DATA	=	"#FILE_DATA##K1#,#BT#,#BS#,#SCRIP#,#SERIES#,#INS#,#GTD#,#ST#,#MFQTY#,#RATE#,#TRGPR#,#QUANTITY#,#QUANTITY#,#PARTCODE#,#CL#,#CLCODE#,#REMARK#,#ORDNO#,#ERRCODE#">
	
							<CFIF K EQ 1>
								<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes">
							<CFELSE>
								<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes"> 
							</CFIF>
	
							<CFIF K EQ 450>
								<CFSET L = L + 1>
								<CFSET FileName	= "SELLBENNSE#L#.dot">
								<CFSET K = 0>
							</CFIF>	
							<CFSET	FILE_DATA	=	"">
						</CFIF>
						</CFIF>	
						</CFIF>	
					</CFIF>		
 				</CFLOOP>
			</CFIF>	
		</cfoutput>
		
 	<SCRIPT>
		alert("Files are generated in C:\\CFUSIONMX7\\WWWROOT\\SELBEN*.DOT");
	</SCRIPT>		
</CFIF>	
	
 	<CFIF NOT IsDefined("FileGenerat")> 
		<cfoutput>
			<CFIF not IsDefined("tOKEN")>
				<CFSET tOKEN ="#Dateformat(now(),'ddmmyyyy')##timeformat(now(),'hhmmss')##VAL(client.CFID)##VAL(client.CFToken)#">
			</CFIF>
		
			<CFIF IsDefined("txtAmount") and IsDefined("RdoUNCCredit")>
				<cfparam default="" name="FinStart">
				<cfparam default="" name="txtDate">
				<cfparam default="" name="txtCOCD">
				<cfparam default="" name="txtBranch">
				<cfparam default="" name="txtFamily">
				<cfparam default="" name="txtClientID">
				<cfparam default="" name="UserId">
				<cfparam default="" name="txtAgeingDays">
				<cfparam default="" name="txtAmount">
				<cfparam default="" name="txtPer">
				<cfparam default="" name="txtBen">
				<cfparam default="" name="RdoUNCCredit">
				<cfparam default="" name="RDOFAC">
				<cfparam default="" name="RDOPOA">
				
			  	<INPUT type="Hidden" name="FinStart" 	value="#FinStart#">				
			 	<INPUT type="Hidden" name="txtDate" 	value="#txtDate#">
				<INPUT type="Hidden" name="txtCOCD" 	value="#Trim(txtCOCD)#">
				<INPUT TYPE="Hidden" NAME="txtBranch" 	VALUE="#txtBranch#">
				<INPUT TYPE="Hidden" NAME="txtFamily" 	VALUE="#txtFamily#">
				<INPUT TYPE="Hidden" NAME="txtClientID" VALUE="#txtClientID#">	
				<INPUT TYPE="HIDDEN" NAME="UserId" 		VALUE="#UserId#">
			 	<input type="hidden" name="txtAgeingDays" value="#txtAgeingDays#">
				<input type="hidden" name="txtAmount" 	value="#txtAmount#">
				<input type="hidden" name="txtPer" 		value="#txtPer#">
				<input type="hidden" name="txtBen" 		value="#txtBen#">
				<input type="hidden" name="RdoUNCCredit" value="#RdoUNCCredit#">
				<input type="hidden" name="RDOFAC" 		value="#RDOFAC#">
				<input type="hidden" name="RDOPOA" 		value="#RDOPOA#">
				<input type="hidden" name="txtAmount1" 		value="#txtAmount1#">
				
				
				<cfif left(#txtdate#,1) eq ','>
					<cfset 	#txtdate#= mid(#txtdate#,2,11)>
				</cfif>

				<CFSTOREDPROC procedure="SELLBEN_REPORT_AGEING" datasource="#Client.database#">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@START_YEAR" 		value="#FinStart#" 		null="no">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@TDATE" 			value="#txtDate#" 		null="no">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@COMPANY_CODE" 	value="#txtCOCD#" 		null="no">
 					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@BRANCH_CODE" 		value="#txtBranch#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@FAMILY_GROUP_LIST" value="#txtFamily#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@LEDGER_LIST" 		value="#txtClientID#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@TOKENNO" 			value="#TOKEN#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@DAY" 				value="#Val(txtAgeingDays)#" null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@AMOUNT" 			value="#Val(txtAmount)#" null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@LEDGERPER" 		value="#txtPer#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@BENLIST" 			value="#txtBen#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@ANUTOCREDIT" 		value="#RdoUNCCredit#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@ACCESSFUTURECASH" value="#RDOFAC#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@POASTOCK" 		value="#RDOPOA#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@AMOUNT1" 		value="#Val(txtAmount1)#" 		null="NO">
					<CFPROCRESULT  NAME="Main" resultset="4">
				</CFSTOREDPROC>
				
					<CFIF Main.RecordCount EQ 0>
						<SCRIPT>
							alert("No Data Found");
						</SCRIPT>		
					</CFIF>	
			</CFIF>
		</CFOUTPUT>

		<DIV align="left" id="TableHeader">
			<TABLE width="100%"  border="1" cellspacing="1" cellpadding="1" align="left" class="StyleReportParameterTable1" style="Color : Green;" >
				<TR>
					<TH align="left" width="10%" title="">Code&nbsp;</TH>
					<TH align="left" width="15%" title="">Scrip Name&nbsp;</TH>
					<TH align="left" width="10%" title="">Isin&nbsp;</TH>
					<TH align="left" width="8%"  title="">Setl&nbsp;</TH>
					<TH align="right" width="9%" title="">Balance&nbsp;</TH>
					<TH align="right" width="9%" title="">Qty&nbsp;</TH>
					<TH align="right" width="9%" title="">Rate&nbsp;</TH>
					<TH align="right" width="9%" title="">Amount&nbsp;</TH>
					<TH align="right" width="4%" title="">Sell&nbsp;</TH>
					<TH align="left" width="9%"  title="">Sell Amt&nbsp;</TH>
					<TH align="right" width="4%" title="">%&nbsp;</TH>
				</TR>
			</TABLE>
		</DIV>

		<DIV align="center" id="Tablefoot">
			<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center" color="NAVY" class="StyleReportParameterTable1">
				<input type="submit" name="FileGenerat" class="StyleButton" value="Generat File">
			</TABLE>
		</DIV> 

		<DIV align="center" id="TableData">
		<CFSET Sr				=	0>
		<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1">
			<CFIF IsDefined("txtAmount") and IsDefined("RdoUNCCredit")>
				<CFOUTPUT query="Main" group="ACCOUNTCODE">
					 <TR  STYLE="background-color:white;color:NAVY">
						<TH align="left" width="5%" title=""><input type="checkbox" name="ClientCode" value="#ACCOUNTCODE#" checked>  </TH> 
						<TH align="left" width="35%" title="" colspan="3">#ACCOUNTCODE#-#ACCOUNTNAME#</TH>
						<TH align="left" width="36%" title="" colspan="4">Branch:&nbsp;#BRANCH_CODE#</TH>
						<TH align="right" width="36%" title="" colspan="4"> Closing Bal:&nbsp;#ClosingBalance#</TH>
					</TR>  

			<!--- 	<CFSET FrstRow ="No" >--->
				<CFSET TotBalance=0>
				<CFSET Totamt=0>
				<CFSET Sellamt=0>
				<CFSET TotPer=0>

				<CFOUTPUT>
						<CFSET ScriptName	=	left(#SCRIPNAME#,20)>
						<CFSET TotBalance	=	NumberFormat(TotBalance+#AGEINGBALANCE#,"999999999.00")>
						<CFSET Totamt		=	NumberFormat(Totamt+#AMOUNT#,"999999999.00")>
						<CFSET Sellamt		=	NumberFormat(Sellamt+#SELLAMOUNT#,"999999999.00")> 
						<cfif #Per# neq ''>
							<cfset TotPer	=	NumberFormat(TotPer+#Per#,"999999999.00")> 
						</cfif>
						
						<TR  STYLE="background-color:white;color:black">
							<Td align="left" width="10%" title="">#SCRIPCODE#&nbsp; </TH>
							<Td align="left" width="15%" title="">#Left(ScriptName,20)#&nbsp;</TH>
							<Td align="left" width="10%" title="">#ISIN#&nbsp;</TH>
							<Td align="left" width="8%">#MKT_TYPE##SETTLEMENT_NO#&nbsp;</TH>
							<Td align="right" width="9%">&nbsp;#AGEINGBALANCE#</TH>
							<Td align="right" width="9%">&nbsp;#QTY#</TH>
							<Td align="right" width="9%">&nbsp;#CLOSINGRATE#</TH>
							<Td align="right" width="9%">&nbsp;#AMOUNT#</TH>
							<Td align="right" width="4%">&nbsp;#SELL#</TH>
							<Td align="right" width="9%">&nbsp;#SELLAMOUNT#</TH>
							<Td align="right" width="4%">&nbsp;#Per#</TH>
						</TR>
				</cfoutput>

						<TR  STYLE="background-color:white;color:NAVY">
							<TH align="left" width="10%" title="">&nbsp;</TH>
							<TH align="left" width="15%" title="">&nbsp;</TH>
							<TH align="left" width="10%" title="">&nbsp;</TH>
							<TH align="left" width="8%" title="">&nbsp;</TH>
							<TH align="right" width="9%" title="">#TotBalance#&nbsp;</TH>
							<TH align="right" width="9%" title="">&nbsp;</TH>
							<TH align="right" width="9%" title="">&nbsp;</TH>
							<CFIF Totamt eq "999999999.99" or Totamt eq "0.00">
								<TH align="right" width="9%" title="">&nbsp;</TH>
							<CFELSE>
								<TH align="right" width="9%" title="">#Totamt#</TH> 					
							</CFIF>				 
							<TH align="left" width="4%" title="">&nbsp;</TH>
							<CFIF Sellamt eq "999999999.99" or Sellamt eq "0.00">
							<TH align="right" width="9%" title="">&nbsp;</TH>
							<CFELSE>
							<TH align="right" width="9%" title="">#Sellamt#</TH>
							</CFIF>		 
							<CFIF TotPer eq "999999999.99" or TotPer eq "0.00">
							<TH align="right" width="4%" title="">&nbsp;</TH>
							<CFELSE>
							<TH align="right" width="4%" title="">#TotPer#</TH>
							</CFIF>		 

						</TR>		 
				</CFOUTPUT>
			</CFIF>
		</TABLE>
	  </div>
	</cfif> 

</CFFORM>
</BODY>
</HTML>