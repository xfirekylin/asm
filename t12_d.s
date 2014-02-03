assume cs:codesg

codesg segment
  start:mov ax,cs
        mov ds,ax

        mov ax,1000
        mov bl,2
        div bl
        
        mov ax,4c00H
        int 21H


codesg ends

end start
