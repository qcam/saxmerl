defmodule Saxmerl do
  @doc """
  Parses XML document into Erlang [xmerl](http://erlang.org/doc/man/xmerl.html) format.

  Xmerl format requires tags and attribute names to be atoms. By default Saxy does not
  create atoms dynamically, because it is dangerous. However, you can override this
  behaviour by specifying `dynamic_atoms?` to `true`. Please check out `String.to_atom/1`
  for more information about dynamic atom conversion.

  ## Examples

      iex> string = ~s(<foo bar="qwe"></foo>)
      iex> Saxmerl.parse_string(string)
      {:ok,
       {:xmlElement,
        :foo,
        :foo,
        [],
        {:xmlNamespace, [], []},
        [],
        1,
        [{:xmlAttribute, :bar, :bar, [], [], [], 1, [], 'qwe', :undefined}],
        [],
        [],
        [],
        :undeclared}}

  ## Options
  * `:dynamic_atoms?` - boolean, whether atoms should be created dynamically. Defaults to `false`.
  * `:expand_entity` - specifies how external entity references should be handled. Three supported strategies respectively are:
    * `:keep` - keep the original binary, for example `Orange &reg;` will be expanded to `"Orange &reg;"`, this is the default strategy.
    * `:skip` - skip the original binary, for example `Orange &reg;` will be expanded to `"Orange "`.
    * `{mod, fun, args}` - take the applied result of the specified MFA.

  """
  @spec parse_string(binary(), Keyword.t()) :: {:ok, any()} | {:error, any()}
  def parse_string(data, options \\ []) do
    {dynamic_atoms?, options} = Keyword.pop(options, :dynamic_atoms?, true)
    state = %Saxmerl.State{dynamic_atoms?: dynamic_atoms?}

    case Saxy.parse_string(data, __MODULE__.Handler, state, options) do
      {:ok, %{stack: [document]}} ->
        {:ok, document}

      {:error, _reason} = error ->
        error
    end
  end
end
