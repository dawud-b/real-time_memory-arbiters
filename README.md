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
