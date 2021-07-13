.model small
.stack 64
.data
  m1 db 10,13,"enter first number$"
  m2 db 10,13,"enter second number$"
  m3 db 10,13,"addition is $"
  m4 db 10,13,"subtraction is $"
  m5 db 10,13,"******MENU****** $"
  m6 db 10,13,"1.ADDITION $"
  m7 db 10,13,"2.SUBTRACTION $"
  m8 db 10,13,"3.MULTIPLICATION $"
  m9 db 10,13,"4.DIVISION $"
  m10 db 10,13,"5.EXIT $"
  m11 db 10,13,"ENTER YOUR CHOICE:: $"
  m12 db 10,13,"product is $"
  m13 db 10,13,"quotient is $"
  m14 db 10,13,"remainder is $"

  n1 dw ?
  n2 dw ?
  n3 dw ?
  p1 dw ?
  p2 dw ?
  d1 dw ?
  d2 dw ?
.386 
.code
  mov ax,@data
  mov ds,ax
  mov es,ax

  mov ah,09h
  lea dx,m1
  int 21h

  call inp
  mov n1,bx

  mov ah,09h
  lea dx,m2
  int 21h

  call inp
  mov n2,bx

a1:
  mov ah,09h
  lea dx,m5
  int 21h

  mov ah,09h
  lea dx,m6
  int 21h

  mov ah,09h
  lea dx,m7
  int 21h

  mov ah,09h
  lea dx,m8
  int 21h

  mov ah,09h
  lea dx,m9
  int 21h

  mov ah,09h
  lea dx,m10
  int 21h

  mov ah,09h
  lea dx,m11
  int 21h

  mov ah,01h
  int 21h
  sub al,30h
  
a2:
  cmp al,1
  je ad1
  

  cmp al,2
  je su1
 
  cmp al,3
  je mu1

  cmp al,4
  je di1

  cmp al,5
  je ex1

  

ad1:
  mov ax,n1
  add ax,n2
  mov n3,ax

  mov ah,09h
  lea dx,m3
  int 21h

  mov bx,n3
  call disp
  jmp ex1


su1:
  mov ax,n1
  sub ax,n2
  mov n3,ax

  mov ah,09h
  lea dx,m4
  int 21h

  mov bx,n3
  call disp
  jmp ex1

mu1:
  mov ax,n1
  mul n2
  mov p1,dx
  mov p2,ax

  mov ah,09h
  lea dx,m12
  int 21h

  mov bx,p1
  call disp

  mov bx,p2
  call disp
  jmp ex1

di1:
  mov ax,n1
  cwd
  div n2
  mov d1,ax
  mov d2,dx

  mov ah,09h
  lea dx,m13
  int 21h

  mov bx,d1
  call disp

  mov ah,09h
  lea dx,m14
  int 21h

  mov bx,d2
  call disp


ex1:
  mov ah,4ch
  int 21h
  
inp:
    mov ch,04h
    mov bx,0000h
l1:
    shl bx,04h
    mov ah,01h
    int 21h
    cmp al,41h
    jb l2
    sub al,07h
l2:
    sub al,30h
    mov ah,00h
    add bx,ax
    dec ch
    jnz l1

    ret
disp:
    mov ch,04h

l3:
    rol bx,04h
    mov dx,bx
    and dx,000fh
    cmp dx,0ah
    jb l4
    add dx,07h
l4:
    add dx,30h
    mov ah,02h
    int 21h
    dec ch
    jnz l3

    ret

  end
