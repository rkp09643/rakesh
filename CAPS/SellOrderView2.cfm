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

		function SetExcelPath()
		{
			
						ExportObj2(TableHeader,TableData)
		}

	</SCRIPT>
	<SCRIPT SRC="/FOCAPS/Common/Scripts/Export.vbs" LANGUAGE="vbscript"></SCRIPT>
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
<cfparam default="" name="txtDate">
<CFPARAM NAME="invalidClient" 	DEFAULT="No">
<!--- <CFPARAM NAME="FrstRow" 		DEFAULT="Yes"> --->
<CFPARAM NAME="ClientCode" 		DEFAULT="">
<CFPARAM NAME="ScriptName" 		DEFAULT="">
<CFPARAM NAME="TotBalance" 		DEFAULT="999999999.99">
<CFPARAM NAME="Totamt" 			DEFAULT="999999999.99">
<CFPARAM NAME="Sellamt" 		DEFAULT="999999999.99">
<CFPARAM NAME="GrandTotBalance" DEFAULT="999999999.99">
<CFPARAM NAME="GrandTotamt" 	DEFAULT="999999999.99">
<CFPARAM NAME="GrandSellamt" 	DEFAULT="999999999.99">
<CFPARAM NAME="TotPer" 			DEFAULT="999999999.99">

<CFSET GrandTotBalance=0>
<CFSET GrandTotamt=0>
<CFSET GrandSellamt=0>
				
<CFFORM NAME="ScrOrd" ACTION="SellOrderView.cfm" METHOD="POST">

	<cfif IsDefined("FileGenerat")>
	
		<cfoutput>
			<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">
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
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@STORETABLE" 	value="Y" 						null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@SCRIP" 		value="#txtScrip#" 				null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@PRICEPER" 	value="#txtPricePer#" 			null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@type" 		value="P" 						null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@ODINFILE" 	value="#RDOODIN#" 				null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@Sellable" 	value="ALL" 					null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@POAPER" 		value="#POApercentage#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@CASHASSO" 	value="#INCCASHASS#" 			null="NO">
					
					<CFPROCRESULT  NAME="Main" resultset="4">
				</CFSTOREDPROC>
			

			<CFIF Main.RecordCount EQ 0>
				<SCRIPT>
					alert("No Data Found");
				</SCRIPT>		
				<cfabort>
			</CFIF>	
			<cfinclude template="SellBenficiaryFileGenerate.cfm">
		</cfoutput>
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
				<cfparam default="" name="txtPricePer">
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
				<input type="hidden" name="txtpriceper" 		value="#txtpriceper#">
				<input type="hidden" name="txtScrip" 		value="#txtScrip#">
				<input type="hidden" name="RDOODIN" 		value="#RDOODIN#">
				<input type="hidden" name="OMNISYSFILE" 		value="#OMNISYSFILE#">
				<input type="hidden" name="INCCASHASS" 		value="#INCCASHASS#">
				<input type="hidden" name="POApercentage" 		value="#POApercentage#">
				
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
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@AMOUNT1" 		value="#Val(txtAmount1)#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@STORETABLE" 	value="N" 					null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@SCRIP" 		value="#txtScrip#" 			null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@PRICEPER" 	value="#txtPricePer#" 		null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@type" 		value="p" 					null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@ODINFILE" 	value="" 					null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@Sellable" 	value="ALL" 				null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@POAPER" 		value="#POApercentage#" 	null="NO">
					<CFPROCPARAM type="in" cfsqltype="cf_sql_varchar" dbvarname="@CASHASSO" 	value="#INCCASHASS#" 		null="NO">
					
					<CFPROCRESULT  NAME="Main" resultset="4">
				</CFSTOREDPROC>
					<CFIF Main.RecordCount EQ 0>
						<SCRIPT>
							alert("No Data Found");
						</SCRIPT>		
						<cfabort>
					</CFIF>	
					<!--- <cfinclude template="SellBenficiaryFileGenerate.cfm"> --->
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
					<TH align="right" width="9%"  title="">Sell Amt&nbsp;</TH>
					<TH align="right" width="4%" title="">%&nbsp;</TH>
				</TR>
			</TABLE>
		</DIV>

		<DIV align="center" id="Tablefoot">
			<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center" color="NAVY" class="StyleReportParameterTable1">
				<input type="submit" name="FileGenerat" class="StyleButton" value="Generate File">
				<input accesskey="O"  type="button"  onClick="SetExcelPath()" name="Excel1" value="Excel" class="StyleSmallButton1">
	 		</TABLE>
		</DIV> 

