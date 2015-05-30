# ConfigurationFile

If you have ever wanted to configure your application with a Ruby configuration file, like a Vagrantfile, this is the gem for you.

This is inspired by the old (v1) [Vagrant](https://github.com/mitchellh/vagrant/) configuration.

# A quick note from the editor

This was a quick extracurricular project from a Ruby class I taught, intended as a quick demonstration of how Vagrant gets its configuration from a Ruby file.  
It works fine, but no additional work is planned on it, so you might not want to include it in your projects.

# Example

```ruby
# We need to require this gem after installing it
require "configuration_file"

# This is our example application
module CarBuilder
  extend ConfigurationFile

  # All our plugins need to be classes in the ConfigurationPlugin namespace
  module ConfigurationPlugin
    class Engine
      attr_accessor :hp
      attr_accessor :fueltype
    end

    class Tires
      attr_accessor :material
    end
  end
end


# Assuming this is in a configuration file, say a Carfile
# Call the configure method on our application, pass it a configuration block
CarBuilder.configure do |car|
  car.engine.hp = 100
  car.engine.fueltype = "Diesel"

  car.tires.material = "Rubber"
end

# Let's load the Carfile
CarBuilder.configure_from_file("/path/to/Carfile")

# You can now access the configuration through the config method of your application
CarBuilder.config.engine.hp       #=> 100
CarBuilder.config.engine.fueltype #=> "Diesel"
CarBuilder.config.tires.material  #=> "Rubber"
```


