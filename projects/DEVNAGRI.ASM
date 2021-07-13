;----------------------------------------------------------------------------
;                NAME:RAKESH KUMAR
;                ROLL NO.23
;                CLASS: T.E.COMP-II
;                PROGRAM ON DEVNAGRI SCRIPT
;----------------------------------------------------------------------------
.MODEL SMALL

PRINT MACRO MSG
MOV AH,09H
LEA DX,MSG
INT 21H
ENDM

SETCURSOR MACRO                    ;MACRO FOR SETCURSOR
MOV AH,02H
MOV BH,00H
MOV DH,30                          ;X-COORDINATE
MOV DL,30                          ;Y-COORDINATE
INT 10H
ENDM

.DATA
BUFF DB 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     DB 0,0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     DB 0,1,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     DB 0,1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     DB 0,1,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     DB 0,1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
     DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1
     DB 0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,1,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,1,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,0,0,1
     DB 0,0,0,1,0,0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,1,1,1,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,1,1,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,0,1,1,1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,1,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,0,0,1
     DB 0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,0,1
     DB 0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,1
     
MSG1 DB 10,13,"PRINTER CONNECTIVITY ERROR$"
MSG2 DB 10,13,"PRINTER SELECTED$"
HEIGHT      DW 53
WID         DW 60
ROW         DW 30
COLUMN      DW 30
PRE_MODE    DB 0
MESS        DB 0

.CODE
     MOV AX,@DATA
     MOV DS,AX

     MOV AH,0FH                    ;CAPTURE PREVIOUS GRAPHICS MODE
     INT 21H
     MOV PRE_MODE,AL

     MOV AH,00H                    ;SET VIDEO MODE
     MOV AL,06
     INT 10H

     XOR SI,SI

L1:
     MOV AH,0CH                    ;PUT PIXEL ON DISPLAY
     MOV AL,BUFF[SI]               ;0 FOR SAME FOREGROUND & BACKGROUND
     MOV BH,00                     ;PAGE
     MOV CX,COLUMN                 ;COLUMN
     MOV DX,ROW                    ;ROW
     INT 10H                       ;BIOS INTERRUPT

     MOV BH,BUFF[SI]
     CMP BH,00
     JNE L2
     MOV AH,00H                    ;CHARACTER ON PRINTER
     MOV AL,20H                    ;BLANK PRINT
     INT 17H
     JMP NEXT
L2:
     MOV AH,00H
     MOV AL,'.'                    ;PRINTING A PIXEL
     INT 17H
NEXT:
     CMP AH,04H
     JNE P1
     MOV MESS,AH                   
P1:
     INC SI
     INC COLUMN
     MOV BX,COLUMN                 ;COMPARE FOR END OF COLUMN
     CMP BX,WID
     JBE  L1

     MOV COLUMN,30
     INC ROW
     MOV BX,ROW
     CMP BX,HEIGHT                 ;COMPARE FOR END OF ROW
     JBE L1

     MOV AH,08H                    ;CHARACTER INPUT WITHOUT ECHO
     INT 21H

     MOV AH,00H
     MOV AL,PRE_MODE
     INT 10H

     SETCURSOR

     CMP MESS,04H
     JE P2
     PRINT MSG1                     ;FAILURE
     JMP QUIT
P2:
     PRINT MSG2                     ;SUCCESS

QUIT:

     MOV AH,4CH
     INT 21H
END
