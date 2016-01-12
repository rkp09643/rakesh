<!---- **********************************************************************************
				BACK-OFFICE SYSTEM FOR CAPITAL MARKET AND DERIVATIVE TRADING.
*********************************************************************************** ---->
<html>
<head>
	<title> Expiry Process. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	
	<STYLE>
		DIV#Heading
		{
			Font		:	Bold 10pt Tahoma;
			Color		:	Navy;
			Position	:	Absolute;
			Top			:	0;
			Width		:	100%;
		}
		DIV#Header
		{
			Position	:	Absolute;
			Top			:	6%;
			Width		:	100%;
		}
		DIV#Datas
		{
			Position	:	Absolute;
			Top			:	80%;
			Width		:	100%;
			Height		: 	20%;
			Overflow	:	Auto;
		}
	</STYLE>
</head>

<body leftmargin="0" rightmargin="0" Class="StyleBody1">
<CFOUTPUT>


<div align="center" id="Heading">
	<u>Generate Trade File</u>
</div>


<div align="center" id="Header">
		
	<cftry>
		<cfquery name="Drop" datasource="#Client.database#">
			Drop table ##TEMPABNTRADEDATA
		</cfquery>
	<cfcatch>
	</cfcatch>
	</cftry>

<CFIF	NOT DirectoryExists("#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\TradeFiles")>
		<CFDIRECTORY ACTION="CREATE" DIRECTORY="#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\TradeFiles">
</CFIF>		
	<CFIF Not IsDefined("Client.GroupID")>
		<CFSET	COCD	=	GetToken(cocd,2,"~")>
	</CFIF>


		<CFINCLUDE TEMPLATE="../../Common/Export_Text_File.cfm">

		<CFIF Not IsDefined("Client.GroupID")>
			<CFINCLUDE TEMPLATE="../Common/CopyFile.cfc">
		<CFELSE>
			<CFINCLUDE TEMPLATE="../../Common/CopyFile.cfc">
		</CFIF>

	<CFIF	optFileType	eq	"Adlwise">
		
		
		<cfquery name="TRADEDATA1" datasource="#Client.database#">
				SELECT 
					CONVERT(VARCHAR(10),TRADE_DATE,103)TRADE_DATE,A.CLIENT_ID,B.CLIENT_NAME,TRADE_NUMBER,
					CAST(ORDER_NUMBER AS VARCHAR(100))ORDER_NUMBER,C.INSTRUMENT_TYPE,A.SCRIP_SYMBOL,A.SCRIP_NAME,CONVERT(VARCHAR(10),A.EXPIRY_DATE,103) EXPIRY_DATE,CAST('' AS VARCHAR(10))NNNF_ORDERNUMBER, 
					(A.STRIKE_PRICE + A.PRICE_PREMIUM)RATE,PRICE_PREMIUM,
					 QUANTITY,BUY_SALE,'' as Remark,trade_number,EXCHANGE_CLEARING_CODE BROKER_CODE,Custodian_Part_Code
				FROM TRADE1 A, SCRIP_MASTER_TABLE C,CLIENT_MASTER B,SYSTEM_SETTINGS D
				WHERE	A.CLIENT_ID = B.CLIENT_ID
				AND		A.COMPANY_CODE = B.COMPANY_CODE
				AND		A.COMPANY_CODE = D.COMPANY_CODE
				AND		A.SCRIP_SYMBOL	=	C.SCRIP_SYMBOL
				AND A.COMPANY_CODE = '#COCD#'
				AND CLIENT_NATURE  = 'I'
			<CFIF	Trim(BranchList)	NEQ	"">
			And		B.Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
			</CFIF>
			<CFIF	Trim(FamilyList)	NEQ	"">
			And		B.Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
			</CFIF>
			<CFIF	Trim(ClientList)	NEQ	"">
			And		B.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
			</CFIF>
			AND TRADE_DATE BETWEEN CONVERT(DATETIME,'#From_Date#',103) AND CONVERT(DATETIME,'#to_Date#',103)
		</cfquery>

		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">
		<CFSET	DateTime			=	TimeFormat(Now(),"HHMMSS")>
		<CFSET	TradeFileName		=	"Adlwise_#COCD#_#DateTime#">	
		<CFFILE FILE				=	"#TradeFilePath#\#TradeFileName#.CSV" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFSET 	Struct 				= 	GetMetaData(TRADEDATA1)>
		<CFSET FileStr1 ="">
		<CFSET FilehStr1 ="">
		<CFSET FileStr ="">
		<cfset FilehStr1 ="date,trade no,,buy/sale,broker code,cp code,scrip,type,expiry,,,qty,price">
		<cfloop query="TRADEDATA1">
				<cFIF CURRENTROW EQ 1>
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FilehStr1##chr(10)#" ADDNEWLINE="YES">
				</cFIF>
				<CFSET FileStr = "#TRADE_DATE#,#trade_number#,#ORDER_NUMBER#,#BUY_SALE#,#BROKER_CODE#,#Custodian_Part_Code#,#SCRIP_NAME#,#INSTRUMENT_TYPE#,#EXPIRY_DATE#,,,#QUANTITY#,#PRICE_PREMIUM#">
				<cFIF CURRENTROW EQ TRADEDATA1.RECORDCOUNT>
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FileStr#" ADDNEWLINE="NO">
				<cfelse>	
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FileStr#" ADDNEWLINE="YES">
				</cFIF>
		</cfloop>
		<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.CSV","C:\#TradeFileName#.CSV")>
		<CENTER>
			<FONT COLOR=BLUE>
				File generated at #TradeFilePath#\<!--- #TradeFileName#.TXT --->
			</FONT>
		</CENTER>
		<CFIF Not ClientFileGenerated>
			<CENTER>
				<FONT COLOR=RED>
					File not generated on your machine...
				</FONT>
			</CENTER>
		<CFELSE>
			<CENTER>
				<FONT COLOR=BLUE>
					File generated at Client Machine C:\<!--- #TradeFileName#.TXT --->
				</FONT>
			</CENTER>
		</CFIF>
		<cfabort>
		
	</CFIF>
	<CFIF	optFileType	eq	"PanVery">
		<CFIF	NOT DirectoryExists("#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\PanVerify")>
			<CFDIRECTORY ACTION="CREATE" DIRECTORY="#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\PanVerify">
		</CFIF>		
		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\PanVerify">
		<CFSET	DateTime			=	DateFormat(Now(),"DDMMYYYY")>
		<CFSET	TradeFileName		=	"ClientPanDetail_#DateTime#">	
		<CFQUERY NAME="selTrades" datasource="#Client.database#">
			SELECT DISTINCT FIRST_NAME,MIDDLE_NAME,LAST_NAME,REPLACE(B.RESI_ADDRESS,'~','')  RESI_ADDRESS,BIRTH_DATE,PAN_NO
			FROM 
			CLIENT_MASTER A,CLIENT_DETAILS B
			WHERE A.CLIENT_ID = B.CLIENT_ID
			AND A.REGISTRATION_DATE BETWEEN CONVERT(DATETIME,'#From_Date#',103) AND CONVERT(DATETIME,'#TO_DATE#',103)
			<CFIF	Trim(BranchList)	NEQ	"">
			And		A.Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
			</CFIF>
			<CFIF	Trim(FamilyList)	NEQ	"">
			And		A.Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
			</CFIF>
			<CFIF	Trim(ClientList)	NEQ	"">
			And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
			</CFIF>
			and len(isnull(PAN_NO,'')) !=0 
		</CFQUERY>	
		<Cfif selTrades.recordcount eq 0>
			No Record Available <cfabort>
		</Cfif>
		<CFFILE FILE				=	"#TradeFilePath#\#TradeFileName#.xml" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<cFSET fILEtEXT ="<?xml version='1.0' encoding='utf-8'?>
<BPANQ xsi:noNamespaceSchemaLocation='BPANQ.xsd' xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance'>
">
		<cfloop query="selTrades">
			<CFSET fILEtEXT ="#fILEtEXT#<BPAN>
