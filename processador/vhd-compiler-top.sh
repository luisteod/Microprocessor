#!/bin/bash
echo "Digite se é um arquivo do tipo _tb : (y) or (n)"
read tipo

ghdl -a registrador.vhd
ghdl -e registrador

ghdl -a flipFlop.vhd
ghdl -e flipFlop

ghdl -a banco_reg.vhd
ghdl -e banco_reg

ghdl -a mux2to1.vhd
ghdl -e mux2to1

ghdl -a maq_estados.vhd
ghdl -e maq_estados

ghdl -a pc.vhd
ghdl -e pc

ghdl -a rom.vhd
ghdl -e rom

ghdl -a ula.vhd
ghdl -e ula

ghdl -a ram.vhd
ghdl -e ram

ghdl -a ula_banco_ram.vhd
ghdl -e ula_banco_ram

ghdl -a instr_reg.vhd
ghdl -e instr_reg

ghdl -a controle.vhd
ghdl -e controle

ghdl -a processador.vhd
ghdl -e processador

#para acessar a variável coloca-se o cifrão
if [ $tipo == "y" ]; then
    ghdl -a processador_tb.vhd
    ghdl -e processador_tb
    ghdl -r processador_tb --wave=processador_tb.ghw
    gtkwave processador_tb.ghw
fi
