module register_file #(
    parameter  ADDRESS_WIDTH = 9,
               DATA_WIDTH = 8
)(
    input logic                       clk,
    input logic                       wr_en,
    input logic  [ADDRESS_WIDTH-1:0]  rd_addr1,
    input logic  [ADDRESS_WIDTH-1:0]  rd_addr2,
    input logic  [ADDRESS_WIDTH-1:0]  wr_addr3,
    input logic  [DATA_WIDTH-1:0]     din,
    output logic  [DATA_WIDTH-1:0]     dout1,
    output logic  [DATA_WIDTH-1:0]     dout2,
    output logic  [DATA_WIDTH-1:0]     dout3

);

logic [DATA_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

assign dout1 = (rd_addr1=='h0) ? 32'h0:ram_array[rd_addr1];   

assign dout2 = (rd_addr2=='h0) ? 32'h0:ram_array[rd_addr2];   

assign dout3 = ram_array[11];


always_ff @(posedge clk) begin

    if(wr_en == 1'b1)
    begin
        if(wr_addr3!='h0)
            ram_array[wr_addr3] <= din;
    end
  
end


endmodule