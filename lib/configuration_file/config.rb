module ConfigurationFile
  # Configuration object.
  # @note You should never need to create an instance of this
  class Config
    # @param [Module] A module your program uses, to find the namespace for the configuration plugins
    def initialize(parent_module)
      @parent_module = parent_module
      @initialized_plugins = {}
    end

    # Evaluate the actual configuration block, whether set directly, or read from a file.
    # Will also finalize this object
    #
    # @param [Proc] Configuration block
    def configure(config_proc)
      config_proc.call(self)
      finalize!
    end

    # Finalize all plugins that can be finalized, by calling their finalize! method
    def finalize!
      @initialized_plugins.each do |_name, plugin|
        plugin.finalize! if plugin.respond_to?(:finalize!)
      end
    end

    # Evaluate the configuration file DSL.
    # Currently only passes stuff through to plugins (which it initializes)
    #
    # The plugins need to be named ModuleName::ConfigurationPlugin::PluginName
    #   ModuleName comes from the parent module this config was initialized with
    #   ConfigurationPlugin is currently hard coded, and may be made configurable at some point in the future
    #   PluginName is the camelized form of whatever is used in the config file, e.g. config.my_plugin.test_attribute = 1 -> MyPlugin
    def method_missing(name, *args)
      return @initialized_plugins[name] if @initialized_plugins[name]

      # expect plugins to be named MyGreatProgram::ConfigurationPlugin::PluginName
      plugin_class_name = [@parent_module, "ConfigurationPlugin", name.to_s.camelize].join("::")

      begin
        @initialized_plugins[name] = plugin_class_name.constantize.new
      rescue NameError
        defer_to_default_configuration_plugin(name, *args)
      end
    end

    # Defer the method call to the default configuration plugin, initializing it if necessary
    #
    # @param [Symbol] name Method name to pass through to default configuration plugins
    # @param [Array] args Arguments to be passed to the method
    def defer_to_default_configuration_plugin(name, *args)
      default_configuration_plugin = @parent_module.configuration_file_default_configuration_plugin

      if default_configuration_plugin
        @initialized_plugins[:__default] = default_configuration_plugin.new unless @initialized_plugins[:__default]
        @initialized_plugins[:__default].send(name, *args)
      else
        fail NameError, "uninitialized method #{ name } on #{ self }"
      end
    end

    # Reads configuration from a configuration file
    #
    # @param [String] path Path to the Honorfile
    # @return [void] No useful return value
    def self.from_file(path)
      if File.exist?(path) && File.readable?(path)
        Kernel.load(path)
      else
        fail IOError, "Cannot open or read #{ path }!"
      end
    end
  end
end
