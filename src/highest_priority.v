// grants highest-priority to least-sig bit
module highest_priority #(
  parameter NUM_REQUESTERS = 4
)(
  input wire  [NUM_REQUESTERS-1:0] requesters,
  output wire [NUM_REQUESTERS-1:0] granted
);

wire [NUM_REQUESTERS-1:0] or_s;

assign granted[0] = requesters[0];
assign or_s[0]    = requesters[0];

genvar i;
generate
  for (i=1; i < NUM_REQUESTERS; i=i+1) begin
    assign or_s[i] = or_s[i-1] | requester[i];
    assign granted[i] = ~(or_s[i-1]) & requester[i];
  end
endgenerate
  
endmodule