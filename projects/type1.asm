.model small
.stack 100
.data
fname	db	40 dup(0)
msg1    db      13,10,'reqyired parameters missing$'
msg2	db	13,10,'file not found$'
ct	db	22
buf	db	0
.code
      mov     ax,@data             ;initialize data segment
	mov	ds,ax
;
      cmp     byte ptr es:80h,2    ;take byte ptr at 80h
	jae	l2
;
      mov     ah,9                 ;display message
	lea	dx,msg1
	int	21h
	jmp	quit
l2:                                  ;set ptr di at 82h
	mov	di,82h
	mov	si,0
l4:
        mov     al,es:di             ;get the file name
	cmp	al,13
	je	l6
	mov	fname[si],al
	inc	si
	inc	di
	jmp	l4
l6:
        mov     ah,3dh                ;open the file in read mode
	mov	al,0
	lea	dx,fname
	int	21h
	jnc	l8	
;
        mov     ah,9                  ;display message file not found
	lea	dx,msg2
	int	21h
	jmp	quit
l8:
        mov     bx,ax                 ;tranfer the handle
l10:
        mov     ah,3fh                ;read byte after byte from file
	mov	cx,1
	lea	dx,buf
	int	21h
	cmp	ax,0
	je	l14
	mov	dl,buf
	mov	ah,2
	int	21h
	cmp	dl,10
	jne	l10
	dec	ct
	jnz	l10	
l14:                                   ;close file
	mov	ah,3eh
	int	21h	
quit:                                  ;exit to dos
	mov	ah,4ch
	int	21h
	end

