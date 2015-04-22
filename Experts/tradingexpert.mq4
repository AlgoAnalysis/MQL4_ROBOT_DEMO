//--------------------------------------------------------------------
// tradingexpert.mq4 
// ������������ ��� ������������� � �������� ������� � �������� MQL4.
//--------------------------------------------------------------------
#property copyright "Copyright � Book, 2007"
#property link      "http://AutoGraf.dp.ua"
//--------------------------------------------------------------- 1 --
                                   // ��������� �������� ��� �15
extern double StopLoss   =200;     // SL ��� ������������ ������
extern double TakeProfit =39;      // �� ��� ������������ ������
extern int    Period_MA_1=11;      // ������ �� 1
extern int    Period_MA_2=31;      // ������ �� 2
extern double Rastvor    =28.0;    // ���������� ����� �� 
extern double Lots       =0.1;     // ������ �������� �����. �����
extern double Prots      =0.07;    // ������� ��������� �������

bool Work=true;                    // ������� ����� ��������.
string Symb;                       // �������� ������. �����������
//--------------------------------------------------------------- 2 --
int start()
  {
   int
   Total,                           // ���������� ������� � ���� 
   Tip=-1,                          // ��� ������. ������ (B=0,S=1)
   Ticket;                          // ����� ������
   double
   MA_1_t,                          // ������. ��_1 �������
   MA_2_t,                          // ������. ��_2 ������� 
   Lot,                             // �����. ����� � ������.������
   Lts,                             // �����. ����� � ������.������
   Min_Lot,                         // ����������� ���������� �����
   Step,                            // ��� ��������� ������� ����
   Free,                            // ������� ��������� ��������
   One_Lot,                         // ��������� ������ ����
   Price,                           // ���� ���������� ������
   SL,                              // SL ���������� ������ 
   TP;                              // TP ���������� ������
   bool
   Ans  =false,                     // ����� ������� ����� ��������
   Cls_B=false,                     // �������� ��� ��������  Buy
   Cls_S=false,                     // �������� ��� ��������  Sell
   Opn_B=false,                     // �������� ��� ��������  Buy
   Opn_S=false;                     // �������� ��� ��������  Sell
//--------------------------------------------------------------- 3 --
   // ���������.���������
   if(Bars < Period_MA_2)                       // ������������ �����
     {
      Alert("������������ ����� � ����. ������� �� ��������.");
      return;                                   // ����� �� start()
     }
   if(Work==false)                              // ����������� ������
     {
      Alert("����������� ������. ������� �� ��������.");
      return;                                   // ����� �� start()
     }
//--------------------------------------------------------------- 4 --
   // ���� �������
   Symb=Symbol();                               // �������� ���.�����.
   Total=0;                                     // ���������� �������
   for(int i=1; i<=OrdersTotal(); i++)          // ���� �������� �����
     {
      if (OrderSelect(i-1,SELECT_BY_POS)==true) // ���� ���� ���������
        {                                       // ������ �������:
         if (OrderSymbol()!=Symb)continue;      // �� ��� ���. �������
         if (OrderType()>1)                     // ������� ����������
           {
            Alert("��������� ���������� �����. ������� �� ��������.");
            return;                             // ����� �� start()
           }
         Total++;                               // ������� ������. ���
         if (Total>1)                           // �� ����� ������ ���
           {
            Alert("��������� �������� �������. ������� �� ��������.");
            return;                             // ����� �� start()
           }
         Ticket=OrderTicket();                  // ����� �������. ���.
         Tip   =OrderType();                    // ��� ���������� ���.
         Price =OrderOpenPrice();               // ���� �������. ���.
         SL    =OrderStopLoss();                // SL ���������� ���.
         TP    =OrderTakeProfit();              // TP ���������� ���.
         Lot   =OrderLots();                    // ���������� �����
        }
     }
//--------------------------------------------------------------- 5 --
   // �������� ��������
   MA_1_t=iMA(NULL,0,Period_MA_1,0,MODE_LWMA,PRICE_TYPICAL,0); // ��_1
   MA_2_t=iMA(NULL,0,Period_MA_2,0,MODE_LWMA,PRICE_TYPICAL,0); // ��_2

   if (MA_1_t > MA_2_t + Rastvor*Point)         // ���� ������� �����
     {                                          // ..�� 1 � 2 �������
      Opn_B=true;                               // �������� ����. Buy
      Cls_S=true;                               // �������� ����. Sell
     }
   if (MA_1_t < MA_2_t - Rastvor*Point)         // ���� ������� �����
     {                                          // ..�� 1 � 2 �������
      Opn_S=true;                               // �������� ����. Sell
      Cls_B=true;                               // �������� ����. Buy
     }
//--------------------------------------------------------------- 6 --
   // �������� �������
   while(true)                                  // ���� �������� ���.
     {
      if (Tip==0 && Cls_B==true)                // ������ ����� Buy..
        {                                       //� ���� �������� ����
         Alert("������� ������� Buy ",Ticket,". �������� ������..");
         RefreshRates();                        // ���������� ������
         Ans=OrderClose(Ticket,Lot,Bid,2);      // �������� Buy
         if (Ans==true)                         // ���������� :)
           {
            Alert ("������ ����� Buy ",Ticket);
            break;                              // ����� �� ����� ����
           }
         if (Fun_Error(GetLastError())==1)      // ��������� ������
            continue;                           // ��������� �������
         return;                                // ����� �� start()
        }

      if (Tip==1 && Cls_S==true)                // ������ ����� Sell..
        {                                       // � ���� �������� ����
         Alert("������� ������� Sell ",Ticket,". �������� ������..");
         RefreshRates();                        // ���������� ������
         Ans=OrderClose(Ticket,Lot,Ask,2);      // �������� Sell
         if (Ans==true)                         // ���������� :)
           {
            Alert ("������ ����� Sell ",Ticket);
            break;                              // ����� �� ����� ����
           }
         if (Fun_Error(GetLastError())==1)      // ��������� ������
            continue;                           // ��������� �������
         return;                                // ����� �� start()
        }
      break;                                    // ����� �� while
     }
//--------------------------------------------------------------- 7 --
   // ��������� �������
   RefreshRates();                              // ���������� ������
   Min_Lot=MarketInfo(Symb,MODE_MINLOT);        // �����. �����. ����� 
   Free   =AccountFreeMargin();                 // ������� ��������
   One_Lot=MarketInfo(Symb,MODE_MARGINREQUIRED);// ��������� 1 ����
   Step   =MarketInfo(Symb,MODE_LOTSTEP);       // ��� ������� �������

   if (Lots > 0)                                // ���� ������ ����,�� 
      Lts =Lots;                                // � ���� � �������� 
   else                                         // % ��������� �������
      Lts=MathFloor(Free*Prots/One_Lot/Step)*Step;// ��� ��������

   if(Lts < Min_Lot) Lts=Min_Lot;               // �� ������ ���������
   if (Lts*One_Lot > Free)                      // ��� ������ �������.
     {
      Alert(" �� ������� ����� �� ", Lts," �����");
      return;                                   // ����� �� start()
     }
//--------------------------------------------------------------- 8 --
   // �������� �������
   while(true)                                  // ���� �������� ���.
     {
      if (Total==0 && Opn_B==true)              // �������� ���. ��� +
        {                                       // �������� ����. Buy
         RefreshRates();                        // ���������� ������
         SL=Bid - New_Stop(StopLoss)*Point;     // ���������� SL ����.
         TP=Bid + New_Stop(TakeProfit)*Point;   // ���������� TP ����.
         Alert("������� ������� Buy. �������� ������..");
         Ticket=OrderSend(Symb,OP_BUY,Lts,Ask,2,SL,TP);//�������� Buy
         if (Ticket > 0)                        // ���������� :)
           {
            Alert ("������ ����� Buy ",Ticket);
            return;                             // ����� �� start()
           }
         if (Fun_Error(GetLastError())==1)      // ��������� ������
            continue;                           // ��������� �������
         return;                                // ����� �� start()
        }
      if (Total==0 && Opn_S==true)              // �������� ���. ��� +
        {                                       // �������� ����. Sell
         RefreshRates();                        // ���������� ������
         SL=Ask + New_Stop(StopLoss)*Point;     // ���������� SL ����.
         TP=Ask - New_Stop(TakeProfit)*Point;   // ���������� TP ����.
         Alert("������� ������� Sell. �������� ������..");
         Ticket=OrderSend(Symb,OP_SELL,Lts,Bid,2,SL,TP);//�������� Sel
         if (Ticket > 0)                        // ���������� :)
           {
            Alert ("������ ����� Sell ",Ticket);
            return;                             // ����� �� start()
           }
         if (Fun_Error(GetLastError())==1)      // ��������� ������
            continue;                           // ��������� �������
         return;                                // ����� �� start()
        }
      break;                                    // ����� �� while
     }
//--------------------------------------------------------------- 9 --
   return;                                      // ����� �� start()
  }
