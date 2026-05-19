###########################################################################
# Upper bound constants for static memory reservation
###########################################################################
.equ CONST_DIMENSION 4
.equ CONST_BUFFER_SIZE 1024
.equ CONST_MAX_VOCAB_TOKENS 100
.equ CONST_MAX_INPUT_TOKENS 10

###########################################################################
# System call constants
###########################################################################
.equ CONST_SYSCALL_PRINT_INT 1
.equ CONST_SYSCALL_PRINT_STRING 4
.equ CONST_SYSCALL_PRINT_CHAR 11
.equ CONST_SYSCALL_EXIT 10
.equ CONST_SYSCALL_EXIT2 93
.equ CONST_SYSCALL_OPEN 1024
.equ CONST_SYSCALL_CLOSE 57
.equ CONST_SYSCALL_READ 63
.equ CONST_SYSCALL_WRITE 64

###########################################################################
# ASCII character constants
###########################################################################
.equ CONST_CHAR_EOF 0
.equ CONST_CHAR_SPACE 32
.equ CONST_CHAR_NEWLINE 10
.equ CONST_CHAR_HYPHEN 45
.equ CONST_CHAR_ZERO 48

.data
###########################################################################
# Data section with static memory reservations.
# Feel free to add more if needed.
###########################################################################
VOCABULARY_FILENAME:     .string "vocab.txt"
EMBEDDINGS_FILENAME:     .string "embeddings.txt"
INPUT_FILENAME:          .string "input.txt"

W_Q_FILENAME:            .string "W_Q.txt"
W_K_FILENAME:            .string "W_K.txt"
W_V_FILENAME:            .string "W_V.txt"

VOCAB_BUFFER:            .zero CONST_BUFFER_SIZE                              # Contents of the vocabulary file
INPUT_BUFFER:            .zero CONST_BUFFER_SIZE                              # Contents of the input file
MATRIX_BUFFER:           .zero CONST_BUFFER_SIZE                              # Contents of a matrix file (used for W_Q, W_K, W_V, and embeddings)

INPUT_INDICES_VECTOR:    .zero (CONST_MAX_INPUT_TOKENS * 4)                   # Vector of input token indices (#inputs x 4 bytes)
SCORES_VECTOR:           .zero (CONST_MAX_INPUT_TOKENS * 4)                   # Vector of scores (#tokens x 4 bytes)

INPUT_TOTAL_TOKENS:      .word 0                                              # Number of tokens in the input
VOCAB_TOTAL_TOKENS:      .word 0                                              # Number of tokens in the vocabulary

VOCAB_EMBEDDINGS_MATRIX: .zero (CONST_MAX_VOCAB_TOKENS * CONST_DIMENSION * 4) # Embedding matrix (#tokens x dimension x 4 bytes)
INPUT_EMBEDDINGS_MATRIX: .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # Embedding matrix (#tokens x dimension x 4 bytes)
W_Q_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_Q matrix (dimension x dimension x 4 bytes)
W_K_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_K matrix (dimension x dimension x 4 bytes)
W_V_MATRIX:              .zero (CONST_DIMENSION * CONST_DIMENSION * 4)        # W_V matrix (dimension x dimension x 4 bytes)
Q_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # Q matrix (#tokens x dimension x 4 bytes)
K_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # K matrix (#tokens x dimension x 4 bytes)
V_MATRIX:                .zero (CONST_MAX_INPUT_TOKENS * CONST_DIMENSION * 4) # V matrix (#tokens x dimension x 4 bytes)

