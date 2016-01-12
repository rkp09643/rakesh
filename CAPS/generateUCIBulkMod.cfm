
<HTML>
<HEAD>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
<TITLE>UCI File Generate </TITLE>
</HEAD>
<BODY  bgcolor="#FFFFCC" TOPMARGIN="0">
<CFPARAM NAME="chkval" DEFAULT="">
<CFPARAM NAME="companyval" DEFAULT="">
<CFPARAM NAME="frdate" DEFAULT="">
<CFPARAM NAME="todate" DEFAULT="">
<CFPARAM NAME="market" DEFAULT="">
<CFPARAM NAME="batchNo" DEFAULT="">
<CFPARAM NAME="chkClient" DEFAULT="Trd">
<CFOUTPUT>

<CFSET chkval="#Left(chkval,(Len(chkval)-1))#">
<CFSET companyval="#Left(companyval,(Len(companyval)-1))#">
	
<cfquery name="getsystemsettingsvalue" datasource="#client.database#">
	select ISNULL(UCCEXPORT_COMPULSORY,'N') UCCEXPORT_COMPULSORY
	FROM SYSTEM_SETTINGS
	WHERE
		COMPANY_CODE = '#COCD#'
</cfquery>
	
	<cfquery name="GetName" datasource="#Client.database#">
		select ltrim(rtrim(CHEKERUSERLIST)) CHEKERUSERLIST
			from system_settings
		where company_code = '#cocd#'
	</cfquery>

