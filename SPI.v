module SPI (input clk, rst_n,MOSI, SS_n,output MISO);

    wire rx_valid, tx_valid;
    wire [9:0]rx_data;
    wire [7:0]tx_data;


    SPI_slave slave(
    	.clk(clk), .rst_n(rst_n), .SS_n(SS_n), .MOSI(MOSI), .MISO(MISO), 
	.tx_valid(tx_valid), .rx_valid(rx_valid), .rx_data(rx_data), .tx_data(tx_data)
    );

    sp_RAM #(.MEM_DEPTH(256),.ADDR_SIZE(8)) RAM(
        .clk(clk), .rst_n(rst_n), .din(rx_data), 
	.rx_valid(rx_valid), .tx_valid(tx_valid), .dout(tx_data)
    );

endmodule