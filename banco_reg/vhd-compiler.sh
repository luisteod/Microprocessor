#!/bin/bash

echo "Digite se é um arquivo do tipo _tb : (y) or (n)"
read tipo

#para acessar a variável coloca-se o cifrão
ghdl -a registrador.vhd
ghdl -e registrador

ghdl -a banco_reg.vhd
ghdl -e banco_reg

if [ $tipo == "y" ]; then
    ghdl -a banco_reg_tb.vhd
    ghdl -e banco_reg_tb
    ghdl -r banco_reg_tb --wave=banco_reg_tb.ghw
    gtkwave banco_reg_tb.ghw
fi
