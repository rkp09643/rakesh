<cfinclude template="/focaps/help.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<TITLE>Demat Expenses</TITLE>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<!--- <link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet"> --->

<style>
		DIV#Heading
		{
			Font: Bold 11pt Tahoma;
			Position: Absolute;
			Top: 0;
			Width: 100%;
		}
		DIV#TABLEDATA
		{
			position:absolute;
			top:12%;
			height:35%;
			overflow:auto;
			width:100%;
		}
		DIV#AddDetails
		{
			Position: Absolute;
			Left: 0;
			Top: 57%;
			Bottom: 0;
			Height: 43%;
			Width: 100%;
			Z-Index: 10;
			Background: ECECFF;
		}
</style>
<script LANGUAGE="JAVASCRIPT">
	
	function validateClient( form, client)	
	{
		with( form )
		{
			if( client != "" && client.charAt(0) != " " )
			{
				top.fraPaneBar.location.href	=	"/FOCAPS/DynamicFrame/Fra_Hide.cfm?COCD=" +COCD.value +"&CoName=" +coname.value +"&Market=" +market.value +"&Exchange=" +exchange.value +"&Broker=" +broker.value +"&FormName=PortFolio&FormObject=PortFolio&ClientID=" +client;
			}
		}
	}
	
	function OpenSingleWindow( form, par, ClntName )
	{
	  	if( par == "Client" )
	  	{
			with( form )
			{
				try
				{
					if (ClntName != "")
					{
						HelpWindow	=	open( "/FOCAPS/HelpSearch/ClientHelp.cfm?COCD="+ COCD.value +"&FinStart=" +FinStart.value +"&FormName=MDE&View=True&helpfor=" +par +"&title=Client", "HelpWindow", "width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=yes, resizeable=no" );
					}
					else
					{	
						HelpWindow	=	open( "/FOCAPS/HelpSearch/ClientHelp.cfm?COCD="+ COCD.value +"&FinStart=" +FinStart.value +"&FormName=MDE&View=True&helpfor=" +par +"&title=Client ", "HelpWindow", "width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=yes, resizeable=no" );
					}	
				}
				catch( e )
				{ 
					HelpWindow	=	open( "/FOCAPS/HelpSearch/ClientHelp.cfm?COCD="+ COCD.value +"&FinStart=" +FinStart.value +"&FormName=MDE&View=True&helpfor=" +par +"&title=Client", "HelpWindow", "width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=yes, resizeable=no" );
				}
			}
		}
		
		if( par == "AllClient" )
		{
			with( form )
			{
				try
				{
					if (ClntName != "")
					{
						HelpWindow	=	open( "/FOCAPS/HelpSearch/ClientHelp.cfm?COCD="+ COCD.value +"&FinStart=" +FinStart.value +"&FormName=MDE&helpfor="+ par + "&ClientName=" + ClntName +"&title=Client", "HelpWindow", "width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=yes, resizeable=no" );
					}
					else
					{
						HelpWindow	=	open( "/FOCAPS/HelpSearch/ClientHelp.cfm?COCD="+ COCD.value +"&FinStart=" +FinStart.value +"&FormName=MDE&helpfor="+ par +"&title=Client", "HelpWindow", "width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=yes, resizeable=no" );
					}	
				}
				catch( e )
				{ 
					HelpWindow	=	open( "/FOCAPS/HelpSearch/ClientHelp.cfm?COCD="+ COCD.value +"&FinStart=" +FinStart.value +"&FormName=MDE&helpfor="+ par +"&title=Client ", "HelpWindow", "width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=yes, resizeable=no" );
				}
			}
		}
	}
	
	function HIDEDETAIL()
	{
		
		SAVEDATA.style.display="";
		UPDATEDATA.style.display="none";
		
	}
	
	function modify(form,ROW_ID,EXPENSE,ONESIDEBUY, ONESIDESALE, OTHERSIDEBUY,OTHERSIDESALE)
	{
		SAVEDATA.style.display="none";
		UPDATEDATA.style.display="";
		
		with(form)
		{
			
			txtROW_ID.value=ROW_ID;
			CmbMktType.value=EXPENSE;
			TxtSettlement_No.value=ONESIDEBUY;
			txtClientID.value=ONESIDESALE;
			cmbDematModule.value=OTHERSIDEBUY;
			TxtDemat_Chrgs.value=OTHERSIDESALE;
			
		}
	}

	function check(form,val)
	{
		with(form)
		{
		if (val != "cmdSearch" && (txtExpenseCode.value == '' || txtExpenseCode.value.charAt(0) == " " ))
			{	
				alert("Please Insert Expense Code");
				return false;
			}
		}
	}
				
