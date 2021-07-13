;TSR FOR PRINT SCREEN USING 'ALT+P'                                                                                                                             ;AUTHOR:-


.model small
.stack 100h
.data
.code
begin:
  jmp init
  savint9 dd ?
  msg1    db 13,10,'PRESS ALT+p FOR PRINT SCREEN ...$'
main:
  push ax
  push bx
  push cx
  push dx
  push bp
  push sp
  push ss
  push ds
  push es
  push si
  push di
  pushf
  push cs
  pop  ds
  in al,60h
  cmp al,19h
  jne end_task
  mov ax,40H
  mov es,ax
  mov al,es:17h ;b7=insert,b6=capslock,b5=numlock,b4=scrolllock,b3=alt,b2=ctrl,b1=left shift b0=right shift
  and al,0fh
  cmp al,08h
  jnz end_task
  int 05h
end_task:
  popf
  pop di
  pop si
  pop es
  pop ds
  pop ss
  pop sp
  pop bp
  pop dx
  pop cx
  pop bx
  pop ax
  jmp dword ptr cs:savint9
init:
  cli
  push cs
  pop ds
  mov ah,35h
  mov al,09h
  int 21h
  mov word ptr savint9,bx
  mov word ptr savint9+2,es
  mov ah,25h
  mov al,09h
  mov dx,seg main
  mov ds,dx
  mov dx,offset main
  int 21h
  sti
  mov ah,09h
  lea dx,msg1
  int 21h
  mov ah,31h
  mov al,01
  mov dx,offset init
  int 21h
end begin
