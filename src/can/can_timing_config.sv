class can_timing_config extends uvm_object;
  `uvm_object_utils(can_timing_config)

  int unsigned can_clk_freq;
  int unsigned target_bitrate;
  int unsigned clocks_per_bit;
  int unsigned sample_point_x100;
  int unsigned sample_point_cycles;

  function new(string name = "can_timing_config");
    super.new(name);
  endfunction

  function void configure(
    int unsigned clk_freq,
    int unsigned bitrate,
    int unsigned sample_point = 8500
  );
    if (clk_freq == 0 || bitrate == 0)
      `uvm_fatal("CAN_TIMING", "Clock frequency and bitrate must be nonzero")

    if (clk_freq % bitrate != 0)
      `uvm_fatal("CAN_TIMING", "Clock frequency must be divisible by bitrate")

    if (sample_point == 0 || sample_point >= 10000)
      `uvm_fatal("CAN_TIMING", "Sample point must be between 0 and 100 percent")

    can_clk_freq = clk_freq;
    target_bitrate = bitrate;
    sample_point_x100 = sample_point;
    clocks_per_bit = clk_freq / bitrate;

    sample_point_cycles =
      (clocks_per_bit * sample_point_x100 + 5000) / 10000;

    if (clocks_per_bit < 2 ||
        sample_point_cycles == 0 ||
        sample_point_cycles >= clocks_per_bit)
      `uvm_fatal("CAN_TIMING", "Invalid CAN bit timing configuration")
  endfunction
endclass
