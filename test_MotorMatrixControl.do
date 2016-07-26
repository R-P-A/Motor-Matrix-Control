add wave -position insertpoint  \
sim:/motormatrixcontrol/motors0/saved_power \
sim:/motormatrixcontrol/motors0/power_shift_amount \
sim:/motormatrixcontrol/motors0/power_decay \
sim:/motormatrixcontrol/motors0/motor_data_selected \
sim:/motormatrixcontrol/motors0/motor_data_out \
sim:/motormatrixcontrol/motors1(1)/n_motors1/saved_power \
sim:/motormatrixcontrol/motors1(1)/n_motors1/power_shift_amount \
sim:/motormatrixcontrol/motors1(1)/n_motors1/power_decay \
sim:/motormatrixcontrol/motors1(1)/n_motors1/motor_data_selected \
sim:/motormatrixcontrol/motors1(1)/n_motors1/motor_data_out \
sim:/motormatrixcontrol/motors2(1)/n_motors2/saved_power \
sim:/motormatrixcontrol/motors2(1)/n_motors2/power_shift_amount \
sim:/motormatrixcontrol/motors2(1)/n_motors2/power_decay \
sim:/motormatrixcontrol/motors2(1)/n_motors2/motor_data_selected \
sim:/motormatrixcontrol/motors2(1)/n_motors2/motor_data_out

# Abre o work
vsim work.motormatrixcontrol

# Adiciona as ondas
add wave -position insertpoint  \
sim:/motormatrixcontrol/clock \
sim:/motormatrixcontrol/reset \
sim:/motormatrixcontrol/enable \
sim:/motormatrixcontrol/acknowledge \
sim:/motormatrixcontrol/new_command \
sim:/motormatrixcontrol/interrupt \
sim:/motormatrixcontrol/readwrite \
sim:/motormatrixcontrol/command \
sim:/motormatrixcontrol/row \
sim:/motormatrixcontrol/col \
sim:/motormatrixcontrol/data \
sim:/motormatrixcontrol/sel_data_registers \
sim:/motormatrixcontrol/sel_input_data_registers \
sim:/motormatrixcontrol/row_out \
sim:/motormatrixcontrol/col_out \
sim:/motormatrixcontrol/motors_data \
sim:/motormatrixcontrol/clock_timer \
sim:/motormatrixcontrol/motors_out \
sim:/motormatrixcontrol/timer \
sim:/motormatrixcontrol/rows \
sim:/motormatrixcontrol/cols \
sim:/motormatrixcontrol/dataWidth \
sim:/motormatrixcontrol/motor_data_width \
sim:/motormatrixcontrol/row_col_width \
sim:/motormatrixcontrol/command_width \
sim:/motormatrixcontrol/timer_width \
sim:/motormatrixcontrol/writedata \
sim:/motormatrixcontrol/reg_command_data_out


# Cria o clock, reset 1 e variáveis iniciais
force clock 1 0, 0 {50 ps} -r 100
force reset 1
force enable 0
force acknowledge 0
force test 0
force bistIn 0
force readwrite 00
force writedata 00000000000000000000000000000000
run 10 ns

# Retira o reset
force reset 0
run 10 ns

# Liga o motor 0,0 potência 100, variação 0 e decaimento 0
# Coloca variação 0
force writedata 00000001000000000000000000000000
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca decaimento 0
force writedata 00000010000000000000000000000000
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca potencia 100
force writedata 00000000000000000000000001100100
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
run 150 ns

# Liga o motor 1,0 potência 100, variação 0 e decaimento 0
# Coloca variação 0
force writedata 00000001000000010000000000000000
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca decaimento 0
force writedata 00000010000000010000000000000000
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca potencia 100
force writedata 00000000000000010000000001100100
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
run 150 ns

# Liga o motor 0,1 potência 100, variação 0 e decaimento 0
# Coloca variação 0
force writedata 00000001000000000000000100000000
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
# Coloca decaimento 0
force writedata 00000010000000000000000100000000
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca potencia 100
force writedata 00000000000000000000000101100100
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
run 150 ns

# Liga o motor 1,2 potência 100, variação 0 e decaimento 0
# Coloca variação 0
force writedata 00000001000000010000001000000000
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca decaimento 0
force writedata 00000010000000010000001000000000
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca potencia 100
force writedata 00000000000000010000001001100100
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
run 150 ns

# Ajustar linha 0 para a próxima linha. Tem que copiar o motors_data_out da linha 0 para a linha 1
force writedata 00000011000000000000000001100100
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
run 150 ns

# Ajusta coluna 1 para a próxima coluna. Tem que copiar o motors_data_out da coluna 1 para a coluna 2
force writedata 00000100000000010000000101100100
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
run 150 ns


# Ligar todos os motores potência 100, variação 5 e decaimento 10
# Coloca variação 0
force writedata 00000001111111111111111100000101
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca decaimento 0
force writedata 00000010111111111111111100001010
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
# Coloca potencia 100
force writedata 00000000111111111111111101100100
run 1 ns
force readwrite 01
run 1 ns
force readwrite 00
run 1 ns
force enable 1
run 1 ns
force enable 0
run 1 ns
force acknowledge 1
run 1 ns
force acknowledge 0
run 1 ns
run 400 ns

# Resta o sistema
force reset 1
run 10 ns

# Retira o reset e tem que continuar tudo desligado
force reset 0
run 10 ns