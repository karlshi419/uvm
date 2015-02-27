class my_agent extends uvm_agent;
	`uvm_component_utils(my_agent)

	my_driver 	drv;
	my_monitor 	mon;

	function new(string name="my_agent", uvm_component parent=null);
		super.new(name, parnet);
	endfunction

	extern virtual function void build_phase(uvm_phase phase);
	extern virtual function void connect_phase(uvm_phase phase);

endclass

function void my_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(is_active == UVM_ACTIVE) begin
		drv = my_driver::type_id::create("drv", this);
	end
	mon = my_monitor::type_id::create("mon", this);
endfunction

function void my_agent::connect_phase(uvm_phase phase);
	super.connect_phase(phase);
endfunction


