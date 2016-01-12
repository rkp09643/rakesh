<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>UCI File Generation for Active Inactive</title>
</head>

<BODY bgcolor="#FFFFCC" TOPMARGIN="0">
<CFPARAM NAME="chkval" DEFAULT="">
<CFPARAM NAME="frdate" DEFAULT="">
<CFPARAM NAME="todate" DEFAULT="">
<CFPARAM NAME="market" DEFAULT="">
<CFPARAM NAME="batchNo" DEFAULT="">
<CFPARAM NAME="chkClient" DEFAULT="Trd">
<CFPARAM NAME="FINALSTRING" DEFAULT="">
<CFPARAM NAME="FILENAMELOG" DEFAULT="">
<CFOUTPUT>
<CFSET chkval="#Left(chkval,(Len(chkval)-1))#">
	
<cfquery name="getsystemsettingsvalue" datasource="#client.database#">
	select ISNULL(UCCEXPORT_COMPULSORY,'N') UCCEXPORT_COMPULSORY
	FROM SYSTEM_SETTINGS
	WHERE
		COMPANY_CODE = '#COCD#'
</cfquery>
<cfquery name="GetName" datasource="#Client.database#">
		select ltrim(rtrim(CHEKERUSERLIST)) CHEKERUSERLIST
			from system_settings
		where company_code = '#cocd#'
	</cfquery>
 <CFQUERY NAME="GETCLIENTLIST" datasource="#Client.database#" DBTYPE="ODBC">
 		Select DISTINCT A.company_code,a.client_id,client_name,CLIENT_NATURE,REGISTRATION_DATE,Last_Modified_date,active_inactive,B.InActiveType,
		'' PANNO,	'n' Trdflg
		from client_master a , brokerage_apply b
		Where
			a.Company_code = b.company_code
		and a.client_id = b.client_id
		and a.Company_code = '#COCD#'
		AND ISNULL(END_DATE ,'') = ''
		and A.Client_Id in(#PreserveSingleQuotes(chkval)#)
		<CFIF IsDefined("FromBranch") and trim(FromBranch) neq ''>
			and Branch_Code IN ('#Replace(FromBranch,",","','","ALL")#')
		</CFIF>	
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(CHEKING,'N') = 'Y'
		</cfif>		
		AND CONVERT(DATETIME, Start_date, 103) BETWEEN CONVERT(DATETIME,'#frdate#',103) and CONVERT(DATETIME,'#todate#',103) 
<!--- 	AND CONVERT(DATETIME, Start_date, 103) BETWEEN CONVERT(DATETIME,'#Reg_date#',103) and CONVERT(DATETIME,'#Reg_date_TO#',103) 
		Order by REGISTRATION_DATE Desc --->
  </CFQUERY>
  


<CFIF not directoryexists("C:\NSEUCI\")>
	<CFDIRECTORY ACTION="CREATE" DIRECTORY="C:\NSEUCI\">
</CFIF>

<CFSET FILENAME = "C:\NSEUCI\CLT_STATUS_#DateFormat(Now(),"YYYYMMDD")#.T#batchNo#">
	<CFSET FILENAMELOG = "C:\NSEUCI\LOG_CLT_STATUS_#DateFormat(Now(),"YYYYMMDD")#.T#batchNo#">
	
	
<CFIF left(batchNo,1) eq '0'>
	<CFSET batchNo="#batchNo#">
</CFIF>

<CFIF FileExists('#FILENAME#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAME#"> 
</CFIF>

<CFIF FileExists('#FILENAMELOG#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAMELOG#"> 
</CFIF>
<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">
<!--- <CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="10|M|#GETTRADINGCODE.BROKER_CODE#|#DateFormat(Now(),'DDMMYYYY')#|#batchNo#|#getClientDetails.RECORDCOUNT##CHR(10)#" ADDNEWLINE="NO"> --->

<CFSET FINALSTRING = "">
<CFSET FINALSTRINGLOG = "">

<CFSET MissingBankDetails="Missing Bank Details For Clients :">
<CFSET MissingBankFLG=false>
<CFSET ERRORCODE = 0>
</cfoutput>

<!--- <CFIF COCD NEQ "CD_NSE">
	<CFSET SEGMENT = "C">
    <cfinclude template="GenerateUCITemplate.cfm">
	<CFSET SEGMENT = "F">
    <cfinclude template="GenerateUCITemplate.cfm">
<cfelse>
	<CFSET SEGMENT = "X">
    <cfinclude template="GenerateUCITemplate.cfm">	
</CFIF> --->
<cfoutput>
<CFSET TOTALCLIENTCOUNT = 0>
<CFLOOP QUERY="GETCLIENTLIST" > <!---  group="CLIENT_ID" groupcasesensitive="no" --->
	
	<CFSET ERRORCODE = 0>
	
  				<CFSET COMPANY_CODE						=		"#LEFT(TRIM(GETCLIENTLIST.COMPANY_CODE),15)#">
				<CFSET client_id 						= 		"#LEFT(TRIM(GETCLIENTLIST.client_id),20)#">
				<CFSET CLIENT_NATURE 						= 		"#LEFT(TRIM(GETCLIENTLIST.CLIENT_NATURE),1)#">
				<CFSET InActiveType						=		"#LEFT(TRIM(GETCLIENTLIST.InActiveType),50)#">
				<CFSET REGISTRATION_DATE 				=		"#LEFT(TRIM(GETCLIENTLIST.REGISTRATION_DATE),10)#">
				<CFSET active_inactive		= 		"#LEFT(TRIM(GETCLIENTLIST.active_inactive),1)#">
  


									
		<CFIF COMPANY_CODE EQ "BSE_CASH" OR COMPANY_CODE EQ  "NSE_CASH">
			<CFSET COMPANY_CODE1 = 'C'>
		<CFELSEIF COMPANY_CODE EQ "BSE_FNO" OR COMPANY_CODE EQ "NSE_FNO">
			<CFSET COMPANY_CODE1 = 'F'>
		<CFELSEIF COMPANY_CODE EQ "CD_NSE" OR COMPANY_CODE EQ  "CD_MCX"  OR COMPANY_CODE EQ "CD_BSE" OR COMPANY_CODE EQ "CD_USE" OR COMPANY_CODE EQ"CD_MCX">
			<CFSET COMPANY_CODE1 = 'X'>
		<CFELSE>
			<CFSET COMPANY_CODE = 'S'>
		</CFIF>
  
  <CFSET FINALSTRING = "#FINALSTRING##COMPANY_CODE1#|#client_id#|#active_inactive#|#InActiveType##CHR(10)#">
		
</CFLOOP>
<CFIF GETCLIENTLIST.recordcount eq 0>
	<SCRIPT>
		alert("No Data Found");
	</SCRIPT>
	<CFABORT>
</CFIF>



<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">


<CFFILE ACTION="READ" FILE="#FileName#" VARIABLE="FileData">

<CFIF FileExists('#FILENAME#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAME#"> 
</CFIF>

<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING#" ADDNEWLINE="NO">

<!--- <CFFILE ACTION="APPEND" FILE="#FILENAMELOG#" OUTPUT="#FileData#" ADDNEWLINE="No">		 --->


<CFSET	ClientFileGenerated	=	CopyFile("#FileName#","#FileName#")>
<!--- <CFSET	ClientFileGenerated1	=	CopyFile("#FILENAMELOG#","#FILENAMELOG#")> --->

<CFIF  ClientFileGenerated>
	<SCRIPT>
		alert("File Generated On Client Machine #REPLACE(FILENAME,'\','\\','ALL')#");
	</SCRIPT>
</CFIF>
<!--- 			
<CFIF ClientFileGenerated1>
	<SCRIPT>
		alert("Log File Generated on Client Machine #REPLACE(FILENAMELOG,'\','\\','ALL')#");
	</SCRIPT>
</CFIF> --->

FILE GENERATED On Your <A target="blank" HREF="FILE:\\#Server_NAme#\#Replace(FileName,":","")#">#FileName#.
</CFOUTPUT>
</body>
</html>
