class tested extends uvm_test;

  `uvm_component_utils(tested)

  enviroment env;

  function new(string name = "tested", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    env = enviroment::type_id::create("env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    sequenced seq1;
    `uvm_info("TEST","ENTERING TEST RUN",UVM_LOW)
    phase.raise_objection(this);

    seq1 = sequenced::type_id::create("seq1");

    env.a0.drv.apply_reset();

    seq1.start(env.a0.seq);

    phase.drop_objection(this);
  endtask

endclass