class exhaustive_sequence extends uvm_sequence #(seq_item);

  `uvm_object_utils(exhaustive_sequence)

  seq_item req;


  function new(string name = "exhaustive_sequence");

    super.new(name);

  endfunction


  virtual task body();

    for (int i = 0; i < 16; i++) begin

      for (int j = 0; j < 16; j++) begin

        req = seq_item::type_id::create("req");

        start_item(req);

        req.a = i;
        req.b = j;

        finish_item(req);

      end

    end

  endtask

endclass