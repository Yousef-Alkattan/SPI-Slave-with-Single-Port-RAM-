module sp_RAM (din,clk,rst_n,rx_valid,tx_valid, dout); 
parameter ADDR_SIZE= 8; 
parameter MEM_DEPTH = 256; 

input [9:0] din; 
input clk,rst_n,rx_valid; 
output reg tx_valid; 
output reg [7:0] dout; 
reg [ADDR_SIZE-1:0] addr; 
reg [7:0] mem [MEM_DEPTH-1:0];


always@(posedge clk) begin 
    if (~rst_n)begin 
    dout<=0; 
    tx_valid<=0; 
    end
    
    else begin 
        if(rx_valid) begin 
            case(din[9:8]) 
            2'b00: begin addr<=din[7:0]; tx_valid<=0; end
            2'b01: begin mem[addr]<=din[7:0]; tx_valid<=0; end
            2'b10: begin addr<=din[7:0]; tx_valid<=0; end
            2'b11: begin dout<=mem[addr]; tx_valid<=1; end
            endcase
        end 
    end 
end 
endmodule