<CFQUERY NAME="GetClientDetails" datasource="#Client.database#">
	SELECT DISTINCT  A.CLIENT_ID,A.CLIENT_NAME,B.MARKET MARKET1,A.COMPANY_CODE,A.REGISTRATION_DATE,A.LAST_MODIFIED_DATE,
		B.MAPIN,B.PAN_NO,B.PASSPORT_NO,B.PASSPORT_EXPIRY_DATE,CONVERT(VARCHAR(11),PASS_ISSUE_DATE,106) PASS_ISSUE_DATE1,
		PASSPORT_ISSUED_PLACE,
		DRIVING_LICENSE,CONVERT(VARCHAR(11),DRIVING_LICENSE_ISSUED_DATE,106) DRIVING_LICENSE_ISSUED_DATE1,DRIVING_LICENSE_ISSUED_PLACE,
		VOTERS_ID_CARD, CONVERT(VARCHAR(11),VOTERS_ID_CARD_ISSUED_DATE,106) VOTERS_ID_CARD_ISSUED_DATE1,Place_Issue_Vouter_ID,
		RATIONCARD,RATIONCARD_ISSUED_PLACE,CONVERT(VARCHAR(11),RATIONCARD_expiry_DATE,106) RATIONCARD_expiry_DATE1,
		A.LAST_NAME + '' + A.FIRST_NAME+''+A.MIDDLE_NAME CLIENTFULLNAME,
		isnull(B.CATEGORY,'')CATEGORY,RESI_ADDRESS R_RESI_ADDRESS,REG_ADDR RESI_ADDRESS,PIN_CODE R_PIN_CODE,R_PIN_CODE PIN_CODE,RESI_TEL_NO,CONVERT(VARCHAR(11),BIRTH_DATE,106) BIRTH_DATE1,
		INTR_LAST_NAME + '' + INTR_FIRST_NAME +''+INTR_MIDDLE_NAME INTRFULLNAME,ISNULL(INTRODUCER_NAME,'')INTRODUCER_NAME,
		REL_WITH_INTRODUCER,INTRODUCER_ACC_CODE ,Registration_Number,Registration_Authority,Place_Of_Reg,Convert(Varchar(11),Date_of_Reg,106)  Date_of_Reg,
		Convert(Varchar(11),A.REGISTRATION_DATE,106) REGISTRATION_DATE,Convert(Varchar(11),A.AGREEMENT_DATE,106)  AGREEMENT_DATE,
		CLIENT_ID_MAIL,R_CITY,R_STATE,R_COUNTRY,ISD_CODE,STD_CODE,MOBILE_NO,CITY CITY1,STATE STATE1,COUNTRY COUNTRY1,RegState_Others,
		Contact_Person1,Designation_Person1,PanNo_Person1,Address_Person1,TelNo_Person1,EmailId_Person1,Contact_Person2,Designation_Person2,
		PanNo_Person2,Address_Person2,TelNo_Person2,EmailId_Person2,Contact_Person3,Designation_Person3,PanNo_Person3,Address_Person3,
		TelNo_Person3,EmailId_Person3,Convert(Varchar(11),Date_Of_Incorporation,106)  Date_of_INCORPORATION,ltrim(rtrim(ISNULL(Person_verify,'N'))) Person_verify,
		ISNULL(PAN_NAME,A.CLIENT_NAME) PAN_NAME,UpdationFlag,RelationShip,MasterPan,TypeOfFacility,CIN, SEX,FATHER_HUSBAND_NAME,upper(isnull(MARITAL_STATUS,'S'))MARITAL_STATUS
		,case when NATIONALITY IN ('I','RI') THEN 1 ELSE 2 END NATIONALITY ,NATIONALITY_OTHERS,BIRTH_DATE
		,STATE_OTHERS ,ISDCODE_off,STD_CODE_off,Off_TEL_NO ,UID,ANNUAL_INCOME ,GrossAnnualIncomeDate ,A.CLIENT_NATURE,
		PORTFOLIO_MKT_VALUE Net_Worth ,Net_Worth_Date ,ISNULL(Political_Affilication,0)Political_Affilication ,PlaceofIncorporation ,OCCUPATION ,OCCUPATION_OTHERS 
		,Dateofcommencement ,Unique_Cl_Id ,DIN_PERSON1,UID_PERSON1,DIN_PERSON2,UID_PERSON2,DIN_PERSON3,UID_PERSON3 
		,Contact_Person4,Designation_Person4,PanNo_Person4,Address_Person4,TelNo_Person4,EmailId_Person4,DIN_Person4,UID_Person4
		,Contact_Person5,Designation_Person5,PanNo_Person5,Address_Person5,TelNo_Person5,EmailId_Person5,DIN_Person5,UID_Person5
		,Contact_Person6,Designation_Person6,PanNo_Person6,Address_Person6,TelNo_Person6,EmailId_Person6,DIN_Person6,UID_Person6
		,Contact_Person7,Designation_Person7,PanNo_Person7,Address_Person7,TelNo_Person7,EmailId_Person7,DIN_Person7,UID_Person7
		,Contact_Person8,Designation_Person8,PanNo_Person8,Address_Person8,TelNo_Person8,EmailId_Person8,DIN_Person8,UID_Person8
		,Contact_Person9,Designation_Person9,PanNo_Person9,Address_Person9,TelNo_Person9,EmailId_Person9,DIN_Person9,UID_Person9
		,Contact_Person10,Designation_Person10,PanNo_Person10,Address_Person10,TelNo_Person10,EmailId_Person10,DIN_Person10,UID_Person10
		,Contact_Person11,Designation_Person11,PanNo_Person11,Address_Person11,TelNo_Person11,EmailId_Person11,DIN_Person11,UID_Person11
		,Contact_Person12,Designation_Person12,PanNo_Person12,Address_Person12,TelNo_Person12,EmailId_Person12,DIN_Person12,UID_Person12
		,Contact_Person13,Designation_Person13,PanNo_Person13,Address_Person13,TelNo_Person13,EmailId_Person13,DIN_Person13,UID_Person13
		,Contact_Person14,Designation_Person14,PanNo_Person14,Address_Person14,TelNo_Person14,EmailId_Person14,DIN_Person14,UID_Person14
		,Contact_Person15,Designation_Person15,PanNo_Person15,Address_Person15,TelNo_Person15,EmailId_Person15,DIN_Person15,UID_Person15
		,Contact_Person16,Designation_Person16,PanNo_Person16,Address_Person16,TelNo_Person16,EmailId_Person16,DIN_Person16,UID_Person16
		,Contact_Person17,Designation_Person17,PanNo_Person17,Address_Person17,TelNo_Person17,EmailId_Person17,DIN_Person17,UID_Person17
		,Contact_Person18,Designation_Person18,PanNo_Person18,Address_Person18,TelNo_Person18,EmailId_Person18,DIN_Person18,UID_Person18
		,Contact_Person19,Designation_Person19,PanNo_Person19,Address_Person19,TelNo_Person19,EmailId_Person19,DIN_Person19,UID_Person19
		,Contact_Person20,Designation_Person20,PanNo_Person20,Address_Person20,TelNo_Person20,EmailId_Person20,DIN_Person20,UID_Person20
		,OTHER_DETAIL_ID,OTHER_DETAIL_NAME,OTHER_ISSUE_DATE,OTHER_PLACE,Correspondance_Address_Proof
		FROM CLIENT_MASTER A LEFT OUTER JOIN CLIENT_DETAIL_VIEW B
		ON  A.CLIENT_ID=B.CLIENT_ID
		AND A.COMPANY_CODE=B.COMPANY_CODE
		AND B.EXCHANGE='NSE'
		LEFT OUTER JOIN COMPANY_MASTER C ON
		A.COMPANY_CODE=C.COMPANY_CODE
		WHERE A.COMPANY_CODE 
		IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE EXCHANGE='NSE')  
		<Cfif Brokerage1 neq 'Y'>
			<CFIF IsDefined('frdate') and IsDefined('todate')>
				AND (
					CONVERT(DATETIME, CONVERT(VarChar(10), A.LAST_MODIFIED_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#frdate#',103) 
					and CONVERT(DATETIME,'#todate#',103) 
					OR  CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#frdate#',103) 
					and CONVERT(DATETIME,'#todate#',103) 
					)
			</CFIF>
		</Cfif>
		<!--- <cfif market eq "">
			AND b.market IN ('CAPS','FO')
			AND A.COMPANY_CODE  IN ('NSE_CASH','NSE_SLBM','NSE_FNO','CD_NSE')
		<cfelse>
			and b.market='#market#'
		</cfif>
		<CFIF COCD EQ "CD_NSE">
			AND A.COMPANY_CODE  = 'CD_NSE'
		</CFIF> --->
		and A.COMPANY_CODE in(#PreserveSingleQuotes(companyval)#)
		<cfif market Neq "">
			<cfif cocd eq 'cd_nse'>
				and ISNULL(C.FLG_NCX,'N') = 'CD'
			<CFELSE>
				and ISNULL(C.FLG_NCX,'N') = 'N'
			</cfif>
		</cfif>
		
		and A.Client_Id in(#PreserveSingleQuotes(chkval)#)
		<!--- <cfif cocd eq 'cd_nse'>
			and ISNULL(C.FLG_NCX,'N') = 'CD'
		<CFELSE>
			and A.COMPANY_CODE  IN ('cd_nse')
			and ISNULL(C.FLG_NCX,'N') = 'N'
		</cfif> --->
		and isnull(B.CATEGORY,'')!=''
		and (isnull(RTRIM(LTRIM(A.LAST_NAME + '' + A.FIRST_NAME+''+A.MIDDLE_NAME)),'') !='' or isnull(A.CLIENT_NAME,'')!='')
		and LTRIM(RTRIM(RESI_ADDRESS)) !=''
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(A.CHEKING,'N') = 'Y'
		</cfif>		
		
		<CFIF IsDefined('chkClient') and chkClient eq 'Trd'>
			AND A.CLIENT_ID IN(SELECT DISTINCT CLIENT_ID FROM TRADE1 WHERE COMPANY_CODE=A.COMPANY_CODE
			AND CONVERT(DATETIME,TRADE_DATE,103)  BETWEEN CONVERT(DATETIME,'#frdate#',103) 
			AND CONVERT(DATETIME,'#todate#',103)) 			
		</CFIF>
		AND A.CLIENT_ID IN(SELECT DISTINCT CLIENT_ID FROM BROKERAGE_APPLY WHERE COMPANY_CODE=A.COMPANY_CODE
							AND ACTIVE_INACTIVE ='A'
							AND ISNULL(END_DATE ,'') = ''
								<Cfif Brokerage1 eq 'Y'>
									AND CONVERT(DATETIME, START_DATE, 103) BETWEEN CONVERT(DATETIME,'#frdate#',103) 
										and CONVERT(DATETIME,'#todate#',103) 
								</Cfif>
							)
							
 		ORDER BY  A.CLIENT_ID,A.CLIENT_NAME,MARKET1
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

<!--- <cfif COCD NEQ "CD_NSE"> --->
	<CFSET FILENAME = "C:\NSEUCI\UCI_MOD_#DateFormat(Now(),"YYYYMMDD")#.T#batchNo#">
	<CFSET FILENAMELOG = "C:\NSEUCI\LOG_UCI_MOD_#DateFormat(Now(),"YYYYMMDD")#.T#batchNo#">
<!--- <cfelse>
	<CFSET FILENAME = "C:\NSEUCI\CDS_#DateFormat(Now(),"YYYYMMDD")#.T#batchNo#">
	<CFSET FILENAMELOG = "C:\NSEUCI\LOG_CDS_#DateFormat(Now(),"YYYYMMDD")#.T#batchNo#">	
</cfif> --->

<CFIF left(batchNo,1) eq '0'>
	<CFSET batchNo="#batchNo#">
</CFIF>

<CFIF FileExists('#FILENAME#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAME#"> 
</CFIF>

<CFIF FileExists('#FILENAMELOG#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAMELOG#"> 
</CFIF>

<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">
<!--- <CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="10|M|#GETTRADINGCODE.BROKER_CODE#|#DateFormat(Now(),'DDMMYYYY')#|#batchNo#|#getClientDetails.RECORDCOUNT##CHR(10)#" ADDNEWLINE="NO"> --->

<CFSET FINALSTRING = "">
<CFSET FINALSTRINGLOG = "">

<CFSET MissingBankDetails="Missing Bank Details For Clients :">
<CFSET MissingBankFLG=false>
<CFSET ERRORCODE = 0>
</cfoutput>

<!--- <CFIF COCD NEQ "CD_NSE">
	<CFSET SEGMENT = "C">
    <cfinclude template="GenerateUCITemplate.cfm">
	<CFSET SEGMENT = "F">
    <cfinclude template="GenerateUCITemplate.cfm">
<cfelse>
	<CFSET SEGMENT = "X">
    <cfinclude template="GenerateUCITemplate.cfm">	
</CFIF> --->
<cfoutput>
<CFSET TOTALCLIENTCOUNT = 0>
<CFLOOP QUERY="getClientDetails" > <!---  group="CLIENT_ID" groupcasesensitive="no" --->
	
	<CFIF COMPANY_CODE NEQ "CD_NSE">
		<CFIF market1 eq "CAPS">
			<CFSET SEGMENT = "C">
		<CFELSE>
			<CFSET SEGMENT = "F">
		</CFIF>
	<cfelse>
		<CFSET SEGMENT = "X">	
	</CFIF>

	<CFIF COMPANY_CODE EQ "NSE_SLBM">
		<CFSET SEGMENT = "S">	
	</CFIF>


	<CFSET ERRORCODE = 0>
	
			<!--- <CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
			Select TOP 1 DEPOSITORY+'|'+CASE WHEN DEPOSITORY = 'cdsl' then '' else DP_ID end +'|'+CLIENT_DP_CODE DpDetails
			FROM IO_DP_MASTER_HISTORY
			WHERE
				CLIENT_ID = '#getClientDetails.CLIENT_ID#'
			AND isnull(default_nbfc,'n') = 'n'	
			AND FULLUPDATE = 'Y'
			ORDER BY CHANGETIME
		</CFQUERY>
		<cfif COMPANY_CODE Neq 'NSE_CASH' OR GetclientDpDetails.RECORDCOUNT LTE 0>
			<CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
				SELECT  ''+'|'+''+'|'+'' DpDetails
			</CFQUERY>
		</cfif>
		
		<cfquery datasource="#Client.database#" name="GETBANKDETAILS">
			SELECT  TOP 1 REPLACE(ltrim(rtrim(left(ISNULL(Bank_Name,''),60)))+'|'+ltrim(rtrim(left(ISNULL(Bank_Address,''),255)))+'|'+ltrim(rtrim(left(ISNULL(Bank_AcNo,''),25))),',','') BankDetails 
			FROM  FA_CLIENT_BANK_DETAILS_HISTORY 
			Where
				Account_Code = '#getClientDetails.Client_id#'
			and isnull(Bank_AcNo,'') <> ''
			AND FULLUPDATE = 'Y'
			ORDER BY CHANGETIME DESC
			
		</cfquery>

		<CFIF GETBANKDETAILS.RECORDCOUNT LTE 0>
			<cfquery datasource="#Client.database#" name="GETBANKDETAILS">
				SELECT  TOP 1 ''+'|'+''+'|'+'' BankDetails 
			</cfquery>
		</CFIF> --->
	
	
	<cfif COMPANY_CODE eq 'NSE_CASH1'>
		<CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
			Select  DEPOSITORY+'|'+CASE WHEN DEPOSITORY = 'cdsl' then '' else DP_ID end +'|'+CLIENT_DP_CODE DpDetails
			FROM IO_DP_MASTER
			WHERE
				CLIENT_ID = '#getClientDetails.CLIENT_ID#'
			AND isnull(default_nbfc,'n') = 'n'	
			AND DEFAULT_ACC='Y'
		</CFQUERY>
	<cfelse>
		<CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
			SELECT  ''+'|'+''+'|'+'' DpDetails
		</CFQUERY>
	</cfif>
	
	<CFQUERY NAME="GETBANKDETAILS" datasource="#Client.database#">
		SELECT  REPLACE(ltrim(rtrim(left(ISNULL(Bank_Name,''),60)))+'|'+ltrim(rtrim(left(ISNULL(Bank_Address,''),255)))+'|'+ltrim(rtrim(left(ISNULL(Bank_AcNo,''),25))),',','') BankDetails 
		FROM  FA_CLIENT_BANK_DETAILS 
		Where
			Account_Code = '#getClientDetails.Client_id#'
		and isnull(Bank_AcNo,'') <> ''	
		AND DEFAULT_AC='YES'
	</CFQUERY>
	
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

				<CFSET SEX							=		"#TRIM(GetClientDetails.SEX)#">
				<CFSET FATHER_HUSBAND_NAME			=		"#TRIM(GetClientDetails.FATHER_HUSBAND_NAME)#">
				<CFSET MARITAL_STATUS				=		"#TRIM(GetClientDetails.MARITAL_STATUS)#">
				<CFSET NATIONALITY					=		"#TRIM(GetClientDetails.NATIONALITY)#">
				<CFSET NATIONALITY_OTHERS			=		"#TRIM(GetClientDetails.NATIONALITY_OTHERS)#">
				<CFSET STATE_OTH					=		"#TRIM(GetClientDetails.STATE_OTHERS)#">
				<CFSET R_STATE_OTH					=		"#TRIM(GetClientDetails.RegState_Others)#">
				
				<CFSET ISDCODE_off					=		"#TRIM(GetClientDetails.ISDCODE_off)#">
				<CFSET STD_CODE_off					=		"#TRIM(GetClientDetails.STD_CODE_off)#">
				<CFSET Off_TEL_NO1					=		"#TRIM(GetClientDetails.Off_TEL_NO)#">
				<CFSET UID							=		"#TRIM(GetClientDetails.UID)#">
				<CFSET GROSSAI						=		"#TRIM(GetClientDetails.ANNUAL_INCOME)#">
				<CFSET GROSSAID						=		"#Dateformat(GetClientDetails.GrossAnnualIncomeDate,"dd-mmm-yyyy")#">
				<CFSET NetWorth						=		"#TRIM(GetClientDetails.Net_Worth)#">
				<CFSET NETWORTHD					=	 	"#Dateformat(GetClientDetails.Net_Worth_Date,"dd-mmm-yyyy")#">
				<CFSET PEP							=		"#TRIM(GetClientDetails.Political_Affilication)#">
				<CFSET POI							=		"#TRIM(GetClientDetails.PlaceofIncorporation)#">
				<CFSET OCCUPATION					=		"#TRIM(GetClientDetails.OCCUPATION)#">
				<CFSET OCCUPATION_OTH				=		"#TRIM(GetClientDetails.OCCUPATION_OTHERS)#">
				<CFSET DATEOFFCOMM					=		"#Dateformat(GetClientDetails.Dateofcommencement,"dd-mmm-yyyy")#">
			<CFIF GetClientDetails.CLIENT_NATURE EQ 'I'>
				<CFSET UCC							=		"#TRIM(GetClientDetails.Unique_Cl_Id)#">
				<CFELSE>
				<CFSET UCC							=		"">
			</CFIF>


				<CFSET OTHERID1 					=		"#LEFT(TRIM(GetClientDetails.OTHER_DETAIL_ID),25)#">
				<CFSET OTHERNAME1					=		"#LEFT(TRIM(GetClientDetails.OTHER_DETAIL_NAME),25)#">
				<CFSET OTHERISSUEDATE1 				=		"#DATEFORMAT(GetClientDetails.OTHER_ISSUE_DATE,"DD-MMM-YYYY")#">
				<CFSET OTHERPLACE1 					=		"#GetClientDetails.OTHER_PLACE#">


						<!--- <CFIF TRIM(GetClientDetails.PAN_NAME) eq ''>
					<CFSET CLIENT_NAME				=		"#GetClientDetails.client_name#">
				</CFIF> --->
				<CFSET CUSTPC = "">
				<CFSET CATEGORY1					=		"">
				<CFIF GetClientDetails.CATEGORY EQ 'I'>
					<CFSET UCC						=		"">
					<CFSET CATEGORY1				=		"1">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'PF'>
					<CFSET CATEGORY1				=		"2">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'HUF'>
					<CFSET CATEGORY1				=		"3">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'CO'>
					<CFSET CATEGORY1				=		"4">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'TS'>
					<CFSET CATEGORY1				=		"5">	
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'NT'>
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
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'FVCF'>
					<CFSET CATEGORY1				=		"14">							
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'PMSI' OR GetClientDetails.CATEGORY EQ 'PMSN'>
					<CFSET CATEGORY1				=		"15">
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'NPS'>
					<CFSET CATEGORY1				=		"16">	
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'DR'>
					<CFSET CATEGORY1				=		"21">	
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'PVTLTD'>
					<CFSET CATEGORY1				=		"4">	
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'SP'>
					<CFSET CATEGORY1				=		"1">
				</CFIF>

				<CFIF GetClientDetails.OCCUPATION EQ ''>
					<CFSET OCCUPATION1				=		"">
				<CFelseIF GetClientDetails.OCCUPATION EQ 'PUBLIC SECTOR SERVICE'>
					<CFSET OCCUPATION1				=		"1">
				<CFELSEIF 	GetClientDetails.OCCUPATION EQ 'PRIVATE SECTOR SERVICE'>
					<CFSET OCCUPATION1				=		"2">
				<CFELSEIF 	GetClientDetails.OCCUPATION EQ 'Government  Service'>
					<CFSET OCCUPATION1				=		"3">
				<CFELSEIF 	GetClientDetails.OCCUPATION EQ 'BUSINESS'>
					<CFSET OCCUPATION1				=		"4">
				<CFELSEIF 	GetClientDetails.OCCUPATION EQ 'PROFESSIONAL'>
					<CFSET OCCUPATION1				=		"5">	
				<CFELSEIF 	GetClientDetails.OCCUPATION EQ 'Agriculturist'>
					<CFSET OCCUPATION1				=		"6">		
				<CFELSEIF 	GetClientDetails.OCCUPATION EQ 'Retired'>
					<CFSET OCCUPATION1				=		"7">
				<CFELSEIF 	GetClientDetails.OCCUPATION EQ 'HOUSEWIFE'>
					<CFSET OCCUPATION1				=		"8">
				<CFELSEIF 	GetClientDetails.OCCUPATION EQ 'Student'>
					<CFSET OCCUPATION1				=		"9">
				<CFELSE>
					<CFSET OCCUPATION1				=		"99">
				</CFIF>


				<CFIF CATEGORY1 EQ 1 OR CATEGORY1 EQ 11 OR CATEGORY1 EQ 18 OR CATEGORY1 EQ 2 OR CATEGORY1 EQ 3 OR CATEGORY1 EQ 5>
					<cfset CLIENTTYPE = 'N'>
				<CFELSE>
					<cfset CLIENTTYPE = 'Y'>
				</CFIF>				
				

				<CFSET Add1="#LEFT(GetToken(GetClientDetails.RESI_ADDRESS,1,'~'),255)#">
				<CFSET Add2="#MID(GetToken(GetClientDetails.RESI_ADDRESS,1,'~'),256,100)# #LEFT(GetToken(GetClientDetails.RESI_ADDRESS,2,'~'),155)#">
				<CFSET Add3="#MID(GetToken(GetClientDetails.RESI_ADDRESS,2,'~'),156,256)#">

				<CFSET RESI_ADDRESS1	 			= 	"#Add1##Add2##GetToken(Add3,1,'-')#">
				 <CFIF RESI_ADDRESS1 eq "">
					<CFSET RESI_ADDRESS1			= 	"#REPLACE(GetClientDetails.RESI_ADDRESS,'~',' ','ALL')#">
				</CFIF>

				<CFSET RAdd1="#LEFT(GetToken(GetClientDetails.R_RESI_ADDRESS,1,'~'),255)#">
				<CFSET RAdd2="#MID(GetToken(GetClientDetails.R_RESI_ADDRESS,1,'~'),256,100)# #LEFT(GetToken(GetClientDetails.R_RESI_ADDRESS,2,'~'),155)#">
				<CFSET RAdd3="#MID(GetToken(GetClientDetails.R_RESI_ADDRESS,2,'~'),156,256)#">

				<CFSET RESI_ADDRESS2	 			= 	"#RAdd1##RAdd2##GetToken(RAdd3,1,'-')#">
				 <CFIF RESI_ADDRESS2 eq "">
					<CFSET RESI_ADDRESS2			= 	"#REPLACE(GetClientDetails.R_RESI_ADDRESS,'~',' ','ALL')#">
				</CFIF>

				  
				<CFSET PINCODE		 				= 	"#GetClientDetails.Pin_Code#">	
				<CFSET RPINCODE		 				= 	"#GetClientDetails.R_Pin_Code#">	
				<CFSET RESI_TEL_NO1	 				= 	"#TRIM(LEFT(GetClientDetails.RESI_TEL_NO,25))#">
				
					
				<CFSET BIRTHDATE	 				= 	"#DateFormat(GetClientDetails.BIRTH_DATE1,'DD-MMM-YYYY')#">
				<CFSET DateOfIncorporation	 				= 	"#DateFormat(GetClientDetails.Date_Of_Incorporation,'DD-MMM-YYYY')#">
			
				<CFIF LEN(GetClientDetails.AGREEMENT_DATE) GT 0>					
					<CFSET AGREEMENT_DATE1			 	= 	"#DATEFORMAT(GetClientDetails.AGREEMENT_DATE,"DD-MMM-YYYY")#">	
				<CFELSE>					
					<CFSET AGREEMENT_DATE1			 	= 	"#DATEFORMAT(GetClientDetails.REGISTRATION_DATE,"DD-MMM-YYYY")#">		
				</CFIF>
				
				<CFSET INTRODUCER_NAME = "#Trim(GetClientDetails.INTRODUCER_NAME)#">
				<CFSET RELWITHINT		= "">
				<CFSET INTRODUCER_ACC_CODE = "">
				
				 <!--- New Field added Here  --->
				 <cfset EMAILID = #gettoken(Trim(GetClientDetails.CLIENT_ID_MAIL),1,';')# >

				 <cfif EMAILID eq "">
					<CFSET EMAILID = "#LEFT(Trim(GetClientDetails.CLIENT_ID_MAIL),60)#"> 	
				 </cfif>

				<CFSET  CITY = "#Trim(GetClientDetails.R_CITY)#">

				<CFSET  RCITY = "#Trim(GetClientDetails.CITY1)#">
				
				<CFSET  ISDCODE = "#Trim(GetClientDetails.ISD_CODE)#">
				<CFSET  UpdationFlag1 = "#Trim(GetClientDetails.UpdationFlag)#">
				<CFSET  RelationShip1 = "#Trim(GetClientDetails.RelationShip)#">
				<CFSET  MasterPan1 = "#Trim(GetClientDetails.MasterPan)#">
				<CFSET  TypeOfFacility1 = "#Trim(GetClientDetails.TypeOfFacility)#">
				
				<CFQUERY name="GetStateCode" datasource="#client.database#">
					select * from state_master
					where STATE_code = '#Trim(GetClientDetails.R_STATE)#'
				</CFQUERY>

				<CFQUERY name="GetStateCode1" datasource="#client.database#">
					select * from state_master
					where STATE_code = '#Trim(GetClientDetails.STATE1)#'
				</CFQUERY>

				<CFIF GetStateCode1.STATE_code EQ 'OTHER'>
					<CFSET  RSTATE = "99">
				<CFELSE>	
					<CFSET  RSTATE = "#Trim(GetStateCode1.NSE_STATE_CODE)#">
				</CFIF>

				<CFIF GetStateCode.STATE_code EQ 'OTHER'>
					<CFSET  STATE = "99">
				<CFELSE>	
					<CFSET  STATE = "#Trim(GetStateCode.NSE_STATE_CODE)#">
				</CFIF>

				<CFQUERY name="GetCountryCode" datasource="#client.database#">
					select * from country_master
					where COUNTRY_NAME = '#Trim(GetClientDetails.R_COUNTRY)#'
				</CFQUERY>

				<CFQUERY name="GetCountryCode1" datasource="#client.database#">
					select * from country_master
					where COUNTRY_NAME = '#Trim(GetClientDetails.COUNTRY1)#'
				</CFQUERY>



				<CFSET  COUNTRY = "#Trim(GetCountryCode.CODE)#">
				<CFSET  RCOUNTRY = "#Trim(GetCountryCode1.CODE)#">

				<CFIF CATEGORY1 EQ "4">
					<CFSET  CIN1 = "#Trim(GetClientDetails.CIN)#">
				<CFELSE>
					<CFSET  CIN1 = "">
				</CFIF>
				
				<cfset banksdetails ="#GETBANKDETAILS.BankDetails#">
				<cfset dpsdetails ="#GetclientDpDetails.DpDetails#">

				<cfset a =   ValueList(GETBANKDETAILS.BankDetails,',')>
		
				<cfif #GetToken(a,1,',')# neq "">
					<cfset b = #GetToken(a,1,',')#>
				<cfelse>
					<cfset b = "|||">
				</cfif>
		
				<cfif #GetToken(a,2,',')# neq "">
					<cfset c = #GetToken(a,2,',')#>
				<cfelse>
					<cfset C = "|||">
				</cfif>
		
				<cfif #GetToken(a,3,',')# neq "">
					<cfset D = #GetToken(a,3,',')#>
				<cfelse>
					<cfset D = "|||">
				</cfif>
				
				<cfset E =   ValueList(GetclientDpDetails.DpDetails,',')>
		
				<cfif #GetToken(E,1,',')# neq "">
					<cfset F = #GetToken(E,1,',')#>
				<cfelse>
					<cfset F = "||">
				</cfif>
		
				<cfif #GetToken(E,2,',')# neq "">

					<cfset G = #GetToken(E,2,',')#>
				<cfelse>
					<cfset G = "||">
				</cfif>
		
				<cfif #GetToken(E,3,',')# neq "">
					<cfset H = #GetToken(E,3,',')#>
				<cfelse>
					<cfset H = "||">
				</cfif>

				<CFSET OTHERACCOUNT				=	"">
				<CFSET SETTLEMENTMODE			=	"">
				<CFSET CLIENTOTH				=	"">
				<CFSET FLAG						=	"E">
				<CFSET FINALSTRING = "">
				<CFIF LEN(MAPIN) NEQ 9 >
					<CFSET MAPIN="">
				</CFIF>
			
			<cfif RAdd1 eq Add1>
				<CFSET FlgIndSameAdd = 'Y'>
			<cfelse>
				<CFSET FlgIndSameAdd = 'N'>
			</cfif>
				
				<cfif CATEGORY1 eq '1' OR CATEGORY1 eq '11' OR CATEGORY1 eq '18'>
					<CFSET NATIONALITY1 = NATIONALITY>
					<CFSET SEX1 = SEX>
					<cfset MARITAL_STATUS1 = MARITAL_STATUS>
				<CFELSe>
					<CFSET NATIONALITY1 = ''>
					<CFSET SEX1 = ''>
					<cfset MARITAL_STATUS1 = ''>
				</cfif> 

				<cfoutput>
					<CFSET FINALSTRING = "#FINALSTRING##SEGMENT#|#CLIENTID#|#SEX1#|#FATHER_HUSBAND_NAME#|#MARITAL_STATUS1#|#NATIONALITY1#|#Nationality_Others#|#EMAILID#|">
					<CFSET FINALSTRING = "#FINALSTRING##RADD1#|#RCITY#|#RSTATE#|#R_STATE_OTH#|#RCOUNTRY#|#RPINCODE#|#FlgIndSameAdd#|">

					<cfif RESI_TEL_NO1 neq "">
						<cfif STD_CODE eq "">
							<CFSET ERRORCODE = 33>
						</cfif>
					</cfif>

					<cfif FlgIndSameAdd eq 'y'>
						<CFSET FINALSTRING = "#FINALSTRING#||||||#STD_CODE#|#RESI_TEL_NO1#|#MOBILE_NO#|">
					<cfelse>
						<CFSET FINALSTRING = "#FINALSTRING##ADD1#|#CITY#|#STATE#|#STATE_OTH#|#COUNTRY#|#PINCODE#|#STD_CODE#|#RESI_TEL_NO1#|#MOBILE_NO#|">
					</cfif>
					
					<CFIF RESI_TEL_NO1 EQ "" AND (MOBILE_NO EQ "" OR LEN(MOBILE_NO) LTE 9 OR LEN(MOBILE_NO) GTE 11)>
						<CFSET ERRORCODE  = 1>
					</CFIF>
					<CFIF  len(GetClientDetails.PAN_NO) neq 10>
						<CFSET ERRORCODE  = 2>
					</CFIF>
					
					<cfif COUNTRY eq "">
						<CFSET ERRORCODE  = 16>
					</cfif>
					
					<cfif ADD1 eq Add2 and Add2 eq Add3 and Add3 eq Add1>
						<CFSET ERRORCODE  = 4>
					</cfif>
					
					<cfif CLIENT_NAME1 eq Contact_Person1 and Contact_Person2 eq Contact_Person1 and Contact_Person2 eq Contact_Person3 and Contact_Person3 eq Contact_Person1 and Contact_Person3 eq client_name>
						<CFSET ERRORCODE  = 5>
					</cfif>

					<cfif GROSSAI eq "Less Than One Lakhs">
						<cfset Income = "1">
					<cfelseif GROSSAI eq "One To Five Lakhs">
						<cfset Income = "2">
					<cfelseif GROSSAI eq "Five To Ten Lakhs">
						<cfset Income = "3">
					<cfelseif GROSSAI eq "Ten To TwentyFive Lakhs">
						<cfset Income = "4">
					<cfelseif GROSSAI eq "TwentyFive Lakhs To One Crore">
						<cfset Income = "5">
					<cfelseif GROSSAI eq "Above TwentyFive Lakhs">
						<cfset Income = "5">
					<cfelse>
						<cfset Income = "6">
					</cfif>
					
					 <cfif CATEGORY1 eq '1' or CATEGORY1 eq '11' OR CATEGORY1 eq '18'>
						<CFSET Date1 = "#BIRTHDATE#">
					<cfelse>
						<CFSET Date1 = "#DateOfIncorporation#">	
					</cfif> 
					<CFSET FINALSTRING = "#FINALSTRING##STD_CODE_off#|#Off_TEL_NO1#|#Date1#|">

					<cfif CATEGORY1 EQ '12'>
						<cfset b = "|||">
						<cfset C = "|||">
						<cfset D = "|||">
					</cfif>

					<CFSET FINALSTRING = "#FINALSTRING##banksdetails#|">
					<CFSET FINALSTRING = "#FINALSTRING##dpsdetails#|">

					<cfif CATEGORY1 NEQ  "9" AND CATEGORY1 NEQ "12">
						<cfif Income neq "">
							<cfif GROSSAID eq "">
								<CFSET ERRORCODE  = 31>
							</cfif>
						</cfif>
					</cfif>
					
					<cfif PEP eq '03' or PEP eq '04'>
						<cfset  PEP1 = '0'>
					<cfelse>
						<cfset  PEP1 = PEP>
					</cfif>
					
					

					<CFSET FINALSTRING = "#FINALSTRING##CIN#|#Income#|#GROSSAID#|#NETWORTH#|#NETWORTHD#|#PEP1#|#OCCUPATION1#|#OCCUPATION_OTH#|#CUSTPC#">

					<!--- <cfif CATEGORY1 eq 1 or CATEGORY1 eq 11>
						<CFSET FINALSTRING = "#FINALSTRING#|#BIRTHDATE#|#AGREEMENT_DATE1#">
					<cfelse>
						<CFSET FINALSTRING = "#FINALSTRING#|#Date_of_INCORPORATION#|#AGREEMENT_DATE1#">	
					</cfif> --->
					
					<!--- <CFIF (CATEGORY1 NEQ '1' OR CATEGORY1 NEQ '11')  AND REGISTRATION_NO NEQ "" AND REGISTRATION_AUTHORITY NEQ "" AND REGISTRATION_PLACE NEQ "" AND REGISTRATION_DATE1 NEQ "">
						<CFSET FINALSTRING	   = "#FINALSTRING#|#REGISTRATION_NO#|#REGISTRATION_AUTHORITY#|#REGISTRATION_PLACE#|#REGISTRATION_DATE1#|">
					<CFELSE>
						<CFSET FINALSTRING	   = "#FINALSTRING#|||||">
					</CFIF> --->

					<cfif CATEGORY1 eq 'I'>
						<CFIF RelationShip1 EQ 1 OR RelationShip1 EQ 2 OR RelationShip1 EQ 3>
							<CFSET ERRORCODE  = 32>
						</CFIF>
					</cfif>
					<!--- #RelationShip1# --->
					<CFSET CORRADDRESSPROFF = "#GetClientDetails.Correspondance_Address_Proof#">
					<cfif PAN_NO1 neq 'PAN_EXEMPT'>
						<cfset CORRADDRESSPROFF = ''>
					</cfif>

				 <CFIF CORRADDRESSPROFF EQ 01>
					<CFSET FINALSTRING1 = "2|#PASSPORT_NO1#|#LEFT(REPLACE(PASSPORT_ISSUED_PLACE1,',','','ALL'),25)#|#Pass_Issue_Date#">
				<CFELSEIF CORRADDRESSPROFF EQ 02>
					<CFSET FINALSTRING1 = "3|#VOTERS_ID_CARD1#|#LEFT(REPLACE(Place_Issue_Vouter_ID1,',',' ','ALL'),25)#|#VOTERS_ID_CARD_ISSUED_DATE#">
				<CFELSEIF CORRADDRESSPROFF EQ 03>
					<CFSET FINALSTRING1 = "4|#DRIVING_LICENSE1#|#DRIVING_LICENSE_ISSUED_DATE#|#LEFT(REPLACE(DRIVING_LICENSE_ISSUED_PLACE1,',',' ','ALL'),25)#">
				<CFELSEIF CORRADDRESSPROFF EQ 04>
					<CFSET FINALSTRING1 = "5|#RATIONCARD1#|#RATIONCARD_EXPIRY_DATE#|#LEFT(REPLACE(RATIONCARD_ISSUED_PLACE1,',',' ','ALL'),25)#">
				<CFELSEIF CORRADDRESSPROFF EQ 05>
					<CFSET FINALSTRING1 = "6|#OTHERID1#|#LEFT(REPLACE(OTHERPLACE1,',',' ','ALL'),25)#|#OTHERISSUEDATE1#">
				<CFELSEIF CORRADDRESSPROFF EQ 06>
					<CFSET FINALSTRING1 = "7|#OTHERID1#|#LEFT(REPLACE(OTHERPLACE1,',',' ','ALL'),25)#|#OTHERISSUEDATE1#">
				<cfelse>
					<CFSET FINALSTRING1 = "|||">
				</CFIF> 

					<CFSET FINALSTRING = "#FINALSTRING#|#UpdationFlag1#|#RelationShip1#|#TypeOfFacility1#|#CLIENTTYPE#">

					
					
								
					<CFIF CATEGORY1 EQ 2 OR CATEGORY1 EQ 3 OR CATEGORY1 EQ 4 OR CATEGORY1 EQ 5>
						<CFIF CATEGORY1 EQ 3>
							
							<CFIF CATEGORY1 EQ 2>
								<CFSET DESIGNATIONPERSON1 = "PARTNER">
							<cfelseIF CATEGORY1 EQ 3>
								<CFSET DESIGNATIONPERSON1 = "KARTA">
							<cfelseIF CATEGORY1 EQ 5>
								<CFSET DESIGNATIONPERSON1 = "TRUSTEE">	
							<cfelse>
								<CFSET DESIGNATIONPERSON1 = "#Designation_Person1#">		
							</CFIF>
							<!--- #Contact_Person1#-#DESIGNATIONPERSON1#-#PanNo_Person1#-#Address_Person1#-#TelNo_Person1#-#EmailId_Person1#<BR> --->
							<CFIF Contact_Person1 NEQ "" AND DESIGNATIONPERSON1 NEQ "" AND PanNo_Person1 NEQ "" AND Address_Person1 NEQ "" AND TelNo_Person1 NEQ "" >					
								<CFSET FINALSTRING = "#FINALSTRING#|#Contact_Person1#|#DESIGNATIONPERSON1#|#PanNo_Person1#|#Address_Person1#|#TelNo_Person1#|#DIN_PERSON1#|#UID_PERSON1#|#EmailId_Person1#">
							<cfelse>
								<CFSET FINALSTRING = "#FINALSTRING#||||||||">	
								<CFSET ERRORCODE  = 10>
							</CFIF>
						<cfelse>
							
							<CFIF CATEGORY1 EQ 2>
								<CFSET DESIGNATIONPERSON1 = "PARTNER">
							<cfelseIF CATEGORY1 EQ 3>
								<CFSET DESIGNATIONPERSON1 = "KARTA">
							<cfelseIF CATEGORY1 EQ 5>
								<CFSET DESIGNATIONPERSON1 = "TRUSTEE">	
							<cfelse>
								<CFSET DESIGNATIONPERSON1 = "#Designation_Person1#">		
							</CFIF>
							
							<CFIF Contact_Person1 NEQ "" AND DESIGNATIONPERSON1  NEQ "" AND PanNo_Person1 NEQ "" AND Address_Person1 NEQ "" AND TelNo_Person1 NEQ "" >					
								<CFSET FINALSTRING = "#FINALSTRING#|#Contact_Person1#|#DESIGNATIONPERSON1#|#PanNo_Person1#|#Address_Person1#|#TelNo_Person1#|#DIN_PERSON1#|#UID_PERSON1#|#EmailId_Person1#">
							<cfelse>
								<CFSET FINALSTRING = "#FINALSTRING#||||||||">
							</CFIF>	
						</CFIF>
						
						<CFIF CATEGORY1 EQ 2 OR CATEGORY1 EQ 3 OR CATEGORY1 EQ 4 OR CATEGORY1 EQ 5>
							
							<CFIF CATEGORY1 EQ 2>
								<CFSET DESIGNATIONPERSON2 = "PARTNER">
							<cfelseIF CATEGORY1 EQ 3>
								<CFSET DESIGNATIONPERSON2 = "COPARCENER">
							<cfelseIF CATEGORY1 EQ 5>
								<CFSET DESIGNATIONPERSON2 = "TRUSTEE">	
							<cfelse>
								<CFSET DESIGNATIONPERSON2 = "#Designation_Person2#">		
							</CFIF>
							
							<CFIF Contact_Person2 NEQ "" AND DESIGNATIONPERSON2 NEQ "" AND PanNo_Person2 NEQ "" AND Address_Person2 NEQ "" AND TelNo_Person2 NEQ "" >					
								<CFSET FINALSTRING = "#FINALSTRING#|#Contact_Person2#|#DESIGNATIONPERSON2#|#PanNo_Person2#|#Address_Person2#|#TelNo_Person2#|#DIN_PERSON2#|#UID_PERSON2#|#EmailId_Person2#">
							<cfelse>
								<CFSET FINALSTRING = "#FINALSTRING#||||||||">
							</CFIF>	
						<cfelse>					
							<CFSET FINALSTRING = "#FINALSTRING#||||||||">	
						</CFIF>
					<cfELSE>
						<CFSET FINALSTRING = "#FINALSTRING#||||||||||||||||">
					</CFIF>
					
					<CFIF CATEGORY1 EQ 2 OR CATEGORY1 EQ 4 OR CATEGORY1 EQ 5>
						<CFIF (Contact_Person1 EQ "" AND DESIGNATIONPERSON1 EQ "" AND PanNo_Person1 EQ "" AND Address_Person1 EQ "" AND TelNo_Person1 EQ "" )
						AND (Contact_Person2 EQ "" AND DESIGNATIONPERSON2 EQ "" AND PanNo_Person2 EQ "" AND Address_Person2 EQ "" AND TelNo_Person2 EQ "" )
						>
							<CFSET ERRORCODE  = 3>
						</CFIF>
					</CFIF>
					<!---<CFSET FINALSTRING = "#FINALSTRING#|#trim(Person_verify)#|">--->

					<!--- <cfif UpdationFlag1 eq "Y">
						<cfif TypeOfFacility eq "">
							<CFSET ERRORCODE = 11>
						<cfelseif TypeOfFacility eq "1" and EMAILID eq "">
							<CFSET ERRORCODE = 12>
						<cfelseif TypeOfFacility eq "2" and MOBILE_NO eq "">
							<CFSET ERRORCODE = 13>
						<cfelseif TypeOfFacility eq "3" and EMAILID eq "" and MOBILE_NO eq "">
							<CFSET ERRORCODE = 14>
						</cfif>
						<cfif RelationShip neq "" and MasterPan eq "">
							<CFSET ERRORCODE = 15>
						</cfif>
					</cfif> --->
					<!--- <CFIF ERRORCODE LTE 10>
						<CFSET FINALSTRING = "#FINALSTRING##UpdationFlag1#|#RelationShip1#|#MasterPan1#|#TypeOfFacility1#">
					<cfelse>
						<CFSET FINALSTRING = "#FINALSTRING#|||">
					</CFIF> --->

					<CFSET FINALSTRING = "#FINALSTRING#|E">
					<CFSET FINALSTRING = "#FINALSTRING##CHR(10)#">
				</cfoutput>
				
				<!--- <CFIF ERRORCODE EQ 1>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Tele Phone / Mobile NO. is Missing/ Length is Not Proper.#chr(10)#">
				<cfelseif ERRORCODE EQ 2>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Insert Proper Pan NO.#chr(10)#">
				<cfelseif ERRORCODE EQ 3>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Insert Any of the Contact Person Details.#chr(10)#">	
				<cfelseif ERRORCODE EQ 4>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Add1 , Add2 , Add3 Can not be Same#chr(10)#">	
				<cfelseif ERRORCODE EQ 5>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Client Name ,Contact_Person1 , Contact_Person2 , Contact_Person3 Can not be Same#chr(10)#">			
				<cfelseif ERRORCODE EQ 6>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Bank Address Should be More then or Equal 3 Words.#chr(10)#">				
				<cfelseif ERRORCODE EQ 10>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Insert First Contact Person Data.#chr(10)#">	
				<cfelseif ERRORCODE EQ 11>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Define Type of Facility in Master > Client Master > Personal Details > Sms & Email Facility Option#chr(10)#">	
				<cfelseif ERRORCODE EQ 12>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Define Email#chr(10)#">	
				<cfelseif ERRORCODE EQ 13>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Define Mobile No#chr(10)#">	
				<cfelseif ERRORCODE EQ 14>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Either Email or Mobile No. is not Defined#chr(10)#">	
				<cfelseif ERRORCODE EQ 15>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Define Master Pan in Master > Client Master > Personal Details > Sms & Email Facility Option#chr(10)#">	
				<cfelseif ERRORCODE EQ 16>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Country is Not Defined#chr(10)#">		
				<cfelseif  ERRORCODE  eq 31	>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : GROSS Annual Income Date is Not Defined#chr(10)#">		
				<cfelseif  ERRORCODE  eq 32	>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Relationship should not be Spouse/Dependent Parent/Dependent Child#chr(10)#">		
				<cfelseif  ERRORCODE  eq 33	>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Std Code is not defined#chr(10)#">		
				<cfelse> --->
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Generated SucessFully.#chr(10)#">		
				<!--- </CFIF> --->

				<cfset ERRORCODE = 0>
				
				<cfif len(FINALSTRINGLOG) gt 0>
					<CFFILE ACTION="APPEND" FILE="#FILENAMELOG#" OUTPUT="#FINALSTRINGLOG#" ADDNEWLINE="Yes">
				</cfif>
				
				<cfif ERRORCODE EQ 0 and len(FINALSTRING) gt 0>
					<CFSET TOTALCLIENTCOUNT = TOTALCLIENTCOUNT  + 1>
					<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING#" ADDNEWLINE="No">		
				</cfif>
				
				<CFSET FINALSTRING = "">
				<CFSET FINALSTRINGLOG = "">	
</CFLOOP>





<CFFILE ACTION="READ" FILE="#FileName#" VARIABLE="FileData">

<CFIF FileExists('#FILENAME#')>
	<CFFILE  ACTION="DELETE" FILE="#FILENAME#"> 
</CFIF>

<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">
<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="10|M|#GETTRADINGCODE.BROKER_CODE#|#DateFormat(Now(),'DDMMYYYY')#|#batchNo#|#TOTALCLIENTCOUNT##CHR(10)#" ADDNEWLINE="NO">
<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FileData#" ADDNEWLINE="No">		

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
