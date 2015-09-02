defmodule Arc.Transformations.Convert do
  def apply(file, args) do
    new_path = temp_path
    if file.binary do
      file = save_binary_data(file)
    end
    System.cmd("convert",
      ~w(#{file.path} #{args} #{String.replace(new_path, " ", "\\ ")}),
      stderr_to_stdout: true)

    %Arc.File{file | path: new_path}
  end

  defp temp_path do
    rand = Base.encode32(:crypto.rand_bytes(20))
    Path.join(System.tmp_dir, rand)
  end

  defp save_binary_data(file) do
    new_temp_path = temp_path
    File.write!(new_temp_path, file.binary)
    %Arc.File{file | path: new_temp_path, binary: nil}
  end
end
