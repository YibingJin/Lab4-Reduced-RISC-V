module instr_mem #(
    parameter  ADDRESS_WIDTH = 10,
               DATA_WIDTH = 32
)(
    input logic                       clk,
    input logic  [ADDRESS_WIDTH-1:0]  rd_addr,
    output logic  [DATA_WIDTH-1:0]     dout
);


logic [DATA_WIDTH-1:0] ram_array [2**ADDRESS_WIDTH-1:0];

initial begin

    $display("loading ram");
    $readmemh("instruction.mem",ram_array);

end

logic [ADDRESS_WIDTH-1:0] addr;
assign addr = rd_addr>>2;

assign dout = ram_array[addr];



endmodule