.text
main:
    ###########################################################################
    # Read vocabulary
    ###########################################################################
    # TODO
    la a0, VOCABULARY_FILENAME
    la a1, VOCAB_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file
    ###########################################################################
    # Read input
    ###########################################################################
    # TODO
    la a0, INPUT_FILENAME
    la a1, INPUT_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file
    ###########################################################################
    # Read W_Q matrix
    ###########################################################################
    # TODO
    la a0, W_Q_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file
    ###########################################################################
    # Parse W_Q matrix from buffer
    ###########################################################################
    # TODO
    la a0, W_Q_MATRIX
    jal ra, parse_matrix_buffer
    ###########################################################################
    # Read W_K matrix
    ###########################################################################
    # TODO
    la a0, W_K_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file
    ###########################################################################
    # Parse W_K matrix from buffer
    ###########################################################################
    # TODO
    la a0, W_K_MATRIX
    jal ra, parse_matrix_buffer
    ###########################################################################
    # Read W_V matrix
    ###########################################################################
    # TODO
    la a0, W_V_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file
    ###########################################################################
    # Parse W_V matrix from buffer
    ###########################################################################
    # TODO
    la a0, W_V_MATRIX
    jal ra, parse_matrix_buffer
    ###########################################################################
    # Read embeddings matrix
    ###########################################################################
    # TODO
    la a0, EMBEDDINGS_FILENAME
    la a1, MATRIX_BUFFER
    li a2, CONST_BUFFER_SIZE
    jal ra, read_file
    ###########################################################################
    # Parse vocabulary embeddings matrix from buffer
    ###########################################################################
    # TODO
    la a0, VOCAB_EMBEDDINGS_MATRIX
    jal ra, parse_matrix_buffer
    la a0, VOCAB_TOTAL_TOKENS
    sw a1, 0(a0)                #guarda total de tokens do vocab
    ###########################################################################
    # Convert input tokens to indices
    ###########################################################################
    # TODO
    la a0, INPUT_INDICES_VECTOR
    la a2, INPUT_BUFFER
    la a3, VOCAB_BUFFER
    jal ra, tokens_to_indices
    la a0, INPUT_TOTAL_TOKENS
    sw a1, 0(a0)                #guarda o num de tokens do input

    ###########################################################################
    # Build input embeddings matrix
    ###########################################################################
    # TODO
    la a0, INPUT_EMBEDDINGS_MATRIX
    la a1, VOCAB_EMBEDDINGS_MATRIX
    la a2, INPUT_INDICES_VECTOR
    la t3, INPUT_TOTAL_TOKENS
    lw a3, 0(t3)
    jal ra, build_input_embeddings_matrix
    ###########################################################################
    # Build matrix Q
    ###########################################################################
    # TODO
    la a0, Q_MATRIX
    la a1, INPUT_EMBEDDINGS_MATRIX
    la a2, INPUT_TOTAL_TOKENS
    li a3, CONST_DIMENSION 
    la a4, W_Q_MATRIX
    la a2, CONST_DIMENSION
    li a3, CONST_DIMENSION
    jal ra, matrix_multiply
    ###########################################################################
    # Build matrix K
    ###########################################################################
    # TODO
    la a0, K_MATRIX
    la a1, INPUT_EMBEDDINGS_MATRIX
    la a2, INPUT_TOTAL_TOKENS
    li a3, CONST_DIMENSION 
    la a4, W_K_MATRIX
    la a2, CONST_DIMENSION
    li a3, CONST_DIMENSION
    jal ra, matrix_multiply
    ###########################################################################
    # Build matrix V
    ###########################################################################
    # TODO
    la a0, V_MATRIX
    la a1, INPUT_EMBEDDINGS_MATRIX
    la a2, INPUT_TOTAL_TOKENS
    li a3, CONST_DIMENSION 
    la a4, W_V_MATRIX
    la a2, CONST_DIMENSION
    li a3, CONST_DIMENSION
    jal ra, matrix_multiply
    ###########################################################################
    # Compute scores for the last input token
    ###########################################################################
    # TODO

    ###########################################################################
    # Get the highest score index using argmax
    ###########################################################################
    # TODO
    mv a1, a0                       #output to compute scores para a1 (prep para argmax) 
    la t2, INPUT_TOTAL_TOKENS       #len do arr equivale ao num de palavras
    lw a2, 0(t2)
    jal ra, argmax
    ###########################################################################
    # Select chosen vector in V using the index from argmax
    ###########################################################################
    # TODO
    mv a4, a1                       #output to argmax para a4 (prep do select)
    la a1, V_MATRIX
    la t2, INPUT_TOTAL_TOKENS
    lw a2, 0(t2)
    li a3, CONST_DIMENSION
    jal ra, select_vector_in_matrix
    ###########################################################################
    # Pick the next token in the vocabulary with the highest score
    ###########################################################################
    # TODO
    # a0 já tem o target vector da função anterior
    la a1, VOCAB_EMBEDDINGS_MATRIX
    la t2, VOCAB_TOTAL_TOKENS
    lw a2, 0(t2)
    jal ra, decide_next_token
    ###########################################################################
    # Terminate program successfully
    ###########################################################################
    li a0, 0
    j exit_with_code                                # Exit with code 0

