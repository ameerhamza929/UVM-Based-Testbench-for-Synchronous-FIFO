class sequenced extends uvm_sequence#(transaction);
    
    `uvm_object_utils(sequenced)

    function new(string name = "sequenced");
        super.new(name);
    endfunction

    virtual task body();
        transaction tr;
        for(int i = 0; i<1000; i++)begin
            tr = transaction::type_id::create("tr");
            start_item(tr);
            void'(tr.randomize());
           // `uvm_info("SEQ1",$sformatf("tr = %p",tr),UVM_LOW)
            finish_item(tr);
        end

    endtask


endclass