<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<title>Active Inactive</title>
<link href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="../../CSS/Bill.css" type="text/css" rel="stylesheet">
</head>
<STYLE>
	DIV#FOOTER
	{
		Position: Absolute;
		Left: 0;
		Top: 56%;
		Bottom: 0;
		Height: 8%;
		Width: 100%;		
	}
</STYLE>
<BODY CLASS="StyleBody1">
<CFOUTPUT>	
<CFSET FINALSTRING1 = "">
<CFSET FINALSTRINGLOG1  = "">
<CFPARAM NAME="batchNo" DEFAULT="">
<CFSET UpdateRow	=	0>
<!--- <CFIF left(batchNo,1) eq '0'>
	<CFSET batchNo="#batchNo#">
</CFIF>
 --->
<cfloop index="i" from="1" to="#Sr#">
<CFSET batchNo="#i#">
</cfloop>	
<!--- <CFSET Filename = "C:\WEBXUCC\#EXCHANGE#_UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt"> --->
 <CFSET Filename = "C:\BSE_UCC\CLT_STATUS_#DateFormat(Now(),"YYYYMMDD")#.T0#batchNo#">
<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">




<!--- <CFIF left(batchNo,1) eq '0'>
	
</CFIF> --->

<CFLOOP INDEX="i" FROM="1" TO="#Sr#">	

<CFIF IsDefined("chk#i#")>
			<CFSET	Client_ID	=	Trim(Evaluate("chk#i#"))><!--- " VALUE="#Client_id#" CLASS="StyleCheckBox"> --->
			<CFSET UpdateRow	=	IncrementValue(UpdateRow)>
		<CFQUERY  NAME="GetActiveInactive" datasource="#Client.database#">
			Select DISTINCT a.COMPANY_CODE,
		a.client_id,client_name,CLIENT_NATURE,REGISTRATION_DATE,Last_Modified_date,active_inactive,B.InActiveType
									from client_master a , brokerage_apply b
									Where
									a.Company_code = b.company_code
									and a.client_id = b.client_id
									and a.Company_code = '#COCD#'
									AND ISNULL(END_DATE ,'') = ''
									And	a.Client_id	=	'#Client_ID#'	
		</CFQUERY>
		
		
		
		<CFSET COMPANY_CODE = "#LEFT(TRIM(GETACTIVEINACTIVE.COMPANY_CODE),15)#">
		<CFSET client_id = "#GETACTIVEINACTIVE.client_id#">
		<CFSET ACTIVE_INACTIVE	= "#GETACTIVEINACTIVE.ACTIVE_INACTIVE#">	
		<CFSET InActiveType	 = "#GETACTIVEINACTIVE.InActiveType#">	

									
		<CFIF COMPANY_CODE EQ "BSE_CASH" OR COMPANY_CODE EQ  "NSE_CASH">
			<CFSET COMPANY_CODE = 'C'>
		<CFELSEIF COMPANY_CODE EQ "BSE_FNO" OR COMPANY_CODE EQ "NSE_FNO">
			<CFSET COMPANY_CODE = 'F'>
		<CFELSEIF COMPANY_CODE EQ "CD_NSE" OR COMPANY_CODE EQ "CD_MCX" >
			<CFSET COMPANY_CODE = 'X'>
		<CFELSE>
			<CFSET COMPANY_CODE = 'S'>
		</CFIF>
		<CFSET FINALSTRING1 = "#FINALSTRING1##LEFT(COMPANY_CODE,10)#|#LEFT(client_id,10)#|#LEFT(ACTIVE_INACTIVE,1)#|#TRIM(LEFT(InActiveType,200))##chr(10)#">
	</cfif>
	</CFLOOP>
	
	<cfif UpdateRow eq 0>
					<SCRIPT>
				alert("Please Select Atlest One Client");
				history.back();
				</SCRIPT>				
			<CFELSE>
				<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING1#" ADDNEWLINE="YES">
				<!--- <CFFILE ACTION="APPEND" FILE="#FilenameLog#" OUTPUT="#FINALSTRING1Log#" ADDNEWLINE="YES"> --->
					<DIV ALIGN="CENTER" CLASS="FOOTER">
					<br><br>FILE GENERATED On Server's  <A target="blank" HREF="FILE:\\#Server_NAme#\#Replace(FileName,":","")#">#FileName#.</A><BR>
					<!--- Log FILE GENERATED On Server's  <A target="blank" HREF="FILE:\\#Server_NAme#\#Replace(FilenameLog,":","")#"> #FilenameLog#.---></a><BR>
					<!--- Please Refer Log File. --->	<BR>
				<A HREF="javascript: history.back(-1)">Back</A>
			</DIV>			
	
				<cfset ClientFileName  = "C:\\BSE_UCC\\CLT_STATUS_#DateFormat(Now(),"YYYYMMDD")#.T0#batchNo#">
				<!--- <cfset ClientFileNameLog  = "C:\BSE_UCC\Log_UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt"> --->

				<SCRIPT LANGUAGE="VBScript">
				newfolderpath = "c:\BSE_UCC" 
				Set FileSys = CreateObject("Scripting.FileSystemObject")
				If Not filesys.FolderExists(newfolderpath) Then 
					 Set newfolder = filesys.CreateFolder(newfolderpath) 
				End If
				</SCRIPT>
		
				<CFSET	ClientFileGenerated	=	CopyFile("#FILENAME#","#ClientFileName#")>
				<!--- <CFSET	ClientFileGenerated1	=	CopyFile("#FilenameLog#","#ClientFileNameLog#")> --->
				
				<CFIF  ClientFileGenerated>
					<SCRIPT>
					
						alert("File Generated On Client Machine : #ClientFileName#");
					</SCRIPT>
				</CFIF>
			
					<!--- <CFIF ClientFileGenerated1>
					<SCRIPT>
					alert("Log File Generated on Client Machine #ClientFileNameLog#");
					</SCRIPT>
				</CFIF> --->
			</CFIF>
	
</CFOUTPUT>
</body>
</html>
