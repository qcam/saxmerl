defmodule Saxmerl.Handler do
  @moduledoc false

  import Saxmerl.Records

  @behaviour Saxy.Handler

  @impl true
  def handle_event(:start_element, element, state) do
    {:ok, start_element(element, state)}
  end

  @impl true
  def handle_event(:end_element, element, state) do
    {:ok, end_element(element, state)}
  end

  @impl true
  def handle_event(:characters, element, state) do
    {:ok, characters(element, state)}
  end

  @impl true
  def handle_event(_event_name, _event_data, state) do
    {:ok, state}
  end

  # Event handlers

  defp start_element({name, attributes}, state) do
    %{dynamic_atoms?: dynamic_atoms?, stack: stack, child_count: child_count} = state

    element = make_element(name, attributes, stack, child_count, dynamic_atoms?)

    %{state | stack: [element | stack], child_count: [0 | child_count]}
  end

  defp end_element(_name, %{stack: [root]} = state) do
    %{state | stack: [reverse_element_content(root)]}
  end

  defp end_element(_name, state) do
    %{stack: stack, child_count: child_count} = state

    [current | [parent | stack]] = stack
    [_ | [count | child_count]] = child_count

    current = reverse_element_content(current)

    parent = prepend_element_content(parent, current)

    %{state | stack: [parent | stack], child_count: [count + 1 | child_count]}
  end

  defp characters(characters, state) do
    %{stack: [current | stack]} = state

    text = xmlText(value: String.to_charlist(characters))
    current = prepend_element_content(current, text)

    %{state | stack: [current | stack]}
  end

  # Helpers

  defp prepend_element_content(xmlElement(content: content) = current, object) do
    xmlElement(current, content: [object | content])
  end

  defp reverse_element_content(xmlElement(content: content) = element) do
    xmlElement(element, content: Enum.reverse(content))
  end

  defp make_element(binary_name, attributes, stack, child_count, dynamic_atoms?) do
    {namespace, local} = split_name(binary_name)

    name = binary_to_atom(dynamic_atoms?, binary_name)
    nsinfo = make_nsinfo(namespace, local)
    attributes = make_attributes(attributes, dynamic_atoms?)
    namespace = make_namespace()
    parents = make_parents(stack)
    position = determine_element_position(child_count)
    content = []

    xmlElement(
      name: name,
      expanded_name: name,
      pos: position,
      nsinfo: nsinfo,
      namespace: namespace,
      parents: parents,
      attributes: attributes,
      content: content
    )
  end

  defp determine_element_position([count | _]), do: count + 1
  defp determine_element_position([]), do: 1

  defp split_name(name) do
    case String.split(name, ":", parts: 2) do
      [local] -> {<<>>, local}
      [namespace, local] -> {namespace, local}
    end
  end

  defp make_nsinfo(<<>>, _local), do: []

  defp make_nsinfo(namespace, local),
    do: {String.to_charlist(namespace), String.to_charlist(local)}

  defp make_namespace(), do: xmlNamespace()

  defp make_parents(stack, acc \\ [])
  defp make_parents([], acc), do: Enum.reverse(acc)

  defp make_parents([current | stack], acc) do
    xmlElement(name: name, pos: pos) = current
    make_parents(stack, [{name, pos} | acc])
  end

  defp make_attributes(attributes, dynamic_atoms?, count \\ 0, acc \\ [])

  defp make_attributes([], _dynamic_atoms?, _count, acc), do: Enum.reverse(acc)

  defp make_attributes([{binary_name, value} | attributes], dynamic_atoms?, count, acc) do
    {namespace, local} = split_name(binary_name)

    name = binary_to_atom(dynamic_atoms?, binary_name)

    attribute =
      xmlAttribute(
        name: name,
        expanded_name: name,
        nsinfo: make_nsinfo(namespace, local),
        pos: count + 1,
        value: String.to_charlist(value)
      )

    make_attributes(attributes, dynamic_atoms?, count + 1, [attribute | acc])
  end

  defp binary_to_atom(true, binary), do: String.to_atom(binary)
  defp binary_to_atom(false, binary), do: String.to_existing_atom(binary)
end
