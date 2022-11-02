restart -f

force -freeze clk 0 0, 1 {10 ns} -r 20ns

force reset 1 0 ns

force instr_reg 0 0 ns 
force instr_reg "00011001" 100 ns 

force debug "100" 0 ns

force status_bit_reg 0 0 ns

run 300ns