vlib work
vlog sp_ram.v SPI_slave.v SPI_tb.v SPI.v
vsim -voptargs=+acc work.SPI_tb
add wave /SPI_tb/*
add wave /SPI_tb/dut/slave/tx_valid
add wave /SPI_tb/dut/slave/rx_valid
add wave /SPI_tb/dut/slave/tx_data
add wave /SPI_tb/dut/slave/rx_data
add wave /SPI_tb/dut/slave/counter
add wave /SPI_tb/dut/RAM/din
add wave /SPI_tb/dut/RAM/dout
add wave /SPI_tb/dut/slave/cs
add wave /SPI_tb/dut/slave/ns

run -all
#quit -sim
