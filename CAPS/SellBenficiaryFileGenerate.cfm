<CFSET VarFileVal = "">
			<CFSET I = 0>
			<CFSET J = 1>
			<CFSET K = 0>
			<CFSET L = 1>
			<CFSET M = 1>
			
			<CFIF LEFT(txtPricePer,1) EQ '+' OR LEFT(txtPricePer,1) EQ '-'>
				<CFSET CLPRICE= VAL(MID(TXTPRICEPER,2,10))>
			<CFELSE>
				<CFSET CLPRICE=txtPricePer>
			</CFIF> 
			 
			<CFSET	FILE_DATA	=	"">
			<!--- <CFSET	CLRATE 		= 	""> --->

			<CFSET	FileName	=	"SELLBEN#J#.dot">
			
			<CFIF Main.RecordCount GT 0>
			<CFIF OMNISYSFILE EQ "Y">
				<CFINCLUDE template="OMNISYSSELLBENFILE.CFM">
			<CFELSE>
				<CFLOOP QUERY="Main">
					<CFIF SELL EQ "Y">
 						<CFIF ISNUMERIC(#SCRIPCODE#)>
							<CFSET 	I = I + 1>
							<cfif J EQ 1>
								<CFSET	FileName	=	"SELLBENBSE#J#.dot">
							</CFIF>
							<CFSET	FileName	=	"SELLBENBSE#J#.dot">
							<!--- <CFIF LEFT(txtPricePer,1) EQ '+'>
								<CFSET	CLRATE 		= VAL(#CLRATE#)+ VAL(#CLOSINGRATE#*#CLPRICE#)/ 100 >
							<cfelse>
								<CFSET	CLRATE 		= VAL(#CLRATE#)- VAL(#CLOSINGRATE#*#CLPRICE#)/ 100 >
							</CFIF>		 --->
<!--- 							<CFSET	CLRATE 		= 	VAL(#CLOSINGRATE#)* 100 >
 --->						<CFSET	QTY			=	"#TOSTRING(QTY)#">	
							<CFSET	MINQTY		=	"#TOSTRING(QTY)#">
							<CFSET	SCRIPCODE	=	"#TOSTRING(SCRIPCODE)#">
							

							<!--- <CFSET	CLRATE		=	"#NumberFormat(VAL(CLRATE),"999999.99")#"> --->
							<CFSET	RATE		=	"#Replacelist(LTrim(rtrim(CLRATE)),'.','')#">
																				
							<CFSET	CLCODE		=	"#ACCOUNTCODE#">
	<!--- 						<CFSET	EOS			=	"EOSESS"> --->
							<CFSET	EOS			=	"EOTODY">
							<CFSET	CLICODE		=	"CLIENT">
							<CFSET	LAST		=	"L">
							<br> </br> 
							
	<!--- 						<CFSET  ERRCODE		= 	"$"> --->
	<!--- 						<cfset	FILE_DATA	=	"#FILE_DATA#S|#QTY#|#MINQTY#|#SCRIPCODE#|#RATE#|#CLCODE#|#EOS#|#CLICODE#|#LAST#|#ERRCODE#|"> --->
 							<cfset	FILE_DATA	=	"#FILE_DATA#S|#QTY#|#MINQTY#|#SCRIPCODE#|#RATE#|#CLCODE#|#EOS#|#CLICODE#|#LAST#|"> 
	
							<CFIF I EQ 1>
								<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes">
							<CFELSE>
								<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes"> 
							</CFIF>
	
							<CFIF I EQ 450>
								<CFSET 	J = J + 1>
								<cfset	FileName	=	"SELLBENBSE#J#.dot">
								<CFSET I = 0>
							</CFIF>	
	
							<CFSET	FILE_DATA		=	"">
	
						<CFELSE>
						<CFIF UCASE(#SCRIPCODE#) EQ "NULL" OR UCASE(#SCRIPCODE#) EQ ''>
						<CFELSE>
						<CFIF NOT ISNUMERIC(#SCRIPCODE#)>
							<CFSET 	K = K + 1>
	
							<CFIF L EQ 1>
								<CFSET	FileName	=	"SELLBENNSE#L#.dot">
							</CFIF>	
								<CFSET	FileName	=	"SELLBENNSE#L#.dot">
								<CFSET	BT 			= 	"1 ">
								<CFSET	BS 			= 	"2 ">
								<CFSET	SCRIP		= 	TRIM(#SCRIPCODE#)&RepeatString(" ",10-LEN(TRIM(LEFT(#SCRIPCODE#,10))))>
								<CFSET	SERIES		=	"EQ">	
								<CFSET	INS			=	"1 ">	
								<CFSET 	GTD			= 	RepeatString(" ",11)>
								<CFSET 	ST			= 	RepeatString(" ",2)>
								<CFSET 	MFQTY		= 	RepeatString(" ",9)>
<!---								<CFSET	RATE		=	NumberFormat(VAL(#CLOSINGRATE#),"999999.00")>
 								<CFSET	RATE1		=	#TRIM(TOSTRING(RATE))#>--->
 								<CFSET	RATE		=	#TRIM(TOSTRING(CLRATE))#&RepeatString(" ",9-len(TOSTRING(#CLRATE#)))>
 								<CFSET	CLCODE		= 	TRIM(#ACCOUNTCODE#)&RepeatString(" ",10-LEN(TRIM(LEFT(#ACCOUNTCODE#,10))))>
								<CFSET 	TRGPR		= 	RepeatString(" ",9)>
								<CFSET	QUANTITY	=	"#RIGHT(TOSTRING(QTY),9)#">
								<CFSET	DQ			=	RepeatString(" ",9)>
								<CFSET	PARTCODE	=	RepeatString(" ",12)>
								<CFSET	CL			=	"2 ">
								<CFSET  REMARK		= 	RepeatString(" ",25)>
								<CFSET  ORDNO		= 	RepeatString(" ",16)>
<!--- 								<CFSET  ERRCODE		= 	"$         "> --->
								<CFSET  ERRCODE		= 	RepeatString(" ",11)>
							<CFIF #QUANTITY# NEQ "">
								<CFSET	QUANTITY 	=	"#TOSTRING(QUANTITY)#"&RepeatString(" ", 9-LEN(#QUANTITY#))>
							</CFIF>	
								<CFSET K1			= 	TOSTRING(K)&RepeatString(" ", 13-LEN(#K#))>
<!--- 							<CFSET	FILE_DATA	=	"#FILE_DATA##K#|#BT#|#BS#|#SCRIP#|#SERIES#|#INS#|#GTD#|#ST#|#MFQTY#|#RATE#|#TRGPR#|#QUANTITY#|#DQ#|#PARTCODE#|#CL#|#CLCODE#|#REMARK#|#ORDNO#|#ERRCODE#|">
 --->							<CFSET	FILE_DATA	=	"#FILE_DATA##K1#,#BT#,#BS#,#SCRIP#,#SERIES#,#INS#,#GTD#,#ST#,#MFQTY#,#RATE#,#TRGPR#,#QUANTITY#,#QUANTITY#,#PARTCODE#,#CL#,#CLCODE#,#REMARK#,#ORDNO#,#ERRCODE#">
	
							<CFIF K EQ 1>
								<CFFILE ACTION="write" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes">
							<CFELSE>
								<CFFILE ACTION="append" FILE="C:\CFUSIONMX7\WWWROOT\#FileName#" output="#FILE_DATA#" addnewline="yes"> 
							</CFIF>
	
							<CFIF K EQ 450>
								<CFSET L = L + 1>
								<CFSET FileName	= "SELLBENNSE#L#.dot">
								<CFSET K = 0>
							</CFIF>	
							<CFSET	FILE_DATA	=	"">
						</CFIF>
						</CFIF>	
						</CFIF>	
					</CFIF>		
 				</CFLOOP>
				</CFIF>	
			</CFIF>	
			
			<SCRIPT>
				alert("Files are generated in C:\\CFUSIONMX7\\WWWROOT\\SELBEN*.DOT");
				<cFIF RDOODIN EQ 'Y'>
				<cfoutput>
					alert("Files are generated in C:\ODINDATA\EQ_#TOKEN#.TXT");
				</cfoutput>
				</CFIF>
			</SCRIPT>		