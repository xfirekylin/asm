assume cs:codesg

stack segment
        db 16 dup (0)
stack ends

codesg segment
  start:mov ax,stack
        mov ss,ax
        mov sp,16

        mov ax,0eh
        call ax
        inc ax
        mov bp,sp
        add ax,[bp]
      
        mov ax,4c00H
        int 21H

codesg ends

end start
