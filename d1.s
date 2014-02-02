assume cs:codesg

data segment
    db '1975','1976','1977','1978','1979','1980','1981','1982','1983','1984'
    db '1985','1986','1987','1988','1989','1990','1991','1992','1993','1994','1995'

    dd 16,22,382,1356,2390,8000,16000,24486,50065,97479,140417,197514
    dd 345980,590827,803530,1183000,1843000,2759000,3753000,4649000,5937000

    dw 3,7,9,13,28,38,130,220,476,778,1001,1442,2258,2793,4037,5653,8226
    dw 11542,14430,15257,17800
data ends

table segment
    db 21 dup ('year summ ne ?? ')
table ends

str_buffer segment
    db 30 dup (0)
str_buffer ends

stack segment
        dw 50 dup (0)
stack ends

codesg segment
start:mov ax,data
    mov ds,ax
    mov bx,0
    mov ax,table
    mov ss,ax

    mov di,0
    mov cx,21
 s: mov ax,[bx].0h
    mov word ptr ss:[di].0h,ax
    mov ax,[bx].2h
    mov word ptr ss:[di].2h,ax
    mov al,' '
    mov byte ptr ss:[di].4h,al
    add bx,4
    add di,16
    loop s

    mov di,5
    mov bx,84
    mov cx,21
s1: mov ax,[bx].0h
    mov word ptr ss:[di].0h,ax
    mov ax,[bx].2h
    mov word ptr ss:[di].2h,ax
    mov al,' '
    mov byte ptr ss:[di].4h,al
    add bx,4
    add di,16
    loop s1

    mov di,10
    mov bx,168
    mov cx,21
s2: mov ax,[bx].0h
    mov word ptr ss:[di].0h,ax
    mov al,' '
    mov byte ptr ss:[di].2h,al
    add bx,2
    add di,16
    loop s2

    mov di,13
    mov si,5
    mov bp,10
    mov cx,21
s3: mov ax,ss:[si].0h
    mov dx,ss:[si].2h
    mov bx,ss:[bp].0h
    div bx
    mov word ptr ss:[di].0h,ax
    mov al,' '
    mov byte ptr ss:[di].2h,al
    add si,16
    add bp,16
    add di,16
    loop s3

        mov ax,stack
        mov ss,ax
        mov sp,100

        mov ax,str_buffer
        mov ds,ax

        mov ax,table
        mov es,ax

        call clear_screen
        
        mov cx,21
        mov di,0
get_str:push cx
        mov si,0
        mov ax,es:[di]
        mov [si],ax
        add si,2
        add di,2
        mov ax,es:[di]
        mov [si],ax
        add di,3
        add si,2
        mov byte ptr [si],' '
        inc si

        mov ax,es:[di]
        add di,2
        mov dx,es:[di]
        call dtoc

        add si,ax
        dec si
        mov byte ptr [si],' '
        inc si
        add di,3
        mov ax,es:[di]
        mov dx,0
        call dtoc

        add si,ax
        dec si
        mov byte ptr [si],' '
        inc si
        add di,3
        mov ax,es:[di]
        mov dx,0
        call dtoc

        add di,3
        add si,ax
        dec si
        mov byte ptr [si],0

        pop cx
        push cx
        mov dh,25
        sub dh,cl
        mov dl,30
        mov cl,7
        mov si,0
        call show_str  
        pop cx
        
        loop get_str
        
        mov ax,4c00H
        int 21H

  divdw:push si
        
        mov si,ax
        mov ax,dx
        mov dx,0
        div cx
        push ax

        mov ax,si
        div cx
        
        mov cx,dx
        mov si,ax
        pop ax
        mov dx,ax
        mov ax,si
        
        pop si
        ret

   dtoc:push dx
        push di
        push cx
        push si

        mov di,0
 dtoc_s:mov cx,10
        call divdw
        add cx,30h
        mov [si],cl
        inc di
        inc si
        mov cx,dx
        jcxz dtoc_cp
        jmp dtoc_s
dtoc_cp:mov cx,ax
        jcxz dtoc_ok
        jmp dtoc_s
dtoc_ok:mov ax, di
        mov dx,0
        mov cx,2
        div cx
        mov cx,ax
        mov bx,si
        sub bx,di
        push di
        
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
        
 dtoc_p:pop di
        mov cx,7
        sub cx,di
        jcxz dtoc_r
dtoc_fill:mov ax,' '
        mov [si],al
        inc si
        loop dtoc_fill
  dtoc_r:mov ax,0
        mov [si],al
        mov ax,si
        pop si
        sub ax,si
        inc ax
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

clear_screen:push ax
        push ds
        push bx
        push cx
        
        mov ax,0b800h
        mov ds,ax
        
        mov cx,25*80*2
        mov bx,0
        mov al,' '
        mov ah,7
        
 clear_s:mov [bx],ax
        add bx,2
        loop clear_s
        
clear_ok:pop cx
        pop bx
        pop ds
        pop ax
        ret
        
codesg ends

end start
