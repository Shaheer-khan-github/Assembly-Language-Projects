.model small
.stack 64
.data
msg1 db 10,13,'missing$'
MSG2 DB 10,13,'$'

fname1 db 40 dup(0)
fname2 db 40 dup(0)
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
 cmp bl,20h
 je l4
 mov fname1[di],bl
 inc si
 inc di
 jmp l3

l4:
  mov di,0
  inc si

l5:
  mov bl,es:byte ptr[si]
  cmp bl,13
  je l6
  mov fname2[di],bl
  inc di
  inc si
  jmp l5

l6:
mov ax,@data
mov es,ax

mov ah,56h
lea dx,fname1
lea di,fname2
int 21h
 


exit:

mov ah,4ch
int 21h

end
 

 