
<HTML>
<HEAD>
<TITLE>UCI File Generation</TITLE>
	<LINK href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
	<!-- <link href="../../CSS/DynamicCSS.css" type="text/css" rel="stylesheet"> -->
<!--- 	<link href="../../CSS/Bill.css" type="text/css" rel="stylesheet"> --->
<LINK href="../../CSS/style.css" rel="stylesheet" type="text/css">
	<SCRIPT SRC="../../Scripts/ScrollTable.js"></SCRIPT>
</HEAD>
<SCRIPT>

function CloseWindow()
{
	try
	{
		if( typeof( HelpWindow ) == "object" && !HelpWindow.closed )
		{
			HelpWindow.close();
			throw "e";
		}
	}
	catch( e )
	{
		return( e );
	}
}

function OpenWindow( form, par )
{
	with( frmUCI )
	{
		
		HelpWindow = open( "/FOCAPS/HelpSearch/TradingClients.cfm?COCD=" +COCD.value +"&COName=" +COName.value +"&Market=" +Market.value +"&Exchange=" +Exchange.value +"&Broker=" +Broker.value +"&FinStart=" +FinStart.value +"&FinEnd=" +FinEnd +"&Mkt_Type=&Settlement_No=0&HelpFor=Client&title=Client-ID Help","ClientIDHelpWindow", "Top=0, Left=0, Width=700, Height=525, AlwaysRaised=Yes, Resizeable=No" );
	}
}


function showdetails(cld,market)
{
	with( frmUCI )
	{		
	  HelpWindow = open( "UCIClientDetails.cfm?ClientID="+cld+"&market="+market+"&COCD=" +COCD.value,"BenkHelp", "width=400, height=500, scrollbar=Yes, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no"  );
	}  
}
	function checkall(frm)
	{
		with(eval(frm))
		{
			if(txtDate.value=='')
			{
				alert("Please enter From Date");
				return false;
			}
			if(txtToDate.value=='')
			{
				alert("Please enter From To Date");
				return false;
			}
		}
	}
	function CheckUncheckAll(form,count,chk)
	{
		with(form)
		{
			if(chk==true)
			{
				for(var i=1;i<=count;i++)
				{
					var obj='chk'+i;
					eval(obj).checked=true;
					
				}
			}
			else
			{
				for(var i=1;i<=count;i++)
				{
					var obj='chk'+i;
					eval(obj).checked=false;
				}
			}
		}
	}
	function generateReport_All(form,count,filefor)
	{

		var chkobj='';
		var chkval='';
		var companyval='';
		
		with(form)
		{
			var commonParam="COCD="+COCD.value+"&CoName=" +COName.value +"&StYr=" +FinStart.value +"&EndYr=" +FinEnd.value;
			chkval1='';
			for (var i=1 ;i<=count; i++)
			{
				var obj='chk'+i;
				var companyccd='companychk'+i;
				if(eval(obj).checked==true)
				{
					chkval=chkval+"'"+eval(obj).value+"',";
					companyval=companyval+"'"+eval(companyccd).value+"',";
					if(eval(companyccd).value == 'BSE_CASH')
						chkval1=chkval1+eval(obj).value+",";
				}
				
			}
			if(chkval == '')
			{
				alert('Please Select At least one Record to Proceed Further');
				return false;
			}
			/*if(Brokerage.checked==true)
			{
				Brokerage2="Y"
			}
			else
			{
				Brokerage2="N"
			}
			var chkClient="";
			if(document.frmUCI.chkClient(0).checked==true)
			{
				chkClient="Trd"
			}
			else
			{
				chkClient="New"
			}*/
			action ="AllUCC.cfm?filefor="+CmbFileOption.value+"&batchNoFront="+document.frmUCI.txtBatchNo.value+"&";
			target = "FileGeneration123";
			target="_self";
			submit();
			action="UCI_File_Generation.cfm"
			
		}
		//FileGeneration.location.href="generateUCINEW3.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&sr="+document.frmUCI.Sr.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2+"&chkval1="+chkval1;
	} 
function generateReport(form,count,filefor)
	{
		//var commonParam="COCD="+cocd.value+"&CoName=" +coname.value +"&CoGroup=" +CoGroup.value +"&StYr=" +StYr.value +"&EndYr=" +EndYr.value;
		var chkobj='';
		var chkval='';
		var companyval='';
		
		
		with(form)
		{
			var commonParam="COCD="+COCD.value+"&CoName=" +COName.value +"&StYr=" +FinStart.value +"&EndYr=" +FinEnd.value;
			chkval1='';
			for (var i=1 ;i<=count; i++)
			{
				var obj='chk'+i;
				var companyccd='companychk'+i;
				if(eval(obj).checked==true)
				{
					chkval=chkval+"'"+eval(obj).value+"',";
					companyval=companyval+"'"+eval(companyccd).value+"',";
					if(eval(companyccd).value == 'BSE_CASH')
						chkval1=chkval1+eval(obj).value+",";
				}
				
			}
			if(chkval == '')
			{
				alert('Please Select At least one Record to Proceed Further');
				return false;
			}
			if(Brokerage.checked==true)
			{
				Brokerage2="Y"
			}
			else
			{
				Brokerage2="N"
			}
		}
		var chkClient="";
		if(document.frmUCI.chkClient(0).checked==true)
		{
			chkClient="Trd"
		}
		else
		{
			chkClient="New"
		}

		if (filefor=='Old')
		{
			FileGeneration.location.href="generateUCI.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2;
		}
		else if (filefor=='New1')
		{
			FileGeneration.location.href="generateUCINEW1.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2;
		}
		else if (filefor=='New2')
		{
			FileGeneration.location.href="generateUCINEW2.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2;
		}
		else if (filefor=='New3')
		{
			FileGeneration.location.href="generateUCINEW3.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&sr="+document.frmUCI.Sr.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2+"&chkval1="+chkval1;
		}
		else if (filefor=='BM')
		{
			FileGeneration.location.href="generateUCIBulkMod.cfm?"+commonParam+"&chkval="+chkval+"&companyval="+companyval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2;
		}
		else if (filefor=='BM')
		{
			FileGeneration.location.href="generateUCIBulkMod.cfm?"+commonParam+"&chkval="+chkval+"&companyval="+companyval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2;
		}
		else if (filefor=='AI')
		{
			FileGeneration.location.href="generateUCIAI.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2;
		}
		else
		{
			FileGeneration.location.href="generateUCINew.cfm?"+commonParam+"&chkval="+chkval+"&batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&chkClient="+chkClient+"&BROKERAGE1="+Brokerage2;		
		}	
	} 
