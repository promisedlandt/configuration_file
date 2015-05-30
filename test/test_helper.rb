require "bundler/setup"

require "minitest/autorun"
require "mocha/setup"

require "configuration_file"

module ExampleApplication
  extend ConfigurationFile
end
