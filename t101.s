assume cs:codesg

stack segment 
        db 16 dup (0)
stack ends        

data segment
        db 'welcome to masm!',0
data ends

codesg segment
  start:mov ax,stack
        mov ss,ax
        mov sp,16
        mov cx,25
        mov dh,0
        mov dl,0

      s:mov di,cx
        mov cl,2
        mov ax,data
        mov ds,ax
        mov si,0
        call show_str
        mov cx,di
        inc dh
        inc dl
        loop s
        
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
