require "test_helper"

describe ConfigurationFile::Config do
  describe "configuration by proc" do
    before do
      @configuration = ExampleApplication.configure {}
    end

    it "calls the configuration proc" do
      configuration_proc = proc {}
      configuration_proc.expects(:call).with(@configuration)

      assert @configuration.configure(configuration_proc)
    end

    it "starts finalization" do
      @configuration.expects(:finalize!)
      @configuration.configure(proc {})
    end
  end

  describe "configuration evaluation" do
    it "passes through to a configuration plugin" do
      module WithConfigurationPlugin
        extend ConfigurationFile

        module ConfigurationPlugin
          class ThisIsAPlugin
            attr_accessor :test_attribute
          end
        end
      end

      attribute_value = "test"

      WithConfigurationPlugin.configure do |config|
        config.this_is_a_plugin.test_attribute = attribute_value
      end

      assert_equal attribute_value, WithConfigurationPlugin.config.this_is_a_plugin.test_attribute
    end

    it "uses a default configuration plugin if one is specified" do
      module WithDefaultConfigurationPlugin
        class MySpecialPlugin
          attr_accessor :test_attribute
        end

        extend ConfigurationFile
        configuration_file default_configuration_plugin: MySpecialPlugin
      end

      attribute_value = "test"

      WithDefaultConfigurationPlugin.configure do |config|
        config.test_attribute = attribute_value
      end

      assert_equal attribute_value, WithDefaultConfigurationPlugin.config.test_attribute
    end
  end

  describe "configuration from file" do
    it "loads the file in the current environment" do
      configuration_file_path = "test/fixtures/Configurationfile"
      Kernel.expects(:load).with(configuration_file_path).at_least_once
      ConfigurationFile::Config.from_file(configuration_file_path)
    end

    it "throws an error if the file does not exist" do
      assert_raises(IOError) { ConfigurationFile::Config.from_file("/does/not/exist") }
    end
  end
end
