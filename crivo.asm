    MOVI R1, 2
    MOVI R2, 1

inicializa:
    MOVR [R1], R1
    ADDI R1, 1
    CMPI R1, 33
    JUMPR flag_n, inicializa

    MOVI R1, 2
marca:
    MOVR R2, R1
    ADDR R2, R1
    marca2:
        MOVR [R2], R0
        ADDR R2, R1
        CMPI R2, 33
        JUMPR flag_n, marca2
    ADDI R1, 1    
    CMPR [R1], R0
    JUMPR flag_nz, marca

    MOVI R3, 21111 1001 
    MOVI R5, 0
loop:
    MOVR R4, [R3]
    ADDI R3, 1
    CMPR R4, R0
    JUMPR flag_z, loop
    MOVR [R5], R4
    ADDI R5, 1
    CMPI R4, 33
    JUMPR flag_n, loop