<UniqueSRNO>#NumberFormat(CURRENTROW,'000000000')#</UniqueSRNO>
<pan>#PAN_NO#</pan>
<firstname>#FIRST_NAME#</firstname>
<midname>#MIDDLE_NAME#</midname>
<lastname>#LAST_NAME#</lastname>
<dob>#DATEFORMAT(BIRTH_DATE,'YYYY-MM-DD')#</dob>
<address>#RESI_ADDRESS#</address>
</BPAN>">
			<cFIF LEN(fILEtEXT) GT 50000>
				<CFFILE FILE = "#TradeFilePath#\#TradeFileName#.xml" ACTION="append" OUTPUT="#fILEtEXT#" ADDNEWLINE="NO">
				<cFSET fILEtEXT ="">
			</cFIF>  
		</cfloop>		
		<CFFILE FILE = "#TradeFilePath#\#TradeFileName#.xml" ACTION="append" OUTPUT="#fILEtEXT#</BPANQ>" ADDNEWLINE="NO">
		<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.xml","C:\Reports\#TradeFileName#.xml")>
		<CENTER>
			<FONT COLOR=BLUE>
				File generated at C:\Reports\#TradeFileName#.xml
			</FONT>
		</CENTER>
		<cfabort>
	</CFIF>

	<CFIF	optFileType	eq	"PanTin">
		<CFIF	NOT DirectoryExists("#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\PanVerify")>
			<CFDIRECTORY ACTION="CREATE" DIRECTORY="#Left(GetTemplatePath(),1)#:\CFUSIONMX7\WWWRoot\Reports\PanVerify">
		</CFIF>		
		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\PanVerify">
		<CFSET	DateTime			=	DateFormat(Now(),"DDMM")>
		<CFSET	TradeFileName		=	"Pan_#DateTime#">
		<CFQUERY NAME="selTrades" datasource="#Client.database#">
			SELECT DISTINCT FIRST_NAME,MIDDLE_NAME,LAST_NAME,REPLACE(B.RESI_ADDRESS,'~','')  RESI_ADDRESS,BIRTH_DATE,PAN_NO
			FROM
			CLIENT_MASTER A,CLIENT_DETAILS B
			WHERE A.CLIENT_ID = B.CLIENT_ID
			AND A.REGISTRATION_DATE BETWEEN CONVERT(DATETIME,'#From_Date#',103) AND CONVERT(DATETIME,'#TO_DATE#',103)
			<CFIF	Trim(BranchList)	NEQ	"">
			And		A.Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
			</CFIF>
			<CFIF	Trim(FamilyList)	NEQ	"">
			And		A.Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
			</CFIF>
			<CFIF	Trim(ClientList)	NEQ	"">
			And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
			</CFIF>
			and len(isnull(PAN_NO,'')) !=0 
		</CFQUERY>	
		<Cfif selTrades.recordcount eq 0>
			No Record Available 
			<cfabort>
		</Cfif>
		
		<CFFILE FILE				=	"#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		
		<cFSET fILEtEXT ="">
		<cFSET fILEtEXTBatch =1>
		
		<cfset rowcount = 1>
		<cfloop query="selTrades">
			<CFSET fILEtEXT ="#fILEtEXT##NumberFormat(CURRENTROW,'000000')#^FD^#Ucase(PAN_NO)##CHR(10)#">
			<cfset rowcount = rowcount+1>
		</cfloop>
		<CFSET fILEtEXT ="#fILEtEXT##NumberFormat(rowcount,'000000')#^FT^EXTIN^#selTrades.recordcount#">
		
		<CFFILE FILE = "#TradeFilePath#\#TradeFileName#.txt" ACTION="append" OUTPUT="#fILEtEXT#" ADDNEWLINE="NO">
		
		<CFSET	ClientFileGenerated	=	CopyFile_UNIX("#TradeFilePath#\#TradeFileName#.txt","C:\Reports\#TradeFileName#.txt")>
		<CENTER>
			<FONT COLOR=BLUE>
				File generated at C:\Reports\#TradeFileName#.txt
			</FONT>
		</CENTER>
		<cfabort>
	</CFIF>

	<CFIF	optFileType	eq	"TradeFile">

			<cfquery name="TRADEDATA1" datasource="#Client.database#">
				SELECT 
					CONVERT(VARCHAR(10),TRADE_DATE,103)TRADE_DATE,A.CLIENT_ID,B.CLIENT_NAME,TRADE_NUMBER,
					CAST(ORDER_NUMBER AS VARCHAR(100))ORDER_NUMBER,C.INSTRUMENT_TYPE,A.SCRIP_SYMBOL,A.SCRIP_NAME,A.EXPIRY_DATE,CAST('' AS VARCHAR(10))NNNF_ORDERNUMBER, 
					(A.STRIKE_PRICE + A.PRICE_PREMIUM)RATE,
					CAST(SUM(QUANTITY * (Trade_Brokerage+Delivery_Brokerage)) /  SUM(QUANTITY) AS NUMERIC(30,2)) Brokerage,
					CASE WHEN BUY_SALE = 'BUY' THEN
						CAST(ABS((SUM(QUANTITY * (Trade_Brokerage+Delivery_Brokerage)) /  SUM(QUANTITY)+(A.STRIKE_PRICE + A.PRICE_PREMIUM))) AS NUMERIC(30,4)) 
					ELSE
						CAST(ABS((SUM(QUANTITY * (Trade_Brokerage+Delivery_Brokerage)) /  SUM(QUANTITY)-(A.STRIKE_PRICE + A.PRICE_PREMIUM))) AS NUMERIC(30,4)) 
					END NETRATE,QUANTITY,BUY_SALE,'' as Remark
				FROM TRADE1 A, SCRIP_MASTER_TABLE C,CLIENT_MASTER B
				WHERE	A.CLIENT_ID = B.CLIENT_ID
				AND		A.COMPANY_CODE = B.COMPANY_CODE
				AND		A.SCRIP_SYMBOL	=	C.SCRIP_SYMBOL
				AND A.COMPANY_CODE = '#COCD#'
			<CFIF	Trim(BranchList)	NEQ	"">
			And		B.Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
			</CFIF>
			<CFIF	Trim(FamilyList)	NEQ	"">
			And		B.Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
			</CFIF>
			<CFIF	Trim(ClientList)	NEQ	"">
			And		B.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
			</CFIF>
				AND TRADE_DATE BETWEEN CONVERT(DATETIME,'#From_Date#',103) AND CONVERT(DATETIME,'#to_Date#',103)
				GROUP BY TRADE_DATE,A.CLIENT_ID,B.CLIENT_NAME,TRADE_NUMBER,
					ORDER_NUMBER,C.INSTRUMENT_TYPE,A.SCRIP_SYMBOL,A.SCRIP_NAME,A.EXPIRY_DATE,
					A.STRIKE_PRICE ,A.PRICE_PREMIUM,BUY_SALE,QUANTITY
				ORDER BY A.SCRIP_SYMBOL,A.SCRIP_NAME
			</cfquery>

		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">
		<CFSET	DateTime			=	TimeFormat(Now(),"HHMMSS")>
		<CFSET	TradeFileName		=	"#COCD#_TradeFile_#DateTime#">	
		<CFFILE FILE				=	"#TradeFilePath#\#TradeFileName#.CSV" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFSET 	Struct 				= 	GetMetaData(TRADEDATA1)>
		<CFSET FileStr1 ="">
		<CFSET FilehStr1 ="">
		<CFSET FileStr ="">
		<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
				<CFIF ArrayLen(Struct) eq i>
					<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##">
				<CFELSE>
					<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##,">
				</CFIF>
		</CFLOOP>
		<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
				<CFIF ArrayLen(Struct) eq i>
					<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#">
				<CFELSE>
					<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#,">
				</CFIF>
		</CFLOOP>
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FilehStr1##chr(10)#" ADDNEWLINE="NO">
		<cfloop query="TRADEDATA1">
				<CFSET FileStr = "#FileStr##EVALUATE(DE(FileStr1))##chr(10)#">
		</cfloop>
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FileStr#" ADDNEWLINE="NO">
		<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.CSV","C:\#TradeFileName#.CSV")>
		<CENTER>
			<FONT COLOR=BLUE>
				File generated at #TradeFilePath#\<!--- #TradeFileName#.TXT --->
			</FONT>
		</CENTER>
		<CFIF Not ClientFileGenerated>
			<CENTER>
				<FONT COLOR=RED>
					File not generated on your machine...
				</FONT>
			</CENTER>
		<CFELSE>
			<CENTER>
				<FONT COLOR=BLUE>
					File generated at Client Machine C:\<!--- #TradeFileName#.TXT --->
				</FONT>
			</CENTER>
		</CFIF>
		<cfabort>
	</CFIF>


	<CFIF	optFileType	eq	"MONEY">
		<CFIF MARKET EQ "CAPS">
			<CFSTOREDPROC PROCEDURE="EXPORT_MONEYWARE_FORMATE1" datasource="#Client.database#">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@COMPANY_CODE" VALUE="#COCD#" MAXLENGTH="15" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FROM_DATE" VALUE="#From_Date#" MAXLENGTH="10" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TO_DATE" VALUE="#TO_DATE#" MAXLENGTH="10" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@BRANCH_CODE" VALUE="#BranchList#" NULL="No"> 
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FAMILY_GROUP" VALUE="#TRIM(FamilyList)#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@CLIENT_ID" VALUE="#ClientList#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@EXCHANGE" VALUE="#EXCHANGE#" NULL="No"> 
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@MARKET" VALUE="#TRIM(MARKET)#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FINSTYR" VALUE="#FinStart#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FINENDYR" VALUE="#FinEnd#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@Category" VALUE="#cmbCategory#" NULL="No">
				<CFPROCRESULT NAME="TRADEDATA">
			</cfstoredproc>
		<cfelse>
			<CFSTOREDPROC PROCEDURE="EXPORT_MONEYWARE_FORMATE1_FO" datasource="#Client.database#">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@COMPANY_CODE" VALUE="#COCD#" MAXLENGTH="15" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FROM_DATE" VALUE="#From_Date#" MAXLENGTH="10" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@TO_DATE" VALUE="#TO_DATE#" MAXLENGTH="10" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@BRANCH_CODE" VALUE="#BranchList#" NULL="No"> 
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FAMILY_GROUP" VALUE="#TRIM(FamilyList)#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@CLIENT_ID" VALUE="#ClientList#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@EXCHANGE" VALUE="#EXCHANGE#" NULL="No"> 
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@MARKET" VALUE="#TRIM(MARKET)#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FINSTYR" VALUE="#FinEnd#" NULL="No">
				<CFPROCPARAM TYPE="In" CFSQLTYPE="CF_SQL_VARCHAR" DBVARNAME="@FINENDYR" VALUE="#FinStart#" NULL="No">
				<CFPROCRESULT NAME="TRADEDATA">
			</cfstoredproc>	
		</CFIF>
		
		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">
		<CFSET	DateTime			=	TimeFormat(Now(),"HHMMSS")>
		<CFSET	TradeFileName		=	"#COCD#_MONEYWARE_#DateTime#">	
		<CFFILE FILE				=	"#TradeFilePath#\#TradeFileName#.CSV" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFSET 	Struct 				= 	GetMetaData(TRADEDATA)>
		<CFSET FileStr1 ="">
		<CFSET FilehStr1 ="">
		<CFSET FileStr ="">
		<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
				<CFIF ArrayLen(Struct) eq i>
					<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##">
				<CFELSE>
					<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##,">
				</CFIF>
		</CFLOOP>
		<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
				<CFIF ArrayLen(Struct) eq i>
					<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#">
				<CFELSE>
					<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#,">
				</CFIF>
		</CFLOOP>
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FilehStr1##chr(10)#" ADDNEWLINE="NO">
		<cfloop query="TRADEDATA">
				<CFSET FileStr = "#FileStr##EVALUATE(DE(FileStr1))##chr(10)#">

		</cfloop>
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FileStr#""" ADDNEWLINE="NO">
		<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.CSV","C:\#TradeFileName#.CSV")>
		<CENTER>
			<FONT COLOR=BLUE>
				File generated at #TradeFilePath#\<!--- #TradeFileName#.TXT --->
			</FONT>
		</CENTER>
		
		<CFIF Not ClientFileGenerated>
			<CENTER>
				<FONT COLOR=RED>
					File not generated on your machine...
				</FONT>
			</CENTER>
		<CFELSE>
			<CENTER>
				<FONT COLOR=BLUE>
					File generated at Client Machine C:\<!--- #TradeFileName#.TXT --->
				</FONT>
			</CENTER>
		</CFIF>
		<cfabort>
	</CFIF>
	
	
	<cfparam name="ClientFileGenerated" default="False">
	<cfparam name="TradeFilePath" default="">
	
		<CFQUERY NAME="GetCMCode" datasource="#Client.database#">
			SELECT	Clearing_Member_Code,BROKER_CODE
			FROM
					System_Settings
			WHERE
					Company_Code	=	'#COCD#'
		</CFQUERY>
		
		<CFSET	CMCode	=	Trim(GetCMCode.Clearing_Member_Code)>
		<CFSET BROKER_CODE = Trim(GetCMCode.BROKER_CODE)>
		
	<cfif MARKET EQ "CAPS">
		<CFQUERY NAME="GetTradeDates" datasource="#Client.database#">
			SELECT	Convert(VarChar(10), From_Date, 103)From_Date
			FROM
					Settlement_Master
			WHERE
					Company_Code	=	'#COCD#'
			And		Convert(Datetime, From_Date, 103)	Between	Convert(Datetime, '#From_Date#', 103)
														And		Convert(Datetime, '#To_Date#', 103)			
		</CFQUERY> 
	<cfelse>
		<CFQUERY NAME="GetTradeDates" datasource="#Client.database#">
			SELECT convert(varchar(10),trade_date,103) From_Date from DATELIST('#From_Date#','#To_Date#')
		</CFQUERY> 	
	</cfif>		
		<CFIF GetTradeDates.RecordCount EQ	0>
			<SCRIPT>
				alert("No data available for given parameter...!")
			</SCRIPT>
			<SCRIPT>
				history.back();
			</SCRIPT>
			<CFABORT>
		</CFIF>
		
		
		<CFSET	DateTime	=	TimeFormat(Now(),"MMSSHH")>
		
		<CFLOOP QUERY="GetTradeDates">
			<CFSET	Trade_Date		=	From_Date>
			<CFSET	CFTOKEN			=	COOKIE.CFTOKEN>
			<CFSET	TradeFilePath	=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">
			<CFSET	TradeFileName	=	"#COCD#_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#_#DateTime#">
			<CFSET	ClientTradeFileName	=	"#COCD#_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#">


		<CFIF MARKET EQ "CAPS">
			<cfif OptGenType eq "D">
				<CFQUERY NAME="selTrades" datasource="#Client.database#">
					Select 	A.*,
						Convert(CHAR(8), Trade_Datetime, 108)TradeTime,
						Convert(CHAR(10), Trade_Date   , 103)TradeDate1,
						Convert(CHAR(8), Order_Datetime, 108)Order_Time,
						ISIN
					From 
						Trade1 A, SCRIP_MASTER_TABLE B, Client_Master C
					Where 
							A.Company_Code	=	'#COCD#'
					And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
					And 	A.Client_ID 	<> 	'#CMCode#'
					And		Order_Number	Not Like 'ND%'
					And		A.Scrip_Symbol	=	B.Scrip_Symbol
					And		A.Company_Code	=	C.Company_Code
					And		A.Client_ID		=	C.Client_ID
					And		A.mkt_Type		In	('N','T')	
					<CFIF	Trim(BranchList)	NEQ	"">
					And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
					</CFIF>
					<CFIF	Trim(FamilyList)	NEQ	"">
					And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
					</CFIF>
					<CFIF	Trim(ClientList)	NEQ	"">
					And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
					</CFIF>
					<CFIF	Trim(TerminalList)	NEQ	"">
					And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
					</CFIF>
				</CFQUERY>		
			<cfelse>
				<CFQUERY NAME="selTrades" datasource="#Client.database#">
					Select 	MAX(TRADE_NUMBER) TRADE_NUMBER,A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_NAME,TRADE_DATE,MAX(TRADE_DATETIME) TRADE_DATETIME,MAX(A.EXPIRY_DATE) EXPIRY_DATE,
							BUY_SALE,MKT_TYPE,SETTLEMENT_NO,SUM(QUANTITY) QUANTITY,
							CAST(SUM(QUANTITY * PRICE_PREMIUM) /  SUM(QUANTITY) AS NUMERIC(30,2))  PRICE_PREMIUM,A.STRIKE_PRICE,MAX(ORDER_NUMBER)ORDER_NUMBER,MAX(ORDER_DATETIME) ORDER_DATETIME,USER_ID,
						<CFIF optFileType EQ 'SONY'>
							MAX(Convert(VARCHAR(50), Trade_Datetime, 113)) TradeTime,
						<CFELSE>
							MAX(Convert(CHAR(8), Trade_Datetime, 108)) TradeTime,
						</CFIF>		
						<CFIF optFileType EQ 'SONY'>
							MAX(Convert(VARCHAR(50), Order_Datetime, 113)) Order_Time,
						<cfelse>	
							MAX(Convert(CHAR(8), Order_Datetime, 108)) Order_Time,
						</CFIF>		
							CAST(SUM(QUANTITY * Trade_Brokerage) /  SUM(QUANTITY) AS NUMERIC(30,2)) Trade_Brokerage,
							CAST(SUM(QUANTITY * Delivery_Brokerage) /  SUM(QUANTITY) AS NUMERIC(30,2)) Delivery_Brokerage,
							Convert(CHAR(10), Trade_Date, 103)TradeDate1,
							ISIN,A.INSTRUMENT_TYPE,A.OPTION_TYPE,A.CONTRACT_NO,C.CLIENT_NAME
					From 
						Trade1 A, SCRIP_MASTER_TABLE B, Client_Master C
					Where 
							A.Company_Code	=	'#COCD#'
					And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
					And 	A.Client_ID 	<> 	'#CMCode#'
					And		Order_Number	Not Like 'ND%'
					And		A.Scrip_Symbol	=	B.Scrip_Symbol
					And		A.Company_Code	=	C.Company_Code
					And		A.Client_ID		=	C.Client_ID
					And		A.mkt_Type		In	('N','T')	
					<CFIF	Trim(BranchList)	NEQ	"">
						And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
					</CFIF>
					<CFIF	Trim(FamilyList)	NEQ	"">
						And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
					</CFIF>
					<CFIF	Trim(ClientList)	NEQ	"">
						And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
					</CFIF>
					<CFIF	Trim(TerminalList)	NEQ	"">
						And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
					</CFIF>
					GROUP BY A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_NAME,TRADE_DATE,BUY_SALE,
							MKT_TYPE,SETTLEMENT_NO,A.STRIKE_PRICE,USER_ID,ISIN,A.INSTRUMENT_TYPE,
							A.OPTION_TYPE,A.OPTION_TYPE,A.CONTRACT_NO,C.CLIENT_NAME
				</CFQUERY>		
			</cfif>
		<cfelse>
			<cfif COCD EQ "MCX">
			
				<cfif OptGenType eq "D">
					<CFQUERY NAME="selTrades" datasource="#Client.database#">
						Select 	A.*,UPPER(REPLACE(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','')) EXP_DATE,CONVERT(VARCHAR(20),TRADE_DATETIME,113) TRDDATETIME,
							CONVERT(VARCHAR(20),ORDER_DATETIME,113) ORDERDATETIME,b.Scrip_Symbol POSITION_SYMBOL,	
							Convert(CHAR(8), Trade_Datetime, 108)TradeTime,
							Convert(CHAR(8), Order_Datetime, 108)Order_Time,
							Replace(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','') EXP_DATE1,
							CAST(A.QUANTITY / CAST( FACTOR AS NUMERIC(30,8)) AS NUMERIC(30)) NEWQTY,POSITION_SYMBOL POSITION_SYMBOL1
						From 
							Trade1 A,COMM_CUR_FACTOR B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'					
						And		A.Scrip_Name	=	B.Scrip_Symbol
						and 	a.expiry_date 	= b.expiry_date
						And		A.Company_Code	=	C.Company_Code
						AND		A.COMPANY_CODE = B.COMPANY			
						And		A.Client_ID		=	C.Client_ID
						And		A.mkt_Type		In	('FO')
						AND		(A.TRADE_TYPE LIKE 'TN')		
						<CFIF	Trim(BranchList)	NEQ	"">
						And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
						And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
						And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
						And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
					</CFQUERY>		
				<cfelse>
					<CFQUERY NAME="selTrades" datasource="#Client.database#">
						Select 	MAX(TRADE_NUMBER) TRADE_NUMBER,A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_SYMBOL SCRIP_NAME,TRADE_DATE,MAX(TRADE_DATETIME) TRADE_DATETIME,MAX(A.EXPIRY_DATE) EXPIRY_DATE,
								BUY_SALE,MKT_TYPE,SETTLEMENT_NO,SUM(QUANTITY) QUANTITY,OPTION_TYPE,
								CAST(SUM(QUANTITY * PRICE_PREMIUM) /  SUM(QUANTITY) AS NUMERIC(30,4))  PRICE_PREMIUM,A.STRIKE_PRICE,MAX(ORDER_NUMBER)ORDER_NUMBER,MAX(ORDER_DATETIME) ORDER_DATETIME,USER_ID,
								MAX(Convert(CHAR(8), Trade_Datetime, 108)) TradeTime,A.INSTRUMENT_TYPE,b.Scrip_Symbol POSITION_SYMBOL,
								MAX(Convert(CHAR(8), Order_Datetime, 108)) Order_Time
								,UPPER(REPLACE(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','')) EXP_DATE,CONVERT(VARCHAR(20),MAX(TRADE_DATETIME),113) TRDDATETIME,
								CONVERT(VARCHAR(20),MAX(ORDER_DATETIME),113) ORDERDATETIME,Replace(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','') EXP_DATE1,
								CAST(SUM(A.QUANTITY) / CAST( FACTOR AS NUMERIC(30,8)) AS NUMERIC(30)) NEWQTY,POSITION_SYMBOL POSITION_SYMBOL1
						From 
							Trade1 A, COMM_CUR_FACTOR B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'					
						And		A.Scrip_Name	=	B.Scrip_Symbol
						And		A.Company_Code	=	C.Company_Code
						and 	a.expiry_date 	= b.expiry_date
						And		A.Client_ID		=	C.Client_ID
						And		A.mkt_Type		In	('FO')
						AND		A.COMPANY_CODE = B.COMPANY			
						AND		(A.TRADE_TYPE LIKE 'TN')	
						<CFIF	Trim(BranchList)	NEQ	"">
							And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
							And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
							And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
							And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
						GROUP BY A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_SYMBOL,TRADE_DATE,BUY_SALE,MKT_TYPE,SETTLEMENT_NO,A.STRIKE_PRICE,USER_ID,OPTION_TYPE,A.EXPIRY_DATE,
						A.INSTRUMENT_TYPE,FACTOR,POSITION_SYMBOL
					</CFQUERY>		
				</cfif>
				<CFELSEIF COCD EQ "NCDEX">
					<cfif OptGenType eq "D">
					<CFQUERY NAME="selTrades" datasource="#Client.database#">
						Select 	A.*,UPPER(CONVERT(CHAR(11),A.EXPIRY_DATE,113)) EXP_DATE,CONVERT(VARCHAR(20),TRADE_DATETIME,113) TRDDATETIME,
								CONVERT(VARCHAR(20),ORDER_DATETIME,113) ORDERDATETIME,POSITION_SYMBOL,
							Convert(CHAR(8), Trade_Datetime, 108)TradeTime,
							Convert(CHAR(8), Order_Datetime, 108)Order_Time,Replace(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','') EXP_DATE1,
							CAST(A.PRICE_PREMIUM / FACTOR AS NUMERIC(30,2)) NEWRATE,CONVERT(VARCHAR(11),TRADE_DATETIME,113) TRDDATETIME1
						From 
							Trade1 A, Ncx_Scrip_Master B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'					
						And		A.Scrip_Name	=	B.Scrip_Symbol
						And		A.Company_Code	=	C.Company_Code
						And		A.Client_ID		=	C.Client_ID
						AND     B.EXCHANGE = 'NCDX'
						And		A.mkt_Type		In	('FO')
						AND		(A.TRADE_TYPE LIKE 'TN')		
						<CFIF	Trim(BranchList)	NEQ	"">
						And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
						And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
						And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
						And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
					</CFQUERY>		
				<cfelse>
					<CFQUERY NAME="selTrades" datasource="#Client.database#">
						Select 	MAX(TRADE_NUMBER) TRADE_NUMBER,A.CLIENT_ID,A.SCRIP_SYMBOL,A.SCRIP_NAME,TRADE_DATE,MAX(TRADE_DATETIME) TRADE_DATETIME,MAX(A.EXPIRY_DATE) EXPIRY_DATE,
								BUY_SALE,MKT_TYPE,SETTLEMENT_NO,SUM(QUANTITY) QUANTITY,OPTION_TYPE,
								CAST(SUM(QUANTITY * PRICE_PREMIUM) /  SUM(QUANTITY) AS NUMERIC(30,4))  PRICE_PREMIUM,A.STRIKE_PRICE,MAX(ORDER_NUMBER)ORDER_NUMBER,MAX(ORDER_DATETIME) ORDER_DATETIME,USER_ID,
								MAX(Convert(CHAR(8), Trade_Datetime, 108)) TradeTime,A.INSTRUMENT_TYPE,POSITION_SYMBOL,
								MAX(Convert(CHAR(8), Order_Datetime, 108)) Order_Time
								,UPPER(REPLACE(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','')) EXP_DATE,CONVERT(VARCHAR(20),MAX(TRADE_DATETIME),113) TRDDATETIME,
								CONVERT(VARCHAR(20),MAX(ORDER_DATETIME),113) ORDERDATETIME,Replace(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','') EXP_DATE1,
								CAST((SUM(QUANTITY * PRICE_PREMIUM) /  SUM(QUANTITY) / FACTOR) AS NUMERIC(30,2)) NEWRATE,CONVERT(VARCHAR(11),MAX(TRADE_DATETIME),113) TRDDATETIME1,
								CAST(SUM(QUANTITY * PRICE_PREMIUM) /  SUM(QUANTITY) AS NUMERIC(30,4))  PRICE_PREMIUM123	
				From 
							Trade1 A, NCX_Scrip_Master B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'					
						And		A.Scrip_Name	=	B.Scrip_Symbol
						And		A.Company_Code	=	C.Company_Code
						And		A.Client_ID		=	C.Client_ID
						And		A.mkt_Type		In	('FO')
						AND     B.EXCHANGE = 'NCDX'
						AND		(A.TRADE_TYPE LIKE 'TN')	
						<CFIF	Trim(BranchList)	NEQ	"">
							And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
							And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
							And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
							And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
						GROUP BY A.CLIENT_ID,A.SCRIP_SYMBOL,A.SCRIP_NAME,TRADE_DATE,BUY_SALE,MKT_TYPE,SETTLEMENT_NO,A.STRIKE_PRICE,USER_ID,OPTION_TYPE,A.EXPIRY_DATE,
						A.INSTRUMENT_TYPE,POSITION_SYMBOL,FACTOR
					</CFQUERY>		
				</cfif>
			<CFELSEIF COCD EQ "CD_NSE">
					<cfif OptGenType eq "D">
					<CFQUERY NAME="selTrades" datasource="#Client.database#">
						Select 	A.*,UPPER(REPLACE(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','')) EXP_DATE,CONVERT(VARCHAR(20),TRADE_DATETIME,113) TRDDATETIME,
							CONVERT(VARCHAR(20),ORDER_DATETIME,113) ORDERDATETIME,b.Scrip_Symbol POSITION_SYMBOL,	
							Convert(CHAR(8), Trade_Datetime, 108)TradeTime,
							Convert(CHAR(8), Order_Datetime, 108)Order_Time,
							Replace(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','') EXP_DATE1,
							CAST(A.QUANTITY / CAST( FACTOR AS NUMERIC(30,8)) AS NUMERIC(30)) NEWQTY,POSITION_SYMBOL POSITION_SYMBOL1
						From 
							Trade1 A,COMM_CUR_FACTOR B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'					
						And		A.Scrip_Name	=	B.Scrip_Symbol
						and 	a.expiry_date 	= b.expiry_date
						And		A.Company_Code	=	C.Company_Code
						AND		A.COMPANY_CODE = B.COMPANY			
						And		A.Client_ID		=	C.Client_ID
						And		A.mkt_Type		In	('FO')
						AND		(A.TRADE_TYPE LIKE 'TN')		
						<CFIF	Trim(BranchList)	NEQ	"">
						And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
						And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
						And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
						And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
					</CFQUERY>		
				<cfelse>
					<CFQUERY NAME="selTrades" datasource="#Client.database#">
						Select 	MAX(TRADE_NUMBER) TRADE_NUMBER,A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_SYMBOL SCRIP_NAME,TRADE_DATE,MAX(TRADE_DATETIME) TRADE_DATETIME,MAX(A.EXPIRY_DATE) EXPIRY_DATE,
								BUY_SALE,MKT_TYPE,SETTLEMENT_NO,SUM(QUANTITY) QUANTITY,OPTION_TYPE,
								CAST(SUM(QUANTITY * PRICE_PREMIUM) /  SUM(QUANTITY) AS NUMERIC(30,4))  PRICE_PREMIUM,A.STRIKE_PRICE,MAX(ORDER_NUMBER)ORDER_NUMBER,MAX(ORDER_DATETIME) ORDER_DATETIME,USER_ID,
								MAX(Convert(CHAR(8), Trade_Datetime, 108)) TradeTime,A.INSTRUMENT_TYPE,b.Scrip_Symbol POSITION_SYMBOL,
								MAX(Convert(CHAR(8), Order_Datetime, 108)) Order_Time
								,UPPER(REPLACE(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','')) EXP_DATE,CONVERT(VARCHAR(20),MAX(TRADE_DATETIME),113) TRDDATETIME,
								CONVERT(VARCHAR(20),MAX(ORDER_DATETIME),113) ORDERDATETIME,Replace(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','') EXP_DATE1,
								CAST(SUM(A.QUANTITY) / CAST( FACTOR AS NUMERIC(30,8)) AS NUMERIC(30)) NEWQTY,POSITION_SYMBOL POSITION_SYMBOL1
						From 
							Trade1 A, COMM_CUR_FACTOR B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'					
						And		A.Scrip_Name	=	B.Scrip_Symbol
						And		A.Company_Code	=	C.Company_Code
						and 	a.expiry_date 	= b.expiry_date
						And		A.Client_ID		=	C.Client_ID
						And		A.mkt_Type		In	('FO')
						AND		A.COMPANY_CODE = B.COMPANY
						AND		(A.TRADE_TYPE LIKE 'TN')	
						<CFIF	Trim(BranchList)	NEQ	"">
							And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
							And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
							And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
							And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
						GROUP BY A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_SYMBOL,TRADE_DATE,BUY_SALE,MKT_TYPE,SETTLEMENT_NO,A.STRIKE_PRICE,USER_ID,OPTION_TYPE,A.EXPIRY_DATE,
						A.INSTRUMENT_TYPE,FACTOR,POSITION_SYMBOL
					</CFQUERY>		
				</cfif>		
			<cfelse>			
				<cfif OptGenType eq "D">
					<CFQUERY NAME="selTrades" datasource="#Client.database#">
						Select 	A.*,CONVERT(CHAR(11),A.EXPIRY_DATE,113) EXP_DATE,CONVERT(VARCHAR(20),TRADE_DATETIME,113) TRDDATETIME,
								CONVERT(VARCHAR(20),ORDER_DATETIME,113) ORDERDATETIME,	
							Convert(CHAR(8), Trade_Datetime, 108)TradeTime,Replace(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','') EXP_DATE1,
							Convert(CHAR(8), Order_Datetime, 108)Order_Time,
							ISIN
						From 
							Trade1 A, SCRIP_MASTER_TABLE B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'					
						And		A.Scrip_Symbol	=	B.Scrip_Symbol
						And		A.Company_Code	=	C.Company_Code
						And		A.Client_ID		=	C.Client_ID
						And		A.mkt_Type		In	('FO')
						AND		(A.TRADE_TYPE LIKE 'TN')
						<CFIF	Trim(BranchList)	NEQ	"">
						And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
						And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
						And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
						And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
					</CFQUERY>		
				<cfelse>
					<CFQUERY NAME="selTrades" datasource="#Client.database#">
						Select 	MAX(TRADE_NUMBER) TRADE_NUMBER,A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_NAME,TRADE_DATE,MAX(TRADE_DATETIME) TRADE_DATETIME,MAX(A.EXPIRY_DATE) EXPIRY_DATE,
								BUY_SALE,MKT_TYPE,SETTLEMENT_NO,SUM(QUANTITY) QUANTITY,OPTION_TYPE,
								CAST(SUM(QUANTITY * PRICE_PREMIUM) /  SUM(QUANTITY) AS NUMERIC(30,4))  PRICE_PREMIUM,A.STRIKE_PRICE,MAX(ORDER_NUMBER)ORDER_NUMBER,MAX(ORDER_DATETIME) ORDER_DATETIME,USER_ID,
								MAX(Convert(CHAR(8), Trade_Datetime, 108)) TradeTime,A.INSTRUMENT_TYPE,
								MAX(Convert(CHAR(8), Order_Datetime, 108)) Order_Time
								,CONVERT(CHAR(11),A.EXPIRY_DATE,113) EXP_DATE,CONVERT(VARCHAR(20),MAX(TRADE_DATETIME),113) TRDDATETIME,
								CONVERT(VARCHAR(20),MAX(ORDER_DATETIME),113) ORDERDATETIME,	Replace(CONVERT(CHAR(11),A.EXPIRY_DATE,113),' ','') EXP_DATE1,
								ISIN
						From 
							Trade1 A, SCRIP_MASTER_TABLE B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'					
						And		A.Scrip_Symbol	=	B.Scrip_Symbol
						And		A.Company_Code	=	C.Company_Code
						And		A.Client_ID		=	C.Client_ID
						And		A.mkt_Type		In	('FO')
						AND		(A.TRADE_TYPE LIKE 'TN')	
						<CFIF	Trim(BranchList)	NEQ	"">
							And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
							And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
							And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
							And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
						GROUP BY A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_NAME,TRADE_DATE,BUY_SALE,MKT_TYPE,SETTLEMENT_NO,A.STRIKE_PRICE,USER_ID,ISIN,OPTION_TYPE,A.EXPIRY_DATE,A.INSTRUMENT_TYPE
					</CFQUERY>		
				</cfif>
			</cfif>			
		</CFIF>	
			<cfif MARKET EQ "CAPS">
				<CFIF	optFileType	eq	"BR">
					<CFSET	BSEBRData	=	"">
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
					
					<CFLOOP QUERY="selTrades">
						<CFSET	Rate	=	Price_Premium>
						<CFIF Mkt_Type EQ "T">	
							<CFSET Scrip_Type	=	"T">
						<CFELSEIF  Mkt_Type EQ "N">	
							<CFSET Scrip_Type	=	"ROLLING">
						</CFIF>
						
						<CFIF optRateType EQ "RateWithBrk">
							<CFIF Buy_Sale	EQ	"BUY">
								<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							<CFELSEIF Buy_Sale	EQ	"SALE">
								<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							</CFIF>
						</CFIF>
						
						<CFSET	Rate	=	Price_Premium * 100><!--- FILE DATA COMES PRICE * 100--->
						
						<CFSET	BSEBRData	=	"">				
						<CFSET	BSEBRData	=	"#BROKER_CODE#|#USER_ID#|#SCRIP_SYMBOL#|#TRIM(SCRIP_NAME)#|#Rate#|#Quantity#|0|0|#TradeTime#|#Replace(Left(Trade_Date,10	),"-","/","ALL")#|#Client_ID#|#Order_Number#|L|#LEFT(BUY_SALE,1)#|#TRADE_NUMBER#|CLIENT|#ISIN#|#Scrip_Type#|#Right(Settlement_No,3)#/#FinStart##FinEnd#|#Order_Time#|">
						<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#BSEBRData#" ADDNEWLINE="YES">
					</CFLOOP>
				</CFIF>
				
				<CFIF	optFileType	eq	"TR">
					<CFSET	BSEBRData	=	"">
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
					
					<CFLOOP QUERY="selTrades">
						<CFSET	Rate	=	Price_Premium>
						<CFIF Mkt_Type EQ "T">	
							<CFSET Scrip_Type	=	"T">
						<CFELSEIF  Mkt_Type EQ "N">	
							<CFSET Scrip_Type	=	"ROLLING">
						</CFIF>
						
						<CFIF optRateType EQ "RateWithBrk">
							<CFIF Buy_Sale	EQ	"BUY">
								<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							<CFELSEIF Buy_Sale	EQ	"SALE">
								<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							</CFIF>
						</CFIF>
						
						<CFSET	Rate	=	Price_Premium * 100><!--- FILE DATA COMES PRICE * 100--->
						
						<CFSET	BSEBRData	=	"">				
						<CFSET	BSEBRData	=	"#SCRIP_SYMBOL#|#TRIM(SCRIP_NAME)#|#TRADE_NUMBER#|#Rate#|#Quantity#|0|0|#TradeTime#|#Replace(Left(Trade_Date,10),"-","/","ALL")#|#Client_ID#|#LEFT(BUY_SALE,1)#|L|#Order_Number#|CLIENT|#ISIN#|#Scrip_Type#|#Right(Settlement_No,3)#/#FinStart##FinEnd#|#Order_Time#|">
						<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#BSEBRData#" ADDNEWLINE="YES">
					</CFLOOP>
				</CFIF>
				

			<CFIF	optFileType	eq	"Rel">
				<cfif OptGenType eq 'D'>
					<cfquery name="TRADEDATA1" datasource="#Client.database#">
								SELECT 	MAX(convert(VARCHAR,A.TRADE_DATE,103)) TRADE_DATE,
										MAX(A.TRADE_NUMBER)TRADE_NUMBER,
										MAX(A.INSTRUMENT_TYPE)INSTRUMENT_TYPE,
										A.SCRIP_SYMBOL,MAX(convert(VARCHAR,A.EXPIRY_DATE,103)) EXPIRY_DATE,
										a.STRIKE_PRICE STRIKE_PRICE,OPTION_TYPE OPTION_TYPE,
										A.SCRIP_NAME SCRIP_NAME ,
										LEFT(BUY_SALE,1) BUY_SALE,
										case when buy_sale = 'buy' then sum(QUANTITY) else 0 end AS BUY_QTY,
										case when buy_sale = 'sale' then sum(QUANTITY) else 0 end AS SALE_QTY,
										'1' CONTRACT_NO,
										(A.STRIKE_PRICE + A.PRICE_PREMIUM)RATE,A.CLIENT_ID CLIENT_ID,C.CLIENT_NAME CLIENT_NAME,
										'PARTICIPANT_CODE' AS PARTICIPANT_CODE
								From 
									Trade1 A, SCRIP_MASTER_TABLE B, Client_Master C
								Where 
										A.Company_Code	=	'#COCD#'
								And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
								And 	A.Client_ID 	<> 	'#CMCode#'
								And		Order_Number	Not Like 'ND%'
								And		A.Scrip_Symbol	=	B.Scrip_Symbol
								And		A.Company_Code	=	C.Company_Code
								And		A.Client_ID		=	C.Client_ID
								And		A.mkt_Type		In	('N','T')
								<CFIF	Trim(BranchList)	NEQ	"">
								And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
								</CFIF>
								<CFIF	Trim(FamilyList)	NEQ	"">
								And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
								</CFIF>
								<CFIF	Trim(ClientList)	NEQ	"">
								And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
								</CFIF>
								<CFIF	Trim(TerminalList)	NEQ	"">
								And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
								</CFIF>
						GROUP BY A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_NAME,TRADE_DATE,BUY_SALE,
								MKT_TYPE,SETTLEMENT_NO,A.STRIKE_PRICE,USER_ID,ISIN,A.INSTRUMENT_TYPE,
								A.OPTION_TYPE,A.OPTION_TYPE,A.CONTRACT_NO,C.CLIENT_NAME,a.SCRIP_NAME,
								a.PRICE_PREMIUM
					</cfquery>
				<cfelse>
					<cfquery name="TRADEDATA1" datasource="#Client.database#">
						SELECT 	MAX(convert(VARCHAR,A.TRADE_DATE,103)) TRADE_DATE,
								MAX(A.TRADE_NUMBER)TRADE_NUMBER,
								MAX(A.INSTRUMENT_TYPE)INSTRUMENT_TYPE,
								MAX(A.SCRIP_SYMBOL)SCRIP_SYMBOL,
								MAX(convert(VARCHAR,A.EXPIRY_DATE,103)) EXPIRY_DATE,
								MAX(A.STRIKE_PRICE) STRIKE_PRICE,MAX(OPTION_TYPE)OPTION_TYPE,
								MAX(A.SCRIP_NAME) SCRIP_NAME ,
								MAX(LEFT(BUY_SALE,1)) BUY_SALE,
								case when buy_sale = 'buy' then sum(QUANTITY) else 0 end AS BUY_QTY,
								case when buy_sale = 'sale' then sum(QUANTITY) else 0 end AS SALE_QTY,
								'1' CONTRACT_NO,
								CAST((sum(quantity*(a.STRIKE_PRICE + a.PRICE_PREMIUM))/sum(quantity)) AS NUMERIC(18,2)) Rate,
								MAX(A.CLIENT_ID) CLIENT_ID,
								MAX(C.CLIENT_NAME) CLIENT_NAME,
								'PARTICIPANT_CODE' AS PARTICIPANT_CODE
						From 
							Trade1 A, SCRIP_MASTER_TABLE B, Client_Master C
						Where 
								A.Company_Code	=	'#COCD#'
						And 	Convert(Datetime, Trade_Date, 103)		=	Convert(Datetime, '#Trade_Date#', 103)
						And 	A.Client_ID 	<> 	'#CMCode#'
						And		Order_Number	Not Like 'ND%'
						And		A.Scrip_Symbol	=	B.Scrip_Symbol
						And		A.Company_Code	=	C.Company_Code
						And		A.Client_ID		=	C.Client_ID
						And		A.mkt_Type		In	('N','T')
						<CFIF	Trim(BranchList)	NEQ	"">
						And		Branch_Code		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#BranchList#', ','))
						</CFIF>
						<CFIF	Trim(FamilyList)	NEQ	"">
						And		Family_Group	In	(SELECT ITEMS FROM FN_GENERATETABLE( '#FamilyList#', ','))
						</CFIF>
						<CFIF	Trim(ClientList)	NEQ	"">
						And		A.Client_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#ClientList#', ','))
						</CFIF>
						<CFIF	Trim(TerminalList)	NEQ	"">
						And		A.USER_ID		In	(SELECT ITEMS FROM FN_GENERATETABLE( '#TerminalList#', ','))
						</CFIF>
				GROUP BY 	A.CLIENT_ID,A.SCRIP_SYMBOL,B.SCRIP_NAME,TRADE_DATE,BUY_SALE,
							MKT_TYPE,SETTLEMENT_NO,USER_ID,ISIN,A.INSTRUMENT_TYPE,
							A.OPTION_TYPE,A.OPTION_TYPE,A.CONTRACT_NO,C.CLIENT_NAME,a.SCRIP_NAME
			</cfquery>
			</cfif>
					<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">
					<CFSET	DateTime			=	TimeFormat(Now(),"HHMMSS")>
					<CFSET	TradeFileName		=	"#COCD#_Rel_#DateTime#">	
					<CFFILE FILE				=	"#TradeFilePath#\#TradeFileName#.CSV" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
					<CFSET 	Struct 				= 	GetMetaData(TRADEDATA1)>
					<CFSET FileStr1 ="">
					<CFSET FilehStr1 ="">
					<CFSET FileStr ="">
					<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
							<CFIF ArrayLen(Struct) eq i>
								<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##">
							<CFELSE>
								<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##,">
							</CFIF>
					</CFLOOP>
					<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
							<CFIF ArrayLen(Struct) eq i>
								<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#">
							<CFELSE>
								<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#,">
							</CFIF>
					</CFLOOP>
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FilehStr1##chr(10)#" ADDNEWLINE="NO">
					<cfloop query="TRADEDATA1">
							<CFSET FileStr = "#FileStr##EVALUATE(DE(FileStr1))##chr(10)#">
			
					</cfloop>
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FileStr#" ADDNEWLINE="NO">
					<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.CSV","C:\#TradeFileName#.CSV")>
					<CENTER>
						<FONT COLOR=BLUE>
							File generated at #TradeFilePath#\<!--- #TradeFileName#.TXT --->
						</FONT>
					</CENTER>
					
					<CFIF Not ClientFileGenerated>
						<CENTER>
							<FONT COLOR=RED>
								File not generated on your machine...
							</FONT>
						</CENTER>
					<CFELSE>
						<CENTER>
							<FONT COLOR=BLUE>
								File generated at Client Machine C:\<!--- #TradeFileName#.TXT --->
							</FONT>
						</CENTER>
					</CFIF>
					<cfabort>
				</CFIF>

	<CFIF	optFileType	eq	"ABN">

			<cfquery name="TRADEDATA1" datasource="#Client.database#">
				EXEC ABN_FILE_GENERATION '#COCD#','#Trade_Date#','#ClientList#'
			</cfquery>

		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">
		<CFSET	DateTime			=	TimeFormat(Now(),"HHMMSS")>
		<CFSET	TradeFileName		=	"#COCD#_ABN_#DateTime#">	
		<CFFILE FILE				=	"#TradeFilePath#\#TradeFileName#.CSV" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFSET 	Struct 				= 	GetMetaData(TRADEDATA1)>
		<CFSET FileStr1 ="">
		<CFSET FilehStr1 ="">
		<CFSET FileStr ="">
		<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
				<CFIF ArrayLen(Struct) eq i>
					<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##">
				<CFELSE>
					<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##,">
				</CFIF>
		</CFLOOP>
		<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
				<CFIF ArrayLen(Struct) eq i>
					<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#">
				<CFELSE>
					<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#,">
				</CFIF>
		</CFLOOP>
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FilehStr1##chr(10)#" ADDNEWLINE="NO">
		<cfloop query="TRADEDATA1">
				<CFSET FileStr = "#FileStr##EVALUATE(DE(FileStr1))##chr(10)#">
		</cfloop>
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FileStr#" ADDNEWLINE="NO">
		<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.CSV","C:\#TradeFileName#.CSV")>
		<CENTER>
			<FONT COLOR=BLUE>
				File generated at #TradeFilePath#\<!--- #TradeFileName#.TXT --->
			</FONT>
		</CENTER>
		<CFIF Not ClientFileGenerated>
			<CENTER>
				<FONT COLOR=RED>
					File not generated on your machine...
				</FONT>
			</CENTER>
		<CFELSE>
			<CENTER>
				<FONT COLOR=BLUE>
					File generated at Client Machine C:\<!--- #TradeFileName#.TXT --->
				</FONT>
			</CENTER>
		</CFIF>
		<cfabort>
	</CFIF>
	
	
		<CFIF	optFileType	eq	"Deals">
			<cfquery name="TRADEDATA1" datasource="#Client.database#">
				EXEC ABN_FILE_GENERATION_Deals '#COCD#','#Trade_Date#','#ClientList#'
			</cfquery>

		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">
		<CFSET	DateTime			=	TimeFormat(Now(),"HHMMSS")>
		<CFSET	TradeFileName		=	"#COCD#_ABN_#DateTime#">	
		<CFFILE FILE				=	"#TradeFilePath#\#TradeFileName#.CSV" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFSET 	Struct 				= 	GetMetaData(TRADEDATA1)>
		<CFSET FileStr1 ="">
		<CFSET FilehStr1 ="">
		<CFSET FileStr ="">
		<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
				<CFIF ArrayLen(Struct) eq i>
					<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##">
				<CFELSE>
					<CFSET FileStr1 = FileStr1&"##"&"Evaluate("&"'##"&"Struct["&i&"].name"&"##'"&")"&"##,">
				</CFIF>
		</CFLOOP>
		<CFLOOP  from="1" to="#ArrayLen(Struct)#" INDEX="i">
				<CFIF ArrayLen(Struct) eq i>
					<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#">
				<CFELSE>
					<CFSET FilehStr1 = "#FilehStr1##Struct[i].name#,">
				</CFIF>
		</CFLOOP>
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FilehStr1##chr(10)#" ADDNEWLINE="NO">
		<cfloop query="TRADEDATA1">
				<CFSET FileStr = "#FileStr##EVALUATE(DE(FileStr1))##chr(10)#">
		</cfloop>
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.CSV" ACTION="append" OUTPUT="#FileStr#" ADDNEWLINE="NO">
		<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.CSV","C:\#TradeFileName#.CSV")>
		<CENTER>
			<FONT COLOR=BLUE>
				File generated at #TradeFilePath#\<!--- #TradeFileName#.TXT --->
			</FONT>
		</CENTER>
		<CFIF Not ClientFileGenerated>
			<CENTER>
				<FONT COLOR=RED>
					File not generated on your machine...
				</FONT>
			</CENTER>
		<CFELSE>
			<CENTER>
				<FONT COLOR=BLUE>
					File generated at Client Machine C:\<!--- #TradeFileName#.TXT --->
				</FONT>
			</CENTER>
		</CFIF>
		<cfabort>
	</CFIF>

	
		<CFIF	optFileType	eq	"Inst">

			<cfquery name="TRADEDATA1" datasource="#Client.database#">
				EXEC ABN_FILE_GENERATION1 '#COCD#','#from_date#','#to_date#','#BranchList#','#FamilyList#','#ClientList#'
			</cfquery>

	 		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">

			<CFIF	TRADEDATA1.RecordCount EQ 0>
				<SCRIPT>alert("No Data Found !!")</SCRIPT>
				<CFABORT>
			</CFIF>
			<CFIF	TRADEDATA1.RecordCount GT 0>
				<CFSET FILENAME1	= "#TRADEDATA1.FILENAME#">
			</CFIF>
			<CFIF #FILENAME1# EQ 'NO DATA FOUND'>
				<SCRIPT>alert("No Data Found !!")</SCRIPT>
				<CFABORT>
			</CFIF>
			<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#FILENAME1#","C:\#FILENAME1#.TXT")>
			<CENTER>
				<FONT COLOR=BLUE>
					File generated at #TradeFilePath#\<!--- #TradeFileName#.TXT --->
				</FONT>
			</CENTER>
			<CFIF Not ClientFileGenerated>
				<CENTER>
					<FONT COLOR=RED>
						File not generated on your machine...
					</FONT>
				</CENTER>
			<CFELSE>
				<CENTER>
					<FONT COLOR=BLUE>
						File generated at Client Machine C:\<!--- #TradeFileName#.TXT --->
					</FONT>
				</CENTER>
			</CFIF>
			<cfabort>
		</CFIF>
				<cfif optFileType	eq	"Royal">
					<cfinclude template="RoyalTradeFile.cfm">
				</cfif>

				<cfif optFileType	eq	"Royal_NEW">
					<cfinclude template="RoyalTradeFile1.cfm">
				</cfif>

				<CFIF	optFileType	eq	"Online">
					<CFSET	NSEData	=	"">
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
					
					<CFLOOP QUERY="selTrades">
	
						<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
							<CFSET	#GetData#	=	Evaluate(GetData)>
						</CFLOOP>
						
						<CFSET	Rate	=	Price_Premium>
						<CFIF Mkt_Type EQ "T">	
							<CFSET Scrip_Type	=	"BE">
						<CFELSEIF  Mkt_Type EQ "N">
							<CFSET Scrip_Type	=	"EQ">
						</CFIF>
						
						<CFIF optRateType EQ "RateWithBrk">
							<CFIF Buy_Sale	EQ	"BUY">
								<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							<CFELSEIF Buy_Sale	EQ	"SALE">
								<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							</CFIF>
						</CFIF>
						
						<CFIF	Buy_Sale EQ "Buy">
							<CFSET BSFlag	=	1>
						<CFELSE>
							<CFSET BSFlag	=	2>
						</CFIF>
					
						<CFSET	NSEData	=	"">				
						<CFSET	NSEData	=	"#REPLaCE(TRADE_NUMBER,'SP111','','ALL')#,11,#SCRIP_SYMBOL#,#Scrip_Type#,#Scrip_Name#,1,1,1,#USER_ID#,10,#BSFlag#,#Quantity#,#Rate#,1,#Client_ID#,#COCD#,N,0,#Settlement_No#,#Trade_DateTime#,#Trade_DateTime#,#Order_Number#,NIL,#Order_DateTime#">
						
						<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
					</CFLOOP>
				</CFIF>


				<CFIF	optFileType	eq	"SONY">
					<CFSET	NSEData	=	"">
					<!--- <CFSET	DateTime			=	DateFormat(Now(),"DDMMMYYYY")>
					<CFSET	TradeFileName1		=	"ClientPanDetail_#DateTime#">	 --->
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
					
					<CFLOOP QUERY="selTrades">
	
						<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
							<CFSET	#GetData#	=	Evaluate(GetData)>
						</CFLOOP>
						
						<CFSET	Rate	=	Price_Premium>
						<CFIF Mkt_Type EQ "T">	
							<CFSET Scrip_Type	=	"BE">
						<CFELSEIF  Mkt_Type EQ "N">
							<CFSET Scrip_Type	=	"EQ">
						</CFIF>
						
						<CFIF optRateType EQ "RateWithBrk">
							<CFIF Buy_Sale	EQ	"BUY">
								<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							<CFELSEIF Buy_Sale	EQ	"SALE">
								<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							</CFIF>
						</CFIF>
						
						<CFIF	Buy_Sale EQ "Buy">
							<CFSET BSFlag	=	1>
						<CFELSE>
							<CFSET BSFlag	=	2>
						</CFIF>
					
						<CFSET	NSEData	=	"">				
						<CFSET	NSEData	=	"#REPLaCE(TRADE_NUMBER,'SP','','ALL')#,11,#SCRIP_SYMBOL#,#Scrip_Type#,#Scrip_Name#,0,1,1,#USER_ID#,0,#BSFlag#,#Quantity#,#Rate#,1,#Client_ID#,#CMCode#,N,0,7,#Trade_DateTime#,#Trade_DateTime#,#Order_Number#,NIL,#Order_DateTime#">
						
						<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
					</CFLOOP>
				</CFIF>

		
				<CFIF	optFileType	eq	"Terminal">
					<CFSET	NSEData	=	"">
					<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
					
					<CFLOOP QUERY="selTrades">
	
						<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
							<CFSET	#GetData#	=	Evaluate(GetData)>
						</CFLOOP>
						
						<CFSET	Rate	=	Price_Premium>
						<CFIF Mkt_Type EQ "T">	
							<CFSET Scrip_Type	=	"BE">
						<CFELSEIF  Mkt_Type EQ "N">
							<CFSET Scrip_Type	=	"EQ">
						</CFIF>
						
						<CFIF optRateType EQ "RateWithBrk">
							<CFIF Buy_Sale	EQ	"BUY">
								<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							<CFELSEIF Buy_Sale	EQ	"SALE">
								<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
							</CFIF>
						</CFIF>
						
						<CFIF	Buy_Sale EQ "Buy">
							<CFSET BSFlag	=	1>
						<CFELSE>
							<CFSET BSFlag	=	2>
						</CFIF>
					
						<CFSET	NSEData	=	"">				
						<CFSET	NSEData	=	"#TRADE_NUMBER#,11,#SCRIP_SYMBOL#,#Scrip_Type#,#Scrip_Name#,1,1,1,#USER_ID#,10,#BSFlag#,#Quantity#,#Rate#,1,#Client_ID#,#COCD#,N,0,#Settlement_No#,#Trade_DateTime#,#Trade_DateTime#,#Order_Number#,NIL,#Order_DateTime#">
						
						<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
					</CFLOOP>
				</CFIF>
			<cfelse>
				<cfif COCD EQ "MCX">
					<cfif optFileType	eq	"Royal">
						<cfinclude template="RoyalTradeFile.cfm">
					<cfelseif optFileType	eq	"Royal_NEW">
						<cfinclude template="RoyalTradeFile1.cfm">
					<cfelse>
						<CFSET	NSEData	=	"">
						<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
						
						<CFLOOP QUERY="selTrades">
		
							<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
								<CFSET	#GetData#	=	Evaluate(GetData)>
							</CFLOOP>
							
							<CFSET	Rate	=	Price_Premium>
							
							<CFIF optRateType EQ "RateWithBrk">
								<CFIF Buy_Sale	EQ	"BUY">
									<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
								<CFELSEIF Buy_Sale	EQ	"SALE">
									<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
								</CFIF>
							<cfelse>
								<CFSET	Rate	=	NumberFormat( (Price_Premium), "999999.99")>	
							</CFIF>
							<CFIF TRIM(OPTION_TYPE) EQ "">
								<CFSET OPTION_TYPE1 = "XX">
							<cfelse>
								<CFSET OPTION_TYPE1 = "#OPTION_TYPE#">	
							</CFIF>
							<CFIF	Buy_Sale EQ "Buy">
								<CFSET BSFlag	=	1>
							<CFELSE>
								<CFSET BSFlag	=	2>
							</CFIF>
							<CFSET	NSEData	=	"">				
							<CFSET	NSEData	=	"#TRADE_NUMBER#,11,4,#INSTRUMENT_TYPE#,#POSITION_SYMBOL#,#EXP_DATE#,,,#Scrip_NAME#,1,RL,1,#BROKER_CODE#,#USER_ID#,#BSFlag#,#NEWQTY#,#Rate#,1,#Client_ID#,#BROKER_CODE#, , , ,#TRDDATETIME#,#ORDER_NUMBER#,">
							
							<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
						</CFLOOP>
					</cFIF>	
				<cfelseif COCD EQ "NCDEX">
					<cfif optFileType	eq	"Royal">
						<cfinclude template="RoyalTradeFile.cfm">
					<cfelseif optFileType	eq	"Royal_NEW">
						<cfinclude template="RoyalTradeFile1.cfm">	
					<cfelse>
						<CFSET	NSEData	=	"">
						<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
						
						<CFLOOP QUERY="selTrades">
		
							<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
								<CFSET	#GetData#	=	Evaluate(GetData)>
							</CFLOOP>
							
							<CFSET	Rate	=	NEWRATE>
							
							<CFIF optRateType EQ "RateWithBrk">
								<CFIF Buy_Sale	EQ	"BUY">
									<CFSET	Rate	=	NumberFormat( (NEWRATE + (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
								<CFELSEIF Buy_Sale	EQ	"SALE">
									<CFSET	Rate	=	NumberFormat( (NEWRATE - (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
								</CFIF>
							<cfelse>
								<CFSET	Rate	=	NumberFormat( (NEWRATE), "999999.99")>	
							</CFIF>
							<CFIF TRIM(OPTION_TYPE) EQ "">
								<CFSET OPTION_TYPE1 = "XX">
							<cfelse>
								<CFSET OPTION_TYPE1 = "#OPTION_TYPE#">	
							</CFIF>
							<CFIF	Buy_Sale EQ "Buy">
								<CFSET BSFlag	=	1>
							<CFELSE>
								<CFSET BSFlag	=	2>
							</CFIF>
							<CFSET	NSEData	=	"">				
							<CFSET	NSEData	=	"#TRADE_NUMBER#,11,#SCRIP_NAME#,#INSTRUMENT_TYPE#,#TRIM(EXP_DATE)#,#STRIKE_PRICE#,#OPTION_TYPE1#,#Scrip_SYMBOL#,1,1,#USER_ID#,1,#BSFlag#,#Quantity#,#Rate#,1,#Client_ID#,#BROKER_CODE#,10,#TRDDATETIME#,#TRDDATETIME#,#ORDER_NUMBER#,NIL">
							
							<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
						</CFLOOP>
					</cfif>	
				<cfelse>

		<CFIF	optFileType	eq	"FT_RM">
			<cfquery name="TRADEDATAFT_RM" datasource="#Client.database#">
			<CFIF optRateType EQ "RateWithBrk">
				EXEC FT_RM '#COCD#','#from_date#','#to_date#','#BranchList#','#FamilyList#','#ClientList#','Yes'
			<CFELSE>
				EXEC FT_RM '#COCD#','#from_date#','#to_date#','#BranchList#','#FamilyList#','#ClientList#','No'
			</CFIF>	
			</cfquery>

	 		<CFSET	TradeFilePath		=	"C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles">

			<CFIF	TRADEDATAFT_RM.RecordCount EQ 0>
				<SCRIPT>alert("No Data Found !!")</SCRIPT>
				<CFABORT>
			</CFIF>
			<CFIF	TRADEDATAFT_RM.RecordCount GT 0>
				<CFSET FILENAME1	= "#TRADEDATAFT_RM.FILENAME#">
			</CFIF>
			<CFIF #FILENAME1# EQ 'NO DATA FOUND'>
				<SCRIPT>alert("No Data Found !!")</SCRIPT>
				<CFABORT>
			</CFIF>
			<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#FILENAME1#","C:\#FILENAME1#")>


			<CENTER>
				<FONT COLOR=BLUE>
					File generated at #FILENAME1#
				</FONT>
			</CENTER>
			<CFIF Not ClientFileGenerated>
				<CENTER>
					<FONT COLOR=RED>
						File not generated on your machine...
					</FONT>
				</CENTER>
			<CFELSE>
				<CENTER>
					<FONT COLOR=BLUE>
						File generated at Client Machine #FILENAME1#<!--- #TradeFileName#.TXT --->
					</FONT>
				</CENTER>
			</CFIF>
			<cfabort>
		</CFIF>

					<cfif optFileType	eq	"Royal">
						<cfinclude template="RoyalTradeFile.cfm">
					<cfelseif optFileType	eq	"Royal_New">
						<cfinclude template="RoyalTradeFile1.cfm">	
					<cfelse>
						<CFSET	NSEData	=	"">
						<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
						
						<CFLOOP QUERY="selTrades">
		
							<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
								<CFSET	#GetData#	=	Evaluate(GetData)>
							</CFLOOP>
							
							<CFSET	Rate	=	Price_Premium>
							
							<CFIF optRateType EQ "RateWithBrk">
								<CFIF Buy_Sale	EQ	"BUY">
									<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
								<CFELSEIF Buy_Sale	EQ	"SALE">
									<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.99")>
								</CFIF>
							<cfelse>
								<CFSET	Rate	=	NumberFormat( (Price_Premium), "999999.99")>	
							</CFIF>
							<CFIF TRIM(OPTION_TYPE) EQ "">
								<CFSET OPTION_TYPE1 = "XX">
							<cfelse>
								<CFSET OPTION_TYPE1 = "#OPTION_TYPE#">	
							</CFIF>
							<CFIF	Buy_Sale EQ "Buy">
								<CFSET BSFlag	=	1>
							<CFELSE>
								<CFSET BSFlag	=	2>
							</CFIF>
							<CFSET	NSEData	=	"">				
							<CFSET	NSEData	=	"#TRADE_NUMBER#,11,#SCRIP_NAME#,#INSTRUMENT_TYPE#,#EXP_DATE#,#STRIKE_PRICE#,#OPTION_TYPE1#,#Scrip_SYMBOL#,1,1,#USER_ID#,10,#BSFlag#,#Quantity#,#Rate#,1,#Client_ID#,#BROKER_CODE#,10,#TRDDATETIME#,#ORDERDATETIME#,#ORDER_NUMBER#,NIL,#ORDERDATETIME#">
							
							<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
						</CFLOOP>	
					</cfif>
				</cfif>	
			</cfif>
				
			

			<cfif optFileType	eq	"Royal">
				<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.TXT","C:\CPS\#TradeFileName#.txt")>
			<cfelseif optFileType	eq	"Royal_New">
				<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.TXT","C:\CPS\#TradeFileName#.txt")>
			<cfelse>
				<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.TXT","C:\#TradeFileName#.txt")>
			</cfif>
			<!--- <cfif optFileType	eq	"Royal">
				<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.TXT","C:\CPS\#TradeFileName#.txt")>
			<cfelse>
				<CFSET	ClientFileGenerated	=	CopyFile("#TradeFilePath#\#TradeFileName#.TXT","C:\#TradeFileName#.txt")>
			</cfif> --->
			
			<cfif optFileType	eq	"Royal" and (cocd eq "Nse_fno" OR cocd eq "MCX" OR cocd eq "NCDEX" OR cocd eq "cd_nse") >
				<CFSET	ClientFileGenerated1	=	CopyFile("C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt","C:\CPS\#cocd#_MTM_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt")>
			</cfif>
			
			<cfif optFileType	eq	"Royal_New" and (cocd eq "Nse_fno" OR cocd eq "MCX" OR cocd eq "NCDEX" OR cocd eq "cd_nse") >
				<CFSET	ClientFileGenerated1	=	CopyFile("C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt","C:\CPS\#cocd#_MTM_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt")>
			</cfif>

		</CFLOOP>
		
		<CENTER>
			<FONT COLOR=BLUE>
				File generated at #TradeFilePath#\<!--- #TradeFileName#.TXT --->
			</FONT>
		</CENTER>
		
		<CFIF Not ClientFileGenerated>
			<CENTER>
				<FONT COLOR=RED>
					File not generated on your machine...
				</FONT>
			</CENTER>
		<CFELSE>
			<CENTER>
				<FONT COLOR=BLUE>
					File generated at Client Machine C:\<!--- #TradeFileName#.TXT --->
				</FONT>
			</CENTER>
		</CFIF>
</div>


</CFOUTPUT>
</body>
</html>

