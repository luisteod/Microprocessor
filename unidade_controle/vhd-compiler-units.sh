#!/bin/bash
echo "Digite o nome do arquivo sem o .vhd e sem _tb"
read nome_arquivo

echo "Digite se é um arquivo do tipo _tb : (y) or (n)"
read tipo

#para acessar a variável coloca-se o cifrão
if [ $tipo == "y" ];
    then
	ghdl -a "$nome_arquivo".vhd
	ghdl -e "$nome_arquivo"
        ghdl -a "$nome_arquivo"_tb.vhd
        ghdl -e "$nome_arquivo"_tb
        ghdl -r "$nome_arquivo"_tb --wave="$nome_arquivo"_tb.ghw
        gtkwave "$nome_arquivo"_tb.ghw
    else
        ghdl -a "$nome_arquivo".vhd
        ghdl -e "$nome_arquivo"
fi