function validatecheck(frm,CID,chkname,chk)
{
	with(frm)
	{
		if(chk==true)
		{
			//FileGeneration.location.href="ValidateUCI.cfm?batchNo="+document.frmUCI.txtBatchNo.value+"&frdate="+document.frmUCI.txtDate.value+"&todate="+document.frmUCI.txtToDate.value+"&market="+document.frmUCI.cmbmarket.value+"&ClientID="+CID+"&chkname="+chkname;
		}
			
	}	
}
function CheckUncheck(objname,chk)
{
	with(frmUCI)
	{
		if(objname=='chkTrdClient' && chk==true)
		{
			chkNewClient.checked=false;
			chkTrdClient.checked=true;
		}
		else
		{
			chkNewClient.checked=true;
			chkTrdClient.checked=false;
		}
	}
}
	
</SCRIPT>
<BODY topmargin="0">
<CENTER>

<FORM NAME="frmUCI"   ACTION="UCI_File_Generation.cfm" METHOD="POST">

<CFOUTPUT>

	<INPUT type="Hidden" name="COCD" value="#COCD#">
	<INPUT type="Hidden" name="COName" value="#COName#">
	<INPUT type="Hidden" name="Market" value="#Market#">
	<INPUT type="Hidden" name="Exchange" value="#Exchange#">
	<INPUT type="Hidden" name="Broker" value="#Broker#">
	<INPUT type="Hidden" name="FinStart" value="#Val(Trim(FinStart))#">
	<INPUT type="Hidden" name="FinEnd" value="#Val(Trim(FinEnd))#">


  <CFQUERY NAME="getnsecompany" datasource="#Client.database#" DBTYPE="ODBC">
 		SELECT * FROM COMPANY_MASTER WHERE EXCHANGE='NSE' 
  </CFQUERY>	
  <cftry>
		<CFQUERY Name="GETCLIENTLIST" datasource="#Client.database#" DBType="ODBC">
			drop table ##KYC_EnteryScreen
		</CFQUERY>
	<cfcatch>
	</cfcatch>
	</cftry>
	<cftry>
	<CFQUERY Name="ClientList" datasource="#Client.database#" DBType="ODBC">
	drop table ##CLIENT_MASTER_cOMPANY
	</CFQUERY>
<cfcatch>
</cfcatch>
</cftry>
<CFQUERY Name="ClientList" datasource="#Client.database#" DBType="ODBC">
	SELECT COMPANY_CODE,CLIENT_ID INTO 
	##CLIENT_MASTER_cOMPANY
	FROM CLIENT_MASTER
