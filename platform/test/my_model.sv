class my_model extends uvm_component;
    
    `uvm_component_utils(my_model)

    uvm_blocking_get_port #(my_transcation) port;
    uvm_analysis_port #(my_transcation) ap;         //connect to scoreboard

    extern function new(string name="my_model", uvm_component parent=null);
    extern function void build_phase(uvm_phase phase);
    extern virtual task main_phase(uvm_phase phase);
endclass

function my_model::new(string name="my_model", uvm_component parent=null);
    super.new(name, parent);
endfunction

function void my_model::build_phase(uvm_phase phase);
    super.build_phase(phase);
    port = new("port", this);
    ap = new("ap", this);
endfunction

task my_model::main_phase(uvm_phase);
    super.main_phase(phase);

    my_transcation tr;
    my_transcation new_tr;

    while(1) begin
        port.get(tr);   // get tr from agent
        //new_tr = new("new_tr");
        new_tr = my_transcation::type_id::create("new_tr");
        new_tr.my_copy(tr); //method defined in my_transcation
        `uvm_info("my_model","get one transcation, copy and print it:", UVM_LOW);
        new_tr.my_print();  // method defined in my_transcation

        ap.write(new_tr);   // write to scoreboard
    end
endtask


