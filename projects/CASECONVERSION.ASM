ms macro msg

         mov    ah,09h
         mov    dx,offset msg
         int    21h
endm


data segment


         buff db 50 dup (0)


         msg1  db  10,13,'enter the string in upper case:$'
         msg  db  10,13,'the string in lower case is:$'


data ends



code segment



         assume cs:code,ds:data



         mov    ax,data
         mov    ds,ax

start:

         ms     msg1

         mov    ah,0Ah
         lea    dx,buff
         int    21h

         mov    ch,00h
         mov    cl,buff+1
         lea    bx,buff+2
         mov    si,00h

         mov    dx,0000h

         ms     msg
      


check:

         mov    dl,[bx+si]
         add    dl,20h

         mov    ah,02h
         int    21h

         inc    si
         dec    cx
         jnz    check


exit:
         mov    ah,4ch
         int    21h


code ends
end start


