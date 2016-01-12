<cfinclude template="/focaps/help.cfm">
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>VoucherValidation</title>
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


<CFOUTPUT>
<script language="vbscript">
	Function Export() 
		DIM sHTML, oExcel, fso, filePath 
		coval = ShortageJVProcess.COCD.value
		sHTML = "Company :" + coval +",User ID:#client.UserName# ,Creation Date #dateformat(now(),'DD/MM/YYYY')#-#timeformat(now(),'HH:MM')#, IP Address :#CLIENT.ClientIPAdd#<br>"
		sHTML = sHTML +LayerAuctClOutHeading.outerHTML 
 	    ShortageJVProcess.FileText.value = sHTML
	End Function 
</script> 
</CFOUTPUT>
	
<cfif IsDefined("FileText")>
	 <cfif NOT DirectoryExists("C:\CFUSIONMX7\WWWROOT\REPORTS\INWARDOUTWARTDEBIT")>
		<cfdirectory action="create" directory="C:\CFUSIONMX7\WWWROOT\REPORTS\INWARDOUTWARTDEBIT">
	</cfif>
	<cffile action="write" file="C:\CFUSIONMX7\WWWROOT\REPORTS\INWARDOUTWARTDEBIT\InwardOutShortDebit_#dateformat(now(),'DDMMYYYY')#_#timeformat(now(),'HHMM')#.HTML"  output="#FileText#">
</cfif>



	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">
</head>
<body CLASS="StyleBody1">
<CENTER>
	<H4>-:&nbsp;<U>Inward Shortage Process</U>&nbsp;:-</H4>
<CFFORM NAME="ShortageJVProcess" ACTION="ShortageJVProcess.cfm" METHOD="POST" ENABLECAB="No" PRESERVEDATA="Yes" ONSUBMIT="Export()">
<CFOUTPUT>
	
	<input type="Hidden" name="COCD" value="#COCD#">
	<input type="Hidden" name="COName" value="#COName#">
	<input type="Hidden" name="Market" value="#Market#">
	<input type="Hidden" name="Exchange" value="#Exchange#">
	<input type="Hidden" name="Broker" value="#Broker#">
	<input type="Hidden" name="StYr" value="#Val(Trim(StYr))#">
	<INPUT TYPE="HIDDEN" NAME="FileText" VALUE="">
<DIV ID="LayerAuctClOutHeading"	>

	Settlement No&nbsp;:&nbsp; 
 	<CFINPUT TYPE="Text" NAME="TxtSettlement_No" VALUE="" class="" MESSAGE="Enter valid Settlement No." VALIDATE="integer" REQUIRED="Yes" SIZE="8" MAXLENGTH="10">
  	<input type="Submit" accesskey="V" name="cmdView" value="View JV" class="StyleSmallButton1">
	<input type="Submit" accesskey="N" name="cmdProcess" value="Process JV" class="StyleSmallButton1" >
	<input type="Submit" accesskey="N" name="cmdDelete" value="Delete JV" class="StyleSmallButton1">
	<input type="Submit" accesskey="N" name="cmdUnSe" value="Un Settle JV" class="StyleSmallButton1">
<div style="position:absolute;top:20%;width:100%;height:80%;left:0; overflow:auto">
	<cfif IsDefined("TxtSettlement_No") And Trim(TxtSettlement_No) is not "">
	
	
		<cfif IsDefined("cmdUnSe")>
				<cfquery datasource="#Client.database#" name="Selece">
						select ACCOUNTCODE,SETTLEMENT_NO BSETTLEMENT_NO,
						SUM(DR_AMT) Debit,SUM(CR_AMT)  Credit
						from FA_TRANSACTIONS
						WHERE
							COCD			=	'#COCD#'
						AND		BILLNO			IN('11111','22222')
						AND		TRANS_TYPE		=	'J'
						AND SETTLEMENT_NO = '#TxtSettlement_No#'
						AND FINSTYR = #StYr#
						AND ACCOUNTCODE !='INWARDSHORTAGE'
						GROUP BY COCD,ACCOUNTCODE,SETTLEMENT_NO
						HAVING SUM(DR_AMT)!=SUM(CR_AMT)
						order by SETTLEMENT_NO,accountcode
				</cfquery>
				<cfdump var="#Selece#">
				<cfabort>
		</cfif>
		<cfif IsDefined("cmdDelete")>
			<cfquery datasource="#Client.database#" name="Delete">
					DECLARE @FA_POSTING		VARCHAR(20)
					SELECT	@FA_POSTING		=	FA_POSTING
					FROM
							COMPANY_MASTER
					WHERE
							COMPANY_CODE	=	'#COCD#'

					DELETE	FA_TRANSACTIONS
					WHERE
							COCD			=	@FA_POSTING
					AND		BILLNO			in ('22222','11111')
					AND		SETTLEMENT_NO	=	'#TxtSettlement_No#'
					AND 	FINSTYR = #StYr#
					AND		TRANS_TYPE		=	'J'
			</cfquery>
			<PRE><font COLOR="Red">Inward Shortage Deletetion Process for #val(TxtSettlement_No)#' Sucessfully Completed.	</FONT></pre>
			<cfabort>
		</cfif>
		<CFTRANSACTION>
			<cftry>
				<CFSTOREDPROC PROCEDURE="FA_POST_IOSHORTAGE" datasource="#Client.database#">
					<CFPROCPARAM DBVARNAME="@COCD" VALUE="#COCD#" CFSQLTYPE="CF_SQL_LONGVARCHAR">
					<CFPROCPARAM DBVARNAME="@FinStart" VALUE="#StYr#" CFSQLTYPE="CF_SQL_INTEGER">
					<CFPROCPARAM DBVARNAME="@Settlement_No" VALUE="#TxtSettlement_No#" CFSQLTYPE="CF_SQL_NUMERIC"> 
					<CFIF IsDefined("cmdView")>
						<CFPROCPARAM DBVARNAME="@PostJV" VALUE="No" CFSQLTYPE="CF_SQL_LONGVARCHAR"> 
					<CFELSE>
						<CFPROCPARAM DBVARNAME="@PostJV" VALUE="Yes" CFSQLTYPE="CF_SQL_LONGVARCHAR"> 
					</CFIF> 
					
					<CFPROCRESULT NAME="View">
				</CFSTOREDPROC>
				
				<CFIF IsDefined("cmdView")>
					<CFDUMP VAR="#View#" LABEL="ShortageReport"> 
				<CFELSE>
					<FONT COLOR="Blue"><BR><BR>
						Inward Shortage Process for #val(TxtSettlement_No)#' Sucessfully Completed.	
					</FONT>
				</CFIF>
				<CFTRANSACTION ACTION="COMMIT"/>
			<CFCATCH TYPE="Any">
				<PRE><font COLOR="Red">Error :#cfcatch.detail#</FONT></pre>
				<CFTRANSACTION ACTION="ROLLBACK"/>	
			</CFCATCH>		
			</CFTRY>
		</CFTRANSACTION>
	</CFIF>
	</div>

</DIV>	
</CFOUTPUT>
</CFFORM>
</CENTER>
</body>
</html>
