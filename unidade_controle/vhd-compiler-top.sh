#!/bin/bash
echo "Digite se é um arquivo do tipo _tb : (y) or (n)"
read tipo

ghdl -a maquina_estados.vhd
ghdl -e maquina_estados
ghdl -a maquina_estados_tb.vhd

ghdl -a pc.vhd
ghdl -e pc
ghdl -a pc.vhd

ghdl -a rom.vhd
ghdl -e rom
ghdl -a rom.vhd

ghdl -a controle.vhd
ghdl -e controle
#para acessar a variável coloca-se o cifrão
if [ $tipo == "y" ]; then
    ghdl -a controle_tb.vhd
    ghdl -e controle_tb
    ghdl -r controle_tb --wave=controle_tb.ghw
    gtkwave controle_tb.ghw
fi
