
module crc_check (
    input  wire        check_en,
    input  wire [14:0] calculated_crc,
    input  wire [14:0] received_crc,
    output wire        crc_error
);

    assign crc_error = check_en && (calculated_crc != received_crc);

always @(*) begin
    if (check_en) begin
        $display("CRC COMPARE: time=%0t calculated=%h received=%h error=%b",
                 $time, calculated_crc, received_crc, crc_error);
    end
end
endmodule
