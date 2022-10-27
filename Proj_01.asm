TITLE Leonardo Caberlim de Souza RA(22017958) Daniel Scanavini Rossi RA(22000787)
.model SMALL
.STACK 100H
.DATA

    msg1 DB 'CALCULADORA EM ASSEMBLY',10,'$'
    msg2 DB 'Por Favor, insira o primeiro numero',10,'$'
    msg3 DB 'Por Favor, insira a operacao a ser realizada',10,'$'
    msg4 DB 'Por Favor, insira o segundo numero',10,'$'
    msg5 DB 'Resultado: ',10,'$'

.CODE
    MAIN PROC
    MOV AX,@DATA
    MOV DS, AX
    MOV AH,09
    LEA dx,msg1
    int 21h        ;ESTE BLOCO INICIA O SEGMENTO DE DADOS EM DS E IMPRIME A MENSAGEM DE BOAS VINDAS

    MOV AH,09
    LEA dx,msg2
    int 21h        ;ESTE BLOCO IMPRIME A MENSAGEM PARA O USUARIO INSERIR O PRIMEIRO OPERANDO

    MOV AH,01
    INT 21H        ;ESTE BLOCO REGISTRA O PRIMEIRO OPERANDO E O ARMAZENA EM BL
    
    MOV BL,AL
    
    MOV AH,02
    MOV DL,10
    INT 21H        ;ESTE BLOCO IMPRIME UM PULA LINHA

    MOV AH,09
    LEA DX, msg3
    INT 21H        ;ESTE BLOCO IMPRIME A MENSAGEM PEDINDO O OPERADOR

    MOV AH,01
    INT 21H        ;ESTE BLOCO REGISTRA O OPERADOR E O ARMAZENA EM CL
    
    MOV CL,AL

    MOV AH,02
    MOV DL,10
    INT 21H        ;ESTE BLOCO  IMPRIME UM PULA LINHA

    MOV AH,09
    LEA DX, msg4
    INT 21H        ;ESTE BLOCO IMPRIME A MENSAGEM PARA O USUARIO INSERIR O SEGUNDO OPERANDO


    MOV AH,01
    INT 21H     ;ESTE BLOCO  REGISTRA O SEGUNDO OPERADOR E O ARMAZENA EM BH
    MOV BH,AL


    AND BL,0FH
    AND BH,0FH

    CMP CL,'+'
    JE SOMA
    CMP CL,'-'
    JE MENOS
    CMP CL,'*'
    JE MULT
    MULT:
        jmp MULTI

SOMA:
    ADD BL,BH
    CMP BL,0AH
    JA NM10

    
    MOV AH,02
    MOV DL,10
    INT 21H

    MOV AH,09H
    LEA DX, msg5
    INT 21H

    OR BL,30H

    MOV AH,02H
    MOV DL,BL
    INT 21H
    JMP FIM

NM10:    

    MOV AH,02
    MOV DL,10
    INT 21H

    MOV AH,09H
    LEA DX, msg5
    INT 21H

    
    XOR AX,AX
    MOV AL,BL
    MOV CH,10
    DIV CH
    MOV DX,AX
    OR DL,30H
    MOV AH,02H
    INT 21H

    MOV DL,DH
    OR DL,30H
    MOV AH,02
    INT 21H

MENOS:

    SUB BL,BH
    JS  NNEG

    MOV AH,02
    MOV DL,10
    INT 21H

    MOV AH,09
    LEA DX, msg5
    INT 21H

    OR BL,30H

    MOV AH,02
    MOV DL,BL
    INT 21H
    JMP FIM

NNEG:

    MOV AH,02
    MOV DL,10
    INT 21H

    MOV AH,09
    LEA DX,msg5
    INT 21h

    MOV AH,02
    MOV DL,'-'
    INT 21H
    
    NEG BL
    OR BL,30H
    MOV DL,BL
    MOV AH,02
    MOV DL,BL
    INT 21H

MULTI:
    MOV CX,8
    XOR DX,DX
TOPO:
    TEST BH,1
    JZ PT1
    ADD DH,BL
PT1:
    SHR DX,1
    SHR BH,1
    LOOP TOPO

    PUSH DX
    MOV DL,10
    MOV AH,02
    INT 21H

    MOV AH,09
    LEA DX, msg5
    INT 21H

    POP DX
    OR DL,30H
    MOV AH,02
    INT 21H
    JMP FIM

    




    













FIM:
    MOV AH,4CH
    INT 21H
    MAIN ENDP
END MAIN
