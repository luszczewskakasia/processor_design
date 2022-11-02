restart -f

force -freeze clk 0 0, 1 {10 ns} -r 20ns

force reset 0 0 ns
force reset 1 13 ns
force reset 0 145ns

force din "00000000" 0ns
force din "01010101" 30ns
force din "11111111" 100ns

force address "0011" 0ns
force address "1011" 105ns

force mem_status "11" 0ns
force mem_status "00" 45ns
force mem_status "10" 75ns
force mem_status "00" 95ns
force mem_status "11" 105ns

run 300ns