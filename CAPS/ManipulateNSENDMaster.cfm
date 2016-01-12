<!---- **************************************************************
	BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*************************************************************** ---->


<CFOUTPUT>


<CFIF IsDefined("Save")>
	<CFTRY>
		<CFTRANSACTION>
			<CFQUERY name="AddNewNDData" datasource="#Client.database#" dbtype="ODBC">
				Insert	NSE_ND_MASTER
				(
						  COMPANY_CODE
						, SCRIP_SYMBOL
						, FROM_DATE
						, TO_DATE
						, NDOPEN_MKT_TYPE
						, NDOPEN_SETL_NO
				)
			    Values
				(
						  '#UCase(Trim(COCD))#'
						, '#UCase(Trim(ScripSymbol))#'
						, Convert( DateTime, '#Trim(FromDate)#', 103 )
						, Convert( DateTime, '#Trim(ToDate)#', 103 )
						, '#UCase(Trim(NDMktType))#'
						, #Val(Trim(NDSetlNo))#
				)
			</CFQUERY>
		</CFTRANSACTION>
		
		<SCRIPT>
			var strUserNotes	=	"";
			strUserNotes		=	strUserNotes +"<font style='Color : Green;'> &raquo; ND-Data is successfully Saved for following parameters:<br>";
			strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Date : '#Trim(FromDate)#' To-Date : '#Trim(ToDate)#' ND-Open-Setl : '#UCase(Trim(NDMktType))# - #Val(Trim(NDSetlNo))#'. </font><br>";
			
			parent.UserNotes.innerHTML	=	strUserNotes;
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
	
	<SCRIPT>
		window.location.href	=	"NDMaster.cfm?#Query_String#";
	</SCRIPT>
</CFIF>


