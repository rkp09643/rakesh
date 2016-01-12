<cfinclude template="/focaps/help.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Early Pay-In of Funds</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">

<link href="../CSS/DynamicCSS.css" type="text/css"  rel="stylesheet">

<style>			
		DIV#TabHead
		{
			Position: Absolute;
			left: 2%;
			Top: 8%;
			Height: 30%;
			Width: 97%;
			OVERFLOW:AUTO;
			Z-Index: 5;
		}
		
		DIV#Data
		{
			Position: Absolute;
			left: 2%;
			Top: 12%;
			Height: 58%;
			Width: 77%;
			Overflow: Auto;
			Z-Index: 5;
		}
				
		DIV#AddData
		{
			Position: Absolute;
			Left: 0;
			Top: 80%;
			Bottom: 0;
			Height:20%;
			Width: 98%;
			Background: ECECFF;
			
		}
</style>
<script>
	function HideDetail()
	{
		AddButton.style.display="";
		UpdateButton.style.display="none";
	}

	function check(form)
	{
		
		with(form)
		
		{
		if  (TxtClient_Code.value == '' || TxtClient_Code.value.charAt(0) == " " )
			{	
				alert("Client Code Cannot Be Blank");
				TxtClient_Code.focus();
				return false;
			}
		else if (txtClientAmt.value == '' || txtClientAmt.value.charAt(0) == " " )
			{
				alert("Amount Cannot Be Blank");
				txtClientAmt.focus();
				return false;
			
			}
			
		}
	}

	
	function Modify(form,RecNo,ClientCode,ClientAmt)
	{
		AddButton.style.display="none";
		UpdateButton.style.display="";
		with(form)
		{
			
			Row_Id.value		 =	RecNo;		
			TxtClient_Code.value = 	ClientCode;
			txtClientAmt.value 	 = 	ClientAmt;
		}
	}

</script>
</head>

<body onLoad="HideDetail();">

<cfoutput>

<CFPARAM NAME="TxtBatch_No"		DEFAULT="0"> 
<CFPARAM NAME="TxtClient_Name"	DEFAULT=""> 

<cfform name="EarlyPayInofFunds" action="EarlyPayinFunds.cfm" method="post">

		<input type="Hidden" name="COCD" value="#UCase(Trim(COCD))#">
		<input type="Hidden" name="CoName" value="#UCase(Trim(CoName))#">
		<input type="Hidden" name="Market" value="#UCase(Trim(Market))#">
		<input type="Hidden" name="Exchange" value="#UCase(Trim(Exchange))#">

 <CFQUERY NAME="MarketType" datasource="#Client.database#" DBTYPE="ODBC">
		 	Select Mkt_Type from Market_Type_Master
			Where Exchange = '#Exchange#'
			and market = '#market#'
			Order By Nature Desc
</CFQUERY>

 <CFQUERY NAME="BatchNo" datasource="#Client.database#" DBTYPE="ODBC">
		 	Select isnull(max(BatchNo),0)+1 BatchNum  from TmpEarlyPayIn
			Where convert(varchar(10),EntryDate,103)=convert(varchar(10),getdate(),103)
</CFQUERY>


<cfif isdefined("CMDSAVE")>
<cftry>
	<cfquery name="SAVE" datasource="#Client.database#">
 			Insert Into TmpEarlyPayIn
 			(MktType,SettNo,ClientCode,ClientAmt,BatchNo,EntryDate) 
			Values
			(
				'#CmbMktType#','#TxtSettlement_No#','#TxtClient_Code#',#txtClientAmt#,#TxtBatch_No#,getdate() 
			)
	</cfquery>
	<cfcatch>
		<script>
			alert("#cfcatch.Message - cfcatch.Detail#");
		</script>
	</cfcatch>
</cftry>
</cfif>
	
<CFIF ISDEFINED("CMDUPDATE")>

		<cfquery name="UPDATE" datasource="#Client.database#" dbtype="ODBC">
		UPDATE TmpEarlyPayIn
		SET ClientCode			=	'#TxtClient_Code#',
			ClientAmt      		=	'#TxtClientAmt#'
		Where 
			RecNo			=	#Row_Id#			
	</cfquery>
</CFIF>

<cfif isdefined("CMDDELETE")>
	<cfquery name="DELETE" datasource="#Client.database#" dbtype="ODBC">
		DELETE 
		FROM TmpEarlyPayIn
		WHERE 
			RecNo		=	'#Row_Id#'		
	</cfquery>
</cfif>

<cfif isdefined("TxtBatch_No")>
	 <cfquery name="SHOW" dbtype="ODBC" datasource="#Client.database#">
		SELECT a.RecNo,a.MktType,a.SettNo,a.ClientCode,a.ClientAmt,a.BatchNo,a.EntryDate,b.Client_Name
		FROM TmpEarlyPayIn	a left join Client_Master b
				on a.clientcode=b.client_id
		where BatchNo='#TxtBatch_No#' 
				and convert(varchar(10),EntryDate,103)=convert(varchar(10),getdate(),103)
				and b.company_code='#cocd#'
	</cfquery> 
</cfif>

