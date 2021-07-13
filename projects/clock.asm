      ;  PROGRAM FOR TSR FOR CLOCK

      

.MODEL TINY

.CODE
ORG 100H
START:

         JMP INITS            ;Jump to initialization portion
         ADRS DD ?

TIME1:
         PUSH AX
         PUSH BX
         PUSH CX
         PUSH DX              ;Save registers
         PUSH SI
         PUSH DI
         PUSH DS
         PUSH SS
         PUSH ES
         PUSHF
        
         MOV AX,0B900H
         MOV ES,AX            ;Load VRAM address
         MOV DI,820

         MOV AH,02            ;Get current time
         INT 1AH

         MOV AL,CH
         SHR AL,04            ;Hours in CH

         ADD AL,30H
         MOV ES:[DI],AL
         ADD DI,02

         MOV AL,CH
         AND AL,0FH
         ADD AL,30H
         MOV ES:[DI],AL
         ADD DI,02

         MOV AL,':'
         MOV ES:[DI],AL
         ADD DI,02

         MOV AL,CL            ;Minutes in CL
         SHR AL,04
         ADD AL,30H
         MOV ES:[DI],AL
         ADD DI,02

         MOV AL,CL
         AND AL,0FH
         ADD AL,30H
         MOV ES:[DI],AL
         ADD DI,02

         MOV AL,':'
         MOV ES:[DI],AL
         ADD DI,02

         MOV AL,DH            ;Seconds in DH
         SHR AL,04H
         ADD AL,30H
         MOV ES:[DI],AL
         ADD DI,02

         MOV AL,DH
         AND AL,0FH
         ADD AL,30H
         MOV ES:[DI],AL
         ADD DI,02

EXIT:
         POPF
         POP ES
         POP SS
         POP DS
         POP DI               ;Restore the registers
         POP SI
         POP DX
         POP CX
         POP BX
         POP AX
         JMP DWORD PTR CS:ADRS  ;Jump to restore original address of
                                ;Interrupt in IVT

INITS:
         MOV AL,00H           ;Clear screen
         MOV AH,06H
         MOV BH,07H
         MOV CX,0000H
         MOV DX,184FH
         INT 10H

         CLI                 
         
         PUSH CS
         POP DS

         MOV AH,35H           ;Get interrupt address of int 08h
         MOV AL,08
         INT 21H
         MOV WORD PTR ADRS,BX
         MOV WORD PTR ADRS+2,ES

         MOV AH,25H           ;Set new address of int 08 h
         MOV AL,08
         LEA DX,TIME1
         INT 21H

         MOV AH,31H           ;Request stay resident
         LEA DX,INITS         ;Load the no. of paragraphs of resident portion
         STI                  ;Restore interrupts
         INT 21H
    END START


         