# Read from a text file into a buffer.
# (in)     a0: filename address (char*)
# (in/out) a1: destination buffer
# (in)     a2: maximum number of bytes to read
read_file:
    # TODO
    # guardar ra e registos na pilha
    addi sp, sp, -20
    sw ra, 0(sp)
    sw t0, 4(sp)
    sw t1, 8(sp)
    sw t2, 12(sp)
    sw t3, 16(sp)
    
    # guardar os argumentos iniciais
    mv t0, a0    
    mv t1, a1     
    mv t2, a2     
    
    # não é necessário validar o tamanho, pois os ficheiros ja sao sempre bem formados
    
    # abrir ficheiro
    mv a0, t0    # Passa o endereço do nome do ficheiro para a0
    li a1, 0     # Flag = 0 (Apenas Leitura)
    li a2, 0
    li a7, CONST_SYSCALL_OPEN
    ecall
    mv t3, a0        
    
    # ler ficheiro
    mv a0, t3    
    mv a1, t1 
    mv a2, t2 
    li a7, CONST_SYSCALL_READ 
    ecall    # após o ecall, a0 contém o número de bytes lidos
    
    # fechar o ficheiro
    mv a0, t3        
    li a7, CONST_SYSCALL_CLOSE
    ecall
    
    # restaurar a pilha, libertando o ra e os registos
    lw ra, 0(sp)
    lw t0, 4(sp)
    lw t1, 8(sp)
    lw t2, 12(sp)
    lw t3, 16(sp)
    addi sp, sp, 20
    
    # retornar
    ret

# Assumes the matrix is stored in the buffer as space-separated integers.
# Assumes columns are separated by 1 space (' '), and rows by 1 newline ('\n').
# Assumes only signed integers are provided.
# (in/out) a0: address of the matrix to fill (int*)
# (out)    a1: number of rows in the matrix (int)
# (in)     a1: address of the buffer containing the matrix data (char*)
parse_matrix_buffer:
    # TODO
        addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)    # ponteiro para matriz original (a1)
    sw s1, 8(sp)    # ponteiro para matriz array (a0)
    sw s2, 12(sp)    # contador de linhas
    sw s3, 16(sp)    # flag para sinal do número (0 é positivo e 1 é negativo)
    sw s4, 20(sp)    # número atualmente em análise   

    mv s0, a1        
    mv s1, a0     
    li s2, 0         
    li s3, 0 
    li s4, 0

loop:
    lb t0, 0(s0)    # byte atual, em análise
    
    # casos em que byte não é dígito:
    beq t0, x0, fim    # em caso de EOF (t0 = 0), termina
    
    li t1, CONST_CHAR_NEWLINE
    beq t0, t1, prox_linha     # em caso de '\n' 
    
    li t2, CONST_CHAR_HYPHEN
    beq t0, t2, negativo    # em caso de sinal negativo
    
    li t3, CONST_CHAR_SPACE
    beq t0, t3, usa_flag        # em caso de espaço
    
    # se byte é dígito: n = n * 10 -48 bytes(representa o 0 na tabela ASCII)
    li t4, CONST_CHAR_ZERO 
    sub t0, t0, t4
    li t5, 10
    mul s4, s4, t5
    add s4, s4, t0
    addi s0, s0, 1    # incrementa o ponteiro
    j loop
 
negativo:
    addi s3, s3, 1    # alteramos a flag para representar um negativo
    addi s0, s0, 1    # incrementa o ponteiro
    j loop
    
prox_linha:
    addi s2, s2, 1    # adicionamos 1 ao contador de linhas
    
usa_flag:
    beq s3, x0, guarda_RAM
    sub s4, x0, s4

guarda_RAM:
    sw s4, 0(s1)
    li s3, 0
    li s4, 0    # resetar o número
    addi s0, s0, 1    # avança um no buffer 
    addi s1, s1, 4    # avança 4 bytes na matriz
    j loop

fim:
    mv a1, s2
    
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    # retonar
    ret

