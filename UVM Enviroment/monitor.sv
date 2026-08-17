class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    virtual if_a vif;
    uvm_analysis_port#(transaction)mn2sc;

    function new(string name ="monitor",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mn2sc = new("mn2sc",this);
        if(!uvm_config_db#(virtual if_a)::get(this,"","vif",vif))
            `uvm_fatal("MON VIF ERROR","Could not get virtual interface")
    endfunction

    virtual task run_phase(uvm_phase phase);
        forever begin
            transaction tr;
            @(posedge vif.clk)
            #0.5ns
            `uvm_info("MON",$sformatf("Current Interface values are rst_n = %d | wr_en = %d | rd_en = %d | datain = %d | dataout = %d | full = %d | empty = %d | overflow = %d | underflow = %d | count = %d",vif.rst_n,vif.wr_en,vif.rd_en,vif.datain,vif.dataout,vif.full,vif.empty,vif.overflow,vif.underflow,vif.count),UVM_MEDIUM);
            tr = transaction::type_id::create("tr");
            tr.rst_n = vif.rst_n;
            tr.wr_en = vif.wr_en;
            tr.rd_en = vif.rd_en;
            tr.datain = vif.datain;
            tr.dataout = vif.dataout;
            tr.full    = vif.full;
            tr.empty  = vif.empty;
            tr.overflow = vif.overflow;
            tr.underflow = vif.underflow;
            //tr.count = vif.count;
            mn2sc.write(tr);
        end
    endtask

endclass