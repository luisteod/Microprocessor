    MOV R1, #2
    MOV R2, #1

    MOV [R1], R1
    ADD R1, #1
    CMP R1, #33
    JUMPR N, #-3

    MOV R1, #2

    MOV R2, R1
    ADD R2, R1
    MOV [R2], R0
    ADD R2, R1
    CMP R2, #33
    JUMPR N, #-3
    ADD R1, #1    
    CMP R0, [R1]
    JUMPR NZ, #-8