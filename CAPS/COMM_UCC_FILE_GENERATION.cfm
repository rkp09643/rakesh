<HTML>
<HEAD>
<TITLE>UCI File Generation</TITLE>

	<!-- <link href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet"> -->
<!--- 	<link href="../../CSS/Bill.css" type="text/css" rel="stylesheet"> --->
<LINK href="../../CSS/style.css" rel="stylesheet" type="text/css">
	<SCRIPT SRC="../../Scripts/ScrollTable.js"></SCRIPT>
</HEAD>
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
	with( frmUCI )
	{
		
		HelpWindow = open( "/FOCAPS/HelpSearch/TradingClients.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd +"&Mkt_Type=&Settlement_No=0&HelpFor=Client&title=Client-ID Help","ClientIDHelpWindow", "Top=0, Left=0, Width=700, Height=525, AlwaysRaised=Yes, Resizeable=No" );
	}
}


function showdetails(cld,market)
{
	HelpWindow = open( "UCIClientDetails.cfm?ClientID="+cld+"&market="+market,"BenkHelp", "width=400, height=500, scrollbar=Yes, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no"  );
}
	function checkall(frm)
	{
		with(eval(frm))
		{
			if(txtDate.value=='')
			{
				alert("Please enter From Date");
				return false;
			}
			if(txtToDate.value=='')
			{
				alert("Please enter From To Date");
				return false;
			}
		}
	}
		function CheckUncheckAll(form,count,chk)
	{
		with(form)
		{
			if(chk==true)
			{
				for(var i=1;i<=count;i++)
				{
					var obj='chk'+i;
					eval(obj).checked=true;
				}
			}
			else
			{
				for(var i=1;i<=count;i++)
				{
					var obj='chk'+i;
					eval(obj).checked=false;
				}
			}
		}
	}
function generateReport(form,count,filefor)
	{
		//var commonParam="COCD="+cocd.value+"&CoName=" +coname.value +"&CoGroup=" +CoGroup.value +"&StYr=" +StYr.value +"&EndYr=" +EndYr.value;
		var chkobj='';
		var chkval='';
		
		
		with(form)
		{
			var commonParam="COCD="+COCD.value+"&CoName=" +COName.value +"&StYr=" +FinStart.value +"&EndYr=" +FinEnd.value;
			for (var i=1 ;i<=count; i++)
			{
				var obj='chk'+i;
				if(eval(obj).checked==true)
				{
					chkval=chkval+"'"+eval(obj).value+"',";
				}
				
			}
			
			if(chkval == '')
			{
				alert('Please Select At least one Record to Proceed Further');
				return false;
			}
		}
		var chkClient="";
		if(document.frmUCI.chkClient(0).checked==true)
		{
			chkClient="Trd"
		}
		else
		{
			chkClient="New"
		}
		
		if (filefor=='MCX' )
		{
			FileGeneration.location.href="generateUCIMCX.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&chkClient="+chkClient;
		}
		else if (filefor=='CD_MCX')
		{
			FileGeneration.location.href="generateUCICURMCX.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&chkClient="+chkClient;
		}
		else if (filefor=='ICEX' )
		{
			FileGeneration.location.href="generateUCIICEX.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&chkClient="+chkClient;
		}
		else
		{
			FileGeneration.location.href="generateUCINcdex.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&chkClient="+chkClient+"&CMBFILETYPE="+document.frmUCI.cmbFileType.value+"&ActiveInactive="+document.frmUCI.CmbActOption.value;
		}	
	} 
function validatecheck(frm,CID,chkname,chk)
{
	with(frm)
	{
		if(chk==true)
		{
			//FileGeneration.location.href="ValidateUCI.cfm?batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&ClientID="+CID+"&chkname="+chkname;
		}
			
	}	
}
function CheckUncheck(objname,chk)
{
	with(frmUCI)
	{
		if(objname=='chkTrdClient' && chk==true)
		{
			chkNewClient.checked=false;
			chkTrdClient.checked=true;
		}
		else
		{
			chkNewClient.checked=true;
			chkTrdClient.checked=false;
		}
	}
}
	
</SCRIPT>
<BODY topmargin="0" onLoad="makeScrollableTable('tabela',true,'auto');">
<CENTER>

<FORM NAME="frmUCI"   ACTION="COMM_UCC_FILE_GENERATION.CFM" METHOD="POST">

