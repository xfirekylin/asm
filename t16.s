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
        mov si,offset int7c

        mov ax,0
        mov es,ax
        mov di,204h

        cld

        ;mov ax,offset sub1 - offset int7c
        ;mov table[0],ax
        ;mov ax,offset sub2 - offset int7c
        ;mov table[1],ax
        ;mov ax,offset sub3 - offset int7c
        ;mov table[2],ax
        ;mov ax,offset sub4 - offset int7c
        ;mov table[3],ax

        mov cx,offset int7c_end - offset int7c

        rep movsb
        
        mov ax,0
        mov es,ax

        mov word ptr es:[7ch*4],204h
        mov word ptr es:[7ch*4+2],0
        
        mov ax,4c00H
        int 21H

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

   org 204h    
   int7c:jmp short int7c_b
        table dw sub1,sub2,sub3,sub4
int7c_b:push bx
        cmp ah,3
        ja sret
        mov bl,ah
        mov bh,0
        add bx,bx
        
        call word ptr table[bx]
        jmp sret

        cmp ah,0
        je sub1_f
        cmp ah,1
        je sub2_f
        cmp ah,2
        je sub3_f
        cmp ah,3
        je sub4_f
        ;call word ptr table[bx]
        jmp sret

sub1_f:call sub1
        jmp sret
sub2_f:call sub2        
        jmp sret

sub3_f:call sub3
        jmp sret

sub4_f:call sub4
        jmp sret

               

    sret:pop bx
        iret

        
   sub1:push bx
        push cx
        push es
        mov bx,0b800h
        mov es,bx
        mov bx,0
        mov cx,2000
  sub1s:mov byte ptr es:[bx],' '
        add bx,2
        loop sub1s
        pop es
        pop cx
        pop bx
        ret

   sub2:push bx
        push cx
        push es

        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
  sub2s:and byte ptr es:[bx],11111000b
        or es:[bx],al
        add bx,2
        loop sub2s

        pop es
        pop cx
        pop bx
        ret

   sub3:push bx
        push cx
        push es
        mov cl,4
        shl al,cl
        mov bx,0b800h
        mov es,bx
        mov bx,1
        mov cx,2000
  sub3s:and byte ptr es:[bx],10001111b
        or es:[bx],al
        add bx,2
        loop sub3s

        pop es
        pop cx
        pop bx
        ret

   sub4:push cx
        push si
        push di
        push es
        push ds

        mov si,0b800h
        mov es,si
        mov ds,si
        mov si,160
        mov di,0
        cld
        mov cx,24*160

        rep movsb

        mov cx,80
        mov si,0
  sub4s:mov byte ptr [160*24+si],' '
        add si,2
        loop sub4s

        pop ds
        pop es
        pop di
        pop si
        pop cx
        ret
        
int7c_end:nop

codesg ends

end start
