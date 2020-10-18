# Saxmerl

## Installation

```elixir
def deps() do
  [
    {:saxmerl, "~> 0.1"}
  ]
end
```

## Benchmarking

To run benchmark

```
mix run bench.exs
```

Result on my local computer:

```
Operating System: macOS
CPU Information: Intel(R) Core(TM) i7-6567U CPU @ 3.30GHz
Number of Available Cores: 4
Available memory: 16 GB
Elixir 1.10.2
Erlang 23.0.3

Benchmark suite executing with the following configuration:
warmup: 2 s
time: 5 s
memory time: 2 s
parallel: 1
inputs: test/support/fixtures/sweet_xml/match.xml, test/support/fixtures/sweet_xml/yahoo_fantasy.xml
Estimated total run time: 36 s

Benchmarking Saxy with input test/support/fixtures/sweet_xml/match.xml...
Benchmarking Saxy with input test/support/fixtures/sweet_xml/yahoo_fantasy.xml...
Benchmarking SweetXml with input test/support/fixtures/sweet_xml/match.xml...
Benchmarking SweetXml with input test/support/fixtures/sweet_xml/yahoo_fantasy.xml...

##### With input test/support/fixtures/sweet_xml/match.xml #####
Name               ips        average  deviation         median         99th %
Saxy            7.12 K      140.49 μs    ±14.42%      133.90 μs      230.90 μs
SweetXml        3.83 K      261.38 μs    ±72.85%      245.90 μs      481.58 μs

Comparison:
Saxy            7.12 K
SweetXml        3.83 K - 1.86x slower +120.89 μs

Memory usage statistics:

Name        Memory usage
Saxy            70.90 KB
SweetXml       253.08 KB - 3.57x memory usage +182.18 KB

**All measurements for memory usage were the same**

##### With input test/support/fixtures/sweet_xml/yahoo_fantasy.xml #####
Name               ips        average  deviation         median         99th %
Saxy            499.56        2.00 ms    ±15.07%        1.88 ms        3.22 ms
SweetXml        279.79        3.57 ms    ±11.84%        3.44 ms        5.16 ms

Comparison:
Saxy            499.56
SweetXml        279.79 - 1.79x slower +1.57 ms

Memory usage statistics:

Name        Memory usage
Saxy             0.84 MB
SweetXml         4.01 MB - 4.75x memory usage +3.16 MB

**All measurements for memory usage were the same**
```
