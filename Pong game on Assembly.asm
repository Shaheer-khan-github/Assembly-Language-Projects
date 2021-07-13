
; You may customize this and other start-up templates; 
; The location of this template is c:\emu8086\inc\0_com_template.txt

org 100h


org 100h
        jmp start

;functions area

WindowColor    Macro X1,Y1,X2,Y2,Color
Mov Ax,0600h
Mov Cl,X1
Mov Ch,Y1
Mov Dl,X2
Mov Dh,Y2
Mov Bh,Color
Int 10h
EndM

printstring     Macro       Adr
MOV DX, OFFSET Adr
MOV AH, 9
INT 21h
EndM
goto        macro           x,y
MOV DH, x   ;ROW
MOV DL, y   ;COLUMN
MOV AH, 02H
INT 10H
EndM
curser      macro       x,y
MOV DH, x   ;ROW
MOV DL, y   ;COLUMN
MOV AH, 02H
INT 10H
EndM
printpixel      macro       x,y,color,p
mov bh, p
mov cx, x
mov dx, y
mov al, color
mov ah, 0ch
int 10h
EndM

delay   macro   time
mov cx,time
mov dx,4240h
mov ah,086h
int 15h
EndM
;----------------------------------
print_batt PROC
PRINTBATT:
MOV DX, player1top
print:
INC player1count
printpixel 10, DX, 0100B,1
INC DX
INC player1count
CMP player1count, 150
JNE print
SUB player1count, 150
RET
print_batt ENDP

print_com PROC
MOV DX, comtop
printcompo:
INC comcount
printpixel 308, DX, 0001b,1
INC DX
INC comcount
CMP comcount, 150
JNE printcompo
SUB comcount, 150
RET
print_com ENDP

print_ball PROC
printpixel ballx, bally, 00000001b,3
DEC ballx
DEC bally
printpixel ballx, bally, 00000001b,3
INC ballx
printpixel ballx, bally, 00000001b,3
sub ballx, 2
DEC bally
printpixel ballx, bally, 00000001b,3
inc ballx
printpixel ballx, bally, 00000001b,3
inc ballx
printpixel ballx, bally, 00000001b,3
inc ballx
printpixel ballx, bally, 00000001b,3

printpixel ballx, bally, 00000001b,3
DEC bally
sub ballx, 2
printpixel ballx, bally, 00000001b,3
INC ballx
printpixel ballx, bally, 00000001b,3
DEC bally
DEC bally
printpixel ballx, bally, 00000001b ,3

RET
print_ball ENDP

clearscreen proc
MOV AL, 13H ;changes the num of pixels to 640X480 with 16 colors
MOV AH, 0
INT 10H

ret
clearscreen ENDP

reprint     proc
call clearscreen
call print_batt
call print_com

ret
reprint     ENDP

baseprint   proc
    mov base, 0
printbase:
printpixel base, 0, 2, 2
INC base
CMP base, 320
JNE printbase

mov base, 0
printdownbase:
printpixel base, 199, 2, 2
INC base
CMP base, 320
JNE printdownbase

mov base, 0
printleftbase:
printpixel 0, base, 2, 2
INC base
CMP base, 199
JNE printleftbase

mov base, 0
printrightbase:
printpixel 319, base, 2, 2
INC base                   
CMP base, 199
JNE printrightbase

    ret
baseprint   EndP

;-----------------------ball movement proc-------------------

;main move
balloop         macro       move
call move
CALL hitcheck
JMP checkahit
EndM

;LEFT UP
bdleftup    PROC
call reprint
sub  ballx, 14
dec  bally
CALL print_ball

MOV lastaction, bdleftup

RET
bdleftup    ENDP

bdleftupreverse     proc
    ADD ballx, 11
    INC bally
RET
bdleftupreverse    ENDP


;LEFT DOWN
bdleftdown    PROC
call reprint
sub  ballx, 11
ADD  bally, 10
CALL print_ball
MOV lastaction, bdleftdown
RET
bdleftdown    ENDP

