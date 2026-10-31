// ============================================================================
// File: Multi_Channel_Signal_Scheduler_Corrected.sv
// Description:
//   Corrected SystemVerilog CRV example for a 4-channel signal scheduler.
//   Generates legal baseline values and selected invalid values based on err[].
//
// Notes:
//   * channel_id, clock_domain, mode, and phase are channel-level arrays (4).
//   * amplitude, sample_period, frequency_mhz, priority_level, sample_count
//     are signal/sample-level arrays (16).
//   * err[] contains 8 fault selectors. Signal-level arrays use err[i%8].
//   * The checks printed here validate generated stimulus; they do not verify
//     a DUT response. Add a driver, monitor, and scoreboard for DUT checking.
// ============================================================================

typedef enum bit [1:0] {
  NORMAL = 0,
  BURST  = 1,
  IDLE   = 2,
  ERROR  = 3
} signal_mode_e;

typedef enum bit [2:0] {
  NONE,
  BAD_ID,
  BAD_AMP,
  BAD_SAMP_PE,
  BAD_FREQ,
  BAD_PHAS,
  BAD_CLK,
  BAD_MODE
} inject_errors;


class Multi_Channel_Signal_Scheduler;

  // Channel-level random fields (4 channels).
  rand bit [2:0] channel_id[];
  rand bit [2:0] clock_domain[];
  rand signal_mode_e mode[];
  rand int phase[];

  // Signal/sample-level random fields (16 entries).
  rand bit [8:0] amplitude[];
  rand int sample_period[];
  rand int frequency_mhz[];
  rand bit [2:0] priority_level[];
  rand int sample_count[];

  // Eight fault selectors, used by signal-level fields through i%8.
  rand inject_errors err[];

  // Optional control field retained from the original example.
  rand bit inject_error;


  // --------------------------------------------------------------------------
  // Constructor: allocate all dynamic arrays.
  // --------------------------------------------------------------------------
  function new();
    channel_id     = new[4];
    clock_domain   = new[4];
    mode           = new[4];
    phase          = new[4];

    amplitude      = new[16];
    sample_period  = new[16];
    frequency_mhz  = new[16];
    priority_level = new[16];
    sample_count   = new[16];

    err            = new[8];
  endfunction


  // --------------------------------------------------------------------------
  // Constraint: exact array sizes.
  // --------------------------------------------------------------------------
  constraint c_sizes {
    channel_id.size()     == 4;
    clock_domain.size()   == 4;
    mode.size()           == 4;
    phase.size()          == 4;

    amplitude.size()      == 16;
    sample_period.size()  == 16;
    frequency_mhz.size()  == 16;
    priority_level.size() == 16;
    sample_count.size()   == 16;

    err.size()            == 8;
  }


  // --------------------------------------------------------------------------
  // Constraint: each err[] element must be a declared fault value.
  // --------------------------------------------------------------------------
  constraint err_c {
    foreach (err[i])
      err[i] inside {
        NONE, BAD_ID, BAD_AMP, BAD_SAMP_PE,
        BAD_FREQ, BAD_PHAS, BAD_CLK, BAD_MODE
      };
  }


  // --------------------------------------------------------------------------
  // Constraint: channel ID.
  // Normal channel IDs are 0..3. BAD_ID allows an invalid ID 4..7.
  // Only the first four err entries map to the four channel IDs.
  // --------------------------------------------------------------------------
  constraint channel_range_c {
    foreach (channel_id[i]) {
      if (err[i] == BAD_ID)
        channel_id[i] inside {[4:7]};
      else
        channel_id[i] inside {[0:3]};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: amplitude.
  // BAD_AMP: 256..500. NORMAL mode: 0. Other modes: 1..255.
  // --------------------------------------------------------------------------
  constraint amplitude_range_c {
    foreach (amplitude[i]) {
      if (err[i%8] == BAD_AMP)
        amplitude[i] inside {[256:500]};
      else if (mode[i%4] == NORMAL)
        amplitude[i] == 0;
      else
        amplitude[i] inside {[1:255]};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: sample period.
  // BAD_SAMP_PE: 21..26.
  // BURST mode: 1..4.
  // NORMAL mode: 5..20.
  // IDLE/ERROR mode: 1..20.
  // --------------------------------------------------------------------------
  constraint sample_period_range_c {
    foreach (sample_period[i]) {
      if (err[i%8] == BAD_SAMP_PE)
        sample_period[i] inside {[21:26]};
      else if (mode[i%4] == BURST)
        sample_period[i] inside {[1:4]};
      else if (mode[i%4] == NORMAL)
        sample_period[i] inside {[5:20]};
      else
        sample_period[i] inside {[1:20]};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: phase.
  // A BAD_PHAS error uses a non-legal phase set.
  // The phase array is channel-level, so err[0..3] selects its faults.
  // --------------------------------------------------------------------------
  constraint phase_range_c {
    foreach (phase[i]) {
      if (err[i] == BAD_PHAS)
        phase[i] inside {30, 45, 60, 120};
      else
        phase[i] inside {0, 90, 180, 270};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: frequency in MHz.
  // BAD_FREQ: 101..201 (outside the normal 1..100 range).
  // --------------------------------------------------------------------------
  constraint frequency_range_c {
    foreach (frequency_mhz[i]) {
      if (err[i%8] == BAD_FREQ)
        frequency_mhz[i] inside {[101:201]};
      else
        frequency_mhz[i] inside {[1:100]};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: legal mode enum values.
  // Since mode is typed signal_mode_e, this is explicit documentation and
  // keeps the intended legal enum set visible.
  // --------------------------------------------------------------------------
  constraint mode_types_c {
    foreach (mode[i])
      mode[i] inside {NORMAL, BURST, IDLE, ERROR};
  }


  // --------------------------------------------------------------------------
  // Constraint: priority level 0..7.
  // --------------------------------------------------------------------------
  constraint priority_range_c {
    foreach (priority_level[i])
      priority_level[i] inside {[0:7]};
  }


  // --------------------------------------------------------------------------
  // Constraint: clock domain.
  // BAD_CLK: 4..7. Otherwise 0..3.
  // Clock domains are channel-level; err[0..3] selects their faults.
  // --------------------------------------------------------------------------
  constraint clock_domain_c {
    foreach (clock_domain[i]) {
      if (err[i] == BAD_CLK)
        clock_domain[i] inside {[4:7]};
      else
        clock_domain[i] inside {[0:3]};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: sample count 1..16.
  // --------------------------------------------------------------------------
  constraint sample_count_range_c {
    foreach (sample_count[i])
      sample_count[i] inside {[1:16]};
  }


  // --------------------------------------------------------------------------
  // Constraint: channel IDs are unique.
  // With four legal IDs (0..3), this makes the four normal IDs a permutation.
  // If BAD_ID is active, its ID is constrained to 4..7 and remains unique.
  // --------------------------------------------------------------------------
  constraint unique_channel_id_c {
    unique {channel_id};
  }


  // --------------------------------------------------------------------------
  // Constraint: exactly one BURST and exactly one IDLE mode.
  // Corrected from the original expressions that compared each item against
  // mode[1] and mode[2], rather than against the enum constants.
  // --------------------------------------------------------------------------
  constraint burst_idle_mode_c {
    mode.sum() with (int'(item == BURST)) == 1;
    mode.sum() with (int'(item == IDLE))  == 1;
  }


  // --------------------------------------------------------------------------
  // Constraint: high priority (6 or 7) selects channel ID 0 or 1.
  // Signal entries map to channel-level arrays using i%4.
  // --------------------------------------------------------------------------
  constraint priority_selects_c {
    foreach (priority_level[i]) {
      if (priority_level[i] inside {6, 7})
        channel_id[i%4] inside {0, 1};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: high priority selects clock domain 0 or 1.
  // --------------------------------------------------------------------------
  constraint priority_select_clk_c {
    foreach (priority_level[i]) {
      if (priority_level[i] inside {6, 7})
        clock_domain[i%4] inside {0, 1};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: amplitude/frequency cross constraints.
  // These implications are retained from the submitted example.
  // --------------------------------------------------------------------------
  constraint frequency_amplitude_cross_c {
    foreach (frequency_mhz[i]) {
      (amplitude[i] > 200) -> (frequency_mhz[i] <= 50);
      (frequency_mhz[i] > 80) -> (amplitude[i] <= 100);
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: clock domains are unique.
  // This already guarantees clock_domain[0] != clock_domain[1], so the
  // separate differnt_clk constraint from the original is redundant.
  // --------------------------------------------------------------------------
  constraint unique_clock_domain_c {
    unique {clock_domain};
  }


  // --------------------------------------------------------------------------
  // Constraint: phase values are unique.
  // --------------------------------------------------------------------------
  constraint unique_phase_c {
    unique {phase};
  }


  // --------------------------------------------------------------------------
  // Constraint: ERROR mode is assigned only channel ID 0 or 1.
  // --------------------------------------------------------------------------
  constraint error_mode_channel_c {
    foreach (mode[i]) {
      if (mode[i] == ERROR)
        channel_id[i] inside {0, 1};
    }
  }


  // --------------------------------------------------------------------------
  // Constraint: exactly one each of BAD_ID, BAD_AMP, and BAD_PHAS in err[].
  // Remaining err entries may be any declared mode, including NONE.
  // --------------------------------------------------------------------------
  constraint required_fault_counts_c {
    err.sum() with (int'(item == BAD_ID))   == 1;
    err.sum() with (int'(item == BAD_AMP))  == 1;
    err.sum() with (int'(item == BAD_PHAS)) == 1;
  }

  // BAD_ID and BAD_PHAS affect channel-level arrays of size 4. Their selector
  // must therefore be among err[0:3], not only in err[4:7].
  constraint channel_fault_selector_c {
    (err[0] == BAD_ID) || (err[1] == BAD_ID) ||
    (err[2] == BAD_ID) || (err[3] == BAD_ID);

    (err[0] == BAD_PHAS) || (err[1] == BAD_PHAS) ||
    (err[2] == BAD_PHAS) || (err[3] == BAD_PHAS);
  }


  // --------------------------------------------------------------------------
  // post_randomize: display and validate generated stimulus.
  //
  // Iterate 16 signal-level entries. Channel-level fields use i%4.
  // Fault selector for signal-level fields uses i%8.
  // --------------------------------------------------------------------------
  function void post_randomize();

    foreach (amplitude[i]) begin

      $display("\n========== SIGNAL CONFIGURATION ==========");
      $display("INDEX CH_ID AMP FREQ PHASE PERIOD MODE PRI CLK SAMPLE_COUNT ERR");
      $display("----------------------------------------------------------------");

      $display("%0d %0d %0d %0d %0d %s %0d %0d %0d %s",
        i,
        channel_id[i%4],
        amplitude[i],
        frequency_mhz[i],
        phase[i%4],
        sample_period[i],
        mode[i%4].name(),
        priority_level[i],
        clock_domain[i%4],
        sample_count[i],
        err[i%8].name()
      );


      // ---------------------- Channel ID check -------------------------------
      if (err[i%4] == BAD_ID) begin
        if (channel_id[i%4] inside {[4:7]})
          $display("PASS: Injected invalid channel ID = %0d", channel_id[i%4]);
        else
          $display("FAIL: BAD_ID selected, but channel ID is not invalid");
      end
      else begin
        if (channel_id[i%4] inside {[0:3]})
          $display("PASS: Channel ID is legal = %0d", channel_id[i%4]);
        else
          $display("FAIL: Channel ID is out of legal range = %0d", channel_id[i%4]);
      end


      // ---------------------- Sample period check ---------------------------
      if (err[i%8] == BAD_SAMP_PE) begin
        if (sample_period[i] inside {[21:26]})
          $display("PASS: Injected invalid sample period = %0d", sample_period[i]);
        else
          $display("FAIL: BAD_SAMP_PE selected, but period is not invalid");
      end
      else begin
        if (sample_period[i] inside {[1:20]})
          $display("PASS: Sample period is in general legal range = %0d",
                   sample_period[i]);
        else
          $display("FAIL: Sample period is out of range = %0d", sample_period[i]);
      end


      // ---------------------- Amplitude check -------------------------------
      if (err[i%8] == BAD_AMP) begin
        if (amplitude[i] inside {[256:500]})
          $display("PASS: Injected invalid amplitude = %0d", amplitude[i]);
        else
          $display("FAIL: BAD_AMP selected, but amplitude is not in fault range");
      end
      else if (mode[i%4] == NORMAL) begin
        if (amplitude[i] == 0)
          $display("PASS: NORMAL mode amplitude is zero");
        else
          $display("FAIL: NORMAL mode amplitude should be zero");
      end
      else begin
        if (amplitude[i] inside {[1:255]})
          $display("PASS: Amplitude is legal = %0d", amplitude[i]);
        else
          $display("FAIL: Amplitude is outside legal range = %0d", amplitude[i]);
      end


      // ---------------------- Phase check -----------------------------------
      if (err[i%4] == BAD_PHAS) begin
        if (phase[i%4] inside {30, 45, 60, 120})
          $display("PASS: Injected phase error = %0d", phase[i%4]);
        else
          $display("FAIL: BAD_PHAS selected, but phase is not in error set");
      end
      else begin
        if (phase[i%4] inside {0, 90, 180, 270})
          $display("PASS: Phase is legal = %0d", phase[i%4]);
        else
          $display("FAIL: Phase is outside legal set = %0d", phase[i%4]);
      end


      // ---------------------- Frequency check -------------------------------
      if (err[i%8] == BAD_FREQ) begin
        if (frequency_mhz[i] inside {[101:201]})
          $display("PASS: Injected frequency error = %0d MHz", frequency_mhz[i]);
        else
          $display("FAIL: BAD_FREQ selected, but frequency is not in fault range");
      end
      else begin
        if (frequency_mhz[i] inside {[1:100]})
          $display("PASS: Frequency is legal = %0d MHz", frequency_mhz[i]);
        else
          $display("FAIL: Frequency is outside legal range = %0d MHz",
                   frequency_mhz[i]);
      end


      // ---------------------- Clock-domain check ---------------------------
      if (err[i%4] == BAD_CLK) begin
        if (clock_domain[i%4] inside {[4:7]})
          $display("PASS: Injected clock-domain error = %0d",
                   clock_domain[i%4]);
        else
          $display("FAIL: BAD_CLK selected, but clock domain is not invalid");
      end
      else begin
        if (clock_domain[i%4] inside {[0:3]})
          $display("PASS: Clock domain is legal = %0d", clock_domain[i%4]);
        else
          $display("FAIL: Clock domain is outside legal range = %0d",
                   clock_domain[i%4]);
      end


      // ---------------------- Mode checks -----------------------------------
      if (mode[i%4] == BURST) begin
        if (sample_period[i] inside {[1:4]})
          $display("PASS: BURST mode sample period = %0d", sample_period[i]);
        else
          $display("FAIL: BURST mode period is outside 1..4");
      end

      if (mode[i%4] == NORMAL) begin
        if (err[i%8] == BAD_SAMP_PE)
          $display("INFO: NORMAL mode period is deliberately fault-injected");
        else if (sample_period[i] inside {[5:20]})
          $display("PASS: NORMAL mode sample period = %0d", sample_period[i]);
        else
          $display("FAIL: NORMAL mode period is outside 5..20");
      end

      if (mode[i%4] == ERROR) begin
        if (channel_id[i%4] inside {0, 1})
          $display("PASS: ERROR mode channel ID = %0d", channel_id[i%4]);
        else
          $display("FAIL: ERROR mode channel ID must be 0 or 1");
      end


      // ---------------------- Cross-constraint checks ----------------------
      if ((amplitude[i] > 200) && (frequency_mhz[i] <= 50))
        $display("PASS: amplitude>200 implies frequency<=50");
      else if (amplitude[i] <= 200)
        $display("INFO: First amplitude/frequency implication antecedent is false");
      else
        $display("FAIL: amplitude>200 but frequency is greater than 50");

      if ((frequency_mhz[i] > 80) && (amplitude[i] <= 100))
        $display("PASS: frequency>80 implies amplitude<=100");
      else if (frequency_mhz[i] <= 80)
        $display("INFO: Second amplitude/frequency implication antecedent is false");
      else
        $display("FAIL: frequency>80 but amplitude is greater than 100");


      // ---------------------- Sample-count check ---------------------------
      if (sample_count[i] inside {[1:16]})
        $display("PASS: Sample count = %0d", sample_count[i]);
      else
        $display("FAIL: Sample count out of range = %0d", sample_count[i]);

      $display("----------------------------------------------------------------");

    end // foreach amplitude

  endfunction : post_randomize

endclass : Multi_Channel_Signal_Scheduler



// ============================================================================
// Testbench
// ============================================================================
module tb;

  Multi_Channel_Signal_Scheduler ms;

  initial begin
    ms = new();

    repeat (5) begin
      if (!ms.randomize())
        $fatal(1, "Randomization failed");
    end

    $finish;
  end

endmodule : tb
