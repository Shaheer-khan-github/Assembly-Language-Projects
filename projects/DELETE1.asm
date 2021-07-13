
;          Program For Deleting File(s)...

        DISP MACRO MSG
           MOV  AH,09H
           LEA  DX,MSG
           INT  21H
           ENDM

        .MODEL SMALL
        .STACK 64
        .DATA
            MSG1      DB 10,13,'    File(s) Deleted!!!$'
            MSG2      DB 10,13,'    File Not Found...$'
            MSG3      DB 10,13,'    Path Not Found...$'
            MSG4      DB 10,13,'    Invalid Access Code...$'

            PATH      DB 30 DUP(00H)

            FILEDTA   LABEL  BYTE       ;File DTA
                      DB     21 DUP(20H)
            FILEATTR  DB     0
            FILETIME  DW     0
            FILEDATE  DW     0
            LOWSIZE   DW     0
            HIGHSIZE  DW     0
            FILENAME  DB     13 DUP(20H)

        .CODE
            MOV  AX,@DATA
            MOV  DS,AX
            MOV  ES,AX

            MOV  AH,62H                 ;Requesting Address Of PSP
            INT  21H                    ;  Delivered To BX

            PUSH ES                     ;Saving Current Extra Segment
            MOV  ES,BX                  ;PSP Address into ES

            MOV  SI,80H
            MOV  CL,ES:[SI]
            SUB  CL,01
            MOV  CH,00H
            LEA  DI,PATH
            ADD  SI,02

         LOP1:
            MOV  AH,ES:[SI]
            MOV  [DI],AH

            INC  SI
            INC  DI

            LOOP LOP1

            MOV  AH,1AH                 ;Request Set DTA
            LEA  DX,FILEDTA             ;Address Of DTA
            INT  21H

            MOV  AH,4EH                 ;Request First Match
            MOV  CX,00H                 ;Normal Attributes
            LEA  DX,PATH                ;Inputed String
            INT  21H                    ;Call Interrupt Service

            JC   ERROR                  ;If An Error Occures

         LOP_CHECK:                     ;For Deleting & Checking 4 Another 
            LEA  DX,FILENAME            ;File That Can Be Deleted
            MOV  AH,41H
            INT  21H

            MOV  AH,4FH                 ;Request For Next Match
            INT  21H
            
            CMP  AX,00                  ;If Found
            JE   LOP_CHECK

            DISP MSG1
            JMP  QUIT

         ERROR:                         ;If An Error Occured
            CMP  AX,02H
            JE   INV_FILE
            CMP  AX,03H
            JE   INV_PATH

            DISP MSG2
            JMP  QUIT
         INV_FILE:
            DISP MSG2
            JMP  QUIT
         INV_PATH:
            DISP MSG3
            JMP  QUIT

         QUIT:                          ;Exit To DOS..
            MOV  AH,4CH
            INT  21H
        END     

