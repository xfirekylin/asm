assume cs:codesg

stack segment 
        dw 20 dup(0)
stack ends        

codesg segment
  start:mov ax,stack
        mov ss,ax
        mov sp,40
        
        mov ax,cs
        mov ds,ax
        mov si,offset int9

        mov ax,0
        mov es,ax
        mov di,204h

        cld

        mov cx,offset int9_end - offset int9

        rep movsb

        push es:[9*4]
        pop  es:[200h]

        push es:[9*4+2]
        pop  es:[202h]

        cli
        mov word ptr es:[9*4],204h
        mov word ptr es:[9*4+2],0
        sti
        
        mov ax,4c00H
        int 21H

   int9:push ax
        push ds
        push si
        push cx
        
        in al,60h

        pushf
        call dword ptr cs:[200h]

        cmp al,9eh
        jne int9_ok

        mov ax,0b800h
        mov ds,ax
        mov si,0
        mov cx,2000
  set_a:mov byte ptr [si],'A'
        add si,2
        loop set_a
        
int9_ok:pop cx
        pop si
        pop ds
        pop ax
        iret
int9_end:nop

codesg ends

end start
