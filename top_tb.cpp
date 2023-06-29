#include "verilated.h"
#include "verilated_vcd_c.h"
#include "Vtop.h"
#include "vbuddy.cpp"     // include vbuddy code
#define MAX_SIM_CYC 600

int main(int argc, char **argv, char **env) {
  int simcyc;     // simulation clock count
  int tick;       // each clk cycle has two ticks for two edges
  int lights = 0; // state to toggle LED lights

  Verilated::commandArgs(argc, argv);
  // init top verilog instance
  Vtop * top = new Vtop;
  // init trace dump
  Verilated::traceEverOn(true);
  VerilatedVcdC* tfp = new VerilatedVcdC;
  top->trace (tfp, 99);
  tfp->open ("risc-v.vcd");
 
  // init Vbuddy
  if (vbdOpen()!=1) return(-1);
  vbdHeader("L4:risc-v");
  vbdSetMode(1);        // Flag mode set to one-shot

  // initialize simulation inputs
  top->clk = 1;
  top->rst = 0;
  //top->en = 1;
  //top->N = vbdValue();
  
  // run simulation for MAX_SIM_CYC clock cycles
  for (simcyc=0; simcyc<MAX_SIM_CYC; simcyc++) {
    // dump variables into VCD file and toggle clock
    for (tick=0; tick<2; tick++) {
      tfp->dump (2*simcyc+tick);
      top->clk = !top->clk;
      top->eval ();
    }

    // Display toggle neopixel
    // if (top->tick) {
    //   vbdBar(lights);
    //   lights = lights ^ 0xFF;
    // }

            // ------send count value to buddy
    vbdHex(4,(int(top->result)>>12)&0xF);
    vbdHex(3,(int(top->result)>>8)&0xF);
    vbdHex(2,(int(top->result)>>4)&0xF);
    vbdHex(1,(int(top->result))&0xF);
    vbdBar(top->result & 0xFF);
    //  printf("instr:%x, \r\n",top->instr);
    //  printf("pc:%x, \r\n",top->pc);
    // printf("imm:%x,\r\n",top->imm);
    // printf("imm_op:%x,\r\n",top->imm_op);
    // printf("imm_src:%x,\r\n",top->imm_src);
    // printf("result:%d,\r\n",top->result);
    // printf("------------------------------------\r\n");

    // set up input signals of testbench
    top->rst = (simcyc < 4);    // assert reset for 1st cycle
    //top->en = (simcyc > 2);
    //top->N = vbdValue();
    vbdCycle(simcyc);

    if (Verilated::gotFinish())  exit(0);
  }

  vbdClose();     // ++++
  tfp->close(); 
  exit(0);
}
