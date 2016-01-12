<cfinclude template="/focaps/help.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>WebX File Generation</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<style>
Select, Input
{
	font: 9pt Tahoma;
}
Pre
{
	color: Red;
	font: 9pt Tahoma;
}
</style>
	<link href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="../../CSS/Bill.css" type="text/css" rel="stylesheet">
</HEAD>
<SCRIPT>
	function setBatchId(form,val)
	{
		with(form)
		{
			if(val=='N')
			{
				GenerationNo.value='001';
			}
			else if(val=='T')
			{
				GenerationNo.value='002';
			}
			else if(val=='A')
			{
				GenerationNo.value='003';
			}
			else
			{
				GenerationNo.value="";
			}
		}
	}
</SCRIPT>
<BODY CLASS="StyleBody1">
<CENTER>
<CFINCLUDE TEMPLATE="../../Common/Export_Text_File.cfm">

<H4>-:&nbsp;<U>WebX File Generation</U>&nbsp;:-</H4>
<CFFORM ACTION="WEBX_FILE_GENERATION.cfm" METHOD="POST" ENABLECAB="No" PRESERVEDATA="Yes">

<cfoutput>
	<input type="Hidden" name="COCD" value="#COCD#">
	<input type="Hidden" name="COName" value="#COName#">
	<input type="Hidden" name="Market" value="#Market#">
	<input type="Hidden" name="Exchange" value="#Exchange#">
	<input type="Hidden" name="Broker" value="#Broker#">
	<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
	<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
	
	<CFPARAM NAME="Settlement_No" DEFAULT="2006001">
	<CFPARAM NAME="Mkt_Type" DEFAULT="N">
	
  <CFQUERY NAME="MarketType" datasource="#Client.database#" DBTYPE="ODBC">
  	Select Mkt_Type from Market_Type_Master
	Where Exchange = '#Exchange#'
	and market = '#market#'
	Order By Nature Desc
  </CFQUERY>
  
  <CFQUERY name="LastSettlement" datasource="#Client.database#" dbtype="ODBC">
	Select 	TOP 1 SETTLEMENT_NO, convert(varchar(10), max(trade_date), 103)trade_date
	From	TRADE1
	Where
		COMPANY_CODE	=  '#Trim(COCD)#'
	And	MKT_TYPE		=  '#MarketType.Mkt_Type#'
	GROUP BY TRADE_DATE, SETTLEMENT_NO
	Having max(trade_date) = TRADE_DATE 	
	Order By SETTLEMENT_NO Desc
  </CFQUERY>
  
  
  <CFIF ISDEFINED('Mkt_Type') AND ISDEFINED('Settlement_No') AND Settlement_No NEQ ''>
<!---   SELECT FROM_DATE FROM SETTLEMENT_MASTER WHERE COMPANY_CODE='#COCD#' AND MKT_TYPE='#Mkt_Type#' AND SETTLEMENT_NO=#Settlement_No#
  <CFABORT> --->
	  <CFQUERY NAME="getSettlement" datasource="#Client.database#">
		SELECT CONVERT(VARCHAR(10),FROM_DATE,103) FROM_DATE 
		FROM SETTLEMENT_MASTER WHERE COMPANY_CODE='#COCD#' AND MKT_TYPE='#Mkt_Type#' AND SETTLEMENT_NO=#Settlement_No#
	  </CFQUERY>
  </CFIF>
  

	<TABLe ALIGN="CENTER" BORDER="0" WIDTH="100%">
		<TR ALIGN="CENTER">
			<TH ALIGN="RIGHT">
				Market Type :&nbsp;&nbsp; 			
			</TH>
			<Td ALIGN="LEFT">				
			  <cfselect  name="Mkt_Type" query="MarketType"  value="Mkt_Type" display="Mkt_Type" required="Yes" ONCHANGE="setBatchId(this.form,this.value);"> </cfselect>
			</Td>
		</TR>
		<TR ALIGN="CENTER">
			<TH ALIGN="RIGHT">
				 Settlement No :&nbsp;&nbsp; 	
			</TH>
			<TD ALIGN="LEFT">				 
			  <CFINPUT TYPE="Text" NAME="Settlement_No" VALUE="#LastSettlement.SETTLEMENT_NO#" class="" MESSAGE="Enter valid Settlement No." VALIDATE="integer" REQUIRED="Yes" SIZE="8" MAXLENGTH="10" onBlur="submit();">				
			</TD>
		</TR>	
		<TR ALIGN="CENTER">
			<TH ALIGN="RIGHT">
				Trade Date :&nbsp; &nbsp; 	
			</TH>
			
			<Td ALIGN="LEFT">
				<cfif isdefined("getSettlement.FROM_DATE")>
					<INPUT TYPE="TEXT" NAME="Trade_date" VALUE="#getSettlement.FROM_DATE#" REQUIRED="Yes" SIZE="11" MAXLENGTH="10"  VALIDATE="eurodate" >
				<CFELSE>
					<INPUT TYPE="TEXT" NAME="Trade_date" VALUE="#Now()#" REQUIRED="Yes" SIZE="11" MAXLENGTH="10"  VALIDATE="eurodate" >
				</cfif>
				
				<!--- <CFINPUT TYPE="Text" NAME="Trade_date" MESSAGE="Enter valid Date." class="" VALUE="getSettlement.FROM_DATE" <!--- VALIDATE="eurodate" ---> REQUIRED="Yes" SIZE="11" MAXLENGTH="10">	 --->
			</Td>
		</TR>
		<TR ALIGN="CENTER">
			<TH ALIGN="RIGHT">
				Batch Id :&nbsp;&nbsp;	
			</TH>
			<Td ALIGN="LEFT">				
				<cfinput TYPE="TEXT" NAME="GenerationNo" MESSAGE="Enter Valid Batch Id." VALUE="" REQUIRED="YES" VALIDATE="INTEGER" SIZE="3" MAXLENGTH="3">
			</Td>			
		</TR>
		<TR ALIGN="CENTER">
			<TH ALIGN="RIGHT">
				Web X Register Id :&nbsp;&nbsp;	
			</TH>
			<TD ALIGN="LEFT">				
				<CFINPUT TYPE="TEXT" NAME="Register_Id" MESSAGE="Enter Valid Register Id." REQUIRED="YES" VALIDATE="INTEGER" SIZE="15" MAXLENGTH="20">
			</TD>
		</TR>
		<TR ALIGN="CENTER">
			<TH ALIGN="RIGHT">
				Format :&nbsp;&nbsp;	
			</TH>
			<TD ALIGN="LEFT">
				<INPUT TYPE="RADIO" NAME="optFormat" ID="old" VALUE="Old" CHECKED>
				<LABEL FOR="old">Old</LABEL>&nbsp;
				<INPUT TYPE="RADIO" NAME="optFormat" ID="new" VALUE="New">
				<LABEL FOR="new">New</LABEL>
			</TD>
		</TR>
	</TABLe>	
  
  <INPUT TYPE="submit" NAME="CmdGenerate" VALUE="Generate" CLASS="StyleSmallButton1">
</cfoutput>

<CFIF Isdefined("CmdGenerate")>
	<CFINCLUDE TEMPLATE="WEBX_FILE_GENERATION_#optFormat#Format.cfm">
</CFIF>

</cfform>
</BODY>
</HTML>