//-------------------------------------------------------------- 10 --
int Fun_Error(int Error)                        // �-�� ������� ������
  {
   switch(Error)
     {                                          // ����������� ������            
      case  4: Alert("�������� ������ �����. ������� ��� ���..");
         Sleep(3000);                           // ������� �������
         return(1);                             // ����� �� �������
      case 135:Alert("���� ����������. ������� ��� ���..");
         RefreshRates();                        // ������� ������
         return(1);                             // ����� �� �������
      case 136:Alert("��� ���. ��� ����� ���..");
         while(RefreshRates()==false)           // �� ������ ����
            Sleep(1);                           // �������� � �����
         return(1);                             // ����� �� �������
      case 137:Alert("������ �����. ������� ��� ���..");
         Sleep(3000);                           // ������� �������
         return(1);                             // ����� �� �������
      case 146:Alert("���������� �������� ������. ������� ���..");
         Sleep(500);                            // ������� �������
         return(1);                             // ����� �� �������
         // ����������� ������
      case  2: Alert("����� ������.");
         return(0);                             // ����� �� �������
      case  5: Alert("������ ������ ���������.");
         Work=false;                            // ������ �� ��������
         return(0);                             // ����� �� �������
      case 64: Alert("���� ������������.");
         Work=false;                            // ������ �� ��������
         return(0);                             // ����� �� �������
      case 133:Alert("�������� ���������.");
         return(0);                             // ����� �� �������
      case 134:Alert("������������ ����� ��� ���������� ��������.");
         return(0);                             // ����� �� �������
      default: Alert("�������� ������ ",Error); // ������ ��������   
         return(0);                             // ����� �� �������
     }
  }
//-------------------------------------------------------------- 11 --
int New_Stop(int Parametr)                      // �������� ����-����.
  {
   int Min_Dist=MarketInfo(Symb,MODE_STOPLEVEL);// �����. ���������
   if (Parametr<Min_Dist)                       // ���� ������ ������.
     {
      Parametr=Min_Dist;                        // ��������� ������.
      Alert("��������� ��������� ����-�������.");
     }
   return(Parametr);                            // ������� ��������
  }
//-------------------------------------------------------------- 12 --