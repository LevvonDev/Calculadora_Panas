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

    CMP CL,'+'  ;compara oo operando com o sinal de adicao
    JE SOMA
    CMP CL,'-'  ;compara o operando com o sinal de subtracao
    JE MENOS
    CMP CL,'*'  ;compara o operando com o sinal de multiplicacao
    JE MULT
MULT:
    JMP MULTI


SOMA:
    ADD BL,BH   ;soma os operandos
    MOV DL,BL   
    CMP DL,0AH  ;compara o resultado para ver se e maior que 10 ou nao
    JAE NM10    

    PUSH DX 
    MOV AH,02
    MOV DL,10   ;imprime um 'pula linha'
    INT 21H

    MOV AH,09H
    LEA DX, msg5    ;imprime a mensagem 5
    INT 21H

    POP DX
    OR DL,30H   ;transforma o resultado de numero pra caracter

    MOV AH,02H
    INT 21H     ;imprime o resultado
    JMP FIM     ;pula para o fim do programa

NM10:    
    PUSH DX
    MOV AH,02
    MOV DL,10   ;pula uma linha
    INT 21H

    MOV AH,09H
    LEA DX, msg5    ;imprime a mensagem 5
    INT 21H

    POP DX
    MOV BL,DL   
    XOR AX,AX   ;zera o ax
    MOV AL,BL   ;move o resultado para al
    MOV CH,10       ;move 10 para ch
    DIV CH        ;divide o numero por 10
    MOV DX,AX   ;move os dois digitos do resultado para dx
    OR DL,30H   ;transforma o numero em caracter
    MOV AH,02H  ;imprime o primeiro digito
    INT 21H

    MOV DL,DH
    OR DL,30H   ;transforma o resultado de numero para caracter
    MOV AH,02   ;imprime o segundo digito
    INT 21H
    JMP FIM
MENOS:

    SUB BL,BH     ;subtrai os operandos
    JS  NNEG      ;verifica se o numero e

    MOV AH,02   
    MOV DL,10       ;imprime um pula linha
    INT 21H

    MOV AH,09
    LEA DX, msg5    ;imprime a mensagem 5
    INT 21H

    OR BL,30H     ;transforma o resultado de numero para caracter

    MOV AH,02
    MOV DL,BL       ;imprime um 'pula linha'
    INT 21H
    JMP FIM

NNEG:

    MOV AH,02
    MOV DL,10   ;imprime um 'pula linha'
    INT 21H

    MOV AH,09
    LEA DX,msg5 ;imprime a mensagem 5
    INT 21h

    MOV AH,02
    MOV DL,'-'  ;imprime um sinal de menos
    INT 21H
    
    NEG BL      
    OR BL,30H   ;transforma de numero para caracter
    MOV DL,BL   
    MOV AH,02
    MOV DL,BL   
    INT 21H     ;imprime o resultado
    JMP FIM

MULTI:
    MOV CX,8    ;inicia cx como 8
    XOR DX,DX   ;zera dx
TOPO:
    TEST BH,1   
    JZ PT1
    ADD DH,BL   
PT1:
    SHR DX,1    ;desloca dx para a direita
    SHR BH,1    ;desloca bh para a direita
    LOOP TOPO   

    CMP DL,0AH  ;compara se o resultado e maior que 10
    JAE SALTA
    JL  CONTINUA
SALTA:
    JMP NM10
CONTINUA:
    PUSH DX 
    MOV DL,10   
    MOV AH,02
    INT 21H     ;imprime um pula linha

    MOV AH,09   
    LEA DX, msg5    ;imprime a mensagem 5
    INT 21H

    POP DX
    OR DL,30H      ;transforma de numero para caracter
    MOV AH,02       ;imprime o resultado
    INT 21H
    JMP FIM

    




    













FIM:
    MOV AH,4CH  ;finaliza o programa
    INT 21H
    MAIN ENDP
END MAIN
