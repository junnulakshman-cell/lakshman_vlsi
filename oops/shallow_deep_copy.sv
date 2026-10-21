class axi_txn;
  // Nested class containing transaction data
  logic [15:0] data;
endclass

class axi_txn_t;

  // Class handle: points to an axi_txn object
  axi_txn tr;

  // Normal value property: stores a 16-bit address
  logic [15:0] addr;

  // ==========================================
  // SHALLOW COPY
  // ==========================================
  function void shallow_copy(axi_txn_t rhs);

    // Copy the address VALUE.
    // The source and destination have independent addr properties.
    addr = rhs.addr;

    // Copy the class HANDLE, not the nested object itself.
    // Both outer objects now point to the same axi_txn object.
    tr = rhs.tr;

  endfunction

  // ==========================================
  // DEEP COPY
  // ==========================================
  function void deep_copy(axi_txn_t rhs);

    // Copy the address value into this outer object.
    addr = rhs.addr;

    // Allocate a NEW nested axi_txn object.
    // This prevents sharing the nested object with rhs.
    tr = new();

    // Copy the data value into the newly created object.
    tr.data = rhs.tr.data;

  endfunction

endclass

module tb;

  axi_txn_t tr1, tr2;

  initial begin

    // TEST 1: SHALLOW COPY
    tr1 = new();
    tr2 = new();
    tr2.tr = new();

    tr2.addr = 'hAF;
    tr2.tr.data = 'hBD;

    tr1.shallow_copy(tr2);

    tr1.addr = 'hFE;
    tr2.tr.data = 'hFC;

    $display("=== SHALLOW COPY ===");
    $display("tr1 addr=%h data=%h", tr1.addr, tr1.tr.data);
    $display("tr2 addr=%h data=%h", tr2.addr, tr2.tr.data);

    // TEST 2: DEEP COPY
    tr1 = new();
    tr2 = new();
    tr1.tr = new();
    tr2.tr = new();

    tr2.addr = 'hAF;
    tr2.tr.data = 'hBD;

    tr1.deep_copy(tr2);

    tr1.addr = 'hFE;
    tr2.tr.data = 'hFC;

    $display("=== DEEP COPY ===");
    $display("tr1 addr=%h data=%h", tr1.addr, tr1.tr.data);
    $display("tr2 addr=%h data=%h", tr2.addr, tr2.tr.data);

    // TEST 3: HANDLE ASSIGNMENT
    tr1 = new();
    tr1.tr = new();
    tr1.addr = 'hAF;
    tr1.tr.data = 'hBD;

    tr2 = tr1;

    tr2.addr = 'h23;
    tr2.tr.data = 'h12;

    $display("=== HANDLE ASSIGNMENT ===");
    $display("tr1 addr=%h data=%h", tr1.addr, tr1.tr.data);
    $display("tr2 addr=%h data=%h", tr2.addr, tr2.tr.data);

    $finish;
  end

endmodule
