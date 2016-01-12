
<cfif filefor eq "New3">

<CFQUERY name="gETsYSVAL" datasource="#CLIENT.DATABASE#">
	SELECT ISNULL(SEPRATECDNSE,'N') SEPRATECDNSE FROM SYSTEM_SETTINGS
</CFQUERY>

<CFSET sepFile = gETsYSVAL.SEPRATECDNSE>

	<Cfif not IsDefined("BROKERAGE1")>
		<Cfif IsDefined("Brokerage")>
			<Cfset BROKERAGE1 ='Y'>
		<cfelse>
			<Cfset BROKERAGE1 ='N'>
		</Cfif>
	</Cfif>
	<cFSET frdate =txtDate>
	<cFSET todate =txtToDate>


	<cFSET market =cmbmarket>
	
	<Cfif not IsDefined("chkval")>
				<cFSET chkval="">
				<cFSET chkval1="">
				<CFLOOP INDEX="i" FROM="1" TO="#Sr#">	
					<CFIF IsDefined("chk#i#")>
						<CFSET	chkval	=	"#chkval#'#Trim(Evaluate("chk#i#"))#',">
						<CFIF IsDefined("companychk#i#") and Evaluate("companychk#i#") eq 'bse_cash'>
							<CFSET	chkval1	=	"#chkval1##Trim(Evaluate("chk#i#"))#,">
						</CFIF>
					</CFIF>
				</CFLOOP>	
				<cFSET Sr = I>
	</Cfif>
	<cfset market1 = 'All'>
	
	<cfif sepFile eq "Y">
		<CFQUERY NAME="GetCom" datasource="#Client.database#" DBTYPE="ODBC">
			select company_code from company_Master where  COMPANY_CODE in ('NSE_CASH','NSE_FNO') 
		</CFQUERY>
		<cFIF GetCom.RECORDCOUNT GT 0>
			<cfset cocd = GetCom.company_code>
			<cfset market = ''>
			<cfset sepFile1 = 'Y'>

			<cfquery name="Spdate" datasource="#client.database#">
				select AutoIncrBatch ,AutoIncrBatchDate from system_settings
				where  COMPANY_CODE in ('NSE_CASH','NSE_FNO','CD_NSE')

			</cfquery>
		
			<cfif DateFormat(Spdate.AutoIncrBatchDate,'ddmmyyyy') neq DateFormat(now(),'ddmmyyyy')>
				<cfquery name="Update" datasource="#client.database#">
					update system_settings
					set AutoIncrBatchDate = convert(datetime,convert(varchar(10),getdate(),103),103),
						AutoIncrBatch	  = 01
					where  COMPANY_CODE in ('NSE_CASH','NSE_FNO','CD_NSE')

				</cfquery>
			</cfif>
		
			<cfif DateFormat(Spdate.AutoIncrBatchDate,'ddmmyyyy') eq DateFormat(now(),'ddmmyyyy')>
					<cFSET batchNo = Spdate.AutoIncrBatch>
			<cfelse>
				<cFSET batchNo = 01>
			</cfif>
		
			<cfquery name="Update" datasource="#client.database#">
				update system_settings
				set AutoIncrBatch = #batchNo# + 1
				where  COMPANY_CODE in ('NSE_CASH','NSE_FNO','CD_NSE')
			</cfquery>
		
			<cfif len(batchNo) eq 1>
				<cfset batchNo = "0#batchNo#">
			<cfelse>		
				<cfset batchNo = "#batchNo#">
			</cfif>

			<cfinclude template="generateUCINEW3.cfm">
			
		</cFIF>

		<CFQUERY NAME="GetComN" datasource="#Client.database#" DBTYPE="ODBC">
			select company_code from company_Master where  COMPANY_CODE in ('CD_NSE') 
		</CFQUERY>
		<cFIF GetComN.RECORDCOUNT GT 0>
			<cfset cocd = GetComN.company_code>
			<cfset market = ''>

			<cfinclude template="generateUCINEW3_CDNSE.cfm">
		</cFIF>
	<cfelse>
		<CFQUERY NAME="GetCom" datasource="#Client.database#" DBTYPE="ODBC">
			select company_code from company_Master where  COMPANY_CODE in ('NSE_CASH','NSE_FNO','CD_NSE') 
		</CFQUERY>
		<cFIF GetCom.RECORDCOUNT GT 0>
			<cfset cocd = GetCom.company_code>
			<cfset market = ''>
			<cfset sepFile1 = 'N'>

			<cfquery name="Spdate" datasource="#client.database#">
				select AutoIncrBatch ,AutoIncrBatchDate from system_settings
				where  COMPANY_CODE in ('NSE_CASH','NSE_FNO')
			</cfquery>
		
			<cfif DateFormat(Spdate.AutoIncrBatchDate,'ddmmyyyy') neq DateFormat(now(),'ddmmyyyy')>
				<cfquery name="Update" datasource="#client.database#">
					update system_settings
					set AutoIncrBatchDate = convert(datetime,convert(varchar(10),getdate(),103),103),
						AutoIncrBatch	  = 01
					where  COMPANY_CODE in ('NSE_CASH','NSE_FNO')
				</cfquery>
			</cfif>
		
			<cfif DateFormat(Spdate.AutoIncrBatchDate,'ddmmyyyy') eq DateFormat(now(),'ddmmyyyy')>
				<cfif val(batchNoFront) neq Spdate.AutoIncrBatch>
					<cFSET batchNo = val(batchNoFront)>
				<cfelse>
					<cFSET batchNo = Spdate.AutoIncrBatch>
				</cfif>		
			<cfelse>
				<cFSET batchNo = 01>
			</cfif>
		
			<cfquery name="Update" datasource="#client.database#">
				update system_settings
				set AutoIncrBatch = #batchNo# + 1
				where  COMPANY_CODE in ('NSE_CASH','NSE_FNO')
			</cfquery>
		
			<cfif len(batchNo) eq 1>
				<cfset batchNo = "0#batchNo#">
			<cfelse>		
				<cfset batchNo = "#batchNo#">
			</cfif>

			<cfinclude template="generateUCINEW3.cfm">
		</cFIF>
	</cfif> 
	
	<cfset market = 'All'>
	<CFQUERY NAME="GetComb" datasource="#Client.database#" DBTYPE="ODBC">
		select company_code from company_Master where  COMPANY_CODE in ('BSE_CASH') 
	</CFQUERY>
	<cfloop query="GetComb">
		<Cfset cocd =company_code>
		<Cfset Format1 ='New'>
		<cfinclude template="New4UccWebX.cfm">
	</cfloop>
	<CFQUERY NAME="GetComc" datasource="#Client.database#" DBTYPE="ODBC">
		select company_code from company_Master where  COMPANY_CODE in ('cd_mcx','mcx_cash','mcx_fno','MCX','NCDEX') 
		order by company_code
	</CFQUERY>
	<cfloop query="GetComc">
		<Cfset cocd =COMPANY_CODE>
		<cFIF cocd  EQ 'mcx'>
				<Cfset ActiveInactive  ='ACTIVE'>
				<Cfset cmbFileType  ='New'>
				<!--- <cfinclude template="generateUCIMCX.cfm"> --->
				<cfinclude template="McxgenerateUCINEW3.cfm">
				
		<cfelseif cocd eq 'ncdex'>
				<Cfset ActiveInactive  ='ACTIVE'>
				<Cfset cmbFileType  ='New'>
				<cfinclude template="generateUCINcdex.cfm">
		<cfelse>
				<cfinclude template="McxgenerateUCINEW3.cfm">
		</cFIF>
	</cfloop> 
	<cfscript>
		function XMLConvertString( inputStr, length, strAlignMent)	
		{
			var inputString = left(trim(inputStr),length);
			inputString = "<"&strAlignMent&">"&inputString& "</"&strAlignMent&">" & Chr(10);
			return inputString;
		}
	
	</cfscript>
	
	<cffunction name="DateC" access="public" returntype="string">
		<cfargument name="Date1" type="string" required="true">
				<cfset Date1 = DateFormat(Date1,'DD/MM/YYYY')>
		<cfreturn Date1>
	</cffunction>
	

	<cfset Intermediary_Role = '01'>
	<cfinclude template="../../../KRA/ExportData/CDSLKRAFILE_I.cfm">
	<cfinclude template="../../../KRA/ExportData/CDSLKRAFILE_N.cfm">
	       
	<A HREF="javascript: history.back(-1);">Back</A>
