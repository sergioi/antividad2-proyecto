   ;actividad 2-proyecto-
   ; lenguajes y automatas.
   ;6to   "b"
   ;ingenieria en sistemas computacionales
   ;integrantes:
   
   ;Sergio Coatl Perez.
   ;Guadalupe de Jesus May Kauil
   
   
   
    PANTALLA MACRO COLOR, INI, FIN
    MOV AH,06H
    MOV AL,0
    MOV BH,COLOR
    MOV CX,INI
    MOV DX,FIN
    INT 10H    
PANTALLA ENDM 
   
 org 100h
 .model small
.stack 64

.data
    msj1 db 'Presione enter para continuar...$'
    msj2 db 'Digite Numero 1: $'
    msj3 db 'Digite Numero 2: $'
    msj4 db 10,13,'El resultado de la operacion es: ','$',10,13
    res db ' ','$'
    var db 36
    
    datos label byte
    maxlon db 3
    actlon db ?
    opc db 3 dup(' ')
    
    datos1 label byte
    maxlon1 db 3
    actlon1 db ?
    numero1 db 3 dup(' ')
    
    datos2 label byte
    maxlon2 db 3
    actlon2 db ?
    numero2 db 3 dup(' ')
    enter2 db 10,13, 'Enter para volver al incio->$'
     
    menuopc db ' CALCULADORA ',0DH, 0ah
            db '1-SUMA. ',0DH, 0AH
            db '2-RESTA. ',0DH, 0AH
            db '3-MULTIPLICACION. ',0DH, 0AH
            db '4-DIVISION. ',0DH, 0AH
            db '5-SALIR. ',0DH, 0AH
            db 'seleccione una opcion: ',0DH, 0AH,'$'

.code 
  start: ;funcion para desplegar el menu
   
   PANTALLA 37H, 0000, 185FH
    
    

inicio proc far
    mov ax,@data
    mov ds,ax
    mov es,ax

volver:
    mov msj4[37],' '
    mov msj4[36],' '
    mov msj4[33],' '
    mov res[0],' '
    call borrar
    mov dx,0000h
    call cursor
    call menu
    call entrada
    cmp opc,49
    je sumar
    cmp opc,50
    je restar
    cmp opc,51
    je multiplicar
    cmp opc,52
    je dividir
    cmp opc,53
    je salir
    jmp volver

;--------------------------------------
;PARA LA SUMA
sumar:
    mov dx,0700h
    call cursor
    call num1
    call entrada_num1
    cmp actlon1,2
    je dos_digitos1
    mov bl,numero1
    sub bl,30h
c1:
    mov dx,0800h
    call cursor
    call num2
    call entrada_num2
    cmp actlon2,2
    je dos_digitos2
    mov cl,numero2
    sub cl,30h
c2:
    add bl,cl
    mov dx,0900h
    call cursor
    cmp bl,100
    jb llamar1
    cmp bl,200
    jb llamar2
llamada_volver:
    call pausa
    cmp al,27; ascii de ESC
    je menu

;--------------------------------------
;PARA LA RESTA
restar:
    mov dx,0700h
    call cursor
    call num1
    call entrada_num1
    cmp actlon1,2
    je dos_digitos1
    mov bl,numero1
    sub bl,30h
c3:
    mov dx,0800h
    call cursor
    call num2
    call entrada_num2
    cmp actlon2,2
    je dos_digitos2
    mov cl,numero2
    sub cl,30h
c4:
    cmp bl,cl
    jb cambio
continuar_resta:
    sub bl,cl
    mov dx,0900h
    call cursor
    call mostrar3
    call pausa


;-----------------------------------------
;PARA LA MULTIPLICACION    (aqui pegas  y borras todo del parentesis)
multiplicar:
  
  

;-----------------------------------------
;PARA LA DIVISION (aqui pegas dividir y borras todo del parentesis)
dividir:
   
   
   
   
;CUANDO EXISTAN DECIMALES
decimales:
        mov var,36
        mov cl,bh
        mov dh,09h
        mov dl,var
        call cursor
        mov ah,09
        mov res[0],'.'
        lea dx,res
        int 21h
        mov bh,cl
mas:
    mov bl,ch
    mov ch,bh
    mov ax,0000
hacer:
    add al,10
    dec ch
    cmp ch,0
    jne hacer
    div bl
    mov ch,bl
    mov bx,ax
    inc var
    mov cl,bh
    mov dh,09h
    mov dl,var
    call cursor
    add bl,30h
    mov res[0],bl
    mov ah,09h
    lea dx,res
    int 21h
    mov bh,cl
    cmp bh,0
    jne mas
    jmp sin_decimales


