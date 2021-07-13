.model  small     
.stack  100h
.data
 
 mes1   db      10,13, 'Format completed.......$'
 mes2   db      10,13, 'ERROR!!!!!!!!$'
 rbuf   db      512*14  dup (0)
 fbuf   db      512*9   dup (0)
 fobuf  db      512*9   dup ()

.code
        mov     ax,@data
        mov     ds,ax      

        mov     al,0
        mov     cx,9
        mov     dx,1
        lea     bx,fobuf
        int     25h
        pop     ax

        mov     al,0
        mov     cx,14
        mov     dx,19
        lea     bx,rbuf
        int     26h
        pop     ax
        jc      error

        mov     al,0f0h
        mov     si,0
        mov     byte ptr fbuf[si],al
        mov     ax,0ffffh
        inc     si
        mov     word ptr fbuf[si],ax


        mov     dx,2
l2:     mov     bx,dx
        mov     ax,bx
        shl     bx,1
        add     bx,ax
        shr     bx,1
        mov     si,bx
        mov     bx,word ptr fobuf[bx]
        jnc     l4
        mov     cl,4
        shr     bx,cl
        and     bx,0fffh
        cmp     bx,0ff7h
        jne     l6
        mov     word ptr fbuf[si],0ff70h       
        jmp     l6      
l4:     and     bx,0fffh
        cmp     bx,0ff7h
        jne     l6
        mov     word ptr fbuf[si],0ff7h

l6:     inc     dx
        cmp     dx,2847
        jnz     l2

        mov     al,0
        mov     cx,9
        mov     dx,1
        lea     bx,fbuf
        int     26h
        pop     ax
        jc      error


        mov     al,0
        mov     cx,9
        mov     dx,10
        lea     bx,fbuf
        int     26h
        pop     ax
        jc      error
        jmp     complete

error:  mov     ah,9
        lea     dx,mes2
        int     21h
 	jmp	quit

complete:        mov     ah,9
        	 lea     dx,mes1
	         int     21h

quit:   mov     ah,4ch
        int     21h
        end     

        
