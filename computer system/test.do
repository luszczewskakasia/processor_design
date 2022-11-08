restart -f 

force -freeze clk 0 0, 1 {10 ns} -r 20ns

force reset 1 0 ns

force app_input "0000000011" 0ns

force debug "011"

run 100000ns