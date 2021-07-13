.model small
.stack 64
.data
msg1 db 10,13,'missing$'
MSG2 DB 10,13,'$'

fname db 40 dup(0)
han dw ?
buff db 0
.code

mov ax,@data
mov ds,ax

mov si,82h

cmp es:byte ptr[80h],0
jne l1

mov ah,09
lea dx,msg1
int 21h

jmp exit

l1:


  mov di,0
 
 l3:

 mov bl,es:byte ptr[si]
 cmp bl,13
 je l4
 mov fname[di],bl

 inc si
 inc di
 jmp l3

l4:
mov ah,3ch
mov cx,0
lea dx,fname
int 21h

mov han,ax

l5:


mov ah,01
int 21h

cmp al,90
je l6

cmp al,13
jne l7

MOV BL,AL
mov ah,09
lea dx,msg2
int  21h
MOV AL,BL
l7:

mov buff,al

mov ah,40h
mov bx,han
mov cx,1
lea dx,buff
int 21h

jmp l5

l6:
mov ah,3eh
mov bx,han
int 21h

exit:

mov ah,4ch
int 21h

end
 

 