# Converts the input tokens into their corresponding indices in the vocabulary.
# (in/out) a0: address of input indices vector to fill (int*)
# (out)    a1: size of input indices vector (number of tokens in input)
# (in)     a2: address to input buffer
# (in)     a3: address to vocabulary buffer
tokens_to_indices:
    # TODO
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)    # ponteiro para a palavra
    sw s1, 8(sp)    # ponteiro para o vetor a preencher
    sw s2, 12(sp)    # contador de palavras
    sw s3, 16(sp)    # indice do vocabulário
    sw s4, 20(sp)    # ponteiro para o início do vocabulário
    
    mv s0, a2    
    mv s1, a0    
    li s2, 0      
    mv s4, a3 
    
    
loop: # percorre as palavras uma a uma
    lb   t0, 0(s0)    # lê primeiro byte da palavra
    beq  t0, x0, fim    # em caso de EOF (t0 = 0), termina
    
    li s3, 0    # índice atual inicializado
    mv t1, s4


vocabulario: # percorre palvra a palavra do vocabulário
    mv t2, s0
    mv t3, t1


comparacao:
    # carrega os caracteres atuais
    li t4, CONST_CHAR_NEWLINE
    lb t5, 0(t2)
    lb t6, 0(t3)
    
    bne t5, t6, diferentes    # caracteres diferentes
    # caracteres iguais
    beq t5, t4, iguais    # são os dois /n
    # se não são os dois /n
    # avançamos na comparação 
    addi t2, t2, 1
    addi t3, t3, 1
    j comparacao
    
    
iguais:
    sw s3, 0(s1)    # guarda o índice
    addi s1, s1, 4    # avança para a próximo indice vazio do vetor retorno
    addi s2, s2, 1    # incrementa o numero de palavras
    
    addi s0, t2, 1    #avança para a próxima palavra
    j loop
    
    
diferentes:
    lb t6, 0(t3)            # lê o caracter do vocabulário
    addi t1, t1, 1          # avança o ponteiro principal em 1 byte
    
    # procura o fim da palavra atual
    beq t6, t4, avanca_voc    # se for '\n', atualiza o índice
    j diferentes


avanca_voc:
    addi s3, s3, 1    # incrementa a palavra do vocabulário
    j vocabulario    # compara a próxima palavra

 
fim:
    mv   a1, s2    # devolve número de palavras

    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    
    # retornar
    ret

# (in/out) a0: address of the output matrix to fill (int*)
# (in)     a1: address of the vocabulary embeddings matrix (int*)
# (in)     a2: address of the input indices array (int*)
# (in)     a3: number of tokens in the input (int)
build_input_embeddings_matrix:
    # TODO
    addi sp, sp, -8
    sw a0, 4(sp)
    sw ra, 0(sp)
    loop_indices:
        ble a3, x0, fim
        addi sp, sp, -16        #guarda args originais & caller saved regs 
        sw a0, 12(sp)
        sw a1, 8(sp)
        sw a2, 4(sp)
        sw a3, 0(sp)
        lw t2, 0(a2)            #load do indice
        slli t3, t2, 4          #calcula linha da matriz:
        add a1, a1, t3          #1 linha => 4 elementos => 16 bytes (slli (...) 4)
        li a4, 4                #inicializa contador elementos antes de cada loop
        jal ra, preenche_loop
        lw a0, 12(sp)           #recupera args originais & caller saved
        lw a1, 8(sp)
        lw a2, 4(sp)
        lw a3, 0(sp)
        addi sp,sp, 16           
        addi a0, a0, 16          #próxima linha da matriz final
        addi a2, a2, 4           #próximo indice do vetor
        addi a3, a3, -1          #-1 no contador de linhas preenchidas (=nr tokens)
        j loop_indices
    
    #(in) a0: linha da matriz final a preencher
    #(in) a1: linha do vocab a copiar
    #(in) a4: elementos a copiar
    preenche_loop:
        ble a4, x0, fim_preenche
        lw a2, 0(a1)
        sw a2, 0(a0)
        addi a1, a1, 4          #próximo elemento da linha do input
        addi a0, a0, 4          #próximo elemento da linha da matriz final
        addi a4, a4, -1         #contador elementos
        j preenche_loop
        
    fim_preenche:
        jr ra
    fim:
        lw a0, 4(sp)            #recupera endereço do início da matriz final
        lw ra, 0(sp)
        addi sp, sp, 8
        jr ra
    
# (in/out) a0: address of the output matrix to fill (int*)
# (in)     a1: address of the first matrix (int*)
# (in)     a2: #rows of the first matrix (int)
# (in)     a3: #columns of the first matrix (int)
# (in)     a4: address of the second matrix (int*)
# (in)     a5: #rows of the second matrix (int)
# (in)     a6: #columns of the second matrix (int)
matrix_multiply:
    # TODO
    li t0,0 #inicializamos o identificador de linhas fora dos ciclos
 
    