<CFIF ISDEFINED("CMDGENERATE")>
	<CFOUTPUT>
		<CFQUERY NAME="CLMEMCODE" datasource="#Client.database#">
			select CLEARING_MEMBER_CODE FROM system_settings
			where company_code='#cocd#'
		</CFQUERY>
		
		<CFSET CLEMCODE=CLMEMCODE.CLEARING_MEMBER_CODE>
		
		<CFQUERY NAME="FileGen" datasource="#Client.database#">
			Select ClientCode,ClientAmt,
				(
					Select sum(ClientAmt) from TmpEarlyPayIn where BatchNo=#TxtBatch_No#
						and convert(varchar(10),EntryDate,103)=convert(varchar(10),getdate(),103)
				) TotAmt,
				(
					Select count(*) from TmpEarlyPayIn where BatchNo=#TxtBatch_No#
						and convert(varchar(10),EntryDate,103)=convert(varchar(10),getdate(),103)
				) RecCnt
			From TmpEarlyPayIn 
			Where BatchNo=#TxtBatch_No# 
				and convert(varchar(10),EntryDate,103)=convert(varchar(10),getdate(),103)
		</CFQUERY>
		
		<CFIF FileGen.RecordCount EQ 0>
			<SCRIPT>
				alert("No Data Found");
			</SCRIPT>		
			<cfabort>
		</CFIF>	

		<CFIF FileGen.RecordCount GT 0>
			<CFSET I = 0>
			<CFSET	FILE_DATA	=	"">
			<CFSET REPORTDATE   = DateFormat(Now(), 'yyyymmdd')>
			<CFSET NOREC		=	"#FileGen.RecCnt#">
			<CFSET TOTVALUE		=	"#FileGen.TotAmt#">

			<CFSET	FileName	=	"CLNTEPF_#CmbMktType#_#TxtSettlement_No#_#REPORTDATE#.T#TxtBatch_No#">
					
			<CFSET RECORDTYPE	= 	"01" >
			<CFSET FILETYPE		=	"CLNTEPF">	
			<CFSET MEMEBERCODE	=	"#CLEMCODE#">
			<CFSET BATCHDATE	=	DateFormat(NOW(),'yyyymmdd')>
			<CFSET BATCHNUMBER	=	"#TxtBatch_No#">
			<CFSET SETTTYPE		= 	"#CmbMktType#">
			<CFSET SETTNO		= 	"#TxtSettlement_No#">
 			<CFSET FILE_DATA	=	"#FILE_DATA##RECORDTYPE#,#FILETYPE#,#MEMEBERCODE#,#BATCHDATE#,#BATCHNUMBER#,#SETTTYPE#,#SETTNO#,#NOREC#,#TOTVALUE#">

			<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes">
			<CFSET	FILE_DATA	=	"">

			<CFSET 	I = I + 1>

			<CFLOOP QUERY="FileGen">
				<CFSET RECORDTYPE	= 	"20" >
				<CFSET CLIENTCODE	= "#ClientCode#"&RepeatString(" ", 12-LEN(#ClientCode#))>
				<CFSET CLIENTAMT	= "#CLIENTAMT#">
 				<CFSET	FILE_DATA	= "#FILE_DATA##RECORDTYPE#,#CLIENTCODE#,#ClientAmt#">
		
				<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\#FileName#" output="#FILE_DATA#" addnewline="yes"> 
		
				<CFSET	FILE_DATA	=	"">
			</CFLOOP>
		</CFIF>	
	</CFOUTPUT>

 	<CFSET #TxtBatch_No#=val(#TxtBatch_No#)+1> 

	<cfif #TxtBatch_No# lt 9>
		<CFSET #TxtBatch_No#="0"&#TxtBatch_No#>
	<cfelse>
			<CFSET #TxtBatch_No#=#TxtBatch_No#>
	</cfif>		

	<SCRIPT>
			alert("Files are generated in C:\\CFUSIONMX7\\WWWROOT\\\REPORTS");
	</SCRIPT>		


</CFIF>

<div align="center">
	<font color="navy"><u> Early Pay-In of Funds </u></font>
</div>
		
<div align="center" id="TabHead">

		<TABLE  ALIGN="center"   WIDTH="100%"  CELLPADDING="0" CELLSPACING="1"  BORDER="0"  CLASS="styletable">
			<tr  BGCOLOR="CCCCFF">
				<th align="Left" width="3%">Sr</th>
				<Th align="Left" width="10%">Client Code</Th>
				<Th align="Left" width="50%">Client Name</Th>
				<th align="Left" width="22%">Amount</th>
	 		</tr>
		</table>
</div>
	
<CFIF SHOW.RecordCount gt 0>	 
	
 	<cfset Sr = 1>
	<div align="center" id="Data">
		<table align="Left" width="100%"  cellpadding="0" cellspacing="1" border="0" class="styletable">
			<cfloop query="SHOW">
				 <tr style="CURSOR: hand" onclick="Modify(EarlyPayInofFunds,'#RecNo#','#ClientCode#',#ClientAmt#);"  onMouseOver="bgColor = 'PINK';" onMouseOut="bgColor = 'White';">
					<td align="Left" width="5%">#Sr#</td>
					<td align="Left" width="14%">#ClientCode#&nbsp;</td>
					<td align="Left" width="55%">#Client_Name#&nbsp;</td>
					<td align="Right" width="22%">#ClientAmt#&nbsp;</td>
				</tr>
				<cfset Sr= Sr+1>
			</cfloop>				
		</table> 
	</div>
	  <cfif SHOW.RecordCount Gt 13 > 
		<script>
		   TabHead.style.width='95%';
		</script>
	 </cfif>	
</CFIF> 

<input type="hidden" name="Row_Id">
<div align="center" id="AddData">

	<TABLE align="left" BORDER="0" CELLSPACING="1" CELLPADDING="0" class="StyleTable">
		<TR>
			<TD ALIGN="left" width="75"> Mkt Type &nbsp;: </TD>
			<TD>
				<select name="CmbMktType"   class="StyleTextBox">
					
					<cfloop query="MarketType">
						<option value="#MKT_Type#" <Cfif MKT_Type eq 'N' > selected</Cfif>>#MKT_Type#</option>
					</cfloop>
				</select>
			</TD>

			<TD ALIGN="CENTER" width="120"> Settlement No :&nbsp; </TD>
			<CFIF ISDEFINED("CMDGENERATE") or NOT ISDEFINED("TxtSettlement_No")>
				<TD>
					<cfINPUT TYPE="Text" NAME="TxtSettlement_No"  SIZE="8" MAXLENGTH="7" class="StyleTextBox" required="yes" message="PLease enter Valid Settlement No" validate="integer">		
				</TD>
			<CFELSE>
				<TD>
 					<INPUT TYPE="Text" NAME="TxtSettlement_No" VALUE="#TxtSettlement_No#"  readonly="true" SIZE="8" MAXLENGTH="10" class="StyleTextBox" >		
				</TD>					
			</CFIF>
			
			<TD ALIGN="CENTER" width="100"> Batch No : </TD>
			<TD>
				<CFIF #TxtBatch_No# EQ 0 >
					<CFLOOP query="BatchNo">
						<CFIF BatchNo.RecordCount gt 0>
							<CFIF #BatchNum# lt 9>
								<CFSET Batch_No="0"&#BatchNum#>
							<CFELSE>
									<CFSET Batch_No=#BatchNum#>
							</CFIF>			
						</CFIF>	
					</CFLOOP>
							<INPUT TYPE="Text" NAME="TxtBatch_No" VALUE="#Batch_No#" readonly="true" SIZE="8" MAXLENGTH="10" class="StyleTextBox" >		
				<CFELSE>
							<INPUT TYPE="Text" NAME="TxtBatch_No" VALUE="#TxtBatch_No#" readonly="true" SIZE="8" MAXLENGTH="10" class="StyleTextBox" >		
				</CFIF>		

			</TD>
		</TR>

		<tr align="center">
			<td align="right"> Client Code :&nbsp;</td>
			<td align="left">
				<cfinput type="text"  name="TxtClient_Code" maxlength="50" class="StyleTextBox">
				<Cfset Help = "select Distinct a.ACCOUNTCODE,B.ACCOUNTNAME from FA_TRANSACTIONS A, FA_ACCOUNTLIST B where b.kindofaccount=~party~ and A.ACCOUNTCODE =B.ACCOUNTCODE AND A.COCD=B.COCD AND A.FINSTYR = B.FINSTYR AND A.MKT_TYPE =~">
				<INPUT TYPE="Button" NAME="cmdClientHelp" VALUE=" ? " CLASS="StyleSmallButton1"
					OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=TxtClient_Code&Sql=#Help#'+this.form.CmbMktType.value+'~ AND A.SETTLEMENT_NO= '+this.form.TxtSettlement_No.value+' &HELP_RETURN_INPUT_TYPE=RADIO', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">				
			</td>
			<td align="left">&nbsp; EPI Amount&nbsp;&nbsp;&nbsp;&nbsp;:</td>
			<td align="left">
				<cfinput type="text" name="txtClientAmt"  message="PLease Enter Numeric Value" validate="float" SIZE="8" maxlength="25" class="StyleTextBox">
			</td>
		</tr>
		<tr align="center">	</tr>		
		<tr id="AddButton">
			<td align="center" colspan="5">
				<input type="submit" name="CMDSAVE" value="Add" class="StyleButton" onclick="check(this.form);">
				<input type="reset" name="Clear" value="Clear" class="StyleButton"> 
			</td>
			<td align="center" colspan="5">
				<input type="submit" name="CMDGENERATE" value="GENERATE" class="StyleButton">
			</td>
		</tr>

		<tr id="UpdateButton">
			<td align="center" colspan="5">
				<input type="submit" accesskey="U" name="CMDUPDATE" value="Update" class="StyleButton">
				<input type="submit" accesskey="D" name="CMDDELETE" value="Delete" class="StyleButton">
				<input type="reset" accesskey="C" name="Clear" value="Clear" class="StyleButton" onClick="HideDetail();">
			</td>
		</tr>
 	</table> 
</div>

</cfform>
</cfoutput>

</body>
</html>
