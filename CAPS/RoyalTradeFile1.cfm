<cfoutput>
	<cfif COCD EQ "NSE_FNO">
		<CFSET	NSEData	=	"">
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFFILE FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		
		<cfquery name="GetClosingPrice" datasource="#CLIENT.DATABASE#">
			select convert(Varchar(10),Market_Date,103) MarketDate,A.Instrument_Type,A.Scrip_symbol,Convert(Varchar(10),A.Expiry_Date,103) Exp_Date,
				   Option_Type,A.Strike_Price,MTM_PRICE,EXPIRY_PRICE,B.SCRIP_NAME
			from mtmclosingprice1 A LEFT OUTER JOIN SCRIP_MASTER_TABLE B ON
				A.SCRIP_SYMBOL = B.SCRIP_SYMBOL
			AND A.EXPIRY_DATE = B.EXPIRY_DATE
			Where
				convert(Datetime,Market_Date,103) = convert(Datetime,'#Trade_Date#',103)
			and A.scrip_symbol not like 'CF%'
		</cfquery>
		<cfset clprice = "">
		<cfloop query="GetClosingPrice">
			<cfif Trim(Option_type) eq ''>
				<cfset Option_type123 = "XX">				
			<cfelse>
				<cfset Option_type123 = "#Option_type#">
			</cfif>

			<cfset clprice = "#trim(MarketDate)#,#trim(Instrument_Type)#,#trim(SCRIP_NAME)#,#Trim(Exp_Date)#,#trim(Strike_Price)#,#trim(Option_Type123)#,#MTM_PRICE#,0,,">
			<CFFILE FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt" ACTION="append" OUTPUT="#ClPrice#" ADDNEWLINE="Yes">	
		</cfloop>
		
		
		<CFLOOP QUERY="selTrades">
			
			<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
				<CFSET	#GetData#	=	Evaluate(GetData)>
			</CFLOOP>
			
			<CFSET	Rate	=	Price_Premium>
			
			<CFIF optRateType EQ "RateWithBrk">
				<CFIF Buy_Sale	EQ	"BUY">
					<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				<CFELSEIF Buy_Sale	EQ	"SALE">
					<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				</CFIF>
			<cfelse>
				<CFSET	Rate	=	NumberFormat( (Price_Premium), "999999.9999")>	
			</CFIF>
			
			
			<CFIF TRIM(OPTION_TYPE) EQ "">
				<CFSET OPTION_TYPE1 = "">
			<cfelse>
				<CFSET OPTION_TYPE1 = "#OPTION_TYPE#">	
			</CFIF>
			<CFIF	Buy_Sale EQ "Buy">
				<CFSET BSFlag	=	1>
			<CFELSE>
				<CFSET BSFlag	=	2>
			</CFIF>
			<CFSET	NSEData	=	"">				
			<CFSET	NSEData	=	"#fileConvertString('', 7, 'R', ' ')#,#fileConvertString('', 2, 'R', ' ')#,#fileConvertString(EXP_DATE1, 9, 'R', ' ')#,#fileConvertString(SCRIP_NAME, 10, 'L', ' ')#,#fileConvertString(INSTRUMENT_TYPE, 6, 'L', ' ')#,#fileConvertString(STRIKE_PRICE, 10, 'R', ' ')#,#fileConvertString(OPTION_TYPE1, 2, 'L', ' ')#,#fileConvertString(LEFT(Scrip_SYMBOL,25), 25, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString('', 3, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(USER_ID, 5, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(BSFlag, 1, 'L', ' ')#,#fileConvertString(Rate, 12, 'R', ' ')#,#fileConvertString(Quantity, 9, 'L', ' ')#,#fileConvertString('', 1, 'R', ' ')#,#fileConvertString(BROKER_CODE, 12, 'L', ' ')#,#fileConvertString(Client_ID, 10, 'L', ' ')#,#fileConvertString(' ', 5, 'L', ' ')#,#fileConvertString(' ', 7, 'L', ' ')#,#fileConvertString(' ', 15, 'L', ' ')#,#fileConvertString(TRDDATETIME, 20, 'L', ' ')#,#fileConvertString(ORDERDATETIME, 20, 'L', ' ')#,#fileConvertString('', 3, 'L', ' ')#">
			
			<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
		</CFLOOP>	
	</cfif>
	<cfif COCD EQ "BSE_CASH">
		<CFSET	BSEBRData	=	"">
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		
		<CFLOOP QUERY="selTrades">
			<CFSET	Rate	=	Price_Premium>
			<CFIF Mkt_Type EQ "T">	
				<CFSET Scrip_Type	=	"T">
			<CFELSEIF  Mkt_Type EQ "N">	
				<CFSET Scrip_Type	=	"ROLLING">
			</CFIF>
			
			<CFIF Buy_Sale	EQ	"BUY">
				<CFSET	Rate123	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				<CFSET  BRK123 = NumberFormat((Trade_Brokerage + Delivery_Brokerage), "999999.9999")>
				<cfset Buy_Sale123 = "Sale">
			<CFELSEIF Buy_Sale	EQ	"SALE">
				<CFSET	Rate123	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				<CFSET  BRK123 = NumberFormat((Trade_Brokerage + Delivery_Brokerage), "999999.9999")>
				<cfset Buy_Sale123 = "Buy">
			</CFIF>
			
			<CFSET	BSEBRData	=	"">				
			<CFSET	BSEBRData	=	"#fileConvertString(TradeDate1, 10, 'R', ' ')#,#fileConvertString(USER_ID, 15, 'L', ' ')#,#fileConvertString('S', 2, 'L', ' ')#,#fileConvertString(SCRIP_SYMBOL, 10, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(Client_ID, 10, 'L', ' ')#,#fileConvertString('P', 2, 'L', ' ')#,#fileConvertString(LEFT(Buy_Sale123,1), 1, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(Quantity, 8, 'R', ' ')#,#fileConvertString(Rate,12, 'R', ' ')#,#fileConvertString(BRK123,11, 'R', ' ')#,#fileConvertString(Rate123,12, 'R', ' ')#,#fileConvertString('0',11, 'R', ' ')#,#fileConvertString(' ',8, 'R', ' ')#,#fileConvertString(' ',15, 'R', ' ')#,#fileConvertString(' ',8, 'R', ' ')#,#fileConvertString('0',7, 'R', ' ')#,#fileConvertString(' ',2, 'R', ' ')#,#fileConvertString(LEFT(TRIM(SCRIP_NAME),10),10, 'R', ' ')#,#fileConvertString('',2, 'R', ' ')#,#fileConvertString('',10, 'R', ' ')#,#fileConvertString('',2, 'R', ' ')#,#fileConvertString('0.0000',8, 'R', ' ')#,#fileConvertString('0.00',9, 'R', ' ')#,#fileConvertString('0.00',10, 'R', ' ')#,#fileConvertString('0.00',6, 'R', ' ')#,#fileConvertString('0.00',10, 'R', ' ')#">			
			<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#BSEBRData#" ADDNEWLINE="YES">
		</CFLOOP>
	</cfif>
	
	<cfif COCD EQ "NSE_CASH">
		<CFSET	BSEBRData	=	"">
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		
		<CFLOOP QUERY="selTrades">
			<CFSET	Rate	=	Price_Premium>
			<CFIF Mkt_Type EQ "T">	
				<CFSET Scrip_Type	=	"T">
			<CFELSEIF  Mkt_Type EQ "N">	
				<CFSET Scrip_Type	=	"ROLLING">
			</CFIF>
			
			<CFIF Buy_Sale	EQ	"BUY">
				<CFSET	Rate123	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				<CFSET  BRK123 = NumberFormat((Trade_Brokerage + Delivery_Brokerage), "999999.9999")>
				<cfset Buy_Sale123 = "Sale">
			<CFELSEIF Buy_Sale	EQ	"SALE">
				<CFSET	Rate123	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				<CFSET  BRK123 = NumberFormat((Trade_Brokerage + Delivery_Brokerage), "999999.9999")>
				<cfset Buy_Sale123 = "Buy">
			</CFIF>
			
			<CFSET	BSEBRData	=	"">				
			<CFSET	BSEBRData	=	"#fileConvertString(TradeDate1, 10, 'R', ' ')#,#fileConvertString(USER_ID, 15, 'L', ' ')#,#fileConvertString('S', 2, 'L', ' ')#,#fileConvertString(SCRIP_SYMBOL, 10, 'L', ' ')#,#fileConvertString('EQ', 2, 'L', ' ')#,#fileConvertString(Client_ID, 10, 'L', ' ')#,#fileConvertString('P', 2, 'L', ' ')#,#fileConvertString(LEFT(Buy_Sale123,1), 1, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(Quantity, 8, 'R', ' ')#,#fileConvertString(Rate,12, 'R', ' ')#,#fileConvertString(BRK123,11, 'R', ' ')#,#fileConvertString(Rate123,12, 'R', ' ')#,#fileConvertString('0',11, 'R', ' ')#,#fileConvertString(' ',8, 'R', ' ')#,#fileConvertString(' ',15, 'R', ' ')#,#fileConvertString(' ',8, 'R', ' ')#,#fileConvertString('0',7, 'R', ' ')#,#fileConvertString(' ',2, 'R', ' ')#,#fileConvertString(LEFT(TRIM(SCRIP_SYMBOL),10),10, 'L', ' ')#,#fileConvertString('EQ',2, 'R', ' ')#,#fileConvertString('',10, 'R', ' ')#,#fileConvertString('',2, 'R', ' ')#,#fileConvertString('0.0000',8, 'R', ' ')#,#fileConvertString('0.00',9, 'R', ' ')#,#fileConvertString('0.00',10, 'R', ' ')#,#fileConvertString('0.00',6, 'R', ' ')#,#fileConvertString('0.00',10, 'R', ' ')#">			
			<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#BSEBRData#" ADDNEWLINE="YES">
		</CFLOOP>
	</cfif>
	<cfif COCD EQ "MCX">
		<CFSET	NSEData	=	"">
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFFILE FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		
		<CFTRY>
			<cfquery name="DROPTABLE" datasource="#CLIENT.DATABASE#">	
				DROP TABLE ##SCRIPTEMPDATA
			</cfquery>
			<CFCATCH>
                       </CFCATCH>
		</CFTRY>	

		<cfquery name="GetClosingPrice" datasource="#CLIENT.DATABASE#">
			SELECT B.SCRIP_SYMBOL,B.EXPIRY_DATE,A.POSITION_SYMBOL,B.SCRIP_NAME
                         INTO ##SCRIPTEMPDATA
                         FROM NCX_SCRIP_MASTER A,SCRIP_MASTER_TABLE B
                         WHERE
							A.SCRIP_SYMBOL	=   B.SCRIP_NAME
                           AND CONVERT(DATETIME,EXPIRY_DATE,103) >= CONVERT(DATETIME,'#Trade_Date#',103)
                           AND A.EXCHANGE_CODE = 'MCX'

			select convert(Varchar(10),Market_Date,103) MarketDate,A.Instrument_Type,A.Scrip_symbol,Convert(Varchar(10),A.Expiry_Date,103) Exp_Date,
				   '' Option_Type,A.Strike_Price,MTM_PRICE,EXPIRY_PRICE,B.POSITION_SYMBOL SCRIP_NAME
			from mtmclosingprice A ,##SCRIPTEMPDATA B				
			Where
				A.SCRIP_SYMBOL = B.SCRIP_SYMBOL
			AND A.EXPIRY_DATE = B.EXPIRY_DATE
			AND convert(Datetime,Market_Date,103) = convert(Datetime,'#Trade_Date#',103)			

		</cfquery>
		<cfset clprice = "">
		<cfloop query="GetClosingPrice">
			<cfif Trim(Option_type) eq ''>
				<cfset Option_type123 = "">				
			<cfelse>
				<cfset Option_type123 = "#Option_type#">
			</cfif>

			<cfset clprice = "#trim(MarketDate)#,#trim(Instrument_Type)#,#trim(SCRIP_NAME)#,#Trim(Exp_Date)#,#trim(Strike_Price)#,#trim(Option_Type123)#,#MTM_PRICE#,0,,">
			<CFFILE FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt" ACTION="append" OUTPUT="#ClPrice#" ADDNEWLINE="Yes">	
		</cfloop>
		
		
		<CFLOOP QUERY="selTrades">
			
			<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
				<CFSET	#GetData#	=	Evaluate(GetData)>
			</CFLOOP>
			
			<CFSET	Rate	=	Price_Premium>
			
			<CFIF optRateType EQ "RateWithBrk">
				<CFIF Buy_Sale	EQ	"BUY">
					<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				<CFELSEIF Buy_Sale	EQ	"SALE">
					<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				</CFIF>
			<cfelse>
				<CFSET	Rate	=	NumberFormat( (Price_Premium), "999999.9999")>	
			</CFIF>
			
			
			<CFIF TRIM(OPTION_TYPE) EQ "CF">
				<CFSET OPTION_TYPE1 = "">
			<cfelse>
				<CFSET OPTION_TYPE1 = "#OPTION_TYPE#">	
			</CFIF>
			<CFIF	Buy_Sale EQ "Buy">
				<CFSET BSFlag	=	1>
			<CFELSE>
				<CFSET BSFlag	=	2>
			</CFIF>
			<CFSET	NSEData	=	"">				
			<CFSET	NSEData	=	"#fileConvertString('0', 7, 'L', ' ')#,#fileConvertString('', 2, 'R', ' ')#,#fileConvertString(UCASE(EXP_DATE1), 9, 'R', ' ')#,#fileConvertString(POSITION_SYMBOL1, 10, 'L', ' ')#,#fileConvertString(INSTRUMENT_TYPE, 6, 'L', ' ')#,#fileConvertString(STRIKE_PRICE, 10, 'R', ' ')#,#fileConvertString(OPTION_TYPE1, 2, 'L', ' ')#,#fileConvertString(LEFT(TRIM(REPLACE(POSITION_SYMBOL1,'CF','','ALL')),25), 25, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString('', 3, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(USER_ID, 10, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(BSFlag, 1, 'L', ' ')#,#fileConvertString(Rate, 12, 'R', ' ')#,#fileConvertString(NEWQTY, 9, 'L', ' ')#,#fileConvertString('', 1, 'R', ' ')#,#fileConvertString(BROKER_CODE, 12, 'L', ' ')#,#fileConvertString(Client_ID, 10, 'L', ' ')#,#fileConvertString('CLOSE', 5, 'L', ' ')#,#fileConvertString('UNCOVER', 7, 'L', ' ')#,#fileConvertString(' ', 15, 'L', ' ')#,#fileConvertString(Left(TRDDATETIME,11), 20, 'L', ' ')#,#fileConvertString(LEFT(TRDDATETIME,11), 20, 'L', ' ')#,#fileConvertString('', 3, 'L', ' ')#">
			
			<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
		</CFLOOP>	
	</cfif>
	<cfif COCD EQ "NCDEX">
		<CFSET	NSEData	=	"">
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFFILE FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		
		<CFTRY>
			<cfquery name="DROPTABLE" datasource="#CLIENT.DATABASE#">	
				DROP TABLE ##SCRIPTEMPDATA
			</cfquery>
			<CFCATCH>
                       </CFCATCH>
		</CFTRY>

		<cfquery name="GetClosingPrice" datasource="#CLIENT.DATABASE#">
			SELECT B.SCRIP_SYMBOL,B.EXPIRY_DATE,A.POSITION_SYMBOL,B.SCRIP_NAME,A.FACTOR
			 INTO ##SCRIPTEMPDATA
			 FROM NCX_SCRIP_MASTER A,SCRIP_MASTER_TABLE B
			 WHERE
				   B.SCRIP_NAME = A.SCRIP_SYMBOL
			   AND CONVERT(DATETIME,EXPIRY_DATE,103) >= CONVERT(DATETIME,'#Trade_Date#',103)
			   AND A.EXCHANGE_CODE = 'NCDX'
			   AND B.SCRIP_SYMBOL LIKE 'CF%'
							
			select convert(Varchar(10),Market_Date,103) MarketDate,A.Instrument_Type,A.Scrip_symbol,Convert(Varchar(10),A.Expiry_Date,103) Exp_Date,
				   '' Option_Type,A.Strike_Price,CAST ((MTM_PRICE/FACTOR) AS NUMERIC(30,2)) MTM_PRICE,CAST((EXPIRY_PRICE /FACTOR) AS NUMERIC(30,2)) EXPIRY_PRICE,B.SCRIP_NAME SCRIP_NAME
			from mtmclosingprice A LEFT OUTER JOIN ##SCRIPTEMPDATA B ON
				A.SCRIP_SYMBOL = B.SCRIP_SYMBOL
			AND A.EXPIRY_DATE = B.EXPIRY_DATE
			Where
				convert(Datetime,Market_Date,103) = convert(Datetime,'#Trade_Date#',103)
			and A.scrip_symbol like 'CF%'
		</cfquery>
		
		<cfset clprice = "">
		
		<cfloop query="GetClosingPrice">
			<cfif Trim(Option_type) eq ''>
				<cfset Option_type123 = "">				
			<cfelse>
				<cfset Option_type123 = "#Option_type#">
			</cfif>
			
			<cfset clprice = "#trim(MarketDate)#,#trim(Instrument_Type)#,#trim(SCRIP_NAME)#,#Trim(Exp_Date)#,#trim(Strike_Price)#,#trim(Option_Type123)#,#MTM_PRICE#,0,,">
			
			<CFFILE FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt" ACTION="append" OUTPUT="#ClPrice#" ADDNEWLINE="Yes">	
		</cfloop>
		
		
		<CFLOOP QUERY="selTrades">
			
			<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
				<CFSET	#GetData#	=	Evaluate(GetData)>
			</CFLOOP>
			
			<CFSET	Rate	=	Price_Premium>
			
			<CFIF optRateType EQ "RateWithBrk">
				<CFIF Buy_Sale	EQ	"BUY">
					<CFSET	Rate	=	NumberFormat( (PRICE_PREMIUM123 + (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				<CFELSEIF Buy_Sale	EQ	"SALE">
					<CFSET	Rate	=	NumberFormat( (PRICE_PREMIUM123 - (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				</CFIF>
			<cfelse>
				<CFSET	Rate	=	NumberFormat( (PRICE_PREMIUM123), "999999.9999")>	
			</CFIF>
			
			
			<CFIF TRIM(OPTION_TYPE) EQ "XX">
				<CFSET OPTION_TYPE1 = "">
			<cfelse>
				<CFSET OPTION_TYPE1 = "#OPTION_TYPE#">	
			</CFIF>
			<CFIF	Buy_Sale EQ "Buy">
				<CFSET BSFlag	=	1>
			<CFELSE>
				<CFSET BSFlag	=	2>
			</CFIF>
			<CFSET	NSEData	=	"">				
			<CFSET	NSEData	=	"#fileConvertString('0', 7, 'L', ' ')#,#fileConvertString('', 2, 'R', ' ')#,#fileConvertString(EXP_DATE1, 9, 'R', ' ')#,#fileConvertString(SCRIP_NAME, 10, 'L', ' ')#,#fileConvertString(INSTRUMENT_TYPE, 6, 'L', ' ')#,#fileConvertString(STRIKE_PRICE, 10, 'R', ' ')#,#fileConvertString(OPTION_TYPE1, 2, 'L', ' ')#,#fileConvertString(LEFT(REPLACE(Scrip_SYMBOL,'CF','','ALL'),25), 25, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString('', 3, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(TRIM(USER_ID), 10, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(BSFlag, 1, 'L', ' ')#,#fileConvertString(Rate, 12, 'R', ' ')#,#fileConvertString(Quantity, 9, 'L', ' ')#,#fileConvertString('', 1, 'R', ' ')#,#fileConvertString(BROKER_CODE, 12, 'L', ' ')#,#fileConvertString(Client_ID, 10, 'L', ' ')#,#fileConvertString('CLOSE', 5, 'L', ' ')#,#fileConvertString('UNCOVER', 7, 'L', ' ')#,#fileConvertString(' ', 15, 'L', ' ')#,#fileConvertString(LEFT(TRDDATETIME,11), 20, 'L', ' ')#,#fileConvertString(LEFT(TRDDATETIME,11), 20, 'L', ' ')#,#fileConvertString('', 3, 'L', ' ')#">
			
			<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
		</CFLOOP>	
	</cfif>
	
	<cfif COCD EQ "CD_NSE">
		<CFSET	NSEData	=	"">
		<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		<CFFILE FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt" ACTION="WRITE" OUTPUT="" ADDNEWLINE="NO">
		
		<CFTRY>
			<cfquery name="DROPTABLE" datasource="#CLIENT.DATABASE#">	
				DROP TABLE ##SCRIPTEMPDATA
			</cfquery>
			<CFCATCH>
                       </CFCATCH>
		</CFTRY>	

		<cfquery name="GetClosingPrice" datasource="#CLIENT.DATABASE#">
			SELECT B.SCRIP_SYMBOL,B.EXPIRY_DATE,B.SCRIP_NAME
 			 INTO ##SCRIPTEMPDATA
			 FROM SCRIP_MASTER_TABLE B
 			 where
				SCRIP_SYMBOL LIKE 'FC%'

			select convert(Varchar(10),Market_Date,103) MarketDate,A.Instrument_Type,A.Scrip_symbol,Convert(Varchar(10),A.Expiry_Date,103) Exp_Date,
				   '' Option_Type,A.Strike_Price,MTM_PRICE,EXPIRY_PRICE,B.SCRIP_NAME SCRIP_NAME
			from mtmclosingprice A ,##SCRIPTEMPDATA B				
			Where
				A.SCRIP_SYMBOL = B.SCRIP_SYMBOL
			AND A.EXPIRY_DATE = B.EXPIRY_DATE
			AND convert(Datetime,Market_Date,103) = convert(Datetime,'#Trade_Date#',103)			

		</cfquery>
		<cfset clprice = "">
		<cfloop query="GetClosingPrice">
			<cfif Trim(Option_type) eq ''>
				<cfset Option_type123 = "">				
			<cfelse>
				<cfset Option_type123 = "#Option_type#">
			</cfif>
		
			<cfset clprice = "#trim(MarketDate)#,#trim(Instrument_Type)#,#trim(SCRIP_NAME)#,#Trim(Exp_Date)#,#trim(Strike_Price)#,#trim(Option_Type123)#,#MTM_PRICE#,0,,">
			<CFFILE FILE="C:\CFUSIONMX7\WWWROOT\REPORTS\TradeFiles\#cocd#ClosingPrice_#LEFT(REPLACE(TRADE_DATE,"/","","ALL"),4)#.txt" ACTION="append" OUTPUT="#ClPrice#" ADDNEWLINE="Yes">	
		</cfloop>
		
		
		<CFLOOP QUERY="selTrades">
			
			<CFLOOP LIST="#selTrades.ColumnList#" INDEX="GetData">
				<CFSET	#GetData#	=	Evaluate(GetData)>
			</CFLOOP>
			
			<CFSET	Rate	=	Price_Premium>
			
			<CFIF optRateType EQ "RateWithBrk">
				<CFIF Buy_Sale	EQ	"BUY">
					<CFSET	Rate	=	NumberFormat( (Price_Premium + (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				<CFELSEIF Buy_Sale	EQ	"SALE">
					<CFSET	Rate	=	NumberFormat( (Price_Premium - (Trade_Brokerage + Delivery_Brokerage)), "999999.9999")>
				</CFIF>
			<cfelse>
				<CFSET	Rate	=	NumberFormat( (Price_Premium), "999999.9999")>	
			</CFIF>
			
			
			<CFIF TRIM(OPTION_TYPE) EQ "FC">
				<CFSET OPTION_TYPE1 = "">
			<cfelse>
				<CFSET OPTION_TYPE1 = "#OPTION_TYPE#">	
			</CFIF>
			<CFIF	Buy_Sale EQ "Buy">
				<CFSET BSFlag	=	1>
			<CFELSE>
				<CFSET BSFlag	=	2>
			</CFIF>
			
			<CFSET	NSEData	=	"">				
			<CFSET	NSEData	=	"#fileConvertString('0', 7, 'L', ' ')#,#fileConvertString('', 2, 'R', ' ')#,#fileConvertString(UCASE(EXP_DATE1), 9, 'R', ' ')#,#fileConvertString(SCRIP_NAME, 10, 'L', ' ')#,#fileConvertString(INSTRUMENT_TYPE, 6, 'L', ' ')#,#fileConvertString(STRIKE_PRICE, 10, 'R', ' ')#,#fileConvertString(OPTION_TYPE1, 2, 'L', ' ')#,#fileConvertString(LEFT(TRIM(REPLACE(SCRIP_NAME,'CF','','ALL')),25), 25, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString('', 3, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(USER_ID, 10, 'L', ' ')#,#fileConvertString('', 2, 'L', ' ')#,#fileConvertString(BSFlag, 1, 'L', ' ')#,#fileConvertString(Rate, 12, 'R', ' ')#,#fileConvertString(NEWQTY, 9, 'L', ' ')#,#fileConvertString('', 1, 'R', ' ')#,#fileConvertString(BROKER_CODE, 12, 'L', ' ')#,#fileConvertString(Client_ID, 10, 'L', ' ')#,#fileConvertString('CLOSE', 5, 'L', ' ')#,#fileConvertString('UNCOVER', 7, 'L', ' ')#,#fileConvertString(' ', 15, 'L', ' ')#,#fileConvertString(Left(TRDDATETIME,11), 20, 'L', ' ')#,#fileConvertString(LEFT(TRDDATETIME,11), 20, 'L', ' ')#,#fileConvertString('', 3, 'L', ' ')#">
			
			<CFFILE FILE="#TradeFilePath#\#TradeFileName#.txt" ACTION="APPEND" output="#NSEData#" ADDNEWLINE="YES">
		</CFLOOP>	
	</cfif>
</cfoutput>