mainloop:
    li t1,0 #inicializamos o identificador de colunas(j)
    blt t0,a2,secloop #enquanto o i for menor ás linhas da 1º matriz,roda os loops de j
    j end # se ir for maior ou igual,acaba o ciclo
    
secloop:
    li t2,0 #inicializamos k a 0 no inicio de cada loop secundario
    li t3,0 #inicializamos a soma no inicio de cada loop secundario
    blt t1,a6,thirdloop #enquanto j for menor que o n colunas,entra no ciclo
    j secloopend #se não for,salta para o fim do segundo loop
    
thirdloop:
    bge t2,a3,thirdloopend #se k maior ou igual as colunas da 1º matriz,acaba
    slli t6,t0,4 #i indica a linha que vamos operar
    slli t4,t2,2 # k indica a coluna dentro da linha 
    add t6,t6,a1 #mete o pointer a apontar para a linha da 1º matriz
    add t6,t6,t4 #soma os bytes da coluna desejada á linha
    lw t4,0(t6) #vamos buscar o valor na linha e coluna desejada da 1º matriz
    slli t6,t2,4 #k define a linha que vamos operar na 2ª matriz
    slli t5,t1,2 #j define a coluna que vamos operar dentro da linha
    add t6,t6,a4 #metemos o pointer a apontar para a linha
    add t6,t6,t5 #somamos os bytes da coluna desejada ao pointer
    lw t5,0(t6) #valor da linha e coluna desejada da segunda matriz
    mul t6,t4,t5 #fazemos a multiplicação dos valores das matrizes
    add t3,t3,t6 #a soma é a soma dos valores calculados no terceiro ciclo
    addi t2,t2,1 #incrementamos o k
    j thirdloop #saltamos de novo para o ciclo
    
thirdloopend:
    slli t6,t0,4 #vemos a linha em que temos de guardar na matriz de saida
    slli t4,t1,2 #vemos a coluna em que temos de guardar na matriz de saida
    add t6,t6,a0 #apontamos para a linha de a0 que queremos guardar o valor
    add t6,t6,t4 #apontamos para a coluna dentro da linha desejada para guardar o valor
    sw t3,0(t6)  #guardamos o valor na posição desejada
    addi t1,t1,1 #incrementamos o j,a variavel que controla o segundo loop
    j secloop #saltamos de novo para o segundo loop

secloopend:
    addi t0,t0,1 #incrementamos o i,a variavel que controla o primeiro loop
    j mainloop #saltamos para o primeiro loop
    
end:
    jr ra #retornamos o valor de a0,a matriz já preenchida

# (in/out) a0: address of the output scores vector to fill (int*)
# (in)     a1: address of Q matrix (int*)
# (in)     a2: address of K matrix (int*)
# (in)     a3: #rows of Q and K (int)
# (in)     a4: #columns of Q and K (int)
# (in)     a5: target token index for which we want to compute the score (int)
compute_scores:
    # TODO
    addi sp,sp,-32 #alocar espaço na stack
    sw ra,0(sp) #guardar o endereço de retorno
    sw s0,4(sp) #guardar s-regs
    sw s1,8(sp)
    sw s2,12(sp)
    sw s3,16(sp)
    sw s4,20(sp)
    sw s5,24(sp)
    sw s6,28(sp)
    mv s3,a0 #por segurança,caso dot destrua,movemos os a-regs
    mv s4,a3
    mv s5,a4
    mv s6,a2
    li s0,0 #s0 vai ditar o ciclo do j
    slli s1,a5,4 #multiplicamos o indice do token por 4
    add s1,a1,s1 #metemos em s1 o adress do nosso alvo

loop:
    bge s0,s4,end #se o j for igual ou maior ao numero de linhas da matriz,acaba
    slli s2,s0,4 #deslocação de linha em linha da matriz 
    add s2,s2,s6 #endereço da linha que vamos avaliar
    mv a1,s1 #movemos os endereços e o tamanho(estavam em s-regs) para os inputs da dot
    mv a2,s2
    mv a3,s5
    jal ra,dot #chamamos a dot
    slli t0,s0,2 #vamos determinar a posição na matriz final com base em j
    add t0,s3,t0 #vamos mexer o ponteiro para a posição na matriz final
    sw a1,0(t0) #damos store do valor recebido de dot(a1) na matriz final
    addi s0,s0,1 #incrementamos o s0
    j loop        #retomamos o loop
    

