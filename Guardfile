guard :minitest do
  watch(%r{^test/(.*)_test\.rb})
  watch("lib/configuration_file.rb") { "test" }
  watch(%r{^lib/configuration_file/(.*/)?([^/]+)\.rb})     { |m| "test/#{ m[1] }#{ m[2] }_test.rb" }
  watch(%r{^test/helper\.rb})      { "test" }
end
