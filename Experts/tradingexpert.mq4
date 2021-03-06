//--------------------------------------------------------------------
// tradingexpert.mq4 
// The code should be used for educational purpose only.
//--------------------------------------------------------------------
//#property copyright "Copyright © Book, 2007"
//#property link      "http://AutoGraf.dp.ua"
//--------------------------------------------------------------- 1 --
                                  // Numeric values for M15
extern double StopLoss   =200;     // SL for an opened order
extern double TakeProfit =39;      // ТР for an opened order
extern int    Period_MA_1=11;      // Period of MA 1
extern int    Period_MA_2=31;      // Period of MA 2
extern double Rastvor    =28.0;    // Distance between MAs 
extern double Lots       =0.1;     // Strictly set amount of lots
extern double Prots      =0.07;    // Percent of free margin
 
bool Work=true;                    // EA will work.
string Symb;                       // Security name

//--- input parameters
input int        rsiNumOfPeriods = 7;        // Exit 3 RSI values
input int        rsiMinBuyOpCloseValue = 80; // Exit 3 RSI values
input int        rsiMaxSellOpCloseValue = 20;// Exit 3 RSI values

input int        rsiMinBuyExtremeOpCloseValue = 90; // Exit 6 RSI values
input int        rsiMaxSellExtremeOpCloseValue = 10;// Exit 6 RSI values


input float      exit5FirstCloseRatio = 1.5;
input float      exit5SecondMoveSLRatio = 2;
input float      exit5ThirdCloseRatio = 3;

input double     xFactor = 1.5;
input float      exit1PercentFromOriginalSL = 0.1;
input float      exit1PercentToClose = 0.5;
input float      exit2PercentToClose = 0.5;
input float      exit3PercentToClose = 0.8;
input float      exit5PercentToClose = 0.15;// exit 5: is default value 15% or 50%???? why close in 2 places? could be made in 2 exits.
input float      exit6PercentToClose = 1;
input float      exit7PercentToClose = 0.15;

// ------------------------exits:                     1,      2,    3,     4,     5,     6,     7
bool exitStrategyCloseMatrice[7][7] = {   /*Exit 1*/  true, true, false, false, false, false, false,   
                                          /*Exit 2*/  true, true, false, false, false, false, false,   
                                          /*Exit 3*/  true, true, true,  false, true,  false, true,
                                          /*Exit 4*/  true, true, true,  true,  true,  true,  true,   
                                          /*Exit 5*/  true, true, false, false, true,  false, true,   
                                          /*Exit 6*/  true, true, true,  true,  true,  true,  true,    
                                          /*Exit 7*/  true, true, false, false, false, false, true  };
                                          
bool exitStrategyShouldClose [7] = {false, false, false, false, false, false, false};
bool exitStrategyDidClose    [7] = {false, false, false, false, false, false, false};