</script>

</HEAD>

<BODY onLoad="HIDEDETAIL();">	 	
<CFOUTPUT>

<cfif isdeFINED("CmdUpdate")>
	<cfquery name="DELETE" datasource="#Client.database#">
		DELETE FROM DEMAT_EXPENSES
		WHERE ROW_ID = '#txtROW_ID#'
	</cfquery>
	
	<cfset	cmdInsert	=	"True">
</cfif>

<cfif ISDEFINED("CMDDELETE")>
	<cfquery name="DELETE" datasource="#Client.database#">
		DELETE FROM DEMAT_EXPENSES
		WHERE ROW_ID = '#txtROW_ID#'
	</cfquery>
</cfif>

<CFIF ISDEFINED("cmdInsert")>
	<cfquery name="SAVE" datasource="#Client.database#" dbtype="ODBC">
		INSERT INTO DEMAT_EXPENSES
			 (
			 	Company_Code, Mkt_Type, Settlement_No, Client_ID,
           		Demat_Module,Demat_Charges
			)
		VALUES
			(
				'#trim(UCASE(COCD))#', '#CmbMktType#', #Val(TxtSettlement_No)#, '#Trim(txtClientID)#',
				'#Trim(cmbDematModule)#', #Val(TxtDemat_Chrgs)#
			)
	</cfquery>
