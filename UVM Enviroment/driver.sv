class driver extends uvm_driver#(transaction);

    `uvm_component_utils(driver)
    virtual if_a bus;

    function new(string name = "driver",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(virtual if_a)::get(this,"","vif",bus))
            `uvm_fatal("DRV VIF ERROR","Could not get virtual interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        //super.run_phase(phase);
        transaction tr;
        forever begin
            seq_item_port.get_next_item(tr);
            drive_item(tr);
            `uvm_info("DRV",$sformatf("current driven values are bus.wr_en = %d | bus.rd_en = %d | bus.datain = %d",bus.wr_en,bus.rd_en,bus.datain),UVM_HIGH)
            seq_item_port.item_done();
        end
    endtask

    task drive_item(transaction tr);
        @(negedge bus.clk)
        bus.wr_en <= tr.wr_en;
		bus.rd_en <= tr.rd_en;
		bus.datain <= tr.datain;
    endtask

    task apply_reset;
        bus.rst_n <= 0;
        @(negedge bus.clk)
        bus.rst_n <= 1;
    endtask

endclass