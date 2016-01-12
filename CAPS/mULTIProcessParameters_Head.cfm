
<CFIF Trade_Date EQ ''>
	<script>
		alert('Please Select Date');
		histor.back();
	</script>
	<cfabort>
</CFIF>
 <div style="position:absolute;top:0;height:50%;width:50%;">
	<cfset 	Mkt_Type  ='T'>
 	<cfinclude template="ProcessParameters.cfm">
 </div>