<CFIF IsDefined("Update")>
	<CFTRY>
		<CFIF	( ( DateCompare( DateFormat(Trim(ToDate), "DD/MM/YYYY"), DateFormat(Trim(OldToDate), "DD/MM/YYYY") ) EQ 1 ) AND 
				( UCase(Trim(OldNDMktType)) EQ UCase(Trim(NDMktType)) ) AND 
				( Val(Trim(OldNDSetlNo)) EQ Val(Trim(NDSetlNo)) ) )>
			
			<CFSET ProcessMsg	=	0>
		<CFELSEIF	( ( DateCompare( DateFormat(Trim(ToDate), "DD/MM/YYYY"), DateFormat(Trim(OldToDate), "DD/MM/YYYY") ) EQ 1 ) AND 
				( UCase(Trim(OldNDMktType)) NEQ UCase(Trim(NDMktType)) ) OR 
				( Val(Trim(OldNDSetlNo)) NEQ Val(Trim(NDSetlNo)) ) )>
			
			<CFSTOREDPROC procedure="NSE_NDMASTER_PREMODIFY_CHECK" datasource="#Client.database#" returncode="Yes">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COMPANY_CODE" value="#UCase(Trim(COCD))#" maxlength="8" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@SCRIP" value="#UCase(Trim(ScripSymbol))#" maxlength="20" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FROM_DATE" value="#Trim(FromDate)#" maxlength="10" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@TO_DATE" value="#Trim(ToDate)#" maxlength="10" null="No">
				<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ND_SETL_NO" value="#Val(Trim(OldNDSetlNo))#" maxlength="7" null="No">
				<CFPROCPARAM type="Out" cfsqltype="CF_SQL_CHAR" dbvarname="@PROCESS_MSG" variable="ProcessMsg" null="No">
				
				<CFPROCRESULT Name="GetNDMarkedSettlements">
			</CFSTOREDPROC>
		<CFELSE>
			<SCRIPT>
				parent.UserNotes.innerHTML	=	"";
			</SCRIPT>
		</CFIF>
		
		<CFIF	( IsDefined("ProcessMsg") AND Trim(ProcessMsg) EQ "0" )>
			<CFTRANSACTION>
				<CFQUERY name="UpdateNDData" datasource="#Client.database#" dbtype="ODBC">
					Update	NSE_ND_MASTER
					Set		  SCRIP_SYMBOL		=	'#UCase(Trim(ScripSymbol))#'
							, FROM_DATE			=	Convert( DateTime, '#Trim(FromDate)#', 103 )
							, TO_DATE			=	Convert( DateTime, '#Trim(ToDate)#', 103 )
							, NDOPEN_MKT_TYPE	=	'#UCase(Trim(NDMktType))#'
							, NDOPEN_SETL_NO	=	#Val(Trim(NDSetlNo))#
					Where	REC_NO				=	'#Val(Trim(RecordNo))#'
				</CFQUERY>
			</CFTRANSACTION>
			
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Green;'> &raquo; ND-Data is successfully Updated for following parameters:<br>";
				strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Date : '#Trim(FromDate)#' To-Date : '#Trim(OldToDate)#' ND-Open-Setl : '#UCase(Trim(OldNDMktType))# - #Val(Trim(OldNDSetlNo))#'. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
			</SCRIPT>
		<CFELSEIF	( IsDefined("ProcessMsg") AND Trim(ProcessMsg) EQ "1" )>
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; ND-Data is NOT Updated, because some Settlements are being Marked for the following parameters:<br>";
				strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Date : '#Trim(FromDate)#' To-Date : '#Trim(OldToDate)#' ND-Open-Setl : '#UCase(Trim(OldNDMktType))# - #Val(Trim(OldNDSetlNo))#'. </font><br>";
				strUserNotes		=	strUserNotes +"<font style='Color : Blue;'> &raquo; <a title='Click to view the List of Settlements being Marked in \"No-Delivery\".' style='Font-Weight : Bold; Color : Brown; Cursor : Hand;' onClick='JavaScript : open( \"NDMarkedSetlsList.cfm?#Query_String#&ListNDMarkedSetls=#ValueList(GetNDMarkedSettlements.NDMARKEDSETL)#&Scrip=#UCase(Trim(ScripSymbol))#&FromDate=#Trim(FromDate)#&ToDate=#Trim(OldToDate)#&NDOMktType=#UCase(Trim(OldNDMktType))#&NDOSetlNo=#Val(Trim(OldNDSetlNo))#\", \"NDMarkedSetlsPopup\", \"Top=100, Left=100, Width=600, Height=250\" );'> <u>Click here</u> </a> to view the List of Settlements being Marked in 'No-Delivery'. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
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
	
	<SCRIPT>
		window.location.href	=	"NDMaster.cfm?#Query_String#";
	</SCRIPT>
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
					Delete	NSE_ND_MASTER
					Where	REC_NO	=	'#Val(Trim(RecordNo))#'
				</CFQUERY>
			</CFTRANSACTION>
			
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Green;'> &raquo; ND-Data is successfully Deleted for following parameters:<br>";
				strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Date : '#Trim(FromDate)#' To-Date : '#Trim(ToDate)#' ND-Open-Setl : '#UCase(Trim(NDMktType))# - #Val(Trim(NDSetlNo))#'. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
			</SCRIPT>
		<CFELSEIF Trim(ProcessMsg) EQ "1">
			<SCRIPT>
				var strUserNotes	=	"";
				strUserNotes		=	strUserNotes +"<font style='Color : Red;'> &raquo; ND-Data is NOT Deleted, because some Settlements are being Marked for the following parameters:<br>";
				strUserNotes		=	strUserNotes +"&raquo; Scrip-Symbol : '#UCase(Trim(ScripSymbol))#' From-Date : '#Trim(FromDate)#' To-Date : '#Trim(ToDate)#' ND-Open-Setl : '#UCase(Trim(NDMktType))# - #Val(Trim(NDSetlNo))#'. </font><br>";
				strUserNotes		=	strUserNotes +"<font style='Color : Blue;'> &raquo; <a title='Click to view the List of Settlements being Marked in \"No-Delivery\".' style='Font-Weight : Bold; Color : Brown; Cursor : Hand;' onClick='JavaScript : open( \"NDMarkedSetlsList.cfm?#Query_String#&ListNDMarkedSetls=#ValueList(GetNDMarkedSettlements.NDMARKEDSETL)#&Scrip=#UCase(Trim(ScripSymbol))#&FromDate=#Trim(FromDate)#&ToDate=#Trim(ToDate)#&NDOMktType=#UCase(Trim(NDMktType))#&NDOSetlNo=#Val(Trim(NDSetlNo))#\", \"NDMarkedSetlsPopup\", \"Top=100, Left=100, Width=600, Height=250\" );'> <u>Click here</u> </a> to view the List of Settlements being Marked in 'No-Delivery'. </font><br>";
				
				parent.UserNotes.innerHTML	=	strUserNotes;
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
	
	<SCRIPT>
		window.location.href	=	"NDMaster.cfm?#Query_String#";
	</SCRIPT>
</CFIF>


</CFOUTPUT>