</CFQUERY>
<CFIF IsDefined('btnView')>		

	<cfquery name="GetName" datasource="#Client.database#">
		select ltrim(rtrim(CHEKERUSERLIST)) CHEKERUSERLIST
			from system_settings
		where company_code = '#cocd#'
	</cfquery>
	<cfif CmbOption neq "AI">
  <CFQUERY NAME="GETCLIENTLIST" datasource="#Client.database#" DBTYPE="ODBC">
 		<!--- <CFIF IsDefined('chkTrdClient')> --->
		
		
		SELECT  
			max(CASE WHEN A.Company_Code ='BSE_CASH' THEN A.Company_Code ELSE NULL END ) BSECOCD ,
			A.CLIENT_ID,MAX(A.CLIENT_NAME) CLIENT_NAME,MAX(B.MARKET) MARKET,'' COMPANY_CODE,A.BRANCH_CODE
		,MAX(A.REGISTRATION_DATE) REGISTRATION_DATE,CONVERT(DATETIME, CONVERT(VarChar(10), MAX(A.REGISTRATION_DATE) , 103), 103) REGISTRATION_DATE1,
		MAX(A.LAST_MODIFIED_DATE) LAST_MODIFIED_DATE,'Y' TRDFLG ,ISNULL(MAX(PANNO),'')PANNO,'' active_inactive
		,CAST('' AS VARCHAR(100)) NSE ,
		CAST('' AS VARCHAR(100)) BSE ,
		CAST('' AS VARCHAR(100)) MSX ,
		CAST('' AS VARCHAR(100)) MCX ,
		CAST('' AS VARCHAR(100)) NCX ,
		CAST('' AS VARCHAR(100)) OTH 
		
		into ##KYC_EnteryScreen 
		FROM CLIENT_MASTER A LEFT OUTER JOIN CLIENT_DETAIL_VIEW B
		ON  A.CLIENT_ID=B.CLIENT_ID
		AND A.COMPANY_CODE=B.COMPANY_CODE
		--AND B.EXCHANGE='NSE'
		LEFT OUTER JOIN COMPANY_MASTER C ON
		A.COMPANY_CODE=C.COMPANY_CODE LEFT OUTER JOIN PAN_NO_DETAILS D ON
		B.PAN_NO = D.PANNO
		WHERE 1 = 1
		<CFIF cmbmarket nEQ 'All'>
			AND A.COMPANY_CODE IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE EXCHANGE='NSE') 
		<cfelse>
			AND A.COMPANY_CODE IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE company_code in ('BSE_CASH','BSE_FNO','CD_BSE','CD_MCX','CD_NSE','MCX','MCX_CASH','MCX_FNO','NCDEX','NSE_CASH','NSE_FNO'))
		</CFIF>
		<cfif CmbOption eq "New">
			<CFIF IsDefined('txtDate') And Trim(txtDate) is not "" and IsDefined('txtToDate') And Trim(txtToDate) is not "">
			AND (
					CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
					and CONVERT(DATETIME,'#txtToDate#',103) 
					AND ISNULL(UCC_STATUS,'') =''
				)
			</CFIF>
		<cfelse>
			<CFIF IsDefined('txtDate') And Trim(txtDate) is not "" and IsDefined('txtToDate') And Trim(txtToDate) is not "">
				AND A.CLIENT_ID IN (SELECT CLIENT_ID
									FROM AUDITEDDATA
									WHERE
										COLUMN_NAME IN ('RESI_ADDRESS','CITY','EMAIL_ID','STATE','COUNTRY','PINCODE','RESI_TEL_NO','MOBILE_NO','TypeOfFacility','MasterPan','RelationShip','UpdationFlag','CIN','ANNUAL_INCOME')
									AND TABLE_NAME IN ('CLIENT_MASTER','CLIENT_DETAILS')
									AND CONVERT(DATETIME,CONVERT(VARCHAR(10),UPDATETIME,103),103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) AND CONVERT(DATETIME,'#txtToDate#',103)

									UNION ALL
									SELECT ACCOUNT_CODE
									FROM 
										FA_CLIENT_BANK_DETAILS
									WHERE 
										CONVERT(DATETIME,CONVERT(VARCHAR(10),INSERTED_DATE,103),103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) AND CONVERT(DATETIME,'#txtToDate#',103)
									UNION ALL
									SELECT ACCOUNT_CODE
									FROM 
										FA_CLIENT_BANK_DETAILS_HISTORY
									WHERE 
										CONVERT(DATETIME,CONVERT(VARCHAR(10),CHANGETIME,103),103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) AND CONVERT(DATETIME,'#txtToDate#',103)
									AND FULLUPDATE = 'Y'
								)	
				AND NOT (
						CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
						and CONVERT(DATETIME,'#txtToDate#',103) 
						AND ISNULL(UCC_STATUS,'') =''
						)
			<!--- AND (
					CONVERT(DATETIME, CONVERT(VarChar(10), A.LAST_MODIFIED_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
					and CONVERT(DATETIME,'#txtToDate#',103) 					
				) --->
			</CFIF>	
		</cfif>
		
		<cfif cmbmarket neq "All">
			<cfif cmbmarket eq "">
				AND b.market IN ('CAPS','FO')
				AND A.COMPANY_CODE  IN ('NSE_CASH','NSE_FNO','CD_NSE')
			<cfelse>
				and b.market='#cmbmarket#'
			</cfif>
		<cfelse>
			AND A.COMPANY_CODE IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE company_code in ('BSE_CASH','BSE_FNO','CD_BSE','CD_MCX','CD_NSE','MCX','MCX_CASH','MCX_FNO','NCDEX','NSE_CASH','NSE_FNO'))
		</cfif>

		<cfif cmbmarket neq "All" AND TRIM(cmbmarket) Neq "">
			<cfif cocd eq 'cd_nse'>
				and ISNULL(C.FLG_NCX,'N') = 'CD'
			<CFELSE>
				and ISNULL(C.FLG_NCX,'N') = 'N'
			</cfif>
		</cfif>	
		and A.CLIENT_ID IN(SELECT DISTINCT CLIENT_ID FROM TRADE1 WHERE COMPANY_CODE=A.COMPANY_CODE
		AND CONVERT(DATETIME,TRADE_DATE,103)  BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
				and CONVERT(DATETIME,'#txtToDate#',103)) 
		<CFIF IsDefined("FromClient") and FromClient neq ''>
			and a.CLIENT_ID IN ('#Replace(FromClient,",","','","ALL")#')
		</CFIF>
		<CFIF IsDefined("FromBRANCH") and FromBRANCH neq ''>
			and a.BRANCH_CODE IN ('#Replace(FromBRANCH,",","','","ALL")#')
		</CFIF>
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(A.CHEKING,'N') = 'Y'
		</cfif>		
		AND A.CLIENT_ID IN(SELECT DISTINCT CLIENT_ID FROM BROKERAGE_APPLY WHERE COMPANY_CODE=A.COMPANY_CODE
							AND ACTIVE_INACTIVE ='A'
							AND ISNULL(END_DATE ,'') = ''
								<Cfif IsDefined("Brokerage")>
									AND CONVERT(DATETIME, START_DATE, 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
										and CONVERT(DATETIME,'#txtToDate#',103) 
								</Cfif>
							)	
							 		<!---ORDER BY  A.CLIENT_ID,A.CLIENT_NAME,B.MARKET
		 <CFELSE> --->
		GROUP BY A.CLIENT_ID,A.BRANCH_CODE
		UNION
		
		SELECT 
		max(CASE WHEN A.Company_Code ='BSE_CASH' THEN A.Company_Code ELSE NULL END ) BSECOCD ,
		A.CLIENT_ID,MAX(A.CLIENT_NAME) CLIENT_NAME,MAX(B.MARKET) MARKET,'' COMPANY_CODE,
		A.BRANCH_CODE,MAX(A.REGISTRATION_DATE) REGISTRATION_DATE
		,CONVERT(DATETIME, CONVERT(VarChar(10), MAX(A.REGISTRATION_DATE) , 103), 103),
		MAX(A.LAST_MODIFIED_DATE) LAST_MODIFIED_DATE 
		,'N' TRDFLG ,ISNULL(MAX(PANNO) ,'')PANNO,'' active_inactive
		,CAST('' AS VARCHAR(100)) NSE ,
		CAST('' AS VARCHAR(100)) BSE ,
		CAST('' AS VARCHAR(100)) MSX ,
		CAST('' AS VARCHAR(100)) MCX ,
		CAST('' AS VARCHAR(100)) NCX ,
		CAST('' AS VARCHAR(100)) OTH 
		FROM CLIENT_MASTER A LEFT OUTER JOIN CLIENT_DETAIL_VIEW B
		ON  A.CLIENT_ID=B.CLIENT_ID
		AND A.COMPANY_CODE=B.COMPANY_CODE
		--AND B.EXCHANGE='NSE'
		LEFT OUTER JOIN COMPANY_MASTER C ON
		A.COMPANY_CODE=C.COMPANY_CODE LEFT OUTER JOIN PAN_NO_DETAILS D ON
		B.PAN_NO = D.PANNO
		WHERE 1 = 1
		<CFIF cmbmarket nEQ 'All'>
			AND A.COMPANY_CODE IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE EXCHANGE='NSE') 
		<cfelse>
			AND A.COMPANY_CODE IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE company_code in ('BSE_CASH','BSE_FNO','CD_BSE','CD_MCX','CD_NSE','MCX','MCX_CASH','MCX_FNO','NCDEX','NSE_CASH','NSE_FNO'))
		</CFIF>
		<cfif CmbOption eq "New">
			<CFIF IsDefined('txtDate') And Trim(txtDate) is not "" and IsDefined('txtToDate') And Trim(txtToDate) is not "">
			AND (
					CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
					and CONVERT(DATETIME,'#txtToDate#',103) 
					AND ISNULL(UCC_STATUS,'') =''
				)
			</CFIF>
		<cfelse>
			<Cfif NOT IsDefined("Brokerage")>
				<CFIF IsDefined('txtDate') And Trim(txtDate) is not "" and IsDefined('txtToDate') And Trim(txtToDate) is not "">
					AND A.CLIENT_ID IN (SELECT CLIENT_ID
									FROM AUDITEDDATA
									WHERE
										COLUMN_NAME IN ('RESI_ADDRESS','CITY','EMAIL_ID','STATE','COUNTRY','PINCODE','RESI_TEL_NO','MOBILE_NO','TypeOfFacility','MasterPan','RelationShip','UpdationFlag','CIN','ANNUAL_INCOME')
									AND TABLE_NAME IN ('CLIENT_MASTER','CLIENT_DETAILS')
									AND CONVERT(DATETIME,CONVERT(VARCHAR(10),UPDATETIME,103),103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) AND CONVERT(DATETIME,'#txtToDate#',103)

									UNION ALL
									SELECT ACCOUNT_CODE
									FROM 
										FA_CLIENT_BANK_DETAILS
									WHERE 
										CONVERT(DATETIME,CONVERT(VARCHAR(10),INSERTED_DATE,103),103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) AND CONVERT(DATETIME,'#txtToDate#',103)
									UNION ALL
									SELECT ACCOUNT_CODE
									FROM 
										FA_CLIENT_BANK_DETAILS_HISTORY
									WHERE 
										CONVERT(DATETIME,CONVERT(VARCHAR(10),CHANGETIME,103),103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) AND CONVERT(DATETIME,'#txtToDate#',103)
									AND FULLUPDATE = 'Y'
								)	

					AND NOT (
								CONVERT(DATETIME, CONVERT(VarChar(10), A.REGISTRATION_DATE, 103), 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
							and CONVERT(DATETIME,'#txtToDate#',103) 
							AND ISNULL(UCC_STATUS,'') =''
							)
 				</CFIF>	
			</Cfif>
		</cfif>
		<CFIF IsDefined("FromClient") and FromClient neq ''>
			and a.CLIENT_ID IN ('#Replace(FromClient,",","','","ALL")#')
		</CFIF>
		<CFIF IsDefined("FromBRANCH") and FromBRANCH neq ''>
			and a.BRANCH_CODE IN ('#Replace(FromBRANCH,",","','","ALL")#')
		</CFIF>

		<cfif cmbmarket neq "All">
			<cfif cmbmarket eq "">
				AND b.market IN ('CAPS','FO')
				AND A.COMPANY_CODE  IN ('NSE_CASH','NSE_FNO','CD_NSE')
			<cfelse>
				and b.market='#cmbmarket#'
			</cfif>
		<cfelse>
			AND A.COMPANY_CODE IN(SELECT COMPANY_CODE FROM COMPANY_MASTER WHERE company_code in ('BSE_CASH','BSE_FNO','CD_BSE','CD_MCX','CD_NSE','MCX','MCX_CASH','MCX_FNO','NCDEX','NSE_CASH','NSE_FNO'))
		</cfif>


		<cfif cmbmarket neq "All" AND TRIM(cmbmarket) Neq "">
			<cfif cocd eq 'cd_nse'>
				and ISNULL(C.FLG_NCX,'N') = 'CD'
			<CFELSE>
				and ISNULL(C.FLG_NCX,'N') = 'N'
			</cfif>
		</cfif>
		and A.CLIENT_ID NOT IN(SELECT DISTINCT CLIENT_ID FROM TRADE1 WHERE COMPANY_CODE=A.COMPANY_CODE
		AND CONVERT(DATETIME,TRADE_DATE,103)  BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
				and CONVERT(DATETIME,'#txtToDate#',103)) 
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(A.CHEKING,'N') = 'Y'
		</cfif>				
		AND A.CLIENT_ID IN(SELECT DISTINCT CLIENT_ID FROM BROKERAGE_APPLY WHERE COMPANY_CODE=A.COMPANY_CODE
							AND ACTIVE_INACTIVE ='A'
							AND ISNULL(END_DATE ,'') = ''
								<Cfif IsDefined("Brokerage")>
									AND CONVERT(DATETIME, START_DATE, 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) 
										and CONVERT(DATETIME,'#txtToDate#',103) 
								</Cfif>
							)
		GROUP BY A.CLIENT_ID,A.BRANCH_CODE
 		ORDER BY  REGISTRATION_DATE1 DESC,A.CLIENT_ID
	<!--- </CFIF> --->
	UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'E' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NSE_CASH'	
	UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'D' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NSE_FNO'	
	UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'C' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='CD_NSE'	
	UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'S' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NSE_SLBM'	
	UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'R' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NSE_RDM'	
	
	UPDATE ##KYC_EnteryScreen 		 SET BSE =BSE + 'E' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='BSE_CASH'	
	UPDATE ##KYC_EnteryScreen 		 SET BSE =BSE + 'D' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='BSE_FNO'	
	UPDATE ##KYC_EnteryScreen 		 SET BSE =BSE + 'C' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='CD_BSE'	
	
	UPDATE ##KYC_EnteryScreen 		 SET MSX =MSX + 'E' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='MCX_CASH'	
	UPDATE ##KYC_EnteryScreen 		 SET MSX =MSX + 'D' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='MCX_FNO'	
	UPDATE ##KYC_EnteryScreen 		 SET MSX =MSX + 'C' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='CD_MCX'	
	
	UPDATE ##KYC_EnteryScreen 		 SET MCX =MCX + 'Y' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='MCX'	
	UPDATE ##KYC_EnteryScreen 		 SET NCX =NCX+ 'Y' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NCDEX'	
			
	UPDATE ##KYC_EnteryScreen 		 SET OTH=OTH+ 'U' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='UCX'	
	UPDATE ##KYC_EnteryScreen 		 SET OTH=OTH+ 'A' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='ACE'	
			
	select * from ##KYC_EnteryScreen 
	
		
  </CFQUERY>
  <cfelse>
 
  <CFQUERY NAME="GETCLIENTLIST" datasource="#Client.database#" DBTYPE="ODBC">
 		Select DISTINCT max(CASE WHEN A.Company_Code ='BSE_CASH' THEN A.Company_Code ELSE NULL END ) BSECOCD ,
		a.client_id,client_name,CLIENT_NATURE,REGISTRATION_DATE,Last_Modified_date,active_inactive,branch_code,
		'' PANNO,	'n' Trdflg
		,CAST('' AS VARCHAR(100)) NSE ,
		CAST('' AS VARCHAR(100)) BSE ,
		CAST('' AS VARCHAR(100)) MSX ,
		CAST('' AS VARCHAR(100)) MCX ,
		CAST('' AS VARCHAR(100)) NCX ,
		CAST('' AS VARCHAR(100)) OTH 

		into ##KYC_EnteryScreen 
		from client_master a , brokerage_apply b
		Where
			a.Company_code = b.company_code
		and a.client_id = b.client_id
		and a.Company_code = '#COCD#'
		AND ISNULL(END_DATE ,'') = ''
		<CFIF IsDefined("FromClient") and trim(FromClient) neq ''>
			and A.CLIENT_ID IN ('#Replace(FromClient,",","','","ALL")#')
		</CFIF>	
		<CFIF IsDefined("FromBranch") and trim(FromBranch) neq ''>
			and Branch_Code IN ('#Replace(FromBranch,",","','","ALL")#')
		</CFIF>	
		<cfif len(ltrim(rtrim(GetName.CHEKERUSERLIST))) neq 0>
			AND ISNULL(CHEKING,'N') = 'Y'
		</cfif>		
		AND CONVERT(DATETIME, Start_date, 103) BETWEEN CONVERT(DATETIME,'#txtDate#',103) and CONVERT(DATETIME,'#txtToDate#',103) 
		Group by a.client_id,client_name,CLIENT_NATURE,REGISTRATION_DATE,Last_Modified_date,active_inactive,branch_code
<!--- 	AND CONVERT(DATETIME, Start_date, 103) BETWEEN CONVERT(DATETIME,'#Reg_date#',103) and CONVERT(DATETIME,'#Reg_date_TO#',103) 
		Order by REGISTRATION_DATE Desc --->
		
		UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'E' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NSE_CASH'	
		UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'D' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NSE_FNO'	
		UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'C' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='CD_NSE'	
		UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'S' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NSE_SLBM'	
		UPDATE ##KYC_EnteryScreen 		 SET NSE =NSE + 'R' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NSE_RDM'	
		
		UPDATE ##KYC_EnteryScreen 		 SET BSE =BSE + 'E' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='BSE_CASH'	
		UPDATE ##KYC_EnteryScreen 		 SET BSE =BSE + 'D' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='BSE_FNO'	
		UPDATE ##KYC_EnteryScreen 		 SET BSE =BSE + 'C' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='CD_BSE'	
		
		UPDATE ##KYC_EnteryScreen 		 SET MSX =MSX + 'E' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='MCX_CASH'	
		UPDATE ##KYC_EnteryScreen 		 SET MSX =MSX + 'D' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='MCX_FNO'	
		UPDATE ##KYC_EnteryScreen 		 SET MSX =MSX + 'C' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='CD_MCX'	
		
		UPDATE ##KYC_EnteryScreen 		 SET MCX =MCX + 'Y' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='MCX'	
		UPDATE ##KYC_EnteryScreen 		 SET NCX =NCX+ 'Y' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='NCDEX'	
				
		UPDATE ##KYC_EnteryScreen 		 SET OTH=OTH+ 'U' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='UCX'	
		UPDATE ##KYC_EnteryScreen 		 SET OTH=OTH+ 'A' FROM ##KYC_EnteryScreen A,##CLIENT_MASTER_cOMPANY B WHERE A.CLIENT_ID =B.CLIENT_ID 	AND B.COMPANY_CODE ='ACE'	
				
		select * from ##KYC_EnteryScreen 
  </CFQUERY>
</cfif>
</CFIF>  

  <TABLE   border="0" bgcolor="##EDECFF" width="100%">
<!---   <TR class="top" height="20">
		
		<TH></TH>
		<TH colspan="8" align="CENTER" class="foot-sel">
			<!-- <LABEL class="copyright"> -:-->&nbsp;UCI File Generation&nbsp;<!-- :-</LABEL> -->
		</TH>
	</TR> --->
#DateFunctionList('frmUCI','txtDate,txtToDate')#		
  	<TR height="20" bgcolor="##EDECFF">
		<Td nowrap align="right">
			Frm Dt. :
		</Td>
		<Td align="left">
			<CFIF IsDefined("txtDate") and txtDate neq ''>
				<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtDate" SIZE="10" VALUE="#txtDate#"  maxlength="10">
			<CFELSE>
				<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtDate" SIZE="10" VALUE="#DateFormat(Now(),'DD/MM/YYYY')#"  maxlength="10">
			</CFIF>	
		</Td>
		<TD align="RIGHT">
			 To Dt :	
		</TD>
		
		<cfquery name="Spdate" datasource="#client.database#">
			select AutoIncrBatch ,AutoIncrBatchDate from system_settings
		</cfquery>
	
		<cfif DateFormat(Spdate.AutoIncrBatchDate,'ddmmyyyy') eq DateFormat(now(),'ddmmyyyy')>
			<cFSET batchNo123 = Spdate.AutoIncrBatch>
		<cfelse>
			<cFSET batchNo123 = 01>
		</cfif>
		
		<cfif len(batchNo123) eq 1>
			<cfset batchNo123 = "0#batchNo123#">
		<cfelse>		
			<cfset batchNo123 = "#batchNo123#">
		</cfif>
		
		<cfset txtBatchNo = batchNo123>
		
		<TD nowrap align="center">
			<CFIF IsDefined("txtToDate") and txtToDate neq ''>
				<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtToDate" SIZE="10" VALUE="#txtToDate#" maxlength="10">
			<CFELSE>
				<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtToDate" SIZE="10" VALUE="#DateFormat(Now(),'DD/MM/YYYY')#"   maxlength="10">
			</CFIF>
			&nbsp;
			Batch No :
			&nbsp;<INPUT TYPE="TEXT" class="fieldbuttonblue" NAME="txtBatchNo" maxlength="3" SIZE="3" <CFIF IsDefined('txtBatchNo') and txtBatchNo neq ''> VALUE="#txtBatchNo#" <CFELSE> VALUE="01"</CFIF>CLASS="StyleTextBox">
		</TD>
		<TD align="right">
			<label>Cl List :</label>
		</TD>
		<TD ALIGN='LEFT' nowrap>
			<TEXTAREA COLS="6" ROWS="1" CLASS="StyleTextBox" NAME="FromClient"></TEXTAREA>
			<INPUT TYPE="Button" NAME="btnHelp" VALUE=" ? " title="Click here to get Help for Client ID." CLASS="StyleSmallButton1" style="Cursor : Help;"
					   ONCLICK="OpenWindow( this.form, 'Client' );">		
		</TD>
		<TD nowrap colspan="2">
			Market :
		
			&nbsp;
			<SELECT NAME="cmbmarket" class="fieldbuttonblue">
				<OPTION 
				title="BSE_CASH,BSE_FNO,CD_BSE,#CHR(10)#CD_MCX,MCX_CASH,MCX_FNO,#CHR(10)#NSE_FNO,NSE_CASH,CD_NSE#CHR(10)#NCDEX,MCX,KRA"
				VALUE="All" <CFIF IsDefined('cmbmarket') and Trim(cmbmarket) eq 'All'>SELECTED</CFIF> 
				 
				> Cash,Fo,Currency,Comodity & Kra </OPTION>
				<OPTION VALUE="CAPS" <CFIF IsDefined('cmbmarket') and Trim(cmbmarket) eq 'CAPS'>SELECTED</CFIF>  >Capital</OPTION>
				<OPTION VALUE="FO" <CFIF IsDefined('cmbmarket') and Trim(cmbmarket) eq 'FO'>SELECTED</CFIF> >FNO</OPTION>
				<OPTION VALUE="" <CFIF IsDefined('cmbmarket') and Trim(cmbmarket) eq ''>SELECTED</CFIF> > Cash & FNO & Currancy</OPTION>
			</SELECT> 
		</TD>
		
	</TR>
	<tr>
		<TD nowrap align="right">
			Cl. Opt. :
		</TD>
		<TD nowrap align="left">
			<SELECT NAME="CmbOption" class="fieldbuttonblue">
				<OPTION VALUE="New" <CFIF IsDefined('CmbOption') and Trim(CmbOption) eq 'New'>SELECTED</CFIF>  >New</OPTION>
				<OPTION VALUE="Mod" <CFIF IsDefined('CmbOption') and Trim(CmbOption) eq 'Mod'>SELECTED</CFIF> >Modified</OPTION>
				<OPTION VALUE="AI" <CFIF IsDefined('CmbOption') and Trim(CmbOption) eq 'AI'>SELECTED</CFIF> >Active/InActive</OPTION>
			</SELECT> 
		</TD>		
		<TD align="right">
			File Opt.:
		</TD>
		<TD align="left">
			&nbsp;
			<cfquery name="SETDATADATA" datasource="#CLIENT.DATABASE#">
				SELECT CASE WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103) > '2013-05-01' THEN 3
							WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103) > '2012-06-17' THEN 2
							WHEN CONVERT(DATETIME,CONVERT(VARCHAR(10),GETDATE(),103),103) > '2011-11-18' THEN 1
							 ELSE 0 END AS FIG
			</cfquery>
			<SELECT NAME="CmbFileOption" class="fieldbuttonblue">
				<!--- <OPTION VALUE="Old" <CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'Old'> SELECTED </CFIF> >Old</OPTION>
				<OPTION VALUE="New" <CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'New'>SELECTED</CFIF>  >New</OPTION>
				
				<OPTION VALUE="New1" <CFIF #SETDATADATA.FIG# EQ 1 and not IsDefined('CmbFileOption')>SELECTED</CFIF><CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'New1'>SELECTED</CFIF>  > New (19/11/11) Onwards</OPTION>				
				<OPTION VALUE="New2" <CFIF #SETDATADATA.FIG# EQ 2 and not IsDefined('CmbFileOption')>SELECTED</CFIF><CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'New2'>SELECTED</CFIF>  > New (18/06/12) Onwards</OPTION> --->				
				<OPTION VALUE="New3" <CFIF #SETDATADATA.FIG# EQ 3 and not IsDefined('CmbFileOption')>SELECTED</CFIF><CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'New3'>SELECTED</CFIF>  > New (02/05/13) Onwards</OPTION>				
				<OPTION VALUE="BM" <CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'BM'>SELECTED</CFIF>  >Bulk Modification</OPTION>
				<OPTION VALUE="AI" <CFIF IsDefined('CmbFileOption') and Trim(CmbFileOption) eq 'AI'>SELECTED</CFIF>  >Active/Inactive</OPTION>
			</SELECT> 
		</TD>
		<TD nowrap align="right">
			Branch List :
		</TD>
		<CFSET hELP ="select BRANCH_CODE,BRANCH_NAME from BRANCH_MASTER">
		<TD nowrap align="left">
			&nbsp;<TEXTAREA COLS="6" ROWS="1" CLASS="StyleTextBox" NAME="FromBRANCH"></TEXTAREA>
				  <INPUT TYPE="Button" NAME="cmdBranchHelp" VALUE=" ? " CLASS="StyleSmallButton1" OnClick = "HelpWindow = open( '/FOCAPS/HelpSearch/REPORT_HELP.cfm?Object_Name=FromBRANCH&Sql=#Help#&HELP_RETURN_INPUT_TYPE=CheckBox', 'HelpWindow', 'width=700, height=525, scrollbar=no, top=0, left=0, menubar=no, titlebar=no, toolbar=no, status=no, resizeable=no' );">
	   </TD>		
		<TD nowrap align="LEFT">
			Date Range On Brokerage :
			<input type="checkbox"  value="Y" name="Brokerage" <cfif IsDefined("Brokerage")>checked</cfif>>
		</TD>
		<TD nowrap align="LEFT">
			&nbsp;
			<INPUT TYPE="SUBMIT" class="StyleSmallButton1" NAME="btnView" VALUE="View" onClick="return checkall(this.form);">
		</TD>		
	</tr>
	
  </TABLE>
  <CFIF IsDefined('btnView')>
 <div align="left" style="top:11%;position:absolute;height:80%;left:0%;overflow:auto;width:100%">
	<TABLE  bgcolor="##ECFFFF"  WIDTH="100%" BORDER="1px" ALIGN="LEFT"  CELLPADDING="0" CELLSPACING="0">
		<TR>
			<TH>
				<INPUT TYPE="CHECKBOX" NAME="CHKSELECTALL" VALUE="Y" ID="CHKSELECTALL" CLASS="StyleCheckBox" onClick="CheckUncheckAll(this.form,#GETCLIENTLIST.Recordcount#,this.checked);"> 
			</TH>
			
			<!--- <TH nowrap>Company Code</TH> --->
			<TH>Client ID</TH>
			<TH>Client Name</TH>
			<TH>Branch Code</TH>
			<TD>NSE</TD>
			<TD>BSE</TD>
			<TD>MSX</TD>
			<TD>MCX</TD>
			<TD>NCDEX</TD>
			<TD>OTH</TD>
			<TH>Trade</TH>
			<TH>Registration Date</TH>
			<TH NOWRAP>Modified Date</TH>
			<TH NOWRAP>Active Inactive</TH>
		</TR>
			<CFSET SR=1>
			<CFLOOP QUERY="GETCLIENTLIST">
				
	  <CFQUERY NAME="GetClientComapny" datasource="#Client.database#" DBTYPE="ODBC">
			SELECT * FROM Client_Master WHERE Client_id='#Client_ID#' 
			and Company_Code in('BSE_CASH','BSE_FNO','CD_BSE','BSE_SLBM','CD_MCX','CD_NSE','MCX_CASH','MCX_FNO','NCDEX','MCX','NSE_CASH','NSE_FNO')
			ORDER BY Company_Code
	  </CFQUERY>	
		  <INPUT TYPE="hidden" NAME="companychk#SR#" VALUE="#BSECOCD#">
		<cfif panno neq ''>
			<TR style="cursor:pointer;" NOWRAP title="Client's pan no is debarred by exchange">
				<TH>
					<INPUT TYPE="hidden" NAME="chk#SR#" VALUE="">
				</TH>
				<!--- <TD ALIGN="LEFT" title="#ValueList(GetClientComapny.Company_Code)#" onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp; 
					#LEFT(ValueList(GetClientComapny.Company_Code),30)#</TD> --->
					
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Client_ID#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Client_Name#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#branch_Code#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#NSE#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#BSE#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#MSX#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#MCX#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#NCX#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#OTH#</TD>
				<TD WIDTH="5%" ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Trdflg#</TD>
				<TD ALIGN="LEFT" nowrap onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp;#Registration_Date#</TD>
				<TD ALIGN="LEFT" NOWRAP onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp;#Last_Modified_date#</TD>
				<TD ALIGN="LEFT" NOWRAP >&nbsp;#Active_inactive#</TD>
			</TR>
		<cfelse>
			<TR style="cursor:pointer;" NOWRAP>
				<TH>
					<INPUT TYPE="CHECKBOX" NAME="chk#SR#" VALUE="#Client_id#" onClick="validatecheck(this.form,'#Client_id#','chk#SR#',this.checked);" checked CLASS="StyleCheckBox">
					<!--- <INPUT TYPE="Hidden" NAME="Company#SR#" VALUE="#BSECOCD#" CLASS="StyleCheckBox"> --->
				</TH>
				<!--- <TD ALIGN="LEFT" title="#ValueList(GetClientComapny.Company_Code)#" onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp; #LEFT(ValueList(GetClientComapny.Company_Code),30)#</TD> --->

				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Client_ID#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Client_Name#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#branch_Code#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#NSE#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#BSE#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#MSX#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#MCX#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#NCX#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#OTH#</TD>
				<TD ALIGN="LEFT" onClick="showdetails('#CLIENT_ID#','#MARKET#')"> &nbsp;#Trdflg#</TD>
				<TD ALIGN="LEFT" nowrap onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp;#Registration_Date#</TD>
				<TD ALIGN="LEFT" NOWRAP onClick="showdetails('#CLIENT_ID#','#MARKET#')">&nbsp;#Last_Modified_date#</TD>
				<TD ALIGN="LEFT" NOWRAP >&nbsp;#Active_inactive#</TD>
			</TR>
		</cfif>
			<CFSET SR=SR+1>
			</CFLOOP>
					<INPUT type="Hidden" name="Sr" value="#Sr#">			
			
		</table>
		</div>
		<br>
		<div align="left" style="top:94%;position:absolute;height:5%;left:0%">
			<table>
			 <TR bgcolor="##EDECFF" >
				<Td ALIGN="LEFT"  COLSPAN="7" NOWRAP>
						Trading Clients :<INPUT TYPE="RADIO" NAME="chkClient" VALUE="Trd" <CFIF IsDefined('chkClient') and chkClient eq 'Trd' >Checked</CFIF> >
						<!--- <CFIF IsDefined('chkTrdClient') and chkTrdClient neq ''>
							<INPUT TYPE="CHECKBOX" NAME="chkTrdClient" VALUE="TradeClient" CHECKED CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">
						<CFELSE>
							<INPUT TYPE="CHECKBOX" NAME="chkTrdClient" VALUE="TradeClient" CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">
						</CFIF>  --->
						New Clients :<INPUT TYPE="RADIO" NAME="chkClient" VALUE="New" <CFIF IsDefined('chkClient') and chkClient eq 'New'>Checked<CFELSE>Checked</CFIF> >
						<!--- <CFIF (IsDefined('chkNewClient')  and chkNewClient neq '')>
							<INPUT TYPE="CHECKBOX" NAME="chkNewClient" VALUE="NewClient" CHECKED CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">
						<CFELSEIF IsDefined('chkTrdClient')  and chkTrdClient eq ''>
							<INPUT TYPE="CHECKBOX" NAME="chkNewClient" VALUE="NewClient" CHECKED CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">
						<CFELSE>
							<INPUT TYPE="CHECKBOX" NAME="chkNewClient" VALUE="NewClient"  CHECKED CLASS="StyleCheckBox" onClick="CheckUncheck(this.name,this.checked);">	
						</CFIF>   --->
						
					<Cfif cmbmarket eq 'All'>
						<INPUT TYPE="button" NAME="CmdGenerate" VALUE="Generate" CLASS="field" ONCLICK="generateReport_All(this.form,#GETCLIENTLIST.Recordcount#,'#CmbFileOption#');">
					<cfelse>
						<INPUT TYPE="button" NAME="CmdGenerate" VALUE="Generate" CLASS="field" ONCLICK="generateReport(this.form,#GETCLIENTLIST.Recordcount#,'#CmbFileOption#');">
					</Cfif>
				</Td>
		<Cfif cmbmarket eq 'All'>
				<!--- <Td ALIGN="LEFT" COLSPAN="4" WIDTH="100%">
<!--- 					<IFRAME  style="background-color:##FFFFCC; "  SRC="about:blank" NAME="FileGeneration123"  SCROLLING="yes" WIDTH="100%" HEIGHT="5%"  FRAMEBORDER="0"></IFRAME>
 --->				</Td> --->
		<cfelse>
				<!--- <Td ALIGN="LEFT" COLSPAN="4" WIDTH="100%">
					<IFRAME  style="background-color:##FFFFCC; "  SRC="about:blank" NAME="FileGeneration"  SCROLLING="yes" WIDTH="100%" HEIGHT="5%"  FRAMEBORDER="0"></IFRAME>
				</Td> --->
		</Cfif>
				
			</TR> 
			</table>	
		</div>	
			
			
	</TABLE>
</CFIF>
  
  
  
	
  
</CFOUTPUT>
	<IFRAME   SRC="about:blank"  NAME="FileGeneration"  STYLE="display:none; " SCROLLING="auto" WIDTH="500" HEIGHT="200"  FRAMEBORDER="0"></IFRAME>
</FORM>

</BODY>
</HTML>