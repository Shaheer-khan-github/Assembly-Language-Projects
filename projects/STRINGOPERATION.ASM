ms macro msg       
      push      dx
      mov       ah,09h
      lea       dx,msg
      int       21h
      pop       dx
endm

data segment
         buff db 50
         len1 db ?
         str1 db 50 dup ("$")
         str2 db 50 dup ("$")
         msg  db 10,13,"enter the string:$"
         msg1 db 10,13,"1.length of string$"
         msg2 db 10,13,"2.reverse of string$"
         msg3 db 10,13,"3.palindrome of string$"
         msg4 db 10,13,"plz enter your choice:$"
         msg5 db 10,13,"length of string is:$"
         msg6 db 10,13,"reverse of string is:$"
         msg7 db 10,13,"string is not a palindrome$"
         msg8 db 10,13,"string is a palindrome$"
data ends

code segment
         assume cs:code,ds:data

  start:
         mov    ax,data
         mov    ds,ax
         mov    es,ax

         ms     msg

         mov    ah,0Ah
         lea    dx,buff
         int    21h


         ms     msg1
         ms     msg2
         ms     msg3
         ms     msg4

         mov    ah,01h
         int    21h

         cmp    al,31h
         je     one

         cmp    al,32h
         je     two

         cmp    al,33h
         je     three

         jmp    exit


    one:
         call   length
         jmp    exit

    two:
         call   reverse
         jmp    exit

  three:
         call   palindrome
         jmp    exit


    proc length near

         ms     msg5
         mov    cl,04h
         mov    ch,02h
         mov    bx,0000h
         mov    bl,len1

     d:
         rol    bl,cl
         mov    dl,bl
         and    dl,0fh

         cmp    dl,09h
         jbe    l2
         add    dl,07h

     l2:
         add    dl,30h

         mov    ah,02h
         int    21h
         dec    ch
         jnz    d
         ret
     endp

     proc reverse near

         mov    cl,len1
         dec    cl
         mov    ch,len1
         lea    si,str1
     a:
         inc    si
         dec    cl
         jnz    a
         lea    di,str2

     b:
         mov    bl,[si]
         mov    [di],bl
         inc    di
         dec    si
         dec    ch
         jnz    b
         ms     msg6
         ms     str2
         ret
    endp

    proc palindrome near


         lea    si,str1
         lea    di,str1
         mov    ch,00h
         mov    cl,len1
         add    di,cx
         xor    bx,bx
         cld


      p:

         mov    bh,[si] 
         mov    bl,[di]
         cmp    bh,bl
         jnz    below

         ms     msg7       





  below:
         inc    si
         dec    di
         dec    ch
         jnz    p
         ms     msg8
         


    endp

 exit:
         mov    ah,4ch
         int    21h

code ends
end start


