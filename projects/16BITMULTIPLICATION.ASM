;Title:Program for 16 bit hex multiplication

.model small

.data
m1  db  10,13,'16 BIT MULTIPLICATION:$'
m2  db  10,13,'Enter the first 8 digit hex number:$'
m3  db  10,13,'Not a hex number! try again:$'
m4  db  10,13,'Enter the second 8 digit hex number:$'
m5  db  10,13,'Multiplication gives:$'

prod1      dw  ?
prod2      dw  ?
prod3      dw  ?
prod4      dw  ?
p1      dw  ?
p2      dw  ?
q1      dw  ?
q2      dw  ?

     
.code

  mov ax,@data               ;initialise base address to data seg
  mov ds,ax

  mov ax,0600h               ;clrscr
  mov bh,14
  mov cx,0000h
  mov dx,184fh
  int 10h

  mov ah,02h                 ;setcursor
  mov bh,00h
  mov dh,02
  mov dl,05
  int 10h


  mov ah,09                  ;display mess1
  lea dx,m1
  int 21h



  mov ch,4                   ;initialise count
  mov cl,4
  mov bx,0000h


l4:                          ;display mess2
   mov ah,09
   lea dx,m2
   int 21h
   mov dh,01h
   mov dl,01h

l6:
   mov ah,01h                ;hex input
   int 21h                   ;if between 0-9
   cmp al,30h
   jb l1
   cmp al,39h
   ja l2
   sub al,30h
   jmp l5

l2:
   cmp al,41h               ;input if between A-F
   jb l1
   cmp al,46h
   ja l3
   sub al,37h
   jmp l5

l3:
    cmp al,61h              ;input if between a-f
    jb l1
    cmp al,66h
    ja l1
    sub al,57h
    jmp l5

l1: mov ah,9h              ;display message if input not hex
    lea dx,m3
    int 21h
    mov ch,04h
    mov cl,04h
    mov bx,0000h
    jmp l4

l5:  rol bx,cl
    mov ah,00h
    or bx,ax
   
    dec ch
    jnz l6
    jmp l7

l7:  cmp dl,00h
     jz l10
     cmp dh, 00h
     jz l8

     mov p1,bx
     mov bx,000h
     mov ch,4
     dec dh
     jmp l6

l8:
     mov p2,bx
     mov bx,0000h
     mov ch,4
     jmp l9

l9:
    mov ah,09
    lea dx,m4
    int 21h

    mov dl,00h
    mov dh,00h
    jmp l6

l10:
    cmp dh,00h
    jnz l11
    mov q1,bx
    mov bx,000h
    mov ch,4
    inc dh
    jmp l6

l11: mov q2,bx
     
     mov bx,000h

l12:                         ;multiplication:gives product in dx,ax
mov ax,p2                    ;if one operand in ax
mul q2
mov prod1,ax
mov prod2,dx

mov ax,p2
mul q1
add prod2,ax
adc prod3,dx
adc prod4,00

mov ax,p1                 ;multiply and store product
mul q2
add prod2,ax
adc prod3,dx
adc prod4,00

mov ax,p1
mul q1
add prod3,ax
adc prod4,dx

mov ah,09                 ;display message
lea dx,m5
int 21h





lab1: mov bx,prod4
      mov cl,4

    

lab2:mov dx,bx             ;unpacking and displaying
     mov ax,0f000h
     and dx,ax
     rol dx,04h
     mov ch,dl
     call disp

     mov dx,bx
     and dx,0f00h
     mov ch,dh
     call disp

     mov dx,bx
     and dx,00f0h
     rol dx,04h
     mov ch,dh
     call disp

     mov dx,bx
     and dx,000fh
     mov ch,dl
     call disp



lab8:cmp cl,4
     jz lab9
     cmp cl,3
     jz lab10
     cmp cl,2
     jz lab12
     jmp lab13
     
lab9:dec cl
     mov bx,prod3
     jmp lab2

lab10:dec cl
      mov bx,prod2
      jmp lab2

lab12:dec cl
      mov bx,prod1
      jmp lab2





disp :
     cmp ch,10
     jc lab14
     add ch,37h

lab15:  xor dx,dx
        mov dl,ch
     mov ah,02h
     int 21h
     ret

lab14:add ch,30h
      jmp lab15

lab13:mov ax,4C00h          ;exit to dos
      int 21h

end



