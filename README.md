# Saxmerl

Saxmerl is a parser written in Elixir that parses XML documents into Erlang `:xmerl` document.

## Installation

```elixir
def deps() do
  [{:saxmerl, "~> 0.1"}]
end
```

## Feature highlights

* **Memory efficiency and better performance** - Several benchmarkings show that
  Saxmerl usually use 4x less memory than `:xmerl` or SweetXml, and is usually
  70-90% faster.
* **XPath compatible** - Saxmerl parsed documents can be used with
  `:xmerl_xpath` or `SweetXml.xpath`.

## Limitations

Not all features provided by `:xmerl` are supported, such as namespaces.

Even Saxmerl discourages dynamic atom conversion by default (via
`dynamic_atoms?: false`), it is usually more practical to generate atoms
dynamically, because of the fact that `:xmerl_xpath` requires atom conversion of
tags and attributes. Therefore, please always monitor the atom usage of the
virtual machine.

## API Overview

```ex
xml_string = "<body><header><p>Message</p><ul><li>One</li><li><a>Two</a></li></ul></header></body>"

{:ok, root} = Saxmerl.parse_string(xml_string, dynamic_atoms: false)

SweetXml.xpath(
  root,
  ~x"//header",
  ul: [
    ~x"./ul",
    a: ~x"./li/a/text()"
  ]
)
%{ul: %{a: 'Two'}}
```

## Benchmarking

To benchmark yourself, do:

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
Benchmarking xmerl with input test/support/fixtures/sweet_xml/match.xml...
Benchmarking xmerl with input test/support/fixtures/sweet_xml/yahoo_fantasy.xml...

##### With input test/support/fixtures/sweet_xml/match.xml #####
Name            ips        average  deviation         median         99th %
Saxy         6.35 K      157.59 μs    ±21.81%      148.90 μs      305.90 μs
xmerl        3.75 K      266.75 μs    ±18.54%      249.90 μs      476.08 μs

Comparison:
Saxy         6.35 K
xmerl        3.75 K - 1.69x slower +109.16 μs

Memory usage statistics:

Name     Memory usage
Saxy         70.90 KB
xmerl       253.08 KB - 3.57x memory usage +182.18 KB

**All measurements for memory usage were the same**

##### With input test/support/fixtures/sweet_xml/yahoo_fantasy.xml #####
Name            ips        average  deviation         median         99th %
Saxy         468.22        2.14 ms    ±14.36%        2.03 ms        3.14 ms
xmerl        254.55        3.93 ms    ±19.35%        3.66 ms        6.70 ms

Comparison:
Saxy         468.22
xmerl        254.55 - 1.84x slower +1.79 ms

Memory usage statistics:

Name     Memory usage
Saxy          0.84 MB
xmerl         4.01 MB - 4.75x memory usage +3.16 MB

**All measurements for memory usage were the same**
```

## Contributing

Any issues or ideas, feel free to write to https://github.com/qcam/saxmerl/issues.

To start developing:

1. Fork the repository.
2. Write your code and related tests.
3. Create a pull request at https://github.com/qcam/saxmerl/pulls.
