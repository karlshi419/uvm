`timescale 1ns/1ps

import uvm_pkg::*;
`include "my_if.sv"
`include "my_transaction.sv"
`include "my_driver.sv"
`include "my_monitor.sv"
`include "my_agent.sv"
`include "my_env_agent.sv"

module top_tb;
	logic clk, rst_n;
	logic [7:0] rxd;
	logic rx_dv;
	wire [7:0] txd;
	wire tx_en;

	my_if input_if(clk, rst_n);
	my_if output_if(clk,rst_n);

	dut my_dut(	.clk(clk),
           		.rst_n(rst_n), 
           		.rxd(input_if.data),
           		.rx_dv(input_if.valid),
           		.txd(output_if.data),
           		.tx_en(output_if.valid)
    );

	initial begin

		run_test("my_env");

	end

	initial begin
		clk = 0;
		forever #1000 clk=~clk;
	end

	initial begin
		rst_n = 0;
		#1000 rst_n = 1;
	end

	//set virtual interface
	initial begin
		uvm_config_db#(virtual my_if)::set(null,"uvm_test_top.i_agent.drv","vif",input_if);
		uvm_config_db#(virtual my_if)::set(null,"uvm_test_top.i_agent.mon","vif",input_if);
		uvm_config_db#(virtual my_if)::set(null,"uvm_test_top.o_agent.mon","vif",output_if);
	end
endmodule