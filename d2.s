assume cs:codesg

stack segment 
        dw 20 dup(0)
stack ends        

codesg segment
  start:mov ax,cs
        mov es,ax
        mov bx,offset boot

        mov al,1
        mov ch,0
        mov cl,1
        mov dh,0
        mov dl,0

        mov ah,3
        int 13h

        mov bx,offset boot_2
        mov cl,2
        mov al,5

        mov ah,3
        int 13h
        
        mov ax,4c00h
        int 21h

        ORG 7c00h
        
   boot:mov ax,cs
        mov es,ax
        mov bx,2000h

        mov al,5
        mov ch,0
        mov cl,2
        mov dh,0
        mov dl,0

        mov ah,2
        int 13h

        mov ax,cs
        push ax
        mov ax,2000h
        push ax
        retf

        ORG 2000h
   boot_2:jmp boot_s
       option1 db '1) reset pc',0
       option2 db '2) start system',0
       option3 db '3) clock',0
       option4 db '4) set clock',0
       str_tab dw option1,option2,option3,option4
     date_time db 'yy/mm/dd hh:mm:ss',0
      port_bit db 9,8,7,4,2,0
      date_tip db 'please input date and time(yy/mm/dd hh:mm:ss),press enter end input',0
    date_error db 'input error,please reinput',0
     digit_err db 'no digit error',0
     split_err db 'no split erro ',0
      calc_err db 'calc error',0
       bcd_err db 'bcd error',0
      date_buf db 30 dup (0)
    date_digit db 6 dup (0)
     month_day db 0,31,29,31,30,31,30,31,31,30,31,30,31
     date_idx  dw 0,1,3,4,6,7,9,10,12,13,15,16
     split_idx dw 2,5,8,11,14
        stackb db 400 dup (0)
      stackb_t db 0
       
 boot_s:mov ax,cs
        mov ss,ax
        mov sp,offset stackb_t
        
        call clear_screen
        
        mov bx,0
        mov cx,4
        
        mov dh,4
        mov dl,5
        
disp_menu:push cx
        mov cl,7
        mov ax,cs
        mov ds,ax
        mov si,str_tab[bx]
        call show_str
        add bx,2
        inc dh
        pop cx
        loop disp_menu

scan_key:mov ah,0
        int 16h
        cmp al,'1'
        je reset_pc
        cmp al,'2'
        je start_os
        cmp al,'3'
        je clock
        cmp al,'4'
        je set_clock_f
        jmp scan_key

set_clock_f:jmp near ptr set_clock
        ret

reset_pc:mov ax,0ffffh
        push ax
        mov ax,0
        push ax
        retf        
        
start_os:mov ax,cs
        mov es,ax
        mov bx,7c00h

        mov al,1
        mov ch,0
        mov cl,1
        mov dh,0
        mov dl,80h

        mov ah,2
        int 13h

        mov ax,cs
        push ax
        mov ax,7c00h;
        push ax
        retf
        
  clock:call clear_screen
        mov ax,cs
        mov ds,ax
        mov si,offset date_time
        
        mov bx,offset port_bit
        mov cl,7
        push cx ;color
        
 clock_d:mov cx,6
get_time:push cx
        mov al,[bx]
        out 70h,al
        in  al,71h

        mov ah,al
        mov cl,4
        shr al,cl
        and ah,00001111b
        add ah,30h
        add al,30h

        mov [si],ax
        add si,3
        inc bx
        pop cx
        loop get_time

        mov si,offset date_time
        mov dh,13
        mov dl,30
        pop cx
        call show_str

clock_key:mov ah,1
        int 16h
        jz clock_s
        mov ah,0
        int 16h
        
        cmp al,20h
        jnb clock_s
        
        cmp ah,3bh
        je clock_color
        cmp ah,1
        je clock_back
        jmp clock_s

clock_back:jmp near ptr boot_s

clock_color:inc cl
        cmp cl,7
        jna clock_s
        mov cl,1
        
clock_s:push cx
        mov si,offset date_time
        mov bx,offset port_bit
        jmp clock_d
        

set_clock:call clear_screen
        mov ax,cs
        mov si,offset date_tip

        mov dh,12
        mov dl,8
        mov cl,7
        call show_str

clock_reinit:mov si,offset date_buf
        mov bx,0
        mov cx,18
init_clock:mov byte ptr [si+bx],0
        inc bx
        loop init_clock
        mov bx,0
clock_input:call disp_input
        mov ah,0
        int 16h
        cmp al,20h
        jb nonchar
        cmp bx,17
        jnb clock_input
        mov [si+bx],al
        inc bx
        jmp clock_input

