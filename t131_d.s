assume cs:codesg

data segment
        db 'welcome to masm!',0
data ends

codesg segment
  start:mov ax,data
        mov ds,ax
        mov si,0

        mov dh,10
        mov dl,10
        mov cl,2
        
        int 7ch

        mov ax,4c00H
        int 21H

codesg ends

end start
