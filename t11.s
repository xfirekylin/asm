assume cs:codesg

data segment
        db "Beginner's All-purpose Symbolic Instruction Code.",0
data ends

codesg segment
  start:mov ax,data
        mov ds,ax
        mov si,0
        
        call letterc

        mov dh,5
        mov dl,2
        mov cl,7
        mov si,0
        call show_str 
        
        mov ax,4c00H
        int 21H

letterc:push ax
        push si

letter_b:mov al,[si]
        cmp al,0
        je  letter_ok
        cmp al,'a'
        jb  letter_n
        cmp al,'z'
        ja  letter_n
        sub al,'a'-'A'
        mov [si],al
letter_n:inc si
        jmp letter_b

letter_ok:pop si
        pop ax
        ret

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
