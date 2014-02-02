assume cs:codesg

stack segment 
        db 16 dup (0)
stack ends        

data segment
        db 16 dup (0)
data ends

codesg segment
  start:mov ax,stack
        mov ss,ax
        mov sp,16
        mov ax,4240h
        mov dx,0fh
        mov cx,0ah
        call divdw
        
        mov ax,4c00H
        int 21H

  divdw:mov si,ax
        mov ax,dx
        mov dx,0
        div cx
        push ax

        mov ax,si
        div cx
        
        mov cx,dx
        mov si,ax
        pop ax
        add dx,ax
        mov ax,si
        ret
codesg ends

end start
