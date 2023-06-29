module sign_extend(
    input logic [31:0] instr,
    input logic [1:0]    imm_src,
    output logic [31:0] imm_op
);

//assign imm = (instr[6:0]==7'b0010011) ? instr[31:20] : {instr[31],instr[7],instr[30:25],instr[11:8]};

assign imm_op = (imm_src==2'b00) ? {{20{instr[31]}},instr[31:20]} :
                (imm_src==2'b10) ? {{21{instr[31]}},instr[7],instr[30:25],instr[11:8]} : 32'd0; 


endmodule

