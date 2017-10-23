class simpleadder_driver extends uvm_driver #(simpleadder_transaction);
	`uvm_component_utils(simpleadder_driver)

	protected virtual simpleadder_if vif;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		void'(uvm_resource_db#(virtual simpleadder_if)::read_by_name(.scope("ifs"),.name("simpleadder_if"),.val(vif)));
	endfunction : build_phase

	task  run_phase(uvm_phase phase);
		driver();
	endtask :  run_phase

	virtual task driver();
		simpleadder_transaction sa_tx;
		integer state = 0;
		vif.sig_ina = 0;
		vif.sig_inb = 0;
		vif.sig_en_i = 0;
		forever begin
			if (state == 0)
				seq_item_port.get_next_item(sa_tx);
			@(posedge vif.sig_clock) begin
				case(state)
					0 : begin
						vif.sig_en_i = 1'b1;
						vif.sig_ina = sa_tx.ina[1];
						vif.sig_inb = sa_tx.inb[1];
						sa_tx.ina = sa_tx.ina << 1;
						sa_tx.inb = sa_tx.inb << 1;
						state = 1;
					end
					1 : begin
						vif.sig_en_i = 1'b0;
						vif.sig_ina = sa_tx.ina[1];
						vif.sig_inb = sa_tx.inb[1];
						state = 2;
					end
					2 : begin
						vif.sig_ina = 1'b0;
						vif.sig_inb = 1'b0;
						state = 3;
					end
					3,4: state = state + 1;
					5 : begin
						state = 0;
						seq_item_port.item_done();
					end
				endcase // state
			end
		end
	endtask : driver

endclass : simpleadder_driver 
