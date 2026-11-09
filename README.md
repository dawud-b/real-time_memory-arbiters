# Real-Time Memory Arbitration

## Objectives
+ At least two functioning Verilog arbiter implementations: fixed-priority and round-robin.
+ A testbench that generates controlled request traffic and evaluates deadline satisfaction.
+ Questa simulation results comparing both policies under multiple contention and workload scenarios.
+ An evaluation of the strengths and limitations of each policy for real-time shared-resource access.

And, if time permits,
5. Vivado synthesis results comparing FPGA resource utilization and timing characteristics.
+  A third arbiter (deadline based policy) Verilog implementation and evaluation.

## Evaluation
The evaluation will use four simulated requesters competing for a single resource. Experiments will vary request arrival patterns, transaction durations, and deadline constraints. Test scenarios will include simultaneous requests, periodic traffic, aperiodic traffic, and continuous requests from multiple requesters.

Many metrics will recorded to properly evaluate and analyze each arbitration. The focus will be on real-time metrics and a few hardware design metrics:

- Request latency: Clock cycles between a request becoming pending and the start of its service.
- Completion latency: Clock cycles between a request becoming pending and its transaction completing.
- Worst observed latency: Maximum measured request and completion latency for each requester during a test.
- Deadline-miss rate: Percentage of requests that complete after their assigned deadlines.
- Fairness: Distribution of completed transactions and waiting times across requesters.
- Throughput: Number of completed transactions per unit of simulated time.
- Hardware cost: If synthesis is completed, FPGA resource utilization and estimated timing for each arbiter.

# Implementation

## Modules

Using a custom bus to simplify the project, focussing on real-time scheduling rather than established bus communication.

### Custom Bus Protocol (Arbiter Perspective):
1. IDLE: `req_i=0, ack_o=0`
2. POS EDGE: If `req_i[x]=1` for any x which is the number of requester
3. Determine which requester gets granted.
4. Next CYCLE: `ack_o[y]=1` where y is number of granted requester
5. Send Data to/from requester/memory (wait TRANSACTION_CYCLES)
6. Once valid data: `ack_o[y]=0` - lets requester know its finished.
7. Repeat

### Arbiters
Slave to requesters, Master to shared resource.

IO:
- `clk`
- `rstn`
- `s_req_i[3:0]`
- `s_ack_o[3:0]` one hot (or none)
- `m_req_o`
- `m_ack_i`
  Select granted's request:
- `data_i`
- `data_o`
- `addr_o`
- `be_o`
- `wr_en_o`

FSM:
- IDLE: s_ack_o=0000, m_req_o=0. If (s_req_i != 0), policy check - determine granted requester -> WAIT_ACK
- WAIT_ACK: s_ack_o!=0, m_req_o=1. If (m_ack_i=1) -> BUSY
- BUSY: s_ack_o!=0, m_req_o=1. If (m_ack_i=0), s_ack_o=0, -> DONE
- DONE: s_ack_o=0000, m_req_o=0. Only one cycle, requester should be setting s_req_i=0. -> IDLE


### Shared Resource 
Contains counter/busy metadata. Connects to assumed BRAM module if FPGA.

`parameter TRANSACTION_CYCLES`: total time once granted is TRANSACTION_CYCLES. One additional cycle for arb determination, making min wait time TRANSACTION_CYCLES+1. 

IO:
- `clk`
- `rstn`
- `req_i`
- `ack_o`
- `addr_i`*
- `data_i`*
- `be_i`*
- `wr_en_i`*
- `data_o`*
  *Pass-through to Mem

FSM:
- IDLE: ack_o=0. If req_i=1 -> BUSY
- BUSY: ack_o=1. wait TRANSACTION_CYCLES-1 cycles, then ack_o=0. If req_i=0 -> IDLE

### Requester (Contains metadata for metrics)
IO:
- `clk`
- `rstn`
- `req_o`
- `ack_i`
- `data_i`
- `data_o`
- `addr_o`
- `be_o`
- `wr_en_o`

Tracks each request latency and completion latency. Keeps track of its deadline. 

## Policies

### Fixed-Priority

Requesters have a specific unique priority. Requester 0 has highest priority and requester 3 has lowest priority. During POLICY state, choose 

### Round Robin

Have a 2-bit looping pointer, which points to the previous_requester+1. When granting a requester, if the counter points to a requester that is not requesting, the next ready requester will be pointed to. 

## Remaining

Things that will need to be thought about at somepoint:
- How to collect metrics (inside each requester vs inside shared resource?)