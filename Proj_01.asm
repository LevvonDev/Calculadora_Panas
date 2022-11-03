TITLE Leonardo Caberlim de Souza RA(22017958) Daniel Scanavini Rossi RA(22000787)
.MODEL SMALL
.STACK 100H
.DATA

    msg1 DB 'CALCULADORA EM ASSEMBLY',10,'$'
    msg2 DB 'Por Favor, insira o primeiro numero',10,'$'
    msg3 DB 'Por Favor, insira a operacao a ser realizada',10,'$'
    msg4 DB 'Por Favor, insira o segundo numero',10,'$'
    msg5 DB 'Resultado: ',10,'$'
    msg6 DB 'Divisao por zero, invalido, finalizando programa...',10,'$'
    MSG7 DB 'resto da divisao:',10,'$'


.CODE
    MAIN PROC
    MOV AX,@DATA
    MOV DS, AX
    MOV AH,09
    LEA dx,msg1
    int 21h        ;inicia o segmento de dados e imprime a mensagem de boas vindas

    MOV AH,09
    LEA dx,msg2
    int 21h        ;imprime a mensagem para que o usuario  insira o primeiro operando

    MOV AH,01
    INT 21H        ;registra o operando e o move para bl
    MOV BL,AL
    
    MOV AH,02
    MOV DL,10
    INT 21H        ;imprime um 'pula linha'

    MOV AH,09
    LEA DX, msg3
    INT 21H        ;imprime a mensagem para que o usuario insira o operador

    MOV AH,01
    INT 21H        ;registra o operador e o move para cl
    MOV CL,AL

    MOV AH,02
    MOV DL,10
    INT 21H        ;imprime um 'pula linha'

    MOV AH,09
    LEA DX, msg4
    INT 21H        ;imprime a menasgem para que o usuario insira o segundo operando


    MOV AH,01
    INT 21H     ;registra o segundo operador e o armazena em bh
    MOV BH,AL


    AND BL,0FH
    AND BH,0FH

    CMP CL,'+'  ;compara oo operando com o sinal de adicao
    JE SOMA
    CMP CL,'-'  ;compara o operando com o sinal de subtracao
    JE MENOS
    CMP CL,'*'  ;compara o operando com o sinal de multiplicacao
    JE MULT
    CMP CL,'/'  ;compara o operando com o sinal de divisao
    JE DIVIS
DIVIS:
    JMP DIVI
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
    XOR DX,DX
    XOR AX,AX 
    MOV AL,BL
TOPO:
    TEST BH,1     ;testa se o primeiro operando e impar  
    JZ OP	
    ADD DX,AX   
OP:
    SHL AX,1    ;desloca dx para a direita
    SHR BH,1    ;desloca bh para a direita
    LOOP TOPO   

    CMP DL,0AH  ;compara se o resultado e maior que 10
    JAE PULA
    JL  CONTINUA
PULA:
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

DIVI:         ;divisor bh, dividendo bl->ax, quociente dx
    MOV CX,9
    XOR AH,AH
    MOV AL,BL ;dividendo ->ax
    CMP BH,0H
    JZ ZERO   ;testa se o divisor e zero
    XOR BL,BL
    XOR DL,DL
DIVISAO:
    SUB AX,BX   
    JNS SALTA   ;se positivo bit 1 no quociente, caso contrario bit 0 no quociente
    ADD AX,BX
    MOV DH,0
    JMP SALTA1
SALTA:
    MOV DH,1

SALTA1:
    SHL DL,1    ;rotaciona o quociente
    OR DL,DH    
    SHR BX,1    ;rotaciona o duvisor
    LOOP DIVISAO
    
    MOV CH,DL
    MOV CL,AL

    MOV DL,10   
    MOV AH,02   
    INT 21H     ;imprime um 'pula linha'

    MOV AH,09
    LEA DX,MSG5
    INT 21H

    
    MOV DL,CH
    OR DL,30H   ;converte o resultado para caracter
    MOV AH,02
    INT 21H

    MOV DL,10   
    MOV AH,02
    INT 21H     ;imprime um pula linha

    MOV AH,09
    LEA DX,MSG7
    INT 21h     ;imprime a mensagem de resto

    MOV DL,CL
    OR DL,30H   ;converte o resultado em caracter
    MOV AH,02   
    INT 21H
    JMP FIM ;finaliza o programa

ZERO:
    MOV DL,10   
    MOV AH,02   ;imprime um 'pula linha'
    INT 21H

    MOV AH,09
    LEA DX, msg6 ;imprime a mensagem informando que dividir por zero e impossivel
    INT 21H     
    JMP FIM     ;finaliza o programa
    
FIM:
    MOV AH,4CH  ;finaliza o programa
    INT 21H
    MAIN ENDP
END MAIN
