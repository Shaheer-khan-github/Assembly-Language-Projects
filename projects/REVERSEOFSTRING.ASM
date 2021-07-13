.model small
.stack 64
.data
 s1   db 10,13,'enter the string $'
 msg1 db 10,13,'reverse is $'

 buff db 80
      db 0
      db 80 dup(0)

.code
 mov ax,@data
 mov ds,ax
 mov es,ax

 mov ah,09h
 lea dx,s1
 int 21h

 mov ah,0ah
 lea dx,buff
 int 21h

 mov ah,09h
 lea dx,msg1
 int 21h


 lea bx,buff
 inc bx
 mov ch,00h
 mov cl,buff+1
 mov di,cx

l1:
 mov dl,[bx+di]
 mov ah,02h
 int 21h
 dec di
 jnz l1


 
ex:
 mov ah,4ch
 int 21h

 end
