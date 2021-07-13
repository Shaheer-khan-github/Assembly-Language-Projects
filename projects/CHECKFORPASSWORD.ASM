;Title:Program to check for password

.MODEL SMALL
.STACK
.DATA
    len         db 0
    MES1      DB 10,13,"Enter the password : $"
    MES2      DB 10,13,"Password is valid.Password accepted.$" 
    MES3      DB 10,13,"Invalid password.   Try again.$"
    MES4      DB 10,13,"Do you want to change the password ? : $"
    MES5      DB 10,13,"Enter the new password : $"
    MES6      DB 10,13,"3 chances are over.  Program ends.$"
    MES7      DB 10,13,"Max. 8 characters are allowed.$"
    BUFFER    DB 10     DUP(0)
    INBUFF    DB 10     DUP(0) 
    CBUFF     DB 10     DUP(0)
    PATH      DB       'c:\TASM\PASS.TXT',00H
    HANDLE    DW ?
    COUNT1    DB 03H
    COUNT2    DB ?

.CODE
    MOV  AX,@DATA            ; Initialisation of data segment
    MOV  DS,AX
    MOV  ES,AX

    MOV  AH,3DH
    MOV  AL,02H              ; Open the file
    LEA  DX,PATH
    INT  21H
    MOV  HANDLE,AX

CLRSCR :
    MOV  AX,0600H
    MOV  BH,07H              ; Clear the screen
    MOV  CX,0000H
    MOV  DX,184FH
    INT  10H

SETCUR :
    MOV  AH,02H              ; Set the cursor
    MOV  BH,12H
    MOV  DH,42H
    MOV  DL,00H
    INT  10H

ACCEPT1 :
    MOV  AH,09H              ; Display first message
    LEA  DX,MES1
    INT  21H
    MOV  COUNT2,09H

    LEA  SI,BUFFER
    XOR  CX,CX

ACCEPT2 :
    MOV  AH,07H               ; Accept password
    INT  21H
    inc  cx
    CMP  AL,0DH
    JZ   CHECK


    MOV  [SI],AL
    INC  SI
    MOV  AH,02H              ; Print the asterisc
    MOV  DL,2AH
    INT  21H
    DEC  COUNT2
    CMP  COUNT2,00H
    JZ   MORE
    JMP  ACCEPT2

MORE :
    MOV  AH,09H
    LEA  DX,MES7
    INT  21H
    JMP  STOP

    CLD
CHECK :

    MOV  LEN,CL
    LEA  SI,BUFFER
    MOV  AH,03FH
    MOV  BX,HANDLE
    MOV  CX,10               ; Check if entered
    LEA  DX,INBUFF           ; password matches
    INT  21H
    LEA  DI,INBUFF

    xor cx,cx
    mov  cl,len
    dec  cl
here:
    mov  al,[si]
    mov  ah,[di]
    cmp  al,ah
    JNE  INVPAS
    inc  si
    inc  di
    loop here
    JMP  CHANGE

INVPAS :
    MOV  AH,09H              ; Display given 
    LEA  DX,MES3             ; password is invalid
    INT  21H

    DEC  COUNT1              ; Check whether 3 attempts
    JNZ  ACCEPT1             ; are over or not
    MOV  AH,09H
    LEA  DX,MES6             ; Display 3 attempts
    INT  21H                 ; are over
    JMP  STOP

CHANGE :
    MOV  AH,09H              ; Display password
    LEA  DX,MES2             ; is valid
    INT  21H

    MOV  AH,3EH
    MOV  BX,HANDLE           ; Close the file
    INT  21H

    MOV  AH,09H              ; Ask if the password
    LEA  DX,MES4             ; is to be changed or not
    INT  21H

    MOV  AH,01H              ; Read the choice
    INT  21H

    CMP  AL,59H
    JNZ  STOP

    MOV  AH,09H              ; Ask to enter the
    LEA  DX,MES5             ; new password
    INT  21H

    MOV  AH,3DH              ; Open the file
    MOV  AL,02H              ; of password
    LEA  DX,PATH             
    INT  21H
    MOV  HANDLE,AX

    LEA  SI,CBUFF
NEXT :
    MOV  AH,07H              ; Write the new
    INT  21H                 ; password in file
    CMP  AL,0DH
    JZ   WRITE
    MOV  [SI],AL
    INC  SI

    MOV  AH,02H              ; Print the asterisc
    MOV  DL,2AH
    INT  21H
    JMP  NEXT

WRITE :
    MOV  AH,40H              ; Write the new password
    MOV  BX,HANDLE           ; in the file
    MOV  CX,000AH
    LEA  DX,CBUFF
    INT  21H
    JMP  STOP

STOP :
    MOV  AH,3EH
    MOV  BX,HANDLE
    INT  21H

    MOV  AH,4CH
    INT  21H

    END
































































































































