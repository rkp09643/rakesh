<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
<title>Import DBF FNO</title>
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

<CFFORM ACTION="IMP_FNO.cfm" METHOD="POST" ENABLECAB="Yes">

  <CFQUERY NAME="CoList" datasource="#Client.database#" DBTYPE="ODBC">
  	Select company_code from company_master 
	Where
			Market	=	'FO'
  </CFQUERY>
  
  Company Code&nbsp;:&nbsp; 
  <cfselect name="CmbCoList" query="CoList" value="company_code" display="company_code" required="Yes">
  </cfselect>
  &nbsp;&nbsp;<INPUT TYPE="Submit" NAME="cmdImportMaster" VALUE="Import Master">
  &nbsp;&nbsp;<INPUT TYPE="Submit" NAME="cmdImportBrokerage" VALUE="Import Brokerage">
  &nbsp;&nbsp;<INPUT TYPE="Submit" NAME="cmdImportClientBrk" VALUE="Import Client - Brokerage Relation">
  <!--- &nbsp;&nbsp;<INPUT type="submit" name="IMPDPMAST" value="Import Dp MASTER"> --->
    
  <BR><BR>
  >>	All file should be In C:\DBFData.<BR>
  >>	File Name for "Client Master" is "CapsAdd.dbf" (Comtek File Name : AMSTAD06.DBF).<BR>
  >>	File Name for "Brokerage Master" is "BrkOff.dbf"(Comtek File Name : CSSBRBL.DBF).<BR>
  >>	File Name for "Client Brokerage Relation" is "CBrkCl.dbf" (Comtek File Name : AMSTAE04.DBF).<BR>


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

			<CFQUERY NAME="GetAddress" DATASOURCE="DBFDrive" DBTYPE="ODBC">
				SELECT		* 						
				FROM		C:\DBFDATA\CapsAdd.dbf
				WHERE 		LEFT(TRIM(MSACCODE), 1) <> 'Z' 
				AND  		LEFT(TRIM(MSACCODE), 2) <> '99'
				<!--- AND  		RIGHT(TRIM(MSACCODE), 1) <> 'S' --->
				AND  		RIGHT(TRIM(MSACCODE), 1) <> 'M'
			</CFQUERY>
			
			<CFLOOP QUERY="GetAddress">
				<CFTRY>
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
											  '#UCase(Trim(CmbCoList))#', '#UCase(Trim(MSACCODE))#', '#LEFT(UCase(Trim(MSPTYNAM)), 100)#'
											, 'MAIN', GetDate(), GetDate(), 'N', 'C', 'T'
										)
						END	
					</CFQUERY>
				<CFCATCH TYPE="Database">
					<CFIF	CFCATCH.NativeErrorCode	EQ 2627>
					
					<CFELSE>
						<FONT COLOR="Red">
							#CFCATCH.DETAIL#
						</FONT>
							Insert	CLIENT_MASTER
							(
								  COMPANY_CODE, CLIENT_ID, CLIENT_NAME, BRANCH_CODE, REGISTRATION_DATE
								, LAST_MODIFIED_DATE, PRO, CLIENT_NATURE, CLIENT_TYPE
							)
							Values
							(
								  '#UCase(Trim(CmbCoList))#', '#UCase(Trim(MSACCODE))#', '#LEFT(UCase(Trim(MSPTYNAM)), 100)#'
								, 'MAIN', GetDate(), GetDate(), 'N', 'C', 'T'
							)
					<CFABORT>
					</CFIF>
				</CFCATCH>
			</CFTRY>
					
			<!--- <CFTRY>
					<CFQUERY Name="AddNewClient" DataSource="CAPSFO" DBType="ODBC">
						If Not Exists
						(
							Select	Top 1 RTrim(CLIENT_ID)
							From	BROKERAGE_APPLY
							Where
										COMPANY_CODE	=	'#Trim(CmbCoList)#'
									And CLIENT_ID		=	'#Trim(MSACCODE)#'
						)
						Begin
							Insert	BROKERAGE_APPLY
							(
							  COMPANY_CODE, CLIENT_ID, START_DATE, END_DATE, BROKERAGE_MODULE, ADJUSTMENT_CODE,
							  DELY_BRK_APPLY, DM_TURNOVER, ST, EXPENSE_MODULE, TOC, STD, MRG, ACTIVE_INACTIVE
							)
							VALUES
							(
							 	'#UCase(Trim(CmbCoList))#', '#UCase(Trim(MSACCODE))#', '2004-10-01', NULL, NULL, 1, 1, 'D', 'Y', NULL, 'Y', 'Y', 'N', 'A'
							) 
						END	
					</CFQUERY>
				<CFCATCH TYPE="Database">
					<CFIF	CFCATCH.NativeErrorCode	EQ 2627>
					
					<CFELSE>
						<FONT COLOR="Red">
							#CFCATCH.DETAIL#
						</FONT>
						Insert	BROKERAGE_APPLY
							(
							  COMPANY_CODE, CLIENT_ID, START_DATE, END_DATE, BROKERAGE_MODULE, ADJUSTMENT_CODE,
							  DELY_BRK_APPLY, DM_TURNOVER, ST, EXPENSE_MODULE, TOC, STD, MRG, ACTIVE_INACTIVE
							)
							VALUES
							(
							 	'#UCase(Trim(CmbCoList))#', '#UCase(Trim(MSACCODE))#', '2004-10-01', NULL, NULL, 1, 1, 'D', 'Y', NULL, 'Y', 'Y', 'N', 'A'
							) 
						<CFABORT>
					</CFIF>
				</CFCATCH>
			</CFTRY> --->
				
				<CFTRY>
				<CFQUERY Name="AddClientDetails" datasource="#Client.database#" DBType="ODBC">
					If Not Exists
						(
							Select	Top 1 RTrim(CLIENT_ID)
							From	CLIENT_DETAILS
							Where							
									CLIENT_ID		=	'#Trim(MSACCODE)#'
						)
						BEGIN
							Insert	CLIENT_DETAILS
							(
								 CLIENT_ID,RESI_ADDRESS,RESI_TEL_NO,PAN_NO,State,
								 EMAIL_ID,MOBILE_NO,INTRODUCER_NAME
							)
							Values
							(
								 '#UCase(Trim(MSACCODE))#', '#UCase(Trim(MSADDRL1))#~#UCase(Trim(MSADDRL2))#~#UCase(Trim(MSADDRL3))# #UCase(Trim(MSADDRL4))# #UCase(Trim(MSADDRL5))#', '#LEFT(UCase(Trim(MSTELNO)), 20)#','#TRIM(LEFT(MSITNO,19))#','#TRIM(UCASE(MSSTATE))#',
								 '#TRIM(MSEMAIL)#','#TRIM(MSMOBILE)#','#TRIM(MSINTRO)#'
							)
						END	
					</CFQUERY>
				<CFCATCH TYPE="Database">
					<CFIF	CFCATCH.NativeErrorCode	EQ 2627>
					
					<CFELSE>
						<FONT COLOR="Red">
							#CFCATCH.DETAIL#
						</FONT>
						<BR>
						Insert	CLIENT_DETAILS
						(
							 CLIENT_ID,RESI_ADDRESS,RESI_TEL_NO,PAN_NO,State,
							 EMAIL_ID,MOBILE_NO,INTRODUCER_NAME
						)
				        Values
						(
							 '#UCase(Trim(MSACCODE))#', '#UCase(Trim(MSADDRL1))#~#UCase(Trim(MSADDRL2))#~#UCase(Trim(MSADDRL3))# #UCase(Trim(MSADDRL4))# #UCase(Trim(MSADDRL5))#', '#LEFT(UCase(Trim(MSTELNO)), 20)#','#TRIM(LEFT(MSITNO,19))#','#TRIM(UCASE(MSSTATE))#',
							 '#TRIM(MSEMAIL)#','#TRIM(MSMOBILE)#','#TRIM(MSINTRO)#'
						)

						 <CFABORT>
					</CFIF>
				</CFCATCH>
				</CFTRY>
			</CFLOOP>

			<CFTRY>	
				<CFSTOREDPROC Procedure="FACLIENT_CREATION" datasource="#Client.database#" ReturnCode="Yes">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@ACTION" value="CREATE FA ACCOUNT" maxlength="25" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@COCD" value="#UCase(Trim(CmbCoList))#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENTID" value="" maxlength="20" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@CLIENTNAME" value="" maxlength="100" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_VARCHAR" dbvarname="@FA_COCD" value="#UCase(Trim(CmbCoList))#" maxlength="10" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@FINSTART" value="2005" maxlength="4" null="No">
					<CFPROCPARAM type="In" cfsqltype="CF_SQL_INTEGER" dbvarname="@FINEND" value="2006" maxlength="4" null="No">
				</CFSTOREDPROC>
		<CFCATCH TYPE="Database">	 
			<FONT COLOR="Red">
			Error in Fa Creation <BR>#CFCATCH.DETAIL#
			</FONT>
		</CFCATCH>		
		 </CFTRY>
	</CFOUTPUT>	
	Data Imported...
  </CFIF>

  <CFIF IsDefined("cmdImportBrokerage")>
	<CFQUERY NAME="GetBrk" DATASOURCE="DBFDrive">
		SELECT		* 						
		FROM		C:\DBFDATA\BrkOff.dbf
		WHERE		
					BRKINDTYPE = 'NFU'
		AND			BRKSQTYPE IN ('1','3')
	Order By 	
				BRKSLAB
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

	<CFQUERY NAME="DeleteData2" datasource="#Client.database#" DBTYPE="ODBC">
		Delete From Brokerage_Apply
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

	<CFQUERY NAME="GetBrk1" DATASOURCE="DBFDrive">
		SELECT  *						
		FROM		C:\DBFDATA\BrkOff.dbf
		WHERE		
					BRKSQTYPE	IN ('1','3')
		AND	BRKINDTYPE = 'NFU'
		Order By 	
				BRKSLAB
	</CFQUERY>
	
	<CFOUTPUT QUERY="GetBrk1" group="BRKSLAB">
		
	<cfif Len(Trim(BRKSLAB)) gt 0>
		<CFQUERY NAME="GetLatestModule" datasource="#Client.database#" DBTYPE="ODBC">
			Select	Module_No ModuleNo
			From
					Brokerage_Master
			Where
					Company_Code	=	'#CmbCoList#'
		  	And	 Description	=	'#Trim(UCase(BRKSLAB))#'

		</CFQUERY>
		
		<CFSET	ModuleNo	=	VAL(GetLatestModule.ModuleNo)>
					   
		<cftry>
			<cfquery name="InsertBrokModule" datasource="#Client.database#" dbtype="ODBC">
			if not exists(select DESCRIPTION 
			   			  From
						  		 Brokerage_Master
						  Where
						  		 Company_Code	=	'#CmbCoList#'
						  And	 Description	=	'#Trim(UCase(BRKSLAB))#'
						 )
			Begin			 
				Insert Into BROKERAGE_MASTER
				(
					COMPANY_CODE,MODULE_NO, 
					DESCRIPTION,fo_level
				)
				Values
				(
					'#UCase(CmbCoList)#','#Trim(UCase(ModuleNo))#', 
					'#Trim(UCase(BRKSLAB))#',1
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
		

		<CFOUTPUT GROUP="SBBOKCOD">
  		  <CFIF LEN(Trim(SBBOKCOD)) GT 0>
			<CFIF Exchange_Code IS "NSE">
				<CFIF	SBBOKCOD IS "U">
					<CFSET	MKT_TYPE = "N">
				<CFELSEIF SBBOKCOD IS "T">
					<CFSET	MKT_TYPE = "T">
				<CFELSEIF SBBOKCOD IS "D">
					<CFSET	MKT_TYPE = "A">
				</CFIF>
			</CFIF>
	
			<CFIF Exchange_Code IS "BSE">
				<CFIF	SBBOKCOD IS "Y">
					<CFSET	MKT_TYPE = "N">
				<CFELSEIF SBBOKCOD IS "O">
					<CFSET	MKT_TYPE = "T">
				<CFELSEIF SBBOKCOD IS "D">
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

		<CFQUERY NAME="GetSlab" DATASOURCE="DBFDrive">
			SELECT		* 						
			FROM		C:\DBFDATA\BrkOff.dbf
			WHERE		
					SBCURTP	IN ('1','2','5')
			AND	SBBRKSLB = '#SBBRKSLB#'
			AND	SBBOKCOD = '#SBBOKCOD#'
			;
		</CFQUERY>	
		#SBBOKCOD#---#SBBRKSLB#<BR>

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
					 <CFQUERY name="InsertBrokerageSlab" datasource="#Client.database#" dbtype="ODBC">
					 	IF Not Exists
						(
				 			Select MODULE_NO
							From BROKERAGE_DETAILS
							Where
								COMPANY_CODE = '#UCase(Trim(CmbCoList))#'
								And MODULE_NO = '#UCase(Trim(ModuleNo))#'
								And MKT_TYPE = '#UCase(Trim(Mkt_Type))#'
								And FROM_TURNOVER = '#trim(BRKSAMT)#'
								And TURNOVER_TYPE = '#Trim(TType)#'
						)
						Begin
						Insert Into BROKERAGE_DETAILS
							(
								  COMPANY_CODE, MODULE_NO, MKT_TYPE, 
								  FROM_TURNOVER, TO_TURNOVER,
								  FROM_PRICE, TO_PRICE, TURNOVER_TYPE,
								  ONESIDEPER, ONESIDEMIN,
								  OTHERSIDEPER, OTHERSIDEMIN								  
								,APPLIED_ON,DERIVATIVE_SYMBOL,TRANSACTION_TYPE
								  
							)
							Values
							(
								  '#CmbCoList#', '#UCase(Trim(ModuleNo))#', 								  
									'FO',								
								   0, 999999999,								   
									   #From_Price#								   
									, #To_Price#, 
									NULL,
								   #ONESIDEPER#, #ONESIDEMIN#,
								   #OTHERSIDEPER#, #OTHERSIDEMIN#
									,'SP','FO','T'								  
							)


						end		
					</CFQUERY>
					'#UCase(Trim(CmbCoList))#', '#UCase(Trim(ModuleNo))#', '#UCase(Trim(Mkt_Type))#',
								   0, 999999999, '#TType#', #OneSidePer#, #OneSideMin#,
								   #OtherSidePer#, #OtherSideMin#, #DELIVERYPER#, #DELIVERYMin#<br>
					 <cfcatch TYPE="Database">
						<CFIF		CFCATCH.NativeErrorCode	EQ 2627>

						<CFELSEIF	CFCATCH.NativeErrorCode	EQ 547>
						
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
		  </CFOUTPUT>
		</CFIF>
		</CFOUTPUT>
		Data Imported...
  	</CFIF>
  
  	<CFIF	IsDefined("cmdImportClientBrk")>
		<CFQUERY NAME="GetBrk" DATASOURCE="DBFDrive" DBTYPE="ODBC">
			SELECT distinct code,br
			FROM C:\DBFDATA\CBrkCl.dbf
			WHERE
				Edate IS NULL
			AND BR IS NOT NULL
			Order by br;
		<!--- 	SELECT	distinct code,br
			FROM		C:\DBFDATA\CBrkCl.dbf
			WHERE
					edate IS NULL
			order by br		 --->
		</CFQUERY>		
	<cfset sr = 1>
	<CFOUTPUT QUERY="GetBrk">

		<CFTRY>
			<CFQUERY NAME="ValidateClient" datasource="#Client.database#" DBTYPE="ODBC">
				Select	Client_ID
				From	
						Client_Master
				Where
						Client_ID		=	'#trim(CODE)#'
				And		Company_Code	=	'#CmbCoList#'
			</CFQUERY>
			
			<!--- <CFSET		ModuleDesc		=	"#Mid(MEPLACE, 7, 1)##Mid(MEREFSW, 4, 1)#">
			 #UCase(Trim(MEACCODE))#-#ModuleDesc# <br> --->
			
			<CFQUERY NAME="ValidateModule" datasource="#Client.database#" DBTYPE="ODBC">
				Select	Module_No
				From	
						Brokerage_Master
				Where 
						Description		=	'#trim(br)#'
				And		Company_Code	=	'#CmbCoList#'
			</CFQUERY>
			
			<CFIF	ValidateClient.RecordCount GT 0
			  And	ValidateModule.RecordCount GT 0>
			  
			  	<CFSET	Module_No		=	ValidateModule.Module_No>
				

			
	 			<CFQUERY Name="AddNewClientBrkApply" datasource="#Client.database#" DBType="ODBC">
					Insert	BROKERAGE_APPLY
					(
							  COMPANY_CODE, CLIENT_ID, START_DATE, END_DATE, JOBBER_PER,
							  BROKERAGE_MODULE,  ADJUSTMENT_CODE,DEL_ADJUSTMENT_CODE,
							  TOC,ST,STD
					)
					Values
					(
							'#UCase(Trim(CmbCoList))#', '#UCase(Trim(CODE))#', '2005-04-01', Null, Null,
							'#UCase(Trim(Module_No))#',3,3,'Y','Y','Y'
					)
				</CFQUERY>
			'#sr#'-'#UCase(Trim(CODE))#'-'#UCase(Trim(Module_No))#'	<BR>		
			</CFIF>
			<cfset sr = sr +1>
			
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
	  
	  <CFQUERY NAME="InsertBlank" datasource="#Client.database#" DBTYPE="ODBC">
			Insert	BROKERAGE_APPLY
			(
					  COMPANY_CODE, CLIENT_ID, START_DATE, END_DATE, JOBBER_PER,
					  BROKERAGE_MODULE, ADJUSTMENT_CODE,DEL_ADJUSTMENT_CODE,
					  TOC,ST,STD
			)
			Select 
					'#UCase(Trim(CmbCoList))#', Client_ID, '2005-04-01', Null, Null, 0, 3, 3,
					'Y','Y','Y'
			From
					Client_Master
			Where
					Company_Code	=	'#UCase(Trim(CmbCoList))#'
			And		Client_ID		Not In	(Select	Client_ID
										 From	
												BROKERAGE_APPLY
										Where
												Company_Code	=	'#UCase(Trim(CmbCoList))#'
										)
	  </CFQUERY>
		<font COLOR="Blue">
			<BR>Data Imported..<BR>
		</FONT>
	</CFIF>
	<CFIF ISDEFINED("IMPDPMAST")>
		<!--- <CFQUERY NAME="GETDEPONAME" DATASOURCE="DBFDrive">
			SELECT		* 						
			FROM		C:\DBFDATA\DPMAST.dbf
			WHERE
				DPACNO IS NULL		
			AND DPACTYPE = 'D'	
			;
		</CFQUERY>
		<cfquery name="DELETEREMAININGONE" datasource="CAPSFO">
			DELETE FROM IO_CLIENT_DP_MASTER
		</cfquery>
		<cfset sr =1>
		<cfloop query="GETDEPONAME">
			<cfquery name="InsertIntoMainone" datasource="capsfo">
				insert into IO_CLIENT_DP_MASTER
				(DP_ID,DP_NAME,DEPOSITORY)
				VALUES
				(
					'#TRIM(DPID)#','#TRIM(DPACNAME)#',
					<CFIF	 DPTYPE EQ "1">
						'NSDL'
					<cfelse>
						'CDSL'	
					</CFIF>
				)
			</cfquery>
			<cfoutput>
			
			#sr#-'#TRIM(DPID)#','#TRIM(DPACNAME)#',
					<CFIF	 DPTYPE EQ "1">
						'NSDL'
					<cfelse>
						'CDSL'	
					</CFIF><br>
			</cfoutput>		
			<cfset sr = sr +1>
		</cfloop> --->
		
		<CFQUERY NAME="GETCLIENTIDS" DATASOURCE="DBFDrive">
			SELECT		* 						
			FROM		C:\DBFDATA\DPMAST.dbf
			WHERE
				DPACNO IS NOT  NULL		
			<!--- AND DPACTYPE = 'B'	 --->
			ORDER BY DPACCODE
			;
		</CFQUERY>
		<cfquery name="DELETEDATA" datasource="CAPSFO">
			DELETE FROM IO_DP_MASTER
		</cfquery>	
		<cfset sr = 1>
		<CFLOOP query="GETCLIENTIDS">
			<cfif LEN(DPACCODE) NEQ 0>
				<cfquery name="CHECKFORCLIENTMASTER" datasource="#Client.database#">
					SELECT DISTINCT *
					FROM CLIENT_MASTER
					WHERE	
						CLIENT_ID = '#DPACCODE#'
					AND	COMPANY_CODE = '#UCase(Trim(CmbCoList))#'	
				</cfquery>
				<cfIF CHECKFORCLIENTMASTER.RECORDCOUNT GTE 0 >					
					<cfquery name="InsertIntodpMaster" datasource="#Client.database#">
						IF Not Exists
						(
				 			Select TOP 1 *
							From IO_DP_MASTER
							Where
									CLIENT_ID = '#DPACCODE#'
								<CFIF	 DPTYPE EQ "1">
									AND CLIENT_DP_CODE = '#DPACNO#'
								<cfelse>
									AND CLIENT_DP_CODE = '#TRIM(DPID)##TRIM(DPACNO)#'
								</CFIF> 								
								AND DP_ID = '#DPID#'
								AND ASS_CLIENT_ID = '#DPACCODE#'								    
						)
						Begin
						INSERT INTO IO_DP_MASTER
						(CLIENT_ID,CLIENT_DP_CODE,CLIENT_DP_NAME,DP_ID,DP_NAME,DEFAULT_ACC,DEPOSITORY,ASS_CLIENT_ID)
						VALUES
						(
							'#TRIM(DPACCODE)#',
							<CFIF	 DPTYPE EQ "1">
								'#TRIM(DPACNO)#',
							<cfelse>
								'#TRIM(DPID)##TRIM(DPACNO)#',
							</CFIF> 							
							'#TRIM(DPACNAME)#','#TRIM(DPID)#',NULL,
							<cfif DPACTST NEQ "I">
								'Y',
							<cfelse>
								'N'	,
							</cfif>
							<CFIF	 DPTYPE EQ "1">
								'NSDL',
							<cfelse>
								'CDSL',
							</CFIF> 
							'#DPACCODE#'
						)
						END
					</cfquery>
					
					<cfoutput>
					#sr# - '#TRIM(DPACCODE)#','#TRIM(DPACNO)#','#TRIM(DPACNAME)#','#TRIM(DPID)#',NULL,
							<cfif DPACTST NEQ "I">
								'Y',
							<cfelse>
								'N'	,
							</cfif>
							<CFIF	 DPTYPE EQ "1">
								'NSDL',
							<cfelse>
								'CDSL',
							</CFIF> 
							'#DPACCODE#'<br>
						</cfoutput>	
						<cfset sr = sr +1>
				</cfIF>
			</cfif>
		</CFLOOP>
		<cfquery name="uPDATEDPNAME" datasource="#Client.database#">
			UPDATE IO_DP_MASTER
			SET
				DP_NAME = A.DP_NAME
			FROM 
			---SELECT B.DP_ID,A.DP_NAME
			---FROM
				IO_CLIENT_DP_MASTER A ,IO_DP_MASTER B
			WHERE 
				A.DP_ID = B.DP_ID	
		</cfquery>
		DATA IMPORTED................
	</CFIF>
</CFFORM>
</body>
</html>
