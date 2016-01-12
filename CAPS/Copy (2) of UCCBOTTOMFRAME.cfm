
<HTML>
<HEAD>
<TITLE>UCI File Generation</TITLE>

	<!-- <link href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet"> -->
<!--- 	<link href="../../CSS/Bill.css" type="text/css" rel="stylesheet"> --->
<LINK href="../../CSS/style.css" rel="stylesheet" type="text/css">
	<SCRIPT SRC="../../Scripts/ScrollTable.js"></SCRIPT>
</HEAD>
<script>
	function AllSelect(frm)
	{
		with(frm)
		{

			var totalbranch,i,j,k;
			totalbranch = Sr.value;
			for(i=1;i<totalbranch;i++)
			{
				if(eval("chk"+i).checked == false)
				{
					eval("chk"+i).checked = true;
				}
				else
				{
					eval("chk"+i).checked = false;
				}
			}
		}
	}	
</script>

<BODY topmargin="0">
<CENTER>
<cfoutput>
<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">

	
	<CFIF isdefined("CmdGenerate")>
		
		<CFIF Format eq "Old">			
			<!--- <CFQUERY NAME="GetClientId" datasource="#Client.database#">
				Select DISTINCT client_id,CLIENT_NATURE,FIRST_NAME,MIDDLE_NAME,LAST_NAME
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
				<!--- <SCRIPT>
					alert("#Market#");
				</SCRIPT> --->
				<CFIF Market eq "CAPS">
					<CFSET SEGMENT = "CASH">
				<CFELSE>
					<CFSET SEGMENT = "DERV">
				</CFIF>		
				<CFSET CATAGORY = "I">
				<CFIF not directoryexists("C:\WEBXUCC\")>
					<CFDIRECTORY ACTION="CREATE" DIRECTORY="C:\WEBXUCC\">
				</CFIF>
				<CFSET Filename = "C:\WEBXUCC\#EXCHANGE#_UCC_#DateFormat(Now(),"DDMMYYYY")#_#TimeFormat(Now(),"HHMMSS")#.txt">
				<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="" ADDNEWLINE="NO">
				<CFSET FINALSTRING = "">
				<CFSET UpdateRow	=	0>
				<!--- <CFLOOP QUERY="GetClientId">		 --->	
				<CFLOOP INDEX="i" FROM="1" TO="#Sr#">
				
				<CFIF IsDefined("chk#i#")>
					<CFSET	Client_ID	=	Trim(Evaluate("chk#i#"))><!--- " VALUE="#Client_id#" CLASS="StyleCheckBox"> --->
					<CFSET UpdateRow	=	IncrementValue(UpdateRow)>
					
					<CFQUERY NAME="GetClientDetails" datasource="#Client.database#">
						SELECT ISNULL(Father_Husband_Name,'') Father_Husband_Name ,ISNULL(RESI_ADDRESS,'') RESI_ADDRESS,
						ISNULL(City,'') CITY,ISNULL(State,'') STATE,ISNULL(Country,'') Country,Pin_Code,
						RESI_TEL_NO,RESI_FAX_NO,
						ISNULL(OFF_ADDRESS,'')OFF_ADDRESS ,OFF_TEL_NO,OFF_FAX_NO,
						ISNULL(EMAIL_ID,'')EMAIL_ID, BIRTH_DATE,
						ISNULL(QUALIFICATION,'')QUALIFICATION,ISNULL(OCCUPATION,'')OCCUPATION,ISNULL(INTRODUCER_NAME,'')INTRODUCER_NAME,
						ISNULL(Rel_With_Introducer,'')Rel_With_Introducer,ISNULL(INTRODUCER_ACC_CODE,'')INTRODUCER_ACC_CODE,
						ISNULL(MAPIN,'') MAPIN,ISNULL(PAN_NO,'') PAN_NO,
						ISNULL(PASSPORT_NO,'')PASSPORT_NO,PASSPORT_EXPIRY_DATE,
						ISNULL(PASSPORT_ISSUED_PLACE,'')PASSPORT_ISSUED_PLACE,Pass_Issue_Date,
						ISNULL(DRIVING_LICENSE,'')DRIVING_LICENSE,ISNULL(DRIVING_LICENSE_ISSUED_PLACE,'')DRIVING_LICENSE_ISSUED_PLACE,
						DRIVING_LICENSE_ISSUED_DATE,Dr_Lic_Exp_Date,
						ISNULL(VOTERS_ID_CARD,'')VOTERS_ID_CARD,ISNULL(Place_Issue_Vouter_ID,'')Place_Issue_Vouter_ID,
						VOTERS_ID_CARD_ISSUED_DATE,
						ISNULL(RATIONCARD,'')RATIONCARD,ISNULL(RATIONCARD_ISSUED_PLACE,'')RATIONCARD_ISSUED_PLACE,RATIONCARD_EXPIRY_DATE,isnull(category,'')category
						FROM CLIENT_DETAILS
						WHERE
							CLIENT_ID = '#client_id#'
					</CFQUERY>
					
					<cfquery name="GetDataMaster" datasource="#Client.database#">
						Select Client_Nature,First_Name,Middle_Name,Last_Name,CONVERT(VARCHAR(10),Registration_Date,103) Registration_Date,
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
					<cfset Reg_Date = '#GetDataMaster.Registration_Date#'>
					
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
										And Default_Ac = 'Y'	
									</CFQUERY>
									
									
									
									<CFSET FATHERHUSNAME = "#GetClientDetails.Father_Husband_Name#">
									<CFSET RESI_ADD1 	 = "#GETTOKEN(GetClientDetails.RESI_ADDRESS,1,'~')#">	
									<CFSET RESI_ADD2 	 = "#GETTOKEN(GetClientDetails.RESI_ADDRESS,2,'~')#">				
									<CFSET CITY			 = "#GetClientDetails.City#">	
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
									<CFSET category      =  "#LEFT(TRIM(GetClientDetails.category),50)#">
									<Cfif category eq 'TS'>
										<Cfset category ='NT'>
									</Cfif>
									<CFIF trim(category) is "I">
										<CFSET BIRTHDATE	 = "#GetClientDetails.BIRTH_DATE#">
									<CFELSE>
										<CFSET BIRTHDATE	 = "">
									</CFIF>
									<CFSET QUALIFCATIN	 = "#LEFT(TRIM(GetClientDetails.QUALIFICATION),25)#">
									<CFSET OCCUPATION	 = "#LEFT(TRIM(GetClientDetails.OCCUPATION),25)#">
									<!--- <CFSET INTRODUCER_NAME1 = "#GETTOKEN(GetClientDetails.INTRODUCER_NAME,1," ")#">
									<CFSET INTRODUCER_NAME2 = "#GETTOKEN(GetClientDetails.INTRODUCER_NAME,2," ")#">
									<CFSET INTRODUCER_NAME3 = "#GETTOKEN(GetClientDetails.INTRODUCER_NAME,3," ")#">
									<CFSET RELWITHINT		= "#LEFT(TRIM(GetClientDetails.Rel_With_Introducer),25)#">
									<CFSET INTRODUCER_ACC_CODE = "#LEFT(TRIM(GetClientDetails.INTRODUCER_ACC_CODE),12)#"> --->
									<CFSET INTRODUCER_NAME1 = "">
									<CFSET INTRODUCER_NAME2 = "">
									<CFSET INTRODUCER_NAME3 = "">
									<CFSET RELWITHINT		= "">
									<CFSET INTRODUCER_ACC_CODE = "">
									<CFSET MAPIN = "#LEFT(TRIM(GetClientDetails.MAPIN),9)#">
									<CFSET PAN_NO = "#LEFT(TRIM(GetClientDetails.PAN_NO),10)#">
									<CFSET PASSPORT_NO = "#LEFT(TRIM(GetClientDetails.PASSPORT_NO),25)#">
									<CFSET PASSPORT_EXPIRY_DATE = "#DateFormat(GetClientDetails.PASSPORT_EXPIRY_DATE,"dd-mm-yyyy")#">
									<CFSET PASSPORT_ISSUED_PLACE = "#LEFT(TRIM(GetClientDetails.PASSPORT_ISSUED_PLACE),25)#">
									<CFSET Pass_Issue_Date = "#Dateformat(GetClientDetails.Pass_Issue_Date,"dd-mm-yyyy")#">
									<CFSET DRIVING_LICENSE = "#LEFT(TRIM(GetClientDetails.DRIVING_LICENSE),25)#">
									<CFSET DRIVING_LICENSE_ISSUED_PLACE = "#LEFT(TRIM(GetClientDetails.DRIVING_LICENSE_ISSUED_PLACE),25)#">
									<CFSET DRIVING_LICENSE_ISSUED_DATE	= "#Dateformat(GetClientDetails.DRIVING_LICENSE_ISSUED_DATE,"dd-mm-yyyy")#">
									<CFSET Dr_Lic_Exp_Date = "#Dateformat(GetClientDetails.Dr_Lic_Exp_Date,"dd-mm-yyyy")#">
									<CFSET VOTERS_ID_CARD	= "#LEFT(TRIM(GetClientDetails.VOTERS_ID_CARD),25)#">
									<CFSET Place_Issue_Vouter_ID = "#LEFT(TRIM(GetClientDetails.Place_Issue_Vouter_ID),25)#">
									<CFSET VOTERS_ID_CARD_ISSUED_DATE = "#Dateformat(GetClientDetails.VOTERS_ID_CARD_ISSUED_DATE,"dd-mm-yyyy")#">
									<CFSET RATIONCARD = "#LEFT(TRIM(GetClientDetails.RATIONCARD),25)#">
									<CFSET RATIONCARD_ISSUED_PLACE = "#LEFT(TRIM(GetClientDetails.RATIONCARD_ISSUED_PLACE),25)#">
									<CFSET RATIONCARD_EXPIRY_DATE = "#DATEFORMAT(GetClientDetails.RATIONCARD_EXPIRY_DATE,"DD-MM-YYYY")#">
									<CFSET DEPOSITORY	=	"#LEFT(TRIM(GetclientDpDetails.DEPOSITORY),4)#">
									<CFSET DPNAME		=	"#LEFT(TRIM(GetclientDpDetails.DP_NAME),25)#">
									<CFSET CLIENT_DP_CODE  = "#LEFT(TRIM(GetclientDpDetails.CLIENT_DP_CODE),16)#">
									<CFSET Bank_name	= "#LEFT(TRIM(GETBANKDETAILS.Bank_Name),60)#">
									<CFSET Bank_Add		= "#LEFT(TRIM(GETBANKDETAILS.Bank_Address),225)#">
									<CFSET MICR			= "#LEFT(TRIM(GETBANKDETAILS.Micr_Code),9)#">
									<CFSET DateOfReg	= "#trim(dateformat(GETBANKDETAILS.ACC_OPEN_DATE,"DD-MM-YYYY"))#">
									<CFSET CLIENTBANKCODE = "#LEFT(TRIM(GETBANKDETAILS.Bank_AcNo),25)#">
									<CFSET TYPE	=	"#TRIM(GETBANKDETAILS.BANK_ACCTYPE)#">
									<CFIF TYPE EQ "SAVING">
										<CFSET BANKTYPE = 10>
									<CFELSEIF TYPE EQ "CURRENT">
										<CFSET BANKTYPE = 11>
									<CFELSE>
										<CFSET BANKTYPE = 99>
									</CFIF>
									
									
									<CFSET FINALSTRING = "#FINALSTRING#">			
									<CFSET FINALSTRING = "#FINALSTRING##BrkWebXId#|#BranchWebXid#|#SubBrkWebXId#|#SEGMENT#">
									
									
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
									<CFSET FINALSTRING = "#FINALSTRING#|#STATUS#|#CATAGORY#">
									<CFIF SEGMENT EQ "CASH">
										<CFSET UCCFORCASH = "#client_id#">
										<CFSET UCCFORDERV = "">	
									<CFELSE>
										<CFSET UCCFORDERV = "#client_id#">	
										<CFSET UCCFORCASH = "">
									</CFIF>
									
									<CFSET LASTNAME = "#left(LAST_NAME,30)#">
									<CFSET FIRSTNAME = "#left(FIRST_NAME,30)#">
									<CFSET MIDDLENAME = "#left(MIDDLE_NAME,30)#">
									
									<CFSET FINALSTRING = "#FINALSTRING#|#UCCFORCASH#|#UCCFORDERV#|#LASTNAME#|#FIRSTNAME#|#MIDDLENAME#|#left(trim(FATHERHUSNAME),60)#">
									<CFSET FINALSTRING = "#FINALSTRING#||">
									<CFIF RESI_ADD1 NEQ "" OR RESI_ADD2 NEQ "">
										<CFSET FINALSTRING = "#FINALSTRING#|#LEFT(TRIM(RESI_ADD1),50)#|#LEFT(TRIM(RESI_ADD2),50)#">
									<CFELSE>
										<CFSET FINALSTRING = "#FINALSTRING#||">	
									</CFIF>
									
									<CFSET FINALSTRING = "#FINALSTRING#|#LEFT(CITY,25)#|#LEFT(State,25)#|#LEFT(Country,25)#|#TRIM(LEFT(PINCODE,10))#">
									
									<CFIF RESI_TEL_NO NEQ "">
										<CFSET FINALSTRING = "#FINALSTRING#|#RESI_TEL_NO#">
									<CFELSE>
										<CFSET FINALSTRING = "#FINALSTRING#|#OFF_TEL#">	
									</CFIF>
									
									<CFIF RESI_FAX NEQ "">
										<CFSET FINALSTRING = "#FINALSTRING#|#RESI_FAX#">	
									<CFELSE>
										<CFSET FINALSTRING = "#FINALSTRING#|#OFF_FAX#">	
									</CFIF>
									
									<CFSET FINALSTRING = "#FINALSTRING#|#EMAIL#|#Dateformat(BIRTHDATE,"dd-mm-yyyy")#|#QUALIFCATIN#|#OCCUPATION#|#DateFormat(Dateformat(Reg_date,"dd-mm-yyyy"),"dd-mm-yyyy")#|#INTRODUCER_NAME1#|#INTRODUCER_NAME3#|#INTRODUCER_NAME2#|#RELWITHINT#|#INTRODUCER_ACC_CODE#|#MAPIN#">
									
									<CFIF  PAN_NO nEQ "">
										<CFSET FINALSTRING = "#FINALSTRING#|#PAN_NO#|N">
									<CFELSE>
										<CFSET FINALSTRING = "#FINALSTRING#||Y">	
									</CFIF>
									
									<CFIF PAN_NO EQ "" AND PASSPORT_NO NEQ "" AND PASSPORT_EXPIRY_DATE NEQ "" AND PASSPORT_ISSUED_PLACE NEQ "" AND Pass_Issue_Date NEQ "">
										<CFSET FINALSTRING = "#FINALSTRING#|#PASSPORT_NO#|#PASSPORT_ISSUED_PLACE#|#Pass_Issue_Date#|#PASSPORT_EXPIRY_DATE#">
									<CFELSE>
										<CFSET FINALSTRING = "#FINALSTRING#||||">	
									</CFIF>
									
									<CFIF PAN_NO EQ "" AND DRIVING_LICENSE NEQ "" AND DRIVING_LICENSE_ISSUED_PLACE NEQ "" AND DRIVING_LICENSE_ISSUED_DATE NEQ "" AND Dr_Lic_Exp_Date NEQ "">
										<CFSET FINALSTRING = "#FINALSTRING#|#DRIVING_LICENSE#|#DRIVING_LICENSE_ISSUED_PLACE#|#DRIVING_LICENSE_ISSUED_DATE#|#Dr_Lic_Exp_Date#">
									<CFELSE>
										<CFSET FINALSTRING = "#FINALSTRING#||||">	
									</CFIF>
									
									<CFIF PAN_NO EQ "" AND VOTERS_ID_CARD NEQ "" AND Place_Issue_Vouter_ID NEQ "" AND VOTERS_ID_CARD_ISSUED_DATE NEQ "">
										<CFSET FINALSTRING = "#FINALSTRING#|#VOTERS_ID_CARD#|#Place_Issue_Vouter_ID#|#VOTERS_ID_CARD_ISSUED_DATE#">
									<CFELSE>
										<CFSET FINALSTRING = "#FINALSTRING#|||">	
									</CFIF>
									
									<CFIF PAN_NO EQ "" AND RATIONCARD NEQ "" AND RATIONCARD_ISSUED_PLACE NEQ "" AND RATIONCARD_EXPIRY_DATE NEQ "">
										<CFSET FINALSTRING = "#FINALSTRING#|#RATIONCARD#|#RATIONCARD_ISSUED_PLACE#|#RATIONCARD_EXPIRY_DATE#">
										<CFIF  Bank_name NEQ "" AND Bank_Add NEQ "" and MICR	NEQ "" AND CLIENTBANKCODE NEQ "" AND TYPE NEQ "">
											<CFSET FINALSTRING = "#FINALSTRING#|Y|#Bank_name#|#Bank_Add#|#MICR#|#BANKTYPE#|#CLIENTBANKCODE#">	
										<CFELSE>
											<CFSET FINALSTRING = "#FINALSTRING#||||||"><!--- #FINALSTRING#|N|||| --->		
										</CFIF>
										<CFSET FINALSTRING = "#FINALSTRING#|#DEPOSITORY#|#DPNAME#|#CLIENT_DP_CODE#">
										<CFSET FINALSTRING = "#FINALSTRING#||||#DateOfReg#||N|||N"><!--- #FINALSTRING#||N|||N||| --->
									<!--- 	<CFIF  Bank_name NEQ "" AND Bank_Add NEQ "" and MICR	NEQ "" AND 	DateOfReg	NEQ  "" AND CLIENTBANKCODE NEQ "" AND TYPE NEQ "">
											<CFSET FINALSTRING = "#FINALSTRING#|#CLIENTBANKCODE#|#BANKTYPE#">	
										<CFELSE>
											<CFSET FINALSTRING = "#FINALSTRING#||">		
										</CFIF> --->
										
									<CFELSE>
										<CFSET FINALSTRING = "#FINALSTRING#|||">	
										<CFSET FINALSTRING = "#FINALSTRING#||||||"><!--- #FINALSTRING#|N|||| --->
										<CFSET FINALSTRING = "#FINALSTRING#|#DEPOSITORY#|#DPNAME#|#CLIENT_DP_CODE#">
										<CFSET FINALSTRING = "#FINALSTRING#||||||N|||N">
										<!--- <CFSET FINALSTRING = "#FINALSTRING#||N|||N|||"><!--- #FINALSTRING#||N|||N||| --->
										<CFSET FINALSTRING = "#FINALSTRING#||">	 --->
										<!---<CFSET FINALSTRING = "#FINALSTRING#|NULL||">---->
									</CFIF>
													
									<CFSET FINALSTRING = "#FINALSTRING#|||||||||N||||#CHR(10)#">	

				</CFIF>
				</CFLOOP>
				
				<CFIF UpdateRow	EQ 0>
					<SCRIPT>
						alert("Please Select Atleast One Client");
						history.back();
					</SCRIPT>
				<CFELSE>
					<CFFILE ACTION="APPEND" FILE="#FILENAME#" OUTPUT="#FINALSTRING#" ADDNEWLINE="YES">
					<DIV ALIGN="CENTER" CLASS="FOOTER">
						<BR><BR>FILE GENERATED On Server's <A target="blank" HREF="FILE:\\#Server_NAme#\#Replace(FileName,":","")#">#FileName#.<br>
						<A HREF="javascript: history.back(-1)">Back</A>
					</DIV>			
				</CFIF>											
			<CFELSEif Format eq "New">
				<cfquery name="getsystemsettingsvalue" datasource="#client.database#">
					select ISNULL(UCCEXPORT_COMPULSORY,'N') UCCEXPORT_COMPULSORY
					FROM SYSTEM_SETTINGS
					WHERE
						COMPANY_CODE = '#COCD#'
				</cfquery>
				<CFIF getsystemsettingsvalue.UCCEXPORT_COMPULSORY EQ "Y">
					<CFINCLUDE TEMPLATE="NewUccWebXCOMP.cfm">
				<cfelse>
					<CFINCLUDE TEMPLATE="NewUccWebX.cfm">
				</CFIF>
			<cfelseif Format eq "New1">
				<cfquery name="getsystemsettingsvalue" datasource="#client.database#">
					select ISNULL(UCCEXPORT_COMPULSORY,'N') UCCEXPORT_COMPULSORY
					FROM SYSTEM_SETTINGS
					WHERE
						COMPANY_CODE = '#COCD#'
				</cfquery>
				
				<CFIF getsystemsettingsvalue.UCCEXPORT_COMPULSORY EQ "Y">
					<CFINCLUDE TEMPLATE="New1UccWebXCOMP.cfm">
				<cfelse>
					<CFINCLUDE TEMPLATE="New1UccWebX.cfm">
				</CFIF>
			<cfelseif Format eq "New2">
				<cfquery name="getsystemsettingsvalue" datasource="#client.database#">
					select ISNULL(UCCEXPORT_COMPULSORY,'N') UCCEXPORT_COMPULSORY
					FROM SYSTEM_SETTINGS
					WHERE
						COMPANY_CODE = '#COCD#'
				</cfquery>
				
				<CFIF getsystemsettingsvalue.UCCEXPORT_COMPULSORY EQ "Y">
					<CFINCLUDE TEMPLATE="New2UccWebXCOMP.cfm">
				<cfelse>
					<CFINCLUDE TEMPLATE="New2UccWebX.cfm">
				</CFIF>	
			</CFIF>
	</CFIF>	


<FORM NAME="frmUCI"   ACTION="UCCBOTTOMFRAME.cfm" METHOD="POST">



	<INPUT type="Hidden" name="COCD" value="#COCD#">
	<INPUT type="Hidden" name="COName" value="#COName#">
	<INPUT type="Hidden" name="Market" value="#Market#">
	<INPUT type="Hidden" name="Exchange" value="#Exchange#">
	<INPUT type="Hidden" name="Broker" value="#Broker#">
	<INPUT type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
	<INPUT type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
	<cfif ISDEFINED("Format1")>
		<input type="hidden" name="Format1" value="#Format1#">
	</cfif>

  	
<CFIF IsDefined('CmdView')>		
	
	<cfquery name="GetName" datasource="#Client.database#">
		select ltrim(rtrim(CHEKERUSERLIST)) CHEKERUSERLIST
			from system_settings
		where company_code = '#cocd#'
	</cfquery>
  <CFQUERY NAME="GETCLIENTLIST" datasource="#Client.database#" DBTYPE="ODBC">
 		Select DISTINCT client_id,client_name,CLIENT_NATURE,REGISTRATION_DATE,Last_Modified_date
		from client_master a
		Where
		Company_code = '#COCD#'
		<cfif Format1 eq "New">
			AND CONVERT(DATETIME,CONVERT(varchar(10),CONVERT(DATETIME,REGISTRATION_DATE,103),103),103) BETWEEN CONVERT(DATETIME,'#Reg_date#',103) AND CONVERT(DATETIME,'#Reg_date_TO#',103)
		<cfelse>
			<cFIF NOT IsDefined("Brokerage")>
				AND (CONVERT(DATETIME,CONVERT(varchar(10),CONVERT(DATETIME,REGISTRATION_DATE,103),103),103) BETWEEN CONVERT(DATETIME,'#Reg_date#',103) AND CONVERT(DATETIME,'#Reg_date_TO#',103)
						OR
					CONVERT(DATETIME, CONVERT(VarChar(10), LAST_MODIFIED_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#Reg_date#',103) and CONVERT(DATETIME,'#Reg_date_TO#',103) 
						)
			</cFIF>
		</cfif>
		<CFIF IsDefined("FromClient") and trim(FromClient) neq ''>
			and CLIENT_ID IN ('#Replace(FromClient,",","','","ALL")#')
		</CFIF>	
		<CFIF IsDefined("FromBranch") and trim(FromBranch) neq ''>
			and Branch_Code IN ('#Replace(FromBranch,",","','","ALL")#')
		</CFIF>	
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(CHEKING,'N') = 'Y'
		</cfif>		
		AND A.CLIENT_ID IN(SELECT DISTINCT CLIENT_ID FROM BROKERAGE_APPLY WHERE COMPANY_CODE=A.COMPANY_CODE AND ACTIVE_INACTIVE ='A' AND ISNULL(END_DATE ,'') = ''
		<cFIF IsDefined("Brokerage")>
			AND CONVERT(DATETIME, START_DATE, 103) BETWEEN CONVERT(DATETIME,'#Reg_date#',103) and CONVERT(DATETIME,'#Reg_date_TO#',103) 
		</cFIF>
		)
		Order by REGISTRATION_DATE Desc
  </CFQUERY>
</CFIF>    
  <CFIF IsDefined('CmdView')>
  <div align="left" style="position:absolute; overflow:auto; height:7%; top:0%; left:0%; ">
  <TABLE  WIDTH="98%" BORDER="0" ALIGN="center"  CELLPADDING="0" CELLSPACING="1" class="StyleReportParameterTable1">	
		<TR  bgcolor="E3F3A3">
		<TH width="5%">
			<INPUT TYPE="CHECKBOX" NAME="All"  onClick="AllSelect(frmUCI);">
		</TH>
			<TH width="10%">Client ID</TH>
			<TH width="15%">Client Name</TH>			
			<TH width="10%">Registration Date</TH>
			<TH NOWRAP width="10%">Modified Date</TH>
		</TR>		
	</table>
	</div>	
	<div align="left" style="position:absolute; overflow:auto; height:89%; top:5%; left:0%;">
	 <TABLE   WIDTH="100%" BORDER="0" ALIGN="center"  CELLPADDING="0" CELLSPACING="1">			
			<CFSET SR=1>
			<CFLOOP QUERY="GETCLIENTLIST">				
			<TR style="font-size:9px;font:"Trebuchet MS";" NOWRAP  bgcolor="E3F3A3">
				<TH width="5%">
					<INPUT TYPE="CHECKBOX" NAME="chk#SR#" VALUE="#Client_id#" CLASS="StyleCheckBox">
				</TH>				
				
				<TD ALIGN="LEFT" width="10%" > &nbsp;#Client_ID#</TD>
				<TD ALIGN="LEFT" width="15%" > &nbsp;#Client_Name#</TD>				
				<TD ALIGN="LEFT" nowrap width="10%" >&nbsp;#Registration_Date#</TD>
				<TD ALIGN="LEFT" NOWRAP width="10%">&nbsp;#Last_Modified_date#</TD>
			</TR>
			<INPUT type="Hidden" name="ClientID#Sr#" value="#CLIENT_ID#">
			<CFSET SR=SR+1>
			</CFLOOP>		
			<INPUT type="Hidden" name="Sr" value="#Sr#">						
		</table>
		</div>
		<div align="left" style="position:absolute; overflow:auto; height:8%; top:92%; left:0%;">
		<TABLE  WIDTH="100%" BORDER="0" ALIGN="center"  CELLPADDING="0" CELLSPACING="0">			
		 <TR bgcolor="##FFFFCC">
			<TH ALIGN="LEFT"  COLSPAN="3" NOWRAP>
					Format:&nbsp;<select name="Format" >
						<option value="Old">Old Format</option>
						<option value="New">New Format</option>
						<option value="New1" >New Format From 24 oct 2011</option>
						<option value="New2" selected>New Format From 09 June 2012</option>
					</select>
<!--- 					<INPUT TYPE="RADIO" NAME="Format" VALUE="Old">Old Format
					
					<INPUT TYPE="RADIO" NAME="Format" VALUE="New" checked>

					<INPUT TYPE="RADIO" NAME="Format" VALUE="New1" checked>
 --->				<INPUT TYPE="submit" NAME="CmdGenerate" VALUE="Generate" CLASS="field">
			</TH>
		</TR>		
		</TABLE>
	</div>
	</CFIF>

</FORM>
</CFOUTPUT>	
</BODY>
</HTML>
