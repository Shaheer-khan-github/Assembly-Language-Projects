;           TITLE PROGRAM ON SIMULATION OF MOUSE
;               
;----------------------------------------------------------------------------
DATA SEGMENT
ERRO DB 10,13,"ERROR IN DETECTION OF MOUSE$"
PRE_MODE  DB 0
X         DW 0
Y         DW 0
BUTTON    DW 0
DATA ENDS

CODE SEGMENT
START:
      ASSUME CS:CODE,DS:DATA
      MOV AX,DATA
      MOV DS,AX
      MOV ES,AX

      MOV AH,0FH                 ;GET CURRENT VIDEO MODE
      INT 21H
      MOV PRE_MODE,AL            ;STORE IT FROM AL

      MOV AH,00H                 ;SET VIDEO MODE
      MOV AL,12H
      INT 10H

      MOV AX,00H                 ;INTIALIZE MOUSE POINTER
      INT 33H

      CMP AX,00H                 ;IF UNSUCCESSFUL RETURNS ZERO IN AX REGISTER
      JE ERROR

L1:
      MOV AX,01H                 ;DISPLAY POINTER
      INT 33H
      CALL GETMOUSE_POSITION
      AND BUTTON,03H
      JZ L1
      CMP BUTTON,02H
      JE QUIT
      CMP BUTTON,01H
      JNE L1
      CALL HIDE_PNTR
      CALL GET_PIXEL
      CALL HIDE_PNTR
      JMP L1

ERROR:
      LEA DX,ERRO
      MOV AH,09H
      INT 21H

QUIT:
      MOV AH,00H
      MOV AL,PRE_MODE
      INT 10H

      MOV AH,4CH
      INT 21H

GETMOUSE_POSITION PROC
      MOV AX,03H
      INT 33H
      MOV BUTTON,BX              ;RETURNS STATUS OF BUTTON
      MOV X,CX                   ;RETURNS X-COORDINATE
      MOV Y,DX                   ;RETURNS Y-COORDINATE
      RET
GETMOUSE_POSITION ENDP

HIDE_PNTR PROC
      MOV AX,02H
      INT 33H
HIDE_PNTR ENDP

GET_PIXEL PROC
      MOV AH,0CH
      MOV AL,0FH                 ;COLOUR
      MOV BH,0                   ;PAGE NO
      MOV CX,X                   ;X-COORDINATE
      MOV DX,Y                   ;Y-COORDINATE
      INT 10H
      RET
GET_PIXEL ENDP

CODE ENDS
END START

