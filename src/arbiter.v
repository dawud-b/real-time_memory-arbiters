module arbiter #(
  parameter NUM_REQUESTERS = 4;
)(
  input clk,
  input rstn,

  input   [NUM_REQUESTERS-1:0] s_req_i, // each bit corresponds to one requester
  input   [NUM_REQUESTERS-1:0] m_ack_i,

  output reg  [NUM_REQUESTERS-1:0]  s_ack_o, // one-hot. While high, indicates requester granted and transaction in progress.
  output reg                        m_req_o,
);

reg [1:0] state;
localparam IDLE = 0;
localparam WAIT_ACK = 1;
localparam BUSY = 2;
localparam DONE = 3;

// --- Policy Determination ---
wire [NUM_REQUESTERS-1:0] granted; // one-hot selects granted requester


// TODO: Mux request info from granted requester.


// --- FSM --- 
always @(posedge clk, negedge rstn) begin
  if (rstn == 0) begin
    state   <= IDLE;
    s_ack_o <= 0;
    m_req_o <= 0;
  end
  else begin
    case (state)
      
      IDLE: begin
        // idle
        s_ack_o <= 0;
        
        // slave-side req seen. Set master-side req
        if (s_reg_i != 0) begin
          s_ack_o <= granted;
          m_req_o <= 1;
          state   <= WAIT_ACK;
        end    
      end

      WAIT_ACK: begin
        // check
        if (s_reg_i == 0)
          state <= IDLE;
        
        // wait for ack on mem
        else begin
          m_req_o <= 1;
          if (m_ack_i == 1) state <= BUSY;
        end
      end

      BUSY: begin
        // wait for ack low
        if (m_ack_i == 0) begin
          m_req_o <= 0;
          s_ack_o <= 0;
          state   <= DONE;
        end
      end

      DONE: begin
        // wait one cycle to let requester lower req
        s_ack_o <= 0;
        state   <= IDLE;
      end
      
      default: 
        state <= IDLE;
    endcase
  end
end
  
endmodule