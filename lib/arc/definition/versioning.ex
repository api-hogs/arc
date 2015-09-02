defmodule Arc.Definition.Versioning do
  defmacro __using__(_) do
    quote do
      @versions [:original]
      @before_compile Arc.Definition.Versioning
    end
  end

  def resolve_file_name(definition, version, {file, scope}) do
    name = definition.filename(version, {file, scope})
    conversion = definition.transform(version, {file, scope})
    case conversion do
      {:noaction} -> filename_with_ext(name, file)
      {:convert, args} ->
        extension = case Regex.run(~r/-format[ ]*(\w*)/, args) do
          nil -> filename_with_ext(name, file)
          [_, ext] -> "#{name}.#{ext}"
        end
    end
  end

  defp filename_with_ext(name, file) do
    ext = Path.extname(file.file_name)
    if String.ends_with?(name, ext) do
      name
    else
      "#{name}#{ext}"
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def transform(_, _), do: {:noaction}
      def __versions, do: @versions
    end
  end
end
