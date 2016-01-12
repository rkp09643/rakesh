<cfparam default="" name="market1">
<HTML>
<HEAD>
<TITLE>UCC FOR WEBEX</TITLE>
	<link href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="../../CSS/Bill.css" type="text/css" rel="stylesheet">
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=iso-8859-1">
</HEAD>
<STYLE>
	DIV#FOOTER
	{
		Position: Absolute;
		Left: 0;
		Top: 56%;
		Bottom: 0;
		Height: 8%;
		Width: 100%;		
	}
</STYLE>
<BODY CLASS="StyleBody1">
<CFOUTPUT>	

		<CFQUERY  NAME="GetBrokerWebxId" datasource="#Client.database#">
			Select Webx_ID
			From Company_Master
			Where
				Company_code = '#COCD#'
		</CFQUERY>
		
		<CFSET BrkWebXId = "#GetBrokerWebxId.Webx_ID#">
		<cfset BranchWebXid = "0">
		<cfset SubBrkWebXId = "0">
		
		<CFIF Market eq "CAPS">
			<CFSET SEGMENT = "CASH">
		<CFELSE>
			<CFSET SEGMENT = "DERV">
		</CFIF>		
		
		<!--- <CFSET CATAGORY = "I"> --->
		
		<CFIF not directoryexists("C:\WEBXUCC\")>
			<CFDIRECTORY ACTION="CREATE" DIRECTORY="C:\WEBXUCC\">
		</CFIF>
		
		<CFSET Filename 	= "C:\WEBXUCC\#EXCHANGE#_UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt">
		<CFSET Filename 	= "C:\WEBXUCC\#EXCHANGE#_UCC_#DateFormat(Now(),"DDMMYYYY")#.txt">
		<!--- <CFSET FilenameLog 	= "C:\WEBXUCC\Log_#EXCHANGE#_UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt"> --->
		<CFSET FilenameLog 	= "C:\COMMUCC\Log_#Client.userName#_#DateFormat(Now(),"YYYYMMDD")#.txt">
		
		<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">
		
		<CFSET FINALSTRING = "">
		<CFSET FINALSTRINGLOG  = "">
		<CFSET UpdateRow	= 0>
		<cFIF market1 EQ 'All'>
			<cFSET I=0>
			<CFLOOP INDEX="K1" list="#chkval1#" delimiters=",">
					<cFSET I=I+1>	
					<cFSET "chk#i#" =K1>
			</CFLOOP>	
			<cFSET Sr = I>
		</cFIF>
		<!--- <CFLOOP QUERY="GetClientId">	 --->	
		<CFLOOP INDEX="i" FROM="1" TO="#Sr#">	
		<CFIF IsDefined("chk#i#")>
			<CFSET	Client_ID	=	Trim(Evaluate("chk#i#"))><!--- " VALUE="#Client_id#" CLASS="StyleCheckBox"> --->
			<CFSET UpdateRow	=	IncrementValue(UpdateRow)>
			
			<CFQUERY NAME="GetClientDetails" datasource="#Client.database#">
				SELECT ISNULL(Father_Husband_Name,'') Father_Husband_Name ,REPLACE(REPLACE(ISNULL(REG_ADDR,''),'/',''),'\','') RESI_ADDRESS,
				REPLACE(REPLACE(ISNULL(RESI_ADDRESS,''),'/',''),'\','')REG_ADDR,
				ISNULL(R_City,'') CITY,ISNULL(R_State,'') STATE,ISNULL(R_Country,'') Country,R_Pin_Code Pin_Code,
				RESI_TEL_NO,RESI_FAX_NO,
				ISNULL(OFF_ADDRESS,'')OFF_ADDRESS ,OFF_TEL_NO,OFF_FAX_NO,
				ISNULL(EMAIL_ID,'') EMAIL_ID, Convert(Varchar(10),BIRTH_DATE,103) BIRTH_DATE,
				ISNULL(QUALIFICATION,'')QUALIFICATION,ISNULL(OCCUPATION,'')OCCUPATION,ISNULL(INTRODUCER_NAME,'')INTRODUCER_NAME,
				ISNULL(Rel_With_Introducer,'')Rel_With_Introducer,ISNULL(INTRODUCER_ACC_CODE,'')INTRODUCER_ACC_CODE,
				ISNULL(MAPIN,'') MAPIN,ISNULL(PAN_NO,'') PAN_NO,
				ISNULL(PASSPORT_NO,'')PASSPORT_NO,Convert(Varchar(10),PASSPORT_EXPIRY_DATE,103) PASSPORT_EXPIRY_DATE,
				ISNULL(PASSPORT_ISSUED_PLACE,'')PASSPORT_ISSUED_PLACE,Convert(Varchar(10),Pass_Issue_Date,103) Pass_Issue_Date,
				ISNULL(DRIVING_LICENSE,'')DRIVING_LICENSE,ISNULL(DRIVING_LICENSE_ISSUED_PLACE,'')DRIVING_LICENSE_ISSUED_PLACE,
				Convert(Varchar(10),DRIVING_LICENSE_ISSUED_DATE,103) DRIVING_LICENSE_ISSUED_DATE,Convert(Varchar(10),Dr_Lic_Exp_Date,103) Dr_Lic_Exp_Date,
				ISNULL(VOTERS_ID_CARD,'')VOTERS_ID_CARD,ISNULL(Place_Issue_Vouter_ID,'')Place_Issue_Vouter_ID,
				Convert(Varchar(10),VOTERS_ID_CARD_ISSUED_DATE,103) VOTERS_ID_CARD_ISSUED_DATE,MOBILE_NO,
				ISNULL(RATIONCARD,'')RATIONCARD,ISNULL(RATIONCARD_ISSUED_PLACE,'')RATIONCARD_ISSUED_PLACE,Convert(Varchar(10),RATIONCARD_EXPIRY_DATE,103) RATIONCARD_EXPIRY_DATE,
				ISNULL(STD_Code,'0') STD_Code,Registration_Number,Registration_Authority,Place_Of_Reg,Convert(Varchar(10),Date_of_Reg,103)  Date_of_Reg,
				ISNULL(category,'I')category,
				Case when isnull(TypeOfFacility,4) =  1  then 2
				WHEN isnull(TypeOfFacility,4) = '2'THEN 1 
				WHEN isnull(TypeOfFacility,4) = '3'THEN 3
				ELSE 4
				END TypeOfFacility,LEFT(CIN,21) CIN, SEX,FATHER_HUSBAND_NAME,MARITAL_STATUS ,NATIONALITY,NATIONALITY_OTHERS
				,STATE_OTHERS ,ISDCODE_off,STD_CODE_off,Off_TEL_NO ,UID,ANNUAL_INCOME ,GrossAnnualIncomeDate,NO_OF_PARTNERS,
				PORTFOLIO_MKT_VALUE Net_Worth ,Net_Worth_Date ,Political_Affilication , PlaceofIncorporation ,OCCUPATION ,OCCUPATION_OTHERS 
				,Dateofcommencement ,DIN_PERSON1,UID_PERSON1,DIN_PERSON2,UID_PERSON2,DIN_PERSON3,UID_PERSON3 
				,Contact_Person1,Designation_Person1,PanNo_Person1,Address_Person1,TelNo_Person1,EmailId_Person1
				,Contact_Person2,Designation_Person2,PanNo_Person2,Address_Person2,TelNo_Person2,EmailId_Person2
				,Contact_Person3,Designation_Person3,PanNo_Person3,Address_Person3,TelNo_Person3,EmailId_Person3
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
				,Case when ISNULL(b.ACTIVE_INACTIVE,'A') =  'A'  then 'Y'
				ELSE 'N'
				END ACTIVE_INACTIVE
				FROM CLIENT_DETAIL_VIEW a, brokerage_apply b
				Where
					a.Company_code = b.company_code
					and a.client_id = b.client_id
					and a.Company_code = '#COCD#'
					AND ISNULL(END_DATE ,'') = ''
					And	a.Client_id	=	'#Client_ID#'
					--AND ISNULL(ACTIVE_INACTIVE,'A')='I'
			</CFQUERY>			
			
			<cfquery name="GetDataMaster" datasource="#Client.database#">
				Select Client_Nature,First_Name,Middle_Name,Last_Name,CONVERT(VARCHAR(10),Registration_Date,103) Registration_Date,Client_Name,CONVERT(VARCHAR(10),Agreement_Date ,103) Agreement_Date,
						ISNULL(PAN_NAME,CLIENT_NAME) PAN_NAME
				from Client_Master
				Where
					Company_code = '#cocd#'
				And	Client_id	=	'#Client_ID#'	
			</cfquery>
			
			<cfset Client_Nature = '#GetDataMaster.Client_Nature#'>
			<cfset First_Name = '#GetDataMaster.First_Name#'>
			<cfset Middle_Name = '#GetDataMaster.Middle_Name#'>
			<cfset Last_Name = '#GetDataMaster.Last_Name#'>
			<cfif Trim(GetDataMaster.Agreement_Date) neq "">
				<cfset Reg_Date = '#GetDataMaster.Agreement_Date#'>
			<cfelse>
				<cfset Reg_Date = '#GetDataMaster.Registration_Date#'>	
			</cfif>			
			<cfset Client_Name1	 = '#GetDataMaster.PAN_NAME#'>	
			
			<CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
				Select 	DEPOSITORY,Replace(DP_NAME,'&',' ')DP_NAME,
						CASE WHEN DEPOSITORY = 'NSDL' THEN DP_ID+''+CLIENT_DP_CODE ELSE CLIENT_DP_CODE END CLIENT_DP_CODE
				FROM IO_DP_MASTER
				WHERE
					CLIENT_ID = '#CLIENT_ID#'
				AND DEFAULT_ACC = 'Y'
				AND isnull(default_nbfc,'n') = 'n'
			</CFQUERY>
			
			<CFQUERY NAME="GETBANKDETAILS" datasource="#Client.database#">
				SELECT Bank_Name,Bank_Address,Micr_Code,Bank_AcNo,ACC_OPEN_DATE,
					   BANK_ACCTYPE
				FROM  FA_CLIENT_BANK_DETAILS 
				Where
					Account_Code = '#Client_id#'
				and isnull(Bank_AcNo,'') <> ''
				And Default_Ac = 'Yes'	
			</CFQUERY>
			
			<cfIF  TRIM(First_Name) EQ "">
				<CFSET First_Name = "#GETTOKEN(Client_Name1,1,' ')#">
			</cfIF>
			<cfIF TRIM(Middle_Name) EQ "">
				<CFSET MIDDLE_NAME = "#GETTOKEN(Client_Name1,2,' ')#">
				<cfIF TRIM(GETTOKEN(Client_Name1,3,' ')) EQ "">
					<CFSET LAST_NAME  = "#GETTOKEN(Client_Name1,2,' ')#">
					<CFSET MIDDLE_NAME = "">
				</cfIF>	
			</cfIF>
			<cfIF TRIM(Last_Name) EQ "">
				<CFSET LAST_NAME  = "#GETTOKEN(Client_Name1,3,' ')#">
				<cfIF TRIM(GETTOKEN(Client_Name1,3,' ')) EQ "">
					<CFSET LAST_NAME  = "#GETTOKEN(Client_Name1,1,' ')#">
				</cfIF>
			</cfIF>
			
			<cfset CIN1 = "#GetClientDetails.CIN#">
			<cfset TypeOfFacility = "#GetClientDetails.TypeOfFacility#">
			<CFSET FATHERHUSNAME = "#GetClientDetails.Father_Husband_Name#">
			<CFSET RESI_ADD1 	 = "#GETTOKEN(GetClientDetails.RESI_ADDRESS,1,'~')#">	
			<CFSET RESI_ADD2 	 = "#GETTOKEN(GetClientDetails.RESI_ADDRESS,2,'~')#">				
			<CFSET REG_ADDR1 	 = "#GETTOKEN(GetClientDetails.REG_ADDR,1,'~')#">	
			<CFSET REG_ADDR2 	 = "#GETTOKEN(GetClientDetails.REG_ADDR,2,'~')#">				


			<CFSET CITY			 = "#GetClientDetails.City#">
			<CFSET category		 = "#GetClientDetails.category#">		
			<CFSET State		 = "#GetClientDetails.State#">		
			<CFSET Country		 = "#GetClientDetails.Country#">
			<CFSET PINCODE		 = "#GetClientDetails.Pin_Code#">	
			<CFSET RESI_TEL_NO	 = "#TRIM(LEFT(GetClientDetails.RESI_TEL_NO,25))#">
			<cfset RESI_FAX		 = "#LEFT(TRIM(GetClientDetails.RESI_FAX_NO),25)#">
			<CFSET OFF_ADD1		 = "#GETTOKEN(GetClientDetails.OFF_ADDRESS,1,'~')#">
			<CFSET OFF_ADD2		 = "#GETTOKEN(GetClientDetails.OFF_ADDRESS,2,'~')#">
			<CFSET OFF_ADD3		 = "#GETTOKEN(GetClientDetails.OFF_ADDRESS,3,'~')#">
			<CFSET OFF_TEL		 = "#LEFT(TRIM(GetClientDetails.OFF_TEL_NO),25)#">
			<CFSET OFF_FAX		 = "#LEFT(TRIM(GetClientDetails.OFF_FAX_NO),25)#">
			<CFSET EMAIL		 = "#LEFT(TRIM(GetClientDetails.EMAIL_ID),50)#">
			<CFSET BIRTHDATE	 = "#GetClientDetails.BIRTH_DATE#">
			<CFSET QUALIFCATIN	 = "#LEFT(TRIM(GetClientDetails.QUALIFICATION),25)#">
			<CFSET OCCUPATION	 = "#LEFT(TRIM(GetClientDetails.OCCUPATION),25)#">
			<CFSET MOBILE_NO	 = "#GetClientDetails.MOBILE_NO#">
			<!--- <CFSET INTRODUCER_NAME1 = "#GETTOKEN(GetClientDetails.INTRODUCER_NAME,1," ")#">
			<CFSET INTRODUCER_NAME2 = "#GETTOKEN(GetClientDetails.INTRODUCER_NAME,2," ")#">
			<CFSET INTRODUCER_NAME3 = "#GETTOKEN(GetClientDetails.INTRODUCER_NAME,3," ")#">
			<CFSET RELWITHINT		= "#LEFT(TRIM(GetClientDetails.Rel_With_Introducer),25)#">
			<CFSET INTRODUCER_ACC_CODE = "#LEFT(TRIM(GetClientDetails.INTRODUCER_ACC_CODE),12)#"> --->
			<CFSET INTRODUCER_NAME = "#GetClientDetails.INTRODUCER_NAME#">
			<CFSET INTRODUCER_NAME2 = "">
			<CFSET INTRODUCER_NAME3 = "">
			<CFSET RELWITHINT		= "">
			<CFSET INTRODUCER_ACC_CODE = "">
			<CFSET MAPIN = "#LEFT(TRIM(GetClientDetails.MAPIN),9)#">
			<CFSET PAN_NO = "#LEFT(TRIM(GetClientDetails.PAN_NO),10)#">
			<CFSET PASSPORT_NO = "#LEFT(TRIM(GetClientDetails.PASSPORT_NO),25)#">
			<CFSET PASSPORT_EXPIRY_DATE = "#GetClientDetails.PASSPORT_EXPIRY_DATE#">
			<CFSET PASSPORT_ISSUED_PLACE = "#LEFT(TRIM(GetClientDetails.PASSPORT_ISSUED_PLACE),25)#">
			<CFSET Pass_Issue_Date = "#GetClientDetails.Pass_Issue_Date#">
			<CFSET DRIVING_LICENSE = "#LEFT(TRIM(GetClientDetails.DRIVING_LICENSE),25)#">
			<CFSET DRIVING_LICENSE_ISSUED_PLACE = "#LEFT(TRIM(GetClientDetails.DRIVING_LICENSE_ISSUED_PLACE),25)#">
			<CFSET DRIVING_LICENSE_ISSUED_DATE	= "#GetClientDetails.DRIVING_LICENSE_ISSUED_DATE#">
			<CFSET Dr_Lic_Exp_Date = "#GetClientDetails.Dr_Lic_Exp_Date#">
			<CFSET VOTERS_ID_CARD	= "#LEFT(TRIM(GetClientDetails.VOTERS_ID_CARD),25)#">
			<CFSET Place_Issue_Vouter_ID = "#LEFT(TRIM(GetClientDetails.Place_Issue_Vouter_ID),25)#">
			<CFSET VOTERS_ID_CARD_ISSUED_DATE = "#GetClientDetails.VOTERS_ID_CARD_ISSUED_DATE#">
			<CFSET RATIONCARD = "#LEFT(TRIM(GetClientDetails.RATIONCARD),25)#">
			<CFSET RATIONCARD_ISSUED_PLACE = "#LEFT(TRIM(GetClientDetails.RATIONCARD_ISSUED_PLACE),25)#">
			<CFSET RATIONCARD_EXPIRY_DATE = "#GetClientDetails.RATIONCARD_EXPIRY_DATE#">
			<CFSET STDCODE		=	"#TRIM(GetClientDetails.STD_Code)#">
			<CFSET RegistrationNumber = "#TRIM(GetClientDetails.Registration_Number)#">
			<CFSET RegistrationAuthority = "#TRIM(GetClientDetails.Registration_Authority)#">
			<CFSET PlaceOfReg = "#TRIM(GetClientDetails.Place_Of_Reg)#">
			<CFSET DateofReg = "#TRIM(GetClientDetails.Date_of_Reg)#">
			<CFSET NOOFPARTNERS = "#TRIM(GetClientDetails.NO_OF_PARTNERS)#">

			<CFSET SEX							=		"#TRIM(GetClientDetails.SEX)#">
			<CFSET FATHER_HUSBAND_NAME			=		"#TRIM(GetClientDetails.FATHER_HUSBAND_NAME)#">
			<CFSET MARITAL_STATUS				=		"#TRIM(GetClientDetails.MARITAL_STATUS)#">
			<CFSET NATIONALITY					=		"#TRIM(GetClientDetails.NATIONALITY)#">
			<CFSET NATIONALITY_OTHERS			=		"#TRIM(GetClientDetails.NATIONALITY_OTHERS)#">
			<CFSET STATE_OTH					=		"#TRIM(GetClientDetails.STATE_OTHERS)#">
			<CFSET ISDCODE_off					=		"#TRIM(GetClientDetails.ISDCODE_off)#">
			<CFSET STD_CODE_off					=		"#TRIM(GetClientDetails.STD_CODE_off)#">
			<CFSET Off_TEL_NO1					=		"#TRIM(GetClientDetails.Off_TEL_NO)#">
			<CFSET UID							=		"#TRIM(GetClientDetails.UID)#">
			<CFSET GROSSAI						=		"#TRIM(GetClientDetails.ANNUAL_INCOME)#">
			<CFSET GROSSAID						=		"#Dateformat(GetClientDetails.GrossAnnualIncomeDate,"dd/mm/yyyy")#">
			<CFSET NetWorth						=		"#TRIM(GetClientDetails.Net_Worth)#">
			<CFSET NETWORTHD					=	 	"#Dateformat(GetClientDetails.Net_Worth_Date,"dd/mm/yyyy")#">
			<CFSET ACTIVE_INACTIVE				=		"#TRIM(GetClientDetails.ACTIVE_INACTIVE)#">
			<CFSET PEP							=		"#TRIM(GetClientDetails.Political_Affilication)#">
			<CFSET POI							=		"#TRIM(GetClientDetails.PlaceofIncorporation)#">
			<CFSET OCCUPATION					=		"#TRIM(GetClientDetails.OCCUPATION)#">
			<CFSET OCCUPATION_OTH				=		"#TRIM(GetClientDetails.OCCUPATION_OTHERS)#">
			<CFSET DATEOFFCOMM					=		"#Dateformat(GetClientDetails.Dateofcommencement,"dd/mm/yyyy")#">

			<CFSET Contact_Person1				=		"#TRIM(GetClientDetails.Contact_Person1)#">
			<CFSET Designation_Person1				=		"#TRIM(GetClientDetails.Designation_Person1)#">
			<CFSET Address_Person1				=		"#TRIM(GetClientDetails.Address_Person1)#">
			<CFSET EmailId_Person1				=		"#TRIM(GetClientDetails.EmailId_Person1)#">
			<CFSET PanNo_Person1				=		"#TRIM(GetClientDetails.PanNo_Person1)#">
			<CFSET TelNo_Person1				=		"#TRIM(GetClientDetails.TelNo_Person1)#">

			<CFSET Contact_Person2				=		"#TRIM(GetClientDetails.Contact_Person2)#">
			<CFSET Designation_Person2				=		"#TRIM(GetClientDetails.Designation_Person2)#">
			<CFSET Address_Person2				=		"#TRIM(GetClientDetails.Address_Person2)#">
			<CFSET EmailId_Person2				=		"#TRIM(GetClientDetails.EmailId_Person2)#">
			<CFSET PanNo_Person2				=		"#TRIM(GetClientDetails.PanNo_Person2)#">
			<CFSET TelNo_Person2				=		"#TRIM(GetClientDetails.TelNo_Person2)#">




				
			
			<CFSET DEPOSITORY	=	"#LEFT(TRIM(GetclientDpDetails.DEPOSITORY),4)#">
			<CFSET DPNAME		=	"#LEFT(TRIM(GetclientDpDetails.DP_NAME),25)#">
			<CFSET CLIENT_DP_CODE  = "#LEFT(TRIM(GetclientDpDetails.CLIENT_DP_CODE),16)#">
			
			<CFSET Bank_name	= "#LEFT(TRIM(GETBANKDETAILS.Bank_Name),50)#">
			<CFSET Bank_Add		= "#LEFT(TRIM(GETBANKDETAILS.Bank_Address),50)#">
			<CFSET MICR			= "#LEFT(TRIM(GETBANKDETAILS.Micr_Code),9)#">
			<CFSET DateOfRegBank= "#trim(GETBANKDETAILS.ACC_OPEN_DATE)#">
			<CFSET CLIENTBANKCODE = "#LEFT(TRIM(GETBANKDETAILS.Bank_AcNo),25)#">
			
			 <cfset EMAIL = #gettoken(Trim(GetClientDetails.EMAIL_ID),1,';')# >
			 <cfif EMAIL eq "">
				<CFSET EMAIL = "#LEFT(Trim(GetClientDetails.EMAIL_ID),50)#"> 	
			 </cfif>
				 
			<CFSET TYPE	=	"#TRIM(GETBANKDETAILS.BANK_ACCTYPE)#">
			
			<CFIF TYPE EQ "SAVING">
				<CFSET BANKTYPE = "#TYPE#">
			<CFELSEIF TYPE EQ "CURRENT">
				<CFSET BANKTYPE = "#TYPE#">
			<CFELSEIF TYPE EQ "Other">
				<CFSET BANKTYPE = "Others">
			<CFELSE>
				<CFSET BANKTYPE = "#TYPE#">
			</CFIF>
			
			<cfquery name="getsegmentdetailsBSE" datasource="#client.database#">
				SELECT COMPANY_CODE,CLIENT_ID
				FROM CLIENT_MASTER
				WHERE
					CLIENT_ID 	= '#CLIENT_ID#'
				and COMPANY_CODE in ('BSE_CASH')
			</cfquery>
			
			<CFIF  getsegmentdetailsBSE.COMPANY_CODE EQ "BSE_CASH">
				<CFSET EQFLAGDATA = "Y">
			<cfelse>
				<CFSET EQFLAGDATA = "N">	
			</CFIF>
			
			<cfquery name="getsegmentdetailsBSEF" datasource="#client.database#">
				SELECT COMPANY_CODE,CLIENT_ID
				FROM CLIENT_MASTER
				WHERE
					CLIENT_ID 	= '#CLIENT_ID#'
				and COMPANY_CODE in ('BSE_FNO')
			</cfquery>
			
			<CFIF  getsegmentdetailsBSEF.COMPANY_CODE EQ "BSE_FNO">
				<CFSET DERFLAGDATA = "Y">
			<cfelse>
				<CFSET DERFLAGDATA = "N">	
			</CFIF>
			
			
			<cfquery name="getsegmentdetailsBSEU" datasource="#client.database#">
				SELECT COMPANY_CODE,CLIENT_ID
				FROM CLIENT_MASTER
				WHERE
					CLIENT_ID 	= '#CLIENT_ID#'
				and COMPANY_CODE in ('CD_USE')
			</cfquery>
			
			<CFIF  getsegmentdetailsBSEU.COMPANY_CODE EQ "CD_USE">
				<CFSET CURRFLAGDATA = "Y">
			<cfelse>
				<CFSET CURRFLAGDATA = "N">	
			</CFIF>
			
			<cfquery name="getsegmentdetailsBSESLM" datasource="#client.database#">
				SELECT COMPANY_CODE,CLIENT_ID
				FROM CLIENT_MASTER
				WHERE
					CLIENT_ID 	= '#CLIENT_ID#'
				and COMPANY_CODE in ('BSE_SLBM')
			</cfquery>
			
			<CFIF  getsegmentdetailsBSESLM.COMPANY_CODE EQ "BSE_SLBM">
				<CFSET SLBMFLAGDATA = "Y">
			<cfelse>
				<CFSET SLBMFLAGDATA = "N">	
			</CFIF>
			
			<cfquery name="getsegmentdetailsBSERDM" datasource="#client.database#">
				SELECT COMPANY_CODE,CLIENT_ID
				FROM CLIENT_MASTER
				WHERE
					CLIENT_ID 	= '#CLIENT_ID#'
				and COMPANY_CODE in ('BSE_RDM')
			</cfquery>
			
			<CFIF  getsegmentdetailsBSERDM.COMPANY_CODE EQ "BSE_RDM">
				<CFSET RDMFLAGDATA = "Y">
			<cfelse>
				<CFSET RDMFLAGDATA = "N">	
			</CFIF>	
			
			<CFIF PAN_NO neq "" AND LEN(TRIM(BIRTHDATE)) NEQ 0 AND trim(category) EQ "I">
				<CFSET FINALSTRING = "#FINALSTRING#">			
				<cfquery name="getsegmentdetails" datasource="#client.database#">
					SELECT COMPANY_CODE,CLIENT_ID
					FROM CLIENT_MASTER
					WHERE
						COMPANY_CODE IN ('BSE_CASH','BSE_FNO')
					AND CLIENT_ID 	= '#CLIENT_ID#'
				</cfquery>
				<cfif Format1 eq "New">
					<CFSET FINALSTRING = "#FINALSTRING#N|#BrkWebXId#|">
				<cfelse>	
					<CFSET FINALSTRING = "#FINALSTRING#M|#BrkWebXId#|">
				</cfif>
				
				<!--- SET STATUS  --->
				<CFIF CLIENT_NATURE  EQ "C">
					<cfset STATUS = "CL">
				<CFELSEIF CLIENT_NATURE EQ "P">
					<cfset STATUS = "OW">
				<CFELSEIF CLIENT_NATURE EQ "I">
					<cfset STATUS = "IN">
				<CFELSE>
					<cfset STATUS = "">	
				</CFIF>
				
						
				<cfset Catagory1 = "#category#">
				
				<cfif Catagory1 eq 'I' or Catagory1 eq 'NRI' or Catagory1 eq 'HNI' or Catagory1 eq 'FN' or Catagory1 eq 'PMSI' or Catagory1 eq 'QFII'>
					<cfset CLIENTTYPE = "I">
				<cfELSEif 	Catagory1 eq 'CO' or Catagory1 eq 'COOP' or Catagory1 eq 'O' or Catagory1 eq 'PF'or Catagory1 eq 'PC'or Catagory1 eq 'PMSN'or Catagory1 eq 'QFIN' 
							or Catagory1 eq 'AOP'or Catagory1 eq 'FVCF'or Catagory1 eq 'HUF'or Catagory1 eq 'MB'or Catagory1 eq 'TS'or Catagory1 eq 'OCB'
							or Catagory1 eq 'BOI'or Catagory1 eq 'NGO'or Catagory1 eq 'DEF'or Catagory1 eq 'SOC'or Catagory1 eq 'CH'or Catagory1 eq 'VCF' or Catagory1 eq 'PVTLTD' or Catagory1 eq 'SB'>
					<cfset CLIENTTYPE = "NI">
				<CFELSEIF Catagory1 eq 'B' or Catagory1 eq 'FII' or Catagory1 eq 'LIC' or Catagory1 eq 'DFI' or Catagory1 eq 'MF' or Catagory1 eq 'NPS' >
					<cfset CLIENTTYPE = "INS">
				</cfif>

				<cfif Catagory1 eq 'I'>
					<CFSET Catagory2 = "I">
				<cfELSEif Catagory1 eq 'NRI'>
					<CFSET Catagory2 = "NRI">
				<cfELSEif Catagory1 eq 'HNI'>
					<CFSET Catagory2 = "HNI">
				<cfELSEif Catagory1 eq 'FN'>
					<CFSET Catagory2 = "I">
				<cfELSEif Catagory1 eq 'PMSI'>
					<CFSET Catagory2 = "PMSI">
				<cfELSEif Catagory1 eq 'QFII'>
					<CFSET Catagory2 = "QFII">
				<cfELSEif 	Catagory1 eq 'CO'>
					<CFSET Catagory2 = "BCO">
				<cfELSEif Catagory1 eq 'O'>
					<CFSET Catagory2 = "O">
				<cfELSEif Catagory1 eq 'PF'>
					<CFSET Catagory2 = "PF">
				<cfELSEif Catagory1 eq 'PC'>
					<CFSET Catagory2 = "LLP">
				<cfELSEif Catagory1 eq 'PMSN'>
					<CFSET Catagory2 = "PMSN">
				<cfELSEif Catagory1 eq 'QFIN'>
					<CFSET Catagory2 = "QFIN">
				<cfELSEif Catagory1 eq 'AOP'>
					<CFSET Catagory2 = "AOP">
				<cfELSEif Catagory1 eq 'FVCF'>
					<CFSET Catagory2 = "FVCF">
				<cfELSEif Catagory1 eq 'HUF'>
					<CFSET Catagory2 = "HUF">
				<cfELSEif Catagory1 eq 'MB'>
					<CFSET Catagory2 = "MB">
				<cfELSEif Catagory1 eq 'TS'>
					<CFSET Catagory2 = "T">
				<cfELSEif Catagory1 eq 'OCB'>
					<CFSET Catagory2 = "OCB">
				<cfELSEif Catagory1 eq 'BOI'>
					<CFSET Catagory2 = "BOI">
				<cfELSEif Catagory1 eq 'NGO'>
					<CFSET Catagory2 = "NGO">
				<cfELSEif Catagory1 eq 'DEF'>
					<CFSET Catagory2 = "DEF">
				<cfELSEif Catagory1 eq 'SOC'>
					<CFSET Catagory2 = "SOC">
				<cfELSEif Catagory1 eq 'CH'>
					<CFSET Catagory2 = "CH">
				<cfELSEif Catagory1 eq 'VCF'>
					<CFSET Catagory2 = "VCF">
				<CFELSEIF Catagory1 eq 'B'>
					<CFSET Catagory2 = "B">
				<cfELSEif Catagory1 eq 'FII'>
					<CFSET Catagory2 = "FII">
				<cfELSEif Catagory1 eq 'LIC'>
					<CFSET Catagory2 = "INS">
				<cfELSEif Catagory1 eq 'DFI'>
					<CFSET Catagory2 = "LLP">
				<cfELSEif Catagory1 eq 'MF'>
					<CFSET Catagory2 = "MF">
				<cfELSEif Catagory1 eq 'NPS' >
					<CFSET Catagory2 = "NPS">
				<cfELSEif Catagory1 eq 'SB' >
					<CFSET Catagory2 = "STATBO">
				<CFELSE>
					<CFSET Catagory2 = "">
				</cfif>

				<CFSET FINALSTRING = "#FINALSTRING##CLIENTTYPE#|#STATUS#|#CATAGORY1#|#client_id#|">
	
				<CFIF  PAN_NO nEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##PAN_NO#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|">	
				</CFIF>
				
				<CFIF PEP EQ '03'  or PEP eq '04'>
					<CFSET PEP1 = 'N'>
				<CFELSE>
					<CFSET PEP1 = 'Y'>
				</CFIF>
				<CFSET FINALSTRING = "#FINALSTRING##PEP1#|">	
				
				<cfif trim(category) eq "I" OR trim(category) eq "NRI">
					<CFSET LASTNAME = "#left(LAST_NAME,30)#">
					<CFSET FIRSTNAME = "#left(FIRST_NAME,30)#">
					<CFSET MIDDLENAME = "#left(MIDDLE_NAME,30)#">
					<CFSET Client_Name1 = "">
				<CFELSE>
					<CFSET LASTNAME = "">
					<CFSET FIRSTNAME = "">
					<CFSET MIDDLENAME = "">
				</CFIF>

				
				<!--- <CFSET FINALSTRING = "#FINALSTRING##Client_Name1#|#LASTNAME#|#FIRSTNAME#|#MIDDLENAME#|">	 --->
						
				<CFIF RESI_ADD1 NEQ "" OR RESI_ADD2 NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##LEFT(TRIM(RESI_ADD1),75)##LEFT(TRIM(RESI_ADD2),75)#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|">	
				</CFIF>
				
				<cfif RESI_ADD1 eq REG_ADDR1>
					<cfset PerAddSAC = "Y">
				<cfelse>
					<cfset PerAddSAC = "N">
				</cfif>

				<cfif PerAddSAC eq 'N'>
					<CFSET FINALSTRING = "#FINALSTRING##PerAddSAC#|#LEFT(TRIM(REG_ADDR1),75)##LEFT(TRIM(REG_ADDR2),75)#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING##PerAddSAC#|#LEFT(TRIM(RESI_ADD1),75)##LEFT(TRIM(RESI_ADD2),75)#|">	
				</CFIF>
				
				<cfif RESI_TEL_NO neq "">
					<cfset ContactDetails = '1'>
				</cfif>

				<cfif MOBILE_NO neq "">
					<cfset ContactDetails = '2'>
				</cfif>
				
				<cfif RESI_TEL_NO neq "" and MOBILE_NO neq "">
					<cfset ContactDetails = '3'>
				</cfif>

			<CFQUERY name="GetCityCode" datasource="#client.database#">
				select * from CITY_MASTER
				where CITY_NAME = '#Trim(GetClientDetails.CITY)#'
			</CFQUERY>

			<CFIF Trim(GetCityCode.CITY_CODE) EQ "">
				<CFSET  CITY_R = "#Trim(GetClientDetails.CITY)#">
			<CFELSE>
				<CFSET  CITY_R = "#Trim(GetCityCode.CITY_CODE)#">
			</CFIF>

			<CFQUERY name="GetStateCode" datasource="#client.database#">
				select * from state_master
				where STATE_code = '#Trim(GetClientDetails.STATE)#'
			</CFQUERY>

			<cfset STATE1 = "#TRIM(GetStateCode.NSESTATENAME)#">

			<cfif state1 eq "">
				<cfset STATE1 = STATE_OTH>
			</cfif>

			<CFIF Trim(GetStateCode.STATE_code) EQ "">
				<CFSET  STATE_R = "#Trim(GetClientDetails.STATE)#">
			<CFELSE>
				<CFSET  STATE_R = "#Trim(GetStateCode.nse_STATE_code)#">
			</CFIF>

				<cfset ContactDetails = ''>
				<cfif RESI_TEL_NO neq "">
					<cfset ContactDetails = '1'>
				</cfif>

				<cfif MOBILE_NO neq "">
					<cfset ContactDetails = '2'>
				</cfif>
				
				<cfif RESI_TEL_NO neq "" and MOBILE_NO neq "">
					<cfset ContactDetails = '3'>
				</cfif>
					
				<CFSET FINALSTRING = "#FINALSTRING##LEFT(Country,25)#|#LEFT(State1,25)#|#LEFT(CITY,25)#|#TRIM(LEFT(PINCODE,10))#|#TypeOfFacility#|#ContactDetails#|">
				<CFSET FINALSTRING = "#FINALSTRING##Left(EMAIL,50)#|#MOBILE_NO#|">

				<CFIF RESI_TEL_NO NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##STDCODE#|#RESI_TEL_NO#|">
				<cfelseif MOBILE_NO NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING#|#MOBILE_NO#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|#OFF_TEL#|">
				</CFIF>
				
				<CFSET FINALSTRING = "#FINALSTRING#||||">
				<CFSET FINALSTRING = "#FINALSTRING##DEPOSITORY#|#CLIENT_DP_CODE#|#DPNAME#|||||||">

				<CFIF  Bank_name NEQ "" AND Bank_Add NEQ ""  AND CLIENTBANKCODE NEQ "" AND BANKTYPE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##Bank_name#|#CLIENTBANKCODE#|#Bank_Add#|||||||">	
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||||||||"><!--- #FINALSTRING#|N|||| --->		
				</CFIF>

				<CFSET FINALSTRING = "#FINALSTRING##Reg_Date#|">
			
				<CFSET ProvideDetails = "">
				
				<CFIF GROSSAI NEQ "">
					<CFSET ProvideDetails = "1">
				</CFIF>

				<CFIF NetWorth NEQ "">
					<CFSET ProvideDetails = "2">
				</CFIF>

				<CFIF GROSSAI NEQ "" AND NetWorth NEQ "">
					<CFSET ProvideDetails = "3">
				</CFIF>
				
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

				<CFSET FINALSTRING = "#FINALSTRING##ProvideDetails#|#Income#|#GROSSAID#|#NetWorth#|#NETWORTHD#|#ACTIVE_INACTIVE#||">

				<CFSET FINALSTRING = "#FINALSTRING##FIRSTNAME#|#MIDDLENAME#|#LASTNAME#||#BIRTHDATE#|#Client_Name1#|">

				<CFIF trim(CATAGORY1) NEQ "I">
					<CFSET FINALSTRING = "#FINALSTRING##RegistrationNumber#|#RegistrationAuthority#|#DateofReg#|#PlaceOfReg#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||">	
				</CFIF>
				
				<CFSET CINFINAL = "">
				<CFSET CINFINALFLAG = "N">

				<CFIF CATEGORY EQ "CO">
					<CFSET CINFINAL = "#CIN1#">
					<CFSET CINFINALFLAG = "Y">
				</CFIF>

				<CFSET FINALSTRING = "#FINALSTRING##CINFINALFLAG#|#CINFINAL#|">
				<CFSET NOOFDIR = "#NOOFPARTNERS#">

				<CFSET FINALSTRING = "#FINALSTRING##NOOFDIR#|||">
				<CFSET FINALSTRING = "#FINALSTRING##Contact_Person1#|#Designation_Person1#|#Address_Person1#|#EmailId_Person1#|#PanNo_Person1#|#TelNo_Person1#|">
				<cfif Designation_Person2 eq 'karta'>
					<cfset Designation_Person22 = 'COPARCENER'>
				<cfelsE>	
					<cfset Designation_Person22 = Designation_Person2>
				</cfif>
				<CFSET FINALSTRING = "#FINALSTRING##Contact_Person2#|#Designation_Person22#|#Address_Person2#|#EmailId_Person2#|#PanNo_Person2#|#TelNo_Person2#">

				<CFSET FINALSTRING = "#FINALSTRING#|#EQFLAGDATA#|#DERFLAGDATA#|#SLBMFLAGDATA#|#CURRFLAGDATA#|#RDMFLAGDATA##CHR(10)#">
				
				<!--- <Cfif COCD eq 'BSE_CASH'>
						<CFSET FINALSTRING = "#FINALSTRING#|Y|N|N|N|N#CHR(10)#"><!--- #FINALSTRING#||N|||N||| --->	
				<CfELSEif COCD eq 'BSE_FNO'>
						<CFSET FINALSTRING = "#FINALSTRING#|N|Y|N|N|N#CHR(10)#"><!--- #FINALSTRING#||N|||N||| --->	
				<cfelse>				
						<CFSET FINALSTRING = "#FINALSTRING##CHR(10)#"><!--- #FINALSTRING#||N|||N||| --->	
				</Cfif> --->

				<cfset FINALSTRINGLog = "#FINALSTRINGLog# #client_id# SucessFully generated #Chr(10)#">
			<CFELSEIF PAN_NO neq "" AND  trim(category) NEQ "I">
				<CFSET FINALSTRING = "#FINALSTRING#">			
				<cfquery name="getsegmentdetails" datasource="#client.database#">
					SELECT COMPANY_CODE,CLIENT_ID
					FROM CLIENT_MASTER
					WHERE
						COMPANY_CODE IN ('BSE_CASH','BSE_FNO')
					AND CLIENT_ID 	= '#CLIENT_ID#'
				</cfquery>
				<cfif Format1 eq "New">
					<CFSET FINALSTRING = "#FINALSTRING#N|#BrkWebXId#|">
				<cfelse>	
					<CFSET FINALSTRING = "#FINALSTRING#M|#BrkWebXId#|">
				</cfif>
				
				<!--- SET STATUS  --->
				<CFIF CLIENT_NATURE  EQ "C">
					<cfset STATUS = "CL">
				<CFELSEIF CLIENT_NATURE EQ "P">
					<cfset STATUS = "OW">
				<CFELSEIF CLIENT_NATURE EQ "I">
					<cfset STATUS = "IN">
				<CFELSE>
					<cfset STATUS = "">	
				</CFIF>
				
						
				<cfset Catagory1 = "#category#">

				<cfif Catagory1 eq 'I' or Catagory1 eq 'NRI' or Catagory1 eq 'HNI' or Catagory1 eq 'FN' or Catagory1 eq 'PMSI' or Catagory1 eq 'QFII'>
					<cfset CLIENTTYPE = "I">
				<cfELSEif 	Catagory1 eq 'CO'  or Catagory1 eq 'COOP' or Catagory1 eq 'O' or Catagory1 eq 'PF'or Catagory1 eq 'PC'or Catagory1 eq 'PMSN'or Catagory1 eq 'QFIN' 
							or Catagory1 eq 'AOP'or Catagory1 eq 'FVCF'or Catagory1 eq 'HUF'or Catagory1 eq 'MB'or Catagory1 eq 'TS'or Catagory1 eq 'OCB'
							or Catagory1 eq 'BOI'or Catagory1 eq 'NGO'or Catagory1 eq 'DEF'or Catagory1 eq 'SOC'or Catagory1 eq 'CH'or Catagory1 eq 'VCF' or Catagory1 eq 'PVTLTD'>
					<cfset CLIENTTYPE = "NI">
				<CFELSEIF Catagory1 eq 'B' or Catagory1 eq 'FII' or Catagory1 eq 'LIC' or Catagory1 eq 'DFI' or Catagory1 eq 'IFI' or Catagory1 eq 'MF' or Catagory1 eq 'NPS' >
					<cfset CLIENTTYPE = "INS">
				</cfif>

				<cfif Catagory1 eq 'I'>
					<CFSET Catagory2 = "I">
				<cfELSEif Catagory1 eq 'NRI'>
					<CFSET Catagory2 = "NRI">
				<cfELSEif Catagory1 eq 'HNI'>
					<CFSET Catagory2 = "HNI">
				<cfELSEif Catagory1 eq 'FN'>
					<CFSET Catagory2 = "I">
				<cfELSEif Catagory1 eq 'PMSI'>
					<CFSET Catagory2 = "PMSI">
				<cfELSEif Catagory1 eq 'QFII'>
					<CFSET Catagory2 = "QFII">
				<cfELSEif 	Catagory1 eq 'CO'>
					<CFSET Catagory2 = "BCO">
				<cfELSEif Catagory1 eq 'O'>
					<CFSET Catagory2 = "O">
				<cfELSEif Catagory1 eq 'PF'>
					<CFSET Catagory2 = "PF">
				<cfELSEif Catagory1 eq 'PC'>
					<CFSET Catagory2 = "LLP">
				<cfELSEif Catagory1 eq 'PMSN'>
					<CFSET Catagory2 = "PMSN">
				<cfELSEif Catagory1 eq 'QFIN'>
					<CFSET Catagory2 = "QFIN">
				<cfELSEif Catagory1 eq 'AOP'>
					<CFSET Catagory2 = "AOP">
				<cfELSEif Catagory1 eq 'FVCF'>
					<CFSET Catagory2 = "FVCF">
				<cfELSEif Catagory1 eq 'HUF'>
					<CFSET Catagory2 = "HUF">
				<cfELSEif Catagory1 eq 'MB'>
					<CFSET Catagory2 = "MB">
				<cfELSEif Catagory1 eq 'TS'>
					<CFSET Catagory2 = "T">
				<cfELSEif Catagory1 eq 'OCB'>
					<CFSET Catagory2 = "OCB">
				<cfELSEif Catagory1 eq 'BOI'>
					<CFSET Catagory2 = "BOI">
				<cfELSEif Catagory1 eq 'NGO'>
					<CFSET Catagory2 = "NGO">
				<cfELSEif Catagory1 eq 'DEF'>
					<CFSET Catagory2 = "DEF">
				<cfELSEif Catagory1 eq 'SOC'>
					<CFSET Catagory2 = "SOC">
				<cfELSEif Catagory1 eq 'CH'>
					<CFSET Catagory2 = "CH">
				<cfELSEif Catagory1 eq 'VCF'>
					<CFSET Catagory2 = "VCF">
				<CFELSEIF Catagory1 eq 'B'>
					<CFSET Catagory2 = "B">
				<cfELSEif Catagory1 eq 'FII'>
					<CFSET Catagory2 = "FII">
				<cfELSEif Catagory1 eq 'LIC'>
					<CFSET Catagory2 = "INS">
				<cfELSEif Catagory1 eq 'DFI'>
					<CFSET Catagory2 = "DFI">
				<cfELSEif Catagory1 eq 'IFI'>
					<CFSET Catagory2 = "DFI">
				<cfELSEif Catagory1 eq 'MF'>
					<CFSET Catagory2 = "MF">
				<cfELSEif Catagory1 eq 'NPS' >
					<CFSET Catagory2 = "NPS">
				<CFELSE>
					<CFSET Catagory2 = "O">
				</cfif>

				
				<CFSET FINALSTRING = "#FINALSTRING##CLIENTTYPE#|#STATUS#|#Catagory2#|#client_id#|">
	
				<CFIF  PAN_NO nEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##PAN_NO#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|">	
				</CFIF>

				<CFIF PEP EQ '03'  or PEP eq '04'>
					<CFSET PEP1 = 'N'>
				<CFELSE>
					<CFSET PEP1 = 'Y'>
				</CFIF>

				<CFSET FINALSTRING = "#FINALSTRING##PEP1#|">	
				
				<cfif trim(category) eq "I" OR trim(category) eq "NRI">
					<CFSET LASTNAME = "#left(LAST_NAME,30)#">
					<CFSET FIRSTNAME = "#left(FIRST_NAME,30)#">
					<CFSET MIDDLENAME = "#left(MIDDLE_NAME,30)#">
					<CFSET Client_Name1 = "">
				<CFELSE>
					<CFSET LASTNAME = "">
					<CFSET FIRSTNAME = "">
					<CFSET MIDDLENAME = "">
				</CFIF>

				<cfif Catagory2 eq 'PMSI'>
					<CFSET LASTNAME = "#left(LAST_NAME,30)#">
					<CFSET FIRSTNAME = "#left(FIRST_NAME,30)#">
					<CFSET MIDDLENAME = "#left(MIDDLE_NAME,30)#">
				</cfif>
				
				<!--- <CFSET FINALSTRING = "#FINALSTRING##Client_Name1#|#LASTNAME#|#FIRSTNAME#|#MIDDLENAME#|">	 --->
						
				<CFIF RESI_ADD1 NEQ "" OR RESI_ADD2 NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##LEFT(TRIM(RESI_ADD1),75)##LEFT(TRIM(RESI_ADD2),75)#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|">	
				</CFIF>
				
				
				<cfif RESI_ADD1 eq REG_ADDR1>
					<cfset PerAddSAC = "Y">
				<cfelse>
					<cfset PerAddSAC = "N">
				</cfif>

				<cfif PerAddSAC eq 'N'>
					<CFSET FINALSTRING = "#FINALSTRING##PerAddSAC#|#LEFT(TRIM(REG_ADDR1),75)##LEFT(TRIM(REG_ADDR2),75)#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING##PerAddSAC#|#LEFT(TRIM(RESI_ADD1),75)##LEFT(TRIM(RESI_ADD2),75)#|">	
				</CFIF>
				
				<!--- <cfset PerAddSAC = "N">

				<CFIF RESI_ADD1 NEQ "" OR RESI_ADD2 NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##PerAddSAC#|#LEFT(TRIM(RESI_ADD1),75)##LEFT(TRIM(RESI_ADD2),75)#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||">	
				</CFIF> --->
				
				<cfset ContactDetails = ''>
				<cfif RESI_TEL_NO neq "">
					<cfset ContactDetails = '1'>
				</cfif>

				<cfif MOBILE_NO neq "">
					<cfset ContactDetails = '2'>
				</cfif>
				
				<cfif RESI_TEL_NO neq "" and MOBILE_NO neq "">
					<cfset ContactDetails = '3'>
				</cfif>

			<CFQUERY name="GetCityCode" datasource="#client.database#">
				select * from CITY_MASTER
				where CITY_NAME = '#Trim(GetClientDetails.CITY)#'
			</CFQUERY>
			
			<CFIF Trim(GetCityCode.CITY_CODE) EQ "">
				<CFSET  CITY_R = "#Trim(GetClientDetails.CITY)#">
			<CFELSE>
				<CFSET  CITY_R = "#Trim(GetCityCode.CITY_CODE)#">
			</CFIF>

			<CFQUERY name="GetStateCode" datasource="#client.database#">
				select * from state_master
				where STATE_code = '#Trim(GetClientDetails.STATE)#'
			</CFQUERY>

			<cfset STATE1 = "#TRIM(GetStateCode.NSESTATENAME)#">

			<cfif state1 eq "">
				<cfset STATE1 = STATE_OTH>
			</cfif>

			<CFIF Trim(GetStateCode.STATE_code) EQ "">
				<CFSET  STATE_R = "#Trim(GetClientDetails.STATE)#">
			<CFELSE>
				<CFSET  STATE_R = "#Trim(GetStateCode.nse_STATE_code)#">
			</CFIF>

				<CFSET FINALSTRING = "#FINALSTRING##LEFT(Country,25)#|#LEFT(STATE1,25)#|#LEFT(CITY,25)#|#TRIM(LEFT(PINCODE,10))#|#TypeOfFacility#|#ContactDetails#|">
				<CFSET FINALSTRING = "#FINALSTRING##Left(EMAIL,50)#|#MOBILE_NO#|">

				<CFIF RESI_TEL_NO NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##STDCODE#|#RESI_TEL_NO#|">
				<cfelseif MOBILE_NO NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING#|#MOBILE_NO#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|#OFF_TEL#|">
				</CFIF>
				
				<CFSET FINALSTRING = "#FINALSTRING#||||">
				<CFSET FINALSTRING = "#FINALSTRING##DEPOSITORY#|#CLIENT_DP_CODE#|#DPNAME#|||||||">

				<CFIF  Bank_name NEQ "" AND Bank_Add NEQ ""  AND CLIENTBANKCODE NEQ "" AND BANKTYPE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##Bank_name#|#CLIENTBANKCODE#|#Bank_Add#|||||||">	
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||||||||"><!--- #FINALSTRING#|N|||| --->		
				</CFIF>

				<CFSET FINALSTRING = "#FINALSTRING##Reg_Date#|">
			
				<CFSET ProvideDetails = "">
				
				<CFIF GROSSAI NEQ "">
					<CFSET ProvideDetails = "1">
				</CFIF>

				<CFIF NetWorth NEQ "">
					<CFSET ProvideDetails = "2">
				</CFIF>

				<CFIF GROSSAI NEQ "" AND NetWorth NEQ "">
					<CFSET ProvideDetails = "3">
				</CFIF>
				
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

				<cfif CLIENTTYPE eq 'INS'>
					<CFSET ProvideDetails = ''>
					<CFSET Income = ''>
				</cfif>
				
				<CFSET FINALSTRING = "#FINALSTRING##ProvideDetails#|#Income#|#GROSSAID#|#NetWorth#|#NETWORTHD#|#ACTIVE_INACTIVE#||">

				<CFSET FINALSTRING = "#FINALSTRING##FIRSTNAME#|#MIDDLENAME#|#LASTNAME#||#BIRTHDATE#|#Client_Name1#|">

				<CFIF trim(CATAGORY1) NEQ "I">
					<CFSET FINALSTRING = "#FINALSTRING##RegistrationNumber#|#RegistrationAuthority#|#DateofReg#|#PlaceOfReg#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||">	
				</CFIF>
				
				<CFSET CINFINAL = "">
				<CFSET CINFINALFLAG = "N">

				<CFIF CATEGORY EQ "CO">
					<CFSET CINFINAL = "#CIN1#">
					<CFSET CINFINALFLAG = "Y">
				</CFIF>

				<CFSET FINALSTRING = "#FINALSTRING##CINFINALFLAG#|#CINFINAL#|">
				<CFSET NOOFDIR = "#NOOFPARTNERS#">

				<CFSET FINALSTRING = "#FINALSTRING##NOOFDIR#|||">
				<CFSET FINALSTRING = "#FINALSTRING##Contact_Person1#|#Designation_Person1#|#Address_Person1#|#EmailId_Person1#|#PanNo_Person1#|#TelNo_Person1#|">
				<cfif Designation_Person2 eq 'karta'>
					<cfset Designation_Person22 = 'COPARCENER'>
				<cfelsE>	
					<cfset Designation_Person22 = Designation_Person2>
				</cfif>
				<CFSET FINALSTRING = "#FINALSTRING##Contact_Person2#|#Designation_Person22#|#Address_Person2#|#EmailId_Person2#|#PanNo_Person2#|#TelNo_Person2#">
				
				    
				<CFSET FINALSTRING = "#FINALSTRING#|#EQFLAGDATA#|#DERFLAGDATA#|#SLBMFLAGDATA#|#CURRFLAGDATA#|#RDMFLAGDATA#">
				
				<!--- <Cfif COCD eq 'BSE_CASH'>
						<CFSET FINALSTRING = "#FINALSTRING#|Y|N|N|N|N"><!--- #FINALSTRING#||N|||N||| --->	
				<CfELSEif COCD eq 'BSE_FNO'>
						<CFSET FINALSTRING = "#FINALSTRING#|N|Y|N|N|N"><!--- #FINALSTRING#||N|||N||| --->	
				<cfelse>				
						<CFSET FINALSTRING = "#FINALSTRING#"><!--- #FINALSTRING#||N|||N||| --->	
				</Cfif> --->
				
				<CFIF CATEGORY EQ "CO">
					<CFIF NOOFDIR NEQ "">
						<cfloop index="K" from="1" to="#NOOFDIR#">
							<CFSET FINALSTRING = "#FINALSTRING##CHR(10)#ND|#client_id#|#Evaluate("GetClientDetails.Contact_Person#K#")#|#Evaluate("GetClientDetails.DIN_Person#K#")#|N|#Evaluate("GetClientDetails.PanNo_Person#K#")#">
						</cfloop>
					</CFIF>
				</CFIF>
				<CFSET FINALSTRING = "#FINALSTRING##CHR(10)#"><!--- #FINALSTRING#||N|||N||| --->	
				<cfset FINALSTRINGLog = "#FINALSTRINGLog# #client_id# SucessFully generated #Chr(10)#">
			<cfelse>
				<CFSET FINALSTRINGLog = "#FINALSTRINGLOG##client_id# Pan Or Birthe Date is Missing #Chr(10)#">	
			</CFIF>
		</CFIF>
	</CFLOOP>

<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">		
		<cfif UpdateRow eq 0>
			<Cfif market1 Neq 'All'>
				<SCRIPT>
					alert("Please Select Atlest One Client");
					history.back();
				</SCRIPT>				
			
			</Cfif>				
		<CFELSE>
			<CFIF FileExists('#FILENAME#')>
				<CFFILE  ACTION="DELETE" FILE="#FILENAME#"> 
			</CFIF>
			<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING#" ADDNEWLINE="YES">
			<CFFILE ACTION="APPEND" FILE="#FilenameLog#" OUTPUT="====================================#cocd#====================================" ADDNEWLINE="YES">
			<CFFILE ACTION="APPEND" FILE="#FilenameLog#" OUTPUT="#FINALSTRINGLog#" ADDNEWLINE="YES">
			<CFFILE ACTION="APPEND" FILE="#FilenameLog#" OUTPUT="==============================================================================" ADDNEWLINE="YES">

	
			<cfset ClientFileName  = "C:\COMMUCC\#EXCHANGE#_UCC_#DateFormat(Now(),"DDMMYYYY")#.txt">
			<cfset ClientFileNameLog  = "C:\COMMUCC\#EXCHANGE#_Log_UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt">
			
			<SCRIPT LANGUAGE="VBScript">
				newfolderpath = "c:\BSE_UCC" 
				Set FileSys = CreateObject("Scripting.FileSystemObject")
				If Not filesys.FolderExists(newfolderpath) Then 
					 Set newfolder = filesys.CreateFolder(newfolderpath) 
				End If
			</SCRIPT>
	
			<Cfif market1 eq 'All'>
					<CFSET	ClientFileGenerated	=	CopyFile("#FILENAME#","#ClientFileName#")>
					<CFIF  ClientFileGenerated>
								BSE-CASH,BSE-FNO,CD-BSE File Generated On Client Machine #REPLACE(ClientFileName,'\','\\','ALL')#<br>
					<cfelse>
								BSE-CASH,BSE-FNO,CD-BSE File Generated Not Generate On Client Machine #REPLACE(ClientFileName,'\','\\','ALL')#<br>
					</CFIF>
			<cfelse>
					<CFSET	ClientFileGenerated	=	CopyFile("#FILENAME#","#ClientFileName#")>
					<CFSET	ClientFileGenerated1	=	CopyFile("#FilenameLog#","#ClientFileNameLog#")>
					File Generated On Client Machine #REPLACE(ClientFileName,'\','\\','ALL')#	<br>
					Log File Generated on Client Machine #REPLACE(ClientFileNameLog,'\','\\','ALL')#<br>
			</Cfif>
		</CFIF>
	
</CFOUTPUT>
</BODY>
</HTML>
