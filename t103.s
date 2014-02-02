assume cs:codesg

stack segment 
        dw 16 dup (0)
stack ends        

data segment
        db 10 dup (0)
        dw 123,12666,1,8,3,38
data ends

codesg segment
  start:mov ax,stack
        mov ss,ax
        mov sp,32
        mov cx,6
        mov dh,5
        mov dl,0
        
        mov bp,10
      s:mov di,cx
        mov ax,data
        mov ds,ax
        mov ax,ds:[bp]
        mov si,0
        call dtoc
        
        mov cl,2
        mov si,0
        call show_str
        mov cx,di
        inc dh
        inc dl
        add bp,2
        loop s
        
        mov ax,4c00H
        int 21H

   dtoc:push dx
        push di
        push cx
        push ax
        push si

        mov di,0
 dtoc_s:mov dx,0
        mov cx,10
        div cx
        add dx,30h
        mov [si],dl
        inc di
        inc si
        mov cx,ax
        jcxz dtoc_ok
        jmp dtoc_s
dtoc_ok:mov ax, di
        mov dx,0
        mov cx,2
        div cx
        mov cx,ax
        mov bx,si
        sub bx,di
        
        jcxz dtoc_p
        mov di,si
        dec di
    rev:mov dl,[di]
        mov al,[bx]
        mov [di],al
        mov [bx],dl
        inc bx
        dec di
        loop rev
 dtoc_p:mov ax,0
        mov [si],ax
        pop si
        pop ax
        pop cx
        pop di
        pop dx
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
