# Open work
vsim work.motor

# Adiciona os sinais
add wave -position insertpoint  \
sim:/motor/row_col_width \
sim:/motor/own_row \
sim:/motor/own_col \
sim:/motor/motor_data_width \
sim:/motor/clock \
sim:/motor/reset \
sim:/motor/new_command \
sim:/motor/clock_timer \
sim:/motor/timer \
sim:/motor/row \
sim:/motor/col \
sim:/motor/sel_data_registers \
sim:/motor/sel_input_data_registers \
sim:/motor/motor_data \
sim:/motor/motor_up_data \
sim:/motor/motor_left_data \
sim:/motor/motor_data_out \
sim:/motor/power_wave \
sim:/motor/saved_power \
sim:/motor/power_shift_amount \
sim:/motor/power_decay \
sim:/motor/acknowledge_motor \
sim:/motor/new_command_acknowledged \
sim:/motor/enable_power_register \
sim:/motor/enable_power_decay \
sim:/motor/enable_power_shift_amount \
sim:/motor/motor_data_selected

# Inicializa as variáveis, power_wave tem que ser 0
force clock 1 0, 0 {50 ps} -r 100
force reset 1
force new_command 0
force clock_timer 1 0, 0 {12800 ps} -r 25600 ps
force sel_data_registers 00
force sel_input_data_registers 00
force row 00000000
force col 00000000
force motor_data 00110010
force motor_up_data 00001111
force motor_left_data 00000010
# Força o timer como contador de 1 em 1 com período 100 ps
force timer(0) 0 0, 1 {100 ps} -r 200 ps
force timer(1) 0 0, 1 {200 ps} -r 400 ps
force timer(2) 0 0, 1 {400 ps} -r 800 ps
force timer(3) 0 0, 1 {800 ps} -r 1600 ps
force timer(4) 0 0, 1 {1600 ps} -r 3200 ps
force timer(5) 0 0, 1 {3200 ps} -r 6400 ps
force timer(6) 0 0, 1 {6400 ps} -r 12800 ps
force timer(7) 0 0, 1 {12800 ps} -r 25600 ps
run 1 ns

# Retira reset, power_wave continua a ser 0.
force reset 0
run 1 ns

# Troca a linha e depois a coluna e coloca valor na potência do motor, ela não pode mudar
force row 00000001
force motor_data 00001010
run 30 ns
force row 00000000
force col 00000001
run 30 ns
force col 00000000
run 30 ns

# Liga o motor e depois troca a linha para testar se continua funcionando normalmente
force new_command 1
run 1 ns
force new_command 0
run 30 ns
force row 00000001
force new_command 1
run 1 ns
force new_command 0
run 70 ns

# Troca a potência para 255 e analisa o tempo da variação (deveria ser praticamente instantâneo)
force row 00000000
force motor_data 11111111
force new_command 1
run 1 ns
force new_command 0
run 100 ns

# Troca a potência para 105 e coloca um valor de variação 1 e decaimento 10
force motor_data 01101001
run 100 ps
force sel_data_registers 01
force motor_data 00000001
run 100 ps
force sel_data_registers 10
force motor_data 00001010
run 100 ps
force new_command 1
run 1 ns
force new_command 0
run 4200 ns

# Pega o valor da potência da linha de cima, variação da linha da esquerda e decaimento 0
force sel_data_registers 00
force sel_input_data_registers 01
run 100 ps
force sel_data_registers 01
force sel_input_data_registers 10
run 100 ps
force sel_data_registers 10
force sel_input_data_registers 00
force motor_data 00000000
run 100 ps
force new_command 1
run 1 ns
force new_command 0
run 2000 ns

# Liga o reset (lembrando que se for o reset geral, os registradores do motor irão zerar) e power_wave deve virar 0
force reset 1
force motor_data 00000000
force motor_up_data 00000000
force motor_left_data 00000000
run 20 ns

# Retira o reset e o sistema deve ficar igual
force reset 0
run 100 ns