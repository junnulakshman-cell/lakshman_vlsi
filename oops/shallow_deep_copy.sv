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

  // Declare two handles to outer transaction objects
  axi_txn_t tr1, tr2;

  initial begin

    // ==========================================
    // TEST 1: SHALLOW COPY
    // ==========================================

    // Create two independent outer objects
    tr1 = new();
    tr2 = new();

    // Create a nested object for tr2
    tr2.tr = new();

    // Initialize the source transaction
    tr2.addr = 'hAF;
    tr2.tr.data = 'hBD;

    // Copy tr2's address value and nested class handle into tr1
    tr1.shallow_copy(tr2);

    // Modify only tr1's address property
    tr1.addr = 'hFE;

    // Modify the shared nested object's data through tr2
    tr2.tr.data = 'hFC;

    $display("=== SHALLOW COPY ===");

    // tr1 has its own address but shares the nested object
    $display("tr1 addr=%h data=%h",
             tr1.addr, tr1.tr.data);

    // tr2's address remains AF; shared data is now FC
    $display("tr2 addr=%h data=%h",
             tr2.addr, tr2.tr.data);

    // Expected:
    // tr1 addr=00fe data=00fc
    // tr2 addr=00af data=00fc

    // ==========================================
    // TEST 2: DEEP COPY
    // ==========================================

    // Create fresh outer objects for an independent test
    tr1 = new();
    tr2 = new();

    // Allocate separate nested objects initially
    tr1.tr = new();
    tr2.tr = new();

    // Initialize the source transaction
    tr2.addr = 'hAF;
    tr2.tr.data = 'hBD;

    // Copy the address and create a separate nested object in tr1
    tr1.deep_copy(tr2);

    // Modify tr1's address
    tr1.addr = 'hFE;

    // Modify only tr2's nested object
    tr2.tr.data = 'hFC;

    $display("=== DEEP COPY ===");

    // tr1's nested data remains BD because it is independent
    $display("tr1 addr=%h data=%h",
             tr1.addr, tr1.tr.data);

    // tr2 contains the updated values
    $display("tr2 addr=%h data=%h",
             tr2.addr, tr2.tr.data);

    // Expected:
    // tr1 addr=00fe data=00bd
    // tr2 addr=00af data=00fc

    // ==========================================
    // TEST 3: CLASS HANDLE ASSIGNMENT
    // ==========================================

    // Create one outer object and its nested object
    tr1 = new();
    tr1.tr = new();

    // Initialize the object accessed through tr1
    tr1.addr = 'hAF;
    tr1.tr.data = 'hBD;

    // Copy the outer class handle.
    // No new outer object is created.
    // tr1 and tr2 now refer to the SAME outer object.
    tr2 = tr1;

    // Modify the shared outer object's address through tr2
    tr2.addr = 'h23;

    // Modify the nested object's data through tr2
    tr2.tr.data = 'h12;

    $display("=== HANDLE ASSIGNMENT ===");

    // Both handles see the same outer object and nested data
    $display("tr1 addr=%h data=%h",
             tr1.addr, tr1.tr.data);

    $display("tr2 addr=%h data=%h",
             tr2.addr, tr2.tr.data);

    // Expected:
    // tr1 addr=0023 data=0012
    // tr2 addr=0023 data=0012

    // End simulation
    $finish;

  end

endmodule
