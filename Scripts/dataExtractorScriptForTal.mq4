//+------------------------------------------------------------------+
//|                                          dataExtractorScript.mq4 |
//|                                                      Ohad Behore |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Ohad Behore"
#property link      ""
#property version   "1.00"
#property strict

datetime newestBarTime = Time[0];
MqlRates mqlRatesArr[10000];
MqlRates mqlRates15MinutesArr[10000];
MqlRates mqlRates4HourArr[10000];
MqlRates mqlRatesDailyArr[10000];
//string symbolSets[100];
//+------------------------------------------------------------------+
//| Script program start function                                    |
//+------------------------------------------------------------------+
void OnStart()
  {
      string subfolder="pinbar_data_for_tal";
      
      int filehandleReadSymbols=FileOpen(subfolder+"\\" + "universe.set",FILE_READ|FILE_TXT);
      if(filehandleReadSymbols > 0){
      
      //int    str_size;
      string currentSymbol;
      //int symbolIndex = 0;
      //str = FileReadString(filehandleReadSymbols);
      //--- read data from the file
      while(!FileIsEnding(filehandleReadSymbols)){
            //str=FileReadString(file_handle,str_size);
            /*symbolSets[symbolIndex]*/currentSymbol = FileReadString(filehandleReadSymbols);
            //symbolSets[symbolIndex] = str;
            //symbolIndex++;
      
         int filehandle=FileOpen(subfolder+"\\" + currentSymbol+  /*_Period*/"5" + ".csv",FILE_WRITE|FILE_CSV);
         int filehandle15Minutes=FileOpen(subfolder+"\\" + currentSymbol+  /*_Period*/"15" + ".csv",FILE_WRITE|FILE_CSV);
         //int filehandle4Hour=FileOpen(subfolder+"\\" + currentSymbol+  "240.csv",FILE_WRITE|FILE_CSV);
         //int filehandleDaily=FileOpen(subfolder+"\\" + currentSymbol+  "1440.csv",FILE_WRITE|FILE_CSV);
      
         if(filehandle > 0 && filehandle15Minutes > 0/*&& filehandle4Hour > 0 && filehandleDaily > 0*/) {
         //int file_size=FileSize(filehandle);

         //if (newestBarTime!= Time[0] || file_size <= 0) {//Calculate the pinbar data once a new bar is created.
             newestBarTime =  Time[0];
          
         
            //FileWrite(filehandle,TimeCurrent(),/*Symbol()*/symbolSets[i],/*_Period*/60, PERIOD_CURRENT);
            
            
            int copied=CopyRates(currentSymbol,PERIOD_M5,0,10000,mqlRatesArr);
            //FileWrite(filehandle,"copied " + copied + " candles. ");
            
            int copied15Minutes=CopyRates(currentSymbol,PERIOD_M15,0,10000,mqlRates15MinutesArr);
            
            //int copied4Hour=CopyRates(/*Symbol()*/currentSymbol,/*_Period*/240,0,10000,mqlRates4HourArr);
            //int copiedDaily=CopyRates(/*Symbol()*/currentSymbol,/*_Period*/1440,0,10000,mqlRatesDailyArr);
            
               int counter=1;
               //FileWrite(filehandle,"Time", "Period", "Open","High","Low","Close","Volume","Moving Average 20", "Bollinger Bands");
               for(int i=0; i<copied; i++)
               {
                  
                  FileWrite(filehandle,mqlRatesArr[i].time, PERIOD_M5, mqlRatesArr[i].open,mqlRatesArr[i].high,mqlRatesArr[i].low,mqlRatesArr[i].close,mqlRatesArr[i].real_volume,
                  //iMA(currentSymbol,PERIOD_M5,14,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1), 
                  //iMA(currentSymbol,PERIOD_M5,21,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1), 
                  //iMA(currentSymbol,PERIOD_M5,200,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1), 
                  iBands(currentSymbol, PERIOD_M5, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRatesArr) - i - 1),
                  iMA(currentSymbol,PERIOD_M5,20,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1),
                  iBands(currentSymbol, PERIOD_M5, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRatesArr) - i - 1),
                  iBands(currentSymbol, PERIOD_M5, 10, 1.9, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRatesArr) - i - 1),
                  iMA(currentSymbol,PERIOD_M5,10,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1),
                  iBands(currentSymbol, PERIOD_M5, 10, 1.9, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRatesArr) - i - 1),
                  iRSI(currentSymbol,PERIOD_M5,14,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1)//,
                  /*iMACD(currentSymbol,PERIOD_M5,12,26,9,PRICE_CLOSE,MODE_MAIN,ArraySize(mqlRatesArr) - i - 1)*/);
               }
               
               for(int i=0; i<copied15Minutes; i++)
               {
                  
                     FileWrite(filehandle15Minutes,mqlRates15MinutesArr[i].time, PERIOD_M15, mqlRates15MinutesArr[i].open,mqlRates15MinutesArr[i].high,mqlRates15MinutesArr[i].low,mqlRates15MinutesArr[i].close,mqlRates15MinutesArr[i].real_volume,
                     //iMA(currentSymbol,PERIOD_M15,14,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates15MinutesArr) - i - 1), 
                     //iMA(currentSymbol,PERIOD_M15,21,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates15MinutesArr) - i - 1), 
                     //iMA(currentSymbol,PERIOD_M15,200,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates15MinutesArr) - i - 1), 
                     iBands(currentSymbol, PERIOD_M15, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRates15MinutesArr) - i - 1),
                     iMA(currentSymbol,PERIOD_M15,20,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates15MinutesArr) - i - 1),
                     iBands(currentSymbol, PERIOD_M15, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRates15MinutesArr) - i - 1),
                     iBands(currentSymbol, PERIOD_M15, 10, 1.9, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRates15MinutesArr) - i - 1),
                     iMA(currentSymbol,PERIOD_M15,10,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates15MinutesArr) - i - 1),
                     iBands(currentSymbol, PERIOD_M15, 10, 1.9, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRates15MinutesArr) - i - 1),
                     iRSI(currentSymbol,PERIOD_M15,14,PRICE_CLOSE,ArraySize(mqlRates15MinutesArr) - i - 1)//,
                     /*iMACD(currentSymbol,PERIOD_M15,12,26,9,PRICE_CLOSE,MODE_MAIN,ArraySize(mqlRates15MinutesArr) - i - 1)*/);
                  
               }
               /*for(int i=0; i<copied; i++)
               {
                  
                  FileWrite(filehandle,mqlRatesArr[i].time, PERIOD_H1, mqlRatesArr[i].open,mqlRatesArr[i].high,mqlRatesArr[i].low,mqlRatesArr[i].close,mqlRatesArr[i].real_volume,
                  iMA(currentSymbol,PERIOD_H1,14,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1), 
                  iMA(currentSymbol,PERIOD_H1,21,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1), 
                  iMA(currentSymbol,PERIOD_H1,200,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1), 
                  iBands(currentSymbol, PERIOD_H1, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRatesArr) - i - 1),
                  iMA(currentSymbol,PERIOD_H1,20,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1),
                  iBands(currentSymbol, PERIOD_H1, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRatesArr) - i - 1),
                  iBands(currentSymbol, PERIOD_H1, 10, 1.9, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRatesArr) - i - 1),
                  iMA(currentSymbol,PERIOD_H1,10,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1),
                  iBands(currentSymbol, PERIOD_H1, 10, 1.9, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRatesArr) - i - 1),
                  iRSI(currentSymbol,PERIOD_H1,14,PRICE_CLOSE,ArraySize(mqlRatesArr) - i - 1),
                  iMACD(currentSymbol,PERIOD_H1,12,26,9,PRICE_CLOSE,MODE_MAIN,ArraySize(mqlRatesArr) - i - 1));
               }
               
               for(int i=0; i<copied4Hour; i++)
               {
                  FileWrite(filehandle4Hour,mqlRates4HourArr[i].time, PERIOD_H4, mqlRates4HourArr[i].open,mqlRates4HourArr[i].high,mqlRates4HourArr[i].low,mqlRates4HourArr[i].close,mqlRates4HourArr[i].real_volume,
                  iMA(currentSymbol,PERIOD_H4,14,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates4HourArr) - i - 1), 
                  iMA(currentSymbol,PERIOD_H4,21,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates4HourArr) - i - 1),
                  iMA(currentSymbol,PERIOD_H4,200,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates4HourArr) - i - 1),
                  iBands(currentSymbol, PERIOD_H4, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRates4HourArr) - i - 1),
                  iMA(currentSymbol,PERIOD_H4,20,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates4HourArr) - i - 1),
                  iBands(currentSymbol, PERIOD_H4, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRates4HourArr) - i - 1),
                  iBands(currentSymbol, PERIOD_H4, 10, 1.9, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRates4HourArr) - i - 1),
                  iMA(currentSymbol,PERIOD_H4,10,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRates4HourArr) - i - 1),
                  iBands(currentSymbol, PERIOD_H4, 10, 1.9, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRates4HourArr) - i - 1),
                  iRSI(currentSymbol,PERIOD_H4,14,PRICE_CLOSE,ArraySize(mqlRates4HourArr) - i - 1),
                  iMACD(currentSymbol,PERIOD_H4,12,26,9,PRICE_CLOSE,MODE_MAIN,ArraySize(mqlRates4HourArr) - i - 1));
               }
               
               for(int i=0; i<copiedDaily; i++)
               {
                  FileWrite(filehandleDaily,mqlRatesDailyArr[i].time, PERIOD_D1, mqlRatesDailyArr[i].open,mqlRatesDailyArr[i].high,mqlRatesDailyArr[i].low,mqlRatesDailyArr[i].close,mqlRatesDailyArr[i].real_volume,
                  iMA(currentSymbol,1440,14,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesDailyArr) - i - 1), 
                  iMA(currentSymbol,1440,21,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesDailyArr) - i - 1),
                  iMA(currentSymbol,1440,200,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesDailyArr) - i - 1),
                  iBands(currentSymbol, PERIOD_D1, 20, 2, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRatesDailyArr) - i - 1),
                  iMA(currentSymbol,1440,20,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesDailyArr) - i - 1),
                  iBands(currentSymbol, PERIOD_D1, 20, 2, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRatesDailyArr) - i - 1),
                  iBands(currentSymbol, PERIOD_D1, 10, 1.9, 0, PRICE_CLOSE, MODE_UPPER, ArraySize(mqlRatesDailyArr) - i - 1),
                  iMA(currentSymbol,1440,10,0,MODE_SMA,PRICE_CLOSE,ArraySize(mqlRatesDailyArr) - i - 1),
                  iBands(currentSymbol, PERIOD_D1, 10, 1.9, 0, PRICE_CLOSE, MODE_LOWER, ArraySize(mqlRatesDailyArr) - i - 1),
                  iRSI(currentSymbol,PERIOD_D1,14,PRICE_CLOSE,ArraySize(mqlRatesDailyArr) - i - 1),
                  iMACD(currentSymbol,PERIOD_D1,12,26,9,PRICE_CLOSE,MODE_MAIN,ArraySize(mqlRatesDailyArr) - i - 1));
               }*/
            
            
           //}
           }
           FileClose(filehandle);
           FileClose(filehandle15Minutes);
           //FileClose(filehandle4Hour);
           //FileClose(filehandleDaily);
         }
           FileClose(filehandleReadSymbols);
           Print("The file most be created in the folder " + subfolder);
         
      } else Print("File open failed, error ",GetLastError());
  }
//+------------------------------------------------------------------+
