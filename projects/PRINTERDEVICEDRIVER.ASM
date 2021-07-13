TITLE PROGRAM ON PRINTER DEVICE DRIVER;

CODE SEGMENT

     ASSUME CS:CODE,DS:CODE
     ORG 0H

HEADER:
       NEXTDRIVER   DD  -1          ;LINK TO NEXT DEVICE DRIVER
       ATTRIBUTE    DW   08000H     ;DEVICE ATTRIBUTE
       STRAT_PTR    DW   STRAT      ;STRATEGY ROUTINE ENTRY POINT
       INTR_PTR     DW   INTR       ;INTERRUPT ROUTINE ENTRY POINT
       DEV_NAME     DB   'MAYPRINT' ;LOGICAL DEVICE NAME

       RHSPT_OFF     DW    0         ;POINTER TO REQUEST HEADER
       RHPT_SEG     DW    0         ;CONTAINS OFFSET & SEGMENT

       MINIT        DB    0DH,0AH,09H,'PRINTER INSTALLED$'

;--------------------------------------------------------------------------
STRAT PROC FAR
      MOV RHPT_OFF,BX                ;SAVE POINTER TO REQUEST
      MOV RHPT_SEG,ES                ;HEADER
      RET
STRAT ENDP
;---------------------------------------------------------------------------
INTR PROC FAR
      PUSH AX
      PUSH BX
      PUSH CX
      PUSH DX
      PUSH DS
      PUSH ES
      PUSH DI
      PUSH SI
      PUSH BP
      PUSH CS
      POP DS

      MOV BX,RHPT_OFF
      MOV ES,RHPT_SEG
      MOV AL,ES:[BX+2]
      CMP AL,0
      JNE DN
      CALL INIT

DN:
      CMP AL,8
      JNE EXIT
      CALL OUT_CHAR

EXIT:
      OR AX,0100H
      MOV ES:[BX+3],AX
      POP BP
      POP SI
      POP DI
      POP ES
      POP DS
      POP DX
      POP CX
      POP BX
      POP AX
      RET
;---------------------------------------------------------------------------

OUT_CHAR PROC NEAR
      MOV CX,ES:[BX+18]
      MOV SI,ES:[BX+14]
      MOV DS,ES:[BX+16]

UP1:
      MOV AL,[SI]
      MOV AH,00H
      MOV DX,00H
      INT 17H
      INC SI
      LOOP UP1
      RET

OUT_CHAR ENDP
;--------------------------------------------------------------------------
INIT PROC NEAR
      MOV AH,09H
      LEA DX,MINIT
      INT 21H
      MOV WORD PTR ES:[BX+14],OFFSET INIT
      MOV ES:[BX+16],CS
      MOV AH,01H
      MOV DX,00H
      INT 17H
      XOR AX,AX
      RET

INIT  ENDP
INTR  ENDP
CODE  ENDS
END

