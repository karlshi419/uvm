class my_env extends uvm_env;
	
	//factory automation
	`uvm_component_utils(my_env)
	
	my_agent i_agent;
	my_agent o_agent;

	function new(string name = "my_env", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		//type_name::type_id::create, can only be used for factory machanism
		i_agent = my_agent::type_id::create("i_agent", this);
		o_agent = my_agent::type_id::create("o_agent", this);
		i_agent.is_active = UVM_ACTIVE;
		o_agent.is_active = UVM_PASSIVE;
	endfunction



endclass
