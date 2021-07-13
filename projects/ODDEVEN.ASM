
ms macro msg
        push    dx
        mov     dx,offset msg
        mov     ah,09h
        int     21h
        pop     dx
endm


data segment
        msg1  db 10,13,"enter the count:$"
        msg2  db 10,13,"enter the numbers:$"
        msg3  db 10,13,"even numbers are:$"
        msg4  db 10,13,"odd  numbers are:$"
        msg5  db "  $"
        arr1  dw 10 dup (00)
        odd   dw 10 dup (00)
        even2 dw 10 dup (00)
        cnt   db ?
        cnt1  db ?
data ends


code segment

        assume cs:code,ds:data

   start:
           mov  ax,data
           mov  ds,ax

           mov  cx,0404h
           mov  si,offset arr1

           ms   msg1
           mov  ah,01h
           int  21h

           cmp  al,39h
           jbe  l2

           sub  al,07h
      l2:
           sub  al,30h
           mov  cnt,al
           mov  dh,cnt

           ms   msg2
      up:
           mov  cx,0204h
           mov  bx,0000h

      l4:
           mov  ah,08h
           int  21h

           cmp  al,30h
           jb   l4

           cmp  al,39h
           jbe  l6

           cmp  al,39h
           ja   l4

      l6:
           mov  dl,al
           mov  ah,02h
           int  21h

           cmp  dl,39h
           jbe  l8
           sub  dl,07h

      l8:
           sub  dl,30h
           shl  bx,cl
           add  bl,dl
           dec  ch
           jnz  l4
           jz   l10

      l10:
           mov  [si],bx
           inc  si
           dec  dh
           ms   msg5
           jnz  up

           mov  ch,00h

      one:     

           xor  si,si
           xor  di,di
           mov  si,offset odd
           mov  di,offset even2
           mov  bp,offset arr1
           xor  ax,ax
           mov  dh,cnt 


    test1:
           mov  al,[bp]
           mov  bl,[bp]
           and  al,01h
           jz   even1
           mov  [si],bl
           inc  si
           inc  bp
           inc  ah
           dec  dh
           jnz  test1
           jz   disp1

    even1:
           mov  [di],bl
           inc  di
           inc  bp
           inc  ch
           dec  dh
           jnz  test1
           jz   disp1
     

    disp1:
           mov  cnt1,ah
           ms   msg3
           mov  ah,09h
           int  21h

           mov  di,offset even2
           mov  dh,ch
           mov  cl,04h
           xor  bx,bx
           mov  dl,00h


       z:
           mov  bl,[di]
           mov  ch,02h

       p:
           rol  bl,cl
           mov  dl,bl
           and  dl,0Fh
           cmp  dl,09h
           jbe  d
           add  dl,07h
       d:
           add  dl,30h

       q:
           mov  ah,02h
           int  21h
           dec  ch
           jnz  p
           inc  di
           ms   msg5
           dec  dh
           jnz  z
           

   disp2:
           ms   msg4
           mov  ah,09h
           int  21h

           mov  si,offset odd
           mov  dh,cnt1
           mov  cl,04h
           xor  bx,bx
           mov  dl,00h


      z1:
           mov  bl,[si]
           mov  ch,02h

      p1:
           rol  bl,cl
           mov  dl,bl
           and  dl,0Fh
           cmp  dl,09h
           jbe  d1
           add  dl,07h
      d1:
           add  dl,30h

      q1:
           mov  ah,02h
           int  21h
           dec  ch
           jnz  p1
           inc  si
           ms   msg5
           dec  dh
           jnz  z1


     exit:
           mov  ah,4ch
           int  21h


code ends
end start




















