assume cs:codesg

stack segment 
        dw 20 dup(0)
stack ends        

codesg segment
  start:mov ax,stack
        mov ss,ax
        mov sp,40
        
        mov ah,2
        mov al,7
        int 7ch

        mov ax,4c00h
        int 21h
        
  delay:push bx
        push ax
        
        mov bx,1000h
        mov ax,0
        sub ax,1
        sbb bx,0
        cmp bx,0
        jne delay
        cmp ax,0
        jne delay

        pop ax
        pop bx
        ret

codesg ends

end start
