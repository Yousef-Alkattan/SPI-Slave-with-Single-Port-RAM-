module SPI_tb(); 
reg MOSI,clk,rst_n,SS_n; 
wire MISO;
SPI dut (.clk(clk), .rst_n(rst_n),.MOSI(MOSI), .SS_n(SS_n),.MISO(MISO));
reg [9:0] data; 
reg [7:0] ADDR_read=0,ADDR_write=0;
reg [7:0] read_data=8'b0; 

initial begin 
    clk=0; 
    forever 
    #1 clk=~clk; 
end 

integer i; 
initial begin 
    $readmemh("mem.dat", dut.RAM.mem); 
    SS_n=1;
    MOSI=0;  
    rst_n=0; 
@(negedge clk); 
    rst_n=1;  

    //RAM write address test
    SS_n=0;
@(negedge clk);
MOSI=0;
@(negedge clk);
    data=10'b0001011001; // address 89 in decimal, has 58
    for (i=0;i<10;i=i+1) begin 
        MOSI=data[9-i]; 
	@(negedge clk);
    end 
    SS_n=1; 
    ADDR_write=dut.slave.rx_data[7:0]; 
    $display("WRITE ADDR: RAM[0x%h] -> Expected Data: 0x58, Stored Data: 0x%h", ADDR_write, dut.RAM.mem[ADDR_write]);

    //RAM write data test
    data =10'b0101110010; //stored 114 in decimal 72 in hexa
@(negedge clk);
    SS_n=0; 
@(negedge clk);
MOSI=0;
@(negedge clk);
    for (i=0;i<10;i=i+1) begin 
        MOSI= data[9-i]; 
	@(negedge clk); 
    end  
    SS_n=1; 
    @(negedge clk); 
    $display("WRITE DATA: RAM[0x%h] -> Expected Data: 0x72, Stored Data: 0x%h", ADDR_write, dut.RAM.mem[ADDR_write]); 

    // read address test
@(negedge clk);
    data=10'b1000101110; // address 46 in decimal, has 5A
    SS_n=0;
@(negedge clk);
MOSI=1;
 @(negedge clk);
    for (i=0;i<10;i=i+1) begin 
        MOSI= data[9-i]; 
	@(negedge clk); 
    end 
    ADDR_read= dut.slave.rx_data[7:0];  
    SS_n=1;  
   $display("READ ADDR: Requested RAM[0x%h] -> Expected Data: 0x5A, Stored Data: 0x%h", ADDR_read, dut.RAM.mem[ADDR_read]);
@(negedge clk);
    SS_n=0;

    // read data test result should be 5A
    data=10'b1100101110;
@(negedge clk);
MOSI=1;
@(negedge clk); 
    for (i=0;i<10;i=i+1) begin 
        MOSI= data[9-i]; 
	@(negedge clk);  
    end
@(negedge clk);
    for (i=0;i<8;i=i+1) begin 
        read_data={MISO, read_data[7:1]}; 
	@(negedge clk);  
    end
    SS_n=1;
    $display("READ DATA: Data received from RAM[0x%h] -> Expected: 0x5A, Received: 0x%h", ADDR_read, read_data);

read_data=0;

    // read old address result should be 72
@(negedge clk);
    data=10'b1001011001; // old read address
    SS_n=0;
@(negedge clk);
MOSI=1;
 @(negedge clk);
    for (i=0;i<10;i=i+1) begin 
        MOSI= data[9-i]; 
	@(negedge clk); 
    end 
    ADDR_read=dut.slave.rx_data[7:0];  
    SS_n=1;  
    $display("READ ADDR: Requested RAM[0x%h] -> Expected Data: 0x72, Stored Data: 0x%h", ADDR_read, dut.RAM.mem[ADDR_read]);

@(negedge clk);
    SS_n=0;

    data=10'b1100101110;//dummy only 11 is important
@(negedge clk);
MOSI=1;
@(negedge clk); 
    for (i=0;i<10;i=i+1) begin 
        MOSI= data[9-i]; 
	@(negedge clk);  
    end
@(negedge clk);
    for (i=0;i<8;i=i+1) begin 
        read_data={MISO, read_data[7:1]}; 
	@(negedge clk);  
    end
    SS_n=1;
repeat(4) @(negedge clk);

    $display("READ DATA: Data received from RAM[0x%h] -> Expected: 0x72, Received: 0x%h", ADDR_read, read_data);
    $stop; 
end 
endmodule