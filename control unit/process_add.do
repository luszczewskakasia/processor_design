restart -f

force -freeze clk 0 0, 1 {10 ns} -r 20ns

force reset 1 0 ns

force register_A "0000000000000000001" 0ns
force register_B "0000000000000000011" 0ns
force register_C "0000000000000000111" 0ns
force register_LOAD "0000000000000001111" 0ns

force instr_reg "00000000" 0ns 
force instr_reg "00001111" 110 ns 

force debug "111" 0 ns

force status_bit_reg 0 0ns

run 2000ns