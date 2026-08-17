class sequencered extends uvm_sequencer#(transaction);
    
    `uvm_component_utils(sequencered)

    function new(string name = "sequencered",uvm_component parent);
        super.new(name,parent);
    endfunction

endclass