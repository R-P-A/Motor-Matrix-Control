# Começa a simulação
vsim work.register_data_width

# Adiciona os sinais
add wave -position insertpoint  \
sim:/register_data_width/dataWidth \
sim:/register_data_width/clock \
sim:/register_data_width/reset \
sim:/register_data_width/enable \
sim:/register_data_width/inpt \
sim:/register_data_width/outpt \
sim:/register_data_width/current_state_reg \
sim:/register_data_width/next_state_reg

# Cria o clock, reset 1 e cria as variáveis de entrada
force clock 1 0, 0 {50 ps} -r 100
force reset 1
force enable 0
force inpt 00000010000000100000000101010000
run 1 ns

# Retira o reset, oupt tem que continuar 0
force reset 0
run 1 ns

# Coloca o enable 1, outp <= inpt
force enable 1
run 1 ns

# Coloca o enable 0, outpt <= outpt
force enable 0
run 1 ns

# Troca o valor de inpt, outpt <= outpt
force inpt 00000010000000100000000101011111
run 1 ns

# Reset 1, outpt <= 0
force reset 1
run 1 ns