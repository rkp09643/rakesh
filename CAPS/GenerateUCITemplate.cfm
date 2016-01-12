
<CFOUTPUT QUERY="getClientDetails" group="CLIENT_ID" groupcasesensitive="no">
	<CFSET ERRORCODE = 0>
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
				<CFSET CLIENT_NAME					=		"#TRIM(GetClientDetails.CLIENTFULLNAME)#">
				<CFIF TRIM(GetClientDetails.CLIENTFULLNAME) eq ''>
					<CFSET CLIENT_NAME				=		"#GetClientDetails.client_name#">
				</CFIF>
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
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'FVCF'>
					<CFSET CATEGORY1				=		"14">							
				<CFELSEIF 	GetClientDetails.CATEGORY EQ 'PMS'>
					<CFSET CATEGORY1				=		"15">				
				</CFIF>

				<CFSET Add1="#LEFT(GetToken(GetClientDetails.RESI_ADDRESS,1,'~'),255)#">
				<CFSET Add2="#MID(GetToken(GetClientDetails.RESI_ADDRESS,1,'~'),256,100)# #LEFT(GetToken(GetClientDetails.RESI_ADDRESS,2,'~'),155)#">
				<CFSET Add3="#MID(GetToken(GetClientDetails.RESI_ADDRESS,2,'~'),156,256)#">
				<CFSET RESI_ADDRESS1	 			= 	"#Add1##Add2##GetToken(Add3,1,'-')#">
				<!--- <CFIF RESI_ADDRESS1 eq "">
					<CFSET RESI_ADDRESS1			= 	"#REPLACE(GetClientDetails.RESI_ADDRESS,'~',' ','ALL')#">
				</CFIF>
				  --->
				<CFSET PINCODE		 				= 	"#GetClientDetails.Pin_Code#">	
				<CFSET RESI_TEL_NO1	 				= 	"#TRIM(LEFT(GetClientDetails.RESI_TEL_NO,25))#">
				
					
				<CFSET BIRTHDATE	 				= 	"#DateFormat(GetClientDetails.BIRTH_DATE1,'DD-MMM-YYYY')#">
			
				<CFIF LEN(GetClientDetails.AGREEMENT_DATE) GT 0>					
					<CFSET AGREEMENT_DATE1			 	= 	"#DATEFORMAT(GetClientDetails.AGREEMENT_DATE,"DD-MMM-YYYY")#">	
				<CFELSE>					
					<CFSET AGREEMENT_DATE1			 	= 	"#DATEFORMAT(GetClientDetails.REGISTRATION_DATE,"DD-MMM-YYYY")#">		
				</CFIF>
				
				<CFSET INTRODUCER_NAME = "#Trim(GetClientDetails.INTRODUCER_NAME)#">
				<CFSET RELWITHINT		= "">
				<CFSET INTRODUCER_ACC_CODE = "">
				
				<!--- New Field added Here --->
				<CFSET EMAILID = "#LEFT(Trim(GetClientDetails.CLIENT_ID_MAIL),60)#">
				<CFSET  CITY = "#Trim(GetClientDetails.R_CITY)#">
				<CFSET  STATE = "#Trim(GetClientDetails.R_STATE)#">
				<CFSET  COUNTRY = "#Trim(GetClientDetails.R_COUNTRY)#">
				<CFSET  ISDCODE = "#Trim(GetClientDetails.ISD_CODE)#">
				
				<CFSET Bank_name				= 	"#LEFT(TRIM(GETBANKDETAILS.Bank_Name),60)#">
				<CFSET Bank_Add					= 	"#LEFT(TRIM(GETBANKDETAILS.Bank_Address),225)#">
				<CFSET TYPE						=	"#TRIM(GETBANKDETAILS.BANK_ACCTYPE)#">
				
				<CFIF TYPE EQ "SAVING">
					<CFSET BANKTYPE 			= 	10>
				<CFELSEIF TYPE EQ "CURRENT">
					<CFSET BANKTYPE 			= 	11>
				<CFELSE>
					<CFSET BANKTYPE 			= 	99>
				</CFIF>
				
				<CFSET CLIENTBANKCODE 			= 	"#LEFT(TRIM(GETBANKDETAILS.Bank_AcNo),25)#">
				<CFSET DP_ID1					=	"#LEFT(TRIM(GetclientDpDetails.DP_ID),25)#">
				<CFSET DEPOSITORY1				=	"#LEFT(TRIM(GetclientDpDetails.DEPOSITORY),4)#">
				<CFSET CLIENT_DP_CODE1 			= 	"#LEFT(TRIM(GetclientDpDetails.CLIENT_DP_CODE),16)#">
				<CFSET OTHERACCOUNT				=	"">
				<CFSET SETTLEMENTMODE			=	"">
				<CFSET CLIENTOTH				=	"">
				<CFSET FLAG						=	"E">
				<CFSET FINALSTRING = "">
				<CFIF LEN(MAPIN) NEQ 9 >
					<CFSET MAPIN="">
				</CFIF>
				
				<cfoutput>
					<CFSET FINALSTRING = "#FINALSTRING##SEGMENT#|#CLIENTID#|#CLIENT_NAME#|#CATEGORY1#|#PAN_NO1#|#EMAILID#|#ADD1#|#ADD2#|#ADD3#|#CITY#|#STATE#|#COUNTRY#|#PINCODE#|#ISDCODE#|#STD_CODE#|#RESI_TEL_NO1#|#MOBILE_NO#">
					
					<CFIF RESI_TEL_NO1 EQ "" AND (MOBILE_NO EQ "" OR LEN(MOBILE_NO) LTE 9 OR LEN(MOBILE_NO) GTE 11)>
						<CFSET ERRORCODE  = 1>
					</CFIF>
					<CFIF  len(GetClientDetails.PAN_NO) neq 10>
						<CFSET ERRORCODE  = 2>
					</CFIF>
					
					<cfif ADD1 eq Add2 and Add2 eq Add3 and Add3 eq Add1>
						<CFSET ERRORCODE  = 4>
					</cfif>
					
					<cfif CLIENT_NAME eq Contact_Person1 and Contact_Person2 eq Contact_Person1 and Contact_Person2 eq Contact_Person3 and Contact_Person3 eq Contact_Person1 and Contact_Person3 eq client_name>
						<CFSET ERRORCODE  = 5>
					</cfif>
					
					<cfif CATEGORY1 eq 1 or CATEGORY1 eq 11>
						<CFSET FINALSTRING = "#FINALSTRING#|#BIRTHDATE#|#AGREEMENT_DATE1#">
					<cfelse>
						<CFSET FINALSTRING = "#FINALSTRING#|#Date_of_INCORPORATION#|#AGREEMENT_DATE1#">	
					</cfif>
					
					<CFIF (CATEGORY1 NEQ '1' OR CATEGORY1 NEQ '11')  AND REGISTRATION_NO NEQ "" AND REGISTRATION_AUTHORITY NEQ "" AND REGISTRATION_PLACE NEQ "" AND REGISTRATION_DATE1 NEQ "">
						<CFSET FINALSTRING	   = "#FINALSTRING#|#REGISTRATION_NO#|#REGISTRATION_AUTHORITY#|#REGISTRATION_PLACE#|#REGISTRATION_DATE1#">
					<CFELSE>
						<CFSET FINALSTRING	   = "#FINALSTRING#||||">
					</CFIF>
					
					<cfset countspace = 0>
					<cfloop index="i"  list="#Bank_Add#" delimiters=" ">
						<cfset countspace = countspace + 1>
					</cfloop>
					
					<cfif countspace lt 3>
						<CFSET ERRORCODE  = 6>
					</cfif>


					<CFIF Bank_Name NEQ "" AND Bank_Add NEQ "" AND CLIENTBANKCODE NEQ ""  AND BANKTYPE NEQ '' >
						<CFSET FINALSTRING = "#FINALSTRING#|#Bank_name#|#Bank_Add#|#BANKTYPE#|#CLIENTBANKCODE#">	
					<CFELSE>
						<CFSET FINALSTRING = "#FINALSTRING#||||">
					</CFIF>
					
					<CFIF COCD NEQ "CD_NSE">	
						<CFIF  DP_ID1 NEQ "" AND DEPOSITORY1 NEQ "" AND CLIENT_DP_CODE1 NEQ "" >
							<CFSET FINALSTRING = "#FINALSTRING#|#DP_ID1#|#DEPOSITORY1#|#CLIENT_DP_CODE1#">	
						<CFELSE>
							<CFSET FINALSTRING = "#FINALSTRING#|||">
						</CFIF>
					</cfiF>
					
					<CFIF PAN_NO1 EQ "PAN_EXEMPT">
						<CFIF PASSPORT_NO NEQ "" AND PASSPORT_ISSUED_PLACE NEQ "" AND Pass_Issue_Date NEQ "">
							<CFSET FINALSTRING = "#FINALSTRING#|2|#PASSPORT_NO1#|#PASSPORT_ISSUED_PLACE1#|#Pass_Issue_Date#">
						<CFELSEIF VOTERS_ID_CARD NEQ "" AND Place_Issue_Vouter_ID NEQ "" AND VOTERS_ID_CARD_ISSUED_DATE NEQ "">
							<CFSET FINALSTRING = "#FINALSTRING#|3|#VOTERS_ID_CARD1#|#Place_Issue_Vouter_ID1#|#VOTERS_ID_CARD_ISSUED_DATE#">	
						<CFELSEIF DRIVING_LICENSE NEQ "" AND DRIVING_LICENSE_ISSUED_PLACE NEQ "" AND DRIVING_LICENSE_ISSUED_DATE NEQ "" >
							<CFSET FINALSTRING = "#FINALSTRING#|4|#DRIVING_LICENSE1#|#DRIVING_LICENSE_ISSUED_PLACE1#|#DRIVING_LICENSE_ISSUED_DATE#">
						<CFELSEIF RATIONCARD NEQ "" AND RATIONCARD_ISSUED_PLACE NEQ "" AND RATIONCARD_EXPIRY_DATE NEQ "">
							<CFSET FINALSTRING = "#FINALSTRING#|5|#RATIONCARD1#|#RATIONCARD_ISSUED_PLACE1#|#RATIONCARD_EXPIRY_DATE#">	
						<CFELSEIF MAPIN NEQ "">
							<CFSET FINALSTRING = "#FINALSTRING#|1|#MAPIN#||">
						<CFELSEIF REGISTRATION_NO NEQ "" AND REGISTRATION_PLACE NEQ "" AND REGISTRATION_DATE1 NEQ "">
							<CFSET FINALSTRING	   = "#FINALSTRING#|6|#REGISTRATION_NO#|#REGISTRATION_PLACE#|#REGISTRATION_DATE1#">
						<cfelse>
							<CFSET FINALSTRING = "#FINALSTRING#||||">
						</CFIF>
					<cfelse>	
						<CFSET FINALSTRING = "#FINALSTRING#||||">	
					</CFIF>
					
								
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
							
							<CFIF Contact_Person1 NEQ "" AND DESIGNATIONPERSON1 NEQ "" AND PanNo_Person1 NEQ "" AND Address_Person1 NEQ "" AND TelNo_Person1 NEQ "" AND EmailId_Person1 NEQ "">					
								<CFSET FINALSTRING = "#FINALSTRING#|#Contact_Person1#|#DESIGNATIONPERSON1#|#PanNo_Person1#|#Address_Person1#|#TelNo_Person1#|#EmailId_Person1#">
							<cfelse>
								<CFSET FINALSTRING = "#FINALSTRING#||||||">	
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
							
							<CFIF Contact_Person1 NEQ "" AND DESIGNATIONPERSON1  NEQ "" AND PanNo_Person1 NEQ "" AND Address_Person1 NEQ "" AND TelNo_Person1 NEQ "" AND EmailId_Person1 NEQ "">					
								<CFSET FINALSTRING = "#FINALSTRING#|#Contact_Person1#|#DESIGNATIONPERSON1#|#PanNo_Person1#|#Address_Person1#|#TelNo_Person1#|#EmailId_Person1#">
							<cfelse>
								<CFSET FINALSTRING = "#FINALSTRING#||||||">
							</CFIF>	
						</CFIF>
						
						<CFIF CATEGORY1 NEQ 3>
							
							<CFIF CATEGORY1 EQ 2>
								<CFSET DESIGNATIONPERSON2 = "PARTNER">
							<cfelseIF CATEGORY1 EQ 3>
								<CFSET DESIGNATIONPERSON2 = "KARTA">
							<cfelseIF CATEGORY1 EQ 5>
								<CFSET DESIGNATIONPERSON2 = "TRUSTEE">	
							<cfelse>
								<CFSET DESIGNATIONPERSON2 = "#Designation_Person2#">		
							</CFIF>
							
							<CFIF Contact_Person2 NEQ "" AND DESIGNATIONPERSON2 NEQ "" AND PanNo_Person2 NEQ "" AND Address_Person2 NEQ "" AND TelNo_Person2 NEQ "" AND EmailId_Person2 NEQ "">					
								<CFSET FINALSTRING = "#FINALSTRING#|#Contact_Person2#|#DESIGNATIONPERSON2#|#PanNo_Person2#|#Address_Person2#|#TelNo_Person2#|#EmailId_Person2#">
							<cfelse>
								<CFSET FINALSTRING = "#FINALSTRING#||||||">
							</CFIF>	
						<cfelse>					
							<CFSET FINALSTRING = "#FINALSTRING#||||||">	
						</CFIF>
						
						<CFIF CATEGORY1 NEQ 3>
							
							<CFIF CATEGORY1 EQ 2>
								<CFSET DESIGNATIONPERSON3 = "PARTNER">
							<cfelseIF CATEGORY1 EQ 3>
								<CFSET DESIGNATIONPERSON3 = "KARTA">
							<cfelseIF CATEGORY1 EQ 5>
								<CFSET DESIGNATIONPERSON3 = "TRUSTEE">	
							<cfelse>
								<CFSET DESIGNATIONPERSON3 = "#Designation_Person3#">		
							</CFIF>
							
							<CFIF Contact_Person3 NEQ "" AND DESIGNATIONPERSON3 NEQ "" AND PanNo_Person3 NEQ "" AND Address_Person3 NEQ "" AND TelNo_Person3 NEQ "" AND EmailId_Person3 NEQ "">					
								<CFSET FINALSTRING = "#FINALSTRING#|#Contact_Person3#|#DESIGNATIONPERSON3#|#PanNo_Person3#|#Address_Person3#|#TelNo_Person3#|#EmailId_Person3#">
							<cfelse>
								<CFSET FINALSTRING = "#FINALSTRING#||||||">
							</CFIF>	
						<cfelse>
							<CFSET FINALSTRING = "#FINALSTRING#||||||">	
						</CFIF>						
					<cfELSE>
						<CFSET FINALSTRING = "#FINALSTRING#||||||||||||||||||">		
					</CFIF>
					
					<CFIF CATEGORY1 EQ 2 OR CATEGORY1 EQ 4 OR CATEGORY1 EQ 5>
						<CFIF (Contact_Person1 EQ "" AND DESIGNATIONPERSON1 EQ "" AND PanNo_Person1 EQ "" AND Address_Person1 EQ "" AND TelNo_Person1 EQ "" AND EmailId_Person1 EQ "")
						AND (Contact_Person2 EQ "" AND DESIGNATIONPERSON2 EQ "" AND PanNo_Person2 EQ "" AND Address_Person2 EQ "" AND TelNo_Person2 EQ "" AND EmailId_Person2 EQ "")
						AND (Contact_Person3 EQ "" AND DESIGNATIONPERSON3 EQ "" AND PanNo_Person3 EQ "" AND Address_Person3 EQ "" AND TelNo_Person3 EQ "" AND EmailId_Person3 EQ "")>
							<CFSET ERRORCODE  = 3>
						</CFIF>
					</CFIF>
					
					<CFSET FINALSTRING = "#FINALSTRING#|#trim(Person_verify)#|#FLAG#">
					<CFSET FINALSTRING = "#FINALSTRING##CHR(10)#">
				</cfoutput>
				
				<CFIF ERRORCODE EQ 1>
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
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Bank Address Should be Greater then 3 Words.#chr(10)#">				
				<cfelseif ERRORCODE EQ 10>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Insert First Contact Person Data.#chr(10)#">	
				<cfelse>
					<CFSET FINALSTRINGLOG = "For #CLIENT_ID# : Generated SucessFully.#chr(10)#">		
				</CFIF>
				
				<cfif len(FINALSTRINGLOG) gt 0>
					<CFFILE ACTION="APPEND" FILE="#FILENAMELOG#" OUTPUT="#FINALSTRINGLOG#" ADDNEWLINE="Yes">
				</cfif>
				
				<cfif ERRORCODE EQ 0 and len(FINALSTRING) gt 0>
					<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING#" ADDNEWLINE="No">		
				</cfif>
				
</CFOUTPUT>