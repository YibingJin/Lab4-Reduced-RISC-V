module pc_reg(
    input logic clk,
    input logic rst,
    input logic pc_src,
    input logic [31:0] imm,
    output logic [31:0] pc
);

logic [31:0] pc_next;

assign pc_next = pc_src ? (pc+imm) :(pc+4);


always_ff @(posedge clk)
begin
    if(rst)
        pc <= 32'd0;
    else 
        pc <= pc_next;
        
end

endmodule

