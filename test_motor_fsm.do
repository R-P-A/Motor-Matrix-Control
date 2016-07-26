# Preparação
vsim work.motor_fsm

add wave -position insertpoint  \
sim:/motor_fsm/motor_data_width \
sim:/motor_fsm/clock \
sim:/motor_fsm/reset \
sim:/motor_fsm/current_state \
sim:/motor_fsm/next_state \
sim:/motor_fsm/new_command_acknowledged \
sim:/motor_fsm/clock_timer \
sim:/motor_fsm/current_acknowledge_delay \
sim:/motor_fsm/next_acknowledge_delay \
sim:/motor_fsm/timer \
sim:/motor_fsm/current_power \
sim:/motor_fsm/next_power \
sim:/motor_fsm/saved_power \
sim:/motor_fsm/power_shift_amount \
sim:/motor_fsm/power_decay \
sim:/motor_fsm/power_wave


# Sempre antes de cada comando novo, o new_command_acknowledged é ativado e desativado.

# Cria as variáveis iniciais e coloca variação e dacaimento 0. current_power vai pra 25 rápido e mantem este valor
force clock 0 0, 1 {50 ps} -r 100
force reset 1
force new_command_acknowledged 0
force clock_timer 1 0, 0 {20 ns} -r 40 ns
force saved_power 00011001
force power_shift_amount 00000000
force power_decay 00000000
# Força o timer como contador de 1 em 1 com período 100 ps
force timer(0) 0 0, 1 {50 ps} -r 100 ps
force timer(1) 0 0, 1 {100 ps} -r 200 ps
force timer(2) 0 0, 1 {200 ps} -r 400 ps
force timer(3) 0 0, 1 {400 ps} -r 800 ps
force timer(4) 0 0, 1 {800 ps} -r 1600 ps
force timer(5) 0 0, 1 {1600 ps} -r 3200 ps
force timer(6) 0 0, 1 {3200 ps} -r 6400 ps
force timer(7) 0 0, 1 {6400 ps} -r 12800 ps
run 100 ps
force reset 0
run 50 ns

# Coloca decay 3 e espera zerar o current_power, mantendo 0
force power_decay 00000011
force new_command_acknowledged 1
run 100 ps
force new_command_acknowledged 0
run 350 ns

# Agora coloca decay 1 e variação 2, e muda a potência para 100. current_power tem que subir devagar e cair mais rápido
force saved_power 01100100
force power_shift_amount 00000010
force power_decay 00000001
force new_command_acknowledged 1
run 100 ps
force new_command_acknowledged 0
run 6100 ns

# Coloca decay 3 e espera zerar o current_power, mantendo 0
force saved_power 11111111
force power_shift_amount 00000000
force power_decay 00000000
force new_command_acknowledged 1
run 100 ps
force new_command_acknowledged 0
run 100 ns

# Força o reset e tem que zerar power_wave e current_power
force reset 1
force saved_power 00000000
run 100 ns
force reset 0
run 100 ns