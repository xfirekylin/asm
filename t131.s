assume cs:codesg

codesg segment
  start:mov ax,cs
        mov ds,ax
        mov si,offset show_str

        mov ax,0
        mov es,ax
        mov di,200h

        mov cx,offset showstr_end - offset show_str
        cld
        rep movsb
        
        mov word ptr es:[7ch*4],200h        
        mov word ptr es:[7ch*4+2],0
        
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
        iret
showstr_end:nop

codesg ends

end start