bdleftdownreverse     proc
    ADD ballx, 11
    DEC bally
RET
bdleftdownreverse    ENDP

;RIGHT UP
bdrightup    PROC
call reprint
ADD  ballx, 11
DEC  bally
CALL print_ball
MOV lastaction, bdrightup
RET
bdrightup    ENDP

bdrightupreverse     proc
    SUB ballx, 11
    INC bally
RET
bdrightupreverse    ENDP

;RIGHT DOWN
bdrightdown    PROC
call reprint
ADD  ballx, 10
ADD  bally, 11
CALL print_ball
MOV lastaction, bdrightdown
RET
bdrightdown    ENDP

bdrightdownreverse     proc
    SUB ballx, 11
    DEC bally
RET
bdrightdownreverse    ENDP

hitcheck    PROC
;------batt and com check-------
MOV BH, 2H
MOV DX, ballx
MOV CX, bally
SUB CX, 2
MOV AH, 0Dh      
INT 10H

CMP AL, 1
JE hitmovement
CMP AL, 3
JE comhitmovement

MOV BH, 2H
MOV DX, ballx
MOV CX, bally
ADD CX, 2
MOV AH, 0Dh            
INT 10H

CMP AL, 1
JE hitmovement
CMP AL, 3
JE comhitmovement

MOV BH, 2H
MOV DX, ballx
MOV CX, bally
SUB DX, 2
MOV AH, 0Dh      
INT 10H

CMP AL, 1
JE hitmovement
CMP AL, 3
JE comhitmovement

MOV BH, 2H
MOV DX, ballx
MOV CX, bally
ADD DX, 2
MOV AH, 0Dh      
INT 10H

CMP AL, 1
JE hitmovement
CMP AL, 3
JE comhitmovement

;------base check-------

CMP bally, 1
JB upbasehitmovement
JE upbasehitmovement

CMP ballx, 1
JB leftbasehitmovement
JE leftbasehitmovement

CMP bally, 199
JA downbasehitmovement
JE downbasehitmovement

CMP ballx, 315
JA rightbasehitmovement
JE rightbasehitmovement

JMP nonhit

hitmovement:
MOV AH, 2CH      ;TIMER
INT 21H    
CMP DH, 30
JA NC1 
JB NC13
NC13:
balloop bdrightup    ;BALLOOP CONFIGURATION
JMP checkahit  
NC1:
balloop bdrightdown    ;BALLOOP CONFIGURATION
JMP checkahit

comhitmovement:
MOV AH, 2CH      ;TIMER
INT 21H    
CMP DH, 30
JA NC2
balloop bdleftdown    ;BALLOOP CONFIGURATION  
NC2:
balloop bdleftup    ;BALLOOP CONFIGURATION
JMP checkahit

upbasehitmovement:
balloop bdrightdown 
JMP checkahit

downbasehitmovement:
balloop bdrightup 
JMP checkahit

rightbasehitmovement:
JMP END

leftbasehitmovement:
JMP END

nonhit:
ret
hitcheck    EndP

;----------------------------------data area-------------------------

yay              DB       "                ,-.----.       ,----..            ,--.               ", 13, 10
DB       "                \    /  \     /   /   \         ,--.'|  ,----..      ", 13, 10
DB       "                |   :    \   /   .     :    ,--,:  : | /   /   \     ", 13, 10
DB       "                |   |  .\ : .   /   ;.  \,`--.'`|  ' :|   :     :    ", 13, 10
DB       "                .   :  |: |.   ;   /  ` ;|   :  :  | |.   |  ;. /    ", 13, 10
DB       "                |   |   \ :;   |  ; \ ; |:   |   \ | :.   ; /--`     ", 13, 10
DB       "                |   : .   /|   :  | ; | '|   : '  '; |;   | ;  __    ", 13, 10
DB       "                ;   | |`-' .   |  ' ' ' :'   ' ;.    ;|   : |.' .'   ", 13, 10
DB       "                |   | ;    '   ;  \; /  ||   | | \   |.   | '_.' :   ", 13, 10
DB       "                 :   ' |     \   \  ',  / '   : |  ; .''   ; : \  |  ", 13, 10
DB       "                 :   : :      ;   :    /  |   | '`--'  '   | '/  .'  ", 13, 10
DB       "                |   | :       \   \ .'   '   : |      |   :    /     ", 13, 10
DB       "                `---'.|        `---`     ;   |.'       \   \ .'      ", 13, 10
DB       "                  `---`                  '---'          `---`        ", 13, 10, '$'
startmsg         DB       "Click Space To Start!$"
lidor            DB       "Created By LidorMotai. Inspired By ATARI.$"
wrongb           DB       "You have clicked the wrong button!$"
c1               DB       0
c2               DB       21

