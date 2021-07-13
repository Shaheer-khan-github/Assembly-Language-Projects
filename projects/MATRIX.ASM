ms macro msg
         push   dx
         mov    dx,offset msg
         mov    ah,09h
         int    21h
         pop    dx
         
endm



data segment

         msg    db "enter the matrices row-wise.$"                                           
         msg1   db 10,13,"enter the first 3*3 matrix:$"
         msg2   db 10,13,"enter the second 3*3 matrix:$"
         msg3   db 10,13,"after additon the resultant matrix is:$"
         msg4   db "  $"
         arr1   db 9 dup (00)
         arr2   db 9 dup (00)
         cnt    db ?

data ends


code segment


         assume cs:code,ds:data


start:
         mov    ax,data
         mov    ds,ax


         ms     msg
         ms     msg1
         mov    si,offset arr1
         mov    dh,09h
         call   create

         ms     msg2
         mov    si,offset arr2
         mov    dh,09h
         call   create
         jmp    add2



   proc create near 

    a:
         xor    ax,ax
         mov    cl,04h
         mov    ch,02h
         mov    bx,0000h
         mov    dl,00h


   l2:
         mov    ah,08h
         int    21h


         cmp    al,30h
         jb     l2

         cmp    al,39h
         jbe    l4

         cmp    al,39h
         ja     l2

   l4:
         mov    dl,al
         mov    ah,02h
         int    21h


         cmp    dl,39h
         sub    dl,30h

   l6:
         shl    bx,cl
         add    bl,dl
         dec    ch
         jnz    l2
         jz     l8


   l8:
         mov    [si],bx
         inc    si
         dec    dh
         ms     msg4
         jnz    a
         ret
   endp


   add2:
         
         mov    si,offset arr1
         mov    di,offset arr2
         mov    dh,09h

  add1:
         xor    ax,ax
         mov    al,[si]
         add    al,[di]
         mov    [si],al
         inc    si
         inc    di
         dec    dh
         jnz    add1

         mov    si,offset arr1
         jmp    disp



  disp:
         xor    bx,bx
         ms     msg3
         mov    ch,09h
         mov    cl,04h


     z:
         mov    dh,02h
         mov    bl,[si]

     p:
         rol    bl,cl
         mov    dl,bl
         and    dl,0Fh
         cmp    dl,09h
         jbe    d
         add    dl,07h

     d:
         add    dl,30h

     q:
         mov    ah,02h
         int    21h
         dec    dh
         jnz    p
         inc    si
         ms     msg4
         dec    ch
         jnz    z


  exit:

         mov    ah,4ch
         int    21h



code ends
end start






