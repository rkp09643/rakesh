<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<TITLE>UCI File Generate </TITLE>
</HEAD>
<BODY  bgcolor="#FFFFCC" TOPMARGIN="0">
<CFPARAM NAME="chkval" DEFAULT="">
<CFPARAM NAME="frdate" DEFAULT="">
<CFPARAM NAME="todate" DEFAULT="">
<CFPARAM NAME="market" DEFAULT="">
<CFPARAM NAME="batchNo" DEFAULT="">
<CFPARAM NAME="chkClient" DEFAULT="Trd">
<CFOUTPUT>
<CFSET chkval="#Left(chkval,(Len(chkval)-1))#">
	
	<cfquery name="GetName" datasource="#Client.database#">
		select ltrim(rtrim(CHEKERUSERLIST)) CHEKERUSERLIST
			from system_settings
		where company_code = '#cocd#'
	</cfquery>


<CFQUERY NAME="GetClientDetails" datasource="#Client.database#">
	SELECT DISTINCT  A.CLIENT_ID,A.CLIENT_NAME,B.MARKET,A.COMPANY_CODE,A.REGISTRATION_DATE,A.LAST_MODIFIED_DATE,
		B.MAPIN,B.PAN_NO,B.PASSPORT_NO,B.PASSPORT_EXPIRY_DATE,CONVERT(VARCHAR(11),PASS_ISSUE_DATE,106) PASS_ISSUE_DATE1,
		PASSPORT_ISSUED_PLACE,
		DRIVING_LICENSE,CONVERT(VARCHAR(11),DRIVING_LICENSE_ISSUED_DATE,106) DRIVING_LICENSE_ISSUED_DATE1,DRIVING_LICENSE_ISSUED_PLACE,
		VOTERS_ID_CARD, CONVERT(VARCHAR(11),VOTERS_ID_CARD_ISSUED_DATE,106) VOTERS_ID_CARD_ISSUED_DATE1,Place_Issue_Vouter_ID,
		RATIONCARD,RATIONCARD_ISSUED_PLACE,CONVERT(VARCHAR(11),RATIONCARD_expiry_DATE,106) RATIONCARD_expiry_DATE1,
		A.LAST_NAME + '' + A.FIRST_NAME+''+A.MIDDLE_NAME CLIENTFULLNAME,
		isnull(B.CATEGORY,'')CATEGORY,REG_ADDR RESI_ADDRESS,R_PIN_CODE PIN_CODE,RESI_TEL_NO,CONVERT(VARCHAR(11),BIRTH_DATE,106) BIRTH_DATE1,
		INTR_LAST_NAME + '' + INTR_FIRST_NAME +''+INTR_MIDDLE_NAME INTRFULLNAME,ISNULL(INTRODUCER_NAME,'')INTRODUCER_NAME,
		REL_WITH_INTRODUCER,INTRODUCER_ACC_CODE ,Registration_Number,Registration_Authority,Place_Of_Reg,Convert(Varchar(11),Date_of_Reg,106)  Date_of_Reg,
			Convert(Varchar(11),A.REGISTRATION_DATE,106) REGISTRATION_DATE,Convert(Varchar(11),A.AGREEMENT_DATE,106)  AGREEMENT_DATE,
		ISNULL(PAN_NAME,A.CLIENT_NAME) PAN_NAME
		FROM CLIENT_MASTER A LEFT OUTER JOIN CLIENT_DETAIL_VIEW B
		ON  A.CLIENT_ID=B.CLIENT_ID
		AND A.COMPANY_CODE=B.COMPANY_CODE
		AND B.EXCHANGE='NSE'
		LEFT OUTER JOIN COMPANY_MASTER C ON
		A.COMPANY_CODE=C.COMPANY_CODE
		WHERE A.COMPANY_CODE 
		IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE EXCHANGE='NSE')  
		<CFIF IsDefined('frdate') and IsDefined('todate')>
			AND (
				CONVERT(DATETIME, CONVERT(VarChar(10), A.LAST_MODIFIED_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#frdate#',103) 
				and CONVERT(DATETIME,'#todate#',103) 
				OR  CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#frdate#',103) 
				and CONVERT(DATETIME,'#todate#',103) 
				)
		</CFIF>
		and B.market='#market#'
		and A.Client_Id in(#PreserveSingleQuotes(chkval)#)
		<cfif cocd eq 'cd_nse'>
			and ISNULL(C.FLG_NCX,'N') = 'CD'
		<CFELSE>
			and ISNULL(C.FLG_NCX,'N') = 'N'
		</cfif>		
		and isnull(B.CATEGORY,'')!=''
		and (isnull(RTRIM(LTRIM(A.LAST_NAME + '' + A.FIRST_NAME+''+A.MIDDLE_NAME)),'') !='' or isnull(A.CLIENT_NAME,'')!='')
		and LTRIM(RTRIM(RESI_ADDRESS)) !=''
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(A.CHEKING,'N') = 'Y'
		</cfif>		
		<CFIF IsDefined('chkClient') and chkClient eq 'Trd'>
		and A.CLIENT_ID IN(SELECT DISTINCT CLIENT_ID FROM TRADE1 WHERE COMPANY_CODE=A.COMPANY_CODE
			AND CONVERT(DATETIME,TRADE_DATE,103)  BETWEEN CONVERT(DATETIME,'#frdate#',103) 
			and CONVERT(DATETIME,'#todate#',103)) 			
		</CFIF>			
 		ORDER BY  A.CLIENT_ID,A.CLIENT_NAME,B.MARKET
</CFQUERY>

<CFIF GetClientDetails.recordcount eq 0>
	<SCRIPT>
		alert("No Data Found");
	</SCRIPT>
	<CFABORT>
</CFIF>

<CFQUERY NAME="GETTRADINGCODE" datasource="#Client.database#">
	SELECT WEBX_ID BROKER_CODE  FROM  COMPANY_MASTER 
	WHERE 
		company_code='#cocd#'
</CFQUERY>
<CFIF not directoryexists("C:\NSEUCI\")>
	<CFDIRECTORY ACTION="CREATE" DIRECTORY="C:\NSEUCI\">
</CFIF>
<CFSET FILENAME = "C:\NSEUCI\UCI_#DateFormat(Now(),"YYYYMMDD")#.T#batchNo#">
<CFSET FILENAMELOG = "C:\NSEUCI\LOG_UCI_#DateFormat(Now(),"YYYYMMDD")#.T#batchNo#">

<CFIF left(batchNo,1) eq '0'>
	<CFSET batchNo="#right(batchNo,1)#">
</CFIF>
<CFIF FileExists('#FILENAME#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAME#"> 
</CFIF>
<CFIF FileExists('#FILENAMELOG#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAMELOG#"> 
</CFIF>

<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">
<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="10|M|#GETTRADINGCODE.BROKER_CODE#|#DateFormat(Now(),'DDMMYYYY')#|#batchNo#|#getClientDetails.RECORDCOUNT##CHR(10)#" ADDNEWLINE="NO">

<CFSET FINALSTRING = "">
<CFSET FINALSTRINGLOG = "">

<CFIF market eq "CAPS">
	<CFSET SEGMENT = "C">
<CFELSE>
	<CFSET SEGMENT = "F">
</CFIF>
<CFSET MissingBankDetails="Missing Bank Details For Clients :">
<CFSET MissingBankFLG=false>

<CFLOOP QUERY="getClientDetails">
	<CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
		Select top 1 DEPOSITORY,DP_ID,CLIENT_DP_CODE
		FROM IO_DP_MASTER
		WHERE
			CLIENT_ID = '#getClientDetails.CLIENT_ID#'
		ORDER BY  DEFAULT_ACC DESC
	</CFQUERY>
	
	<CFQUERY NAME="GETBANKDETAILS" datasource="#Client.database#">
		SELECT top 1 Bank_Name,Bank_Address,Micr_Code,Bank_AcNo,ACC_OPEN_DATE,
			   BANK_ACCTYPE
		FROM  FA_CLIENT_BANK_DETAILS 
		Where
			Account_Code = '#getClientDetails.Client_id#'
		order by Default_Ac desc 
	</CFQUERY>
	
	<!--- <CFIF GETBANKDETAILS.RECORDCOUNT EQ 0>
		<CFSET MissingBankDetails="#MissingBankDetails##CLIENT_ID#,">
		<CFSET MissingBankFLG=true>
	</CFIF>  GETBANKDETAILS.recordcount neq 0 and GetclientDpDetails.recordcount neq 0 and--->
	<CFIF  len(GetClientDetails.PAN_NO) eq 10>				
				<CFSET CLIENTID						=		'#CLIENT_ID#'>
				<CFSET MAPIN1 						= 		"#LEFT(TRIM(GetClientDetails.MAPIN),9)#">
				<CFSET PAN_NO1 						= 		"#LEFT(TRIM(GetClientDetails.PAN_NO),10)#">
				<CFSET WARDNO						=		"">
				<CFSET PASSPORT_NO1 				=		"#LEFT(TRIM(GetClientDetails.PASSPORT_NO),25)#">
				<CFSET PASSPORT_ISSUED_PLACE1		= 		"#LEFT(TRIM(GetClientDetails.PASSPORT_ISSUED_PLACE),25)#">
				<CFSET Pass_Issue_Date				=		"#Dateformat(GetClientDetails.Pass_Issue_Date1,'DD-MMM-YYYY')#">
				<CFSET DRIVING_LICENSE1				=		"#LEFT(TRIM(GetClientDetails.DRIVING_LICENSE),25)#">
				<CFSET DRIVING_LICENSE_ISSUED_PLACE1= 		"#LEFT(TRIM(GetClientDetails.DRIVING_LICENSE_ISSUED_PLACE),25)#">
				<CFSET DRIVING_LICENSE_ISSUED_DATE	= 		"#Dateformat(GetClientDetails.DRIVING_LICENSE_ISSUED_DATE1,"dd-mmm-yyyy")#">
				<CFSET VOTERS_ID_CARD1				=	 	"#LEFT(TRIM(GetClientDetails.VOTERS_ID_CARD),25)#">
				<CFSET Place_Issue_Vouter_ID1 		= 		"#LEFT(TRIM(GetClientDetails.Place_Issue_Vouter_ID),25)#">
				<CFSET VOTERS_ID_CARD_ISSUED_DATE 	= 		"#Dateformat(GetClientDetails.VOTERS_ID_CARD_ISSUED_DATE1,"dd-mmm-yyyy")#">
				<CFSET RATIONCARD1 					=		"#LEFT(TRIM(GetClientDetails.RATIONCARD),25)#">
				<CFSET RATIONCARD_ISSUED_PLACE1		=		"#LEFT(TRIM(GetClientDetails.RATIONCARD_ISSUED_PLACE),25)#">
				<CFSET RATIONCARD_EXPIRY_DATE 		=		"#DATEFORMAT(GetClientDetails.RATIONCARD_EXPIRY_DATE1,"DD-MMM-YYYY")#">
				<CFSET REGISTRATION_NO				=		"#LEFT(TRIM(GetClientDetails.Registration_Number),25)#">
				<CFSET REGISTRATION_AUTHORITY		=		"#LEFT(TRIM(GetClientDetails.Registration_Authority),60)#">
				<CFSET REGISTRATION_PLACE 			=		"#LEFT(TRIM(GetClientDetails.Place_Of_Reg),25)#">
				<CFSET REGISTRATION_DATE1			=		"#TRIM(DATEFORMAT(GetClientDetails.Date_of_Reg,"DD-MMM-YYYY"))#">
				<CFSET CLIENT_NAME1					=		"#TRIM(GetClientDetails.PAN_NAME)#">
				<!--- <CFIF TRIM(GetClientDetails.PAN_NAME) eq ''>
					<CFSET CLIENT_NAME				=		"#GetClientDetails.client_name#">
				</CFIF> --->
				<CFSET CATEGORY1					=		"">
				<CFIF GetClientDetails.CATEGORY EQ 'I'>
					<CFSET CATEGORY1				=		"1">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'PF'>
					<CFSET CATEGORY1				=		"2">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'HUF'>
					<CFSET CATEGORY1				=		"3">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'CO'>
					<CFSET CATEGORY1				=		"4">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'TS'>
					<CFSET CATEGORY1				=		"5">	
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'MF'>
					<CFSET CATEGORY1				=		"6">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'IFI'>
					<CFSET CATEGORY1				=		"7">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'B'>
					<CFSET CATEGORY1				=		"8">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'LIC'>
					<CFSET CATEGORY1				=		"9">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'SB'>
					<CFSET CATEGORY1				=		"10">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'NRI'>
					<CFSET CATEGORY1				=		"11">				
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'FII'>
					<CFSET CATEGORY1				=		"12">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ '0CB'>
					<CFSET CATEGORY1				=		"13">					
				</CFIF>
				<CFSET Add1="#GetToken(GetClientDetails.RESI_ADDRESS,1,'~')#">
				<CFSET Add2="#GetToken(GetClientDetails.RESI_ADDRESS,2,'~')#">
				<CFSET Add3="#GetToken(GetClientDetails.RESI_ADDRESS,3,'~')#">
				<CFSET RESI_ADDRESS1	 			= 	"#Add1##Add2##GetToken(Add3,1,'-')#">
				<!--- <CFIF RESI_ADDRESS1 eq "">
					<CFSET RESI_ADDRESS1			= 	"#REPLACE(GetClientDetails.RESI_ADDRESS,'~',' ','ALL')#">
				</CFIF>
				  --->
				<CFSET PINCODE		 				= 	"#GetClientDetails.Pin_Code#">	
				<CFSET RESI_TEL_NO1	 				= 	"#TRIM(LEFT(GetClientDetails.RESI_TEL_NO,25))#">
				
				<CFIF TRIM(Category) eq "I">
					<CFSET BIRTHDATE	 				= 	"#DateFormat(GetClientDetails.BIRTH_DATE1,'DD-MMM-YYYY')#">
				<CFELSE>
					<CFSET BIRTHDATE	 				= 	"">
				</CFIF>
			
				<CFIF LEN(GetClientDetails.AGREEMENT_DATE) GT 0>					
					<CFSET AGREEMENT_DATE1			 	= 	"#DATEFORMAT(GetClientDetails.AGREEMENT_DATE,"DD-MMM-YYYY")#">	
				<CFELSE>					
					<CFSET AGREEMENT_DATE1			 	= 	"#DATEFORMAT(GetClientDetails.REGISTRATION_DATE,"DD-MMM-YYYY")#">		
				</CFIF>
				
				<CFSET INTRODUCER_NAME = "#Trim(GetClientDetails.INTRODUCER_NAME)#">
				<CFSET RELWITHINT		= "">
				<CFSET INTRODUCER_ACC_CODE = "">
				
				
				
				<CFSET Bank_name				= 	"#LEFT(TRIM(GETBANKDETAILS.Bank_Name),60)#">
				<CFSET Bank_Add					= 	"#LEFT(TRIM(GETBANKDETAILS.Bank_Address),225)#">
				<CFSET TYPE						=	"#TRIM(GETBANKDETAILS.BANK_ACCTYPE)#">
				
				<CFIF TYPE EQ "SAVING">
					<CFSET BANKTYPE 			= 	10>
				<CFELSEIF TYPE EQ "CURRENT">
					<CFSET BANKTYPE 			= 	11>
				<CFELSE>
					<CFSET BANKTYPE 			= 	10>
				</CFIF>
				<CFSET CLIENTBANKCODE 			= 	"#LEFT(TRIM(GETBANKDETAILS.Bank_AcNo),25)#">
				<CFSET DP_ID1					=	"#LEFT(TRIM(GetclientDpDetails.DP_ID),25)#">
				<CFSET DEPOSITORY1				=	"#LEFT(TRIM(GetclientDpDetails.DEPOSITORY),4)#">
				<CFSET CLIENT_DP_CODE1 			= 	"#LEFT(TRIM(GetclientDpDetails.CLIENT_DP_CODE),16)#">
				<CFSET OTHERACCOUNT				=	"">
				<CFSET SETTLEMENTMODE			=	"">
				<CFSET CLIENTOTH				=	"">
				<CFSET FLAG						=	"E">
				<CFSET FINALSTRING = "#FINALSTRING#">
				<CFIF LEN(MAPIN) NEQ 9 >
					<CFSET MAPIN="">
				</CFIF>
				<CFSET FINALSTRING = "#FINALSTRING##SEGMENT#|#CLIENTID#|#MAPIN1#|#PAN_NO1#|#WARDNO#|">
				<CFIF PASSPORT_NO NEQ "" AND PASSPORT_ISSUED_PLACE NEQ "" AND Pass_Issue_Date NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##PASSPORT_NO1#|#PASSPORT_ISSUED_PLACE1#|#Pass_Issue_Date#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
				
				<CFIF DRIVING_LICENSE NEQ "" AND DRIVING_LICENSE_ISSUED_PLACE NEQ "" AND DRIVING_LICENSE_ISSUED_DATE NEQ "" >
					<CFSET FINALSTRING = "#FINALSTRING##DRIVING_LICENSE1#|#DRIVING_LICENSE_ISSUED_PLACE1#|#DRIVING_LICENSE_ISSUED_DATE#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
				
				<CFIF VOTERS_ID_CARD NEQ "" AND Place_Issue_Vouter_ID NEQ "" AND VOTERS_ID_CARD_ISSUED_DATE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##VOTERS_ID_CARD1#|#Place_Issue_Vouter_ID1#|#VOTERS_ID_CARD_ISSUED_DATE#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
				
				<CFIF RATIONCARD NEQ "" AND RATIONCARD_ISSUED_PLACE NEQ "" AND RATIONCARD_EXPIRY_DATE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##RATIONCARD1#|#RATIONCARD_ISSUED_PLACE1#|#RATIONCARD_EXPIRY_DATE#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
				
				<CFIF GetClientDetails.CATEGORY NEQ 'I' AND REGISTRATION_NO NEQ "" AND REGISTRATION_AUTHORITY NEQ "" AND REGISTRATION_PLACE NEQ "" AND REGISTRATION_DATE1 NEQ "">
					<CFSET FINALSTRING	   = "#FINALSTRING##REGISTRATION_NO#|#REGISTRATION_AUTHORITY#|#REGISTRATION_PLACE#|#REGISTRATION_DATE1#|">
				<CFELSE>
					<CFSET FINALSTRING	   = "#FINALSTRING#||||">
				</CFIF>
				
				<CFSET FINALSTRING	   = "#FINALSTRING##CLIENT_NAME1#|#CATEGORY1#|#RESI_ADDRESS1#|#PINCODE#|#Replace(RESI_TEL_NO1,'-','','All')#|#BIRTHDATE#|#AGREEMENT_DATE1#|#INTRODUCER_NAME#|#RELWITHINT#|#INTRODUCER_ACC_CODE#|">
					
				<CFIF <!---  RATIONCARD NEQ "" AND RATIONCARD_ISSUED_PLACE NEQ "" AND RATIONCARD_EXPIRY_DATE NEQ ""  AND---> Bank_Name NEQ "" AND Bank_Add NEQ "" AND CLIENTBANKCODE NEQ ""  AND BANKTYPE NEQ 99 >
					<CFSET FINALSTRING = "#FINALSTRING##Bank_name#|#Bank_Add#|#BANKTYPE#|#CLIENTBANKCODE#|">	
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||">
				</CFIF>
					
				<CFIF  <!--- RATIONCARD NEQ "" AND RATIONCARD_ISSUED_PLACE NEQ "" AND RATIONCARD_EXPIRY_DATE NEQ "" AND---> DP_ID1 NEQ "" AND DEPOSITORY1 NEQ "" AND CLIENT_DP_CODE1 NEQ "" >
					<CFSET FINALSTRING = "#FINALSTRING##DP_ID1#|#DEPOSITORY1#|#CLIENT_DP_CODE1#|">	
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||">
				</CFIF>
				<CFSET FINALSTRING = "#FINALSTRING##OTHERACCOUNT#|#SETTLEMENTMODE#|#CLIENTOTH#|#FLAG#">
<!--- 				<cfif currentrow neq getClientDetails.recordcount >--->
				<CFSET FINALSTRING = "#FINALSTRING##CHR(10)#">
				<CFSET FINALSTRINGLOG = "#FINALSTRINGLOG##CLIENT_ID# SuccesFully Generated#chr(10)#">
				<!--- <SCRIPT>
					alert("#FINALSTRING#");
				</SCRIPT> --->
				<!--- </cfif> --->
	<CFELSE>
		<CFSET FINALSTRINGLOG = "#FINALSTRINGLOG#For #CLIENT_ID# Pan No is Missing#chr(10)#">
	</CFIF> 
</CFLOOP>
<!--- <CFIF Trim(MissingBankFLG) eq true>
	<SCRIPT>
		alert("#MissingBankDetails#");
	</SCRIPT>
	<CFABORT>
</CFIF> --->
<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING#" ADDNEWLINE="no">
<CFFILE ACTION="APPEND" FILE="#FILENAMELOG#" OUTPUT="#FINALSTRINGLOG#" ADDNEWLINE="no">

<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">


<CFSET	ClientFileGenerated	=	CopyFile("#FileName#","#FileName#")>
<CFSET	ClientFileGenerated1	=	CopyFile("#FILENAMELOG#","#FILENAMELOG#")>

<CFIF  ClientFileGenerated>
	<SCRIPT>
		alert("File Generated On Client Machine #REPLACE(FILENAME,'\','\\','ALL')#");
	</SCRIPT>
</CFIF>
			
<CFIF ClientFileGenerated1>
	<SCRIPT>
		alert("Log File Generated on Client Machine #REPLACE(FILENAMELOG,'\','\\','ALL')#");
	</SCRIPT>
</CFIF>

FILE GENERATED On Your <A target="blank" HREF="FILE:\\#Server_NAme#\#Replace(FileName,":","")#">#FileName1#.
</CFOUTPUT>
</BODY>
</HTML>