disp_input:push ax
        push ds
        push cx
        push bx
        
        mov ax,0b800h
        mov ds,ax
        
        mov cx,80
        mov bx,13*80*2
        mov al,' '
        mov ah,7
        
 clear_line:mov [bx],ax
        add bx,2
        loop clear_line

        pop bx
        pop cx
        pop ds
        pop ax
        
        mov dh,13
        mov dl,30
        mov cl,7
        call show_str
        ret

nonchar:cmp ah,0eh
        je del_char
        cmp ah,1ch
        je input_ok
        cmp ah,1
        je back_menu
        jmp clock_input

back_menu:jmp near ptr boot_s

del_char:cmp bx,0
        je clock_input
        dec bx
        mov byte ptr [si+bx],0
        jmp clock_input
        
input_ok:cmp bx,17
        je set_check
input_error:call clear_screen
        mov si,offset date_error
        mov dh,12
        mov dl,25
        mov cl,7
        call show_str
        mov si,offset date_buf
        jmp clock_reinit
        
set_check:push bx
        mov cx,12
        mov bx,0
        
check_digit:push si
        push bx
        add si,date_idx[bx]
        mov al,[si]
        mov bl,'0'
        mov bh,'9'
        call range_check
        cmp al,0
        je d_range_error
        pop bx
        add bx,2
        pop si
        loop check_digit
        jmp check_s

d_range_error:pop si
        push si
        mov si,offset digit_err
        call show_error
        pop si
        
        jmp check_error

check_s:mov cx,5
        mov bx,0
        mov di,offset date_time
check_split:push si
        push di
        add si,split_idx[bx]
        add di,split_idx[bx]
        mov al,[si]
        cmp al,[di]
        jne split_error
        add bx,2
        pop di
        pop si
        loop check_split
        jmp check_over

split_error:pop di
        pop si
        
        push si
        mov si,offset split_err
        call show_error
        pop si

        jmp check_error
        
range_check:cmp al,bl
        jb range_error
        cmp al,bh
        ja range_error
        mov al,1
        jmp range_ok
range_error:mov al,0
range_ok:ret

check_error:pop bx
        jmp input_error

check_over:mov cx,6
        mov bx,0
        mov di,si
        mov bp,0
        
calc_digit:add si,date_idx[bx]
        mov al,[si]
        sub al,30h
        mov dl,10
        mul dl
        mov ah,al
        
        mov al,[si+1]
        sub al,30h
        add ah,al
        
        mov date_digit[bp],ah 
        inc bp
        add bx,4
        mov si,di
        loop calc_digit

        mov bx,0
        mov bl,date_digit[1]
        cmp bl,1
        jb  over_error
        cmp bl,12
        ja over_error

        mov cl,date_digit[2]
        cmp cl,1
        jb over_error
        cmp cl,month_day[bx]
        ja over_error

        cmp bl,0
        je run_year
        and bl,00000011b
        cmp bl,0
        je run_year
        jmp hour_check

run_year:cmp cl,28
        ja over_error
        
hour_check:mov bl,date_digit[3]
        cmp bl,0
        jb over_error
        cmp bl,23
        ja over_error

        mov bl,date_digit[4]
        cmp bl,0
        jb over_error
        cmp bl,59
        ja over_error

        mov bl,date_digit[5]
        cmp bl,0
        jb over_error
        cmp bl,59
        ja over_error
        jmp clock_bcd
        
over_error:pop bx

        push si
        mov si,offset calc_err
        call show_error
        pop si

        jmp input_error
        
clock_bcd:mov cx,6
        mov bx,0
calc_bcd:push cx
        mov al,date_digit[bx]
        mov ah,0
        mov dl,10
        div dl
        mov cl,4
        shl al,cl
        or  al,00001111b
        or  ah,11110000b
        and al,ah
        mov date_digit[bx],al
        inc bx
        pop cx
        loop calc_bcd

        mov cx,6
        mov bx,0
        mov si,0
set_date:mov al,port_bit[si]
        out 70h,al
        mov al,date_digit[bx]
        out 71h,al
        inc si
        inc bx
        loop set_date
        
        jmp near ptr boot_s


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
        
show_error:push dx
        push cx
        push ds
        push ax
        
        mov dh,5
        mov dl,5
        mov cl,7
        mov ax,cs
        mov ds,ax
        call show_str
        mov al,0
        int 16h
        pop ax
        pop ds
        pop cx
        pop dx
        ret
        
boot_end:nop

codesg ends

end start
