
<html>
<head>
<title>BRS</title>
<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
<SCRIPT SRC="../../FA_FOCAPS/Scripts/DatePicker.js" TYPE="text/javascript"></SCRIPT>
<link href="../../CSS/style1.css" rel="stylesheet" type="text/css">
</head>
<script>
	function submitFrm()
	{
		FrmBrsMainScreen.submit();
	}
</script>
<body>
<CFOUTPUT>

<CFFORM NAME="FrmBrsMainScreen" ACTION="BillBottom.cfm"  METHOD="POST" target="Scr31">
<CFQUERY name="Markets" datasource="#Client.database#" dbtype="ODBC">
	Select	Distinct
			RTrim( b.MKT_TYPE ) MktType, RTrim( b.DESCRIPTION ) MktTypeDesc
	From	  MARKET_TYPE_MASTER b
	Order By MktType Desc
</CFQUERY>
<INPUT TYPE="HIDDEN" NAME="FinStart" VALUE="#FinStart#"> 
<cfparam default="01/04/#FinStart#" name="From_Date">
<cfparam default="31/03/#FinStart+1#" name="To_Date">
<DIV STYLE="position:absolute;top:0%;height:6%;width:100%;background-color:ECECFF">
	<table width="100%" align="left" border="0" cellpadding="0" cellspacing="0" Class="StyleCommonMastersTable">
		<tr>
			<td colspan="1" width="18%">
				Date :&nbsp;
					<CFINPUT NAME="From_Date" TYPE="text" VALUE="#From_Date#" SIZE="9" MAXLENGTH="10" REQUIRED="no" MESSAGE="Please enter Date !!!" VALIDATE="eurodate" Class="StyleTextBox">
					&nbsp;<INPUT TYPE="button" VALUE="V" CLASS="StyleButton1" onClick="fPopCalendar(this.form.From_Date, this.form.From_Date);return false">
			</td>		
			<td colspan="1"  width="13%">
					<CFINPUT TYPE="Text" NAME="To_Date" Class="StyleTextBox" VALUE="#To_Date#" MESSAGE="Please enter Date !!!" VALIDATE="eurodate" REQUIRED="Yes" SIZE="9" MAXLENGTH="10">
					&nbsp;<INPUT TYPE="button" VALUE="V" CLASS="StyleButton1" onClick="fPopCalendar(this.form.To_Date, this.form.To_Date);return false">&nbsp;&nbsp;&nbsp;
			</td>
			<td align="Right">
				Company :&nbsp;
			</td>
			<TD ID="CashBankCode">
				<textarea name="COCDList"></textarea>
			</TD>
			<TD ID="CashBankCode">
					Process Type <SELECT NAME="BillType" CLASS="top">
						<OPTION VALUE="N">Cancle Bill.
						<OPTION VALUE="Y">Process Bill</OPTION>
						<OPTION value="">All</OPTION>
					</SELECT>&nbsp;
			</TD>
			<td align="Right" width="*">
				Mkt Type:&nbsp;
					<SELECT NAME="MktType" CLASS="top">
							<option value=""> All Segment</option>
							<CFLOOP query="Markets">
								<option value="#Trim(MktType)#"> #Trim(MktType)# - #Trim(MktTypeDesc)# </option>
							</CFLOOP>
							<option value="FO"> FO - Derivative & Commodity </option>
					</SELECT>&nbsp;					
			</td>
			<td align="Right" width="*">
				Settlement List :&nbsp;
					<textarea name="SetlList" cols="10" rows="2"></textarea>
			</td>
			<td align="Right">
				&nbsp;<input type="Submit" name="View" value="View" class="StyleSmallButton1" accesskey="I">
			</td>				
		</tr>
	</table>
</DIV>


</CFFORM>

</CFOUTPUT>

</body>
</html>
