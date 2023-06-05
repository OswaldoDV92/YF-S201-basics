
_clock:

	BSF        IRCF0_bit+0, BitPos(IRCF0_bit+0)
	BSF        IRCF1_bit+0, BitPos(IRCF1_bit+0)
	BSF        IRCF2_bit+0, BitPos(IRCF2_bit+0)
L_clock0:
	BTFSC      HTS_bit+0, BitPos(HTS_bit+0)
	GOTO       L_clock1
	GOTO       L_clock0
L_clock1:
	MOVLW      26
	MOVWF      R12+0
	MOVLW      248
	MOVWF      R13+0
L_clock2:
	DECFSZ     R13+0, 1
	GOTO       L_clock2
	DECFSZ     R12+0, 1
	GOTO       L_clock2
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
	MOVLW      132
	MOVWF      OPTION_REG+0
	MOVLW      6
	MOVWF      TMR0+0
	MOVLW      49
	MOVWF      T1CON+0
	MOVLW      5
	MOVWF      CCP1CON+0
	BCF        CCP1IF_bit+0, BitPos(CCP1IF_bit+0)
	BSF        CCP1IE_bit+0, BitPos(CCP1IE_bit+0)
	MOVLW      192
	MOVWF      INTCON+0
	MOVLW      51
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

	CLRF       interrupt_time2_L0+0
	BCF        CCP1IF_bit+0, BitPos(CCP1IF_bit+0)
	CLRF       TMR1L+0
	CLRF       TMR1H+0
L_interrupt3:
	BTFSC      CCP1IF_bit+0, BitPos(CCP1IF_bit+0)
	GOTO       L_interrupt4
	GOTO       L_interrupt3
