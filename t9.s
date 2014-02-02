assume cs:codesg

data segment
        db 'welcome to masm!'
        db 2,24h,71h
data ends

codesg segment
  start:mov ax,0b800h
        mov ds,ax

        mov ax,data
        mov es,ax

        mov bx,720h
        mov si,16
        mov cx,3
      r:mov bp,0
        mov di,cx
        mov ah,es:[si]
        mov cx,16
      l:mov al,es:[bp]
        mov [bx],ax
        add bx,2
        inc bp
        loop l

        inc si
        add bx,128
        mov cx,di
        loop r

        mov ax,4c00H
        int 21H

codesg ends

end start
