module tb_highest_priority ();

reg [3:0] request;
wire [3:0] grant;

highest_priority #(4) DUT (
  .requesters(request), .granted(grant)
);

initial begin
  request = 4'b0000;
  #10
  request = 4'b1010;
  #10
  request = 4'b1111;
  #10
  request = 4'b0011;
  #10
  request = 4'b1000;
  #10
  $finish;
end

endmodule