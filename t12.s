assume cs:codesg

codesg segment
  start:mov ax,cs
        mov ds,ax
        mov si,offset do0

        mov ax,0
        mov es,ax
        mov di,200h

        mov cx,offset do0_end - offset do0
        cld
        rep movsb
        
        mov word ptr es:[0],200h        
        mov word ptr es:[2],0
        
        mov ax,4c00H
        int 21H

    do0:jmp short do0_start
        db 'divide error!',0

do0_start:mov ax,0b800h
        mov es,ax
        mov di,12*160+66
        mov bl,2
        mov ax,cs
        mov ds,ax
        mov si,202h
        
showstr_s:mov cl,[si]
        mov ch,0
        jcxz showstr_ok
        mov ch,bl
        mov es:[di],cx
        add di,2
        inc si
        loop showstr_s
showstr_ok:mov ax,4c00h
        int 21h
do0_end:nop

codesg ends

end start
