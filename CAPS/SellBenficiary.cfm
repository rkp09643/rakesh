<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<LINK href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<LINK HREF="../../CSS/DynamicCSS.css" REL="stylesheet" TYPE="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>

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
			Top				:	20%;
			Width			:	100%;
			Height			:	80%;
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
</head>
<body>
<cfform name="SellBen" action="">
<cfoutput>

<cfif NOT IsDefined("tOKEN")>
	<cfabort>
</cfif>
<cfif IsDefined("SubmitFrm")>
	<cfloop index="i" from="1" to="#TotalRec#">	
			<cfif  IsDefined("ChkQty#i#") and Evaluate("ChkQty#i#") gt 0>
				<cfset Qty =  Evaluate("ChkQty#i#")>
				<cfset RowId  =  Evaluate("ChkRowId#i#")>
				<cfquery datasource="#Client.database#" name="AgeingData">
					update TEMP_AGEINGBENDATA
					set sellqty=case when qty < #val(Qty)# then qty else #val(Qty)# end
					WHERE TOKEN = '#TOKEN#'
					AND ACCOUNTCODE ='#ACCOUNTCODE#'	
				</cfquery>
			</cfif>
	</cfloop>
	<script>
		parent.ScrOrd.#ChkBok#.checked=true;
		parent.ScrOrd.submit();
		parent.TableSclo.style.display='none';
	</script>
</cfif>
<cfquery datasource="#Client.database#" name="AgeingData">
	SELECT * FROM TEMP_AGEINGBENDATA
	WHERE TOKEN = '#TOKEN#'
	AND ACCOUNTCODE ='#ACCOUNTCODE#'	
</cfquery>
<input type="hidden" value="#TOKEN#" name="TOKEN">
<input type="hidden" value="#ChkBok#" name="ChkBok">

<input type="hidden" value="#ACCOUNTCODE#" name="ACCOUNTCODE">
</cfoutput>
<DIV align="left" id="TableHeader">
	<TABLE width="100%"  border="1" cellspacing="0" cellpadding="0" align="left" class="StyleReportParameterTable1" style="Color : Green;">
		<tr>
			<td align="right" colspan="9">
				<label class="clsLabel" style="cursor:hand" onClick="SellBen.SubmitFrm.value=1;SellBen.submit();"  >Submit</label>
				&nbsp;|&nbsp;<label class="clsLabel" style="cursor:hand" onClick="parent.TableSclo.style.display='none';"  >Close</label>
			</td>
		</tr>
		<TR>

					<TH align="left" width="10%" TITLE="">Benificiry&nbsp;</TH>
					<TH align="left" width="*" TITLE="">Scrip Name</TH>
					<TH align="right" width="14%" TITLE="">ISIN</TH>
					<TH align="right" width="8%">Qty</TH>
					<TH align="right" width="8%">Rate</TH>
					<TH align="right" width="10%">Amount</TH>
					<TH align="right" width="10%">
						Cal. Amount
					</TH>
					<TH ALIGN="right" WIDTH="10%">	Sell Qty
					</TH> 
		</TR>
	</TABLE>
</DIV>
<DIV align="center" id="TableData">
	<CFSET Sr				=	0>
	<TABLE width="100%" border="1" cellspacing="0" cellpadding="0" align="center" class="StyleReportParameterTable1">
		<CFOUTPUT query="AgeingData">
			<CFSET Sr				=	Sr	+1>
			<TR  style="cursor:hand">
					<TH align="left" width="10%" TITLE="">#COUNTERID#&nbsp;</TH>
					<TH align="left" width="*" TITLE="">#left(SCRIP_NAME,20)#&nbsp;</TH>
					<TH align="right" width="14%" TITLE="">#ISIN#</TH>
					<TH align="right" width="8%">#QTY#</TH>
					<TH align="right" width="8%">#CLOSINGRATE#</TH>
					<TH align="right" width="10%">#AMOUNT#</TH>
					<TH align="right" width="10%">
						<input type="text" class="StyleUCaseTextBox" style="text-align:right" size="8" name="ChkAmt#Sr#" disabled>
					</TH>
				<cfsavecontent variable="OnClickVar"> 
					var a ,b 
					a=0
					b=0
					a=SellBen.ChkQty#Sr#.value
					b=SellBen.ChkOrgQty#Sr#.value
					if(a > b)
					{
						SellBen.ChkQty#Sr#.value = SellBen.ChkOrgQty#Sr#.value
					}
					SellBen.ChkAmt#Sr#.value =SellBen.ChkQty#Sr#.value *SellBen.ChkRate#Sr#.value
					
				</cfsavecontent>					
									<TH ALIGN="right" WIDTH="10%">
										<input type="text"  onBlur="#OnClickVar#" class="StyleUCaseTextBox"  value="#sellqty#" style="text-align:right" size="8" name="ChkQty#Sr#">
									</TH> 
							</TR>
				<input type="hidden" class="StyleUCaseTextBox"  value="#QTY#" name="ChkOrgQty#Sr#">
				<input type="hidden" class="StyleUCaseTextBox"  value="#CLOSINGRATE#" name="ChkRate#Sr#">
				<input type="hidden" class="StyleUCaseTextBox"  value="#rowid#" name="ChkRowId#Sr#">
					</TABLE>
				</div>
				<script>
					#OnClickVar#
				</script>
				</CFOUTPUT>
<cfoutput>
<input type="hidden" class="StyleUCaseTextBox"  value="" name="SubmitFrm">
<input type="hidden" class="StyleUCaseTextBox"  value="#AgeingData.recordcount#" name="TotalRec">
</cfoutput>
</cfform>
</body>
</html>
