class my_monitor extends uvm_monitor;

	virtual my_if vif;

	//factory machanism
	`uvm_component_utils(my_monitor)

	function new(string name="my_monitor", uvm_component parent = null);
		super.new(name,parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(virtual my_if)::get(this,"","vif",vif))
			`uvm_fatal("my_monitor","virtual interface must be set for vif!");
	endfunction

	extern task main_phase(uvm_phase phase);
	extern task collect_one_pkt(my_transaction tr);

endclass

task my_monitor::main_phase(uvm_phase phase);
	my_transaction tr;
	//phase.raise_objection(this);
	while(1) begin
		tr = new("tr");
		collect_one_pkt(tr);
	end

endtask

task my_monitor::collect_one_pkt(my_transaction tr);
		bit [7:0] data_q[$];
		int psize;
		// wait for data valid
		while(1) begin
			@(posedge vif.clk);
			if(vif.valid)	break;
		end

		`uvm_info("my_monitor","Start to collect one pkt",UVM_LOW);
		while(vif.valid) begin
			// collect data into queue
			data_q.push_back(vif.data);
			@(posedge vif.clk);
		end

		//pop dmac
		for(int i=0; i<6; i++) begin
			tr.dmac = {tr.dmac[39:0], data_q.pop_front()};
		end

		//pop smac
		for(int i=0; i<6; i++) begin
			tr.smac = {tr.smac[39:0], data_q.pop_front()};
		end

		//pop ether_type 
		for(int i=0; i<2; i++) begin
			tr.ether_type = {tr.ether_type[7:0], data_q.pop_front()};
		end

		//pop payload
		for(int i=0; i< tr.pload.size; i++) begin
			tr.pload[i] = data_q.pop_front();
		end

		//pop crc
		for(int i=0; i<4; i++) begin
			tr.crc = {tr.crc[23:0], data_q.pop_front()};
		end

		`uvm_info("my_monitor","collection one package finished", UVM_LOW);

		tr.my_print();

endtask
	



	//phase.drop_objection(this);

