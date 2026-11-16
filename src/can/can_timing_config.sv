class can_timing_config extends uvm_object;
  `uvm_object_utils(can_timing_config)

can_operation_e operation;

  int unsigned can_clk_freq; 
  int unsigned target_bitrate;
  int unsigned clocks_per_bit;  //clk cycle required for 1 bit
  int unsigned sample_point_x100; //sample point in terms of 100%
  int unsigned sample_point_cycles; //clk cycle for sampling

  function new(string name = "can_timing_config");
    super.new(name);
operation = DRIVE_FRAME;
  endfunction

  function void configure(int unsigned clk_freq, int unsigned bitrate, int unsigned sample_point = 8500 );
    if (clk_freq == 0 || bitrate == 0)
      `uvm_fatal("CAN_TIMING", "Clock frequency and bitrate must be nonzero")

    if (clk_freq % bitrate != 0)
      `uvm_fatal("CAN_TIMING", "Clock frequency must be divisible by bitrate")

    if (sample_point == 0 || sample_point >= 10000)  //multiplied by 100 
      `uvm_fatal("CAN_TIMING", "Sample point must be between 0 and 100 percent")

    can_clk_freq = clk_freq;
    target_bitrate = bitrate;
    sample_point_x100 = sample_point;
    clocks_per_bit = clk_freq / bitrate;    // gives clks per bit

    sample_point_cycles = (clocks_per_bit * sample_point_x100 + 5000) / 10000; // 5000 used becuase to round of it to nearest integer when we get fraction, 5000 is denominator/2

    if (clocks_per_bit < 2 || sample_point_cycles == 0 || sample_point_cycles >= clocks_per_bit)
      `uvm_fatal("CAN_TIMING", "Invalid CAN bit timing configuration")
  endfunction
endclass
