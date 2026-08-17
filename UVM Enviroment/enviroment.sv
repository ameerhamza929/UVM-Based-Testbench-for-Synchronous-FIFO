class enviroment extends uvm_env;
    `uvm_component_utils(enviroment)

    agent a0;
    scoreboard s0;

    function new(string name = "enviroment",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        a0 = agent::type_id::create("a0",this);
        s0 = scoreboard::type_id::create("s0",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        a0.mn.mn2sc.connect(s0.mn2sc);
    endfunction

    
endclass