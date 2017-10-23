`include "simpleadder_pkg.sv"
`include "simpleadder.v"
`include "simpleadder_if.sv"

module simpleadder_tb_top();
	import uvm_pkg::*;

	//Interface declaration
	simpleadder_if vif();

	//Connects the Interface to the DUT
	simpleadder dut (
		vif.sig_clock,
		vif.sig_en_i,
		vif.sig_ina,
		vif.sig_inb,
		vif.sig_en_o,
		vif.sig_out
	);

	initial begin
		uvm_resource_db#(virtual simpleadder_if)::set
			(.scope("ifs"), .name("simpleadder_if"), .val(vif));
		run_test();
	end

	initial begin
		vif.sig_clock <= 1'b1;
	end

	always
		#5 vif.sig_clock = ~vif.sig_clock;
endmodule