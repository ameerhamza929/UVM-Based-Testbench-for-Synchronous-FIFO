class scoreboard #(parameter int width = 8, parameter int depth = 16) extends uvm_scoreboard;
    `uvm_component_utils(scoreboard)
    
    uvm_analysis_imp#(transaction,scoreboard)mn2sc;
    logic [width-1:0] mem_array [$:depth-1];
	logic [$clog2(depth):0] count;	
	logic full,empty,overflow,underflow;
	logic [width-1:0] expected_data;
	int countfail = 0;
	int countunderflow = 0;				
	int countoverflow = 0;
	int countread = 0;
	int countwrite = 0;

    function new(string name = "scoreboard",uvm_component parent);
        super.new(name,parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
         super.build_phase(phase);
         mn2sc = new("mn2sc",this);
         `uvm_info("SC","ENTERING BUILD PHASE",UVM_DEBUG)
    endfunction

    virtual function void write(transaction tr);
            `uvm_info("SC","ENTERING RUN PHASE",UVM_DEBUG)
            Refrence_model(tr);
            if(tr.dataout == expected_data && tr.overflow == overflow && tr.underflow == underflow && tr.empty == empty && tr.full == full)begin
				`uvm_info("PASS ||||",$sformatf("ID = %d, the transaction is wr_en = %d, rd_en = %d,datain = %d, while  exp_full = %d and act_full = %d | exp_empty = %d and act_empty = %d | exp_overflow = %d and act_overflow = %d | exp_underflow = %d and act_underflow = %d | exp_dataout = %d and act_dataout = %d",tr.id,tr.wr_en,tr.rd_en,tr.datain, full,tr.full,empty,tr.empty,overflow,tr.overflow,underflow,tr.underflow, expected_data,tr.dataout),UVM_LOW);

			end  	
			else begin
				countfail++;
				`uvm_info("FAIL ||||", $sformatf("ID = %d, the transaction is wr_en = %d, rd_en = %d,datain = %d, while  exp_full = %d and act_full = %d | exp_empty = %d and act_empty = %d | exp_overflow = %d and act_overflow = %d | exp_underflow = %d and act_underflow = %d | exp_dataout = %d and act_dataout = %d",tr.id,tr.wr_en,tr.rd_en,tr.datain, full,tr.full,empty,tr.empty,overflow,tr.overflow,underflow,tr.underflow, expected_data,tr.dataout),UVM_LOW);
			end
    endfunction

    task Refrence_model(transaction tr);
            if(!tr.rst_n)begin
				count = 0;
				full = 0;
				empty = 1;
				overflow = 0;
				underflow = 0;
				expected_data = 0;
			end
			else begin
				if(tr.wr_en && !full)begin			
					mem_array.push_front(tr.datain);
					count++;
					expected_data = expected_data;
					countwrite++;
				end
				else if(tr.rd_en && !empty)begin
					expected_data = mem_array.pop_back();
					count--;
					countread++;
				end
				if(tr.rd_en && empty) begin underflow = 1; countunderflow++; end
				else underflow = 0;
				if(tr.wr_en && full) begin overflow = 1; countoverflow++; end
				else overflow = 0;
				if(mem_array.size == 0) empty = 1;
				else empty = 0;
				if(mem_array.size == depth) full = 1;
				else full = 0;
				
				
			end
    endtask

    virtual function void report_phase(uvm_phase phase);
        `uvm_info("[RP]","====================== FINAL REPORT ======================",UVM_LOW)
        `uvm_info("NO. OF FAILS      = ",$sformatf("%d",countfail),UVM_LOW)
        `uvm_info("NO. OF OVERFLOWS  = ",$sformatf("%d",countoverflow),UVM_LOW)
        `uvm_info("NO. OF UNDERFLOWS = ",$sformatf("%d",countunderflow),UVM_LOW)
        `uvm_info("NO. OF READS      = ",$sformatf("%d",countread),UVM_LOW)
        `uvm_info("NO. OF WRITES     = ",$sformatf("%d",countwrite),UVM_LOW)
    endfunction

endclass

