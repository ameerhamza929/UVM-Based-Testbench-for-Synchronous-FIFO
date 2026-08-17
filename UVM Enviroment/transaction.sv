class transaction#(parameter int width=8) extends uvm_sequence_item;
	rand bit wr_en,rd_en;
	logic full, empty, overflow, underflow,rst_n;
	randc bit [width-1:0] datain;
	logic [width-1:0] dataout;
	int id;
	static int transactionid = 0;
    
    `uvm_object_utils(transaction)

    function new(string name = "AMEER");
        super.new(name);
        id = transactionid++;
    endfunction



    task display;
		$display("ID = %d, the transaction is wr_en = %d, rd_en = %d, full = %d, empty = %d, overflow = %d, underflow = %d, datain = %d, dataout = %d",id,wr_en,rd_en,full, empty, overflow, underflow, datain,dataout);
	endtask

	constraint c1 {datain inside {[0:100]};
			datain%2 ==0; }
	constraint c2 { wr_en != rd_en; }

endclass