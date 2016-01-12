<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Import DBF</title>
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
</head>
<body style="font: 9pt Tahoma;">

<CFFORM ACTION="IMPORT_MASTER_DBF.cfm" METHOD="POST" ENABLECAB="Yes">

  <CFQUERY NAME="CoList" datasource="#Client.database#" DBTYPE="ODBC">
  	Select company_code from company_master 
	Where
			Market	=	'CAPS'
  </CFQUERY>
  
  Company Code&nbsp;:&nbsp; 
  <cfselect name="CmbCoList" query="CoList" value="company_code" display="company_code" required="Yes">
  </cfselect>
  &nbsp;&nbsp;<INPUT TYPE="Submit" NAME="cmdImportMaster" VALUE="Import Master">
  &nbsp;&nbsp;<INPUT TYPE="Submit" NAME="cmdImportBrokerage" VALUE="Import Brokerage">
  &nbsp;&nbsp;<INPUT TYPE="Submit" NAME="cmdImportClientBrk" VALUE="Import Client - Brokerage Relation">
    
  <BR><BR>
  >>	All file should be In C:\DBFData.<BR>
  >>	File Name for "Client Master" is "CapsAdd.dbf".<BR>
  >>	File Name for "Brokerage Master" is "BrkOff.dbf".<BR>
  >>	File Name for "Client Brokerage Relation" is "CBrkCl.dbf".
  <BR><BR>
  <CFIF IsDefined("cmdImportMaster")>
  	<CFOUTPUT>
		<CFQUERY NAME="GetExchange" datasource="#Client.database#" DBTYPE="ODBC">
			Select	Market
			From
					Company_Master
			Where
					company_code = '#CmbCoList#'
		</CFQUERY>
		
		<CFSET Market	=	GetExchange.Market>
		
			<CFQUERY NAME="GetAddress" DBTYPE="Dynamic" connectstring="Driver={Microsoft dBASE Driver (*.dbf)}; DriverID=277; ">
				SELECT		* 						
				FROM		C:\DBFData\CapsAdd.dbf
				WHERE 		LEFT(TRIM(MSACCODE), 1) <> 'Z' 
				AND  		LEFT(TRIM(MSACCODE), 2) <> '99';
			</CFQUERY>
			
			<CFLOOP QUERY="GetAddress">
				<CFQUERY Name="AddNewClient" datasource="#Client.database#" DBType="ODBC">
					If Not Exists
					(
						Select	Top 1 RTrim(CLIENT_ID)
						From	CLIENT_MASTER
						Where
									COMPANY_CODE	=	'#Trim(CmbCoList)#'
								And CLIENT_ID		=	'#Trim(MSACCODE)#'
					)
					Begin
									Insert	CLIENT_MASTER
									(
										  COMPANY_CODE, CLIENT_ID, CLIENT_NAME, BRANCH_CODE, REGISTRATION_DATE
										, LAST_MODIFIED_DATE, PRO, CLIENT_NATURE, CLIENT_TYPE
									)
									Values
									(
										  '#UCase(Trim(CmbCoList))#', '#UCase(Trim(MSACCODE))#', '#UCase(Trim(MSPTYNAM))#'
										, 'MAIN', GetDate(), GetDate(), 'N', 'C', 'T'
									)
								End
							</CFQUERY>
				
					<CFTRY>
						<CFQUERY Name="AddClientDetails" datasource="#Client.database#" DBType="ODBC">
							Insert	CLIENT_DETAILS
							(
									CLIENT_ID,RESI_ADDRESS,RESI_TEL_NO,
									INTRODUCER_NAME
							)
					        Values
							(
									  '#UCase(Trim(MSACCODE))#', '#UCase(Trim(MSADDRL1))#~#UCase(Trim(MSADDRL2))#~#UCase(Trim(MSADDRL3))# #UCase(Trim(MSADDRL4))# #UCase(Trim(MSADDRL5))#'
										, '#UCase(Trim(MSADDRL6))#', '#UCase(Trim(MSADDRL7))#'
							)
						</CFQUERY>
					<CFCATCH TYPE="Database">
						<CFIF	CFCATCH.NativeErrorCode	EQ 2627>
						
						<CFELSE>
							<FONT COLOR="Red">
								#CFCATCH.DETAIL#
							</FONT>	
						</CFIF>
					</CFCATCH>
					</CFTRY>
					
					<CFSTOREDPROC Procedure="FACLIENT_CREATION" datasource="#Client.database#" ReturnCode="Yes">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ACTION" value="CREATE FA ACCOUNT" maxlength="15" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COCD" value="#UCase(Trim(CmbCoList))#" maxlength="10" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENTID" value="#UCase(Trim(MSACCODE))#" maxlength="20" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENTNAME" value="#UCase(Trim(MSPTYNAM))#" maxlength="100" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FA_COCD" value="#UCase(Trim(CmbCoList))#" maxlength="10" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@FINSTART" value="2004" maxlength="4" null="No">
						<CFPROCPARAM type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@FINEND" value="2005" maxlength="4" null="No">
					</CFSTOREDPROC>
			</CFLOOP>
	</CFOUTPUT>	
  </CFIF>

  <CFIF IsDefined("cmdImportBrokerage")>
	<CFQUERY NAME="GetBrk" DBTYPE="Dynamic" connectstring="Driver={Microsoft dBASE Driver (*.dbf)}; DriverID=277; ">
		SELECT		* 						
		FROM		C:\DBFData\BrkOff.dbf
		WHERE		
					SBCURTP	IN ('1','2','5')
		AND	SBBRKSLB = 'PI'
		Order By 	
				SBBRKSLB;
	</CFQUERY>		

	<CFQUERY NAME="DeleteData" datasource="#Client.database#" DBTYPE="ODBC">
		Delete From Brokerage_master
		Where
				company_code = '#CmbCoList#'
	</CFQUERY>

	<CFQUERY NAME="DeleteData1" datasource="#Client.database#" DBTYPE="ODBC">
		Delete From Brokerage_details
		Where
				company_code = '#CmbCoList#'
	</CFQUERY>

	<CFQUERY NAME="GetExchange" datasource="#Client.database#" DBTYPE="ODBC">
		Select	Exchange
		From
				Company_Master
		Where
				company_code = '#CmbCoList#'
	</CFQUERY>
	
	<CFSET Exchange_Code	=	GetExchange.Exchange>
	

	<CFOUTPUT QUERY="GetBrk">
		<cfif Len(Trim(SBBRKSLB)) gt 0>
		<CFQUERY NAME="GetLatestModule" datasource="#Client.database#" DBTYPE="ODBC">
			Select	IsNull(Max(Module_No), 0) ModuleNo
			From
					Brokerage_Master
			Where
					Company_Code	=	'#CmbCoList#'
			
		</CFQUERY>
		
		<CFIF	GetLatestModule.ModuleNo eq 0>
			<CFSET	ModuleNo	=	"1">
		<CFELSE>
			<CFSET	ModuleNo	=	VAL(GetLatestModule.ModuleNo) + 1>
		</CFIF>
					   
		<cftry>
			<cfquery name="InsertBrokModule" datasource="#Client.database#" dbtype="ODBC">
			if not exists(select DESCRIPTION 
			   			  From
						  		 Brokerage_Master
						  Where
						  		 Company_Code	=	'#CmbCoList#'
						  And	 Description	=	'#Trim(UCase(SBBRKSLB))#'
						 )
			Begin			 
				Insert Into BROKERAGE_MASTER
				(
					COMPANY_CODE,MODULE_NO, 
					DESCRIPTION
				)
				Values
				(
					'#UCase(CmbCoList)#','#Trim(UCase(ModuleNo))#', 
					'#Trim(UCase(SBBRKSLB))#'
				)
			End	
			</cfquery>
		<cfcatch TYPE="Database">
			<CFIF	CFCATCH.NativeErrorCode	EQ 2627>
			
			<CFELSE>
				#CFCATCH.DETAIL#
			</CFIF>
		</CFCATCH>	
		</CFTRY>
		</CFIF>		
	</CFOUTPUT>	

	<CFOUTPUT QUERY="GetBrk">
	
		<CFQUERY NAME="GetLatestModule" datasource="#Client.database#" DBTYPE="ODBC">
			Select	Module_No ModuleNo
			From
					Brokerage_Master
			Where
					Company_Code	=	'#CmbCoList#'
			And	 Description	=	'#Trim(UCase(SBBRKSLB))#'
			
		</CFQUERY>
		
		<CFSET	ModuleNo	=	VAL(GetLatestModule.ModuleNo)>
	
		<cfif Len(Trim(SBBRKSLB)) gt 0>
	
  		  <CFIF LEN(Trim(SBBOKCOD)) GT 0>
			<CFIF Exchange_Code IS "NSE">
				<CFIF	SBBOKCOD IS "T">
					<CFSET	MKT_TYPE = "N">
				<CFELSEIF SBBOKCOD IS "Q">
					<CFSET	MKT_TYPE = "T">
				<CFELSEIF SBBOKCOD IS "R">
					<CFSET	MKT_TYPE = "A">
				</CFIF>
			</CFIF>
	
			<CFIF Exchange_Code IS "BSE">
				<CFIF	SBBOKCOD IS "M">
					<CFSET	MKT_TYPE = "N">
				<CFELSEIF SBBOKCOD IS "O">
					<CFSET	MKT_TYPE = "T">
				<CFELSEIF SBBOKCOD IS "B">
					<CFSET	MKT_TYPE = "A">
				</CFIF>
			</CFIF>

			<CFIF	not Isdefined("Mkt_Type")>
				<br>#SBBOKCOD#    Incorrect File...
				<CFABORT>
			</cfif>
					

		<CFSET	ONESIDEPER = "0">
		<CFSET	ONESIDEMIN = "0">
		<CFSET	OTHERSIDEPER = "0">
	 	<CFSET	OTHERSIDEMIN = "0">
		<CFSET	DELIVERYPER = "0">
		<CFSET	DELIVERYMIN = "0">
		<CFSET	TOTYPE	   = "">
		<CFSET	TOTURNOVER = "0">
		<CFSET	TType	= "">

				<CFSET	TOTURNOVER = "999999999">


		<CFQUERY NAME="GetSlab" DBTYPE="Dynamic" connectstring="Driver={Microsoft dBASE Driver (*.dbf)}; DriverID=277; "DEBUG>
			SELECT		* 						
			FROM		C:\DBFData\BrkOff.dbf
			WHERE		
					SBCURTP	IN ('1','2','5')
			AND	SBBOKCOD = '#SBBOKCOD#'
			AND	SBBRKSLB = '#SBBRKSLB#';
		</CFQUERY>	


			<cfloop query="GetSlab">
				<CFIF	SBCURTP EQ 1>
					<CFSET	ONESIDEPER = "#SBSLAB#">
					<CFSET	ONESIDEMIN = "#SBMINAMT#">
					<CFSET	TOTYPE	   = "T">
				</CFIF>
				
				<CFIF	SBCURTP EQ 2>
					<CFSET	OTHERSIDEPER = "#SBSLAB#">
					<CFSET	OTHERSIDEMIN = "#SBMINAMT#">
					<CFSET	TOTYPE	   	 = "T">
				</CFIF>
				
				<CFIF	SBCURTP EQ 5>
					<CFSET	DELIVERYPER = "#SBSLAB#">
					<CFSET	DELIVERYMIN = "#SBMINAMT#">
					<CFSET	TOTYPE	 	= "#TOTYPE#,D">
				</CFIF>
			</cfloop>

			<CFLOOP INDEX="i" FROM="1" TO="2">
				<CFSET	TType	=	"#GetToken(TOTYPE, i, ',')#">
				
				<CFIF	TType	is not "">
					<CFTRY>
					 <CFQUERY name="InsertBrokerageSlab" datasource="#Client.database#" dbtype="ODBC"DEBUG>
					 	IF Not Exists
						(
				 			Select MODULE_NO
							From BROKERAGE_DETAILS
							Where
								COMPANY_CODE = '#UCase(Trim(CmbCoList))#'
								And MODULE_NO = '#UCase(Trim(ModuleNo))#'
								And MKT_TYPE = '#UCase(Trim(Mkt_Type))#'
								And FROM_TURNOVER = 0
								And TURNOVER_TYPE = '#Trim(TType)#'
						)
						Begin
							Insert Into BROKERAGE_DETAILS
							(
								  COMPANY_CODE, MODULE_NO, MKT_TYPE,
								  FROM_TURNOVER, TO_TURNOVER, TURNOVER_TYPE,
								  ONESIDEPER, ONESIDEMIN, OTHERSIDEPER, OTHERSIDEMIN,
								  DELIVERYPER, DELIVERYMIN
							)
							Values
							(
								  '#UCase(Trim(CmbCoList))#', '#UCase(Trim(ModuleNo))#', '#UCase(Trim(Mkt_Type))#',
								   0, 999999999, '#TType#', #OneSidePer#, #OneSideMin#,
								   #OtherSidePer#, #OtherSideMin#, #DELIVERYPER#, #DELIVERYMin#
							)
						end		
					</CFQUERY>
					 <cfcatch TYPE="Database">
						<CFIF		CFCATCH.NativeErrorCode	EQ 2627>

						<CFELSEIF	CFCATCH.NativeErrorCode	EQ 547>
						#CFCATCH.DETAIL#
						<CFELSE>
							<FONT COLOR="Red"><BR>
							#CFCATCH.DETAIL#
							</FONT>
						</CFIF>
					</CFCATCH>	
					</CFTRY>
				</CFIF>
			</CFLOOP>
		
		   </CFIF>
		</CFIF>
		</CFOUTPUT>
  	</CFIF>
  
  	<CFIF	IsDefined("cmdImportClientBrk")>
		<CFQUERY NAME="GetBrk" DBTYPE="Dynamic" connectstring="Driver={Microsoft dBASE Driver (*.dbf)}; DriverID=277; ">
			SELECT		* 						
			FROM		C:\DBFData\CBrkCl.dbf
		</CFQUERY>		
	
	<CFOUTPUT QUERY="GetBrk">

		<CFTRY>
			<CFQUERY NAME="ValidateClient" datasource="#Client.database#" DBTYPE="ODBC">
				Select	Client_ID
				From	
						Client_Master
				Where
						Client_ID		=	'#trim(MSACCODE)#'
				And		Company_Code	=	'#CmbCoList#'
			</CFQUERY>
			
			<CFSET		ModuleDesc		=	"#Mid(MSPLACE, 7, 1)##Mid(MSREFSW, 4, 1)#">

			<CFQUERY NAME="ValidateModule" datasource="#Client.database#" DBTYPE="ODBC">
				Select	Module_No
				From	
						Brokerage_Master
				Where 
						Description		=	'#trim(ModuleDesc)#'
				And		Company_Code	=	'#CmbCoList#'
			</CFQUERY>
			
			<CFIF	ValidateClient.RecordCount GT 0
			  And	ValidateModule.RecordCount GT 0>
			  
			  	<CFSET	Module_No		=	ValidateModule.Module_No>
			
	 			<CFQUERY Name="AddNewClientBrkApply" datasource="#Client.database#" DBType="ODBC">
					Insert	BROKERAGE_APPLY
					(
							  COMPANY_CODE, CLIENT_ID, START_DATE, END_DATE, JOBBER_PER,
							  BROKERAGE_MODULE
					)
					Values
					(
							'#UCase(Trim(CmbCoList))#', '#UCase(Trim(MSACCODE))#', '2004-10-01', Null, Null,
							'#UCase(Trim(Module_No))#'
					)
				</CFQUERY>
			
			</CFIF>
			
			<cfcatch TYPE="Database">
				<CFIF	CFCATCH.NativeErrorCode	EQ 2627>
				
				<CFELSE>
					<FONT COLOR="Red"><BR>
					2 - #CFCATCH.DETAIL#
					</FONT>
				</CFIF>
			</CFCATCH>	
			</CFTRY>
	  </CFOUTPUT>
		<font COLOR="Blue">
			<BR>Data Imported..<BR>
		</FONT>
	</CFIF>
</CFFORM>
</body>
</html>
