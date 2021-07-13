.model small
.stack 1000h   

.data 

msg1 db " enter decimal number : $"
msg2 db "press b for decimal to binary: h for decimal to haxa : for decimal to octal: $"
msgb db 13,10, " binary form: $"
msgh db  13,10," haxa form: $"
octmsg db 13,10,"In octall: $" 
err1 db  "wrong operator! $" 
msg5 db   'thank you for using this! press any key... $'  
msg6 db   'press y for again: and  q to exist... $'  

counter db 0
curValue db 0
prevValue db 0 
octal db 0 
opr db '?'
num1 db 0
.code
mov ax, @data           ;initialize DS
mov ds, ax

start: 

call newln


lea dx, msg2
mov ah, 09h    ; output string at ds:dx
int 21h
       
 call newln
; get operator:
mov ah, 1   ; single char input to AL.
int 21h

mov opr, al 
  
cmp opr, 'b'
je tbin

cmp opr, 'h'
je tohaxa

cmp opr, 'o'
je tooctal 

; none of the above....
wrong_opr:
call newln
lea dx, err1
mov ah, 09h     ;
int 21h 
call  agian 


exiit:
call newln
lea dx, msg5
mov ah, 09h
int 21h  

mov ah,4ch
int 21h


  ; return back to os.
tbin:
call newln


call print_ax_bin ; binary (16 bit).
ret 

print_ax_bin proc      
    call newln
    mov dx, offset msg1
    mov ah, 9
    int 21h
    call dec_in
    mov dx, offset msgb
    mov ah, 9
     int 21h 
    
    ; print result value in binary:
    mov cx, 16
    mov bx,bx
    print: mov ah, 2   ; print function.
           mov dl, '0'
           test bx, 1000000000000000b  ; test first bit.
           jz zero
           mov dl, '1'
    zero:  int 21h
           shl bx, 1
    loop print      
    ; print binary suffix:
    mov dl, 'b'
    int 21h  
    pop ax
    call newln  
    call agian
     
    ret
print_ax_bin endp 

tooctal: 
call toctal 
toctal proc 
 call newln
 lea dx, msg1
 mov ah, 09h    ; output string at ds:dx
 int 21h
accept:
 mov ah,01h  ; single char input to AL.
 int 21h    
         
cmp al, 13              ;compare al with 13
je exit                 ;jump to label exit if input is 13 

sub al, 48              ;subract al with 48
mov curValue, al        ;move al to curValue

cmp counter, 1          ;compare counter with 1
jl inc_ctr              ;jump to label inc_ctr if al<1

mov al, prevValue       ;move prevValue to al
mov bl, 10
mul bl

add al, curValue        ;add curValue to al

mov prevValue, al       ;move al tp prevValue

inc counter             ;inc_ctr counter
jmp accept              ;jump to label accept

inc_ctr:
mov prevValue, al        ;move al to prevValue 

inc counter                 ;inc_ctr counter
jmp accept              ;jump to label accept

exit:
mov bl,prevValue         ;move prevValue to bl



mov octal, bl            ;move bl to octal
xor bx, bx               ;clear bx


jmp convertTooctall      ;jump to convertTooctall

convertTooctall:

mov ah, 09h              ;load and display the string ctmsg
lea dx, octmsg
int 21h 

mov bh, octal            ;move octal to bh

and bh, 192              ;multiply 192 to bh          
mov cl, 2               ;move 2 to cl
rol bh, cl              ;rotate bh 2x

add bh, 48              ;add 48 to bh 
mov ah, 02              ;set the output function
mov dl, bh              ;move bh to dl
int 21h                 ;print the character

mov bh, octal           ;move octal to bh
and bh, 56              ;add 56 to bh
mov cl, 5               ;move 5 to cl
rol bh, cl              ;rotate bh 5x
add bh, 48              ;add 48 to bh
mov ah, 02              ;set the output function
mov dl, bh              ;move bh to dl
int 21h                 ;print the character

mov bh, octal            ;move octal to bh
and bh, 7               ;mulptiply by 7

add bh, 48              ;add 48 to bh
mov ah, 02              ;set the output function
mov dl, bh              ;move bh to dl
int 21h
mov dl, 'o'
int 21h  
call newln
call agian

toctal endp 
     
tohaxa: 
call newln
call tohax
tohax proc    

mov ah,9           ; print prompt
lea dx,msg1
int     21h
call    dec_in      ; read value into bx
mov ah,9            ; print output label
lea dx,msgh
int     21h 
call    hexout 

tohax endp      ; display the value in bx as hex
             ; bye!
; dec_in will read a base 10 value from the keyboard and place it into the bx    register
dec_in proc 
; save registers
push    ax
push    dx

xor bx,bx       ; bx holds accumulated input
mov ah,1        ; read char fcn
int 21h         ; read it into al
while1: 
cmp al,0Dh      ; char = CR?
je  finis       ; if so, we are done
push    ax      ; save the character read
mov ax,10       ; set up for multiply
mul bx          ; dx:ax <- bx * 10
mov bx,ax       ; put 16-bit result back in bx (assume no overflow)
pop ax          ; restore the char read
and ax,000Fh    ; convert character '0'-'9' to value 0-9
add bx,ax       ; add value to accumulated input
mov ah,1        ; read char fcn
int 21h         ; read next char into al
jmp while1      ; loop until done
finis:  
; restore registers
pop dx
pop ax
ret
dec_in endp

; hexout will display the binary value in the bx register as a base 16 value    
hexout proc
; save registers we will be using
push    ax
push    cx
push    dx
mov ah,2        ; display char fcn
mov cx,4        ; loop counter init
for1:               ; top of for loop
rol bx,4        ; rotate so digit is in lowest 4 bits
mov dl,bl       ; get low half in dl
and dl,0Fh      ;  and mask out all but 4 bits
cmp dl,9        ; dl <= 9?
jnbe    AtoF    ; if not, then it's A-F
or  dl,30h      ; convert 0-9 to '0'-'9'
jmp endif1      ; get ready to display
AtoF:   add dl,55   ; convert 10-15 to 'A'-'F'
endif1: int 21h     ; display char
loop    for1 
mov dl, 'h'
int 21h    ; loop until done
; restore registers
pop dx
pop cx
pop ax 
call agian    
hexout endp

    newln proc    
    
       mov ah,02h
       mov dl,13   ; control device to 3
       int 21h
       mov dl,10   ; ascii codefor new line 
       int 21h 
       ret
       
    newln endp 
    
    agian proc
        
     
    call newln            
    lea dx,msg6
    mov ah,9h
    int 21h
    mov ah,1
    int 21h 
    mov opr,al   
    
    cmp opr,'y'
    je start
    cmp opr,'q'
    je exiit
    agian endp; The recursive function to print UNsigned value of AX register.
; And simpler function to print out binary value of the AX register.
