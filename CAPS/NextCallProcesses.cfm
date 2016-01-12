<html>
<head>
	<title> Process Parameter Screen. </title>
	<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<link href="/FOCAPS/CSS/Bill.css" type="text/css" rel="stylesheet">
 </head>
  
 <CFOUTPUT>
 <body leftmargin="0" rightmargin="0"  >
	<CFFORM name="CallForm" target="Econ" action="NextCallProcesses2.cfm?#Query_String#" method="POST" >
 
		<input type="Hidden" name="COCD" value="#COCD#">
		<input type="Hidden" name="COName" value="#COName#">
		<input type="Hidden" name="Market" value="#Market#">
		<input type="Hidden" name="Exchange" value="#Exchange#">
		<input type="Hidden" name="Broker" value="#Broker#">
		<input type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
		<input type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">
		<input type="Hidden" name="hidBtn" value="false">
		<cfparam  default="" name="BillCancle">
		<input type="hidden" name="BillCancle" value="#BillCancle#">
		<cftry>
			<CFQUERY NAME="GetSysParam" datasource="#Client.database#" DBTYPE="ODBC">
				drop table ##VALANDATA12
			</CFQUERY>
		<cfcatch></cfcatch>
		</cftry>
		<cftry>
			<CFQUERY NAME="GetSysParam" datasource="#Client.database#" DBTYPE="ODBC">
				drop table ##SETL_PAYIN_999
			</CFQUERY>
		<cfcatch></cfcatch>
		</cftry>
		<cftry>
			<CFQUERY NAME="GetSysParam" datasource="#Client.database#" DBTYPE="ODBC">
				drop table ##SETL_PAYIN
			</CFQUERY>
		<cfcatch></cfcatch>
		</cftry>
		<CFQUERY NAME="GetPayIn" datasource="#Client.database#" DBTYPE="ODBC">
			SELECT	A.COMPANY_CODE,A.CLIENT_ID,
					 TRADE_DATE,A.MKT_TYPE,A.SETTLEMENT_NO,
					CASE WHEN BUY_SALE ='BUY' THEN CAST(SUM(QUANTITY * (PRICE_PREMIUM )) AS NUMERIC(30,2)) ELSE CAST(0 AS NUMERIC(30,2)) END AS BUY_AMOUNT_ACK,
					CASE WHEN BUY_SALE ='SALE' THEN CAST(SUM(QUANTITY * (PRICE_PREMIUM )) AS NUMERIC(30,2)) ELSE CAST(0 AS NUMERIC(30,2)) END AS SALE_AMOUNT_ACK,
					CAST(0.00 AS NUMERIC(30,2)) TOC, 
					CAST(0.00 AS NUMERIC(30,2)) STT
			 INTO	##SETL_PAYIN_999
			
			FROM 
					TRADE1 A, CLIENT_MASTER B,SYSTEM_SETTINGS C
			WHERE
					A.COMPANY_CODE	=	B.COMPANY_CODE
			and		A.CLIENT_ID		=	B.CLIENT_ID
			AND		B.CLIENT_ID		<>	C.CLEARING_MEMBER_CODE
			AND		b.COMPANY_CODE	=	c.COMPANY_CODE
			and		a.COMPANY_CODE ='#cocd#'
			<Cfif mkt_type eq 'N,T'>
				AND		mkt_type in('n','t')
			<cfelse>
				AND		mkt_type in('#mkt_type#')
			</Cfif>
			AND		SETTLEMENT_NO ='#SETTLEMENT_NO#'
			GROUP BY A.COMPANY_CODE,A.CLIENT_ID,TRADE_DATE,	A.MKT_TYPE,A.SETTLEMENT_NO,BUY_SALE
			
			select	COMPANY_CODE,CLIENT_ID,
					 TRADE_DATE,MKT_TYPE,SETTLEMENT_NO,
					 SUM(BUY_AMOUNT_ACK) BUY_AMOUNT_ACK,
					SUM(SALE_AMOUNT_ACK) SALE_AMOUNT_ACK,
					CAST(0.00 AS NUMERIC(30,2)) TOC, 
					CAST(0.00 AS NUMERIC(30,2)) STT
			INTO	##SETL_PAYIN
			 FROM ##SETL_PAYIN_999 A
			GROUP BY COMPANY_CODE,CLIENT_ID,
					 TRADE_DATE,MKT_TYPE,SETTLEMENT_NO
			
			UPDATE ##SETL_PAYIN
			SET		TOC	=	B.TOC,
					STT =	B.STT
			FROM
					##SETL_PAYIN A,TRADE_TO_ACCOUNTS B
			WHERE
					A.COMPANY_CODE	=	B.COMPANY_CODE
			AND		A.CLIENT_ID		=	B.CLIENT_ID
			AND		A.MKT_TYPE		=	B.MKT_TYPE
			AND		A.SETTLEMENT_NO	=	B.SETTLEMENT_NO 
			
			SELECT	COMPANY_CODE,TRADE_DATE,MKT_TYPE,SETTLEMENT_NO,
					CAST(SUM(SALE_AMOUNT_ACK - (BUY_AMOUNT_ACK+TOC+STT)) AS NUMERIC(30,2)) AMOUNT
			INTO ##VALANDATA12
			FROM
					 ##SETL_PAYIN
			GROUP BY	COMPANY_CODE,TRADE_DATE,MKT_TYPE,SETTLEMENT_NO
			
			
			select * from ##VALANDATA12
		</CFQUERY>
		<table align="center" border="1" cellpadding="0" cellspacing="0" class="StyleTable1">
			<tr >
				<th width="40%" align="center" colspan="5">Payin/Payout Detail</th>
			</tr>
			<tr >
				<th width="10%" align="Right">Date</th>
				<th align="Right">MktType</th>
				<th align="Right">Settlement No</th>
				<th align="Right">PayIn</th>
				<th align="Right">PayOut</th>
			</tr>
		<cfloop query="GetPayIn">
			<tr >
				<td  width="10%" align="Right">#DateFormat(Trade_date,'DD/MM/YYYY')#</th>
				<td  width="10%" align="Right">#Mkt_type#</th>
				<td   width="10%" align="Right">#Settlement_no#</th>
				<td  width="10%" align="Right"><Cfif AMOUNT lt 0 >#abs(AMOUNT)#</Cfif>&nbsp;</th>
				<td   width="10%" align="Right"><Cfif AMOUNT gte 0 >#abs(AMOUNT)#</Cfif>&nbsp;</th>
			</tr>
		</cfloop>
		</table>
		<CFQUERY NAME="GetSysParam" datasource="#Client.database#" DBTYPE="ODBC">
			Select	
					IsNull(FLG_PositionShift, 'Y')FLG_PositionShift,
					IsNull(FLG_STTCalculation, 'I')FLG_STTCalculation,
					IsNull(JV_PostingDate, 'ToDate')JV_PostingDate
			From
					SYSTEM_SETTINGS
			Where
					Company_Code	=	'#COCD#'		
		</CFQUERY>
		<CFSET	PositionShift	=	GetSysParam.FLG_PositionShift>
		<CFSET	STTMethod		=	GetSysParam.FLG_STTCalculation>
		<CFSET	JV_PostingDate	=	GetSysParam.JV_PostingDate>
		
		<input type="hidden" name="Trade_Date" value="#Trade_Date#">
		<input type="hidden" name="Settlement_No" value="#Settlement_No#">
		<input type="hidden" name="Mkt_Type" value="#Mkt_Type#">



 		<table align="center" border="0"  cellpadding="0" cellspacing="0" class="StyleTable1">
			<tr id="row0">
				<th align="Right">&nbsp;  </th>
			</tr>
			<tr id="row0">
				<th align="Right">&nbsp;  </th>
			</tr>
			
			<tr id="row0">
				<th align="Right"> Market-Type : &nbsp; </th>
				<th align="Left">
					#Trim(Mkt_Type)# 
				</th>
			</tr>
			

			<tr id="row1">
				<th align="Right"> Settlement-No : &nbsp; </th>
				<th align="Left">
 					#Settlement_No#
 				</th>
			</tr>
			
			<tr id="row2">
				<th align="Right"> Date : &nbsp; </th>
				<th align="Left">
					#Trade_Date#
				</th>
			</tr>
			<tr id="row0">
				<th align="Right">&nbsp;  </th>
			</tr>
			<tr id="row0">
				<th align="Right">&nbsp;  </th>
			</tr>
			 
			<label for="PrSTT">
				<tr id="rowPrSTT" style="Cursor : Default;">
					<th colspan="2" align="left" Class="StyleLabel2">
						<input type="Checkbox" name="EContract" value="1"  id="EContract">
						E-Contract HTML File Generate
					</th>
				</tr>
			</label>
			<!--- <tr id="rowPrBRKST" style="Cursor : Default;">
				<th colspan="2" align="left" Class="StyleLabel2">
					<label for="PrBRKST">
						<input type="Checkbox" name="Replication" value="1"  id="Replication">
						Start Replication 
					</label><br>
					</th>
			</tr> --->
			<tr id="rowPrBRKST" style="Cursor : Default;">
				<th colspan="2" align="left" Class="StyleLabel2">
					<label for="PrBRKST">
						<input type="Checkbox" name="SMS1" value="1"  id="SMS1">
							SMS &nbsp;
						<SELECT NAME="Suada" CLASS="StyleListBox" style="border: thin none Navy; color: Orange; font-family: Arial; font-size: 8pt; font-weight: bold;">
								<OPTION VALUE="SPB">Suda Sumamry + Bill Amount</OPTION>
								<OPTION VALUE="SPL">Suda Sumamry + Ledger</OPTION>
								<OPTION VALUE="B" >Bill Amount</OPTION>
								<OPTION VALUE="S" >Suada Sumamry </OPTION>
						</SELECT>
					</label><br>
					</th>
			</tr>
			<!--- <tr id="rowPrBRKST" style="Cursor : Default;">
				<th colspan="2" align="left" Class="StyleLabel2">
					<label for="PrBRKST">
						<input type="Checkbox" name="BenTomarket" value="1"  id="BenTomarket">
						Ben To Market
					</label><br>
					</th>
			</tr>
			<tr id="rowPrBRKST" style="Cursor : Default;">
				<th colspan="2" align="left" Class="StyleLabel2">
					<label for="PrBRKST">
						<input type="Checkbox" name="EarlyPayin" value="1"  id="EarlyPayin">
						Early payIn To Exchange
					</label><br>
					</th>
			</tr>
			<tr id="rowPrBRKST" style="Cursor : Default;">
				<th colspan="2" align="left" Class="StyleLabel2">
					<label for="PrBRKST">
						<input type="Checkbox" name="PoaToMarkt" value="1"  id="PoaToMarkt">
						POA To Market
					</label><br>
					</th>
			</tr> --->
			<tr id="row0">
				<th align="Right">&nbsp;  </th>
			</tr>
			<tr id="row6">
				<th colspan="2" align="Right">
					<input type="submit" name="Ok" value="Process" class="StyleSmallButton1" id="btnProcess" accesskey="P"  >
				</th>	
			</tr>
		</table>

		<table width="100%" align="center" border="0"  cellpadding="0" cellspacing="0" class="StyleTable1">
			<tr>
				<th colspan="2" align="Right">
					<iframe height="200" width="100%" name="Econ"/>
				</th>	
			</tr>
		</table>
		 			
	</CFFORM>
 
</body>
</CFOUTPUT>

</html>