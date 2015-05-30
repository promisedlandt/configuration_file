# Shipped with Ruby
require "fileutils"

# Internal stuff
require "configuration_file/core_extensions"
require "configuration_file/version"
require "configuration_file/config"

# rubocop:disable HandleExceptions
# Development stuff, can't be loaded in production, but that's fine
%w(debugger).each do |development_gem|
  begin
    require development_gem
  rescue LoadError
  end
end
# rubocop:enable HandleExceptions

module ConfigurationFile
  # Returns either the existing configuration object, or creates a new, empty one
  #
  # @return [ConfigurationFile::Config] The configuration object
  def config
    @config ||= ConfigurationFile::Config.new(self)
  end

  # @!attribute [r] configuration_file_default_configuration_plugin
  #   @return [Class] The class that configuration will be passed to if no configuration plugin is specified
  attr_reader :configuration_file_default_configuration_plugin

  # Configure the installation(s), usually from a Configurationfile
  #
  # @param [Block] block The configuration block
  def configure(&block)
    @config = ConfigurationFile::Config.new(self).tap do |config|
      config.configure(block)
    end
  end

  # Reads configuration from a configuration file
  #
  # @param [String] path Path to the configuration file
  # @return [ConfigurationFile::Config] The configuration object
  def configure_from_file(path)
    ConfigurationFile::Config.from_file(path)
  end

  # Allows configuration of this module
  #
  # @param [Hash] options
  # @options options []
  def configuration_file(options = {})
    @configuration_file_default_configuration_plugin = options[:default_configuration_plugin]
  end
end
