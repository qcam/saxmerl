inputs =
  Map.new(Path.wildcard("test/support/fixtures/sweet_xml/*.*"), fn sample ->
    binary = sample |> Path.expand() |> File.read!()
    {sample, {binary, String.to_charlist(binary)}}
  end)

bench_options = [
  time: 5,
  memory_time: 2,
  inputs: inputs
]

saxmerl_parser = fn {data, _} ->
  {:ok, _} = Saxmerl.parse_string(data, dynamic_atoms?: true)
end

xmerl_parser = fn {_, data} ->
  {_, _} = :xmerl_scan.string(data, [])
end

Benchee.run(
  %{
    "Saxy" => saxmerl_parser,
    "xmerl" => xmerl_parser
  },
  bench_options
)
