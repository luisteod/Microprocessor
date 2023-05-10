#!/bin/bash
echo "Digite se é um arquivo do tipo _tb : (y) or (n)"
read tipo

ghdl -a registrador.vhd
ghdl -e registrador

ghdl -a maq_estados.vhd
ghdl -e maq_estados

ghdl -a pc.vhd
ghdl -e pc

ghdl -a rom.vhd
ghdl -e rom

ghdl -a processador.vhd
ghdl -e processador

#para acessar a variável coloca-se o cifrão
if [ $tipo == "y" ]; then
    ghdl -a processador_tb.vhd
    ghdl -e processador_tb
    ghdl -r processador_tb --wave=processador_tb.ghw
    gtkwave processador_tb.ghw
fi
