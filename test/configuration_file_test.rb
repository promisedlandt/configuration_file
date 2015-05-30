require "test_helper"

describe ConfigurationFile do
  it "does not allow the config to be set" do
    assert_raises(NoMethodError) { ExampleApplication.config = "shouldntwork" }
  end

  describe "configuration by block" do
    before do
      @configuration = ExampleApplication.configure {}
    end

    it "returns the config object" do
      assert_kind_of ConfigurationFile::Config, @configuration
    end

    it "makes config return the config object" do
      assert_kind_of ConfigurationFile::Config, ExampleApplication.config
    end
  end

  describe "configuration from file" do
    it "makes config return the config object" do
      ExampleApplication.configure_from_file("test/fixtures/Configurationfile")
      assert_kind_of ConfigurationFile::Config, ExampleApplication.config
    end

    it "raises an error when file does not exist" do
      assert_raises(IOError) { ExampleApplication.configure_from_file("does/not/exist") }
    end
  end

  describe "configuration of this module" do
    before do
      module ConfigureTest
        extend ConfigurationFile
        configuration_file default_configuration_plugin: "test"
      end
    end

    it "uses configuration_file for configuration" do
      assert_equal "test", ConfigureTest.instance_variable_get(:@configuration_file_default_configuration_plugin)
    end
  end
end
