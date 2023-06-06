#line 1 "C:/Users/amara/Documents/MikroC/SensorFlujo/SensorFlujo.c"

sbit led at RC0_bit;
sbit water_sensor at RB0_bit;
sbit uart_tx at RC6_bit;
sbit uart_rx at RC7_bit;

char pulses = 0, time = 0;

void clock(){
 IRCF0_bit = 0;
 IRCF1_bit = 1;
 IRCF2_bit = 1;
 while(!HTS_bit);
 Delay_ms(10);
}

void config(){
 ANSEL = 0;
 ANSELH = 0;
 TRISA = 0xff;
 TRISB = 0xff;
 TRISC = 0xfe;


 T1CON = 0x31;
 TMR1L = 0xdc;
 TMR1H = 0x0b;
 TMR1IE_bit = 1;


 INTEDG_bit = 1;
 INTCON = 0xd0;


 UART1_Init(9600);
}

void interrupt(){
 if(INTF_bit){
 pulses++;
 INTF_bit = 0;
 }

 if(TMR1IF_bit){
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
 waterflow = pulses / 450.0;
 volume += waterflow;

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