;CUANDO LA RESTA ES NEGATIVA
cambio:
    mov al,bl
    mov bl,cl
    mov cl,al
    mov msj4[33],'-'
    jmp continuar_resta

;CUANDO SE ENTREN NUMEROS DE 2 DIGITOS
dos_digitos1:
    mov cl,numero1[0]
    sub cl,30h
    mov ax,0000
etiq1:
    add al,10
    dec cl
    cmp cl,0
    jne etiq1
    mov bx,0000
    mov bl,al
    mov cl,numero1[1]
    sub cl,30h
    add bl,cl
    cmp opc,49
    je c1
    cmp opc,50
    je c3
    cmp opc,51
    je c5
    cmp opc,52
    je c7

dos_digitos2:
    mov cl,numero2[0]
    sub cl,30h
    mov ax,0000
etiq2:
    add al,10
    dec cl
    cmp cl,0
    jne etiq2
    mov cx,0000
    mov cl,al
    mov al,numero2[1]
    sub al,30h
    add cl,al
    cmp opc,49
    je c2
    cmp opc,50
    je c4
    cmp opc,51
    je c6
    cmp opc,52
    je c8

;----------------------------------------
llamar1:
    call mostrar3
    cmp opc,49
    je llamada_volver
    cmp opc,51
    je llamada_volver2
    
;----------------------------------------
llamar2:
    call mostrar1
    cmp opc,49
    je llamada_volver
    cmp opc,51
    je llamada_volver2

;----------------------------------------
llamar3:
    call mostrar2
    jmp llamada_volver2
    
;----------------------------------------
llamar4:
    call mostrar4
    jmp llamada_volver2

ir_menu:
        mov ah,1 ;pedimos un enter para regresar con el servicio 1
        int 21h ;de la in terrupcion 21h
        
        cmp al,0Dh ;comparamos lo que metimos con 0dh (enter)
        jb ir_menu ;si es menor volvemos a ir_menu y pedimos de nuevo un enter
        ja ir_menu ;si es mayor volvemos a ir_menu y pedimos de nuevo un enter
        
        
        call limpiar ;llamamos a limpiar
        jmp start;luego saltamos a la etiquta start
salir:
    mov ax,4c00h
    int 21h
    inicio endp

menu proc near
    mov ah,09h
    mov bh,01
    mov cx,174d
    lea dx,menuopc
    int 21h
    ret
menu endp

borrar proc near
    mov ax,0600h
    mov bh,70h
    mov cx,0000
    mov dx,184fh
    int 10h
    ret
borrar endp

cursor proc near
    mov ah,02h
    mov bh,00h
    int 10h
    ret
cursor endp

num1 proc near
    mov ah,09h
    lea dx,msj2
    int 21h
    ret
num1 endp

num2 proc near
    mov ah,09h
    lea dx,msj3
    int 21h
    ret
num2 endp

mostrar1 proc near
    mov ah,00h
    mov al,bl
    mov cl,0ah
    div cl
    add ah,30h
    mov msj4[36],ah
    mov ah,00h
    div cl
    add ah,30h
    mov msj4[35],ah
    mov ah,09h
    add al,30h
    mov msj4[34],al
    lea dx,msj4
    int 21h
    ret
mostrar1 endp

mostrar2 proc near
    mov ax,bx
    mov cl,0ah
    div cl
    add ah,30h
    mov msj4[36],ah
    mov ah,00h
    div cl
    add ah,30h
    mov msj4[35],ah
    mov ah,09h
    add al,30h
    mov msj4[34],al
    lea dx,msj4
    int 21h
    ret
mostrar2 endp
;------------------------------
;aqui pegas lo demas 


;___________________________________
entrada proc near
    mov ah,0ah
    lea dx,datos
    int 21h
    ret
entrada endp

entrada_num1 proc near
    mov ah,0ah
    lea dx,datos1
    int 21h
    ret
entrada_num1 endp

entrada_num2 proc near
    mov ah,0ah
    lea dx,datos2
    int 21h
    ret 

limpiar:
        mov ah,00h ;usamos el servico 00h de la interrupcion 10h
        mov al,03h ;para limpiar la pantalla
        int 10h
        
        ret

entrada_num2 endp

 
pausa proc near
MOV AH, 9               ; SERVICIO DE IMPRESION
        LEA DX, enter2              ; OBTIENE LA DIRECCION DE M1
        INT 21H
call ir_menu

jmp inicio
pausa endp


end 