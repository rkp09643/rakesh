<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<LINK href="../../CSS/style.css" type="text/css" rel="stylesheet">
<TITLE></TITLE>
</HEAD>
<BODY BGCOLOR="#FFFFCC">
<CFQUERY NAME="GETDETAILS" datasource="#Client.database#">
	SELECT  A.CLIENT_ID,A.CLIENT_NAME,B.MARKET,A.COMPANY_CODE,A.REGISTRATION_DATE,A.LAST_MODIFIED_DATE,
		B.MAPIN,B.PAN_NO,B.PASSPORT_NO,B.PASSPORT_EXPIRY_DATE,CONVERT(VARCHAR(11),PASS_ISSUE_DATE,106) PASS_ISSUE_DATE1,
		PASSPORT_ISSUED_PLACE,
		DRIVING_LICENSE,CONVERT(VARCHAR(11),DRIVING_LICENSE_ISSUED_DATE,106) DRIVING_LICENSE_ISSUED_DATE1,DRIVING_LICENSE_ISSUED_PLACE,
		VOTERS_ID_CARD, CONVERT(VARCHAR(11),VOTERS_ID_CARD_ISSUED_DATE,106) VOTERS_ID_CARD_ISSUED_DATE1,Place_Issue_Vouter_ID,
		RATIONCARD,RATIONCARD_ISSUED_PLACE,CONVERT(VARCHAR(11),RATIONCARD_expiry_DATE,106) RATIONCARD_expiry_DATE1,
		A.LAST_NAME + ' ' + A.FIRST_NAME+' '+A.MIDDLE_NAME CLIENTFULLNAME,
		B.CATEGORY,RESI_ADDRESS,PIN_CODE,RESI_TEL_NO,CONVERT(VARCHAR(11),BIRTH_DATE,106) BIRTH_DATE1,
		INTR_LAST_NAME + ' ' + INTR_FIRST_NAME +' '+INTR_MIDDLE_NAME INTRFULLNAME,
		REL_WITH_INTRODUCER,INTRODUCER_ACC_CODE 
		FROM CLIENT_MASTER A LEFT OUTER JOIN CLIENT_DETAIL_VIEW B
		ON  A.CLIENT_ID=B.CLIENT_ID
		AND A.COMPANY_CODE=B.COMPANY_CODE
		AND B.EXCHANGE='NSE'
		LEFT OUTER JOIN COMPANY_MASTER C ON
		A.COMPANY_CODE=C.COMPANY_CODE
		WHERE A.COMPANY_CODE 
		IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE EXCHANGE='NSE')  
		<cfif market eq 'ALL'>
		and B.market in ('Caps','Fo')
		<cfelse>
		and B.market='#market#'
		</cfif>
		and A.Client_Id ='#CLientID#'
		and ISNULL(C.FLG_NCX,'N') = 'N'
		--and LEN(B.PAN_NO)<> 10	
 		ORDER BY  A.CLIENT_ID,A.CLIENT_NAME,B.MARKET
</CFQUERY>
	<CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
		Select DEPOSITORY,DP_ID,CLIENT_DP_CODE
		FROM IO_DP_MASTER
		WHERE
			CLIENT_ID = '#CLientID#'
		AND DEFAULT_ACC = 'Yes'
	</CFQUERY>
	
	<CFQUERY NAME="GETBANKDETAILS" datasource="#Client.database#">
		SELECT Bank_Name,Bank_Address,Micr_Code,Bank_AcNo,ACC_OPEN_DATE,
			   BANK_ACCTYPE
		FROM  FA_CLIENT_BANK_DETAILS 
		Where
			Account_Code = '#CLientID#'
		And Default_Ac = 'Y'	
	</CFQUERY>
<CFOUTPUT>
	<TABLE WIDTH="100%" BORDER="1" CELLPADDING="0"  CELLSPACING="0">
		<CFLOOP QUERY="GETDETAILS">
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Client ID:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#CLient_ID#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Name:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				<CFIF Trim(CLIENTFULLNAME) neq ''>
				&nbsp;#CLIENTFULLNAME#
				<CFELSE>
				&nbsp;#CLIENT_NAME#
				</CFIF>
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				PAN No:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#Pan_No#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				MAPIN:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#MAPIN#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Registration Date:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#REGISTRATION_DATE#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Modified Date:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#Last_Modified_DATE#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Passport No:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#Passport_No#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Driving License:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#DRIVING_LICENSE#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Voters ID:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#VOTERS_ID_CARD#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Retioncard:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#RATIONCARD#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Address:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#RESI_ADDRESS#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Birth Date:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#BIRTH_DATE1#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Pin:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#PIN_CODE#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Resi Tel No:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#RESI_TEL_NO#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Bank Name:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#GETBANKDETAILS.Bank_Name#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Bank Address:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#GETBANKDETAILS.Bank_Address#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Bank A/c:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#GETBANKDETAILS.Bank_AcNo#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Depository:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#GetclientDpDetails.Depository#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				DP ID:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#GetclientDpDetails.DP_ID#
			</TH>
		</TR>
		<TR>
			<TH WIDTH="35%" ALIGN="LEFT">
				Benefitiary Code:
			</TH>
			<TH WIDTH="65%" ALIGN="LEFT">
				&nbsp;#GetclientDpDetails.Client_DP_Code#
			</TH>
		</TR>
		</CFLOOP>
	</TABLE>
</CFOUTPUT>	
</BODY>
</HTML>
