<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
<TITLE>Import No Delivery Entry</TITLE>
<link href="/FOCAPS/CSS/DynamicCSS.css" type="text/css" rel="stylesheet">
<style>
	DIV#Head
	{
		Font: Bold 10pt Tahoma;
		Position: Fixed;
		Top: 0;
		Width: 100%;
	}
		
	DIV#TableHead
	{
		Position: Absolute;
		Top: 10%;
		Left: 0;
		Width: 100%;
		Height: 15%;
		Overflow: Auto;
	}
	DIV#Message
	{
		Position: Absolute;
		Top: 50%;
		Left: 0;
		Width: 100%;
		Height: 15%;
		Overflow: Auto;
	}		
	DIV#Footer
	{
		Position: Absolute;
		Top: 75%;
		Left: 0;
		Width: 100%;
		Height: 20%;
		Overflow: Auto;
	}		

</style>
</HEAD>
<BODY Class="StyleBody1">
<CFOUTPUT>
	 <CFFORM NAME="ImpordNdData" ACTION="ImportNDMaster.cfm" METHOD="POST" enctype="multipart/form-data">
		<input type="Hidden" name="COCD" value="#Trim(UCase(COCD))#">
		<input type="Hidden" name="CoName" value="#Trim(UCase(CoName))#">
		<input type="Hidden" Name="CoGroup" value="#UCase(Trim(CoGroup))#">
		<input type="Hidden" name="Market" value="#Trim(UCase(Market))#">
		<input type="Hidden" name="Exchange" value="#Trim(UCase(Exchange))#">
		<input type="Hidden" name="Broker" value="#Trim(UCase(Broker))#">
		<input type="Hidden" Name="FinStart" value="#Val(Trim(FinStart))#">
		<input type="Hidden" Name="FinEnd" value="#Val(Trim(FinEnd))#">
	
	<cfif isdefined("Import")>
		 
		 <cfif  not FileExists("c:\ImportTradeFile\NdEntry.txt")>
		 	<cffile action="write" file="#Client.ServerPath#\IMPORTTRADEFILES\NdEntry.txt" output="" addnewline="no" >
		<cfelse>
			<cffile action="write" file="#Client.ServerPath#\IMPORTTRADEFILES\NdEntry.txt"  output="" addnewline="no">
		 </cfif>
		 
		 <CFFILE ACTION="upload" DESTINATION="#Client.ServerPath#\IMPORTTRADEFILES\NdEntry.txt" filefield="FileName" nameconflict="overwrite">
		 
		 <CFQUERY NAME="BulkinsterData" datasource="#Client.database#" dbtype="ODBC">
			DELETE 
			FROM TEMP_ND_ENTRY
			
			BULK INSERT TEMP_ND_ENTRY
			FROM '#Client.ServerPath#\IMPORTTRADEFILES\NdEntry.txt'			
		</CFQUERY>		
		 <cftry>
			<cfquery name="Select" datasource="#Client.database#" dbtype="odbc">
				Select *
				from Temp_Nd_Entry
			</cfquery>
			<cfset Add1 = #Finstart# * 1000>
	
			<cfquery name="DeleteMain" datasource="#Client.database#" dbtype="odbc">
				Delete
				From Temp_Nd_Main		
			</cfquery>
	
			<cfloop query="Select">
				<cfquery name="InsertInToTemp" datasource="#Client.database#" dbtype="odbc">
					insert into Temp_Nd_Main
						(scrip_code,temp_date,from_settlement,to_settlement)
					values
						(substring('#Temp_Data#',1,6),substring('#Temp_Data#',17,8),substring('#Temp_Data#',29,4)+substring('#Temp_Data#',25,3),substring('#Temp_Data#',29,4)+substring('#Temp_Data#',38,3))
				</cfquery>	
			</cfloop>
			<cfquery name="SelectMain" datasource="#Client.database#" dbtype="odbc">
				Select *
				From  Temp_Nd_Main
			</cfquery>
			<!--- <cfloop query="SelectMain">
				<cfset From = Add1 +  '#from_settlement#'>
				<cfset Tos = Add1 + '#to_settlement#'>
				
				<cfquery name="UpdateQuery" datasource="#Client.database#" dbtype="odbc">
					Update Temp_Nd_Main
					Set
						From_Settlement = '#From#',
						To_Settlement = '#Tos#'
					Where
						Scrip_code = '#Scrip_code#'
				</cfquery>
			</cfloop> --->
			<cfquery name="SelectMaintoInsert" datasource="#Client.database#" dbtype="odbc">
				Select *
				From  Temp_Nd_Main
			</cfquery>
			
			<cfloop query="SelectMaintoInsert">
				<cftry>
					<cfquery name="InsertintoMain" datasource="#Client.database#" dbtype="odbc">
						if not exists(select scrip_code from ND_Entry where company_code = '#COCD#' 
																		And Scrip_Code = '#Scrip_Code#'
																		And	To_Settlement = '#To_Settlement#'
																		)
						BEGIN												
							Insert Into Nd_Entry
							(Company_Code,Scrip_Code,From_Settlement,To_Settlement,ImportDate)
							Values
							('#Cocd#','#Scrip_Code#','#From_Settlement#','#To_Settlement#',getdate())
						END	
					</cfquery>
				<cfcatch type="database">
					<cfif CFCATCH.NativeErrorCode NEQ 2627>
						#CFCATCH.Detail#
					</cfif>					
				</cfcatch>
				</cftry>	
			</cfloop>
			
			<div align="center" id="Message">
				<font color="RED" size="1">File Has Been Imported</font><BR>
				
			</div>
		<cfcatch type="any">
			#cfcatch.errorcode# #cfcatch.detail#
			<script>
				alert("#cfcatch.errorcode# #cfcatch.detail#");
			</script>
		</cfcatch>
		</cftry>		
	</cfif>	
	
	
		<div align="center" id="Head">
			<font color="CC33FF" size="2"><u>Import For No Delivery</u></font>			
		</div>
		
		<div align="center" id="TableHead">
			File Name:&nbsp;
			<input type="File" name="FileName" class="StyleTextBox" size="50">
			&nbsp;
			&nbsp;<input type="Submit" name="Import" value="Import" class="StyleSmallButton1" accesskey="I">
		</div>	
		
		<div align="left" id="Footer">
			<font color="red" size="1">
				<u>Notice :</u><br>
				1. You can Download This File From D-Load -> Notice -> DMTND*. <br>
				2. Take the Latest File					
			</font>
		</div>
	</CFFORM> 
</CFOUTPUT>
</BODY>
</HTML>