end:
    lw ra,0(sp) #repomos os valores iniciais,cumprindo com a convenção
    lw s0,4(sp)
    lw s1,8(sp)
    lw s2,12(sp)
    lw s3,16(sp)
    lw s4,20(sp)
    lw s5,24(sp)
    lw s6,28(sp)
    addi sp,sp,32 #libertamos o espaço da pilha
    jr ra

# (out) a0: address of the selected vector (int*)
# (in)  a1: address of matrix (int*)
# (in)  a2: #rows (int)
# (in)  a3: #cols (int)
# (in)  a4: target row
select_vector_in_matrix:
    # TODO
    slli t0, a3, 2       #size de 1 linha em bytes = nr cols * 4 
    mul t1, a4, t0       #calcular nr de bytes desejado relativamente ao inicio da matriz V
    add t2, t1, a1       #endereço absoluto do vetor desejado em V 
    mv a0, t2
    jr ra
# (out) a0: index of the predicted token in the vocabulary (int)
# (in)  a0: address of target vector (int*)
# (in)  a1: vocabulary embeddings address (int*)
# (in)  a2: number of tokens in vocabulary (int)
decide_next_token:
    # TODO
    addi sp, sp, -24         #salvaguardar os callee saved
    sw s0, 20(sp)
    sw s1, 16(sp)
    sw s2, 12(sp)
    sw s3, 8(sp)
    sw s4, 4(sp)
    sw ra, 0(sp)

    mv s2, a2                #limite do loop (nr de linhas no vocab)
    mv s0, x0                
    li a4, 0                 
    loop:
        bge s0, s2, fim          #guarda os args originais - caller saved regs
        addi sp, sp, -12
        sw a0, 8(sp)
        sw a1, 4(sp)    
        sw a2, 0(sp)
        mv a2, a0                #prepara os args de dot
        li a3, CONST_DIMENSION
        jal ra, dot
        mv s3, a1                #guarda o output 
        lw a0, 8(sp)             
        lw a1, 4(sp)
        lw a2, 0(sp)
        addi sp, sp, 12
        bgt s3, s4, atualiza     #compara com o output com o max atual
        addi a1, a1, 16          #próxima linha (1 linha => 4 elementos => 16 bytes)
        addi s0, s0, 1
        j loop
    
    atualiza:
        mv s4, s3                #atualiza valor do maior
        mv s1, s0                #atualiza indice do maior
        addi a1, a1, 16          
        addi s0, s0, 1
        j loop
    
    fim:
        mv a0, s1                #prepara o output
        lw ra, 0(sp)             #repõe os callee saved
        sw s4, 4(sp)
        sw s3, 8(sp)
        sw s2, 12(sp)
        sw s1, 16(sp)
        sw s0, 20(sp)
        addi sp, sp, 24
        jr ra                       

#############################################################################################################
# Dot product and argmax helper functions.
#############################################################################################################

# (in)  a1: address of first vector (int*)
# (in)  a2: address of second vector (int*)
# (in)  a3: length of the vectors (int)
# (out) a0: status code (0 for success, non-zero for error)
# (out) a1: dot product result (int)
dot:
    addi sp, sp, -4
    sw ra, 0(sp)                                    # Save return address on the stack
    # Initialize the result and the loop index.
    mv t0, zero                                     # t0 will hold the result (dot product)
    mv t1, zero                                     # t1 will be our loop index
    # Let's see first if SIZE < 1, and jump to dot_end if that's the case.
    slti t2, a3, 1                                  # t2 = (SIZE < 1)
    beq t2, zero, dot_loop                          # If SIZE >= 1, we can proceed to the loop
    li a0, 50                                       # Set a0 to 50 to indicate an error (invalid size)
    j dot_end                                       # If SIZE < 1, jump to dot_end