player1top       DW       4  ;top pixel
player1count     DW       0

comtop           DW       110  ;top com pixel
comcount         DW       0

ballx            DW       150
bally            DW       90

p1score          DW       0
p2score          DW       0

lastaction       DW       bdleftup

base             dw       0

start:

;----------START PAGE-------------
MOV AL, 1 ;PAGE NUMBER
MOV AH, 05H
INT 10H

WindowColor 0,0,80,25,01ch

;PRINT "PONG" TO SCREEN
MOV BH, 1
printstring yay

;SET CURSOR POSITION TO STARTMSG
goto 14,29

;PRINT STARTMSG
printstring startmsg

;SET CURSOR POSITION TO lidor
MOV BH, 1   ;PAGE
curser  20, 20

;PRINT CREATOR(LidorMotai)

MOV DX, OFFSET lidor
MOV AH, 09H
INT 21H

;SET CURSOR POSITION TO lidor
MOV BH, 0   ;PAGE
curser  15,40

;WAIT FOR PLAYER TO CLICK SPACE

MOV AH, 07H
INT 21H
CMP AL, 20H
JNE wrong
JE right

wrong:
MOV BH, 0   ;PAGE
MOV DH, 16   ;ROW
MOV DL, 23   ;COLUMN
MOV AH, 02H
INT 10H

MOV DX, OFFSET wrongb
MOV AH, 09H
INT 21H
jmp end

right:

;-------------------GAME PAGE-------------------

MOV AL, 2 ;PAGE NUMBER
MOV AH, 05H
INT 10H

MOV AX, 13H ;changes the num of pixels to 640X480 with 16 colors
INT 10H

; - - - - - - - - - - Game Code - - - - - - - -


CALL print_ball
CALL print_com
CALL print_batt

balloop bdleftup

;PLAYER1 - CLICK?
checkahit:


p1movecheck:

; PRINT BASE
CALL baseprint

delay   00000001b
;
;CMP p1score, 1
;JE score

MOV AL, 0
MOV AH, 01H
INT 16H
JZ noclick
MOV AH, 00H
INT 16H

CMP AH, 48H
JE P1UP
CMP AH, 50H
JE P1DOWN


P1UP:

CMP player1top, 4
JE  checkahit

MOV AL, 13H ;changes the num of pixels to 640X480 with 16 colors
MOV AH, 0
INT 10H

CALL print_com

MOV AX, player1top
SUB AX, 4
MOV player1top, AX

balloop lastaction
JMP hitcheck

CALL print_batt
JMP checkahit

P1DOWN:

CMP player1top, 120
JE  checkahit

MOV AL, 13H
MOV AH, 0
INT 10H

CALL print_com

MOV AX, player1top
ADD AX, 4
MOV player1top, AX

CALL print_batt

balloop lastaction
JMP hitcheck

JMP checkahit

noclick:
balloop lastaction
JMP hitcheck

score:
call clearscreen

END:

;MOV AH, 2CH      ;TIMER
;INT 21H    
;
;CMP DH, 30
;JA NC1
;balloop bdrightup    ;BALLOOP CONFIGURATION  
;NC1:
;balloop bdrightdown    ;BALLOOP CONFIGURATION

ret




