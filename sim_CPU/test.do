restart -f

force -freeze clk 0 0, 1 {10 ns} -r 20ns

force reset 0 0 ns
force reset 1 13 ns

run 300ns