dot_loop:
    beq t1, a3, dot_end_loop                        # If t1 == SIZE, we are done
    lw t2, 0(a1)                                    # Load A[t1] into t2
    lw t3, 0(a2)                                    # Load B[t1] into t3
    mul t4, t2, t3                                  # t4 = A[t1] * B[t1]
    # Check if the multiplication of A[t1] and B[t1] overflows
    mulh t5, t2, t3                                 # t5 = high 32 bits of A[t1] * B[t1] (signed)
    srai t6, t4, 31                                 # t6 = sign extension of low 32 bits (0 or -1)
    bne t5, t6, overflow                            # Overflow if high bits != sign extension of low bits
    mv t6, t0                                       # Store the current result in t6 for overflow checking
    add t0, t0, t4                                  # t0 += A[t1] * B[t1]
    # Check if the previous addition caused an overflow
    # Careful: adding negative numbers will correctly result in a negative number, so we need to check for overflow in both directions.
    bgt t6, zero, check_positive_overflow           # If previous result was positive, check for positive overflow
    blt t6, zero, check_negative_overflow           # If previous result was negative, check for negative overflow
    j dot_continue_loop
check_positive_overflow:
    blt t4, zero, dot_continue_loop                 # If we added a negative number, we can't have a positive overflow
    blt t0, zero, overflow                          # If t0 < 0 after adding a positive number, we have an overflow
    j dot_continue_loop
check_negative_overflow:
    bgt t4, zero, dot_continue_loop                 # If we added a positive number, we can't have a negative overflow
    bgt t0, zero, overflow                          # If t0 > 0 after adding a negative number, we have an overflow
    j dot_continue_loop
dot_continue_loop:
    addi a1, a1, 4                                  # Move to the next element in A
    addi a2, a2, 4                                  # Move to the next element in B
    addi t1, t1, 1                                  # t1++
    j dot_loop                                      # Repeat the loop
dot_end_loop:
    li a0, 0                                        # Set a0 to 0 to indicate success
    mv a1, t0                                       # Move the result into a1 for return
    j dot_end                                       # Jump to the end of the function
overflow:
    li a0, 200                                      # Set a0 to 200 to indicate an overflow error
    j dot_end                                       # Jump to the end of the function
dot_end:
    lw ra, 0(sp)                                    # Restore return address
    addi sp, sp, 4                                  # Deallocate stack space
    ret                                             # Return to the caller

# (in)  a1: pointer to int array
# (in)  a2: array length
# (out) a0: status code
# (out) a1: index of the largest element
argmax:
    # Get the index of the maximum value in A, which is of size SIZE.
    # The result will be stored in a0.
    # If here's a draw, return the smallest index among the maximum values.
    addi sp, sp, -4
    sw ra, 0(sp)                                    # Save return address on the stack
    # Initialize the max value and the index of the max value.
    lw t0, 0(a1)                                    # t0 will hold the max value
    mv t1, zero                                     # t1 will hold the index of the max value
    mv t2, zero                                     # t2 will be our loop index
    # Error checking first: if SIZE < 1, we should return 50 to indicate an error.
    slti t3, a2, 1                                  # t3 = (SIZE < 1)
    beq t3, zero, argmax_loop                       # if SIZE >= 1, we can proceed to the loop
    li a0, 50                                       # set a0 to 50 to indicate an error (invalid size)
    j argmax_end                                    # if SIZE < 1, jump to argmax_end
argmax_loop:
    # The actual loop logic.
    beq t2, a2, argmax_end_loop                     # if t2 == SIZE, we are done
    lw t3, 0(a1)                                    # load A[t2] into t3
    ble t3, t0, argmax_next                         # if A[t2] <= max_value, skip to next
    mv t0, t3                                       # max_value = A[t2]
    mv t1, t2                                       # index_of_max = t2
argmax_next:
    addi a1, a1, 4                                  # move to the next element in A
    addi t2, t2, 1                                  # t2++
    j argmax_loop                                   # repeat the loop
argmax_end_loop:
    mv a1, t1                                       # move the index of the max value into a1 for return
    li a0, 0                                        # set a0 to 0 to indicate success
argmax_end:
    lw ra, 0(sp)                                    # Restore return address
    addi sp, sp, 4                                  # Deallocate stack space
    ret                                             # return to the caller

exit_with_code:
    li a7, CONST_SYSCALL_EXIT2
    ecall

#############################################################################################################
# Helper functions for printing and debugging.
#############################################################################################################

