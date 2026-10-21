class Base_Transactions;
    logic [15:0] data;
    logic [31:0] addr;
    logic [2:0]  id;
    logic [2:0]  burst_len;
    logic [2:0]  burst_size;

    function new(logic [15:0] data,
                 logic [31:0] addr,
                 logic [2:0]  id,
                 logic [2:0]  burst_len,
                 logic [2:0]  burst_size);
        this.data = data;
        this.addr = addr;
        this.id = id;
        this.burst_len = burst_len;
        this.burst_size = burst_size;
    endfunction

    virtual function void axi_txn();
        $display("BASE->\nDATA = %0d\nADDR = %0d\nID = %0d\nBURST_LEN = %0d\nBURST_SIZE = %0d",
                 data, addr, id, burst_len, burst_size);
    endfunction
endclass

class Axi_write_transactions extends Base_Transactions;
    logic [15:0] w_data;
    logic [31:0] aw_addr;
    logic [1:0]  b_resp;

    function new(logic [15:0] w_data,
                 logic [31:0] aw_addr,
                 logic [1:0]  b_resp,
                 logic [15:0] data,
                 logic [31:0] addr,
                 logic [2:0]  id,
                 logic [2:0]  burst_len,
                 logic [2:0]  burst_size);
        super.new(data, addr, id, burst_len, burst_size);
        this.w_data = w_data;
        this.aw_addr = aw_addr;
        this.b_resp = b_resp;
    endfunction

    virtual function void axi_txn();
        $display("AXI-WRITE_TRANS->\nWRITE_DATA = %0d\nWRITE_ADDR = %0d\nID = %0d\nBURST_LEN = %0d\nWRITE_RESP = %0d",
                 w_data, aw_addr, id, burst_len, b_resp);
    endfunction
endclass

class Axi_read_transactions extends Base_Transactions;
    logic [15:0] r_data;
    logic [31:0] ar_addr;
    logic [1:0]  r_resp;

    function new(logic [15:0] r_data,
                 logic [31:0] ar_addr,
                 logic [1:0]  r_resp,
                 logic [15:0] data,
                 logic [31:0] addr,
                 logic [2:0]  id,
                 logic [2:0]  burst_len,
                 logic [2:0]  burst_size);
        super.new(data, addr, id, burst_len, burst_size);
        this.r_data = r_data;
        this.ar_addr = ar_addr;
        this.r_resp = r_resp;
    endfunction

    virtual function void axi_txn();
        $display("READ_TRAN->\nREAD_DATA = %0d\nREAD_ADDR = %0d\nID = %0d\nBURST_LEN = %0d\nREAD_RESP = %0d",
                 r_data, ar_addr, id, burst_len, r_resp);
    endfunction
endclass

module tb;
    Base_Transactions tr_b;
    Axi_write_transactions tr_w;
    Axi_read_transactions tr_r;

    initial begin
        // Create a write transaction object
        tr_w = new(16'd23, 32'd34, 2'd1,
                   16'd23, 32'd34, 3'd3, 3'd2, 3'd3);

        if ($cast(tr_b, tr_w))
            $display("casting is successful\n");
        else
            $display("casting is failed\n");

        tr_b.axi_txn();

        // Create a read transaction object
        tr_r = new(16'd24, 32'd33, 2'd5,
                   16'd2, 32'd1, 3'd3, 3'd4, 3'd7);

        if ($cast(tr_b, tr_r))
            $display("casting is successful\n");
        else
            $display("casting is failed\n");

        tr_b.axi_txn();

        $finish;
    end
endmodule
