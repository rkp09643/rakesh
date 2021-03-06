<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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

	<!--- <CFQUERY NAME="GetClientId" datasource="#Client.database#">
		Select DISTINCT client_id,CLIENT_NATURE,FIRST_NAME,MIDDLE_NAME,LAST_NAME,Client_Name
		from client_master
		Where
			Company_code = '#COCD#'
		AND CONVERT(VARCHAR(10),REGISTRATION_DATE,103) = CONVERT(VARCHAR(10),'#Reg_date#',103)
	</CFQUERY>
	<CFIF GetClientId.RecordCount gt 0> --->
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
		<CFSET FilenameLog 	= "C:\WEBXUCC\Log_#EXCHANGE#_UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt">
		
		<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">
		
		<CFSET FINALSTRING = "">
		<CFSET FINALSTRINGLOG  = "">
		<CFSET UpdateRow	= 0>
		<!--- <CFLOOP QUERY="GetClientId">	 --->	
		<CFLOOP INDEX="i" FROM="1" TO="#Sr#">	
		<CFIF IsDefined("chk#i#")>
			<CFSET	Client_ID	=	Trim(Evaluate("chk#i#"))><!--- " VALUE="#Client_id#" CLASS="StyleCheckBox"> --->
			<CFSET UpdateRow	=	IncrementValue(UpdateRow)>
			
			<CFQUERY NAME="GetClientDetails" datasource="#Client.database#">
				SELECT ISNULL(Father_Husband_Name,'') Father_Husband_Name ,ISNULL(REG_ADDR,'') RESI_ADDRESS,
				ISNULL(R_City,'') CITY,ISNULL(R_State,'') STATE,ISNULL(R_Country,'') Country,R_Pin_Code Pin_Code,
				RESI_TEL_NO,RESI_FAX_NO,
				ISNULL(OFF_ADDRESS,'')OFF_ADDRESS ,OFF_TEL_NO,OFF_FAX_NO,
				ISNULL(EMAIL_ID,'')EMAIL_ID, Convert(Varchar(10),BIRTH_DATE,103) BIRTH_DATE,
				ISNULL(QUALIFICATION,'')QUALIFICATION,ISNULL(OCCUPATION,'')OCCUPATION,ISNULL(INTRODUCER_NAME,'')INTRODUCER_NAME,
				ISNULL(Rel_With_Introducer,'')Rel_With_Introducer,ISNULL(INTRODUCER_ACC_CODE,'')INTRODUCER_ACC_CODE,
				ISNULL(MAPIN,'') MAPIN,ISNULL(PAN_NO,'') PAN_NO,
				ISNULL(PASSPORT_NO,'')PASSPORT_NO,Convert(Varchar(10),PASSPORT_EXPIRY_DATE,103) PASSPORT_EXPIRY_DATE,
				ISNULL(PASSPORT_ISSUED_PLACE,'')PASSPORT_ISSUED_PLACE,Convert(Varchar(10),Pass_Issue_Date,103) Pass_Issue_Date,
				ISNULL(DRIVING_LICENSE,'')DRIVING_LICENSE,ISNULL(DRIVING_LICENSE_ISSUED_PLACE,'')DRIVING_LICENSE_ISSUED_PLACE,
				Convert(Varchar(10),DRIVING_LICENSE_ISSUED_DATE,103) DRIVING_LICENSE_ISSUED_DATE,Convert(Varchar(10),Dr_Lic_Exp_Date,103) Dr_Lic_Exp_Date,
				ISNULL(VOTERS_ID_CARD,'')VOTERS_ID_CARD,ISNULL(Place_Issue_Vouter_ID,'')Place_Issue_Vouter_ID,
				Convert(Varchar(10),VOTERS_ID_CARD_ISSUED_DATE,103) VOTERS_ID_CARD_ISSUED_DATE,
				ISNULL(RATIONCARD,'')RATIONCARD,ISNULL(RATIONCARD_ISSUED_PLACE,'')RATIONCARD_ISSUED_PLACE,Convert(Varchar(10),RATIONCARD_EXPIRY_DATE,103) RATIONCARD_EXPIRY_DATE,
				ISNULL(STD_Code,'0') STD_Code,Registration_Number,Registration_Authority,Place_Of_Reg,Convert(Varchar(10),Date_of_Reg,103)  Date_of_Reg,category
				FROM CLIENT_DETAILS
				WHERE
					CLIENT_ID = '#client_id#'
			</CFQUERY>			
			
			<cfquery name="GetDataMaster" datasource="#Client.database#">
				Select Client_Nature,First_Name,Middle_Name,Last_Name,CONVERT(VARCHAR(10),Registration_Date,103) Registration_Date,Client_Name
				from Client_Master
				Where
					Company_code = '#cocd#'
				And	Client_id	=	'#Client_ID#'	
			</cfquery>
			
			<cfset Client_Nature = '#GetDataMaster.Client_Nature#'>
			<cfset First_Name = '#GetDataMaster.First_Name#'>
			<cfset Middle_Name = '#GetDataMaster.Middle_Name#'>
			<cfset Last_Name = '#GetDataMaster.Last_Name#'>
			<cfset Reg_Date = '#GetDataMaster.Registration_Date#'>
			<cfset Client_Name	 = '#GetDataMaster.Client_Name#'>	
			
			<CFQUERY NAME="GetclientDpDetails" datasource="#Client.database#">
				Select DEPOSITORY,DP_NAME,CLIENT_DP_CODE
				FROM IO_DP_MASTER
				WHERE
					CLIENT_ID = '#CLIENT_ID#'
				AND DEFAULT_ACC = 'Y'
			</CFQUERY>
			
			<CFQUERY NAME="GETBANKDETAILS" datasource="#Client.database#">
				SELECT Bank_Name,Bank_Address,Micr_Code,Bank_AcNo,ACC_OPEN_DATE,
					   BANK_ACCTYPE
				FROM  FA_CLIENT_BANK_DETAILS 
				Where
					Account_Code = '#Client_id#'
				And Default_Ac = 'Yes'	
			</CFQUERY>
			
			<cfIF  TRIM(First_Name) EQ "">
				<CFSET First_Name = "#GETTOKEN(Client_Name,1,' ')#">
			</cfIF>
			<cfIF TRIM(Middle_Name) EQ "">
				<CFSET MIDDLE_NAME = "#GETTOKEN(Client_Name,2,' ')#">
				<cfIF TRIM(GETTOKEN(Client_Name,3,' ')) EQ "">
					<CFSET LAST_NAME  = "#GETTOKEN(Client_Name,2,' ')#">
					<CFSET MIDDLE_NAME = "">
				</cfIF>	
			</cfIF>
			<cfIF TRIM(Last_Name) EQ "">
				<CFSET LAST_NAME  = "#GETTOKEN(Client_Name,3,' ')#">
			</cfIF>
			
			<CFSET FATHERHUSNAME = "#GetClientDetails.Father_Husband_Name#">
			<CFSET RESI_ADD1 	 = "#GETTOKEN(GetClientDetails.RESI_ADDRESS,1,'~')#">	
			<CFSET RESI_ADD2 	 = "#GETTOKEN(GetClientDetails.RESI_ADDRESS,2,'~')#">				
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
			
			<CFSET DEPOSITORY	=	"#LEFT(TRIM(GetclientDpDetails.DEPOSITORY),4)#">
			<CFSET DPNAME		=	"#LEFT(TRIM(GetclientDpDetails.DP_NAME),25)#">
			<CFSET CLIENT_DP_CODE  = "#LEFT(TRIM(GetclientDpDetails.CLIENT_DP_CODE),16)#">
			
			<CFSET Bank_name	= "#LEFT(TRIM(GETBANKDETAILS.Bank_Name),60)#">
			<CFSET Bank_Add		= "#LEFT(TRIM(GETBANKDETAILS.Bank_Address),225)#">
			<CFSET MICR			= "#LEFT(TRIM(GETBANKDETAILS.Micr_Code),9)#">
			<CFSET DateOfReg	= "#trim(GETBANKDETAILS.ACC_OPEN_DATE)#">
			<CFSET CLIENTBANKCODE = "#LEFT(TRIM(GETBANKDETAILS.Bank_AcNo),25)#">
			
			<CFSET TYPE	=	"#TRIM(GETBANKDETAILS.BANK_ACCTYPE)#">
			
			<CFIF TYPE EQ "SAVING">
				<CFSET BANKTYPE = "#TYPE#">
			<CFELSEIF TYPE EQ "CURRENT">
				<CFSET BANKTYPE = "#TYPE#">
			<CFELSE>
				<CFSET BANKTYPE = "#TYPE#">
			</CFIF>
			
			<CFIF PAN_NO neq "" AND LEN(TRIM(BIRTHDATE)) NEQ 0>
				<CFSET FINALSTRING = "#FINALSTRING#">			
				
				<cfif Format1 eq "New">
					<CFIF Market eq "CAPS">
						<CFSET FINALSTRING = "#FINALSTRING#N||Y|N||||">
					<CFELSE>
						<CFSET FINALSTRING = "#FINALSTRING#N||N|Y||||">
					</CFIF>
				<cfelse>	
					<CFIF Market eq "CAPS">
						<CFSET FINALSTRING = "#FINALSTRING#M||Y|N||||">
					<CFELSE>
						<CFSET FINALSTRING = "#FINALSTRING#M||N|Y||||">
					</CFIF>
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
				
				<CFSET FINALSTRING = "#FINALSTRING##client_id#|#STATUS#|#CATAGORY1#|">
	
				<cfif trim(category) eq "I">
					<CFSET LASTNAME = "#left(LAST_NAME,30)#">
					<CFSET FIRSTNAME = "#left(FIRST_NAME,30)#">
					<CFSET MIDDLENAME = "#left(MIDDLE_NAME,30)#">
				<CFELSE>
					<CFSET LASTNAME = "">
					<CFSET FIRSTNAME = "">
					<CFSET MIDDLENAME = "">
				</CFIF>	
				
				<CFSET FINALSTRING = "#FINALSTRING##Client_Name#|#LASTNAME#|#FIRSTNAME#|#MIDDLENAME#|">	
						
				<CFIF RESI_ADD1 NEQ "" OR RESI_ADD2 NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##LEFT(TRIM(RESI_ADD1),75)##LEFT(TRIM(RESI_ADD2),75)#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|">	
				</CFIF>
				
				<CFSET FINALSTRING = "#FINALSTRING##LEFT(CITY,25)#|#LEFT(State,25)#|#LEFT(Country,25)#|#TRIM(LEFT(PINCODE,10))#|">
				
				<CFIF RESI_TEL_NO NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##STDCODE#|#RESI_TEL_NO#">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|#OFF_TEL#">	
				</CFIF>
				
				<CFSET FINALSTRING = "#FINALSTRING#|#Left(EMAIL,50)#|#MAPIN#|">
				
				<CFIF  PAN_NO nEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##PAN_NO#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|">	
				</CFIF>
				
			
				<CFIF CLIENT_NATURE EQ "I">
					<CFSET FINALSTRING = "#FINALSTRING##RegistrationNumber#|#RegistrationAuthority#|#PlaceOfReg#|#DateofReg#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||">	
				</CFIF>
				
				
				<CFIF PAN_NO EQ "" AND PASSPORT_NO NEQ "" AND PASSPORT_ISSUED_PLACE NEQ "" AND Pass_Issue_Date NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING#|#PASSPORT_NO#|#PASSPORT_ISSUED_PLACE#|#Pass_Issue_Date#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||">	
				</CFIF>
				
				<CFIF PAN_NO EQ "" AND DRIVING_LICENSE NEQ "" AND DRIVING_LICENSE_ISSUED_PLACE NEQ "" AND DRIVING_LICENSE_ISSUED_DATE NEQ "" >
					<CFSET FINALSTRING = "#FINALSTRING##DRIVING_LICENSE#|#DRIVING_LICENSE_ISSUED_PLACE#|#DRIVING_LICENSE_ISSUED_DATE#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
				
				<CFIF PAN_NO EQ "" AND VOTERS_ID_CARD NEQ "" AND Place_Issue_Vouter_ID NEQ "" AND VOTERS_ID_CARD_ISSUED_DATE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##VOTERS_ID_CARD#|#Place_Issue_Vouter_ID#|#VOTERS_ID_CARD_ISSUED_DATE#">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||">	
				</CFIF>
				
				<CFIF PAN_NO EQ "" AND RATIONCARD NEQ "" AND RATIONCARD_ISSUED_PLACE NEQ "" AND RATIONCARD_EXPIRY_DATE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##RATIONCARD#|#RATIONCARD_ISSUED_PLACE#|#RATIONCARD_EXPIRY_DATE#|">
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#|||">	
				</CFIF>
					
				<CFIF  Bank_name NEQ "" AND Bank_Add NEQ ""  AND CLIENTBANKCODE NEQ "" AND BANKTYPE NEQ "">
					<CFSET FINALSTRING = "#FINALSTRING##Bank_name#|#Bank_Add#|#BANKTYPE#|#CLIENTBANKCODE#|">	
				<CFELSE>
					<CFSET FINALSTRING = "#FINALSTRING#||||"><!--- #FINALSTRING#|N|||| --->		
				</CFIF>
					
					<CFSET FINALSTRING = "#FINALSTRING##DEPOSITORY#|#DPNAME#|#CLIENT_DP_CODE#|">
					<CFSET FINALSTRING = "#FINALSTRING#|#INTRODUCER_NAME#||#BIRTHDATE#|#Reg_Date#|N|Y#CHR(10)#"><!--- #FINALSTRING#||N|||N||| --->						
					<cfset FINALSTRINGLog = "#FINALSTRINGLog# #client_id# SucessFully generated #Chr(10)#">
				<CFELSE>
					<CFSET FINALSTRINGLog = "#FINALSTRINGLOG##client_id# Pan Or Birthe Date is Missing #Chr(10)#">	
				</CFIF>		
				
			</CFIF>
		</CFLOOP>
		
		<cfif UpdateRow eq 0>
			<SCRIPT>
				alert("Sorry No Client Register On #Reg_date#");
				history.back();
			</SCRIPT>				
		<CFELSE>
			<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING#" ADDNEWLINE="YES">
			<CFFILE ACTION="APPEND" FILE="#FilenameLog#" OUTPUT="#FINALSTRINGLog#" ADDNEWLINE="YES">
			<DIV ALIGN="CENTER" CLASS="FOOTER">
				<br><br>FILE GENERATED On Server's  <A target="blank" HREF="FILE:\\#Server_NAme#\#Replace(FileName,":","")#">#FileName#.</A><BR>
					Log FILE GENERATED On Server's  <A target="blank" HREF="FILE:\\#Server_NAme#\#Replace(FilenameLog,":","")#">#FilenameLog#.</a><BR>
					Please Refer Log File.	<BR>
				<A HREF="javascript: history.back(-1)">Back</A>
			</DIV>			
	
			<cfset ClientFileName  = "C:\UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt">
			<cfset ClientFileNameLog  = "C:\Log_UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt">
			
			<CFSET	ClientFileGenerated	=	CopyFile("#FILENAME#","#ClientFileName#")>
			<CFSET	ClientFileGenerated1	=	CopyFile("#FilenameLog#","#ClientFileNameLog#")>
			
			<CFIF  ClientFileGenerated>
				<SCRIPT>
					alert("File Generated On Client Machine #ClientFileName#");
				</SCRIPT>
			</CFIF>
			
			<CFIF ClientFileGenerated1>
				<SCRIPT>
					alert("Log File Generated on Client Machine #ClientFileNameLog#");
				</SCRIPT>
			</CFIF>
		</CFIF>
	
</CFOUTPUT>
</BODY>
</HTML>
