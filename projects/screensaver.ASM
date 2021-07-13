        ;           PROGRAM ON SCREEN SAVER USING TSR
        ; THE SREEN IS BLANKED AFTER EVERY 30 SECONDS

        .model small
        .stack 100
        .code
        resi_kbd:
                mov     cs:count,0
                cmp     cs:flag,0
                jz      kbd_quit
        ;
                mov     cs:flag,0
                push    cx
                push    ds
                push    es
                push    si
                push    di
                push    cs
                pop     ds
        ;
                mov     si,offset buf
                mov     di,0b800h
                mov     es,di
                mov     di,0
                mov     cx,2000
                rep     movsw
                pop     di
                pop     si


                pop     es
                pop     ds
                pop     cx
                jmp q7
        kbd_quit:
                push    ax
                in      al,60h
                cmp     al,3bh
                jnz     quit_2
                xor     cs:flag2,1
                jmp     quit_6
        quit_2:
                cmp     al,3ch
                jnz     quit_6
                push    ds
                push    es
                push    di
                push    si
        ;
                push    cs
                pop     ds
                mov     si,offset old_iptim
                mov     di,0
                mov     es,di
                mov     di,32
                mov     cx,4
                rep     movsw
                pop     si
                pop     di
                pop     es
                pop     ds 
        quit_6:
                pop     ax
        q7:
                jmp     cs:dword ptr old_ipkbd
        ;
        resi_tim:

                cmp     cs:flag2,1
                je      tim_quit
                cmp     cs:flag,1
                jz      tim_quit
        ;
                inc     cs:count
                cmp     cs:count,182
                jc      tim_quit
        ;
                mov     cs:flag,1
                push    ax
                push    cx
                push    ds
                push    es
                push    si
                push    di
                push    cs
                pop     es
        ;
                mov     di,offset buf
                mov     si,0b800h
                mov     ds,si
                mov     si,0
                mov     cx,2000
                rep     movsw
        ;
                mov     di,0b800h
                mov     es,di
                mov     di,0
                mov     ax,7020h
                mov     cx,2000
                rep     stosw
        ;
                pop     di
                pop     si
                pop     es
                pop     ds
                pop     cx
                pop     ax
        tim_quit:
                jmp     cs:dword ptr old_iptim
        ;
        old_iptim       dw      0
        old_cstim       dw      0
        old_ipkbd       dw      0
        old_cskbd       dw      0
        buf             db      4000 dup(0)
        flag            db      0
        flag2           db      0
        count           dw      0
        ;
        init:
                push    cs
                pop     ds
                mov     ah,35h
                mov     al,09
                int     21h
        ;
                mov     old_ipkbd,bx
                mov     old_cskbd,es
                lea     dx,resi_kbd
                mov     ah,25h
                mov     al,9
                int     21h
        ;
                mov     ah,35h
                mov     al,08
                int     21h
        ;
                mov     old_iptim,bx
                mov     old_cstim,es
                lea     dx,resi_tim
                mov     ah,25h
                mov     al,8
                int     21h
        ;
                lea     dx,init
                sub     dx,offset resi_kbd
                add     dx,272
                mov     cl,4
                shr     dx,cl
                mov     ah,31h
                int     21h
                end     init
        
