defmodule ArcTest.Storage.Local do
  use ExUnit.Case
  @img "test/support/image.png"

  setup_all do
    File.mkdir_p("arctest/uploads")
  end


  defmodule DummyDefinition do
    use Arc.Definition
    def __storage, do: Arc.Storage.Local
    @versions [:original, :thumb]

    def transform(:thumb, _), do: {:convert, "-strip -thumbnail 10x10"}
    def storage_dir(_, _), do: "arctest/uploads"
    def filename(version,  {file, scope}) do
      "#{version}-#{Path.basename(file.file_name)}"
    end
  end

  test "put, delete, get" do
    DummyDefinition.store({Arc.File.new(@img), nil})
    assert true == File.exists?("arctest/uploads/original-image.png")
    assert true == File.exists?("arctest/uploads/thumb-image.png")

    assert "arctest/uploads/original-image.png" == Arc.Storage.Local.url(DummyDefinition, :original, {Arc.File.new(@img), nil})
    assert "arctest/uploads/thumb-image.png" == Arc.Storage.Local.url(DummyDefinition, :thumb, {Arc.File.new(@img), nil})

    Arc.Storage.Local.delete(DummyDefinition, :original, {Arc.File.new(@img), nil})
    Arc.Storage.Local.delete(DummyDefinition, :thumb, {Arc.File.new(@img), nil})
    assert false == File.exists?("arctest/uploads/original-image.png")
  end

  test "save binary" do
    DummyDefinition.store({Arc.File.new("binary", "binary.png"), nil})
    assert true == File.exists?("arctest/uploads/original-binary.png")
    assert true == File.exists?("arctest/uploads/thumb-binary.png")
  end

end
