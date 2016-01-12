<!---- **************************************************************
	BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*************************************************************** ---->


<CFOUTPUT>


<CFIF IsDefined("Save")>
	<CFTRY>
		<CFTRANSACTION>
			<!----<CFIF	NDMktType is "T">
				<CFSET	ScripSymbol	=	"#REPLACE(ScripSymbol, '-TT', '')#-TT">
			</CFIF>----->
			<CFQUERY name="AddNewNDData" datasource="#Client.database#" dbtype="ODBC">
				Insert	BSE_ND_MASTER
				(
						  COMPANY_CODE
						, SCRIP_SYMBOL
						, MKT_TYPE
						, SETL_NO
						, CLOSING_PRICE
						, CF_SETL_NO
				)
			    Values
				(
						  '#UCase(Trim(COCD))#'
						, '#UCase(Trim(ScripSymbol))#'
						, '#UCase(Trim(NDMktType))#'
						, #Val(Trim(NDSetlNo))#
						, #Val(Trim(ClosingPrice))#
						, #Val(Trim(CFSetlNo))#
				)
			</CFQUERY>
		</CFTRANSACTION>
		
		<SCRIPT>
			var strUserNotes	=	"";
			strUserNotes		=	strUserNotes +"<font style='Color : Green;'> &raquo; ND-Data is successfully Saved for following parameters:<br>";
			strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Setl : '#UCase(Trim(NDMktType))# - #Val(Trim(NDSetlNo))#' Closing-Price : '#Val(Trim(ClosingPrice))#' Carry-Forward Setl-No : '#Val(Trim(CFSetlNo))#'. </font><br>";
			
			parent.UserNotes.innerHTML	=	strUserNotes;
			window.location.href = "NDMaster.cfm?#Query_String#";
		</SCRIPT>
	<CFCATCH type="Database">
		<SCRIPT>
			var strUserNotes	=	"";
			
			<CFIF IsDefined("CFCATCH.NativeErrorCode") AND CFCATCH.NativeErrorCode EQ 2627>
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; This ND-Data already exists. </font><br>";
			<CFELSE>
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; Errorcode : #CFCATCH.NativeErrorCode#<br>#CFCATCH.Detail#. </font><br>";
			</CFIF>
			
			parent.UserNotes.innerHTML	=	strUserNotes;
			window.history.back();
		</SCRIPT>
	</CFCATCH>
	</CFTRY>
</CFIF>

<CFIF	IsDefined("Update") Or 
		IsDefined("Delete")>
	
	<CFQUERY NAME="GetDate" datasource="#Client.database#" DBTYPE="ODBC">
		SELECT	
				CONVERT(VARCHAR(10), FROM_DATE, 103) FromDate,
				CONVERT(VARCHAR(10), TO_DATE, 103) ToDate
		FROM	
				SETTLEMENT_MASTER
		WHERE
				COMPANY_CODE	=	'#COCD#'
		AND		MKT_TYPE		=	'#trim(NDMktType)#'
		AND		SETTLEMENT_NO	=	#VAL(trim(NDSetlNo))#
	</CFQUERY>
	
	<CFSET	FromDate	=	"#GetDate.FromDate#">
	<CFSET	ToDate		=	"#GetDate.ToDate#">

</CFIF>


