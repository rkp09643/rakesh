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
		B.MAPIN,B.PAN_NO,B.PASSPORT_NO,CONVERT(VARCHAR(11),B.PASSPORT_EXPIRY_DATE,106) PASSPORT_EXPIRY_DATE,CONVERT(VARCHAR(11),PASS_ISSUE_DATE,106) PASS_ISSUE_DATE1,
		PASSPORT_ISSUED_PLACE,
		RESI_FAX_NO,ISNULL(STD_Code,'0') STD_Code,CONVERT(VARCHAR(11),dr_lic_exp_date,106) dr_lic_exp_date,
		DRIVING_LICENSE,CONVERT(VARCHAR(11),DRIVING_LICENSE_ISSUED_DATE,106) DRIVING_LICENSE_ISSUED_DATE1,DRIVING_LICENSE_ISSUED_PLACE,
		VOTERS_ID_CARD, CONVERT(VARCHAR(11),VOTERS_ID_CARD_ISSUED_DATE,106) VOTERS_ID_CARD_ISSUED_DATE1,Place_Issue_Vouter_ID,
		RATIONCARD,RATIONCARD_ISSUED_PLACE,CONVERT(VARCHAR(11),RATIONCARD_expiry_DATE,106) RATIONCARD_expiry_DATE1,
		A.LAST_NAME + '' + A.FIRST_NAME+''+A.MIDDLE_NAME CLIENTFULLNAME,
		isnull(B.CATEGORY,'')CATEGORY,REG_ADDR RESI_ADDRESS,R_PIN_CODE PIN_CODE,R_STATE,R_COUNTRY,R_CITY,
		RESI_TEL_NO,CONVERT(VARCHAR(11),BIRTH_DATE,106) BIRTH_DATE1,
		INTR_LAST_NAME + '' + INTR_FIRST_NAME +''+INTR_MIDDLE_NAME INTRFULLNAME,ISNULL(INTRODUCER_NAME,'')INTRODUCER_NAME,
		REL_WITH_INTRODUCER,INTRODUCER_ACC_CODE ,Registration_Number,Registration_Authority,Place_Of_Reg,Convert(Varchar(11),Date_of_Reg,106)  Date_of_Reg,
			Convert(Varchar(11),A.REGISTRATION_DATE,106) REGISTRATION_DATE,Convert(Varchar(11),A.AGREEMENT_DATE,106)  AGREEMENT_DATE,
			A.First_Name,A.Middle_Name,A.Last_Name,UIN,NAME_NON_INDIVIDUAL,FATHER_HUSBAND_NAME,OFF_ADDRESS,Off_City,Off_Pin,
			OFF_TEL_NO,MOBILE_NO,Off_State,
			ISNULL(PAN_NAME,A.CLIENT_NAME) PAN_NAME
		FROM CLIENT_MASTER A LEFT OUTER JOIN CLIENT_DETAIL_VIEW B
		ON  
			A.CLIENT_ID=B.CLIENT_ID
		AND A.COMPANY_CODE=B.COMPANY_CODE
		LEFT OUTER JOIN COMPANY_MASTER C 
		ON
			A.COMPANY_CODE=C.COMPANY_CODE
		WHERE 
			A.COMPANY_CODE IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE EXCHANGE='NSE' AND FLG_NCX IN ('MCX','NCDX'))  
		AND A.COMPANY_CODE = '#COCD#'
		<cfif ActiveInactive eq "ACTIVE">
			<CFIF IsDefined('frdate') and IsDefined('todate')>
				AND (
					CONVERT(DATETIME, CONVERT(VarChar(10), A.LAST_MODIFIED_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#frdate#',103) 
					and CONVERT(DATETIME,'#todate#',103) 
					OR  CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#frdate#',103) 
					and CONVERT(DATETIME,'#todate#',103) 
					)
			</CFIF>
		</cfif>		
		and A.Client_Id in(#PreserveSingleQuotes(chkval)#)
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
	SELECT WEBX_ID BROKER_CODE,COMPANY_NAME  FROM  COMPANY_MASTER 
	WHERE 
		company_code='#cocd#'
</CFQUERY>

<CFIF not directoryexists("C:\COMMUCC\")>
	<CFDIRECTORY ACTION="CREATE" DIRECTORY="C:\COMMUCC\">
</CFIF>

 <SCRIPT LANGUAGE="VBScript">
	newfolderpath = "c:\COMMUCC" 
	Set FileSys = CreateObject("Scripting.FileSystemObject")
	If Not filesys.FolderExists(newfolderpath) Then 
		 Set newfolder = filesys.CreateFolder(newfolderpath) 
	End If
</SCRIPT>
	
<CFSET FILENAME = "C:\COMMUCC\CLI_#DateFormat(Now(),"DDMMYYYY")#.T#batchNo#">
<CFSET FILENAMELOG = "C:\COMMUCC\LOG_CLI_#DateFormat(Now(),"DDMMYYYY")#.T#batchNo#">

<!--- <CFIF left(batchNo,1) eq '0'>
	<CFSET batchNo="#right(batchNo,1)#">
</CFIF> --->
<CFIF FileExists('#FILENAME#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAME#"> 
</CFIF>
<CFIF FileExists('#FILENAMELOG#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAMELOG#"> 
</CFIF>

<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">
<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="10|M|#GETTRADINGCODE.BROKER_CODE#|#LEFT(TRIM(GETTRADINGCODE.COMPANY_NAME),80)#|#DateFormat(Now(),'DDMMYYYY')#|#batchNo#|#getClientDetails.RECORDCOUNT##CHR(10)#" ADDNEWLINE="NO">

<CFSET FINALSTRING = "">
<CFSET FINALSTRINGLOG = "">

	<CFIF cmbFileType EQ "New">
		<CFSET FileType12 = 'I'>
	<cfelse>
		<CFSET FileType12 = 'M'>	
	</CFIF>
	
<CFIF market eq "CAPS">
	<CFSET SEGMENT = "C">
<CFELSE>
	<CFSET SEGMENT = "F">
</CFIF>
<CFSET MissingBankDetails="Missing Bank Details For Clients :">
<CFSET MissingBankFLG=false>

<CFLOOP QUERY="getClientDetails">
	<cfset ERRORCODE = 0>
	<CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
		Select top 1 DEPOSITORY,DP_ID,CLIENT_DP_CODE,DP_NAME
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
				<CFSET CLIENTID						=		'#CLIENT_ID#'>
				<CFSET MAPIN1 						= 		"#LEFT(TRIM(GetClientDetails.MAPIN),9)#">
				<CFSET PAN_NO1 						= 		"#LEFT(TRIM(GetClientDetails.PAN_NO),10)#">
				<CFSET WARDNO						=		"">
				<CFSET PASSPORT_NO1 				=		"#LEFT(TRIM(GetClientDetails.PASSPORT_NO),25)#">
				<CFSET PASSPORT_ISSUED_PLACE1		= 		"#LEFT(TRIM(GetClientDetails.PASSPORT_ISSUED_PLACE),25)#">
				<CFSET Pass_Issue_Date				=		"#Dateformat(GetClientDetails.Pass_Issue_Date1,'DD-MMM-YYYY')#">
				<CFSET Pass_Exp_Date				=		"#Dateformat(GetClientDetails.PASSPORT_EXPIRY_DATE,'DD-MMM-YYYY')#">
				<CFSET DRIVING_LICENSE1				=		"#LEFT(TRIM(GetClientDetails.DRIVING_LICENSE),25)#">
				<CFSET DRIVING_LICENSE_ISSUED_PLACE1= 		"#LEFT(TRIM(GetClientDetails.DRIVING_LICENSE_ISSUED_PLACE),25)#">
				<CFSET dr_lic_exp_date1				= 		"#Dateformat(GetClientDetails.dr_lic_exp_date,"DD-MMM-YYYY")#">
				<CFSET DRIVING_LICENSE_ISSUED_DATE	= 		"#Dateformat(GetClientDetails.DRIVING_LICENSE_ISSUED_DATE1,"DD-MMM-YYYY")#">
				<CFSET VOTERS_ID_CARD1				=	 	"#LEFT(TRIM(GetClientDetails.VOTERS_ID_CARD),25)#">
				<CFSET Place_Issue_Vouter_ID1 		= 		"#LEFT(TRIM(GetClientDetails.Place_Issue_Vouter_ID),25)#">
				<CFSET VOTERS_ID_CARD_ISSUED_DATE 	= 		"#Dateformat(GetClientDetails.VOTERS_ID_CARD_ISSUED_DATE1,"DD-MMM-YYYY")#">
				<CFSET RATIONCARD1 					=		"#LEFT(TRIM(GetClientDetails.RATIONCARD),25)#">
				<CFSET RATIONCARD_ISSUED_PLACE1		=		"#LEFT(TRIM(GetClientDetails.RATIONCARD_ISSUED_PLACE),25)#">
				<CFSET RATIONCARD_EXPIRY_DATE 		=		"#DATEFORMAT(GetClientDetails.RATIONCARD_EXPIRY_DATE1,"DD-MMM-YYYY")#">
				<CFSET REGISTRATION_NO				=		"#LEFT(TRIM(GetClientDetails.Registration_Number),25)#">
				<CFSET REGISTRATION_AUTHORITY		=		"#LEFT(TRIM(GetClientDetails.Registration_Authority),60)#">
				<CFSET REGISTRATION_PLACE 			=		"#LEFT(TRIM(GetClientDetails.Place_Of_Reg),25)#">
				<CFSET REGISTRATION_DATE1			=		"#TRIM(DATEFORMAT(GetClientDetails.Date_of_Reg,"DD-MMM-YYYY"))#">
				<CFSET CLIENT_NAME1					=		"#TRIM(GetClientDetails.PAN_NAME)#">
				
				<CFIF GetClientDetails.CATEGORY EQ "PF">
					<CFSET RECORDTYPECODE = 30>
				<cfelse>
					<CFSET RECORDTYPECODE = 20>	
				</CFIF>
				
				<cfif trim(category) eq "I" OR trim(category) eq "NRI">
					<CFSET LASTNAME = "#left(TRIM(GetClientDetails.LAST_NAME),100)#">
					<CFSET FIRSTNAME = "#left(TRIM(GetClientDetails.FIRST_NAME),20)#">
					<CFSET MIDDLENAME = "#left(TRIM(GetClientDetails.MIDDLE_NAME),20)#">
				<CFELSE>
					<CFSET LASTNAME = "">
					<CFSET FIRSTNAME = "">
					<CFSET MIDDLENAME = "">
				</CFIF>	
				
				<!--- <CFIF TRIM(GetClientDetails.PAN_NAME) eq ''>
					<CFSET CLIENT_NAME				=		"#GetClientDetails.client_name#">
				</CFIF> --->
				
				<CFSET CATEGORY1					=		"">
				
				<CFIF GetClientDetails.CATEGORY EQ 'I'>
					<CFSET CATEGORY1				=		"01">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'PF'>
					<CFSET CATEGORY1				=		"02">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'HUF'>
					<CFSET CATEGORY1				=		"03">		
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'PVTLTD'>
					<CFSET CATEGORY1				=		"04">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'LTDCO'>
					<CFSET CATEGORY1				=		"05">					
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'COOP'>
					<CFSET CATEGORY1				=		"07">
				<CFELSE>
					<CFSET CATEGORY1				=		"99">		
				</CFIF>
				
				<CFSET Add1="#TRIM(GetToken(GetClientDetails.RESI_ADDRESS,1,'~'))#">
				<CFSET Add2="#TRIM(GetToken(GetClientDetails.RESI_ADDRESS,2,'~'))#">
				<CFSET Add3="#TRIM(GetToken(GetClientDetails.RESI_ADDRESS,3,'~'))#">
				
				<CFSET RESI_ADDRESS1	 			= 	"#Add1##Add2#">
				<!--- <CFIF RESI_ADDRESS1 eq "">
					<CFSET RESI_ADDRESS1			= 	"#REPLACE(GetClientDetails.RESI_ADDRESS,'~',' ','ALL')#">
				</CFIF>
				  --->
				<cfquery name="GETRESSTATECODE" datasource="#CLIENT.DATABASE#">
					SELECT *
					FROM STATE_MASTER
					WHERE
						STATE_CODE = '#R_STATE#'
				</cfquery>
				<CFSET RESSTATECODE = "#GETRESSTATECODE.NCDEX_CODE#">
				
				<cfquery name="GETOFFSTATECODE" datasource="#CLIENT.DATABASE#">
					SELECT *
					FROM STATE_MASTER
					WHERE
						STATE_CODE = '#OFF_STATE#'
				</cfquery>
				
				<CFSET OFFSTATECODE = "#GETOFFSTATECODE.NCDEX_CODE#">
				
				<CFSET PINCODE		 				= 	"#GetClientDetails.Pin_Code#">	
				<CFSET RESI_TEL_NO1	 				= 	"#STD_Code##TRIM(LEFT(GetClientDetails.RESI_TEL_NO,22))#">
				
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
				<CFELSEIF TYPE EQ "OD">
					<CFSET BANKTYPE 			= 	12>	
				<CFELSE>
					<CFSET BANKTYPE 			= 	99>
				</CFIF>
				
				<CFSET CLIENTBANKCODE 			= 	"#LEFT(TRIM(GETBANKDETAILS.Bank_AcNo),25)#">
				
				<CFSET DP_ID1					=	"#LEFT(TRIM(GetclientDpDetails.DP_ID),25)#">
				<CFSET DEPOSITORY1				=	"#LEFT(TRIM(GetclientDpDetails.DEPOSITORY),4)#">
				<CFSET CLIENT_DP_CODE1 			= 	"#LEFT(TRIM(GetclientDpDetails.CLIENT_DP_CODE),16)#">
				<CFSET DP_NAME1 				= 	"#TRIM(GetclientDpDetails.DP_NAME)#">
				
				<CFSET OTHERACCOUNT				=	"">
				<CFSET SETTLEMENTMODE			=	"">
				<CFSET CLIENTOTH				=	"">
				<CFSET FLAG						=	"E">
				<CFSET FINALSTRING = "#FINALSTRING#">
				<CFIF LEN(MAPIN) NEQ 9 >
					<CFSET MAPIN="">
				</CFIF>
				
				<CFSET FINALSTRING = "#FINALSTRING##RECORDTYPECODE#|#CLIENT_NAME1#|#CLIENTID#|#CATEGORY1#|">
				
				<!--- ,#LASTNAME#,#CATEGORY1#,#LEFT(TRIM(REPLACE(Add1,',',' ','ALL')),75)#
				,#LEFT(TRIM(REPLACE(Add2,',',' ','ALL')),75)#,#LEFT(TRIM(REPLACE(Add3,',',' ','ALL')),75)#,#R_CITY#,#R_STATE#,
				#R_COUNTRY#,#PIN_CODE#,#Replace(REPLACE(RESI_TEL_NO1,',',' ','ALL'),'-','','All')#,#AGREEMENT_DATE1#,#BIRTHDATE#,#PAN_NO1#,,#UIN#,"> --->
				<CFIF  len(GetClientDetails.PAN_NO) Neq 10>
					<CFSET ERRORCODE = 3>
				</CFIF>
				
				<CFIF CATEGORY1 EQ '04' OR CATEGORY1 EQ '05' OR CATEGORY1 EQ '07'>
					<CFIF  REGISTRATION_NO NEQ "" AND REGISTRATION_AUTHORITY NEQ "" AND REGISTRATION_PLACE NEQ "" AND REGISTRATION_DATE1 NEQ "">
						<CFSET FINALSTRING	   = "#FINALSTRING##REGISTRATION_NO#|#REGISTRATION_PLACE#|#REGISTRATION_DATE1#|#REGISTRATION_AUTHORITY#|">
					<CFELSE>
						<CFSET FINALSTRING	   = "#FINALSTRING#||||">
						<CFSET ERRORCODE = 1>
					</CFIF>
				<cfelse>
					<CFSET FINALSTRING	   = "#FINALSTRING#||||">	
				</CFIF>
				
				<CFIF NAME_NON_INDIVIDUAL EQ "">
					<CFSET PERSONANME = "#CLIENT_NAME1#">
				<cfelse>
					<CFSET PERSONANME = "#NAME_NON_INDIVIDUAL#">	
				</CFIF>
				
				<CFSET FINALSTRING = "#FINALSTRING##PERSONANME#|#BIRTHDATE#||#FATHER_HUSBAND_NAME#||">
				
				<CFIF CATEGORY1 EQ '04' OR CATEGORY1 EQ '05' OR CATEGORY1 EQ '07' OR CATEGORY1 EQ '02'>
					<CFIF OFF_ADDRESS NEQ "" and Off_City NEQ "" and Off_Pin NEQ "">
						<CFSET FINALSTRING = "#FINALSTRING##MID(OFF_ADDRESS,1,30)#|#MID(OFF_ADDRESS,31,30)#|#MID(OFF_ADDRESS,61,30)#|#Off_City#|#Off_Pin#|">
					<cfelse>
						<CFSET FINALSTRING = "#FINALSTRING#|||||">
						<CFSET ERRORCODE = 2>
					</CFIF>
				<cfelse>
					<CFSET FINALSTRING = "#FINALSTRING#|||||">
				</CFIF>
				
				<CFSET FINALSTRING = "#FINALSTRING##OFF_TEL_NO#|#MID(RESI_ADDRESS1,1,30)#|#MID(RESI_ADDRESS1,31,30)#|#MID(RESI_ADDRESS1,61,30)#|#R_CITY#|#PIN_CODE#|#Replace(REPLACE(RESI_TEL_NO1,',',' ','ALL'),'-','','All')#|#MOBILE_NO#|#PAN_NO1#||Y|">
				
				
				<CFIF PASSPORT_NO NEQ "" AND PASSPORT_ISSUED_PLACE NEQ "" AND Pass_Issue_Date NEQ "" and Pass_Exp_Date neq "">
					<CFSET FINALSTRING = "#FINALSTRING##PASSPORT_NO1#|#LEFT(REPLACE(PASSPORT_ISSUED_PLACE1,',','','ALL'),25)#|#Pass_Issue_Date#|#Pass_Exp_Date#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||">
				</CFIF>
				
				<CFIF DRIVING_LICENSE1 NEQ "" AND DRIVING_LICENSE_ISSUED_PLACE1 NEQ "" AND DRIVING_LICENSE_ISSUED_DATE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##DRIVING_LICENSE1#|#LEFT(REPLACE(DRIVING_LICENSE_ISSUED_PLACE1,',',' ','ALL'),25)#|#DRIVING_LICENSE_ISSUED_DATE#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
				
				<CFIF VOTERS_ID_CARD NEQ "" AND Place_Issue_Vouter_ID NEQ "" AND VOTERS_ID_CARD_ISSUED_DATE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##VOTERS_ID_CARD1#|#LEFT(REPLACE(Place_Issue_Vouter_ID1,',',' ','ALL'),25)#|#VOTERS_ID_CARD_ISSUED_DATE#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
				
				<CFIF RATIONCARD NEQ "" AND RATIONCARD_ISSUED_PLACE NEQ "" AND RATIONCARD_EXPIRY_DATE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##RATIONCARD1#|#LEFT(REPLACE(RATIONCARD_ISSUED_PLACE1,',',' ','ALL'),25)#|#RATIONCARD_EXPIRY_DATE#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
				
				<CFIF Bank_Name NEQ "" AND Bank_Add NEQ "" AND CLIENTBANKCODE NEQ "" >
					<CFSET FINALSTRING = "#FINALSTRING##LEFT(REPLACE(Bank_name,',','','ALL'),50)#|#LEFT(REPLACE(Bank_Add,',','','ALL'),120)#|#BANKTYPE#|#CLIENTBANKCODE#|">	
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||">
				</CFIF>
				
				
				<CFSET FINALSTRING = "#FINALSTRING#||||||">
				<!--- <CFIF DEPOSITORY1 EQ "NSDL">
					<CFIF  DP_ID1 NEQ "" AND DEPOSITORY1 NEQ "" AND CLIENT_DP_CODE1 NEQ "" >
						<CFSET FINALSTRING = "#FINALSTRING##DP_ID1#|#DP_NAME1#|#CLIENT_DP_CODE1#||||">	
					<CFELSE>
						<CFSET FINALSTRING = "#FINALSTRING#||||||">
					</CFIF>
				<cfelse>
					<CFIF  DP_ID1 NEQ "" AND DEPOSITORY1 NEQ "" AND CLIENT_DP_CODE1 NEQ "" >
						<CFSET FINALSTRING = "#FINALSTRING#|||#DP_ID1#|#DP_NAME1#|#CLIENT_DP_CODE1#|">	
					<CFELSE>
						<CFSET FINALSTRING = "#FINALSTRING#||||||">
					</CFIF>	
				</CFIF> --->
				<cfif ActiveInactive eq "ACTIVE">
					<CFSET FINALSTRING	   = "#FINALSTRING##FileType12#|N|||||||#OFFSTATECODE#|#RESSTATECODE#|||A|E">
				<cfelse>
					<CFSET FINALSTRING	   = "#FINALSTRING##FileType12#|N|||||||#OFFSTATECODE#|#RESSTATECODE#|||D|E">
				</cfif>		
					
				<CFSET FINALSTRING = "#FINALSTRING##CHR(10)#">				
				<CFSET FINALSTRINGLOG = "#FINALSTRINGLOG##CLIENT_ID# SuccesFully Generated#chr(10)#">
				
				<CFIF ERRORCODE EQ 1>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Reg. No / Reg. Authority / Reg. Place / Reg. Date is Missing.#chr(10)#">
				<cfelseif ERRORCODE EQ 2>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Office Address / Office City / Office Pin is Missing.#chr(10)#">
				<cfelseif ERRORCODE EQ 3>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Insert Proper Pan NO.#chr(10)#">	
				<cfelse>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Generated SucessFully.#chr(10)#">
				</cfif>
					
				<cfif len(FINALSTRINGLOG) gt 0>
					<CFFILE ACTION="APPEND" FILE="#FILENAMELOG#" OUTPUT="#FINALSTRINGLOG#" ADDNEWLINE="Yes">
				</cfif>
				
				<cfif ERRORCODE EQ 0 and len(FINALSTRING) gt 0>
					<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING#" ADDNEWLINE="No">		
				</cfif>
				
				<CFSET FINALSTRING = "">
				<CFSET FINALSTRINGLOG = "">
	</CFLOOP>
<!--- <CFIF Trim(MissingBankFLG) eq true>
	<SCRIPT>
		alert("#MissingBankDetails#");
	</SCRIPT>
	<CFABORT>
</CFIF> --->


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