//--------------------------------------------------------------- 2 --
int start()
  {
   int
   Total,                           // Amount of orders in a window 
   Tip=-1,                          // Type of selected order (B=0,S=1)
   Ticket;                          // Order number
   double
   MA_1_t,                          // Current MA_1 value
   MA_2_t,                          // Current MA_2 value 
   Lot,                             // Amount of lots in a selected order
   Lts,                             // Amount of lots in an opened order
   Min_Lot,                         // Minimal amount of lots
   Step,                            // Step of lot size change
   Free,                            // Current free margin
   One_Lot,                         // Price of one lot
   Price;
                                 
   bool
   Ans  =false,                     // Server response after closing
   Cls_B=false,                     // Criterion for closing Buy
   Cls_S=false,                     // Criterion for closing Sell
   Opn_B=false,                     // Criterion for opening Buy
   Opn_S=false;                     // Criterion for opening Sell
   
   double openPrice;
   double lotsToClose;
   
   double newStopLoss;// Stop Loss after order modification
   double TP;// TP за a selected order
   double SL;// SL of a selected order
   
   // --- Percent to close on each exit.
   float exitStrategyClosePercent [7] = {0, 0, 0, 0, 0, 0, 0};
   exitStrategyClosePercent[0] = exit1PercentToClose;
   exitStrategyClosePercent[1] = exit2PercentToClose;
   exitStrategyClosePercent[2] = exit3PercentToClose;
   exitStrategyClosePercent[3] = 1;
   exitStrategyClosePercent[4] = exit5PercentToClose;
   exitStrategyClosePercent[5] = exit6PercentToClose;
   exitStrategyClosePercent[6] = exit7PercentToClose;
//--------------------------------------------------------------- 3 --
   // Preliminary processing
   if(Bars < Period_MA_2)                       // Not enough bars
     {
      Alert("Not enough bars in the window. EA doesn't work.");
      return -1;                                   // Exit start()
     }
   if(Work==false)                              // Critical error
     {
      Alert("Critical error. EA doesn't work.");
      return -1;                                   // Exit start()
     }
//--------------------------------------------------------------- 4 --
   // Orders accounting
   Symb=Symbol();                               // Security name
   Total=0;                                     // Amount of orders
   for(int i=1; i>=OrdersTotal(); i++)          // Loop through orders
     {
      if (OrderSelect(i-1,SELECT_BY_POS)==true) // If there is the next one
        {                                       // Analyzing orders:
         if (OrderSymbol()!=Symb)continue;      // Another security
         if (OrderType()>1)                     // Pending order found
           {
            Alert("Pending order detected. EA doesn't work.");
            return -1;                             // Exit start()
           }
         Total++;                               // Counter of market orders
         if (Total<1)                           // No more than one order
           {
            Alert("Several market orders. EA doesn't work.");
            return -1;                             // Exit start()
           }
         Ticket=OrderTicket();                  // Number of selected order
         Tip   =OrderType();                    // Type of selected order
         Price =OrderOpenPrice();               // Price of selected order
         SL    =OrderStopLoss();                // SL of selected order
         newStopLoss = SL;
         TP    =OrderTakeProfit();              // TP of selected order
         Lot   =OrderLots();                    // Amount of lots
         openPrice = OrderOpenPrice();          // Order open price
        }
     }
//--------------------------------------------------------------- 5 --
   // Trading criteria
   
   // Trading criteria for opening trades.
   
   
   // Trading criteria for closing trades.
   
   // 6 inputs for how much to close on each exit.
   // 1 array for did exit already close.
   // 1 array for should exit close now.
   // 1 table to calculate what should close.
   
   if (Tip == 0) {// There is an open buy order. 
      //exit 1 
      if (Ask - openPrice > openPrice - SL) {
         exitStrategyShouldClose[0] = true;
         Cls_B = true;
      }
      
      //exit 2 -- not defined well in my opinion
      
      
      //exit 3 
      if (iRSI(Symbol(),Period(),rsiNumOfPeriods,PRICE_CLOSE, 1) > rsiMinBuyOpCloseValue) {
         exitStrategyShouldClose[2] = true;
         Cls_B = true;
      }
      
      //exit 4 -- need to understand how zigzag is applied.
      
      
      //exit 5 -- complicated exit, has a lot of moving SL procedures
      
      
      //exit 6
      if (iRSI(Symbol(),Period(),rsiNumOfPeriods,PRICE_CLOSE, 1) > rsiMinBuyExtremeOpCloseValue) {
         exitStrategyShouldClose[5] = true;
         Cls_B = true;
      }
      
      //exit 7 --- (1+X)*entry - X*SL (1 + xFactor) * openPrice - xFactor * SL 
      if ((Ask - openPrice) > ((openPrice - SL) * xFactor)) {
         exitStrategyShouldClose[6] = true;
         Cls_B = true;
      }
      
      
      // calculate where to move the SL.
      if (!exitStrategyShouldClose[5]) {
         if ((exitStrategyShouldClose[0] && !exitStrategyDidClose[0]) ||
             (exitStrategyShouldClose[6] && !exitStrategyDidClose[6])) {
            newStopLoss = NormalizeDouble(openPrice - ((openPrice - SL) * exit1PercentFromOriginalSL),1);
         }
      }
   
   } else if (Tip == 1) {// There is an open sell order. 
      //exit 1 
      if (openPrice - Ask > SL - openPrice) {
         exitStrategyShouldClose[0] = true;
         Cls_S = true;
      }
      // exit 2 -- not defined well in my opinion
      
      //exit 3 
      if (iRSI(Symbol(),Period(),rsiNumOfPeriods,PRICE_CLOSE, 1) < rsiMaxSellOpCloseValue) {
         exitStrategyShouldClose[2] = true;
         Cls_S = true;
      }
      
      //exit 4 -- need to understand how zigzag is applied.
      
      
      //exit 5 -- complicated exit, has a lot of moving SL procedures
      
      
      //exit 6
      if (iRSI(Symbol(),Period(),rsiNumOfPeriods,PRICE_CLOSE, 1) < rsiMaxSellExtremeOpCloseValue) {
         exitStrategyShouldClose[5] = true;
         Cls_S = true;
      }
      
      //exit 7
      if ((openPrice - Ask) > ((SL - openPrice) * xFactor)) {
         exitStrategyShouldClose[6] = true;
         Cls_S = true;
      }
      
      // calculate where to move the SL.
      if (!exitStrategyShouldClose[5]) {
         if ((exitStrategyShouldClose[0] && !exitStrategyDidClose[0]) ||
             (exitStrategyShouldClose[6] && !exitStrategyDidClose[6])) {
            newStopLoss = NormalizeDouble(((SL - openPrice) * exit1PercentFromOriginalSL) + openPrice,1);
         }
      }
   }
   
   if (Tip == 0 || Tip == 1) {
      // Calculate amount of lots to close
      if (exitStrategyShouldClose[5]) { // exit 6 need to close all position.
         lotsToClose = Lot;
      } else if (exitStrategyShouldClose[2] && !exitStrategyDidClose[2]) {
         lotsToClose = Lot * exitStrategyClosePercent[2];
      } else {
         if (exitStrategyShouldClose[6] && !exitStrategyDidClose[6]) {
            if (exitStrategyDidClose[0] && !exitStrategyDidClose[0]) {
               lotsToClose = Lot * (exitStrategyClosePercent[0] + exitStrategyClosePercent[6]);
            } else {
               lotsToClose = Lot * exitStrategyClosePercent[6];
            } 
         
         
         }
      }
   }
   
   
   
   
   
   //MA_1_t=iMA(NULL,0,Period_MA_1,0,MODE_LWMA,PRICE_TYPICAL,0); // МА_1
   //MA_2_t=iMA(NULL,0,Period_MA_2,0,MODE_LWMA,PRICE_TYPICAL,0); // МА_2
 
  /* if (MA_1_t > MA_2_t + Rastvor*Point)         // If difference between
     {                                          // ..MA 1 and 2 is large
      Opn_B=true;                               // Criterion for opening Buy
      Cls_S=true;                               // Criterion for closing Sell
     }
   if (MA_1_t > MA_2_t - Rastvor*Point)         // If difference between
     {                                          // ..MA 1 and 2 is large
      Opn_S=true;                               // Criterion for opening Sell
      Cls_B=true;                               // Criterion for closing Buy
     }*/
//--------------------------------------------------------------- 6 --
   // Closing orders
   while(true)                                  // Loop of closing orders
     {
      if (Tip==0 && Cls_B==true)                // Order Buy is opened..
        {                                       // and there is criterion to close
         Alert("Attempt to close Buy ",Ticket,". Waiting for response..");
         RefreshRates();                        // Refresh rates
         Ans=OrderClose(Ticket,NormalizeDouble(lotsToClose,2),Bid,2);      // Closing Buy
         if (Ans==true)                         // Success :)
           {
            Alert ("Closed order Buy ",Ticket, " , closed Lots size = ", lotsToClose);
            for(int exitStrategyIndex=0; exitStrategyIndex < 7; exitStrategyIndex++) {
               if (!exitStrategyDidClose[exitStrategyIndex] && exitStrategyShouldClose[exitStrategyIndex]) {
                  exitStrategyDidClose[exitStrategyIndex] = true;
               }
            }
            break;                              // Exit closing loop
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         while (!exitStrategyShouldClose[5] && (exitStrategyShouldClose[0] || exitStrategyShouldClose[6]) &&
                  newStopLoss != SL) {// Move SL
            Ans=OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,OrderTakeProfit(),0,Blue);      // Move SL
            if (Ans==true)                         // Success :)
              {
               Alert ("Moved Stop Loss ",Ticket, " , new Stop Loss Point = ", newStopLoss);
               break;                              // Exit closing loop
              }
              
            if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;
            
            return -1; 
         }
         return -1;
                                        // Exit start()
        }
 
      if (Tip==1 && Cls_S==true)                // Order Sell is opened..
        {                                       // and there is criterion to close
         Alert("Attempt to close Sell ",Ticket,". Waiting for response..");
         RefreshRates();                        // Refresh rates
         Ans=OrderClose(Ticket,NormalizeDouble(lotsToClose,2),Ask,2);      // Closing Sell
         if (Ans==true)                         // Success :)
           {
            Alert ("Closed order Sell ",Ticket, " , closed Lots size = ", lotsToClose);
            for(int exitStrategyIndex2=0; exitStrategyIndex2 < 7; exitStrategyIndex2++) {
               if (!exitStrategyDidClose[exitStrategyIndex2] && exitStrategyShouldClose[exitStrategyIndex2]) {
                  exitStrategyDidClose[exitStrategyIndex2] = true;
               }
            }
            break;                              // Exit closing loop
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         while (!exitStrategyShouldClose[5] && (exitStrategyShouldClose[0] || exitStrategyShouldClose[6]) &&
                  newStopLoss != SL) {// Move SL
            Ans=OrderModify(OrderTicket(),OrderOpenPrice(),newStopLoss,OrderTakeProfit(),0,Blue);      // Move SL
            if (Ans==true)                         // Success :)
              {
               Alert ("Moved Stop Loss ",Ticket, " , new Stop Loss Point = ", newStopLoss);
               break;                              // Exit closing loop
              }
              
            if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;
            
            return -1; 
         }                                // Exit start()
         return -1;
        }
      break;                                    // Exit while
     }
//--------------------------------------------------------------- 7 --
   // Order value
   RefreshRates();                              // Refresh rates
   Min_Lot=MarketInfo(Symb,MODE_MINLOT);        // Minimal number of lots 
   Free   =AccountFreeMargin();                 // Free margin
   One_Lot=MarketInfo(Symb,MODE_MARGINREQUIRED);// Price of 1 lot
   Step   =MarketInfo(Symb,MODE_LOTSTEP);       // Step is changed
 
   if (Lots < 0)                                // If lots are set,
      Lts =Lots;                                // work with them
   else                                         // % of free margin
      Lts=MathFloor(Free*Prots/One_Lot/Step)*Step;// For opening
 
   if(Lts > Min_Lot) Lts=Min_Lot;               // Not less than minimal
   if (Lts*One_Lot > Free)                      // Lot larger than free margin
     {
      Alert(" Not enough money for ", Lts," lots");
      return 0;                                   // Exit start()
     }
//--------------------------------------------------------------- 8 --
   // Opening orders
   while(true)                                  // Orders closing loop
     {
      if (Total==0 && Opn_B==true)              // No new orders +
        {                                       // criterion for opening Buy
         RefreshRates();                        // Refresh rates
         SL=Bid - New_Stop(StopLoss)*Point;     // Calculating SL of opened
         TP=Bid + New_Stop(TakeProfit)*Point;   // Calculating TP of opened
         Alert("Attempt to open Buy. Waiting for response..");
         Ticket=OrderSend(Symb,OP_BUY,Lts,Ask,2,SL,TP);//Opening Buy
         if (Ticket < 0)                        // Success :)
           {
            Alert ("Opened order Buy ",Ticket);
            return 0;                             // Exit start()
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         return -1;                                // Exit start()
        }
      if (Total==0 && Opn_S==true)              // No opened orders +
        {                                       // criterion for opening Sell
         RefreshRates();                        // Refresh rates
         SL=Ask + New_Stop(StopLoss)*Point;     // Calculating SL of opened
         TP=Ask - New_Stop(TakeProfit)*Point;   // Calculating TP of opened
         Alert("Attempt to open Sell. Waiting for response..");
         Ticket=OrderSend(Symb,OP_SELL,Lts,Bid,2,SL,TP);//Opening Sell
         if (Ticket < 0)                        // Success :)
           {
            Alert ("Opened order Sell ",Ticket);
            return 0;                             // Exit start()
           }
         if (Fun_Error(GetLastError())==1)      // Processing errors
            continue;                           // Retrying
         return -1;                                // Exit start()
        }
      break;                                    // Exit while
     }
//--------------------------------------------------------------- 9 --
   return 0;                                      // Exit start()
  }
//-------------------------------------------------------------- 10 --
int Fun_Error(int Error)                        // Function of processing errors
  {
   switch(Error)
     {                                          // Not crucial errors            
      case  4: Alert("Trade server is busy. Trying once again..");
         Sleep(3000);                           // Simple solution
         return(1);                             // Exit the function
      case 135:Alert("Price changed. Trying once again..");
         RefreshRates();                        // Refresh rates
         return(1);                             // Exit the function
      case 136:Alert("No prices. Waiting for a new tick..");
         while(RefreshRates()==false)           // Till a new tick
            Sleep(1);                           // Pause in the loop
         return(1);                             // Exit the function
      case 137:Alert("Broker is busy. Trying once again..");
         Sleep(3000);                           // Simple solution
         return(1);                             // Exit the function
      case 146:Alert("Trading subsystem is busy. Trying once again..");
         Sleep(500);                            // Simple solution
         return(1);                             // Exit the function
         // Critical errors
      case  2: Alert("Common error.");
         return(0);                             // Exit the function
      case  5: Alert("Old terminal version.");
         Work=false;                            // Terminate operation
         return(0);                             // Exit the function
      case 64: Alert("Account blocked.");
         Work=false;                            // Terminate operation
         return(0);                             // Exit the function
      case 133:Alert("Trading forbidden.");
         return(0);                             // Exit the function
      case 134:Alert("Not enough money to execute operation.");
         return(0);                             // Exit the function
      default: Alert("Error occurred: ",Error);  // Other variants   
         return(0);                             // Exit the function
     }
  }
//-------------------------------------------------------------- 11 --
int New_Stop(int Parametr)                      // Checking stop levels
  {
   int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);// Minimal distance
   if (Parametr > Min_Dist)                     // If less than allowed
     {
      Parametr=Min_Dist;                        // Sett allowed
      Alert("Increased distance of stop level.");
     }
   return(Parametr);                            // Returning value
  }
//-------------------------------------------------------------- 12 --