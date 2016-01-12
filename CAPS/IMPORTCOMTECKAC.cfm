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

<CFFORM ACTION="IMPORTCOMTECKAC.cfm" METHOD="POST" ENABLECAB="Yes">

  <CFQUERY NAME="CoList" datasource="CAPSFO" DBTYPE="ODBC">
  	Select company_code from company_master 	
  </CFQUERY>
  
  Company Code&nbsp;:&nbsp; 

  <cfselect name="CmbCoList" query="CoList" value="company_code" display="company_code" required="Yes">
  </cfselect>

  &nbsp;&nbsp;<INPUT TYPE="Submit" NAME="cmdImportJournal" VALUE="Import Jouranl">
  &nbsp;&nbsp;<INPUT TYPE="Submit" NAME="cmdImportRecpay" VALUE="Import Receipt-Payment">
  &nbsp;&nbsp;<INPUT TYPE="text" NAME="txtDate" VALUE="01/04/2010">    
  <BR><BR>
  >>	Please Create "DBFDrive" in >>Control Panel>>Administrator Tools >> OdbcData Source and Aslo in ColdFusion Administrator <br>
  >>	All file should be In C:\DBFData.<BR>
  >>	File Name for "Account" is "Account.dbf" (Comtek File Name : SDOC0410.DBF).<BR>
