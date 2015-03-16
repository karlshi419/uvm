class my_env extends uvm_env;
	
	//factory automation
	`uvm_component_utils(my_env)
	
	my_agent i_agent;
	my_agent o_agent;

	uvm_tlm_analysis_fifo #(my_transcation) agt_mdl_fifo;		//connect my_model and my_monitor (i_agent)

	extern function new(string name = "my_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);


endclass

function my_env::new(string name = "my_env", uvm_component parent = null);
	super.new(name, parent);
endfunction
	
function void my_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	//type_name::type_id::create, can only be used for factory machanism
	i_agent = my_agent::type_id::create("i_agent", this);
	o_agent = my_agent::type_id::create("o_agent", this);
	i_agent.is_active = UVM_ACTIVE;
	o_agent.is_active = UVM_PASSIVE;
	// create fifo
	agt_mdl_fifo = new("agt_mdl_fifo", this);
endfunction

function void my_env::connect_phase(uvm_phase);
	super.connect_phase(phase);

	i_agent.ap.connect(agt_mdl_fifo.analysis_export);
	mdl.port.connect(agt_mdl_fifo.blocking_get_export);

endfunction


