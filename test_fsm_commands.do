quit -sim
vcom -93 -work work -O0 {D:/Google Drive/Coding/VHDL/ProjectTemp/fsm_commands.vhd}

# Começa a simulação
vsim work.fsm_commands

# Adiciona os sinais
add wave -position insertpoint  \
sim:/fsm_commands/command_width \
sim:/fsm_commands/row_col_width \
sim:/fsm_commands/data_width \
sim:/fsm_commands/rows \
sim:/fsm_commands/cols \
sim:/fsm_commands/clock \
sim:/fsm_commands/reset \
sim:/fsm_commands/enable \
sim:/fsm_commands/acknowledge \
sim:/fsm_commands/command \
sim:/fsm_commands/row \
sim:/fsm_commands/col \
sim:/fsm_commands/row_out \
sim:/fsm_commands/col_out \
sim:/fsm_commands/status \
sim:/fsm_commands/sel_data_registers \
sim:/fsm_commands/sel_input_data_registers \
sim:/fsm_commands/command_done \
sim:/fsm_commands/new_command \
sim:/fsm_commands/current_state \
sim:/fsm_commands/next_state

# Cria clock, reset 1 e coloca as variáveis iniciais
force clock 1 0, 0 {50 ps} -r 100
force reset 1
force enable 0
force acknowledge 0
force command 00000000
force row 00000010
force col 00000001
run 1 ns

# Retira o reset, espera enable ser 1
force reset 0
run 1 ns

# Coloca enable em 1 e começa a máquina, troca para a função change_power, coloca new_command em 1 e depois espera acknowledge
force enable 1
run 1 ns
# Coloca acknowledge 1 e enable 0 e espera novo comando (enable = 1)
force enable 0
force acknowledge 1
run 1 ns

# Troca para a função change_shift_amount, sel_data_registers tem que ficar 01
force acknowledge 0
force command 00000001
force enable 1
run 1 ns
force enable 0
force acknowledge 1
run 1 ns

# Troca para a função change_decay, sel_data_registers tem que ficar 10
force acknowledge 0
force command 00000010
force enable 1
run 1 ns
force enable 0
force acknowledge 1
run 1 ns

# Troca para a função copy_to_next_row_power, sel_data_registers tem que ficar 00 e sel_input_data_registers 01. A coluna fica em 255 ativando todos da próxima linha.
# Depois troca para a função copy_to_next_row_shift_amount, sel_data_registers tem que ficar 01 e sel_input_data_registers 01. A coluna fica em 255 ativando todos da próxima linha.
# Depois troca para a função copy_to_next_row_decay, sel_data_registers tem que ficar 10 e sel_input_data_registers 01. A coluna fica em 255 ativando todos da próxima linha.
force acknowledge 0
force command 00000011
force enable 1
run 1 ns
force enable 0
force acknowledge 1
run 1 ns

# Troca para a função copy_to_next_col_power, sel_data_registers tem que ficar 00 e sel_input_data_registers 10. A linha fica em 255 ativando todos da próxima coluna.
# Depois troca para a função copy_to_next_col_shift_amount, sel_data_registers tem que ficar 01 e sel_input_data_registers 10. A linha fica em 255 ativando todos da próxima coluna.
# Depois troca para a função copy_to_next_col_decay, sel_data_registers tem que ficar 10 e sel_input_data_registers 10. A linha fica em 255 ativando todos da próxima coluna.
force acknowledge 0
force command 00000100
force enable 1
run 1 ns
force enable 0
force acknowledge 1
run 1 ns