assume cs:codesg

stack segment 
        dw 20 dup(0)
stack ends        

codesg segment
            db 30 dup (0)
     split: db '// :: '
  port_bit: db 9,8,7,4,2,0

  start:mov ax,cs
        mov ds,ax
        mov si,0

        mov di,offset split
        mov bx,offset port_bit
        
        mov ax,stack
        mov ss,ax
        mov sp,40

        mov cx,6
get_time:push cx
        mov al,[bx]
        out 70h,al
        in  al,71h

        mov ah,al
        mov cl,4
        shr al,cl
        and ah,00001111b
        add ah,30h
        add al,30h

        mov [si],ax
        add si,2
        mov al,[di]
        mov [si],al
        inc si
        inc di
        inc bx
        pop cx
        loop get_time

        
        mov dh,13
        mov dl,30
        mov cl,2
        mov si,0
        call show_str
        
        mov ax,4c00H
        int 21H

show_str:push ax
        push es
        push dx
        push bx
        push di
        push si
        push cx
        
        mov ax,0b800h
        mov es,ax
        mov al,dh
        mov bl,0a0h
        mul bl
        mov di,ax
        mov al,dl
        mov bl,2
        mul bl
        add di,ax
        mov bl,cl
        
showstr_s:mov cl,[si]
        mov ch,0
        jcxz showstr_ok
        mov ch,bl
        mov es:[di],cx
        add di,2
        inc si
        loop showstr_s
showstr_ok:pop cx
        pop si
        pop di
        pop bx
        pop dx
        pop es
        pop ax
        ret

codesg ends

end start
