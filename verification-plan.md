# Verification Plan — 4-Bit UVM Adder

## Purpose

This plan documents the table that guided my adder verification work and maps each item to the implemented stimulus, checking, and coverage.

The plan influenced the code: I chose exhaustive stimulus to exercise every input pair and used the table's coverage goals to define the coverpoints and cross. This document records that reasoning after the successful simulation.

## DUT requirements and test scope

`A` and `B` are unsigned four-bit operands. With reset inactive, the DUT registers their five-bit sum at the rising clock edge. The legal result range is 0–30. Active-high asynchronous reset clears the output.

This completed test targets arithmetic behaviour after startup reset. Reset functionality is part of the RTL specification but is not closed by a dedicated reset test in this milestone.

## Plan-to-implementation mapping

All arithmetic rows use the scoreboard comparison against the five-bit expected result. Coverage is sampled from transactions published by the monitor.

| ID | Feature | Stimulus | Expected behaviour | Coverage / implementation evidence |
|---|---|---|---|---|
| ADD-01 | Basic addition | All legal `a,b` pairs | `sum == a+b` | Exhaustive sequence; scoreboard checks every observed pair |
| ADD-02 | Zero + zero | `0+0` | Result is 0 | Included in exhaustive sequence; `combi` pair `(0,0)` and sum-0 bin |
| ADD-03 | Zero operand | `0+x` and `x+0`, for `x=0..15` | Result equals `x` | All cross pairs with either operand zero; 31 distinct pairs because `(0,0)` belongs to both sets |
| ADD-04 | Maximum inputs | `15+15` | Result is 30 | Cross pair `(15,15)` and sum-30 bin |
| ADD-05 | No carry | Pairs whose expected sum is below 16 | `sum[4] == 0` | `val_carry.no_carry`; full-result scoreboard comparison |
| ADD-06 | Carry | Pairs whose expected sum is at least 16 | `sum[4] == 1` | `val_carry.carry`; full-result scoreboard comparison |
| ADD-07 | All A values | `a=0..15` | Correct result for each operand value | `val_A`: 16 individual bins |
| ADD-08 | All B values | `b=0..15` | Correct result for each operand value | `val_B`: 16 individual bins |
| ADD-09 | Every ordered A×B pair | All 256 combinations | Correct result for every pair | `combi: cross val_A, val_B`: 256 bins |
| ADD-10 | All possible sums | Pairs producing each result from 0 through 30 | Correct five-bit result | `val_sum`: 31 legal bins |

`val_sum` additionally contains `illegal_bins impossible_sum = {31}`. The scoreboard also detects an observed result of 31 because no legal operand pair produces it.

## Why exhaustive stimulus was chosen

With two four-bit operands, the input space contains only 256 ordered pairs. Two nested loops generate these deterministically, with no need to rely on random selection to reach an untested pair.

Generating 256 random transactions would not provide the same guarantee. The cross is useful even with exhaustive stimulus because it measures pairs observed by the monitor, rather than relying only on the sequence's intention to generate them.

Individual A and B coverage alone would be insufficient: each operand could take every value without exercising every combination. The A×B cross captures that pairing requirement.

## Corner-case coverage decision

There are no separately named bins for `zero_plus_zero` or `maximum_inputs` in this implementation. Their exact input pairs are already individual bins in the A×B cross.

When all cross bins are hit, these corner cases have been observed. The scoreboard establishes whether their results are correct. Named corner-case bins could improve report readability or requirement traceability, but would overlap existing coverage for this test.

A sum bin alone does not generally identify which input pair produced the result. The cross provides the pair-specific evidence.

## Checking and sampling

The scoreboard computes:

```systemverilog
expected_sum = {1'b0, trans.a} + {1'b0, trans.b};
```

It compares that result against `trans.sum`, increments a pass or fail counter, and issues a UVM error for a mismatch. Checking the complete result also checks the carry bit.

The driver supplies operands at a falling edge, the DUT registers the result at the next rising edge, and the monitor collects the completed operation at the following falling edge. The monitor's `input #1step` sampling separates observation of the current result from driving the next operands.

The interface's `valid` signal is testbench bookkeeping, not a DUT protocol signal. The current test sends continuous stimulus; arbitrary gaps and interrupted sequences are outside the demonstrated scope.

## Completion and acceptance criteria

For this arithmetic milestone:

1. The sequence generates all 256 ordered input pairs.
2. The scoreboard processes 256 transactions before the test drops its objection.
3. All 256 comparisons pass and none fail.
4. The defined functional coverage reaches 100%.
5. The UVM summary reports no warnings, errors, or fatal errors.

The test code waits for `pass_count + fail_count == 256`. That wait is a completion condition; the final failure count must still be examined to determine whether the test passed. The current test has no dedicated timeout.

## Recorded results

The EDA Playground run supplied with this project reports:

| Metric | Result |
|---|---:|
| Total scoreboard comparisons | 256 |
| Pass count | 256 |
| Fail count | 0 |
| Functional coverage | 100.00% |
| UVM warnings | 0 |
| UVM errors | 0 |
| UVM fatal errors | 0 |

The log includes successful checks for `(0,0)` producing 0 and `(15,15)` producing 30. Together with the exhaustive sequence and completed coverage model, these results meet the acceptance criteria for this arithmetic milestone.

## Limits of this result

Exhaustive input-pair testing is not exhaustive testing of every temporal sequence. The current result does not claim closure for reset during traffic, different reset-release timings, unknown-value handling, arbitrary stimulus gaps, or every internal RTL path. No code-coverage result is claimed.

Dedicated reset tests, assertions, a simulation timeout, and deliberate fault injection are possible next steps. They are future work, not part of the completed evidence above.
