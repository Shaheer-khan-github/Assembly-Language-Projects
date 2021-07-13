;Title:Program to check for pallindrome

.model small
.data
str1 db "ENTER A STRING",10,13,'$'
buff db 20,0,20 DUP(0)
str2 db 10,13,'THE STRING IS A EVEN PALINDROME:',10,13,'$'
str3 db 10,13,'THE STRING IS NOT A PALINDROME:',10,13,'$' 
str4 db 10,13,' THE STRING IS AN ODD PALINDROME:',10,13,'$'
len dw 0

.code
start:
mov ax,@data
mov ds,ax

call clrscr
mov dx,0000h
call setcursor
mov ah,09h
lea dx,str1
int 21h

mov ah,0ah
lea dx,buff
int 21h


xor si,si
xor ax,ax
mov al,buff+1

mov si,ax
mov len,ax
xor dx,dx
xor cx,cx
mov bx,02h
mov ax,len
div bx
mov bx,ax
xor si,si
xor cx,cx
mov cl,bh
xor di,di
mov di,len
dec di
xor ax,ax

loop1:
mov ah,buff[2+di]
cmp  ah,buff[2+si]
jne unequ
xor ax,ax
inc si
dec di
cmp si,bx
jne loop1
xor ax,ax
xor dx,dx

equt:
mov bx,02h
mov ax,len
div bx
cmp dl,0h
jne disp1
mov ah,09h
lea dx,str2
int 21h
call quit

disp1:
mov ah,09h
lea dx,str4
int 21h
call quit

unequ:
mov ah,09h
lea dx,str3
int 21h
call quit

 CLRSCR PROC                    ; [ DEFINITION OF CLEAR SCREEN PROC. ]
               MOV AX,0600H
              MOV BH,07H
            MOV CX,0000H
           MOV DX,184FH
           INT 10H
          RET
         ENDP                   ; Ends CLRSCR procedure.
      SETCURSOR PROC                 ; [ DEFINITION OF SETCURSOR PROC. ] 
              MOV AH,02
            MOV BH,00H
           INT 10H
        RET
       ENDP                   ; Ends the SETCURSOR procedure.
quit:   

mov ax,4c00h
int 21h
end start



