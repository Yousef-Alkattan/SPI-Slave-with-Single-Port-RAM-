module SPI_slave(clk ,rst_n ,SS_n ,MOSI ,MISO ,rx_data ,rx_valid ,tx_data ,tx_valid);


input clk,rst_n;
input MOSI; //Master out Slave in
input SS_n,tx_valid;
input [7:0] tx_data;

output reg MISO; //Master in Slave out
output reg rx_valid;
output reg [9:0] rx_data;

parameter IDLE      = 5'b00000;
parameter CHK_CMD   = 5'b00001;
parameter WRITE     = 5'b00010;
parameter READ_ADD  = 5'b00011;
parameter READ_DATA = 5'b00100;

(* fsm_extract = "yes", fsm_encoding = "gray" *)
reg [4:0] cs,ns;
reg read_type;//0 is address 1 is data
reg [4:0] counter;

always@(posedge clk)begin //STATE MEMORY

	if(~rst_n)
		cs <= IDLE;
	else
		cs <= ns;
end

always@(*)begin //NEXT STATE LOGIC
	case(cs)
		IDLE:
			if(~SS_n) ns = CHK_CMD;
		CHK_CMD:
			if(SS_n) ns = IDLE;
			else begin
				if(~MOSI) ns = WRITE;
				else if(MOSI && ~read_type) ns = READ_ADD;
				else ns = READ_DATA;
			end
		WRITE:
			if(SS_n) ns = IDLE;
		READ_ADD:
			if(SS_n) ns = IDLE;
		READ_DATA:
			if(SS_n) ns = IDLE;

		default: ns = IDLE;
	endcase	

end

always@(posedge clk)begin //OUTPUT LOGIC
	if (!rst_n) begin
		rx_valid <= 0;
        	rx_data <= 0;
		read_type <= 0;
        	counter <= 0;
        	MISO <= 0;
	end
	
	else if(cs == IDLE)begin
        counter <= 0;
		rx_valid <=0;
		rx_data <= 0;
	end
                
	else if(cs == WRITE)begin
 		if (counter <= 9) rx_data[9 - counter] <= MOSI; // Store 10 bits
                if (counter == 9) rx_valid <= 1;
                	counter <= counter + 1;
	end

 	else if(cs == READ_ADD)begin
		read_type <= 1;
               	if (counter <= 9) rx_data[9 - counter] <= MOSI; // Store 10 bits address
               	if (counter == 9) rx_valid <= 1;
                    	counter <= counter + 1;
	end

	else if(cs == READ_DATA)begin
		read_type <= 0;
                if (counter <= 9) rx_data[9 - counter] <= MOSI;
               	if (counter == 9) rx_valid <= 1;
		if(tx_valid && counter <= 17) MISO = tx_data[counter-10]; // Send out data bit by bit
                    	counter <= counter + 1;
 	end
end



endmodule