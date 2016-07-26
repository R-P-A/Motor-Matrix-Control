# Inicio do teste
vsim work.timer_n_bits

# Adiciona os sinais
add wave -position insertpoint  \
sim:/timer_n_bits/N \
sim:/timer_n_bits/clock \
sim:/timer_n_bits/timer \
sim:/timer_n_bits/clock_timer \
sim:/timer_n_bits/current_timer \
sim:/timer_n_bits/max_timer \
sim:/timer_n_bits/next_timer

# Variáveis iniciais
force clock 1 0, 0 {10 ns} -r 20 ns
run 350000 ns