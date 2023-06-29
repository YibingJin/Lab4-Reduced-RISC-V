module top(
    input logic clk,
    input logic rst,
    output logic [31:0] result,
    output logic [2:0]  alu_ctrl,
    output logic [31:0] alu_op1,
    output logic [31:0] alu_op2,
    output logic [31:0] imm_op,
    output logic [11:0] imm,
    output logic [31:0] instr,
    output logic pc_src,
    output logic [31:0] pc,
    output logic [1:0]imm_src
    

);


logic [4:0] rd,rs1,rs2;
logic [6:0] op;
logic [2:0] funct3;
//logic [31:0] instr;
//logic [11:0] imm;
//logic [31:0] imm_op;
//logic [31:0] pc;
logic [31:0] alu_out;


logic [31:0] reg_op2;
//logic [31:0] result;
logic eq;
logic reg_write;
//logic alu_ctrl;
logic alu_src;





pc_reg pc_counter(
    .clk(clk),
    .rst(rst),
    .pc_src(pc_src),
    .imm(imm_op),
    .pc(pc)
);

instr_mem  instruction(
    .clk(clk),
    .rd_addr(pc),
    .dout(instr)
);

assign imm = (instr[6:0]==7'b0010011) ? instr[31:20] : {instr[31],instr[7],instr[30:25],instr[11:8]};


sign_extend extension(
    .instr(instr),
    .imm_src(imm_src),
    .imm_op(imm_op)
);



register_file  reg_group(
    .clk(clk),
    .wr_en(reg_write),
    .rd_addr1(instr[19:15]),
    .rd_addr2(instr[24:20]),
    .wr_addr3(instr[11:7]),
    .din(alu_out),
    .dout1(alu_op1),
    .dout2(reg_op2),
    .dout3(result)
);

assign alu_op2 = alu_src ? imm_op : reg_op2;

alu cpu_alu(
    .operand1(alu_op1),
    .operand2(alu_op2),
    .alu_ctrl(alu_ctrl),
    .alu_out(alu_out),
    .eq(eq)
);

control_unit controller(
    .instr(instr),
    .eq(eq),
    .reg_write(reg_write),
    .alu_ctrl(alu_ctrl),
    .alu_src(alu_src),
    .imm_src(imm_src),
    .pc_src(pc_src)
);


endmodule