L_interrupt4:
	CLRF       TMR1L+0
	CLRF       TMR1H+0
	MOVF       CCPR1H+0, 0
	MOVWF      interrupt_period_L0+0
	CLRF       interrupt_period_L0+1
	CLRF       interrupt_period_L0+2
	CLRF       interrupt_period_L0+3
	MOVF       interrupt_period_L0+2, 0
	MOVWF      R4+3
	MOVF       interrupt_period_L0+1, 0
	MOVWF      R4+2
	MOVF       interrupt_period_L0+0, 0
	MOVWF      R4+1
	CLRF       R4+0
	MOVF       R4+0, 0
	MOVWF      interrupt_period_L0+0
	MOVF       R4+1, 0
	MOVWF      interrupt_period_L0+1
	MOVF       R4+2, 0
	MOVWF      interrupt_period_L0+2
	MOVF       R4+3, 0
	MOVWF      interrupt_period_L0+3
	MOVF       CCPR1L+0, 0
	MOVWF      R0+0
	CLRF       R0+1
	CLRF       R0+2
	CLRF       R0+3
	MOVF       R4+0, 0
	ADDWF      R0+0, 1
	MOVF       R4+1, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+1, 0
	ADDWF      R0+1, 1
	MOVF       R4+2, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+2, 0
	ADDWF      R0+2, 1
	MOVF       R4+3, 0
	BTFSC      STATUS+0, 0
	INCFSZ     R4+3, 0
	ADDWF      R0+3, 1
	MOVF       R0+0, 0
	MOVWF      interrupt_period_L0+0
	MOVF       R0+1, 0
	MOVWF      interrupt_period_L0+1
	MOVF       R0+2, 0
	MOVWF      interrupt_period_L0+2
	MOVF       R0+3, 0
	MOVWF      interrupt_period_L0+3
	MOVLW      30
	MOVWF      R4+0
	CLRF       R4+1
	CLRF       R4+2
	CLRF       R4+3
	CALL       _Mul_32x32_U+0
	MOVF       R0+0, 0
	MOVWF      interrupt_period_L0+0
	MOVF       R0+1, 0
	MOVWF      interrupt_period_L0+1
	MOVF       R0+2, 0
	MOVWF      interrupt_period_L0+2
	MOVF       R0+3, 0
	MOVWF      interrupt_period_L0+3
	MOVF       R0+0, 0
	MOVWF      FARG_LongToStr_input+0
	MOVF       R0+1, 0
	MOVWF      FARG_LongToStr_input+1
	MOVF       R0+2, 0
	MOVWF      FARG_LongToStr_input+2
	MOVF       R0+3, 0
	MOVWF      FARG_LongToStr_input+3
	MOVLW      interrupt_txt_L0+0
	MOVWF      FARG_LongToStr_output+0
	CALL       _LongToStr+0
	MOVLW      80
	MOVWF      ?lstr1_SensorFlujo+0
	MOVLW      101
	MOVWF      ?lstr1_SensorFlujo+1
	MOVLW      114
	MOVWF      ?lstr1_SensorFlujo+2
	MOVLW      105
	MOVWF      ?lstr1_SensorFlujo+3
	MOVLW      111
	MOVWF      ?lstr1_SensorFlujo+4
	MOVLW      100
	MOVWF      ?lstr1_SensorFlujo+5
	MOVLW      42
	MOVWF      ?lstr1_SensorFlujo+6
	MOVLW      55
	MOVWF      ?lstr1_SensorFlujo+7
	MOVLW      46
	MOVWF      ?lstr1_SensorFlujo+8
	MOVLW      53
	MOVWF      ?lstr1_SensorFlujo+9
	MOVLW      58
	MOVWF      ?lstr1_SensorFlujo+10
	MOVLW      32
	MOVWF      ?lstr1_SensorFlujo+11
	CLRF       ?lstr1_SensorFlujo+12
	MOVLW      ?lstr1_SensorFlujo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      interrupt_txt_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVF       interrupt_period_L0+0, 0
	MOVWF      R0+0
	MOVF       interrupt_period_L0+1, 0
	MOVWF      R0+1
	MOVF       interrupt_period_L0+2, 0
	MOVWF      R0+2
	MOVF       interrupt_period_L0+3, 0
	MOVWF      R0+3
	CALL       _longint2double+0
	MOVF       R0+0, 0
	MOVWF      R4+0
	MOVF       R0+1, 0
	MOVWF      R4+1
	MOVF       R0+2, 0
	MOVWF      R4+2
	MOVF       R0+3, 0
	MOVWF      R4+3
	MOVLW      0
	MOVWF      R0+0
	MOVLW      36
	MOVWF      R0+1
	MOVLW      116
	MOVWF      R0+2
	MOVLW      146
	MOVWF      R0+3
	CALL       _Div_32x32_FP+0
	MOVF       R0+0, 0
	MOVWF      FARG_FloatToStr_fnum+0
	MOVF       R0+1, 0
	MOVWF      FARG_FloatToStr_fnum+1
	MOVF       R0+2, 0
	MOVWF      FARG_FloatToStr_fnum+2
	MOVF       R0+3, 0
	MOVWF      FARG_FloatToStr_fnum+3
	MOVLW      interrupt_flow_L0+0
	MOVWF      FARG_FloatToStr_str+0
	CALL       _FloatToStr+0
	MOVLW      32
	MOVWF      ?lstr2_SensorFlujo+0
	MOVLW      117
	MOVWF      ?lstr2_SensorFlujo+1
	MOVLW      115
	MOVWF      ?lstr2_SensorFlujo+2
	MOVLW      44
	MOVWF      ?lstr2_SensorFlujo+3
	MOVLW      32
	MOVWF      ?lstr2_SensorFlujo+4
	MOVLW      70
	MOVWF      ?lstr2_SensorFlujo+5
	MOVLW      108
	MOVWF      ?lstr2_SensorFlujo+6
	MOVLW      111
	MOVWF      ?lstr2_SensorFlujo+7
	MOVLW      119
	MOVWF      ?lstr2_SensorFlujo+8
	MOVLW      114
	MOVWF      ?lstr2_SensorFlujo+9
	MOVLW      97
	MOVWF      ?lstr2_SensorFlujo+10
	MOVLW      116
	MOVWF      ?lstr2_SensorFlujo+11
	MOVLW      101
	MOVWF      ?lstr2_SensorFlujo+12
	MOVLW      58
	MOVWF      ?lstr2_SensorFlujo+13
	MOVLW      32
	MOVWF      ?lstr2_SensorFlujo+14
	CLRF       ?lstr2_SensorFlujo+15
	MOVLW      ?lstr2_SensorFlujo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      interrupt_flow_L0+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      32
	MOVWF      ?lstr3_SensorFlujo+0
	MOVLW      76
	MOVWF      ?lstr3_SensorFlujo+1
	MOVLW      47
	MOVWF      ?lstr3_SensorFlujo+2
	MOVLW      109
	MOVWF      ?lstr3_SensorFlujo+3
	MOVLW      105
	MOVWF      ?lstr3_SensorFlujo+4
	MOVLW      110
	MOVWF      ?lstr3_SensorFlujo+5
	MOVLW      32
	MOVWF      ?lstr3_SensorFlujo+6
	CLRF       ?lstr3_SensorFlujo+7
	MOVLW      ?lstr3_SensorFlujo+0
	MOVWF      FARG_UART1_Write_Text_uart_text+0
	CALL       _UART1_Write_Text+0
	MOVLW      6
	MOVWF      TMR0+0
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
L_interrupt5:
	MOVLW      125
	SUBWF      interrupt_time2_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt6
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L_interrupt7
	INCF       interrupt_time2_L0+0, 1
	INCF       _time+0, 1
	MOVF       _time+0, 0
	SUBLW      250
	BTFSC      STATUS+0, 0
	GOTO       L_interrupt8
	MOVLW      250
	MOVWF      _time+0
L_interrupt8:
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
	MOVLW      6
	MOVWF      TMR0+0
L_interrupt7:
	GOTO       L_interrupt5
L_interrupt6:
	BCF        CCP1IF_bit+0, BitPos(CCP1IF_bit+0)
L_end_interrupt:
L__interrupt17:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

	CALL       _clock+0
	CALL       _config+0
L_main9:
	MOVLW
	XORWF      RC0_bit+0, 1
	CLRF       _time+0
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
L_main11:
	MOVLW      250
	SUBWF      _time+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_main12
	BTFSS      T0IF_bit+0, BitPos(T0IF_bit+0)
	GOTO       L_main13
	INCF       _time+0, 1
	BCF        T0IF_bit+0, BitPos(T0IF_bit+0)
	MOVLW      6
	MOVWF      TMR0+0
L_main13:
	GOTO       L_main11
L_main12:
	GOTO       L_main9
L_end_main:
	GOTO       $+0
; end of _main