<cfelse>
	<Cfif not IsDefined("BROKERAGE1")>
		<Cfif IsDefined("Brokerage")>
			<Cfset BROKERAGE1 ='Y'>
		<cfelse>
			<Cfset BROKERAGE1 ='N'>
		</Cfif>
	</Cfif>
	<cFSET frdate =txtDate>
	<cFSET todate =txtToDate>
	<cFSET batchNo = txtBatchNo>
	<cFSET market =cmbmarket>
	
	<Cfif not IsDefined("chkval")>
				<cFSET chkval="">
				<cFSET chkval1="">
				<CFLOOP INDEX="i" FROM="1" TO="#Sr#">	
					<CFIF IsDefined("chk#i#")>
						<CFSET	chkval	=	"#chkval#'#Trim(Evaluate("chk#i#"))#',">
						<CFIF IsDefined("companychk#i#") and Evaluate("companychk#i#") eq 'bse_cash'>
							<CFSET	chkval1	=	"#chkval1##Trim(Evaluate("chk#i#"))#,">
						</CFIF>
					</CFIF>
				</CFLOOP>	
				<cFSET Sr = I>
	</Cfif>
	
	<cfset market = 'All'>
	<CFQUERY NAME="GetComb" datasource="#Client.database#" DBTYPE="ODBC">
		select company_code from company_Master where  COMPANY_CODE in ('BSE_CASH') 
	</CFQUERY>
	<cfloop query="GetComb">
		<Cfset cocd =company_code>
		<Cfset Format1 ='modified'>
		<cfinclude template="UCC_ActiveInactive.cfm">
	</cfloop>
	<cfoutput>
		<CFSET	ClientFileGenerated1	=	CopyFile("#FILENAMELOG#","#FILENAMELOG#")>
		<CFIF ClientFileGenerated1>
					Log File Generated On Client Machine #REPLACE(FILENAMELOG,'\','\\','ALL')#<br>
		<cfelse>
					Log File Generated Not Generate On Client Machine #REPLACE(FILENAMELOG,'\','\\','ALL')#<br>
		</CFIF>
	</cfoutput>
	<A HREF="javascript: history.back(-1);">Back</A>
</cfif>