.data
PRINT_HEADER_VOCABULARY:    .string "=== Vocabulary ==="
PRINT_HEADER_INPUT:         .string "=== Input ==="
PRINT_HEADER_INPUT_INDICES: .string "=== Input Indices ==="
PRINT_HEADER_MATRIX:        .string "=== Matrix ==="
PRINT_HEADER_SCORES:        .string "=== Scores ==="
PRINT_HEADER_NEXT_TOKEN:    .string "=== Decision ==="
PRINT_VECTOR_LB:            .string "[ "
PRINT_VECTOR_RB:            .string "]"

.text
# Prints a null-terminated string followed by a newline.
# (in) a0: buffer to print (char*)
println:
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    ret

# Prints the vocabulary buffer.
# (in) a0: address of the vocabulary buffer (char*)
print_vocabulary:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_VOCABULARY
    jal println
    mv a0, s0
    jal println
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

# Prints the input buffer as a string.
# (in) a0: address of the input buffer (char*)
print_input:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_INPUT
    jal println
    mv a0, s0
    jal println
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret

# Prints the input indices vector.
# (in) a0: address of the input indices vector (int*)
# (in) a1: size of the input indices vector (int)
print_indices:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    mv s0, a0
    mv s1, a1
    la a0, PRINT_HEADER_INPUT_INDICES
    jal println
    mv a0, s0
    mv a1, s1
    jal print_vector
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret

print_scores:
    addi sp, sp, -4
    sw ra, 0(sp)
    la a0, PRINT_HEADER_SCORES
    jal println
    la a0, SCORES_VECTOR
    lw a1, INPUT_TOTAL_TOKENS
    jal print_vector
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

# a0: address of matrix to print (int*)
# a1: number of rows
# a2: number of columns
print_matrix:
    addi sp, sp, -24
    sw ra, 0(sp)                                    # return address
    sw s0, 4(sp)                                    # matrix pointer
    sw s1, 8(sp)                                    # row index
    sw s2, 12(sp)                                   # col index
    sw s3, 16(sp)                                   # number of rows
    sw s4, 20(sp)                                   # number of columns
    mv s0, a0                                       # s0 = pointer to matrix
    mv s3, a1                                       # s3 = number of rows
    mv s4, a2                                       # s4 = number of columns
    li s1, 0                                        # s1 = current row index
    la a0, PRINT_HEADER_MATRIX
    jal println
print_matrix_row_loop:
    beq s1, s3, print_matrix_done
    li s2, 0
print_matrix_col_loop:
    beq s2, s4, print_matrix_next_row
    lw a0, 0(s0)
    li a7, CONST_SYSCALL_PRINT_INT
    ecall
    addi s0, s0, 4
    addi s2, s2, 1
    li a0, CONST_CHAR_SPACE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    j print_matrix_col_loop
print_matrix_next_row:
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s1, s1, 1
    j print_matrix_row_loop
print_matrix_done:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24
    ret

# a0: address of vector to print (int*)
# a1: number of elements (int)
print_vector:
    addi sp, sp, -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    mv s0, a0                                       # s0 = pointer to vector
    mv s1, a1                                       # s1 = number of elements
    la a0, PRINT_VECTOR_LB                          # Print "[ "
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
print_vector_loop:
    beq s1, zero, print_vector_done
    lw a0, 0(s0)
    li a7, CONST_SYSCALL_PRINT_INT
    ecall
    li a0, CONST_CHAR_SPACE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s0, s0, 4
    addi s1, s1, -1
    j print_vector_loop
print_vector_done:
    la a0, PRINT_VECTOR_RB                          # Print "]"
    li a7, CONST_SYSCALL_PRINT_STRING
    ecall
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    ret

# (in) a0: address of the predicted token (char*)
print_predicted_token:
    addi sp, sp, -8
    sw ra, 0(sp)
    sw s0, 4(sp)
    mv s0, a0
    la a0, PRINT_HEADER_NEXT_TOKEN
    jal println
    # s0 = start of target token, print it char by char until newline or null
print_predicted_token_char:
    lb t0, 0(s0)
    beq t0, zero, print_predicted_token_nl          # null terminator
    li t1, CONST_CHAR_NEWLINE
    beq t0, t1, print_predicted_token_nl            # newline terminator
    mv a0, t0
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    addi s0, s0, 1
    j print_predicted_token_char
print_predicted_token_nl:
    li a0, CONST_CHAR_NEWLINE
    li a7, CONST_SYSCALL_PRINT_CHAR
    ecall
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
    ret
