
_clock:

	BCF        IRCF0_bit+0, BitPos(IRCF0_bit+0)
	BSF        IRCF1_bit+0, BitPos(IRCF1_bit+0)
	BSF        IRCF2_bit+0, BitPos(IRCF2_bit+0)
L_clock0:
	BTFSC      HTS_bit+0, BitPos(HTS_bit+0)
	GOTO       L_clock1
	GOTO       L_clock0
L_clock1:
	MOVLW      13
	MOVWF      R12+0
	MOVLW      251
	MOVWF      R13+0
L_clock2:
	DECFSZ     R13+0, 1
	GOTO       L_clock2
	DECFSZ     R12+0, 1
	GOTO       L_clock2
	NOP
	NOP
L_end_clock:
	RETURN
; end of _clock

_config:

	CLRF       ANSEL+0
	CLRF       ANSELH+0
	MOVLW      255
	MOVWF      TRISA+0
	MOVLW      255
	MOVWF      TRISB+0
	MOVLW      254
	MOVWF      TRISC+0
	MOVLW      49
	MOVWF      T1CON+0
	MOVLW      220
	MOVWF      TMR1L+0
	MOVLW      11
	MOVWF      TMR1H+0
	BSF        TMR1IE_bit+0, BitPos(TMR1IE_bit+0)
	BSF        INTEDG_bit+0, BitPos(INTEDG_bit+0)
	MOVLW      208
	MOVWF      INTCON+0
	MOVLW      25
	MOVWF      SPBRG+0
	BSF        TXSTA+0, 2
	CALL       _UART1_Init+0
L_end_config:
	RETURN
; end of _config

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

	BTFSS      INTF_bit+0, BitPos(INTF_bit+0)
	GOTO       L_interrupt3
	INCF       _pulses+0, 1
	BCF        INTF_bit+0, BitPos(INTF_bit+0)
L_interrupt3:
	BTFSS      TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
	GOTO       L_interrupt4
	MOVLW      220
	MOVWF      TMR1L+0
	MOVLW      11
	MOVWF      TMR1H+0
	INCF       _time+0, 1
	BCF        TMR1IF_bit+0, BitPos(TMR1IF_bit+0)
L_interrupt4:
L_end_interrupt:
L__interrupt11:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

	CLRF       main_volume_L0+0
	CLRF       main_volume_L0+1
	CLRF       main_volume_L0+2
	CLRF       main_volume_L0+3
	CALL       _clock+0
	CALL       _config+0
L_main5:
	MOVLW      2
	SUBWF      _time+0, 0
	BTFSS      STATUS+0, 0
	GOTO       L_main7
	MOVF       _pulses+0, 0
	MOVWF      R0+0
	CALL       _byte2double+0
	MOVLW      0
	MOVWF      R4+0
	MOVLW      0
	MOVWF      R4+1
	MOVLW      97
	MOVWF      R4+2
	MOVLW      135
	MOVWF      R4+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FLOC__main+0
	MOVF       R0+1, 0
	MOVWF      FLOC__main+1
	MOVF       R0+2, 0
	MOVWF      FLOC__main+2
	MOVF       R0+3, 0
	MOVWF      FLOC__main+3
	MOVF       main_volume_L0+0, 0
	MOVWF      R0+0
	MOVF       main_volume_L0+1, 0
	MOVWF      R0+1
	MOVF       main_volume_L0+2, 0
	MOVWF      R0+2
	MOVF       main_volume_L0+3, 0
	MOVWF      R0+3
	MOVF       FLOC__main+0, 0
	MOVWF      R4+0
	MOVF       FLOC__main+1, 0
	MOVWF      R4+1
	MOVF       FLOC__main+2, 0
	MOVWF      R4+2
	MOVF       FLOC__main+3, 0
	MOVWF      R4+3
	CALL       _Add_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      main_volume_L0+0
	MOVF       R0+1, 0
	MOVWF      main_volume_L0+1
	MOVF       R0+2, 0
	MOVWF      main_volume_L0+2
	MOVF       R0+3, 0
	MOVWF      main_volume_L0+3
	MOVF       FLOC__main+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       FLOC__main+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       FLOC__main+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       FLOC__main+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
	MOVLW      87
	MOVWF      ?lstr1_SensorFlujo+0
	MOVLW      97
	MOVWF      ?lstr1_SensorFlujo+1
	MOVLW      116
	MOVWF      ?lstr1_SensorFlujo+2
	MOVLW      101
	MOVWF      ?lstr1_SensorFlujo+3
	MOVLW      114
	MOVWF      ?lstr1_SensorFlujo+4
	MOVLW      102
	MOVWF      ?lstr1_SensorFlujo+5
	MOVLW      108
	MOVWF      ?lstr1_SensorFlujo+6
	MOVLW      111
	MOVWF      ?lstr1_SensorFlujo+7
	MOVLW      119
	MOVWF      ?lstr1_SensorFlujo+8
	MOVLW      58
	MOVWF      ?lstr1_SensorFlujo+9
	MOVLW      32
	MOVWF      ?lstr1_SensorFlujo+10
	CLRF       ?lstr1_SensorFlujo+11
	MOVLW      ?lstr1_SensorFlujo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      32
	MOVWF      ?lstr2_SensorFlujo+0
	MOVLW      76
	MOVWF      ?lstr2_SensorFlujo+1
	MOVLW      47
	MOVWF      ?lstr2_SensorFlujo+2
	MOVLW      115
	MOVWF      ?lstr2_SensorFlujo+3
	MOVLW      44
	MOVWF      ?lstr2_SensorFlujo+4
	CLRF       ?lstr2_SensorFlujo+5
	MOVLW      ?lstr2_SensorFlujo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVF       main_volume_L0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       main_volume_L0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       main_volume_L0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       main_volume_L0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      main_txt_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
	MOVLW      32
	MOVWF      ?lstr3_SensorFlujo+0
	MOVLW      86
	MOVWF      ?lstr3_SensorFlujo+1
	MOVLW      111
	MOVWF      ?lstr3_SensorFlujo+2
	MOVLW      108
	MOVWF      ?lstr3_SensorFlujo+3
	MOVLW      117
	MOVWF      ?lstr3_SensorFlujo+4
	MOVLW      109
	MOVWF      ?lstr3_SensorFlujo+5
	MOVLW      101
	MOVWF      ?lstr3_SensorFlujo+6
	MOVLW      58
	MOVWF      ?lstr3_SensorFlujo+7
	MOVLW      32
	MOVWF      ?lstr3_SensorFlujo+8
	CLRF       ?lstr3_SensorFlujo+9
	MOVLW      ?lstr3_SensorFlujo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      main_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      32
	MOVWF      ?lstr4_SensorFlujo+0
	MOVLW      76
	MOVWF      ?lstr4_SensorFlujo+1
	MOVLW      32
	MOVWF      ?lstr4_SensorFlujo+2
	CLRF       ?lstr4_SensorFlujo+3
	MOVLW      ?lstr4_SensorFlujo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	CLRF       _pulses+0
	CLRF       _time+0
	MOVLW
	XORWF      RC0_bit+0, 1
L_main7:
	GOTO       L_main5
L_end_main:
	GOTO       $+0
; end of _main
