//PIC16F886 on MikroC
sbit led at RC0_bit;
sbit water_sensor at RC2_bit;
sbit uart_tx at RC6_bit;
sbit uart_rx at RC7_bit;

char time;

void clock(){
  IRCF0_bit = 1;//8 MHz
  IRCF1_bit = 1;
  IRCF2_bit = 1;
  while(!HTS_bit);
  Delay_ms(10);
}

void config(){
  ANSEL = 0;//digital I/O pins
  ANSELH = 0;//digital I/O pins
  TRISA = 0xff;//all as inputs
  TRISB = 0xff;//all as inputs
  TRISC = 0xfe;//RC0 as output, others as inputs
  
  //configure timer0
  OPTION_REG = 0x84;//1:32
  TMR0 = 6;
  
  //configure timer1
  T1CON = 0x31;//1:8
  
  //configure ccp
  CCP1CON = 0x05;//capture every rising edge
  CCP1IF_bit = 0;//clear flag
  CCP1IE_bit = 1;//enable capture interrupts
  INTCON = 0xc0;//enable global and peripheral interrupts
  
  //configure uart
  UART1_Init(9600);
}

void interrupt(){
  long period;
  float flowrate;
  char flow[15], txt[12], time2 = 0;

  //skip first pulse
  CCP1IF_bit = 0;
  TMR1L = 0;
  TMR1H = 0;
  //wait for next interrupt
  while(CCP1IF_bit == 0);
  TMR1L = 0;
  TMR1H = 0;
  //get the period
  period = CCPR1H;
  period = period << 8;
  period += CCPR1L;
  //get the flowrate
  period = period * 30;
  
  LongToStr(period, txt);
  UART1_Write_Text("Period*7.5: ");
  UART1_Write_Text(txt);
  
  flowrate = 1000000.0 / period;
  FloatToStr(flowrate, flow);
  UART1_Write_Text(" us, Flowrate: ");
  UART1_Write_Text(flow);
  UART1_Write_Text(" L/min ");
  
  TMR0 = 6;
  T0IF_bit = 0;
  while(time2 < 125){//500 ms delay
    if(T0IF_bit){
      time2++;
      time++;
      if(time > 250)
        time = 250;
      T0IF_bit = 0;
      TMR0 = 6;
    }  
  }
  CCP1IF_bit = 0;
}

void main() {
  clock();
  config();
  
  while(1){
    led = !led;
    
    time = 0;
    T0IF_bit = 0;
    while(time < 250){//1 s delay
      if(T0IF_bit){
        time++;
        T0IF_bit = 0;
        TMR0 = 6;
      }  
    }
  }  
}