<!--- 		<DIV align="center" id="Tablefoot">
			<TABLE width="100%" border="0" cellspacing="0" cellpadding="0" align="center" color="NAVY" class="StyleReportParameterTable1">
				<input type="submit" name="FileExport" class="StyleButton" value="Export to Excel">
			</TABLE>
		</DIV> 
 --->
		<DIV align="center" id="TableData">
		<CFSET Sr				=	0>
		<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1">
			<CFIF IsDefined("txtAmount") and IsDefined("RdoUNCCredit")>
				<CFOUTPUT query="Main" group="ACCOUNTCODE">
					 <TR  STYLE="background-color:white;color:NAVY">
						<TH align="left" width="5%" title=""><input type="checkbox" name="ClientCode" value="#ACCOUNTCODE#" checked>  </TH> 
						<TH align="left" width="35%" title="" colspan="3">#ACCOUNTCODE#-#ACCOUNTNAME#</TH>
						<TH align="left" width="36%" title="" colspan="4">Branch:&nbsp;#BRANCH_CODE#</TH>
						<TH align="right" width="36%" title="" colspan="3"> Closing Bal:&nbsp;#ClosingBalance#</TH>
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
						<CFSET GrandTotBalance	=	NumberFormat(GrandTotBalance+TotBalance,"999999999.00")>
						<CFSET GrandTotamt		=	NumberFormat(GrandTotamt+Totamt,"999999999.00")>
						<CFSET GrandSellamt		=	NumberFormat(GrandSellamt+Sellamt,"999999999.00")> 
				</CFOUTPUT>

 				<CFOUTPUT>
					 <TR  STYLE="background-color:white;color:NAVY">
						<TH align="left" width="5%" title="" colspan="1">&nbsp; </TH> 
						<TH align="left" width="35%" title="" colspan="3">GRAND TOTAL</TH>
						<TH align="right" width="10%" title="" >#GrandTotBalance#</TH>
						<TH align="right" width="35%" title="" colspan="3">#GrandTotamt#</TH>
						<TH align="right" width="35%" title="" colspan="2"> #GrandSellamt#</TH>
						<TH align="right" width="35%" title="" >&nbsp; </TH>
					</TR>  
				</CFOUTPUT>
				<Cfif sms eq 'y'>
						<cfinclude template="../../Common/SMSAdd.cfc">	
						<cfquery name="GetJob" datasource="capsfo_tradeData">
							select max(isnull(JobId,0))+1  JobId From  SMS_Trans
						</cfquery>
						<cfset Jobid1 = val(GetJob.JobId)>
						<cfquery dbtype="query" name="SMSSEND">
							SELECT * FROM Main
							WHERE sell = 'Y'
							order by ACCOUNTCODE
						</cfquery>

						<CFOUTPUT query="SMSSEND" group="ACCOUNTCODE">
								<Cfif REMARKS neq ''>
									<Cfset A = SMSADD(MOBILE_NO,REMARKS,'N',val(GetJob.JobId))>	
								</Cfif>
						</CFOUTPUT>
						<cfoutput>
							<script>
								alert('Your Sms Queue No Is #Jobid1#')
							</script>
						</cfoutput>
				</Cfif>
 			</CFIF>
		</TABLE>
	  </div>
	</cfif> 

</CFFORM>
</BODY>
</HTML>