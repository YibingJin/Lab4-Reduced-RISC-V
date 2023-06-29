module alu #(
 parameter   DATA_WIDTH = 32
)
(
    input logic [DATA_WIDTH-1:0]       operand1,
    input logic [DATA_WIDTH-1:0]       operand2,
    input logic [2:0]                  alu_ctrl,
    output logic [DATA_WIDTH-1:0]      alu_out,
    output logic                       eq
);

parameter ADDI_OP = 7'b0010011;
parameter BNE_OP = 7'b1100011;
parameter ADDI_FUNC3 = 3'b000;
parameter BNE_FUNC3 = 3'b001;
parameter alu_add = 3'd0;
parameter alu_subtract =3'd1;

assign alu_out = operand1+operand2;//(alu_ctrl==alu_add) ? operand1+operand2 : operand1-operand2;
//assign eq = ((alu_ctrl==alu_subtract)&&(alu_out==0))? 1'b1 : 1'b0;
assign eq = (operand1==operand2);
                 




endmodule