</CFIF>

	

	<CFFORM NAME="MDE" ACTION="ManualDematExpenseEntry.cfm" METHOD="POST">
		<input type="Hidden" name="COCD" value="#COCD#">
		<input type="Hidden" name="COName" value="#COName#">
		<input type="Hidden" name="Market" value="#Market#">
		<input type="Hidden" name="Exchange" value="#Exchange#">
		<input type="Hidden" name="Broker" value="#Broker#">
		<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
		<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
		<input type="Hidden" name="txtROW_ID" value="">
		
		<!--- <H4>-:&nbsp;<U>Manual Demat Expense Entry</U>&nbsp;:-</H4> --->
		
		<CFQUERY name="SHOW" datasource="#Client.database#">
			Select 
					*
			From 
					DEMAT_EXPENSES
			WHERE 
					COMPANY_CODE = '#trim(ucase(COCD))#' 
					<CFIF isDefined('cmdSearch') and txtSearchVal neq ''>
						and #cmbSearch# like('#txtSearchVal#%') 
					</CFIF> 
		</CFQUERY>

		<TABLE>
			<TR>
				<TH  width="5%" ROWSPAN="2" ALIGN="RIGHT" >Search On:</TH>
				<th  width="10%" ROWSPAN="5" ALIGN="LEFT">
					<SELECT NAME="cmbSearch" class="StyleTextBox">
						<OPTION VALUE="Settlement_No">Settlement No</OPTION>
						<OPTION VALUE="Client_ID">Client ID</OPTION>
					</SELECT>
					&nbsp;&nbsp;<INPUT TYPE="TEXT" NAME="txtSearchVal"  VALUE=""  class="StyleTextBox">
						<INPUT TYPE="SUBMIT" NAME="cmdSearch" VALUE="Go" class="StyleButton">
				</th>
			</TR>
		</TABLE>
		<table align="center" width="97%" cellpadding="0" cellspacing="1" border="0">
			<TR align="center" bgcolor="CCCCFF" >
				<TH  width="5%">Sr.</TH>
				<th  width="10%">Mkt Type</th>
				<th  width="10%">Settlement No</th>
				<th  width="10%">Client ID</th>
				<td width="10%" style="font-weight:bold; ">Demat Module</td>
				<th  width="10%">Demat Expense</th>
			</TR>
		</table>
		<CFIF SHOW.RecordCount gt 0>
		<cfset SR=1>	
		<DIV ALIGN="CENTER" ID="TABLEDATA" >
			<table align="center" width="97%" cellpadding="0" cellspacing="1" border="0" class="styletable">
				<cfloop query="SHOW">
					<TR align="center" style="CURSOR: hand" onMouseOver="bgColor = 'PINK';" onMouseOut="bgColor = 'White';"
						onClick="modify(MDE,'#ROW_ID#', '#Mkt_Type#', '#Settlement_No#',
										'#Client_ID#', '#Demat_Module#', '#Demat_Charges#');">
						<td width="5%" ALIGN="left">#SR#</td>
						<td width="10%" ALIGN="left">#Mkt_Type#</td>
						<TD width="10%" ALIGN="left">#Settlement_No#</TD>
						<td width="10%" ALIGN="left">#Client_ID#</td>
						<td width="10%" ALIGN="left" >#Demat_Module#</td>
						<td width="10%" ALIGN="left">#Demat_Charges#</td>
					</TR>
					<cfset SR=#SR#+1>
				</cfloop>	
			</table> 
		</DIV>
		<cfif SHOW.RecordCount Gt 13 >
			<script>
			   TabHead.style.width='98%';
			</script>
		</cfif>	
	</CFIF>
		<CENTER>
		 <CFQUERY NAME="MarketType" datasource="#Client.database#" DBTYPE="ODBC">
		 	Select Mkt_Type from Market_Type_Master
			Where Exchange = '#Exchange#'
			and market = '#market#'
			Order By Nature Desc
		 </CFQUERY>
		<CFQUERY NAME="getExpense" datasource="#Client.database#" DBTYPE="ODBC">
		 	Select distinct expenese_code from demat_master
		 </CFQUERY>

		<div id="AddDetails" align="center">		
		<br>
			<TABLE align="center" BORDER="0" CELLSPACING="1" CELLPADDING="0" class="StyleTable">
			  <TR>
				<TD WIDTH="109">
					Mkt Type 
				</TD>
				<TD ALIGN="CENTER" WIDTH="8">:</TD>
				<TD >
					<select name="CmbMktType"   class="StyleTextBox">
					<cfloop query="MarketType">
						<option value="#MKT_Type#">#MKT_Type#</option>
					</cfloop>
					
					</select>
					
				</TD>
			  </TR>
			  
			  <TR>
				<TD>Settlement No </TD>
				<TD ALIGN="CENTER"> :</TD>
				<TD>
					<INPUT TYPE="Text" NAME="TxtSettlement_No" VALUE="" MESSAGE="Enter valid Settlement No." VALIDATE="integer" REQUIRED="Yes" SIZE="8" MAXLENGTH="10" class="StyleTextBox" >		
				</TD>
			  </TR>
			  <TR>
				<TD>Client ID </TD>
				<TD ALIGN="CENTER">:</TD>
					<th align="left" width="130pt" NOWRAP>
			<CFINPUT TYPE="Text" NAME="txtClientID" VALUE="" MESSAGE="Enter valid Client ID." REQUIRED="No" SIZE="12" CLASS="StyleTextBox" onBlur="validateClient(this.form,this.value);" onChange="validateClient(this.form,this.value);">&nbsp;
			<INPUT TYPE="BUTTON" NAME="BTNCLHELP" VALUE=" ? "  title="Click to get Client-ID Help." OnClick="OpenSingleWindow(this.form, 'AllClient', this.form.Client_Name.value);" CLASS="StyleButton">
		</th>	
		<th align="left" width="80pt" COLSPAN="2">
			<INPUT TYPE="Text" NAME="Client_Name" SIZE="35" MAXLENGTH="60" CLASS="StyleTextBox">
		</th>
					<!--- <INPUT TYPE="Text" NAME="TxtClient_ID" VALUE="" MESSAGE="Enter valid Client ID." REQUIRED="NO" SIZE="10" class="StyleTextBox">
				</TD> --->
			  </TR>
			  <TR>
				<TD >Demat Module</TD>
				<TD ALIGN="CENTER">:</TD>
				<TD>
					<SELECT NAME="cmbDematModule" class="StyleTextBox">
					<cfloop query="getExpense">
						<OPTION value="#expenese_code#">#expenese_code#</OPTION>
					</cfloop>	
					</SELECT>
				</TD>
			  </TR>
			  <TR>
				<TD >Demat Charges </TD>
				<TD ALIGN="CENTER">:</TD>
				<TD>
					<INPUT TYPE="Text" NAME="TxtDemat_Chrgs" VALUE="" VALIDATE="FLOAT" MESSAGE="Enter valid Demat Expenses." REQUIRED="YES" SIZE="10" class="StyleTextBox">
				</TD>
			  </TR>
			  <TR id="SAVEDATA">
				<td colspan="2" align="center">
					<input type="submit" name="cmdInsert" value="Save" class="StyleButton">
					<input type="Reset" name="reset" value="Reset" class="StyleButton">
				</td>
			  </TR>
			  <TR id="UPDATEDATA">
				<td colspan="2" align="center">
				<input type="submit" name="cmdUpdate" value="Update" class="StyleButton">
				<input type="submit" name="cmdDelete" value="Delete" class="StyleButton">				
				<input type="Reset" name="Cancel" value="Cancel" class="StyleButton" onclick="HIDEDETAIL();">
				</td>
			  </TR>
			</TABLE>
		</div>		
	</CFFORM>		
</CFOUTPUT>
</BODY>
</HTML>
