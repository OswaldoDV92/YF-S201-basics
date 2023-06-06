//PIC16F886 on MikroC
sbit led at RC0_bit;
sbit water_sensor at RB0_bit;
sbit uart_tx at RC6_bit;
sbit uart_rx at RC7_bit;

char pulses = 0, time = 0;

void clock(){
  IRCF0_bit = 0;//4 MHz
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
  
  //configure timer1 for a period of 500 ms
  T1CON = 0x31;//1:8
  TMR1L = 0xdc;
  TMR1H = 0x0b;
  TMR1IE_bit = 1;
  
  //configure external interrupt
  INTEDG_bit = 1;//use rising edge
  INTCON = 0xd0;//enable global, peripheral and external interrupts
  
  //configure uart
  UART1_Init(9600);
}

void interrupt(){
  if(INTF_bit){//count the pulses
    pulses++;
    INTF_bit = 0;
  }        
  
  if(TMR1IF_bit){//increment sample time flag
    TMR1L = 0xdc;
    TMR1H = 0x0b;
    time++;
    TMR1IF_bit = 0;
  }
}

void main(){
  float waterflow, volume = 0.0;
  char txt[15];
  
  clock();
  config();
  
  while(1){
    if(time >= 2){
      waterflow = pulses / 450.0;//in L/s
      volume += waterflow;//in L
      
      FloatToStr(waterflow, txt);
      UART1_Write_Text("Waterflow: ");
      UART1_Write_Text(txt);
      UART1_Write_Text(" L/s,");
      
      FloatToStr(volume, txt);
      UART1_Write_Text(" Volume: ");
      UART1_Write_Text(txt);
      UART1_Write_Text(" L ");
      
      pulses = 0;
      waterflow = 0.0;
      time = 0;
      led = !led;
    }
  }  
}