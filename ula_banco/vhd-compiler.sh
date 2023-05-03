#!/bin/bash

echo "Digite se é um arquivo do tipo _tb : (y) or (n)"
read tipo

#para acessar a variável coloca-se o cifrão
ghdl -a registrador.vhd
ghdl -e registrador

ghdl -a banco_reg.vhd
ghdl -e banco_reg

ghdl -a ula.vhd
ghdl -e ula

ghdl -a mux2to1.vhd
ghdl -e mux2to1

ghdl -a ula_banco.vhd
ghdl -e ula_banco

if [ $tipo == "y" ]; then
    ghdl -a ula_banco_tb.vhd
    ghdl -e ula_banco_tb
    ghdl -r ula_banco_tb --wave=ula_banco_tb.ghw
    gtkwave ula_banco_tb.ghw
fi
