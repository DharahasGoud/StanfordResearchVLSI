ran with about 1B points on PYNQ\_Z1 board

cdf\_tot: 1001889430
-6: 0.0
-5: 2.43539848504041e-07
-4: 3.131483281543354e-05
-3: 0.0013484671656831433
-2: 0.022756972293838853
-1: 0.15867389278675192
0: 0.49997847167626075
1: 0.8413026704952861
2: 0.9772350936969162
3: 0.9986492172095278
4: 0.9999685504217766
5: 0.9999997574582656
6: 1.0

//////////////////////////////////
* Aug 29 -- re-ran with MT19937.  Main purpose is to fix "runs" in the output of a simple LFSR, but the distribution itself also appears to be more accurate.

cdf\_tot: 1002129550
-6: 9.978749753462513e-10
-5: 2.8239861802298917e-07
-4: 3.189607571196758e-05
-3: 0.0013521694874679626
-2: 0.022767034461761954
-1: 0.15870203408331787
0: 0.5000117699353342
1: 0.8413383229743101
2: 0.9772432296802345
3: 0.9986477157569099
4: 0.9999681268754125
5: 0.9999997315716316
6: 1.0

resource utilization (PYNQ\_Z1)
whole design: 4145 LUT, 6169 FF, 10 BRAM, 4 DSPs
just the test bench: 809 LUT, 621 FF, 2.5 BRAM, 4 DSP
mt19937: 427 LUT, 168 FF, 2 BRAM
just the MT19937 core