<BR><BR>

  <CFIF IsDefined("cmdImportJournal")>
  	<CFOUTPUT>
		<cfquery name="TRIGERDISABLE" datasource="CAPSFO">
			EXEC [TriggerEnableDisable] 'DISABLE'
			
			DELETE
			FROM FA_TRANSACTIONS
			WHERE
				COCD = '#CmbCoList#'
			AND FINSTYR = 2010
			AND TRANS_TYPE = 'J'
			AND CONVERT(DATETIME,VOUCHERDATE,103) >= CONVERT(DATETIME,'01/04/2010',103)

		</cfquery>
	
		<CFQUERY NAME="GetAddress1" DATASOURCE="DBFDrive" DBTYPE="ODBC">
			SELECT		DISTINCT TRBOKCOD
			FROM		C:\DBFDATA\Account.dbf
			WHERE
				TRBOKCOD LIKE 'JE%';
		</CFQUERY>
			
		<cfloop query="GetAddress1">
			<CFSET JVNOSEQ = "#TRBOKCOD#">
			<CFQUERY NAME="GetAddress" DATASOURCE="DBFDrive" DBTYPE="ODBC">
				SELECT		DISTINCT TRCURNO,TRCURDT
				FROM		C:\DBFDATA\Account.dbf
				WHERE
					TRBOKCOD IN ('#TRIM(JVNOSEQ)#');
			</CFQUERY>
			
			<cfloop query="GetAddress">
					
					<CFQUERY NAME="GetAddress123" DATASOURCE="DBFDrive" DBTYPE="ODBC">
						SELECT		DISTINCT *
						FROM		C:\DBFDATA\Account.dbf
						WHERE
							TRBOKCOD IN ('#TRIM(JVNOSEQ)#')
						AND TRCURNO = #TRIM(TRCURNO)#
						AND TRPTYAMT <> 0
						AND ISNULL(TRPTYCOD,'') <> '';
					</CFQUERY>
					
					<cfquery name="GETVOUCHERNO" datasource="CAPSFO">
						SELECT DBO.[GETLATESTVOUCEHRNO]('#CmbCoList#',2010,'J','',CONVERT(DATETIME,'#TRCURDT#',103),'') VNO
					</cfquery>
					<CFSET VOUCHERNO = '#GETVOUCHERNO.VNO#'>
				<cfloop query="GetAddress123">
					<cfquery name="GETVOUCHERNO" datasource="CAPSFO">
						INSERT INTO FA_TRANSACTIONS
						(COCD,ACCOUNTCODE,DR_AMT,CR_AMT,
						VOUCHERDATE,TRANS_TYPE,VOUCHERNO,NARRATION,FINSTYR,FINENDYR,
						SR,REFNO,TRREFNO,TRADING_COCD,PUNCH_TIME)
						SELECT '#CmbCoList#','#TRIM(TRPTYCOD)#',
								CASE WHEN '#TRIM(TRDRCRCD)#' = 'D' THEN
									#VAL(TRIM(TRPTYAMT))#
								ELSE
									0
								END AS DR_AMT,
								CASE WHEN '#TRIM(TRDRCRCD)#' = 'C' THEN
									ABS(#VAL(TRIM(TRPTYAMT))#)
								ELSE
									0
								END AS CR_AMT,
								CONVERT(DATETIME,'#TRIM(TRCURDT)#',103) VDATE,'J','#TRIM(VOUCHERNO)#','#TRIM(TRNARR)#',2010,2011,
						'#TRIM(TRSRNO)#','#TRIM(TRCURNO)#','#TRIM(TRSRNO)#','#TRIM(CmbCoList)#',GETDATE()		
					</cfquery>
				</cfloop>
			</cfloop>	
		</cfloop>
		
	</cfoutput>
	
	<cfquery name="TRIGERDISABLE" datasource="CAPSFO">
	
		INSERT INTO FA_ACCOUNTSUBTYPE
		(
			COCD, BOOKTYPECODE, ACCOUNT_CLIENT_CODE, ACCOUNTNAME, 
			OPENINGBALANCE, OPENINGBALANCETYPE, 
			CLOSINGBALANCE, CLOSINGBALANCETYPE, 
			FINSTYR, FINENDYR, CREATIONTYPE, KIND_OF_ACCOUNT
		)
		SELECT DISTINCT COCD,2,Counter_Account_Code,Counter_Account_Code,0,'DR',0,'DR',2010,2011,'U','D'
		FROM FA_TRANSACTIONS A
		WHERE
			ISNULL(Counter_Account_Code,'') <> ''
		AND FINSTYR = 2010
		AND Counter_Account_Code NOT IN (SELECT DISTINCT ACCOUNTCODE FROM FA_ACCOUNTLIST B WHERE FINSTYR = 2010 AND A.COCD = B.COCD 
										AND A.FINSTYR = B.FINSTYR AND A.Counter_Account_Code = B.ACCOUNTCODE)
		
		INSERT INTO FA_ACCOUNTSUBTYPE
		(
			COCD, BOOKTYPECODE, ACCOUNT_CLIENT_CODE, ACCOUNTNAME, 
			OPENINGBALANCE, OPENINGBALANCETYPE, 
			CLOSINGBALANCE, CLOSINGBALANCETYPE, 
			FINSTYR, FINENDYR, CREATIONTYPE, KIND_OF_ACCOUNT
		)	
		
		SELECT DISTINCT COCD,3,ACCOUNTCODE,ACCOUNTCODE,0,'DR',0,'DR',2009,2010,'U','D'
		FROM FA_TRANSACTIONS A
		WHERE
			ISNULL(ACCOUNTCODE,'') <> ''
		AND FINSTYR = 2010
		AND ACCOUNTCODE NOT IN (SELECT DISTINCT ACCOUNTCODE FROM FA_ACCOUNTLIST B WHERE FINSTYR = 2010 AND A.COCD = B.COCD 
										AND A.FINSTYR = B.FINSTYR AND A.ACCOUNTCODE = B.ACCOUNTCODE)
									
		EXEC [TriggerEnableDisable] 'ENABLE'
	</cfquery>
	Journal Data Imported...
  </CFIF>

	<CFIF IsDefined("cmdImportRecpay")>
  	<CFOUTPUT>
		<cfquery name="TRIGERDISABLE" datasource="CAPSFO">
			EXEC [TriggerEnableDisable] 'DISABLE'
			
			DELETE
			FROM FA_TRANSACTIONS
			WHERE
				COCD = '#CmbCoList#'
			AND FINSTYR = 2010
			AND TRANS_TYPE IN ('R','P')
			AND CONVERT(DATETIME,VOUCHERDATE,103) >= CONVERT(DATETIME,'01/04/2010',103)

		</cfquery>
	
		<CFQUERY NAME="GetAddress1" DATASOURCE="DBFDrive" DBTYPE="ODBC">
			SELECT		DISTINCT TRBOKCOD
			FROM		C:\DBFDATA\Account.dbf
			WHERE
				TRBOKCOD LIKE 'BC%';
		</CFQUERY>
			
		<cfloop query="GetAddress1">
			<CFSET JVNOSEQ = "#TRBOKCOD#">
			<CFQUERY NAME="GetAddress" DATASOURCE="DBFDrive" DBTYPE="ODBC">
				SELECT		DISTINCT *
				FROM		C:\DBFDATA\Account.dbf
				WHERE
					TRBOKCOD IN ('#TRIM(JVNOSEQ)#')
				AND TRPTYAMT <> 0;
			</CFQUERY>
			
			<cfloop query="GetAddress">
				<CFIF TRDRCRCD EQ "D">
					<CFSET TRANS_TYPE = "P">
				<cfelse>
					<CFSET TRANS_TYPE = "R">	
				</CFIF>	
				<cfquery name="GETVOUCHERNO" datasource="CAPSFO">
					SELECT DBO.[GETLATESTVOUCEHRNO]('#CmbCoList#',2010,'#TRANS_TYPE#','B',CONVERT(DATETIME,'#TRCURDT#',103),'#TRIM(TRPRDGL)#') VNO
				</cfquery>
				<CFSET VOUCHERNO = '#GETVOUCHERNO.VNO#'>
			
				<cfquery name="GETVOUCHERNO" datasource="CAPSFO">
					INSERT INTO FA_TRANSACTIONS
					(
						COcd, AccountCode, Dr_amt, Cr_amt,
						VoucherDate,  Trans_Type, VoucherNo, ChqNo,BankNo,BankAcNo,Narration,FinStyr, FinEndyr	
						,Counter_Account_Code,Punch_Time,REFNO,TRREFNO,BRSFLAG,EXPECTED_DATE,BRANCH_ID,
						TRANSACTION_TYPE
					)
					SELECT 
					'#CmbCoList#','#TRIM(TRPTYCOD)#',
							CASE WHEN '#TRIM(TRDRCRCD)#' = 'D' THEN
								#VAL(TRIM(TRPTYAMT))#
							ELSE
								0
							END AS DR_AMT,
							CASE WHEN '#TRIM(TRDRCRCD)#' = 'C' THEN
								ABS(#VAL(TRIM(TRPTYAMT))#)
							ELSE
								0
							END AS CR_AMT,
							CONVERT(DATETIME,'#TRIM(TRCURDT)#',103) VDATE,'#TRANS_TYPE#','#TRIM(VOUCHERNO)#',
							'#VAL(TRIM(TRCHLNO))#','#TRIM(TRMICRCD)#','#TRIM(TRACNO)#','#REPLACE(REPLACE(TRIM(TRNARR),'"','','ALL'),"'","","ALL")#',2010,2011,
							'#TRIM(TRPRDGL)#',GETDATE(),'#TRIM(TRSRNO)#','#TRIM(TRCURNO)#','N',NULL,NULL,NULL
					
					INSERT INTO FA_TRANSACTIONS
					(
						COcd, AccountCode, Dr_amt, Cr_amt,
						VoucherDate,  Trans_Type, VoucherNo, ChqNo,BankNo,BankAcNo,Narration,FinStyr, FinEndyr	
						,Counter_Account_Code,Punch_Time,REFNO,TRREFNO,BRSFLAG,EXPECTED_DATE,BRANCH_ID,
						TRANSACTION_TYPE
					)
					SELECT
						'#CmbCoList#','#TRIM(TRPRDGL)#',
							CASE WHEN '#TRIM(TRDRCRCD)#' = 'C' THEN
								#VAL(TRIM(TRPTYAMT))#
							ELSE
								0
							END AS DR_AMT,
							CASE WHEN '#TRIM(TRDRCRCD)#' = 'D' THEN
								ABS(#VAL(TRIM(TRPTYAMT))#)
							ELSE
								0
							END AS CR_AMT,
							CONVERT(DATETIME,'#TRIM(TRCURDT)#',103) VDATE,'#TRANS_TYPE#','#TRIM(VOUCHERNO)#',
							'#VAL(TRIM(TRCHLNO))#','#TRIM(TRMICRCD)#','#TRIM(TRACNO)#','Narration for #TRIM(VOUCHERNO)#',2010,2011,
							NULL,GETDATE(),'#TRIM(TRSRNO)#','#TRIM(TRCURNO)#','N',NULL,NULL,NULL		
				</cfquery>
			</cfloop>			
		</cfloop>
		
	</cfoutput>
	
	<cfquery name="TRIGERDISABLE" datasource="CAPSFO">
	
	INSERT INTO FA_ACCOUNTSUBTYPE
	(
		COCD, BOOKTYPECODE, ACCOUNT_CLIENT_CODE, ACCOUNTNAME, 
		OPENINGBALANCE, OPENINGBALANCETYPE, 
		CLOSINGBALANCE, CLOSINGBALANCETYPE, 
		FINSTYR, FINENDYR, CREATIONTYPE, KIND_OF_ACCOUNT
	)
	SELECT DISTINCT COCD,2,Counter_Account_Code,Counter_Account_Code,0,'DR',0,'DR',2010,2011,'U','D'
	FROM FA_TRANSACTIONS A
	WHERE
		ISNULL(Counter_Account_Code,'') <> ''
	AND FINSTYR = 2010
	AND Counter_Account_Code NOT IN (SELECT DISTINCT ACCOUNTCODE FROM FA_ACCOUNTLIST B WHERE FINSTYR = 2010 AND A.COCD = B.COCD 
									AND A.FINSTYR = B.FINSTYR AND A.Counter_Account_Code = B.ACCOUNTCODE)
	
	INSERT INTO FA_ACCOUNTSUBTYPE
	(
		COCD, BOOKTYPECODE, ACCOUNT_CLIENT_CODE, ACCOUNTNAME, 
		OPENINGBALANCE, OPENINGBALANCETYPE, 
		CLOSINGBALANCE, CLOSINGBALANCETYPE, 
		FINSTYR, FINENDYR, CREATIONTYPE, KIND_OF_ACCOUNT
	)	
	
	SELECT DISTINCT COCD,3,ACCOUNTCODE,ACCOUNTCODE,0,'DR',0,'DR',2010,2011,'U','D'
	FROM FA_TRANSACTIONS A
	WHERE
		ISNULL(ACCOUNTCODE,'') <> ''
	AND FINSTYR = 2010
	AND ACCOUNTCODE NOT IN (SELECT DISTINCT ACCOUNTCODE FROM FA_ACCOUNTLIST B WHERE FINSTYR = 2010 AND A.COCD = B.COCD 
									AND A.FINSTYR = B.FINSTYR AND A.ACCOUNTCODE = B.ACCOUNTCODE)
									
	EXEC [TriggerEnableDisable] 'ENABLE'
	</cfquery>
	
	
	Receipt-Payment Data Imported...
  </CFIF>
  
  </CFFORM>
</body>
</html>
