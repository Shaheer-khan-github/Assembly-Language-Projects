
ms macro msg
         push   dx
         mov    ah,09h
         mov    dx,offset msg
         int    21h
         pop    dx
endm

data segment

         msg db "enter the count:$"
         msg1 db 10,13, "enter the elements:$"
         msg2 db 10,13,"the addition of elements is:$"
         msg3 db 10,13,"carry:$"
         msg4 db "  $"
         arr dw 10 dup(00)
         res db ?
         cnt1 db ?
         cnt db ?
data ends

code segment
        assume cs:code,ds:data

 start:
          mov   ax,data
          mov   ds,ax

          ms    msg
          mov   ah,01h
          int   21h
          cmp   al,39h
          jbe   d
          sub   al,07h

     d:
          sub   al,30h
          mov   cnt1,al

          ms    msg1
          mov   si,offset arr
          mov   cl,04h
          mov   dl,cl
          mov   dh,cnt1

    up:
       
          mov   cl,04h
          mov   ch,04h
          mov   bx,0000h

    l2:
          mov   ah,08h
          int   21h

          cmp   al,30h
          jb    l2

          cmp   al,39h
          jbe   l4

          cmp   al,41h
          jb    l2

          cmp   al,46h
          ja    l2

    l4:
          mov   dl,al
          mov   ah,2
          int   21h

          cmp   dl,39h 
          jbe   l6

          sub   dl,07h

    l6:
          sub   dl,30h
          shl   bx,cl
          add   bl,dl
          dec   ch
          jnz   l2
          jz    l8

    l8:
          mov   [si],bx
          inc   si
          inc   si
          dec   dh
          ms    msg4
          jnz   up

    add:
          mov   cl,04h
          mov   ch,00h
          mov   ax,00h
          mov   si,offset arr
          mov   bx,0000h

    one: 
          add   ax,[si]
          jnc   two
          inc   ch

    two:
          inc   si
          inc   si
          dec   cl
          jnz   one
          mov   bx,ax
          mov   res,ch

          ms    msg2

    disp:
          mov   cl,04h
          mov   ch,04h
          mov   dl,00h

       a:
          rol   bx,cl
          mov   dl,bl
          and   dl,0Fh
          cmp   dl,09h
          jbe   l12
          add   dl,07h
     l12:
          add   dl,30h

          mov   ah,02h
          int   21h
          dec   ch
          jnz   a

          ms    msg3
          mov   dl,00h
          add   res,30h
          mov   dl,res
          mov   ah,02h
          int   21h


   exit:
          mov   ah,4ch
          int   21h

code ends
end start
