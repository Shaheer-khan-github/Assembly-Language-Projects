;A PROGRAM TO IMPLEMENT BOOTH'S ALGORITHM FOR SIGNED NUMBER MULTIPLICATION
print macro message
mov ah, 09h
lea dx, message
int 21h
endm

.model small
.stack 100
.data
msg db 10, 13,          "BOOTH'S ALGORITHM FOR 8-BIT"
db                      "MULTIPLICATION $"
remark db 10, 13,        "ENTER VALUE PRECEEDING WITH + OR - SIGN $"
msg1 db 10, 13,          "ENTER THE MULTIPLICAND :$"
msg2 db 10, 13,          "ENTER THE MULTIPLIER :$"
result db                "THE RESULT OF MULTIPLICATION IS :$"
newline db 10,13,        "$"
m db 0
q db 0
a db 0
q_1 db 0
cnt db 8
sign_flag db 0

.code
mov ax, @data
mov ds, ax
print newline
print msg
print newline
print remark
print newline
print newline


;************************* ACCEPT MULTIPLICAND **************************

print msg1
        call get_data
        cmp sign_flag, 01
        jnz post_m
        neg bl
        mov sign_flag, 0

post_m :
        mov m, bl

;*********************** ACCEPT MULTIPLIER ******************************

        print msg2
        call get_data
        cmp sign_flag, 01
        jnz post_q
        neg bl
        mov sign_flag, 0

post_q :
        mov q, bl
        call booth_algo
        mov ah, 4ch
        int 21h

;***********************PROCEDURE TO ACCEPT 8-BIT NUMBER*************************

        get_data proc near
        mov ah, 01h
        int 21h
        cmp al, '-'
        jne post
        mov sign_flag, 1

post :
        mov cx, 0204h
        mov bl, 0

accept :
        mov ah, 08h
        int 21h
        cmp al, 0dh
        jz complt
        cmp al, 30h
        jb accept
        cmp al, 39h
        jg accept
        mov dl, al
        mov ah, 02h
        int 21h
        sub al, 30h
        shl bl, cl
        add bl, al
        dec ch
        jnz accept

complt :
        call bcd2hx

ret

get_data endp

;************************ END OF GET_DATA PROCEDURE ************************

;*********************** PROCEDURE TO IMPLEMENT BOOTH'S ALGORITHM ********************

booth_algo proc near
        mov q_1, 0
        mov bh, a
        mov bl, q

go_on :
        call check
        call shift
        dec cnt
        jnz go_on
        print newline
        print newline
        print result
        mov ax, bx
        and ah, 80h
        cmp ah, 00
        jz pos_ans
        neg bx
        mov dl, '-'
        mov ah, 02h
        int 21h

pos_ans :
        call disp_ans

booth_algo endp

;********************* END OF BOOTH'S ALGORITHM PROCRDURE ************************


;******************** PROCEDURE TO COMPARE Q0 AND Q_1 BITS ***********************

        check proc near
        mov cl, bl
        and cl, 01
        cmp cl, q_1
        je skip
        jg subt
        add bh, m
        jmp skip

subt :
        sub bh, m

skip :
        ret

check endp

;******************** END OF CHECK PROCEDURE *********************************

;******************** PROCEDURE TO SHIFT BITS ********************************

shift proc near
        mov cx, bx
        and cx, 01
        mov q_1, cl
        sar bx, 1
        ret
shift endp

;****************** END OF SHIFT PROCEDURE *****************************

;***************** PROCEDURE TO DISPLAY RESULT *************************

disp_ans proc near
        call hex2bcd
        mov cx, 0404h

dispx :
        rol bx, cl
        mov dl, bl
        and dl, 0fh
        add dl, 30h
        mov ah, 02h
        int 21h
        dec ch
        jnz dispx
        ret
disp_ans endp

;****************** END OF DISP_ANS PROCEDURE ***********************

;***************** PROCEDURE TO CONVERT HEX TO BCD ******************

hex2bcd proc near
        mov cx, 00

thousd :
        cmp bx, 1000
        jb hund
        sub bx, 1000
        add cx, 1000h
        jmp thousd

hund :
        cmp bx, 100
        jb tens
        sub bx, 100
        add cx, 100h
        jmp hund

tens :
        cmp bx, 10
        jb unit
        sub bx, 10
        add cx,10h
        jmp tens

unit :
        add cx, bx
        mov bx, cx
        ret
hex2bcd endp

;************************* END OF HX2BCD PROCEDURE ****************************

;************************ PROCEDURE TO CONVERT BCD TO HEX *********************

bcd2hx proc near
        mov cl, 00

tens1 :
        cmp bl, 10h
        jb unit1
        sub bl, 10h
        add cl, 10
        jmp tens1

unit1 :
        add cl, bl
        mov bl, cl
        ret
bcd2hx endp

;***********************END OF BCD2HX PROCEDURE ********************************

end


        



