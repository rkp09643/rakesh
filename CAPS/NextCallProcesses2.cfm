<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Untitled Document</title>
</head>

<body>
<cfoutput>
	<cfif IsDefined("EContract")>
		<input type="Hidden" name="COCD" value="#COCD#">
		<input type="Hidden" name="COName" value="#COName#">
		<input type="Hidden" name="Market" value="#Market#">
		<input type="Hidden" name="Exchange" value="#Exchange#">
		<input type="Hidden" name="Broker" value="#Broker#">
		<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
		<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
		<Cfset WEBXCONTRACT ='Y'>
		<cfset LASTCLIENT ="">
		<cfset BILLCUMCONTRACT =''>
		 <cfset ContraOpt ="System">
		 <cfset fileType = 'HTML'>
		<cfinclude template="../../Text_Reports/Trading/CAPS/BSE_CASHContractHTML.cfm"><br>
	</cfif>
	<Cfif IsDefined("SMS1")>
		<cfset from_date =Trade_Date>
		<cfset To_date =Trade_Date>
		<cfset COMPANY_LIST =cocd>
		<cfset TXTMKTTYPE =mkt_type>
		<cfset txtSetlNo =Settlement_No>
		<cfset txtBranch ="">
		<cfset txtFamily ="">
		<Cfset SendOpt1  ='SEL'>
		<cfset ClientCode ="">
		<cfset ClACCCode ="ACCode">
		<Cfset  DRTEXT="">
		<Cfset  CRTEXT="">
		<cfset FROMTEXT ="">
		<cfinclude template="../../Common/SMSAdd.cfc">	
		<cfinclude template="../../SMSSENDER/SMSSudaReport.cfm">
		SMS Is Adeed In Queue<br>
	</Cfif>
</cfoutput>
</body>
</html>
