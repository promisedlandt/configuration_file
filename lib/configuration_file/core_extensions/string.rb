class String
  # rubocop:disable all
  # Unabashedly stolen from ActiveSupport
  def camelize
    string = self.dup
    string = string.sub(/^[a-z\d]*/) { $&.capitalize }

    string.gsub(/(?:_|(\/))([a-z\d]*)/) { "#{$1}#{ $2.capitalize }" }.gsub('/', '::')
  end

  # Unabashedly stolen from ActiveSupport
  def constantize
    names = self.split('::')
    names.shift if names.empty? || names.first.empty?

    constant = Object
    names.each do |name|
      constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
    end
    constant
  end
  # rubocop:enable all
end