<CFIF IsDefined("Update")>
	<CFTRY>
		<CFSTOREDPROC procedure="NSE_NDMASTER_PREMODIFY_CHECK" datasource="#Client.database#" returncode="Yes">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#UCase(Trim(COCD))#" maxlength="8" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SCRIP" value="#UCase(Trim(ScripSymbol))#" maxlength="20" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROM_DATE" value="#Trim(FromDate)#" maxlength="10" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TO_DATE" value="#Trim(ToDate)#" maxlength="10" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ND_SETL_NO" value="#Val(Trim(NDSetlNo))#" maxlength="7" null="No">
			<CFPROCPARAM type="Out" cfsqltype="CF_SQL_CHAR" dbvarname="@PROCESS_MSG" variable="ProcessMsg" null="No">
			
			<CFPROCRESULT Name="GetNDMarkedSettlements">
		</CFSTOREDPROC>
		
		<CFIF Trim(ProcessMsg) EQ "0">
			<CFTRANSACTION>
				<CFIF	NDMktType is "T">
					<CFSET	ScripSymbol	=	"#REPLACE(ScripSymbol, '-TT', '')#-TT">
				</CFIF>
				<CFQUERY name="UpdateNDData" datasource="#Client.database#" dbtype="ODBC">
					Update	BSE_ND_MASTER
					Set
							  SCRIP_SYMBOL		=	'#UCase(Trim(ScripSymbol))#'
							, MKT_TYPE			=	'#UCase(Trim(NDMktType))#'
							, SETL_NO			=	#Val(Trim(NDSetlNo))#
							, CLOSING_PRICE		=	#Val(Trim(ClosingPrice))#
							, CF_SETL_NO		=	#Val(Trim(CFSetlNo))#
					Where	REC_NO				=	'#Val(Trim(RecordNo))#'
				</CFQUERY>
			</CFTRANSACTION>
			
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Green;'> &raquo; ND-Data is successfully Updated for following parameters:<br>";
				strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Setl : '#UCase(Trim(NDMktType))# - #Val(Trim(NDSetlNo))#' Closing-Price : '#Val(Trim(ClosingPrice))#' Carry-Forward Setl-No : '#Val(Trim(CFSetlNo))#'. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
				window.location.href = "NDMaster.cfm?#Query_String#";
			</SCRIPT>
		<CFELSEIF Trim(ProcessMsg) EQ "1">
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; ND-Data is NOT Updated, because some Settlements are being Marked for the following parameters:<br>";
				strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Setl : '#UCase(Trim(NDMktType))# - #Val(Trim(NDSetlNo))#' Closing-Price : '#Val(Trim(ClosingPrice))#' Carry-Forward Setl-No : '#Val(Trim(CFSetlNo))#'. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
				window.location.href = "NDMaster.cfm?#Query_String#";
			</SCRIPT>
		</CFIF>
	<CFCATCH type="Database">
		<SCRIPT>
			var strUserNotes	=	"";
			
			<CFIF IsDefined("CFCATCH.NativeErrorCode") AND CFCATCH.NativeErrorCode EQ 2627>
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; This ND-Data already exists. </font><br>";
			<CFELSE>
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; Errorcode : #CFCATCH.NativeErrorCode#<br>#CFCATCH.Detail#. </font><br>";
			</CFIF>
			
			parent.UserNotes.innerHTML	=	strUserNotes;
			window.history.back();
		</SCRIPT>
	</CFCATCH>
	</CFTRY>
</CFIF>


<CFIF IsDefined("Delete")>
	<CFTRY>
		
		<CFSTOREDPROC procedure="NSE_NDMASTER_PREMODIFY_CHECK" datasource="#Client.database#" returncode="Yes">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#UCase(Trim(COCD))#" maxlength="8" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SCRIP" value="#UCase(Trim(ScripSymbol))#" maxlength="20" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROM_DATE" value="#Trim(FromDate)#" maxlength="10" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TO_DATE" value="#Trim(ToDate)#" maxlength="10" null="No">
			<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ND_SETL_NO" value="#Val(Trim(NDSetlNo))#" maxlength="7" null="No">
			<CFPROCPARAM type="Out" cfsqltype="CF_SQL_CHAR" dbvarname="@PROCESS_MSG" variable="ProcessMsg" null="No">
			
			<CFPROCRESULT Name="GetNDMarkedSettlements">
		</CFSTOREDPROC>
		
		<CFIF Trim(ProcessMsg) EQ "0">
			<CFTRANSACTION>
				<CFQUERY name="DeleteNDData" datasource="#Client.database#" dbtype="ODBC">
					Delete	BSE_ND_MASTER
					Where	REC_NO	=	'#Val(Trim(RecordNo))#'
				</CFQUERY>
			</CFTRANSACTION>
			
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Green;'> &raquo; ND-Data is successfully Deleted for following parameters:<br>";
				strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Setl : '#UCase(Trim(NDMktType))# - #Val(Trim(NDSetlNo))#' Closing-Price : '#Val(Trim(ClosingPrice))#' Carry-Forward Setl-No : '#Val(Trim(CFSetlNo))#'. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
				window.location.href = "NDMaster.cfm?#Query_String#";
			</SCRIPT>
		<CFELSEIF Trim(ProcessMsg) EQ "1">
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; ND-Data is NOT Deleted, because some Settlements are being Marked for the following parameters:<br>";
				strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Setl : '#UCase(Trim(NDMktType))# - #Val(Trim(NDSetlNo))#' Closing-Price : '#Val(Trim(ClosingPrice))#' Carry-Forward Setl-No : '#Val(Trim(CFSetlNo))#'. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
				window.location.href = "NDMaster.cfm?#Query_String#";
			</SCRIPT>
		</CFIF>
	<CFCATCH type="Database">
		<SCRIPT>
			var strUserNotes	=	"";
			
			<CFIF IsDefined("CFCATCH.NativeErrorCode") AND CFCATCH.NativeErrorCode EQ 2627>
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; This ND-Data already exists. </font><br>";
			<CFELSE>
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; Errorcode : #CFCATCH.NativeErrorCode#<br>#CFCATCH.Detail#. </font><br>";
			</CFIF>
			
			parent.UserNotes.innerHTML	=	strUserNotes;
			window.history.back();
		</SCRIPT>
	</CFCATCH>
	</CFTRY>
</CFIF>


</CFOUTPUT>