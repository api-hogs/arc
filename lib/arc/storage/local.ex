defmodule Arc.Storage.Local do

  def put(definition, version, {file, scope}) do
    destination_dir = definition.storage_dir(version, {file, scope})
    File.mkdir_p(destination_dir)
    binary = extract_binary(file)
    File.write!(Path.join(destination_dir, file.file_name), binary)
    file.file_name
  end

  def url(definition, version, {file, scope}, options \\ []) do
    destination_dir = definition.storage_dir(version, {file, scope})
    Path.join(destination_dir, file.file_name)
  end

  def delete(definition, version, {file, scope}) do
    destination_dir = definition.storage_dir(version, {file, scope})
    File.rm(Path.join(destination_dir, file.file_name))
  end

  defp extract_binary(file) do
    if file.binary do
      binary = file.binary
    else
      {:ok, binary} = File.read(file.path)
      binary
    end
  end
end
