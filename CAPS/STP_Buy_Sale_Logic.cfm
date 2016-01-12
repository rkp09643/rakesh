			<CFIF	BQTY	GT	0>
				<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
				<CFSET	QTY		=	BQTY>
				<CFSET	BRATE1	=	BRATE>
				<CFSET	BBRK1	=	TRIM(NUMBERFORMAT(BBRK,'9999999999999.999999'))>
				<CFSET	BNetRATE1	=	BNetRATE>
				<CFSET ACTBUY_SALE = 'B'>
				<CFSET	BRATEDecimal	=	Find(".",BRATE)>
				<CFSET	BRATE1	= 	Trim(NumberFormat(Mid(Trim(BRATE), 1, BRATEDecimal+INST_GROSS),'9999999.'&RepeatString(9,INST_GROSS))) >				

				<CFSET	BRATE1	= 	MKT_PRICE >				

				<CFSET BACTAMT = TRIM(NUMBERFORMAT(BQTY * BRATE1,'999999999999999.999999'))>
				<CFSET BACTAMTDecimal	=	Find(".",BACTAMT)>
				<CFSET BACTAMT1 = Trim(NumberFormat(Mid(Trim(BACTAMT), 1, BACTAMTDecimal+2),'99999999999999.'&RepeatString(9,2)))>
				<CFSET	BBRK1Decimal	=	Find(".",TRIM(BBRK1))>
				<CFSET	BBRK2			= 	TRIM(Numberformat(Mid(Trim(BBRK1), 1, BBRK1Decimal+BRKDECIMAL),'999999999.'&RepeatString(9,BRKDECIMAL)))>					
				<CFSET	BNETRATEDecimal	=	Find(".",BNETRATE)>
				<CFSET	BNETRATE1	= 	Trim(NumberFormat(Mid(Trim(BNETRATE), 1, BNETRATEDecimal+INST_NET),'9999999.'&RepeatString(9,INST_NET))) >				
	
				<CFSET	BNETRATE1	= 	NET_PRICE >				

				<CFSET	RATE	=	BRATE1>
				<CFSET	BRK		=	BBRK2>
				<CFSET	NetRATE	=	BNetRATE1>
				<CFSET	TOTBBRK		=	TRIM(NUMBERFORMAT(BQTY	*	BBRK2,"999999999.999999"))>
				<CFSET	BBRKDecimal	=	Find(".",TOTBBRK)>
				<CFSET	TOTBBRK1	= 	Trim(NumberFormat(Mid(Trim(TOTBBRK), 1, BBRKDecimal+2),'9999999.99')) >
				<CFSET	TOTBBRK1	= 	Trim(NumberFormat(TOTBBRK,'9999999.99')) >				

				<CFSET	TOTBrk	=	TOTBBRK1>
				<CFSET	AMT =		BACTAMT1+TOTBBRK1>
				<!--- <CFSET	AMT		=	Trim(NumberFormat(BQTY * BNetRATE1,"99999999.99"))> --->
				<CFSET	Actual_Amt	=	BACTAMT1>
				
				<CFSET	BUY_SALE_M	=	"BUYI">
				<CFSET	BUY_SALE	=	"BUYI">
				<CFSET	BUY_SALE2	=	"SELL">
				<CFSET	BUY_SALE3	=	"DEAG">
				<CFSET	RatePlusBrk	=	"+">
				
				
				<CFIF	APPLY_STT>
					<CFSET	STT	=	trim(((BQTY * BRATE1 * BSTT)) / 100)>
				<CFELSE>
					<CFSET	STT	=	0>
				</CFIF>
				
				<CFSET	STT	=	trim(STT)>
				<CFSET	AMT1	=	Trim((AMT + NumberFormat(STT, "9999999999")))>
				<CFSET	STT		=	Trim(NumberFormat(STT, "999999999"))>
				<CFSET  AMT		=	NumberFormat(AMT1,"99999999999.99")>
					
			<CFELSE>
				<CFSET	Contract_Note_Text	=	"A#TYPEFOREXCHANGE##CONTRACT_NO#">
				<CFSET	QTY		=	SQTY>
				<CFSET	SRATE1	=	SRATE>
				<CFSET	SBRK1	=	SBRK>
				<CFSET	SNetRATE1	=	SNetRATE>
				<CFSET ACTBUY_SALE = 'S'>
				
				<CFSET	SRATEDecimal	=	Find(".",SRATE)>
				<!--- <CFSET	SRATE1	= 	Trim(NumberFormat(Trim(SRATE),'9999999.'&RepeatString(9,INST_GROSS))) >								 --->
				<CFSET	SRATE1	= 	Trim(NumberFormat(Mid(Trim(SRATE), 1, SRATEDecimal+INST_GROSS),'9999999.'&RepeatString(9,INST_GROSS))) >				
				
				<CFSET	SRATE1	= 	MKT_PRICE >			
				<CFSET SACTAMT = TRIM(NUMBERFORMAT(SQTY * SRATE1,'999999999999999.999999'))>
				<CFSET SACTAMTDecimal	=	Find(".",SACTAMT)>
				<CFSET SACTAMT1 = Trim(NumberFormat(Mid(Trim(SACTAMT), 1, SACTAMTDecimal+2),'99999999999999.'&RepeatString(9,2)))>

				<CFSET	SBRK1Decimal	=	Find(".",TRIM(SBRK1))>
				<CFSET	SBRK2			= 	TRIM(Numberformat(Mid(Trim(SBRK1), 1, SBRK1Decimal+BRKDECIMAL),'999999999.'&RepeatString(9,BRKDECIMAL)))>					

				<CFSET	SNETRATEDecimal	=	Find(".",SNETRATE)>
				<!--- <CFSET	SNETRATE1	= 	Trim(NumberFormat(SNETRATE,'9999999.'&RepeatString(9,INST_NET))) >									 --->
				<CFSET	SNETRATE1	= 	Trim(NumberFormat(Mid(Trim(SNETRATE), 1, SNETRATEDecimal+INST_NET),'9999999.'&RepeatString(9,INST_NET))) >				
				<CFSET	SNETRATE1	= 	NET_PRICE >			
				<CFSET	TOTSBRK				=	TRIM(NUMBERFORMAT(SQTY	*	SBRK2,"999999999.999999"))>
				<CFSET	SBRKDecimal	=	Find(".",TOTSBRK)>
				<CFSET	TOTSBRK1	= 	Trim(NumberFormat(Mid(Trim(TOTSBRK), 1, SBRKDecimal	+2),'9999999.99')) >				
				<CFSET	TOTSBRK1	= 	Trim(NumberFormat(TOTSBRK,'9999999.99')) >				
				<CFSET	BUY_SALE_M	=	"SELL">
				<CFSET	RATE	=	SRATE1>
				<CFSET	BRK		=	SBRK2>
				<CFSET	TOTBrk	=	TOTSBRK1>
				<CFSET	NetRATE	=	SNETRATE1>
				<CFSET	Actual_Amt	=	SACTAMT1>
				<CFSET	AMT =		SACTAMT1-TOTSBRK1>
				<CFSET	BUY_SALE	=	"SELL">
				<CFSET	BUY_SALE2	=	"BUYR">
				<CFSET	BUY_SALE3	=	"REAG">
				<CFSET	RatePlusBrk	=	"+">
				<CFIF	APPLY_STT>
					<CFSET	STT	=	trim(((SQTY * SRATE1 * SSTT) / 100))>
				<CFELSE>
					<CFSET	STT	=	0>
				</CFIF>
								<CFSET	STT	=	trim(STT)>

				<CFSET	AMT1	=	Trim((AMT - NumberFormat(STT, "99999999")))>
				<CFSET	STT		=	Trim(NumberFormat(STT, "99999999"))>
				<CFSET  AMT     =   NumberFormat(AMT1,"99999999999.99")>  
			</CFIF>
