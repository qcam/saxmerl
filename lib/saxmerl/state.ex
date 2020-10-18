defmodule Saxmerl.State do
  @moduledoc false

  defstruct stack: [],
            child_count: [],
            dynamic_atoms?: false
end
