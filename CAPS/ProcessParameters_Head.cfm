<cfinclude template="../../messenging system/SendMes.cfc">
<CFIF Trade_Date EQ ''>
	<script>
		alert('Please Select Date');
		histor.back();
	</script>
	<cfabort>
</CFIF>
<Cfset Mkt_Type1=Mkt_Type>
 <Cfif Mkt_Type eq 'N,T'>
 <div style="position:absolute;top:0;height:50%;width:50%;">
	<cfset 	Mkt_Type  ='T'>
 	<cfinclude template="ProcessParameters.cfm">
 </div>
 <div style="position:absolute;top:50%;height:50%;width:50%;">
	 <label id="ab">
		 Wait Normal Bill Is Runninng .........
	 </label>
	<cfset 	Mkt_Type  ='N'>
 	<cfinclude template="ProcessParameters.cfm">
	<script>
		ab.style.display="none"
	</script>
 </div>
 <cfelse>
	 <div style="position:absolute;top:0%;height:100%;width:50%;">
		<cfinclude template="ProcessParameters.cfm">
	 </div>
 </Cfif>

<Cfset Mkt_Type=Mkt_Type1>
 <CFIF 1 EQ 1>
<!---  <CFIF Val(p8) EQ 1>
 --->		  <div style="position:absolute;top:0;height:50%;width:50%;left:50%">
			<cfinclude template="NextCallProcesses.cfm">
		 </div> 
 </CFIF>