<CFOUTPUT>

	<INPUT type="Hidden" name="COCD" value="#COCD#">
	<INPUT type="Hidden" name="COName" value="#COName#">
	<INPUT type="Hidden" name="Market" value="#Market#">
	<INPUT type="Hidden" name="Exchange" value="#Exchange#">
	<INPUT type="Hidden" name="Broker" value="#Broker#">
	<INPUT type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
	<INPUT type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">


  <CFQUERY NAME="getnsecompany" datasource="#Client.database#" DBTYPE="ODBC">
 		SELECT * FROM COMPANY_MASTER WHERE EXCHANGE='NSE' AND FLG_NCX IN ('MCX','NCDX','ICEX','CD_MCX')
  </CFQUERY>	

<CFIF IsDefined('btnView')>		

	<cfquery name="GetName" datasource="#Client.database#">
		select ltrim(rtrim(CHEKERUSERLIST)) CHEKERUSERLIST
			from system_settings
		where company_code = '#cocd#'
	</cfquery>
	
  <CFQUERY NAME="GETCLIENTLIST" datasource="#Client.database#" DBTYPE="ODBC">
 		<!--- <CFIF IsDefined('chkTrdClient')> --->
		SELECT  A.CLIENT_ID,pan_name CLIENT_NAME,B.MARKET,A.COMPANY_CODE,A.REGISTRATION_DATE,CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103),
		A.LAST_MODIFIED_DATE,'Y' TRDFLG 
		FROM CLIENT_MASTER A LEFT OUTER JOIN CLIENT_DETAIL_VIEW B
		ON  A.CLIENT_ID=B.CLIENT_ID
		AND A.COMPANY_CODE=B.COMPANY_CODE
		LEFT OUTER JOIN COMPANY_MASTER C ON
		A.COMPANY_CODE=C.COMPANY_CODE
		WHERE 
			A.COMPANY_CODE 	IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE EXCHANGE='NSE' AND FLG_NCX IN ('MCX','NCDX','CD_MCX','ICEX')) 
		AND A.COMPANY_CODE = '#COCD#'	
		and A.CLIENT_ID IN(SELECT DISTINCT CLIENT_ID FROM TRADE1 WHERE COMPANY_CODE=A.COMPANY_CODE AND CONVERT(DATETIME,TRADE_DATE,103)  BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
				and CONVERT(DATETIME,'#txtToDate#',103) )
		<cfif CmbActOption eq "ACTIVE">
			<cfif CmbOption eq "New">
				<CFIF IsDefined('txtDate') And Trim(txtDate) is not "" and IsDefined('txtToDate') And Trim(txtToDate) is not "">
				AND (
						CONVERT(DATETIME, A.Agreement_Date, 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
						and CONVERT(DATETIME,'#txtToDate#',103) 
					)
				</CFIF>
			<cfelse>
				<CFIF IsDefined('txtDate') And Trim(txtDate) is not "" and IsDefined('txtToDate') And Trim(txtToDate) is not "">
				AND (
						CONVERT(DATETIME, CONVERT(VarChar(10), A.LAST_MODIFIED_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
						and CONVERT(DATETIME,'#txtToDate#',103) 					
					)
				</CFIF>	
			</cfif>	
		<cfelse>
			AND A.CLIENT_ID IN (
							SELECT DISTINCT CLIENT_ID
							FROM BROKERAGE_APPLY
							WHERE
								COMPANY_CODE ='#COCD#'
							AND ACTIVE_INACTIVE = 'I'
							AND CONVERT(DATETIME,START_DATE,103) >= CONVERT(DATETIME,'#txtDate#',103)
							AND CONVERT(DATETIME,ISNULL(END_DATE,CONVERT(DATETIME,'#txtToDate#',103)),103) <= CONVERT(DATETIME,'#txtToDate#',103)
							)
		</cfif>		
		<CFIF IsDefined("FromClient") and FromClient neq ''>
			and a.CLIENT_ID IN ('#Replace(FromClient,",","','","ALL")#')
		</CFIF>
		<CFIF IsDefined("FromBRANCH") and FromBRANCH neq ''>
			and a.BRANCH_CODE IN ('#Replace(FromBRANCH,",","','","ALL")#')
		</CFIF>
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(A.CHEKING,'N') = 'Y'
		</cfif>		
 		<!---ORDER BY  A.CLIENT_ID,A.CLIENT_NAME,B.MARKET
		 <CFELSE> --->

		UNION
		
		SELECT  A.CLIENT_ID,pan_name CLIENT_NAME,B.MARKET,A.COMPANY_CODE,A.REGISTRATION_DATE,CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103),
		A.LAST_MODIFIED_DATE 
		,'N' TRDFLG 
		FROM CLIENT_MASTER A LEFT OUTER JOIN CLIENT_DETAIL_VIEW B
		ON  A.CLIENT_ID=B.CLIENT_ID
		AND A.COMPANY_CODE=B.COMPANY_CODE
		AND B.EXCHANGE='NSE'
		LEFT OUTER JOIN COMPANY_MASTER C ON
		A.COMPANY_CODE=C.COMPANY_CODE
		WHERE 
			A.COMPANY_CODE 	IN (SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE EXCHANGE='NSE' AND FLG_NCX IN ('MCX','NCDX','ICEX','CD_MCX'))  
		AND A.COMPANY_CODE = '#COCD#'
		<cfif CmbActOption eq "ACTIVE">
			<cfif CmbOption eq "New">
				<CFIF IsDefined('txtDate') And Trim(txtDate) is not "" and IsDefined('txtToDate') And Trim(txtToDate) is not "">
				AND (
						CONVERT(DATETIME, A.Agreement_Date, 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
						and CONVERT(DATETIME,'#txtToDate#',103) 
					)
				</CFIF>
			<cfelse>
				<CFIF IsDefined('txtDate') And Trim(txtDate) is not "" and IsDefined('txtToDate') And Trim(txtToDate) is not "">
				AND (
						CONVERT(DATETIME, CONVERT(VarChar(10), A.LAST_MODIFIED_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
						and CONVERT(DATETIME,'#txtToDate#',103) 					
					)
				</CFIF>	
			</cfif>
		<cfelse>
			AND A.CLIENT_ID IN (
							SELECT DISTINCT CLIENT_ID
							FROM BROKERAGE_APPLY
							WHERE
								COMPANY_CODE ='#COCD#'
							AND ACTIVE_INACTIVE = 'I'
							AND CONVERT(DATETIME,START_DATE,103) >= CONVERT(DATETIME,'#txtDate#',103)
							AND CONVERT(DATETIME,ISNULL(END_DATE,CONVERT(DATETIME,'#txtToDate#',103)),103) <= CONVERT(DATETIME,'#txtToDate#',103)
							)	
		</cfif>	
		<CFIF IsDefined("FromClient") and FromClient neq ''>
			and a.CLIENT_ID IN ('#Replace(FromClient,",","','","ALL")#')
		</CFIF>
		<CFIF IsDefined("FromBRANCH") and FromBRANCH neq ''>
			and a.BRANCH_CODE IN ('#Replace(FromBRANCH,",","','","ALL")#')
		</CFIF>
		and A.CLIENT_ID NOT IN(
								SELECT DISTINCT CLIENT_ID 
								FROM TRADE1 WHERE COMPANY_CODE=A.COMPANY_CODE
								AND CONVERT(DATETIME,TRADE_DATE,103)  BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
								and CONVERT(DATETIME,'#txtToDate#',103)
								) 
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(A.CHEKING,'N') = 'Y'
		</cfif>
 		ORDER BY  CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103) DESC,A.CLIENT_ID
	<!--- </CFIF> --->
  </CFQUERY>
</CFIF>  
  <TABLE   border="0" bgcolor="##FFFFCC" width="98%">
<!---   <TR class="top" height="20">
		
		<TH></TH>
		<TH colspan="8" align="CENTER" class="foot-sel">
			<!-- <LABEL class="copyright"> -:-->&nbsp;UCI File Generation&nbsp;<!-- :-</LABEL> -->
		</TH>
	</TR> --->
	
  	<TR height="20" bgcolor="##FFFFCC">
		<TH nowrap >
			Frm Dt.: &nbsp;
		</TH>
		<TH >
			<CFIF IsDefined("txtDate") and txtDate neq ''>
				<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtDate" SIZE="10" VALUE="#txtDate#" CLASS="StyleTextBox">
			<CFELSE>
				<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtDate" SIZE="10" VALUE="#DateFormat(Now(),'DD/MM/YYYY')#" CLASS="StyleTextBox">
			</CFIF>	
		</TH>
		<TH  nowrap>
			To Dt : &nbsp;
		</TH>
		<TH >
			<CFIF IsDefined("txtToDate") and txtToDate neq ''>
				<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtToDate" SIZE="10" VALUE="#txtToDate#" CLASS="StyleTextBox">
			<CFELSE>
				<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtToDate" SIZE="10" VALUE="#DateFormat(Now(),'DD/MM/YYYY')#" CLASS="StyleTextBox">
			</CFIF>	
		</TH>
		<TH nowrap>
			Batch No :
		</TH>
		<TH nowrap>
			&nbsp;<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtBatchNo" maxlength="3" SIZE="3" <CFIF IsDefined('txtBatchNo') and txtBatchNo neq ''> VALUE="#txtBatchNo#" <CFELSE> VALUE="01"</CFIF>CLASS="StyleTextBox">
		</TH>
		
		<TH nowrap>
			File Type :
		</TH>
		<TH nowrap>
			&nbsp;
			<SELECT NAME="cmbFileType" class="fieldbuttonblue" CLASS="StyleTextBox">
				<OPTION VALUE="New" <CFIF IsDefined('cmbFileType') and Trim(cmbFileType) eq 'New'>SELECTED</CFIF>  > New </OPTION>
				<OPTION VALUE="MOD" <CFIF IsDefined('cmbFileType') and Trim(cmbFileType) eq 'Mod'>SELECTED</CFIF>> Mod </OPTION>
			</SELECT>
		</TH>
		<TH nowrap>
			Cl. Opt. :
		</TH>
		<TH nowrap>
			&nbsp;
			<SELECT NAME="CmbOption" class="fieldbuttonblue" CLASS="StyleTextBox">
				<OPTION VALUE="New" <CFIF IsDefined('CmbOption') and Trim(CmbOption) eq 'New'>SELECTED</CFIF>  >New</OPTION>
				<OPTION VALUE="Mod" <CFIF IsDefined('CmbOption') and Trim(CmbOption) eq 'Mod'>SELECTED</CFIF> >Modified</OPTION>
			</SELECT>
		</TH>		
	</TR>
	<tr>
		<!--- <TH>
			File Opt. :
		</TH>
		<TH>
			&nbsp;
			<SELECT NAME="CmbFileOption" class="fieldbuttonblue" CLASS="StyleTextBox">
				<OPTION VALUE="Old" <CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'Old'>SELECTED</CFIF> >Old</OPTION>
				<OPTION VALUE="New" <CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'New'>SELECTED</CFIF>  >New</OPTION>
			</SELECT>
		</TH> --->
		<TH nowrap>
			Branch List :
		</TH>
		<CFSET hELP ="select BRANCH_CODE,BRANCH_NAME from BRANCH_MASTER">
		<TH nowrap>
			&nbsp;<TEXTAREA COLS="6" ROWS="1" CLASS="StyleTextBox" NAME="FromBRANCH"></TEXTAREA>
				  <INPUT TYPE="Button" NAME="cmdBranchHelp" VALUE=" ? " CLASS="StyleSmallButton1" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=FromBRANCH&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
	   </TH>
	   <TH nowrap>
			Cl List :
		</TH>
		<TH nowrap>
			&nbsp;<TEXTAREA COLS="6" ROWS="1" CLASS="StyleTextBox" NAME="FromClient"></TEXTAREA>
									<INPUT TYPE="Button" NAME="btnHelp" VALUE=" ? " title="Click here to get Help for Client ID." CLASS="StyleSmallButton1" style="Cursor : Help;"
					   ONCLICK="OpenWindow( this.form, 'Client' );">		
		</TH>
		
		<TH nowrap>
			Option :
		</TH>
		<TH nowrap>
			&nbsp;
			<SELECT NAME="CmbActOption" class="fieldbuttonblue" CLASS="StyleTextBox">
				<OPTION VALUE="Active" <CFIF IsDefined('CmbActOption') and Trim(CmbActOption) eq 'Active'>SELECTED</CFIF>  > Active </OPTION>
				<OPTION VALUE="Inactive" <CFIF IsDefined('CmbActOption') and Trim(CmbActOption) eq 'Inactive'>SELECTED</CFIF> > Inactive </OPTION>
			</SELECT>
		</TH>			
		
				
		<Td colspan="10" align="right">
			&nbsp;
			<INPUT TYPE="SUBMIT" class="fieldbutton" NAME="btnView" VALUE="View" CLASS="StyleButton" onClick="return checkall(this.form);">
		</Td>		
	</tr>
	
  </TABLE>
  <CFIF IsDefined('btnView')>
 
  <TABLE  bgcolor="##ECFFFF"  ID="tabela" WIDTH="100%" BORDER="1px" ALIGN="LEFT"  CELLPADDING="0" CELLSPACING="0">
	<THEAD>
		
		<TR class="orange">
			<TH>
				<INPUT TYPE="CHECKBOX" NAME="CHKSELECTALL" VALUE="Y" ID="CHKSELECTALL" CLASS="StyleCheckBox" onClick="CheckUncheckAll(this.form,#GETCLIENTLIST.Recordcount#,this.checked);"> 
			</TH>
			
			<TH nowrap>Company Code</TH>
			<TH>Client ID</TH>
			<TH>Client Name</TH>
			<TH WIDTH="5%">Trade</TH>
			<TH>Registration Date</TH>
			<TH NOWRAP>Modified Date</TH>
		</TR>
		</THEAD>
		<TBODY STYLE="height:100% ">
			<CFSET SR=1>
			<CFLOOP QUERY="GETCLIENTLIST">
				<!--- <CFQUERY NAME="TrdDone" datasource="#Client.database#">
					IF Exists(	Select trade_number
								From
										Trade1
								Where
										Company_Code	=			'#GETCLIENTLIST.Company_Code#'
								And		Client_ID		=			'#GETCLIENTLIST.Client_ID#'
							)
					BEGIN			
						SELECT 'Y' Trd
					END
				</CFQUERY>
				 --->
				<!--- <CFIF IsDefined("TrdDone.Trd")>
					<CFSET	TrdYN	=	TrdDone.Trd>
				<CFELSE>
					<CFSET	TrdYN	=	"N">
				</CFIF> --->
			<TR STYLE="cursor:pointer; " style="font-size:9px;color:666666;font:"Trebuchet MS";" NOWRAP>
				<TH>
					<INPUT TYPE="CHECKBOX" NAME="chk#SR#" VALUE="#Client_id#" onClick="validatecheck(this.form,'#Client_id#','chk#SR#',this.checked);" CLASS="StyleCheckBox">
				</TH>
				
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp;#Company_Code#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Client_ID#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Client_Name#</TD>
				<TD WIDTH="5%" ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Trdflg#</TD>
				<TD ALIGN="LEFT" nowrap onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp;#Registration_Date#</TD>
				<TD ALIGN="LEFT" NOWRAP onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp;#Last_Modified_date#</TD>
			</TR>
			<CFSET SR=SR+1>
			</CFLOOP>
		
			<TR>
				<TH COLSPAN="7">&nbsp;</TH>
			</TR>
		</TBODY>
		
		<TFOOT>
			 <TR bgcolor="##FFFFCC">
				<TH ALIGN="LEFT"  COLSPAN="3" NOWRAP>
						Trading Clients :<INPUT TYPE="RADIO" NAME="chkClient" VALUE="Trd" <CFIF IsDefined('chkClient') and chkClient eq 'Trd' >Checked<CFELSE>Checked</CFIF> >
						<!--- <CFIF IsDefined('chkTrdClient') and chkTrdClient neq ''>
							<INPUT TYPE="CHECKBOX" NAME="chkTrdClient" VALUE="TradeClient" CHECKED CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">
						<CFELSE>
							<INPUT TYPE="CHECKBOX" NAME="chkTrdClient" VALUE="TradeClient" CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">
						</CFIF>  --->
						New Clients :<INPUT TYPE="RADIO" NAME="chkClient" VALUE="New" <CFIF IsDefined('chkClient') and chkClient eq 'New'>Checked</CFIF> >
						<!--- <CFIF (IsDefined('chkNewClient')  and chkNewClient neq '')>
							<INPUT TYPE="CHECKBOX" NAME="chkNewClient" VALUE="NewClient" CHECKED CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">
						<CFELSEIF IsDefined('chkTrdClient')  and chkTrdClient eq ''>
							<INPUT TYPE="CHECKBOX" NAME="chkNewClient" VALUE="NewClient" CHECKED CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">
						<CFELSE>
							<INPUT TYPE="CHECKBOX" NAME="chkNewClient" VALUE="NewClient"  CHECKED CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">	
						</CFIF>   --->
					<INPUT TYPE="button" NAME="CmdGenerate" VALUE="Generate" CLASS="field" ONCLICK="generateReport(this.form,#GETCLIENTLIST.Recordcount#,'#COCD#');">
				</TH>
				<TH ALIGN="LEFT" COLSPAN="4" WIDTH="100%">
					<IFRAME  style="background-color:##FFFFCC; "  SRC="about:blank" NAME="FileGeneration"  SCROLLING="no" WIDTH="100%" HEIGHT="30"  FRAMEBORDER="0"></IFRAME>
				</TH>
				
			</TR> 
		</TFOOT>			
			
	</TABLE>
	</CFIF>
  
  
  
	
  
</CFOUTPUT>
	<IFRAME   SRC="about:blank"  NAME="FileGeneration1"  STYLE="display:none; " SCROLLING="auto" WIDTH="500" HEIGHT="200"  FRAMEBORDER="0"></IFRAME>
</FORM>
</BODY>
</HTML>
